/*
//
// Curago (now iOS Blocks)
//
// This is a widget system blah blah blah. Build, install and you'll see.
//
// (c) Matt Clarke, 2014.
//
// curago.xm - 25/5/2014
//
*/

// Sorry about the headers here, I'll need to have these all included within the project directory 
#import <SpringBoard7.0/SBIconController.h>
#import <SpringBoard7.0/SBFolder.h>
#import <SpringBoard7.0/SBRootFolder.h>
#import <SpringBoard7.0/SBIconListModel.h>
#import <SpringBoard7.0/SBIconModel.h>
#import <SpringBoard7.0/SBIconListView.h>
#import <SpringBoard7.0/SBIconImageView.h>
#import <SpringBoard7.0/SBIconView.h>
#import <SpringBoard7.0/SBApplicationIcon.h>
#import <SpringBoard7.0/SBFolderIcon.h>
#import <SpringBoard7.0/SBIconIndexMutableList.h>
#import <SpringBoard7.0/SBIconViewMap.h>
#import <SpringBoard7.0/SBIconScrollView.h>
#import <SpringBoard7.0/SBIconBadgeView.h>
#import <SpringBoard7.0/SBRootFolderController.h>
#import <SpringBoard7.0/SBRootFolderView.h>
//#import <SpringBoard8.1/SBFolderView.h>
#import <objc/runtime.h>

#import <QuartzCore/QuartzCore.h>
#import <BulletinBoard/BBServer.h>
#import <BulletinBoard/BBBulletin.h>

#import "IBKResources.h"
#import "IBKWidgetViewController.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface SBFAnimationSettings : NSObject
@property double duration;
+ (id)settingsControllerModule;
@end

// Structs

typedef struct SBIconCoordinate {
    NSUInteger row;
    NSUInteger col;
} SBIconCoordinate;

// Class additions

@interface SBIconListView (Additions)
-(SBIconCoordinate)coordinateForIconWithIndex:(unsigned int)index andOriginalCoordinate:(SBIconCoordinate)orig forOrientation:(int)arg3;
-(SBIcon*)modifiedIconForIcon:(SBIcon*)icon;
@end

@interface SBIconModel (iOS8)
- (void)saveIconStateIfNeeded;
@end

@interface IBKIconView : SBIconView

+(IBKWidgetViewController*)getWidgetViewControllerForIcon:(SBIcon*)arg1 orBundleID:(NSString*)arg2;
-(void)addPreExpandedWidgetIfNeeded:(id)arg1;

@end

// Globals

NSMutableDictionary *cachedIndexes;
NSMutableDictionary *cachedIndexesLandscape;
NSMutableSet *movedIndexPaths;
NSMutableDictionary *widgetViewControllers;

int icons = 0;
int currentOrientation = 1;
int touchesInAppWindowCount = 0;
int indexOfGrabbedIcon = -1;

id grabbedIcon;

BOOL animatingIn = NO;
BOOL rearrangingIcons = NO;
BOOL iWidgets = NO;
BOOL isRotating = NO;

BOOL allWidgetsNeedLocking = NO;

static BBServer* __weak IBKBBServer;

// Hooks

#pragma mark Icon co-ordinate placements

%hook SBIconListView

%end

#pragma mark App switcher detection

BOOL inSwitcher = NO;

%hook SBAppSliderController

- (void)switcherWasDismissed:(BOOL)arg1 {
    %orig;
    inSwitcher = NO;
}

%end

%hook SBUIController

-(void)_activateSwitcher {
    inSwitcher = YES;
    
    // Oh bollocks. We need to ensure that all widgets are reset to showing again.
    for (NSString *key in [widgetViewControllers allKeys]) {
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:key];
        widgetController.view.alpha = 1.0;
    }
    
    %orig;
}

%end

// iOS 8

NSString *lastOpenedWidgetId;

%hook SBAppSwitcherController

- (void)switcherWasDismissed:(BOOL)arg1 {
    %orig;
    
    inSwitcher = NO;
}

%end

#import <SpringBoard7.0/SBApplication.h>

#pragma mark Opening/closing app animations

BOOL sup;
BOOL launchingWidget;

