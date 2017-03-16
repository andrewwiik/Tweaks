#import <UIKit/UIKit.h>
#import "Floater.h"
#import "CDTContextHostProvider.h"
#import <objc/runtime.h>
#import "Interfaces.h"


#define NSLog(FORMAT, ...) NSLog(@"[%@]: %@",@"Floater" , [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#define SCREEN ([[UIScreen mainScreen] bounds]) // Screen Bounds
#define CENTER (CGPointMake(SCREEN.size.width/2, SCREEN.size.height/2)) // Center of Device Screen
#define kResizeThumbSize (35) // the size of each corner resize handle

// static NSData * (*SBSCopyIconImagePNGDataForDisplayIdentifier)(NSString *identifier) = NULL;
extern "C" NSData* SBSCopyIconImagePNGDataForDisplayIdentifier(NSString * bundleid);//获取APP图标


// @interface UIApplicationShortcutItem : NSObject

// + (unsigned int)_sbsActivationModeFromUIActivationMode:(unsigned int)arg1;
// + (unsigned int)_uiActivationModeFromSBSActivationMode:(unsigned int)arg1;
// + (BOOL)supportsSecureCoding;

// - (id)_initWithType:(id)arg1 localizedTitle:(id)arg2 localizedSubtitle:(id)arg3 icon:(id)arg4 userInfoData:(id)arg5 activationMode:(unsigned int)arg6;
// - (unsigned int)activationMode;
// - (id)description;
// - (unsigned int)hash;
// - (id)icon;
// - (id)init;
// - (id)initWithSBSApplicationShortcutItem:(id)arg1;
// - (id)initWithType:(id)arg1 localizedTitle:(id)arg2;
// - (id)initWithType:(id)arg1 localizedTitle:(id)arg2 localizedSubtitle:(id)arg3 icon:(id)arg4 userInfo:(id)arg5;
// - (BOOL)isEqual:(id)arg1;
// - (id)localizedSubtitle;
// - (id)localizedTitle;
// - (id)sbsShortcutItem;
// - (void)setActivationMode:(unsigned int)arg1;
// - (void)setIcon:(id)arg1;
// - (void)setLocalizedSubtitle:(id)arg1;
// - (void)setLocalizedTitle:(id)arg1;
// - (void)setType:(id)arg1;
// - (void)setUserInfo:(id)arg1;
// - (void)setUserInfoData:(id)arg1;
// - (id)type;
// - (id)userInfo;
// - (id)userInfoData;

