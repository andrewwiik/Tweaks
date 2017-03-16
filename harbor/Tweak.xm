#import <objc/runtime.h>
#import <substrate.h>

#import "UIView+Origin.h"

#import "SBIconListModel.h"
#import "SBDockIconListView.h"
#import "SBIconView.h"
#import "SBIconViewMap.h"
#import "SBIconController.h"
#import "SBIcon.h"
#import "SBScaleIconZoomAnimator.h"
#import "SBWallpaperEffectView.h"
#import "SBUIAnimationZoomUpAppFromHome.h"
#import "SBIconFadeAnimator.h"
#import "SBDockView.h"
#import "SBRootFolderView.h"
#import "SBRootFolderController.h"
#import "SBUIController.h"
#import "SBIconModelPropertyListFileStore.h"
#import "SBIconBadgeView.h"
#import "CDStructures.h"

#import "HBPreferences.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

#pragma mark Declarations

#define UIApp ([UIApplication sharedApplication])

#define cur_orientation ([UIApp statusBarOrientation])
#define in_landscape (UIInterfaceOrientationIsLandscape(cur_orientation) && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)

#define icon_animation_duration ([[prefs getanimationDuration] floatValue])

@interface SBRootFolderView ()

- (void)orientationChanged:(NSNotification*)arg1;

@end

@interface SBUIController ()

@property (nonatomic, retain) UIWindow *iconBounceWindow;
@property (nonatomic, retain) UIWindow *iconBounceWindowContainer;

@end

@interface SBDockIconListView ()

- (CGFloat)horizontalIconBounds;
- (CGFloat)iconPadding;
- (CGFloat)collapsedIconPadding;
- (CGFloat)collapsedIconScale;
- (CGFloat)collapsedIconWidth;
- (CGPoint)collapsedCenterForIcon:(SBIcon*)icon;
- (CGFloat)scaleForOffsetFromFocusPoint:(CGFloat)offset;
- (CGFloat)yTranslationForOffsetFromFocusPoint:(CGFloat)offset;
- (CGFloat)xTranslationForOffsetFromFocusPoint:(CGFloat)offset;
- (CGFloat)iconCenterY;
- (NSUInteger)columnAtX:(CGFloat)x;

- (void)removeAllBounceAnimations;
- (void)updateIconTransforms;
- (void)collapseAnimated:(BOOL)animated;
- (void)updateIndicatorForIconView:(SBIconView*)iconView animated:(BOOL)animated;

@end

@interface SBDockView ()

- (void)layoutBackgroundView;

@end

#pragma mark Constants

static const CGFloat kCancelGestureRange = 10.0;

static const CGFloat kMaxScale = 1.0;

#pragma mark -

%hook SBDockIconListView

static CGFloat focusPoint;
static BOOL trackingTouch;
static BOOL appLaunching;
static SBIconView *activatingIcon;

static CGFloat maxTranslationX;
static CGFloat xTranslationDamper;

static UIView *indicatorView;
static UILabel *indicatorLabel;

+ (NSUInteger)iconColumnsForInterfaceOrientation:(NSInteger)arg1{
	if (![[prefs getenabled] boolValue])
		return %orig(arg1);
	return 100;
}