%hook SBApplication

- (void)willAnimateDeactivation:(_Bool)arg1 {
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];
    widgetController.view.alpha = 0.0;

    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.25] animations:^{
        widgetController.view.alpha = 1.0;
    }];

    sup = YES;

    %orig;
}

- (void)didAnimateDeactivation {
    %orig;

    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];
    [(UIImageView*)[widgetController.correspondingIconView _iconImageView] setAlpha:0.0];

    sup = NO;
}

- (void)willActivateWithTransactionID:(unsigned long long)arg1 {
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];

    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.25] animations:^{
        widgetController.view.alpha = 0.0;
    }];

    sup = YES;

    %orig;
}

- (void)didActivateWithTransactionID:(unsigned long long)arg1 {
    lastOpenedWidgetId = [self bundleIdentifier];

    %orig;

    sup = NO;
    
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];
    widgetController.view.alpha = 1.0;
}

// iOS 7

- (void)didAnimateActivation {
    %orig;

    sup = NO;
}

- (void)willAnimateActivation {
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];

    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.3] animations:^{
        widgetController.view.alpha = 0.0;
    }];

    sup = YES;

    %orig;
}

%end

#pragma mark Injection into icon views

%hook SBIconViewMap

- (id)mappedIconViewForIcon:(id)arg1 {
    id orig = %orig;

    if ([[orig class] isEqual:[objc_getClass("IBKIconView") class]]) {
        if (!isRotating)
            [(IBKIconView*)orig addPreExpandedWidgetIfNeeded:arg1];
    }

    return orig;
}

%end

%hook SBIconView

// hack - I wanted to play about with the Obj-C runtime and make a subclass to keep things neat.
- (id)initWithDefaultSize {
    SBIconView *original = %orig;
    if (![[original class] isEqual:[objc_getClass("IBKIconView") class]] && ![[original class] isEqual:[objc_getClass("SBFolderIconView") class]])
        object_setClass(original, objc_getClass("IBKIconView"));
    return original;
}

%end

CGSize defaultIconSizing;

#import <SpringBoard8.1/SBIconImageCrossfadeView.h>

%hook SBIconImageView

- (CGRect)visibleBounds {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
        CGRect frame = %orig;
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

        return frame;
    }

    return %orig;
}

-(CGRect)frame {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
        CGRect frame = %orig;
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

        return frame;
    }

    return %orig;
}

-(CGRect)bounds {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
        CGRect frame = %orig;
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

        return frame;
    }

    return %orig;
}

%end

%hook IBKIconView

- (CGPoint)iconImageCenter {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        CGPoint point = %orig;

        if ([IBKResources hoverOnly]) {
            return point;
        }

        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        point = CGPointMake(widgetController.view.frame.size.width/2, widgetController.view.frame.size.height/2);

        return point;
    }

    return %orig;
}

- (CGRect)iconImageFrame {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        CGRect frame = %orig;
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

        return frame;
    }

    return %orig;
}

- (void)prepareToCrossfadeImageWithView:(id)arg1 maskCorners:(_Bool)arg2 trueCrossfade:(_Bool)arg3 anchorPoint:(struct CGPoint)arg4 {
    %orig;
}

- (id)iconImageSnapshot {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        UIView *view = widgetController.view;

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];

        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        return img;
    } else {
        return %orig;
    }
}

-(CGRect)frame {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && !animatingIn && (iWidgets || [IBKResources hoverOnly])) {
        CGRect frame = %orig;
        defaultIconSizing = frame.size;
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height + [self _frameForLabel].size.height);

        if ([IBKResources hoverOnly]) {
            frame.origin = CGPointMake(frame.origin.x - ((widgetController.view.frame.size.width - frame.size.width)/2), frame.origin.y - ((widgetController.view.frame.size.height - frame.size.height)/2));
        }

        return frame;
    }

    return %orig;
}

- (void)_setIcon:(id)arg1 animated:(BOOL)arg2 { // Deal with adding a widget view onto those icons that are already expanded
    %orig;

    [self addPreExpandedWidgetIfNeeded:arg1];
}