// @end
@interface SBApplicationShortcutStoreManager : NSObject
+ (id)sharedManager;
- (void)saveSynchronously;
- (void)setShortcutItems:(id)arg1 forBundleIdentifier:(id)arg2;
- (id)shortcutItemsForBundleIdentifier:(NSString*)arg1;
- (id)init;
@end
@interface SBApplication ()
@property(copy, nonatomic) NSArray *staticShortcutItems;
@end
@interface SBApplicationShortcutMenu : UIView
@property(retain, nonatomic) SBApplication *application;
- (id)contextForID:(NSString *)bundleID;
- (void)dismissAnimated:(_Bool)arg1 completionHandler:(id)arg2;
- (id)_shortcutItemsToDisplay;
- (UIView*)appViewForShortcut;
- (id)sceneMonitorForAppView:(id)arg1;
- (UIView*)contextHostViewForSceneMonitor:(id)arg1;
@end
@interface SpringBoard : UIApplication
- (void)reboot;
- (void)powerDown;
@end
@interface SBApplicationShortcutMenuContentView : UIView
@end
// @interface UIApplicationShortcutIcon : NSObject
// @end
@interface UIApplicationShortcutIcon()
@end
@interface SBSApplicationShortcutIcon : NSObject
@end
@interface SBSApplicationShortcutItem : NSObject
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
@end
@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
- (id)initWithType:(UIApplicationShortcutIconType)arg1;
@end
@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
- (id)initWithImagePNGData:(id)arg1;
@end
@interface SBSApplicationShortcutContactIcon : SBSApplicationShortcutIcon
-(instancetype)initWithContactIdentifier:(NSString *)contactIdentifier;
-(instancetype)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName;
-(instancetype)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName imageData:(NSData*)imageData;
@end
@interface UIApplication (Floater)
- (void)addNotifications;
@end
@implementation UIApplication (Floater)
- (void)addNotifications {
   NSString *dispident = [(UIApplication *)self displayIdentifier];

        //if we get here, we're inside an app. register notification for rotation
        //notification will be appidentifierLamoRotate
        NSString *rotationLandscapeNotification = [NSString stringWithFormat:@"%@LamoLandscapeRotate", dispident];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), (CFNotificationCallback)receivedLandscapeRotate, (CFStringRef)rotationLandscapeNotification, NULL, CFNotificationSuspensionBehaviorDrop);
        
        //portrait
        NSString *rotationPortraitNotification = [NSString stringWithFormat:@"%@LamoPortraitRotate", dispident];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), (CFNotificationCallback)receivedPortraitRotate, (CFStringRef)rotationPortraitNotification, NULL, CFNotificationSuspensionBehaviorDrop);
        
        //create statusbar notification
        NSString *changeStatusBarNotification = [NSString stringWithFormat:@"%@LamoStatusBarChange", dispident];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(), (__bridge const void *)(self), (CFNotificationCallback)receivedStatusBarChange, (CFStringRef)changeStatusBarNotification, NULL, CFNotificationSuspensionBehaviorDrop);
        
        //create window size notification
        NSString *windowSizeNotification = [NSString stringWithFormat:@"Resize-%@", dispident];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(), (__bridge const void *)(self), (CFNotificationCallback)recievedResize, (CFStringRef)windowSizeNotification, NULL, CFNotificationSuspensionBehaviorDrop);
}

void receivedStatusBarChange(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {

    //set hidden based on isHidden key
    [[UIApplication sharedApplication] setStatusBarHidden:[[(__bridge NSDictionary *)userInfo valueForKey:@"isHidden"] boolValue] animated:YES];
}

void receivedLandscapeRotate() {
    
    //rotate all windows
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        
        [window _setRotatableViewOrientation:UIInterfaceOrientationLandscapeRight updateStatusBar:YES duration:0.45 force:YES];
        
    }
}

void receivedPortraitRotate() {
    
    //rotate all windows
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        
        [window _setRotatableViewOrientation:UIInterfaceOrientationPortrait updateStatusBar:YES duration:0.45 force:YES];
        
    }
}

void recievedResize(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSLog(@"Frame Resize: %@", [[(__bridge NSDictionary *)userInfo valueForKey:@"frame"] CGRectValue]);
    //resize all windows
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        
        [window setFrame:[[(__bridge NSDictionary *)userInfo valueForKey:@"frame"] CGRectValue]];
        
    }
}
@end


%hook SBApplicationShortcutStoreManager
- (id)shortcutItemsForBundleIdentifier:(NSString*)arg1 {
		NSArray *aryItems = [NSArray new];
		if (%orig != NULL || %orig != nil) {
			aryItems = %orig;
		}
		NSMutableArray *aryShortcuts = [aryItems mutableCopy];

    SBSApplicationShortcutItem *newAction = [[%c(SBSApplicationShortcutItem) alloc] init];
    [newAction setIcon:[[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeAdd]];
    [newAction setLocalizedTitle:@"Floater"];
    [newAction setLocalizedSubtitle:@""];
    [newAction setType:[NSString stringWithFormat:@"%@___extractApp",arg1]];
    [aryShortcuts addObject:newAction];

		return aryShortcuts;
}
%end

%hook SBApplicationShortcutMenu
%new
- (UIImage *)appView {
  //[self.medusa _bringToForeground:self.app.bundleIdentifier withFrame:CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height)];
  [[[[NSClassFromString(@"SBMedusaAppsTestRecipe") class] alloc] init] _bringToForeground:self.application.bundleIdentifier withFrame:CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height)];
  SBWorkspaceApplication *workspaceApplication = [[NSClassFromString(@"SBWorkspaceApplication") class] entityForApplication:self.application];
    SBLayoutElement *applicationLayoutElement = [workspaceApplication layoutElementForRole:1];
    NSSet *elements = [NSSet setWithObjects:applicationLayoutElement, nil];
    SBMainDisplayLayoutState *layoutState = [[[NSClassFromString(@"SBMainDisplayLayoutState") class] alloc] _initWithElements:elements];

    SBAppContainerViewController *appController = [[[NSClassFromString(@"SBAppContainerViewController") class] alloc] initWithDisplay:[[UIScreen mainScreen] valueForKey:@"_fbsDisplay"]];
    [appController configureWithEntity:workspaceApplication forElement:applicationLayoutElement layoutState:layoutState];
    SBAppView *appView = ((SBAppContainerView *)appController.view).appView;
    UIImage* image = [[((SBAppContainerView *)appController.view).appView _snapshotOrDefaultImageView] image];
    return image;
}

