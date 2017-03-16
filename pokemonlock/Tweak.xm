#import <UIKit/UIKit.h>
#include "CDTContextHostProvider.h"

@interface RootViewController : UIViewController
void queryNavStatus();
@end

@interface SBLockScreenView : UIView
void gMapsIsNavigating();
@end

@interface SBLockScreenManager : NSObject
+ (id)sharedInstance;
@end

@interface SBAwayViewPluginController : UIViewController
@end

@interface SBLockScreenViewControllerBase
-(void)disableLockScreenBundleWithName:(id)name deactivationContext:(id)context;
-(void)enableLockScreenBundleWithName:(id)name activationContext:(id)context;
@end

@interface FBWorkspaceEvent : NSObject
+ (instancetype)eventWithName:(NSString *)label handler:(id)handler;
@end

@interface FBSceneManager : NSObject
@end

@interface SBAppToAppWorkspaceTransaction
- (void)begin;
- (id)initWithAlertManager:(id)alertManager exitedApp:(id)app;
- (id)initWithAlertManager:(id)arg1 from:(id)arg2 to:(id)arg3 withResult:(id)arg4;
- (id)initWithTransitionRequest:(id)arg1;
@end

@interface FBWorkspaceEventQueue : NSObject
+ (instancetype)sharedInstance;
- (void)executeOrAppendEvent:(FBWorkspaceEvent *)event;
@end

@interface SBDeactivationSettings
-(id)init;
-(void)setFlag:(int)flag forDeactivationSetting:(unsigned)deactivationSetting;
@end

@interface UIApplication (DopeLock)
    +(id)sharedApplication;
    -(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface SpringBoard
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface SBDeviceLockController : NSObject
+ (SBDeviceLockController *)sharedController;
- (BOOL)isPasscodeLocked;
@end

static UIView *gmapsContextView;
static id observer;

%hook SBLockScreenPluginLoader

- (Class)_principleClassFromBundleWithName:(NSString *)name {

  if ([name isEqualToString:@"GMaps"]) {
    return %c(EAGMSBPluginController);
  }

  return %orig;
}

%end

%subclass EAGMSBPluginController : SBAwayViewPluginController

%new
+ (id)rootViewController {
  return [[self alloc] init];
}

- (id)init {
  id me = %orig;
  if (me) {

    [[(UIViewController *)self view] setUserInteractionEnabled:NO];
  }
  return me;
}
- (void)loadView {

    //if we get here, its time to show gmaps on the lockscreen
    //get context host of the app
    if (!([[objc_getClass("SBDeviceLockController") sharedController] isPasscodeLocked])) {

        if (!gmapsContextView) {

            CDTContextHostProvider *provider = [CDTContextHostProvider new];
            gmapsContextView = [provider hostViewForApplicationWithBundleID:@"com.nianticlabs.pokemongo"];
            [provider setStatusBarHidden:@(1) onApplicationWithBundleID:@"com.nianticlabs.pokemongo"];
        }

        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(40, 10, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        [containerView setUserInteractionEnabled:NO];
        [gmapsContextView setTransform:CGAffineTransformMakeScale(.9, .9)];

        CGRect frame = [gmapsContextView frame];
        frame.origin.x = ([[UIScreen mainScreen] bounds].size.width / 2) - (([[UIScreen mainScreen] bounds].size.width * .9) / 2);
        [gmapsContextView setFrame:frame];

        [containerView addSubview:gmapsContextView];

        [(SBAwayViewPluginController *)self setView:containerView];
    }

}

- (BOOL)shouldDisableOnUnlock {
  return YES;
}
- (BOOL)showDateView {
  return NO;
}

- (BOOL)viewWantsFullscreenLayout {
  return NO;
}

- (BOOL)canScreenDim {
    return NO;
}

- (BOOL)isContentViewWhiteUnderSlideToUnlockText {
    return 1;
}

%end

%hook SBLockScreenView

- (void)setCustomSlideToUnlockText:(id)arg1 {
    NSString *string;
    if (!([[objc_getClass("SBDeviceLockController") sharedController] isPasscodeLocked])) {
        string = @"";
    } else {
        string = arg1;
    }
    %orig(string);
}

- (void)startAnimating {

    //add observer to hear back from gmaps
    //register to get notifications sent from SB asking about navigation status
   // CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), (CFNotificationCallback)gMapsIsNavigating, (CFStringRef)@"gmaps.isNavigating", NULL, CFNotificationSuspensionBehaviorDrop);

    //post notification to google maps. If it has a route, it will post a notification back
    //CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"gmaps.queryNavStatus", NULL, NULL, YES);

dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

    %orig;

    gMapsIsNavigating();
});
}

