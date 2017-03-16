#include <MediaPlayer/MediaPlayer.h>
#include <CoreGraphics/CoreGraphics.h>
#import "headers.h"
// #import "CCXMainControlsPageViewController.h"
#import "CCXNavigationViewController.h"
//#import "CCXSettingsPageViewController.h"
#import <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/_UIBackdropView.h>

static BOOL shouldPop = NO;
static BOOL isCCXPage = NO;


@interface HUHomeControlCenterViewController : UIViewController
-(id)initWithNibName:(id)arg1 bundle:(id)arg2;
@end

static BOOL fakeIdiom = NO;

void enableFakeIdiom() {
	fakeIdiom = YES;
}
void disableFakeIdiom() {
	fakeIdiom = NO;
}
@implementation UIView (RemoveConstraints)
- (void)removeAllConstraints
{
    UIView *superview = self.superview;
    while (superview != nil) {
        for (NSLayoutConstraint *c in superview.constraints) {
            if (c.firstItem == self || c.secondItem == self) {
                [superview removeConstraint:c];
            }
        }
        superview = superview.superview;
    }

    [self removeConstraints:self.constraints];
    self.translatesAutoresizingMaskIntoConstraints = YES;
}
@end

@implementation CCTXTestView
- (CGSize)intrinsicContentSize {
	return CGSizeMake(400, 74);
}
@end

@implementation CCXTestViewController 
- (CGSize)intrinsicContentSize {
	return CGSizeMake(400, 74);
}
- (void)loadView {
	[super loadView];
	self.view = [[CCTXTestView alloc] initWithFrame:CGRectMake(0,0,400,74)];
	// MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
	// 	NSLog(@"%@", information);
	// });

}
@end

@interface NCAnimatableBlurringView (CCX)
@property (nonatomic, assign) BOOL hasConfiguredBlurFilter;
@property (nonatomic, retain) _UIBackdropViewSettings *fullBlurSettings;
@property (nonatomic, retain) _UIBackdropViewSettings *noBlurSettings;
@property (nonatomic, retain) _UIBackdropView *backgroundBlurView;
@property (nonatomic, retain) NSNumber *backgroundBlurProgress;
- (void)setInputProgress:(CGFloat)radius;
@end

@interface _UIBackdropView (CCX)
@property (nonatomic,copy) NSString *groupName; 
@property (nonatomic, retain) UIView *contentView;
- (id)initWithStyle:(int)arg1;
- (id)initWithSettings:(_UIBackdropViewSettings *)arg1;
- (void)transitionIncrementallyToPrivateStyle:(int)arg1 weighting:(CGFloat)arg2;
- (void)transitionIncrementallyToStyle:(int)arg1 weighting:(CGFloat)arg2;
- (void)transitionIncrementallyToSettings:(_UIBackdropViewSettings *)arg1 weighting:(CGFloat)arg2;
- (void)setAppliesOutputSettingsAnimationDuration:(CGFloat)duation;
- (void)transitionToSettings:(id)arg1;	
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
- (id)initWithPrivateStyle:(int)arg1;
- (void)setBlurFilterWithRadius:(float)arg1 blurQuality:(id)arg2 blurHardEdges:(int)arg3;
- (void)setBlurFilterWithRadius:(float)arg1 blurQuality:(id)arg2;
- (void)setBlurHardEdges:(int)arg1;
- (void)setInputSettings:(id)arg1;
- (void)setBlurQuality:(id)arg1;
- (void)setBlurRadius:(float)arg1;
- (void)setBlurRadiusSetOnce:(BOOL)arg1;
- (void)setBlursBackground:(BOOL)arg1;
- (void)setBlursWithHardEdges:(BOOL)arg1;
@end

%hook NCAnimatableBlurringView
%property (nonatomic, assign) BOOL hasConfiguredBlurFilter;
%property (nonatomic, retain) _UIBackdropViewSettings *fullBlurSettings;
%property (nonatomic, retain) _UIBackdropViewSettings *noBlurSettings;
%property (nonatomic, retain) _UIBackdropView *backgroundBlurView;
%property (nonatomic, retain) NSNumber *backgroundBlurProgress;

%new
- (void)setInputProgress:(CGFloat)radius {
	if (!self.hasConfiguredBlurFilter) {
		[self _configureBlurFilterIfNecessary];
	}

	// [self.backgroundBlurView transitionIncrementallyToSettings:self.fullBlurSettings weighting:radius];
	if (radius != [self.backgroundBlurProgress floatValue] && self.hasConfiguredBlurFilter) {
		if (self.backgroundBlurView && self.fullBlurSettings) {
			[self.backgroundBlurView transitionIncrementallyToSettings:self.fullBlurSettings weighting:radius];
		}
	}
	self.backgroundBlurProgress = [NSNumber numberWithFloat:radius];
	//%orig;
}