- (void)menuContentView:(id)arg1 activateShortcutItem:(UIApplicationShortcutItem*)arg2 index:(long long)arg3 {
	NSString *input = arg2.type;

	if ([input containsString:@"___"]) {

    UIView *my_proxyIconViewWrapper = MSHookIvar<UIView *>(self, "_proxyIconViewWrapper");
    Floater *viewFloat = [[Floater alloc] initWithApplicationBundleID:self.application.bundleIdentifier atPoint:my_proxyIconViewWrapper.center];
    [viewFloat toggleFloater];
    [self dismissAnimated:YES completionHandler:nil];
    UIView *viewMovement = [[UIView alloc] initWithFrame:CGRectMake(0,0,[viewFloat floaterOpenSize].width,20)];
    viewMovement.userInteractionEnabled = NO;
    viewMovement.backgroundColor = [UIColor redColor];
    [viewFloat.viewOpen addSubview:viewMovement];

  } else {
		%orig;
	}
}
%end


/*void receivedLandscapeRotate() {
    
    //rotate all windows
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        
        [window _setRotatableViewOrientation:UIInterfaceOrientationLandscapeRight updateStatusBar:YES duration:0.45 force:YES];
        
    }
}

void receivedPortraitRotate() {
    
    //rotate all windows
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        
        [window _setRotatableViewOrientation:UIInterfaceOrientationPortrait updateStatusBar:YES duration:0.45 force:YES];
        
    }
} */
%hook SBAppView
-(BOOL)_hasLiveContent {
return TRUE;
}
%new
- (FBSceneMonitor*)_sceneMonitor {
    return MSHookIvar<id>(self,"_sceneMonitor");
}
%new
- (UIView*)_contextHostView {
    id test = MSHookIvar<id>(self,"_contextHostView");
    if (!test) {
        FBSceneMonitor *sceneMonitor = MSHookIvar<id>(self,"_sceneMonitor");
        if (sceneMonitor.scene) {
            MSHookIvar<id>(self,"_contextHostView") = MSHookIvar<id>(sceneMonitor.scene.contextHostManager,"_hostView");
        }
        else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                if (sceneMonitor.scene) {
                    MSHookIvar<id>(self,"_contextHostView") = MSHookIvar<id>(sceneMonitor.scene.contextHostManager,"_hostView");
                }
            });
        }
    }
    return MSHookIvar<id>(self,"_contextHostView");
}
%end

%hook Floater
%property (nonatomic, retain) SBAppView *appView;
%property (nonatomic, retain) UIView *contextView;
%property (nonatomic, retain) UIView *slideView;
%property (nonatomic, retain) SBApplication *app;
%property (nonatomic, retain) SBMedusaAppsTestRecipe *medusa;
%end

%hook SBApplication
%new
- (id)processState {
  return MSHookIvar<id>(self,"_processState");
}
%end