- (id)initWithModel:(id)arg1 orientation:(NSInteger)arg2 viewMap:(id)arg3 {

	self = %orig(arg1, arg2, arg3);
	if (self) {

		trackingTouch = false;
		appLaunching = false;

		// Set up indicator view
		indicatorView = [[UIView alloc] init];

		indicatorView.clipsToBounds = true;
		indicatorView.layer.cornerRadius = 5;

		// Add background view
		SBWallpaperEffectView *indicatorBackgroundView = [[objc_getClass("SBWallpaperEffectView") alloc] initWithWallpaperVariant:1];
		indicatorBackgroundView.style = 11;
		indicatorBackgroundView.translatesAutoresizingMaskIntoConstraints = false;

		[indicatorView addSubview:indicatorBackgroundView];

		// Set up label
		indicatorLabel = [[UILabel alloc] init];
		indicatorLabel.font = [UIFont systemFontOfSize:14];
		indicatorLabel.textColor = [UIColor whiteColor];
		indicatorLabel.textAlignment = NSTextAlignmentCenter;
		[indicatorView addSubview:indicatorLabel];

		// Setup constraints
		NSMutableArray *constraints = [NSMutableArray new];

		[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[v]-0-|" options:0 metrics:nil views: @{ @"v" : indicatorBackgroundView }]];
		[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[v]-0-|" options:0 metrics:nil views: @{ @"v" : indicatorBackgroundView }]];
		[indicatorView addConstraints:constraints];

		[constraints release];

		// -

		[self addSubview:indicatorView];

	}



	return self;
}

#pragma mark Layout

%new
- (CGFloat)horizontalIconBounds {
	return (in_landscape ? self.bounds.size.height : self.bounds.size.width) - [[prefs geticonInset] floatValue] * 2;
}

%new
- (CGFloat)collapsedIconScale {
	CGFloat normalIconSize = [objc_getClass("SBIconView") defaultVisibleIconImageSize].width;

	CGFloat newIconSize = [self horizontalIconBounds] / self.model.numberOfIcons;

	if (self.model.numberOfIcons == 0) {
		return 1;
	}

	return MIN(newIconSize / (normalIconSize + [self iconPadding]), 1);
}

%new
- (CGFloat)collapsedIconWidth {
	return [self collapsedIconScale] * ([objc_getClass("SBIconView") defaultVisibleIconImageSize].width + [self iconPadding]);
}

%new
- (CGFloat)iconPadding {
	return [objc_getClass("SBIconView") defaultVisibleIconImageSize].width * [[prefs geticonPaddingMultipler] floatValue];
}

%new
- (CGFloat)collapsedIconPadding {
	return [self collapsedIconScale] * [self iconPadding];
}

%new
- (CGFloat)scaleForOffsetFromFocusPoint:(CGFloat)offset {

	if (fabs(offset) > [[prefs geteffectiveRange] doubleValue])
		return [self collapsedIconScale];

	return MAX((cos(offset / (([[prefs geteffectiveRange] doubleValue]) / M_PI)) + 1.0) / (1.0 / ((kMaxScale - [self collapsedIconScale]) / 2.0)) + [self collapsedIconScale], [self collapsedIconScale]);
}

%new
- (CGFloat)xTranslationForOffsetFromFocusPoint:(CGFloat)offset {

	if (xTranslationDamper == 0)
		xTranslationDamper = 1;

	return -(atan(offset / (xTranslationDamper * (M_PI / 4))) * ((maxTranslationX) / (M_PI / 2)));
}

%new
- (CGFloat)yTranslationForOffsetFromFocusPoint:(CGFloat)offset {

	if (fabs(offset) > [[prefs geteffectiveRange] doubleValue])
		return 0;

	return -((cos(offset / (([[prefs geteffectiveRange] doubleValue]) / M_PI)) + 1.0) / (1.0 / ([[prefs getevasionDistance] doubleValue] / 2.0)));
}

- (void)updateEditingStateAnimated:(BOOL)arg1 {

	%orig(arg1);
	if (![[prefs getenabled] boolValue])
		return;
	[self layoutIconsIfNeeded:0.0 domino:false];

}

%new
- (CGFloat)iconCenterY {

	if ([[prefs getflushWithBottom] boolValue]) {
		return (in_landscape ? self.bounds.size.width : self.bounds.size.height) - [self collapsedIconWidth] / 2 - 10.0;
	} else {
		return (in_landscape ? self.bounds.size.width : self.bounds.size.height) / 2;
	}

}

- (void)layoutIconsIfNeeded:(NSTimeInterval)animationDuration domino:(BOOL)arg2 {

	if (![[prefs getenabled] boolValue]) {
		%orig(animationDuration, arg2);
		return;
	}

	CGFloat defaultWidth = [objc_getClass("SBIconView") defaultVisibleIconImageSize].width;

	xTranslationDamper = acos(([[prefs geteffectiveRange] doubleValue] * [self collapsedIconScale]) / ([[prefs geteffectiveRange] doubleValue] / 2) - 1) * ([[prefs geteffectiveRange] doubleValue] / M_PI);
	maxTranslationX = 0;

	// Calculate total X translation

	int iconsInRange = (int)floor([[prefs geteffectiveRange] doubleValue] / [self collapsedIconWidth]);
	float offset = 0;

	for (int i = 0; i < 2; i++) {
		// Run twice, once for left side of focus, and one for right side of focus

		for (int i = 0; i < iconsInRange; i++) {
			maxTranslationX += ([self scaleForOffsetFromFocusPoint:offset] * (defaultWidth + [self iconPadding])) - [self collapsedIconWidth];
			offset += [self collapsedIconWidth];
		}

		offset = [self collapsedIconWidth]; // Set to collapsed icon width, so we skip the center icon on the second run
	}

	[UIView animateWithDuration:animationDuration delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:0 animations:^{

		for (int i = 0; i < self.model.numberOfIcons; i++) {

			SBIcon *icon = self.model.icons[i];
			SBIconView *iconView = [self.viewMap mappedIconViewForIcon:icon];

			[self sendSubviewToBack:iconView];

			iconView.location = [self iconLocation];

			iconView.center = [self collapsedCenterForIcon:icon];
		}

		if (activatingIcon) {
			focusPoint = in_landscape ? activatingIcon.center.y : activatingIcon.center.x;
		}

		[self updateIconTransforms];

		if ([self.superview isKindOfClass:objc_getClass("SBDockView")]) {
			if (![[prefs getuseNormalBackground] boolValue]) {
				[(SBDockView*)self.superview layoutBackgroundView];
			}
		}
	} completion:nil];

	if (activatingIcon) {
		[self bringSubviewToFront:activatingIcon];
	}

}

%new
- (CGPoint)collapsedCenterForIcon:(SBIcon*)icon {
	CGFloat defaultWidth = [objc_getClass("SBIconView") defaultVisibleIconImageSize].width;

	CGFloat xOffset = MAX(([self horizontalIconBounds] - self.model.numberOfIcons * (defaultWidth + [self iconPadding])) / 2, 0);

	CGPoint center = CGPointZero;

	if (!in_landscape) {
		center.x = xOffset + ([self collapsedIconWidth] * [self.model indexForIcon:icon]) + ([self collapsedIconWidth] / 2) + (self.bounds.size.width - [self horizontalIconBounds]) / 2;
		center.y = [self iconCenterY];
	} else {
		center.x = [self iconCenterY];
		center.y = xOffset + ([self collapsedIconWidth] * [self.model indexForIcon:icon]) + ([self collapsedIconWidth] / 2) + (self.bounds.size.height - [self horizontalIconBounds]) / 2;
	}

	return center;
}

%new
- (void)removeAllBounceAnimations {

	for (int i = 0; i < self.model.numberOfIcons; i++) {

		SBIcon *icon = self.model.icons[i];
		SBIconView *iconView = [self.viewMap mappedIconViewForIcon:icon];

		[iconView.layer removeAnimationForKey:@"jumping"];
	}
}

%new
- (void)updateIconTransforms {

	for (int i = 0; i < self.model.numberOfIcons; i++) {
		SBIcon *icon = self.model.icons[i];
		SBIconView *iconView = [self.viewMap mappedIconViewForIcon:icon];

		const CGFloat offsetFromFocusPoint = focusPoint - (in_landscape ? iconView.center.y : iconView.center.x);


		CGFloat scale = [self collapsedIconScale];

		CGFloat tx = 0;
		CGFloat ty = 0;

		if (trackingTouch) {
			scale = [self scaleForOffsetFromFocusPoint:offsetFromFocusPoint];
			ty = [self yTranslationForOffsetFromFocusPoint:offsetFromFocusPoint];
			tx = [self xTranslationForOffsetFromFocusPoint:offsetFromFocusPoint];
		}

		CGPoint center = iconView.center;

		if (!in_landscape) {
			center.x += tx;
			center.y += ty;
		} else {
			center.x += ty;
			center.y += tx;
		}

		iconView.center = center;

		iconView.transform = CGAffineTransformMakeScale(scale, scale);

	}

}

%new
- (void)updateIndicatorForIconView:(SBIconView*)iconView animated:(BOOL)animated {



	if (![[prefs getshowIndicator] boolValue]) {
		indicatorView.hidden = true;
		return;
	}

	if (!iconView) {

		if (animated) {
			[UIView animateWithDuration:0.2 animations:^{
				indicatorView.alpha = 0;
			} completion:^(BOOL finished) {
				indicatorView.hidden = true;
				indicatorView.alpha = 1;
			}];
		}else{
			indicatorView.hidden = true;
		}

		return;
	}else{
		if (animated && indicatorView.hidden) {
			indicatorView.alpha = 0;
			indicatorView.hidden = false;

			[UIView animateWithDuration:0.2 animations:^{
				indicatorView.alpha = 1;
			} completion:nil];
		}else{
			indicatorView.hidden = false;
		}
	}

	void (^animations) (void) = ^{

		NSString *text;

		if ([iconView.icon respondsToSelector:@selector(displayName)]) {
			text = iconView.icon.displayName;
		} else {
			text = [iconView.icon displayNameForLocation:[self iconLocation]];
		}

		CGRect textRect = [text boundingRectWithSize:[objc_getClass("SBIconView") maxLabelSize] options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];

		indicatorView.bounds = CGRectMake(0, 0, textRect.size.width + 30, textRect.size.height + 30);

		if (!in_landscape) {
			indicatorView.center = CGPointMake(MAX(MIN(focusPoint, self.bounds.size.width - indicatorView.bounds.size.width / 2), indicatorView.bounds.size.width / 2), (self.bounds.size.height / 2) - [[prefs getevasionDistance] doubleValue] - indicatorView.bounds.size.height - 20.0);
		} else {
			indicatorView.center = CGPointMake((self.bounds.size.width / 2) - [[prefs getevasionDistance] doubleValue] - indicatorView.bounds.size.width, MAX(MIN(focusPoint, self.bounds.size.height - indicatorView.bounds.size.height / 2), indicatorView.bounds.size.height / 2));
		}

		indicatorLabel.text = text;
		indicatorLabel.bounds = textRect;
		indicatorLabel.center = CGPointMake(indicatorView.bounds.size.width / 2, indicatorView.bounds.size.height / 2);

	};

	if (animated)
		[UIView animateWithDuration:0.1 animations:animations completion:nil];
	else
		animations();


}

#pragma mark Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {



	if (![[prefs getenabled] boolValue]) {
		%orig(touches, event);
		return;
	}

	if (appLaunching)
		return;

	trackingTouch = true;
	focusPoint = in_landscape ? [[touches anyObject] locationInView:self].y : [[touches anyObject] locationInView:self].x;
	activatingIcon = nil;

	[self layoutIconsIfNeeded:icon_animation_duration domino:false];

	// Update indicator
	SBIconView *focusedIcon = nil;

	@try {
		focusedIcon = [self.viewMap mappedIconViewForIcon:self.model.icons[[self columnAtX:focusPoint]]];
	}@catch (NSException *exception) { }

	[self updateIndicatorForIconView:focusedIcon animated:false];


}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	if (![[prefs getenabled] boolValue]) {
		%orig(touches, event);
	}

	if (appLaunching)
		return;

	SBIconView *iconView = nil;

	@try {
		iconView = [self.viewMap mappedIconViewForIcon:self.model.icons[[self columnAtX:focusPoint]]];
	} @catch (NSException *e) { }

	//cancel wave without opening an app by tapping with another finger
	if ([[event allTouches] count] >= 2) {
		[self collapseAnimated:YES];
		trackingTouch = NO;
		return;
	}

	if ([[touches anyObject] respondsToSelector:@selector(force)] && [[touches anyObject] force] >= 2.5) {

		SBIconController *controller = [NSClassFromString(@"SBIconController") sharedInstance];

		if ([controller respondsToSelector:@selector(_revealMenuForIconView:presentImmediately:)]) {

			[controller _revealMenuForIconView:iconView presentImmediately:YES];
		}

		else if ([controller respondsToSelector:@selector(_revealMenuForIconView:)]) {

			//queue the shortcut object
			[controller _revealMenuForIconView:iconView];

			//present it if its successfully been created
			if ([controller valueForKey:@"_presentedShortcutMenu"]) {

				[[controller valueForKey:@"_presentedShortcutMenu"] performSelector:@selector(presentAnimated:) withObject:@(YES)];
			}
		}

		%orig(touches, event);
	}

	if ((in_landscape ? [[touches anyObject] locationInView:self].x : [[touches anyObject] locationInView:self].y) < 0 && (![[objc_getClass("SBIconController") sharedInstance] grabbedIcon] && iconView) && ((![[objc_getClass("SBIconController") sharedInstance] isEditing] && [[prefs getinitiateEditMode] boolValue]) || [[objc_getClass("SBIconController") sharedInstance] isEditing]) ) {
		// get origin, remove transform, restore origin
		CGPoint origin = iconView.origin;
		iconView.transform = CGAffineTransformIdentity;
		iconView.origin = origin;

		// fix frame (somewhere along the way, the size gets set to zero. not exactly sure where)
		CGRect frame = iconView.frame;
		frame.size = [objc_getClass("SBIconView") defaultIconSize];
		iconView.frame = frame;

		// set grabbed and begin forwarding touches to icon
		[[objc_getClass("SBIconController") sharedInstance] setGrabbedIcon:iconView.icon];
		[iconView touchesBegan:touches withEvent:nil];
		[[iconView delegate] iconHandleLongPress:iconView withFeedbackBehavior:nil];

		[[objc_getClass("SBIconController") sharedInstance] setIsEditing:true];

		[self updateIndicatorForIconView:nil animated:true];

		return;
	}

	if ([[objc_getClass("SBIconController") sharedInstance] grabbedIcon]) {
		SBIconView *iconView = [self.viewMap mappedIconViewForIcon:[[objc_getClass("SBIconController") sharedInstance] grabbedIcon]];
		[iconView touchesMoved:touches withEvent:nil];
		return;
	}

	focusPoint = in_landscape ? [[touches anyObject] locationInView:self].y : [[touches anyObject] locationInView:self].x;
	[self layoutIconsIfNeeded:0 domino:false];

	// Update indicator
	SBIconView *focusedIcon = nil;

	@try {
		focusedIcon = [self.viewMap mappedIconViewForIcon:self.model.icons[[self columnAtX:focusPoint]]];
	}@catch (NSException *exception) { }

	[self updateIndicatorForIconView:focusedIcon animated:true];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {



	if (![[prefs getenabled] boolValue]) {
		%orig(touches, event);
		return;
	}

	if (appLaunching)
		return;

	if ([[objc_getClass("SBIconController") sharedInstance] grabbedIcon]) {
		SBIconView *iconView = [self.viewMap mappedIconViewForIcon:[[objc_getClass("SBIconController") sharedInstance] grabbedIcon]];
		[iconView touchesEnded:touches withEvent:nil];
		return;
	}

	[self updateIndicatorForIconView:nil animated:true];


	if (in_landscape ?
		 ( [[touches anyObject] locationInView:self].x > self.bounds.size.width - kCancelGestureRange) :
		 ( [[touches anyObject] locationInView:self].y > self.bounds.size.height - kCancelGestureRange)) {
		// User swiped off to the bottom edge of the screen; collapse and do nothing
		[self collapseAnimated:true];
		return;
	}

	if (!trackingTouch)
		return;

	NSInteger index = [self columnAtX:focusPoint];

	SBIconView *iconView = nil;

	@try {
		iconView = [self.viewMap mappedIconViewForIcon:self.model.icons[index]];
	}@catch (NSException *e) {
		[self collapseAnimated:true];
		return;
	}

	[self bringSubviewToFront:iconView];

	activatingIcon = iconView;

	[self layoutIconsIfNeeded:icon_animation_duration domino:false];

	[[objc_getClass("SBIconController") sharedInstance] iconTapped:iconView];


}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {



	if (![[prefs getenabled] boolValue]) {
		%orig(touches, event);
		return;
	}

	if (appLaunching)
		return;

	trackingTouch = false;
	[self layoutIconsIfNeeded:0 domino:false];

	[self updateIndicatorForIconView:nil animated:true];


}

#pragma mark -

%new
- (void)collapseAnimated:(BOOL)animated {



	trackingTouch = false;
	activatingIcon = nil;
	[self layoutIconsIfNeeded:animated ? icon_animation_duration : 0.0 domino:false];


}

%new
- (NSUInteger)columnAtX:(CGFloat)x {
	return in_landscape ? [self rowAtPoint:CGPointMake(0, x)] : [self columnAtPoint:CGPointMake(x, 0)];
}


- (NSUInteger)columnAtPoint:(struct CGPoint)arg1 {

	if (![[prefs getenabled] boolValue])
		return %orig(arg1);

	if (in_landscape) {
		return 0;
	}

	CGFloat collapsedItemWidth = [self collapsedIconWidth];
	CGFloat xOffset = MAX(([self horizontalIconBounds] - self.model.numberOfIcons * ([objc_getClass("SBIconView") defaultVisibleIconImageSize].width + [self iconPadding])) / 2, 0);

	NSInteger index = floorf((arg1.x - (self.bounds.size.width - [self horizontalIconBounds]) / 2 - xOffset) / collapsedItemWidth);

	if (index < 0)
		index = NSNotFound;

	return (NSUInteger)index;
}

- (NSUInteger)rowAtPoint:(struct CGPoint)arg1 {
	if (![[prefs getenabled] boolValue])
		return %orig(arg1);

	if (!in_landscape) {
		return 0;
	}

	CGFloat collapsedItemWidth = [self collapsedIconWidth];
	CGFloat xOffset = MAX(([self horizontalIconBounds] - self.model.numberOfIcons * ([objc_getClass("SBIconView") defaultVisibleIconImageSize].width + [self iconPadding])) / 2, 0);

	NSInteger index = floorf((arg1.y - (self.bounds.size.height - [self horizontalIconBounds]) / 2 - xOffset) / collapsedItemWidth);

	if (index < 0)
		index = NSNotFound;

	return (NSUInteger)index;
}

- (void)removeIconAtIndex:(NSUInteger)arg1 {



	%orig(arg1);

	if (![[prefs getenabled] boolValue])
		return;

	[self collapseAnimated:true];


}

%end

#pragma mark Animators

%hook SBIconFadeAnimator

- (void)_cleanupAnimation {



	%orig();
	if (![[prefs getenabled] boolValue])
		return;
	[[[objc_getClass("SBIconController") sharedInstance] dockListView] collapseAnimated:true];


}

%end

%hook SBIconAnimator

- (void)prepare {


	if (![[prefs getenabled] boolValue]) {
		%orig();
		return;
	}

	appLaunching = true;
	%orig();

}

- (void)cleanup {


	if (![[prefs getenabled] boolValue]) {
		%orig();
		return;
	}

	appLaunching = false;
	%orig();

}

%end

%hook SBScaleIconZoomAnimator

- (void)enumerateIconsAndIconViewsWithHandler:(void (^) (id animator, SBIconView *iconView, BOOL inDock))arg1 {



	if (![[prefs getenabled] boolValue]) {
		%orig(arg1);
		return;
	}

	// Prevent this method from changing the origins and transforms of the dock icons

	NSMapTable *mapHolder = MSHookIvar<NSMapTable*>(self, "_dockIconToViewMap");
	MSHookIvar<NSMapTable*>(self, "_dockIconToViewMap") = nil;

	%orig(arg1);

	MSHookIvar<NSMapTable*>(self, "_dockIconToViewMap") = mapHolder;


}

- (void)_prepareAnimation {


	if (![[prefs getenabled] boolValue]) {
		%orig();
		return;
	}

	// Remove jump animation if in progress

	SBDockIconListView *dockListView = [[objc_getClass("SBIconController") sharedInstance] dockListView];

	[dockListView removeAllBounceAnimations];

	// Focus dock on animation target icon

	SBIconView *targetIconView = [dockListView.viewMap mappedIconViewForIcon:self.targetIcon];

	if ([targetIconView isInDock]) {
		activatingIcon = targetIconView;
		trackingTouch = true;
		[dockListView layoutIconsIfNeeded:0.0 domino:false];
	}

	%orig();


}

- (void)_cleanupAnimation {


	%orig();
	if (![[prefs getenabled] boolValue])
		return;
	[self.dockListView collapseAnimated:true];


}

%end

%hook SBDockView

- (void)layoutSubviews {
	%orig();
	if (![[prefs getenabled] boolValue])
		return;
	if (![[prefs getuseNormalBackground] boolValue]) {

		MSHookIvar<UIView*>(self, "_highlightView").hidden = true;
		[self layoutBackgroundView];
	}

	// Layout iconBounceWindow
	UIWindow *bounceWindow = [(SBUIController*)[objc_getClass("SBUIController") sharedInstance] iconBounceWindow];
	UIWindow *bounceWindowContainer = [(SBUIController*)[objc_getClass("SBUIController") sharedInstance] iconBounceWindowContainer];

	CGFloat rotation;

	switch(cur_orientation) {
		case UIInterfaceOrientationPortrait:
			rotation = 0;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			rotation = DEGREES_TO_RADIANS(180);
			break;
		case UIInterfaceOrientationLandscapeLeft:
			rotation = DEGREES_TO_RADIANS(270);
			break;
		case UIInterfaceOrientationLandscapeRight:
			rotation = DEGREES_TO_RADIANS(90);
			break;
	}

	bounceWindowContainer.transform = CGAffineTransformMakeRotation(rotation);
	bounceWindowContainer.frame = [[UIScreen mainScreen] bounds];

	SBDockIconListView *dockListView = [[objc_getClass("SBIconController") sharedInstance] dockListView];

	CGRect frame = self.frame;

	if (in_landscape) {
		frame.origin.x += (self.bounds.size.width - [dockListView iconCenterY]) + ([dockListView collapsedIconWidth] / 2) + ([objc_getClass("SBIconBadgeView") _overhang].x * [dockListView collapsedIconScale]);
	} else {
		frame.origin.y += (self.bounds.size.height - [dockListView iconCenterY]) + ([dockListView collapsedIconWidth] / 2) + ([objc_getClass("SBIconBadgeView") _overhang].y * [dockListView collapsedIconScale]);
	}

	[bounceWindow setFrame:frame];
}

%new
- (void)layoutBackgroundView {

	SBDockIconListView *_iconListView = MSHookIvar<SBDockIconListView*>(self, "_iconListView");

	UIView *firstIcon = [_iconListView.viewMap mappedIconViewForIcon:[_iconListView.model.icons firstObject]];
	UIView *lastIcon = [_iconListView.viewMap mappedIconViewForIcon:[_iconListView.model.icons lastObject]];

	if ([[_iconListView.model.icons lastObject] isKindOfClass:objc_getClass("SBPlaceholderIcon")]) {
		lastIcon = [_iconListView.viewMap mappedIconViewForIcon:_iconListView.model.icons[([_iconListView.model.icons count]) - 1]];
	}

	CGFloat backgroundMargin = 25.0;

	CGRect frame = CGRectZero;

	if (!in_landscape) {

		frame.size.width = (CGRectGetMaxX(lastIcon.frame) - CGRectGetMinX(firstIcon.frame)) + backgroundMargin;
		frame.size.height = [_iconListView collapsedIconWidth] + backgroundMargin;
		frame.origin.x = CGRectGetMinX(firstIcon.frame) - backgroundMargin / 2;
		frame.origin.y = ([_iconListView iconCenterY]) - (backgroundMargin / 2) - ([_iconListView collapsedIconWidth] / 2);

	} else {

		frame.size.width = [_iconListView collapsedIconWidth] + backgroundMargin;
		frame.size.height = (CGRectGetMaxY(lastIcon.frame) - CGRectGetMinY(firstIcon.frame)) + backgroundMargin;
		frame.origin.x = ([_iconListView iconCenterY]) - (backgroundMargin / 2) - ([_iconListView collapsedIconWidth] / 2);
		frame.origin.y = CGRectGetMinY(firstIcon.frame) - backgroundMargin / 2;

	}

	MSHookIvar<UIView*>(self, "_backgroundView").layer.cornerRadius = 5.0;
	MSHookIvar<UIView*>(self, "_backgroundView").frame = frame;

}

%end

%hook SBRootFolderView

- (id)initWithFolder:(id)arg1 orientation:(UIInterfaceOrientation)arg2 viewMap:(id)arg3 forSnapshot:(BOOL)arg4 {
	self = %orig(arg1, arg2, arg3, arg4);
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
	}
	return self;
}

