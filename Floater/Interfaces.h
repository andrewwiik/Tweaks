#define __is__iOS9__ [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
@interface SBLayoutState : NSObject
- (id)_initWithElements:(id)arg1;
@end
@interface SBApplication : NSObject
@property(copy) NSString* displayIdentifier;
@property(copy) NSString* bundleIdentifier;
- (id)valueForKey:(id)arg1;
- (NSString *)displayName;
- (int)pid;
- (id)mainScene;
- (NSString *)path;
- (id)mainScreenContextHostManager;
- (void)setDeactivationSetting:(unsigned int)setting value:(id)value;
- (void)setDeactivationSetting:(unsigned int)setting flag:(BOOL)flag;
- (id)bundleIdentifier;
- (id)displayIdentifier;
- (void)notifyResignActiveForReason:(int)reason;
- (void)notifyResumeActiveForReason:(int)reason;
- (void)activate;
- (void)setFlag:(long long)arg1 forActivationSetting:(unsigned int)arg2;
- (BOOL)statusBarHidden;
@end
@interface SBIcon : NSObject
@property (nonatomic, retain) NSString* applicationBundleID;
-(NSString*)displayNameForLocation:(NSInteger)location;
-(UIImage*)generateIconImage:(int)arg1;
@end
@interface SBApplicationIcon : NSObject
@property (nonatomic, retain) SBApplication* application;
@end
@interface SBIconView : UIView
@property (nonatomic, retain) SBIcon* icon;
@end
@interface SBIconModel : NSObject
-(id)expectedIconForDisplayIdentifier:(NSString*)ident;
@end
@interface SBRootFolderController : NSObject
@property (nonatomic, retain) UIView* contentView;
@end
@interface SBIconController : NSObject
+(id)sharedInstance;
@property (nonatomic, retain) SBIconModel* model;
@property (nonatomic, assign) BOOL isEditing;
-(UIView*)currentRootIconList;
-(UIView*)dockListView;
-(SBRootFolderController*)_rootFolderController;
-(SBRootFolderController*)_currentFolderController;
-(void)clearHighlightedIcon;
-(NSInteger)currentIconListIndex;
-(void)removeIcon:(id)arg1 compactFolder:(BOOL)arg2;
-(id)insertIcon:(id)arg1 intoListView:(id)arg2 iconIndex:(long long)arg3 moveNow:(BOOL)arg4 pop:(BOOL)arg5;
-(id)rootFolder;
-(UIView*)iconListViewAtIndex:(NSInteger)index inFolder:(id)folder createIfNecessary:(BOOL)create;
-(BOOL)scrollToIconListAtIndex:(long long)arg1 animate:(BOOL)arg2;
-(NSArray*)allApplications;
-(BOOL)_canRevealShortcutMenu;
-(void)_revealMenuForIconView:(SBIconView*)icon presentImmediately:(BOOL)immediately;
-(void)_dismissShortcutMenuAnimated:(BOOL)animated completionHandler:(id)completionHandler;
@end
@interface SBApplicationShortcutMenuBackgroundView : UIView
@end
@class FBScene, FBWindowContextHostManager, FBSMutableSceneSettings;
extern "C" void BKSHIDServicesCancelTouchesOnMainDisplay();

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#ifdef __cplusplus
extern "C" {
#endif

CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);

#ifdef __cplusplus
}
#endif

@interface FBScene
- (id)contextHostManager;
- (id)mutableSettings;
-(void)_applyMutableSettings:(id)arg1 withTransitionContext:(id)arg2 completion:(id)arg3;
@end

@interface SBUIController : NSObject
+(id)sharedInstance;
-(void)clickedMenuButton;
@end

@interface FBWindowContextHostManager : NSObject
- (void)enableHostingForRequester:(id)arg1 orderFront:(BOOL)arg2;
- (void)enableHostingForRequester:(id)arg1 priority:(int)arg2;
- (void)disableHostingForRequester:(id)arg1;
- (id)hostViewForRequester:(id)arg1 enableAndOrderFront:(BOOL)arg2;
@end

@interface FBWindowContextHostView : UIView
- (BOOL)isHosting;
@end

@interface FBSMutableSceneSettings
- (void)setBackgrounded:(bool)arg1;
@end