/*%hook SBUIController
- (_Bool)clickedMenuButton
{

    return YES;
}
%end*/
%hook SBSwitcherAppSuggestionSlideUpView
%property (nonatomic, retain) SBAppView *appView;

- (void)_configureContentView {
  %orig;
  [self setAppView];
}
%new
- (void)setAppView {
  SBAppView *appView = MSHookIvar<id>(self,"_appView");
  if (appView) {
    self.appView = MSHookIvar<id>(self,"_appView");
    return;
  }
  else if (!appView) {
    [self setAppView];
  }
}
%end


%hook UIApplication
- (id)init {
    %orig;
    [self addNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustFrameWindow) name:UIWindowDidBecomeVisibleNotification object:nil];
     //NSString *dispident = [(UIApplication *)self displayIdentifier];
      //if (![dispident isEqualToString:@"com.apple.springboard"]) {

        //if we get here, we're inside an app. register notification for rotation
        //notification will be appidentifierLamoRotate
        /*NSString *rotationLandscapeNotification = [NSString stringWithFormat:@"%@LamoLandscapeRotate", dispident];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), (CFNotificationCallback)receivedLandscapeRotate, (CFStringRef)rotationLandscapeNotification, NULL, CFNotificationSuspensionBehaviorDrop);
        
        //portrait
        NSString *rotationPortraitNotification = [NSString stringWithFormat:@"%@LamoPortraitRotate", dispident];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), (CFNotificationCallback)receivedPortraitRotate, (CFStringRef)rotationPortraitNotification, NULL, CFNotificationSuspensionBehaviorDrop);
        */
        //create window size notification
        //NSString *windowSizeNotification = [NSString stringWithFormat:@"Resize-%@", dispident];
        //CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(), NULL, (CFNotificationCallback)recievedResize, (CFStringRef)windowSizeNotification, NULL, CFNotificationSuspensionBehaviorDrop);
                
    return %orig;
}
/*%new
- (void)adjustFrameWindow {
  if ([[self identifier] isEqualToString:[[NSBundle mainBundle] bundleIdentifier]]) {
    CGRect newFrame = [self.settings frame];
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
      if ([window isKeyWindow]) {
        if (!CGRectEqualToRect(window.frame, newFrame)) {
          UIWindow *statusBarWindow = (UIWindow *)[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
          [window.rootViewController.view setFrame:statusBarWindow.frame];
          if (statusBarWindow.frame.size.width <= SCREEN.size.width/2) {
            [window _setRotatableViewOrientation:UIInterfaceOrientationPortrait updateStatusBar:YES duration:0.45 force:YES];
          }
          //window.frame = statusBarWindow.frame;
        }
      }
    }
  }
} */
%end


%hook FBSSceneImpl
-(void)updater:(id)arg1 didUpdateSettings:(id)arg2 withDiff:(id)arg3 transitionContext:(id)arg4 completion:(/*^block*/id)arg5 {
  %orig;
  if ([[self identifier] isEqualToString:[[NSBundle mainBundle] bundleIdentifier]]) {
    CGRect newFrame = [self.settings frame];
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
      if ([window isKeyWindow]) {
        if (!CGRectEqualToRect(window.frame, newFrame)) {
          UIWindow *statusBarWindow = (UIWindow *)[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
          [window.rootViewController.view setFrame:statusBarWindow.frame];
          if (statusBarWindow.frame.size.width <= SCREEN.size.width/2) {
            [window _setRotatableViewOrientation:UIInterfaceOrientationPortrait updateStatusBar:YES duration:0.45 force:YES];
          }
          //window.frame = statusBarWindow.frame;
        }
      }
    }
  }
}
/*-(void)updater:(id)arg1 didReceiveActions:(id)arg2 {
  %orig;
  if ([[self identifier] isEqualToString:[[NSBundle mainBundle] bundleIdentifier]]) {
    CGRect newFrame = [self.settings frame];
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
      if (!CGRectEqualToRect(window.frame, newFrame)) {
          [window _adjustSizeClassesAndResizeWindowToFrame:newFrame];
      }
    }
  }
}*/
%end