- (struct CGRect)_frameForLabel {
    CGRect orig = %orig;

    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && ![IBKResources hoverOnly]) {
        orig.origin = CGPointMake(8, [IBKResources heightForWidget] + (isPad ? 7 : 2));
    }

    return orig;
}

-(void)prepareForRecycling {
    %orig;

    IBKWidgetViewController *cont = [objc_getClass("IBKIconView") getWidgetViewControllerForIcon:self.icon orBundleID:nil];
    [cont unloadWidgetInterface];

    NSLog(@"**** [Curago] :: recycling view");

    if ([self.icon applicationBundleID])
        [widgetViewControllers removeObjectForKey:[self.icon applicationBundleID]];
}

- (BOOL)pointInside:(struct CGPoint)arg1 withEvent:(UIEvent*)arg2 {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        // Check if point will be inside our thing.

        if ([IBKResources hoverOnly]) {
            UIView *view = [[widgetViewControllers objectForKey:[self.icon applicationBundleID]] view];

            // Normalise point.
            arg1.x = arg1.x + ((view.frame.size.width - self.frame.size.width)/2);
            arg1.y = arg1.y + ((view.frame.size.width - self.frame.size.width)/2);
            //arg1 = [[[widgetViewControllers objectForKey:[self.icon applicationBundleID]] view] convertPoint:arg1 fromView:self];
        }

        NSLog(@"Checking if point %@ is inside.", NSStringFromCGPoint(arg1));

        return [[[widgetViewControllers objectForKey:[self.icon applicationBundleID]] view] pointInside:arg1 withEvent:arg2];
    }

    BOOL orig = %orig;

    // We need to check that if there are two or more touches, and only one is on the icon, then we MUST return NO.
    // Else, pinching will fail.

    return orig;
}

-(void)addSubview:(UIView*)view {    
    IBKWidgetViewController *cont = [objc_getClass("IBKIconView") getWidgetViewControllerForIcon:self.icon orBundleID:nil];
    if (cont && [[view class] isEqual:[objc_getClass("SBCloseBoxView") class]]) {
        [cont.view addSubview:view];
    } else {
        %orig;
    }
}

%new

+(IBKWidgetViewController*)getWidgetViewControllerForIcon:(SBIcon*)arg1 orBundleID:(NSString*)arg2 {
    NSString *bundleIdentifier;
    if (arg1)
        bundleIdentifier = [arg1 applicationBundleID];
    else
        bundleIdentifier = arg2;

    return [widgetViewControllers objectForKey:bundleIdentifier];
}

%new

-(void)addPreExpandedWidgetIfNeeded:(id)arg1 {
    SBApplicationIcon *icon = (SBApplicationIcon*)arg1;

    if (!icon) {
        icon = (SBApplicationIcon*)self.icon;
    }

    if (!inSwitcher) {
        if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]]) {

            // Widget view controllers will be deallocated when the icon is recycled.
            IBKWidgetViewController *widgetController;
            if (![widgetViewControllers objectForKey:[icon applicationBundleID]]) {
                widgetController = [[IBKWidgetViewController alloc] init];
                widgetController.applicationIdentifer = [icon applicationBundleID];
                [widgetController layoutViewForPreExpandedWidget]; // No need to set center position
            } else {
                widgetController = [widgetViewControllers objectForKey:[icon applicationBundleID]];
            }

            // Add the small UI onto the icon - we can be sure this will not be a folder icon
            [self addSubview:widgetController.view];

            if (!widgetViewControllers)
                widgetViewControllers = [NSMutableDictionary dictionary];

                if ([icon applicationBundleID] && ![widgetViewControllers objectForKey:[icon applicationBundleID]])
                    [widgetViewControllers setObject:widgetController forKey:[icon applicationBundleID]]; // Ensure that a pointer remains to that widget controller.

            // Hide original icon
            [(UIImageView*)[self _iconImageView] setAlpha:0.0];
            widgetController.correspondingIconView = self;

            widgetController.view.layer.shadowOpacity = 0.0;
            widgetController.shimIcon.alpha = 0.0;
            widgetController.shimIcon.hidden = YES;

            if ([IBKResources hoverOnly]) {
                widgetController.view.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
                widgetController.view.layer.shadowOpacity = 0.3;
            }
        }

        // Testing
        //NSLog(@"Resultant count == %lu", (unsigned long)[widgetViewControllers count]);
    }

}