%new
- (void)orientationChanged:(NSNotification*)arg1 {
	for (UIView *view in [[[objc_getClass("SBIconController") sharedInstance] _rootFolderController] iconListViews]) {
		view.alpha = 1;
	}

	if (![[prefs getuseNormalBackground] boolValue]) {
		CGPoint contentOffset = [self.scrollView contentOffset];

		if ([self respondsToSelector:@selector(iconScrollView:willSetContentOffset:)]) {
			[self iconScrollView:self.scrollView willSetContentOffset:&contentOffset];
		}
	}
}

- (void)iconScrollView:(UIScrollView*)arg1 willSetContentOffset:(struct CGPoint *)arg2 {

	%orig(arg1, arg2);

	if (![[prefs getenabled] boolValue])
		return;

	if (![[prefs getuseNormalBackground] boolValue]) {
		if (in_landscape) {
			int page = floor(arg2->x / arg1.frame.size.width);

			CGFloat opacity = (arg2->x / arg1.frame.size.width) - (CGFloat)page;

			UIView *nextPage = [[[objc_getClass("SBIconController") sharedInstance] _rootFolderController] iconListViewAtIndex:page + 1];

			nextPage.alpha = opacity;
		}
	}
}


%end

%hook SBRootFolderController

- (BOOL)_shouldSlideDockOutDuringRotationFromOrientation:(UIInterfaceOrientation)arg1 toOrientation:(UIInterfaceOrientation)arg2 {

	if (![[prefs getenabled] boolValue])
		return %orig(arg1, arg2);

	return true; // Hides animation glitch. TODO: Make a proper fix for the glitch
}