- (void)_configureBlurFilterIfNecessary {
	if (!self.hasConfiguredBlurFilter) {
		self.fullBlurSettings= [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:2020];
        self.fullBlurSettings.blurRadius = 20.0;
        self.fullBlurSettings.grayscaleTintAlpha = 0.05;
        self.fullBlurSettings.colorTint = [UIColor whiteColor];
        self.fullBlurSettings.colorTintAlpha = 0.25;

        self.noBlurSettings = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:-2];
        // self.noBlurSettings.blurRadius = 0;
        // self.noBlurSettings.grayscaleTintAlpha = 0.05;
        // self.noBlurSettings.colorTint = [UIColor blackColor];
        // self.noBlurSettings.colorTintAlpha = 0.07;
// 
        self.backgroundBlurView = [[NSClassFromString(@"_UIBackdropView") alloc] initWithSettings:self.noBlurSettings];
        [self.backgroundBlurView setAppliesOutputSettingsAnimationDuration:0];

        self.backgroundBlurView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.backgroundBlurView];

		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

  //       self.settingsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  //       self.settingsLabel.text = @"Configure";
  //       self.settingsLabel.font = [UIFont fontWithName:@".SFUIText" size:13];
  //       self.settingsLabel.textColor = [UIColor whiteColor];
  //       [self addSubview:self.settingsLabel];
  //       [self.settingsLabel sizeToFit];
  //       self.settingsLabel.translatesAutoresizingMaskIntoConstraints = NO;


  //       [self addConstraint:[NSLayoutConstraint constraintWithItem:self.settingsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
  //       [self addConstraint:[NSLayoutConstraint constraintWithItem:self.settingsLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-45]];
  //       // [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
  //       // [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
		// // CAFilter *blurFilter = [NSClassFromString(@"CAFilter") filterWithType:@"gaussianBlur"];
		// // [blurFilter setValue:[NSNumber numberWithFloat:0.0] forKey:@"inputRadius"];
		// // [self.layer setFilters:[NSArray arrayWithObjects:blurFilter,nil]];
		self.hasConfiguredBlurFilter = YES;
		//[self sendSubviewToFront:self.settingsLabel];
	}
	//%orig;
}
%end

%hook CCUIControlCenterViewController
- (void)_loadPages {
	// %orig;
	//CCXMainControlsPageViewController *extraPageController = [[NSClassFromString(@"CCXMainControlsPageViewController") alloc] init];
	CCXNavigationViewController *mainController = [[NSClassFromString(@"CCXNavigationViewController") alloc] init];
	HUHomeControlCenterViewController *homePageController = [[NSClassFromString(@"HUHomeControlCenterViewController") alloc] initWithNibName:nil bundle:nil];
	//CCXSettingsPageViewController *settingsPageController = [[NSClassFromString(@"CCXSettingsPageViewController") alloc] init];
	//[self _addContentViewController:extraPageController];
	//[self _addContentViewController:settingsPageController];
	[self _addContentViewController:mainController];
	[self _addContentViewController:homePageController];
	//[self setValue:extraPageController forKey:@"_systemControlsPage"];
	return;
}

-(void)setTransitioning:(BOOL)arg1 {
	%orig;
	if (arg1) {
		NSLog(@"I AM GOING TO TRANSITION");
	} else {
		NSLog(@"I AIN'T GONNA TRANSITION");
	}
}

-(void)controlCenterDidFinishTransition {
	%orig;
	NSLog(@"WE DID IT WOOH");
}

// -(CGFloat)_scrollviewContentMaxHeight {
// 	return %orig+36;
// }
%end

@interface CCUIControlCenterContainerView : UIView
@property (nonatomic, retain) NCAnimatableBlurringView *blurringView;
@property (nonatomic, retain) UILabel *settingsLabel;
@property (nonatomic, retain) NSLayoutConstraint *bottomConstraintLabel;
@property (assign,nonatomic) CGFloat revealPercentage;
@property (nonatomic, retain) CCUIControlCenterViewController *delegate; 
@end