%end

#pragma mark Handle de-caching indexes when in editing mode

%hook SBIconController

- (void)setIsEditing:(BOOL)arg1 {
    rearrangingIcons = arg1;

    %orig;

    if (arg1) {
        //if (currentOrientation == 1 || currentOrientation == 2)
            [cachedIndexes removeAllObjects];
        //else if (currentOrientation == 3 || currentOrientation == 4)
            [cachedIndexesLandscape removeAllObjects];
    }
}

%new

-(BOOL)ibkIsInSwitcher {
    return inSwitcher;
}

%new

-(void)removeIdentifierFromWidgets:(NSString*)identifier {
    [widgetViewControllers removeObjectForKey:identifier];
}

%new

-(void)removeAllCachedIcons {
    if (currentOrientation == 1 || currentOrientation == 2)
        [cachedIndexes removeAllObjects];
    else if (currentOrientation == 3 || currentOrientation == 4)
        [cachedIndexesLandscape removeAllObjects];
}

%end

#pragma mark Handle pinching of icons

IBKWidgetViewController *widget;
SBIcon *widgetIcon;

// handle main scrolling icons

@interface SBIconScrollView (Additions2)
-(void)handlePinchGesture:(UIPinchGestureRecognizer*)pinch;
@end

@interface SBIconScrollView (Additions)
-(SBIconListView *)IBKListViewForIdentifierTwo:(NSString*)identifier;
@end

UIPinchGestureRecognizer *pinch;
NSObject *panGesture;

%hook SBIconScrollView

-(UIScrollView*)initWithFrame:(CGRect)frame {
    UIScrollView *orig = %orig;

    NSLog(@"*** [Curago] :: Adding pinch gesture onto SBIconScrollView");

    pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [(UIView*)orig addGestureRecognizer:pinch];

    for (UIGestureRecognizer *arg in [self gestureRecognizers]) {
        if ([[arg class] isEqual:[objc_getClass("UIScrollViewPanGestureRecognizer") class]]) {
            arg.delegate = self;
            panGesture = arg;
        } else if ([[arg class] isEqual:[objc_getClass("UIScrollViewPinchGestureRecognizer") class]]) {
            [orig removeGestureRecognizer:arg];
        }
    }

    return orig;
}

- (void)_updatePagingGesture {
    %orig;

    for (UIGestureRecognizer *arg in [self gestureRecognizers]) {
        if ([[arg class] isEqual:[objc_getClass("UIScrollViewPanGestureRecognizer") class]]) {
            arg.delegate = self;
            panGesture = arg;
        } else if ([[arg class] isEqual:[objc_getClass("UIScrollViewPinchGestureRecognizer") class]]) {
            [self removeGestureRecognizer:arg];
        } else if ([[arg class] isEqual:[objc_getClass("UIScrollViewPagingSwipeGestureRecognizer") class]]) {
            [arg requireGestureRecognizerToFail:pinch];
        }
    }
}

-(void)layoutSubviews {
    %orig;

    // Now, layout the widgets for hover mode.

    if ([IBKResources hoverOnly]) {
        for (NSString *key in [widgetViewControllers allKeys]) {
            IBKWidgetViewController *contr = [widgetViewControllers objectForKey:key];
            UIView *view = contr.view;

            [[view superview] addSubview:view];
        }
    }
}

%new

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL isPan = [gestureRecognizer isEqual:panGesture];

    if (isPan && gestureRecognizer.numberOfTouches > 1) {
        return NO;
    } else {
        return YES;
    }
}

%new

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer*)recTwo {
    if ([recTwo isEqual:pinch] && gestureRecognizer.numberOfTouches > 1) {
        return YES;
    } else {
        return NO;
    }
}

%new