%end

%hook SBIconModelPropertyListFileStore

/*
Use different icon state plist so that SpringBoard doesn't mess up the dock
when we are in safe mode
*/

#define harborPlistStore "file:///var/mobile/Library/SpringBoard/IconState_harbor.plist"

- (BOOL)_save:(id)arg1 url:(id)arg2 error:(id *)arg3 {

	if ([[prefs getenabled] boolValue])
		%orig(arg1, [NSURL URLWithString:@harborPlistStore], arg3);

	return %orig(arg1, arg2, arg3);
}

- (id)_load:(NSURL*)path error:(id *)arg2 {
	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/SpringBoard/IconState_harbor.plist"] && [[prefs getenabled] boolValue]) {
		return %orig([NSURL URLWithString:@harborPlistStore], arg2);
	}

	return %orig(path, arg2);
}

%end

@interface SBUIIconForceTouchController : NSObject
@end

%hook SBIconController

- (void)applicationShortcutMenuDidDismiss:(id)arg1 {

	%orig(arg1);

	SBDockIconListView *dockListView = [[objc_getClass("SBIconController") sharedInstance] dockListView];
	[dockListView collapseAnimated:YES];
}

// %new
// - (void)_revealMenuForIconView:(SBIconView *)iconView presentImmediately:(BOOL)arg2 {
// 	if ([iconView appIconForceTouchGestureRecognizer]) {
// 		UIGestureRecognizer *forceGesture = [iconView appIconForceTouchGestureRecognizer];
// 		NSMutableArray *targets = [forceGesture valueForKeyPath:@"_targets"];
// 		for (id targetContainer in targets) {
// 			if ([(NSObject *)targetContainer valueForKeyPath:@"_target"]) {
// 				id target = [(NSObject *)targetContainer valueForKeyPath:@"_target"];
// 				if (target) {
// 					if ([(NSObject *)target isKindOfClass:NSClassFromString(@"SBUIIconForceTouchController")]) {
// 						NSLog(@"GO TO THE TARGET STEP");
// 						SBUIIconForceTouchController *forceController = [targetContainer valueForKeyPath:@"_target"];
// 						[forceController _setupWithGestureRecognizer:forceGesture];
// 						[forceController _presentAnimated:YES withCompletionHandler:nil];
// 					}
// 				}
// 			}
// 		}
// 	}
// }

// %new
// - (void)_revealMenuForIconView:(SBIconView *)iconView {
// 	if ([iconView appIconForceTouchGestureRecognizer]) {
// 		UIGestureRecognizer *forceGesture = [iconView appIconForceTouchGestureRecognizer];
// 		NSMutableArray *targets = [forceGesture valueForKeyPath:@"_targets"];
// 		for (id targetContainer in targets) {
// 			if ([(NSObject *)targetContainer valueForKeyPath:@"_target"]) {
// 				id target = [(NSObject *)targetContainer valueForKeyPath:@"_target"];
// 				if (target) {
// 					if ([(NSObject *)target isKindOfClass:NSClassFromString(@"SBUIIconForceTouchController")]) {
// 						NSLog(@"GO TO THE TARGET STEP");
// 						SBUIIconForceTouchController *forceController = [targetContainer valueForKeyPath:@"_target"];
// 						[forceController _setupWithGestureRecognizer:forceGesture];
// 						[forceController _presentAnimated:YES withCompletionHandler:nil];
// 					}
// 				}
// 			}
// 		}
// 	}
// }

%end