%hook CCUIControlCenterContainerView
%property (nonatomic, retain) NCAnimatableBlurringView *blurringView;
%property (nonatomic, retain) UILabel *settingsLabel;
%property (nonatomic, retain) NSLayoutConstraint *bottomConstraintLabel;
- (void)setRevealPercentage:(CGFloat)percentage {
	// %orig;

	if (percentage > 1.3) {
		shouldPop = YES;
	} else {
		shouldPop = NO;
	}
	isCCXPage = NO;
	if (self.delegate) {
		if ([self.delegate _selectedContentViewController]) {
			if ([(NSObject *)[self.delegate _selectedContentViewController] isKindOfClass:NSClassFromString(@"CCXNavigationViewController")]) {
				isCCXPage = YES;
			}
		}
	}

	if (!self.blurringView) {
		self.blurringView = [[NSClassFromString(@"NCAnimatableBlurringView") alloc] initWithFrame:CGRectZero];
		[self insertSubview:self.blurringView atIndex:1];
		self.blurringView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.blurringView
			                                             attribute:NSLayoutAttributeTop
			                                             relatedBy:NSLayoutRelationEqual
			                                                toItem:self
			                                             attribute:NSLayoutAttributeTop
			                                             multiplier:1
			                                               constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.blurringView
			                                             attribute:NSLayoutAttributeBottom
			                                             relatedBy:NSLayoutRelationEqual
			                                                toItem:self
			                                             attribute:NSLayoutAttributeBottom
			                                             multiplier:1
			                                               constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.blurringView
			                                             attribute:NSLayoutAttributeLeft
			                                             relatedBy:NSLayoutRelationEqual
			                                                toItem:self
			                                             attribute:NSLayoutAttributeLeft
			                                             multiplier:1
			                                               constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.blurringView
			                                             attribute:NSLayoutAttributeRight
			                                             relatedBy:NSLayoutRelationEqual
			                                                toItem:self
			                                             attribute:NSLayoutAttributeRight
			                                             multiplier:1
			                                               constant:0]];

		self.settingsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.settingsLabel.text = @"Configure";
        self.settingsLabel.font = [UIFont fontWithName:@".SFUIText" size:15];
        self.settingsLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.settingsLabel];
        [self.settingsLabel sizeToFit];
        self.settingsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.settingsLabel.alpha= 0;


        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.settingsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        self.bottomConstraintLabel = [NSLayoutConstraint constraintWithItem:self.settingsLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-45];
        [self addConstraint:self.bottomConstraintLabel];
		[self sendSubviewToBack:self.blurringView];
	}

	if (self.blurringView && isCCXPage) {
		if (percentage > 1) {
			[self.blurringView setInputProgress:(percentage - 1)*1.5];
			 self.settingsLabel.alpha = (percentage - 1)*(2*percentage);
			 self.bottomConstraintLabel.constant = -18*(percentage + (((percentage - 1)*3))*percentage);
			 self.settingsLabel.transform = CGAffineTransformMakeScale(percentage*0.8, percentage*0.8);
			 if (percentage > self.revealPercentage) {
				 %orig(percentage - (percentage - 1)*0.5);
				 return;
			}
			 // [self.settingsLabel setNeedsLayout];
			 // [self setNeedsLayout];

		} else {
			self.settingsLabel.alpha = (percentage - 1)*(2*percentage);
			 self.bottomConstraintLabel.constant = -18*(percentage + (((percentage - 1)*3))*percentage);
			 self.settingsLabel.transform = CGAffineTransformMakeScale(percentage*0.8, percentage*0.8);
			//self.blurringView.inputRadius = 0;
		}
		// if (percentage > 1.15) {
			//self.settingsLabel.alpha = (percentage - 1)*3;
		// }
	}
	%orig;
}
%end

%hook SBControlCenterController
-(void)_showControlCenterGestureEndedWithGestureRecognizer:(id)arg1 {
	%orig;
	NSLog(@"Gesture Ended: %@", arg1);
}
-(void)_endTransitionWithVelocity:(CGPoint)arg1 completion:(/*^block*/id)arg2 {
	
	%orig;
	if (isCCXPage && shouldPop) {

		[[NSNotificationCenter defaultCenter] postNotificationName:@"com.horseshoe.activatesettings" object:nil];
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.horseshoe.activatesettings"), nil, nil, true);
	}


	// if ([self valueForKey:@"_viewController"] && shouldPop) {
	// 	if ([(NSObject *)[(CCUIControlCenterViewController *)[self valueForKey:@"_viewController"] _selectedContentViewController] isKindOfClass:NSClassFromString(@"CCXNavigationViewController")]) {
	// 		if (![((CCXNavigationViewController *)[(CCUIControlCenterViewController *)[self valueForKey:@"_viewController"] _selectedContentViewController]).navigationController.visibleViewController isKindOfClass:NSClassFromString(@"CCXSettingsPageViewController")])
	// 			[(CCXNavigationViewController *)[(CCUIControlCenterViewController *)[self valueForKey:@"_viewController"] _selectedContentViewController] showSettings];
	// 	}
	// }
	NSLog(@"TRANSITION ENDED WITH VELOCITY");
}
%end