int scale = 0;
NSInteger page = 0;
-(void)handlePinchGesture:(UIPinchGestureRecognizer*)pinch {
    // You must return if we're in a folder. for now
    if ([[objc_getClass("SBIconController") sharedInstance] hasOpenFolder]) return;

    if (pinch.state == UIGestureRecognizerStateBegan) {
         NSLog(@"Pinching began");
        // Handle setting up the view.

        // calculate mid-point of pinch
        CGFloat width = self.frame.size.width;
        page = (self.contentOffset.x + (0.5f * width)) / width;
        CGPoint rawMidpoint = [pinch locationInView:(UIView*)self];
        CGPoint finalMidpoint = CGPointMake(rawMidpoint.x - (page * width), rawMidpoint.y);
        NSLog(@"*** final midpoint == %@", NSStringFromCGPoint(finalMidpoint));

        // Get the icon at this point in the current list view
        SBIconListView *listView;
        [[objc_getClass("SBIconController") sharedInstance] getListView:&listView folder:nil relativePath:nil forIndexPath:[NSIndexPath indexPathForRow:1 inSection:page] createIfNecessary:NO];

        //SBIconListView *listView = [self.subviews objectAtIndex:(page+1)]; // Spotlight is still page 0. WTF Apple.
        unsigned int index;
        widgetIcon = [listView iconAtPoint:finalMidpoint index:&index];
        NSLog(@"Widget icon == %@", widgetIcon);

        // Extra check for folders

        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) {
            widget = nil;
            return;
        }

        // Ah shit. If this widget is already open, don't do anything!
        if ([widgetViewControllers objectForKey:[widgetIcon applicationBundleID]]) {
            widget = nil;
            return;
        }

        // We need to make this icon's view to be the highest subview. Oh shit. We can add in all our widget controllers here!
        widget = [[IBKWidgetViewController alloc] init];
        widget.applicationIdentifer = [widgetIcon applicationBundleID];

        if (!widgetViewControllers)
            widgetViewControllers = [NSMutableDictionary dictionary];

        if ([widgetIcon applicationBundleID])
            [widgetViewControllers setObject:widget forKey:[widgetIcon applicationBundleID]];

        // Add widget view onto icon.
        IBKIconView *view = [[objc_getClass("SBIconViewMap") homescreenMap] iconViewForIcon:widgetIcon];
        [view addSubview:widget.view];
        [view.superview addSubview:view]; // Move the view to be the top most subview

        widget.correspondingIconView = view;

        [[(SBIconView*)view _iconImageView] setAlpha:0.0];

        widget.view.transform = CGAffineTransformMakeScale(1.0, 1.0);

        [widget loadWidgetInterface];

        widget.view.center = CGPointMake(([(UIView*)[view _iconImageView] frame].size.width/2)-1, ([(UIView*)[view _iconImageView] frame].size.height/2)-1);

        CGFloat iconScale = (isPad ? 72 : 60) / [IBKResources heightForWidget];

        NSLog(@"BEGINNING SCALE IS %f", iconScale);

        widget.view.transform = CGAffineTransformMakeScale(iconScale, iconScale);
    } else if (pinch.state == UIGestureRecognizerStateChanged && widget) {
         NSLog(@"Pinching changed");
        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) return;

        // Set scale of our widget view, using scale/velocity as our time duration for animation

        CGFloat duration = (pinch.scale/pinch.velocity);

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            duration = (pinch.scale-1)/pinch.velocity;
            //NSLog(@"pinch.scale == %f, pinch.velocity == %f, duration == %f", pinch.scale, pinch.velocity, duration);
        }

        if (duration < 0)
            duration = -duration;

            scale = pinch.scale;

            [widget setScaleForView:pinch.scale withDuration:0.1];
        } 
        else if (pinch.state == UIGestureRecognizerStateEnded && widget) {
            NSLog(@"Pinching ended");
            if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) return;
            // Handle end of touch. If scale greater than a set value, drop down regardless of time spent held in place.
            // Also, we need to check whether we'll be overlapping another widget, and if so, don't drop /the bass/
            // We should add onto the homescreen now.

            if ((scale-1.0) > 0.75) { // Scale is 1.0 onwards, but we expect 0.0 onwards for our code
                [widget setScaleForView:8.0 withDuration:0.3];
                [IBKResources addNewIdentifier:[widgetIcon applicationBundleID]];

            }
        |
    } else if (pinch.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"PINCHING WAS CANCELLED");

        CGFloat scale = (isPad ? 72 : 60) / [IBKResources heightForWidget];

        [UIView animateWithDuration:0.3 animations:^{
            widget.view.transform = CGAffineTransformMakeScale(scale, scale);
            widget.view.center = CGPointMake(([(UIView*)[widget.correspondingIconView _iconImageView] frame].size.width/2)-1, ([(UIView*)[widget.correspondingIconView _iconImageView] frame].size.height/2)-1);
            widget.shimIcon.alpha = 1.0;

            widget.iconImageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [[widget.correspondingIconView _iconImageView] setAlpha:1.0];
            widget.view.hidden = YES;
            [widget unloadFromPinchGesture];

            if (widget && widget.applicationIdentifer) [widgetViewControllers removeObjectForKey:widget.applicationIdentifer];
        }];

    }
}

