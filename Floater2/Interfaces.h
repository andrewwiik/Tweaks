#define __is__iOS9__ [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0
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
- (void)setInterfaceOrientation:(int)orientation;
- (void)setFrame:(CGRect)frame;
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

@interface FBProcessManager : NSObject
+ (id)sharedInstance;
- (void)_updateWorkspaceLockedState;
- (void)applicationProcessWillLaunch:(id)arg1;
- (void)noteProcess:(id)arg1 didUpdateState:(id)arg2;
- (void)noteProcessDidExit:(id)arg1;
- (id)_serviceClientAddedWithPID:(int)arg1 isUIApp:(BOOL)arg2 isExtension:(BOOL)arg3 bundleID:(id)arg4;
- (id)_serviceClientAddedWithConnection:(id)arg1;
- (id)_systemServiceClientAdded:(id)arg1;
- (BOOL)_isWorkspaceLocked;
- (id)createApplicationProcessForBundleID:(id)arg1 withExecutionContext:(id)arg2;
- (id)createApplicationProcessForBundleID:(id)arg1;
- (id)applicationProcessForPID:(int)arg1;
- (id)processForPID:(int)arg1;
- (id)applicationProcessesForBundleIdentifier:(id)arg1;
- (id)processesForBundleIdentifier:(id)arg1;
- (id)allApplicationProcesses;
- (id)allProcesses;
@end
@interface UIView (Shit)
- (UIImage*)image;
@end
@interface FBDisplayManager
+ (id)mainDisplay;
@end
@interface FBSceneHostManager : NSObject
@end
@interface FBScene (Private)
@property (nonatomic, readonly, retain) FBSceneHostManager *contextHostManager;
@end
@interface FBSceneMonitor : NSObject
@property (nonatomic, readonly, retain) FBScene *scene;
@end

@interface SBMainSwitcherViewController : NSObject
+ (instancetype)sharedInstance;
- (void)_disableContextHostingForApp:(id)arg1;
@end

@interface SBAppView : UIView
- (id)initWithApp:(id)arg1 referenceSize:(CGSize)arg2 orientation:(long long)arg3 display:(id)arg4;
- (void)_configureViewForEffectiveDisplayMode:(long long)arg1;
- (void)_enableContextHosting;
- (void)_setEffectiveDisplayMode:(long long)arg1 options:(unsigned long long)arg2 withAnimationFactory:(id)arg3 completion:(id)arg4;
- (double)cornerRadius;
- (void)setDisplayMode:(long long)arg1 withAnimationFactory:(id)arg2 completion:(id)arg3;
- (id)_viewForDisplayMode:(long long)arg1;
- (void)invalidate;
- (FBSceneMonitor*)_sceneMonitor;
- (UIView*)contextHostViewForSceneMonitor;
- (void)setContextHostView:(id)arg1;
- (UIView*)_contextHostView;
- (void)_disableContextHosting;
+ (id)defaultDisplayModeAnimationFactory;
- (UIView*)_snapshotOrDefaultImageView;
@end
@interface SBAppContainerView : UIView
@property(retain, nonatomic) SBAppView *appView;
@end
@interface SBMainDisplayLayoutState : NSObject
- (id)_initWithElements:(id)arg1;
@end

@interface SBLayoutElement : NSObject
@end
@interface SBWorkspaceApplication : NSObject
+ (instancetype)entityForApplication:(id)arg1;
- (id)layoutElementForRole:(long long)arg1;
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
- (SBWorkspaceApplication*)workspaceEntity;
- (id)processState;
@end


@interface SBAppContainerViewController : UIViewController
// - (SBAppContainerView *)view;
- (id)initWithDisplay:(id)arg1;
- (void)configureWithEntity:(id)arg1 forElement:(id)arg2 layoutState:(id)arg3;
- (void)loadView;
- (void)_invalidateSceneDerivedObjects;
@end
@interface SBIcon : NSObject
@property (nonatomic, retain) NSString* applicationBundleID;
-(NSString*)displayNameForLocation:(NSInteger)location;
-(UIImage*)generateIconImage:(int)arg1;
@end
@interface SBApplicationIcon : NSObject
@property (nonatomic, retain) SBApplication* application;
-(id)initWithApplication:(id)application;
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
//extern "C" void BKSHIDServicesCancelTouchesOnMainDisplay();

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



@interface SBSceneLayoutViewController : UIViewController
+ (instancetype)mainDisplayLayoutViewController;
- (SBAppView*)appViewForWorkspaceApplication:(id)arg1;
@end

@interface _DECAppItem : NSObject
@property (nonatomic, readonly) NSString *bundleIdentifier;

+ (id)appWithBundleIdentifier:(id)arg1;
+ (BOOL)supportsSecureCoding;

- (id)bundleIdentifier;
- (id)description;
- (void)encodeWithCoder:(id)arg1;
- (unsigned int)hash;
- (id)initWithBundleIdentifier:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (BOOL)isEquivalent:(id)arg1;

@end

@interface _DECResult : NSObject
@property (nonatomic, readonly) unsigned int consumer;
@property (nonatomic, readonly) NSUUID *identifier;
@property (nonatomic) int reason;
@property (nonatomic, retain) NSDictionary *reasonMetadata;
@property (nonatomic, retain) NSDictionary *results;

+ (BOOL)supportsSecureCoding;

- (unsigned int)consumer;
- (id)description;
- (void)encodeWithCoder:(id)arg1;
- (id)identifier;
- (id)initWithCoder:(id)arg1;
- (id)initWithConsumer:(unsigned int)arg1;
- (BOOL)isEqual:(id)arg1;
- (int)reason;
- (id)reasonMetadata;
- (id)resultForCategory:(unsigned int)arg1;
- (id)results;
- (void)setReason:(int)arg1;
- (void)setReasonMetadata:(id)arg1;
- (void)setResults:(id)arg1;