%hook CCUISystemControlsPageViewController
%new
- (BOOL)wantsVisible {
	return NO;
}
%end

%hook MPUControlCenterMediaControlsViewController
%new
- (BOOL)wantsVisible {
	return YES;
}
%end

%hook CCUIButtonStackPagingView
%new
-(CGSize)intrinsicContentSize {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if ([[self delegate] isKindOfClass:NSClassFromString(@"CCUISettingsSectionController")]) {
			return CGSizeMake(-1, 44);
		} else {
			return CGSizeMake(-1,60);
		}
	}
	if ([[self delegate] isKindOfClass:NSClassFromString(@"CCUISettingsSectionController")]) {
		return CGSizeMake(49, -1);
	} else {
		return CGSizeMake(60,-1);
	}
}
// - (CGFloat)
%end

%hook CCUIControlCenterButton
- (void)_updateNaturalHeight {
	enableFakeIdiom();
	%orig;
	disableFakeIdiom();
}
%end

%hook MPUNowPlayingArtworkView
- (id)init {
	enableFakeIdiom();
	id orig = %orig;
	disableFakeIdiom();
	return orig;
}
%end

@interface UITableViewCellReorderControl : UIView
@end

// %hook UITableViewCellReorderControl
// - (void)_updateImageView {
// 	%orig;
// 	for (UIImageView *imageView in [self subviews]) {
// 		imageView.image = [imageView.image  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
// 	}
// }
// %end

%hook NSBundle
+ (id)bundleForClass:(Class)value {
	if ([value isEqual:NSClassFromString(@"CCXAirAndNightSectionController")]) {
		return %orig(NSClassFromString(@"CCUIAirStuffSectionController"));
	} else if ([value isEqual:NSClassFromString(@"CCXTriButtonLikeSectionSplitView")]) {
		return %orig(NSClassFromString(@"CCUIButtonLikeSectionSplitView"));
	} else return %orig;
}
%end

%hook UIDevice
- (NSInteger)userInterfaceIdiom {
	if (fakeIdiom) {
		return 0;
	} else return %orig;
}
// %new
// - (NSMutableArray *)testSpecifciers {
// 	PSListController *controller = [NSClassFromString(@"PSListController") new];
// 	// @"/Library/PreferenceBundles/FlipswitchSettings.bundle/"
// 	NSMutableArray *specifiers = [NSClassFromString(@"PSSpecifierDataSource") loadSpecifiersFromPlist:@"/Library/PreferenceLoader/Preferences/FlipControlCenter.plist" inBundle:[NSBundle bundleWithPath:@"/Library/PreferenceBundles/FlipswitchSettings.bundle/"] target:nil stringsTable:nil];
// 	return specifiers;
// }

%new
- (id)weatherDataTest {
	WeatherPreferences *preferences = [NSClassFromString(@"WeatherPreferences") sharedPreferences];
	WATodayAutoupdatingLocationModel *todayModel = [NSClassFromString(@"WATodayModel") autoupdatingLocationModelWithPreferences:preferences effectiveBundleIdentifier:@"com.apple.springboard"];
	NSInteger conditionCode = todayModel.forecastModel.currentConditions.conditionCode;
	UIImage *conditionImage = [NSClassFromString(@"WeatherImageLoader") conditionImageWithConditionIndex:conditionCode];
	return conditionImage;
}
%end


@interface UIView (CCXPrivate)
@end

// %hook UIView
// - (BOOL)_shouldAnimatePropertyWithKey:(NSString *)key {

// 	if ([self respondsToSelector:@selector(delegate)]) {
//    		return ([self shouldForwardSelector:NSSelectorFromString(key)] || %orig);
//    	}
//    	return %orig;
// }
// %new
// - (BOOL)shouldForwardSelector:(SEL)aSelector {
// 	if ([self respondsToSelector:@selector(delegate)]) {
// 		return (![[self superclass] instancesRespondToSelector:aSelector] &&
// 		    [self.delegate respondsToSelector:aSelector]);
// 	}
// 	return NO;
// }
// - (id)forwardingTargetForSelector:(SEL)aSelector {

// 	if ([self respondsToSelector:@selector(delegate)]) {
//     	return (![self respondsToSelector:aSelector] && [self shouldForwardSelector:aSelector]) ? self.delegate : self;
//     }
//     return %orig;
// }
// %end

// NCAnimatableBlurringView

%ctor {
	//dlopen("/Library/MobileSubstrate/DynamicLibraries/Noctis.dylib", RTLD_NOW);
	%init;
}