%new

-(SBIconListView *)IBKListViewForIdentifierTwo:(NSString*)identifier {
    SBIconController *viewcont = [objc_getClass("SBIconController") sharedInstance];
    SBIconModel *model = [viewcont model];
    SBIcon *icon = [model expectedIconForDisplayIdentifier:identifier];

    SBIconController *controller = [objc_getClass("SBIconController") sharedInstance];
    SBRootFolder *rootFolder = [controller valueForKeyPath:@"rootFolder"];
    NSIndexPath *indexPath = [rootFolder indexPathForIcon:icon];
    SBIconListView *listView = nil;
    [controller getListView:&listView folder:NULL relativePath:NULL forIndexPath:indexPath createIfNecessary:YES];
    return listView;
}

%end

#pragma mark Icon badge handling

%hook SBIconBadgeView

static SBIcon *temp;

- (void)configureForIcon:(SBIcon*)arg1 location:(int)arg2 highlighted:(BOOL)arg3 {
    temp = arg1;

    %orig;

    if ([[IBKResources widgetBundleIdentifiers] containsObject:[arg1 applicationBundleID]] && !inSwitcher) {
        // Calculate x for center
        [[self superview] addSubview:self]; // Bring to front.
    }

}

- (struct CGPoint)accessoryOriginForIconBounds:(CGRect)arg1 {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[temp applicationBundleID]] && !inSwitcher) {
        // Calculate x for center
        IBKWidgetViewController *contr = [widgetViewControllers objectForKey:[temp applicationBundleID]];
        arg1 = contr.view.bounds;

        // TODO: Fix for hover mode

        [[self superview] addSubview:self]; // Bring to front.
    }

    return %orig(arg1);
}

-(void)layoutSubviews {
    %orig;

    [[self superview] addSubview:self]; // Bring to front.
}

%end

#pragma mark Close button handling

@interface SBCloseBoxView : UIView
@end

%hook SBCloseBoxView

-(void)layoutSubviews {
    %orig;

    [[self superview] addSubview:self]; // Bring to front.
}

%end

#pragma mark Handle uninstallation of apps

%hook SBApplication

- (void)prepareForUninstallation {
    %orig;

    NSString *bundleId;
    if ([self respondsToSelector:@selector(bundleIdentifier)]) {
        bundleId = [self bundleIdentifier];
    } else {
        bundleId = [self displayIdentifier];
    }

    IBKWidgetViewController *contr = [widgetViewControllers objectForKey:bundleId];
    [widgetViewControllers removeObjectForKey:bundleId];
    [contr unloadWidgetInterface];
    contr = nil;

    [IBKResources removeIdentifier:bundleId];
}

%end

#pragma mark Handle re-locking widgets when locking

%hook SBLockScreenManager