- (void)stopAnimating {

    if (gmapsContextView && [gmapsContextView superview]) {

        [(SBLockScreenViewControllerBase *)[[%c(SBLockScreenManager) sharedInstance] valueForKey:@"_lockScreenViewController"] disableLockScreenBundleWithName:@"GMaps" deactivationContext:nil];
        [[CDTContextHostProvider new] stopHostingForBundleID:@"com.nianticlabs.pokemongo"];

  /*      //close the app
        FBWorkspaceEvent *event = [NSClassFromString(@"FBWorkspaceEvent") eventWithName:@"ActivateSpringBoard" handler:^{
            SBDeactivationSettings *deactiveSets = [[NSClassFromString(@"SBDeactivationSettings") alloc] init];
            [deactiveSets setFlag:YES forDeactivationSetting:20];
            [deactiveSets setFlag:NO forDeactivationSetting:2];
            [(SBApplication *)[[UIApplication sharedApplication] _accessibilityFrontMostApplication] _setDeactivationSettings:deactiveSets];
            SBAppToAppWorkspaceTransaction *transaction = [[NSClassFromString(@"SBAppToAppWorkspaceTransaction") alloc] initWithAlertManager:nil exitedApp:[[UIApplication sharedApplication] _accessibilityFrontMostApplication]];
            [transaction begin];

        }];

        [(FBWorkspaceEventQueue *)[NSClassFromString(@"FBWorkspaceEventQueue") sharedInstance] executeOrAppendEvent:event];
*/
        [[gmapsContextView superview] removeFromSuperview];
        [gmapsContextView removeFromSuperview];
        gmapsContextView = nil;

    }

    %orig;
 }

void gMapsIsNavigating() {

    //if we get here its time to enable the gmaps view
    [(SBLockScreenViewControllerBase *)[[%c(SBLockScreenManager) sharedInstance] valueForKey:@"_lockScreenViewController"] enableLockScreenBundleWithName:@"GMaps" activationContext:nil];
}

%end

%hook RootViewController

- (void)loadView {

    %orig;

    //register to get notifications sent from SB asking about navigation status
//    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), (CFNotificationCallback)queryNavStatus, (CFStringRef)@"gmaps.queryNavStatus", NULL, CFNotificationSuspensionBehaviorDrop);

}

%new
void queryNavStatus() {
/*
    //if we are navigating somewhere, post a notification letting SB know
    RootViewController *rootVC = [[(UIResponder *)[[UIApplication sharedApplication] delegate] valueForKey:@"_uiNavigationController"] valueForKey:@"_rootViewController"];

    if ([[[rootVC valueForKey:@"_navigationManager"] valueForKey:@"_navigating"] boolValue]) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"gmaps.isNavigating", NULL, NULL, YES);
    }
*/
}

%end

%ctor {
    if (!([[objc_getClass("SBDeviceLockController") sharedController] isPasscodeLocked])) {
        observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
        object:nil queue:[NSOperationQueue mainQueue]
        usingBlock:^(NSNotification *notification) {
            int64_t delay = 5.0; // In seconds
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
            HBLogDebug(@"Launched?");

            dispatch_after(time, dispatch_get_main_queue(), ^(void){
                HBLogDebug(@"Delayed");
                [(SpringBoard *)[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.nianticlabs.pokemongo" suspended:YES];
            });

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                HBLogDebug(@"Boot app");
                SBApplication *application = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:@"com.nianticlabs.pokemongo"];
                FBScene *scene = [application mainScene];
                if (!scene || !scene.settings || !scene.mutableSettings) {
                    return;
                }
                FBSMutableSceneSettings *sceneSettings = scene.mutableSettings;
                sceneSettings.backgrounded = YES;
                [scene _applyMutableSettings:sceneSettings withTransitionContext:nil completion:nil];                
            });
            }
        ];
    }
    
}