@end
@interface SBBestAppSuggestion : NSObject

- (_Bool)isArrivedAtHomePrediction;
- (_Bool)isArrivedAtWorkPrediction;
- (_Bool)isFirstWakePrediction;
- (_Bool)isCarPlayPrediction;
- (_Bool)isBluetoothAudioPrediction;
- (_Bool)isBluetoothPrediction;
- (_Bool)isHeadphonesPrediction;
- (_Bool)isPrediction;
- (_Bool)isLocationBasedSuggestion;
- (_Bool)isSiriSuggestion;
- (_Bool)isLocallyGeneratedSuggestion;
- (_Bool)isCallContinuitySuggestion;
- (_Bool)isOpenURLSuggestion;
- (_Bool)isNotificationSuggestion;
@property(readonly, copy) NSString *originatingDeviceType;
@property(readonly, copy) NSString *originatingDeviceName;
@property(readonly, copy) NSString *originatingDeviceIdentifier;
@property(readonly, copy) NSDate *lastUpdateTime;
@property(readonly, copy) NSString *activityType;
@property(readonly, copy) NSString *bundleIdentifier;
@property(readonly, copy) NSUUID *uniqueIdentifier;

@end
@interface _SBExpertAppSuggestion : SBBestAppSuggestion

@property(readonly, retain, nonatomic) _DECResult *result; // @synthesize result=_result;
@property(readonly, retain, nonatomic) _DECAppItem *appSuggestion; // @synthesize appSuggestion=_appSuggestion;
- (unsigned long long)hash;
- (_Bool)isEqual:(id)arg1;
- (_Bool)isArrivedAtHomePrediction;
- (_Bool)isArrivedAtWorkPrediction;
- (_Bool)isFirstWakePrediction;
- (_Bool)isCarPlayPrediction;
- (_Bool)isBluetoothAudioPrediction;
- (_Bool)isBluetoothPrediction;
- (_Bool)isHeadphonesPrediction;
- (_Bool)isPrediction;
- (_Bool)isLocallyGeneratedSuggestion;
- (id)originatingDeviceName;
- (_Bool)isLocationBasedSuggestion;
- (id)bundleIdentifier;
@property(readonly, retain, nonatomic) NSUUID *resultUUID;
- (void)dealloc;
- (id)initWithAppSuggestion:(id)arg1 result:(id)arg2;

@end

@interface SBSwitcherAppSuggestionSlideUpView : UIView
@property (nonatomic, retain) SBAppView *appView;
- (id)initWithFrame:(CGRect)arg1 appSuggestion:(id)arg2;
- (void)setAppView;
@end

@interface SBMedusaAppsTestRecipe : NSObject
- (void)_bringToForeground:(id)arg1 withFrame:(CGRect)arg2;
- (void)_sendToBackground:(id)arg1;
@end

@interface SBAppResizingPlaceholderView : UIView
- (id)initWithAppView:(id)arg1;
- (void)setAppIconView:(id)arg1;
@end


@interface SBSceneViewAppIconView : UIView
- (id)initWithIcon:(id)arg1;
@end
@interface FBSSceneSettings : NSObject
- (CGRect)frame;
@end
@interface FBSScene : NSObject
@property (nonatomic, readonly, copy) NSString *identifier;
@property (nonatomic, readonly, retain) FBSSceneSettings *settings;

// Image: /System/Library/PrivateFrameworks/FrontBoardServices.framework/FrontBoardServices

- (id)_init;
- (BOOL)_performSnapshotRequestType:(unsigned int)arg1 withContext:(id)arg2;
- (void)attachContext:(id)arg1;
- (void)attachLayer:(id)arg1;
- (void)attachSceneContext:(id)arg1;
- (id)clientSettings;
- (id)contexts;
- (id)delegate;
- (id)descriptionBuilderWithMultilinePrefix:(id)arg1;
- (id)descriptionWithMultilinePrefix:(id)arg1;
- (void)detachContext:(id)arg1;
- (void)detachLayer:(id)arg1;
- (void)detachSceneContext:(id)arg1;
- (id)display;
- (id)fbsDisplay;
- (NSString*)identifier;
- (id)init;
- (id)initWithQueue:(id)arg1 identifier:(id)arg2 display:(id)arg3 settings:(id)arg4 clientSettings:(id)arg5;
- (void)invalidate;
- (BOOL)invalidateSnapshotWithContext:(id)arg1;
- (id)layers;
- (BOOL)performSnapshotWithContext:(id)arg1;
- (void)sendActions:(id)arg1;
- (void)setDelegate:(id)arg1;
- (id)settings;
- (id)snapshotRequest;
- (void)updateClientSettings:(id)arg1 withTransitionContext:(id)arg2;
- (void)updateClientSettingsWithBlock:(id /* block */)arg1;
- (void)updateClientSettingsWithTransitionBlock:(id /* block */)arg1;

// Image: /System/Library/Frameworks/UIKit.framework/UIKit

- (BOOL)uiCanReceiveDeviceOrientationEvents;
- (id)uiClientSettings;
- (id)uiSettings;
- (void)updateUIClientSettingsWithBlock:(id /* block */)arg1;
- (void)updateUIClientSettingsWithTransitionBlock:(id /* block */)arg1;

@end

@interface FBSSceneImpl : FBSScene
@end

OBJC_EXTERN UIImage* _UICreateScreenUIImage(void) NS_RETURNS_RETAINED;