-(void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 {
    %orig;

    if ([IBKResources relockWidgets] || allWidgetsNeedLocking) {
        for (NSString *key in [widgetViewControllers allKeys]) {
            IBKWidgetViewController *contr = [widgetViewControllers objectForKey:key];
            [contr lockWidget];
        }

        allWidgetsNeedLocking = NO;
    }
}

%end

#pragma mark BBServer hooks for notification tables

%hook BBServer

-(id)init {
    BBServer *orig = %orig;
    IBKBBServer = orig;
    return orig;
}

- (void)_addBulletin:(BBBulletin*)arg1 {
    IBKWidgetViewController *contr = [widgetViewControllers objectForKey:[arg1 sectionID]];
    if (contr)
        [contr addBulletin:arg1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@/notificationrecieved", [arg1 sectionID]] object:arg1];

    %orig;
}

- (void)_removeBulletin:(id)arg1 rescheduleTimerIfAffected:(BOOL)arg2 shouldSync:(BOOL)arg3 {
    for (NSString *key in widgetViewControllers) {
        if ([[(IBKWidgetViewController*)[widgetViewControllers objectForKey:key] applicationIdentifer] isEqual:[arg1 sectionID]])
            [(IBKWidgetViewController*)[widgetViewControllers objectForKey:key] removeBulletin:arg1];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@/notificationremoved", [arg1 sectionID]] object:arg1];

    %orig;
}

%new

+(id)sharedIBKBBServer {
    return IBKBBServer;
}

%end

#pragma mark Media data handling

%hook SBMediaController

-(void)_nowPlayingInfoChanged {
    %orig;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"IBK-UpdateMusic" object:nil];
}

%end

#pragma mark IOS 8 stuff

%group iOS8

%hook SBIconImageView

%new
-(id)alternateIconView {
    return nil; // Small fix for Auxo 3 of all things?!
}

%end

%end

#pragma mark iWidgets fixes

%group iWidgets

%hook IWWidgetsView

- (_Bool)pointInside:(struct CGPoint)arg1 withEvent:(id)arg2 {
    iWidgets = YES;
    BOOL original = %orig;
    iWidgets = NO;

    return original;
}

%end

%end

#pragma mark Settings callbacks

static void settingsChangedForWidget(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [IBKResources reloadSettings];

    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];

    // Reload widget for this bundle identifier.
    IBKWidgetViewController *controller = [widgetViewControllers objectForKey:[dict objectForKey:@"changedBundleIdFromSettings"]];
    [controller reloadWidgetForSettingsChange];
}

static void reloadAllWidgets(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    // Reload widget for this bundle identifier.
    [IBKResources reloadSettings];

    for (NSString *key in [widgetViewControllers allKeys]) {
        IBKWidgetViewController *controller = [widgetViewControllers objectForKey:key];
        [controller reloadWidgetForSettingsChange];
    }
}

static void changedLockAll(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSLog(@"RECIEVED LOCK ALL");

    [IBKResources reloadSettings];

    for (NSString *key in [widgetViewControllers allKeys]) {
        IBKWidgetViewController *controller = [widgetViewControllers objectForKey:key];
        [controller reloadWidgetForSettingsChange];
    }
}

static void reloadSettings(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [IBKResources reloadSettings];
}

#pragma mark Constructor and anti-piracy code

@interface ISIconSupport : NSObject
+(instancetype)sharedInstance;
-(void)addExtension:(NSString*)arg1;
@end

%ctor {

    // Subclass SBIconView at runtime.
    Class $IBKIconView = objc_allocateClassPair(objc_getClass("SBIconView"), "IBKIconView", 0);

    objc_registerClassPair($IBKIconView);

    // We're done. Load!
    %init;

    dlopen("/Library/MobileSubstrate/DynamicLibraries/IconSupport.dylib", RTLD_NOW);
    dlopen("/Library/MobileSubstrate/DynamicLibraries/iWidgets.dylib", RTLD_NOW);
    [[objc_getClass("ISIconSupport") sharedInstance] addExtension:@"com.matchstic.curago"];

    // Load custom stuff for certain versions of iOS.

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        %init(iOS8);

    %init(iWidgets);

    [IBKResources reloadSettings];

    // Handlers for widget settings.
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChangedForWidget, CFSTR("com.matchstic.ibk/settingschangeforwidget"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, reloadAllWidgets, CFSTR("com.matchstic.ibk/reloadallwidgets"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, reloadSettings, CFSTR("com.matchstic.ibk/reloadsettings"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, changedLockAll, CFSTR("com.matchstic.ibk/changedlockall"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