/*#define kResizeThumbSize (35)
BOOL isResizingLR, isResizingUL, isResizingUR, isResizingLL;
CGPoint touchStart;
CGPoint previousPoint;
BOOL calculatedCorner;
CGFloat x, y, width, height;
float deltaWidth, deltaHeight;
CGPoint touchPoint, previous;
BOOL touchingCorner;
BOOL updateFrame;

@interface UIWindow (Private)
- (void)resize;
@end

CGRect _iconFrame = CGRectMake(0,0,62,62);
%hook UIWindow
%new
- (void)resize { // Resize calcualtion to make sure the user doesn't resize beyond the screen
  if (touchingCorner == YES) { // Checks a corner is touched
    if (isResizingLR) { // If the bottom-right corner is opposite diagonally to the icon
      CGFloat finalHeight = touchPoint.y+deltaWidth; // The planned new height for our view
      CGFloat finalWidth = touchPoint.x+deltaWidth; // The planned new width for our view

      if (finalWidth > SCREEN.size.width - self.frame.origin.x - 20 ) { // If the planned new width is beyond the allowed width
        finalWidth = self.frame.size.width; // Reset the new planned width to what it currently is.

        }
        /*if (finalWidth < _iconFrame.size.width) { // If the planned new width is less than allowed width
          finalWidth = self.superview.frame.size.width; // Reset the new planned width to what it currently is.
        }*/

        /*if (finalHeight < _iconFrame.size.height) { // If the planned new height is less than the allowed height
          finalHeight = self.superview.frame.size.height; // Reset the new planned height to what it currently is
        } */
        /*if (finalHeight > SCREEN.size.height - self.frame.origin.y - 20) { // If the planned new height is greater than the allowed height
          finalHeight = self.frame.size.height; // Reset the new planned height to what it currently is
        }


        self.frame = CGRectMake(x, y, finalWidth, finalHeight); // Set the new frame

      }
      else if (isResizingUL) { // If the top-left corner is opposite diagonally to the icon
        CGFloat finalHeight = height-deltaHeight; // The planned new height for our view
        CGFloat finalWidth = width-deltaWidth; // The planned new width for our view
        CGFloat finalX = x+deltaWidth; // The planned origin on the x-axis for our view
        CGFloat finalY = y+deltaHeight; // The planned origin on the y-axis for our view

        if (finalWidth < _iconFrame.size.width) { // If the planned new width is less than allowed width
            finalWidth = self.superview.frame.size.width; // Reset the new planned width to what it currently is.
            finalX = self.superview.frame.origin.x; // Reset the planned origin on the x-axis to what it currently is
        }
        if (finalHeight < _iconFrame.size.height) { // If the planned new height is less than the allowed height
          finalHeight = self.superview.frame.size.height; // Reset the new planned height to what it currently is
          finalY = self.superview.frame.origin.y; // Reset the planned origin on the y-axis to what it currently is
        }

        if (finalWidth > SCREEN.size.width - (SCREEN.size.width - self.frame.origin.x - self.frame.size.width) -20) { // If the planned new width is beyond the allowed width
          finalWidth = self.frame.size.width; // Reset the new planned width to what it currently is.
          finalX = self.frame.origin.x; // Reset the planned origin on the x-axis to what it currently is
        }

        if (finalHeight > SCREEN.size.height - (SCREEN.size.height - self.frame.origin.y - self.frame.size.height) - 20) { // If the planned new height is greater than the allowed height
          finalHeight = self.frame.size.height; // Reset the new planned height to what it currently is
          finalY = self.frame.origin.y; // Reset the planned origin on the y-axis to what it currently is 
        }

        self.frame = CGRectMake(finalX, finalY, finalWidth, finalHeight); // Set the new frame

      }
      else if (isResizingUR) { // If the top-right corner is opposite diagonally to the icon
        // is already handled
      }
      else if (isResizingLL) { // If the bottom-left corner is opposite diagonally to the icon
        CGFloat finalHeight = height+deltaHeight; // The planned new height for our view
        CGFloat finalWidth = width-deltaWidth; // The planned new width for our view
        CGFloat finalX = x+deltaWidth; // The planned origin on the x-axis for our view

        if (finalWidth < _iconFrame.size.width) { // If the planned new width is less than allowed width
            finalWidth = self.superview.frame.size.width; // Reset the new planned width to what it currently is.
            finalX = self.superview.frame.origin.x; // Reset the planned origin on the x-axis to what it currently is
        }
        if (finalHeight < _iconFrame.size.height) { // If the planned new height is less than the allowed height
          finalHeight = self.superview.frame.size.height; // Reset the new planned height to what it currently is
        }

        if (finalHeight > SCREEN.size.height - self.frame.origin.y - 20) { // If the planned new height is greater than the allowed height
          finalHeight = self.frame.size.height; // Reset the new planned height to what it currently is
        }
        if (finalWidth > SCREEN.size.width - (SCREEN.size.width - self.frame.origin.x - self.frame.size.width) -20) { // If the planned new width is beyond the allowed width
          finalWidth = self.frame.size.width; // Reset the new planned width to what it currently is.
          finalX = self.frame.origin.x; // Reset the planned origin on the x-axis to what it currently is
        }

        self.frame = CGRectMake(finalX, y, finalWidth, finalHeight); // Set the new frame
      }
      //self.frame = self.superview.bounds; // make our frame match the frame above us
      previous = touchPoint; // set the previous touch point as our current one
      updateFrame = YES; // tell the -(void)layoutSubviews method to resize the live camera preview layer
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    isResizingUL = NO; // It's not the top-left
              isResizingUR = NO; // It's not the top-right
              isResizingLL = NO; // It's not the bottom-left
              isResizingLR = YES;
touchStart = [[touches anyObject] locationInView:self]; // The point we touched the screen in relation to our view
    previous=[[touches anyObject]previousLocationInView:self]; // The point we touched the screen previously in relation to our view
    if ((self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize) || // If we are touching a corner.
        (touchStart.x <kResizeThumbSize && touchStart.y <kResizeThumbSize) ||
        (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize) ||
        (touchStart.x <kResizeThumbSize && self.bounds.size.height -touchStart.y <kResizeThumbSize)) {
     touchingCorner = YES; //a corner has been touched start resize gesture
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    touchPoint = [[touches anyObject] locationInView:self]; // The current location of the user's finger in realtion to our view
    previous = [[touches anyObject]previousLocationInView:self]; // The previous location of the user's finger in relation to our view

    deltaWidth = touchPoint.x-previous.x; // The differnce on the x-axis between the previous touch and the current touch
    deltaHeight = touchPoint.y-previous.y; // The differnce on the y-axis between the previous touch and the current touch

    x = self.frame.origin.x; // The current x-axis origin of the regular 3D touch menu
    y = self.frame.origin.y; // The current y-axis origin of the regular 3D touch menu
    width = self.frame.size.width; // The current width of the regular 3D touch menu
    height = self.frame.size.height; // The current height of the regular 3D touch menu

    if (isResizingLR) { // If the bottom-right corner is opposite diagonally to the icon
      [self resize];//resize calculations
    }
    if (isResizingUL) { // If the top-left corner is opposite diagonally to the icon
     [self resize];//resize calculations
    }
    if (isResizingLL) { // If the bottom-left corner is opposite diagonally to the icon
       [self resize];//resize calculations
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  touchingCorner = NO;//signal corner movement is done
}
%end */

%hook UIApplication
%new
- (id)iconForBundleID:(NSString *)bundleID {
  // SBSCopyIconImagePNGDataForDisplayIdentifier = dlsym(RTLD_DEFAULT, "SBSCopyIconImagePNGDataForDisplayIdentifier");
  NSData *icondata = SBSCopyIconImagePNGDataForDisplayIdentifier(bundleID);
  return [UIImage imageWithData:icondata];
}

%end