@interface SBApplicationController
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(NSString *)bid;
@end

@interface UIApplication (Private)
- (void)_relaunchSpringBoardNow;
- (id)_accessibilityFrontMostApplication;
- (void)launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended;
- (id)displayIdentifier;
- (void)setStatusBarHidden:(bool)arg1 animated:(bool)arg2;
void receivedStatusBarChange(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo);
void receivedLandscapeRotate();
void receivedPortraitRotate();
@end

@interface SBBannerContextView : UIView
@end

@interface SBAppSwitcherModel : NSObject
+ (id)sharedInstance;
- (id)snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary;
@end

@interface SBAppSwitcherController : NSObject
- (id)_snapshotViewForDisplayItem:(id)arg1;
@end

@interface SBDisplayItem : NSObject
+ (id)displayItemWithType:(NSString *)arg1 displayIdentifier:(id)arg2;
@end

@interface SBAppSwitcherSnapshotView : NSObject
-(void)_loadSnapshotSync;
@end

@interface _UIBackdropViewSettings : NSObject
+(id)settingsForStyle:(NSInteger)style graphicsQuality:(NSInteger)quality;
+(id)settingsForStyle:(NSInteger)style;
-(void)setDefaultValues;
-(id)initWithDefaultValues;
@end
@interface _UIBackdropViewSettingsCombiner : _UIBackdropViewSettings
@end
@interface _UIBackdropView : UIView
-(id)initWithFrame:(CGRect)frame autosizesToFitSuperview:(BOOL)autoresizes settings:(_UIBackdropViewSettings*)settings;
@end

@interface SBAppToAppWorkspaceTransaction
- (void)begin;
- (id)initWithAlertManager:(id)alertManager exitedApp:(id)app;
- (id)initWithAlertManager:(id)arg1 from:(id)arg2 to:(id)arg3 withResult:(id)arg4;
- (id)initWithTransitionRequest:(id)arg1;
@end

@interface FBWorkspaceEvent : NSObject
+ (instancetype)eventWithName:(NSString *)label handler:(id)handler;
@end

@interface FBWorkspaceEventQueue : NSObject
+ (instancetype)sharedInstance;
- (void)executeOrAppendEvent:(FBWorkspaceEvent *)event;
@end
@interface SBDeactivationSettings
-(id)init;
-(void)setFlag:(int)flag forDeactivationSetting:(unsigned)deactivationSetting;
@end
@interface SBWorkspaceApplicationTransitionContext : NSObject
@property(nonatomic) _Bool animationDisabled; // @synthesize animationDisabled=_animationDisabled;
- (void)setEntity:(id)arg1 forLayoutRole:(int)arg2;
@end
@interface SBWorkspaceDeactivatingEntity
@property(nonatomic) long long layoutRole; // @synthesize layoutRole=_layoutRole;
+ (id)entity;
@end
@interface SBWorkspaceHomeScreenEntity : NSObject
@end
@interface SBMainWorkspaceTransitionRequest : NSObject
- (id)initWithDisplay:(id)arg1;
@end

static int const UITapticEngineFeedbackPeek = 1001;
static int const UITapticEngineFeedbackPop = 1002;
@interface UITapticEngine : NSObject
- (void)actuateFeedback:(int)arg1;
- (void)endUsingFeedback:(int)arg1;
- (void)prepareUsingFeedback:(int)arg1;
@end
@interface UIDevice (Private)
-(UITapticEngine*)_tapticEngine;
@end

OBJC_EXTERN UIImage* _UICreateScreenUIImage(void) NS_RETURNS_RETAINED;

@interface SBAppView : UIView
- (id)initWithApp:(id)arg1 referenceSize:(struct CGSize)arg2 orientation:(long long)arg3 display:(id)arg4 hostRequester:(id)arg5;
- (id)initWithApp:(id)arg1 referenceSize:(struct CGSize)arg2 orientation:(long long)arg3 display:(id)arg4;
@end

@interface FBSDisplay : NSObject
- (id)initWithCADisplay:(id)arg1;
- (id)initWithCADisplay:(id)arg1 isMainDisplay:(BOOL)arg2;
@end

@interface CADisplay : NSObject
+ (id)mainDisplay;
- (id)_initWithDisplay:(id)arg1;
@end
