#import "CameraView.h"
#import "FlashLight.h"
#import <AudioToolbox/AudioServices.h>
#import <Social/Social.h>
#import <Twitter/TWTweetComposeViewController.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@interface UIForceGestureRecognizerQC : UILongPressGestureRecognizer
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(NSString *)bid;
@end
@interface SBApplicationShortcutStoreManager : NSObject
+ (instancetype)sharedManager;
- (id)shortcutItemsForBundleIdentifier:(id)arg1;
@end
@interface SBIconView : UIView
@property (nonatomic, retain) NSString *type;
@property(nonatomic) _Bool isEditing;
- (void)setUpHoppinGestures;
- (void)changeGestures;
- (void)openMenuSwipe:(UISwipeGestureRecognizer *)sender;
- (void)openMenuHold:(UILongPressGestureRecognizer *)sender;
- (void)editActivate:(UISwipeGestureRecognizer *)sender;
- (void)disableAllGestures;
- (void)_handleSecondHalfLongPressTimer:(id)arg1;
+ (CGSize)defaultIconImageSize;
- (UIImageView *)_iconImageView;
@end

@interface SBApplication : NSObject
@property(copy, nonatomic) NSArray *dynamicShortcutItems;
@property(copy, nonatomic) NSArray *staticShortcutItems;
- (NSString*)bundleIdentifier;
- (NSString*)displayName;
- (id)initWithApplicationInfo:(id)arg1 bundle:(id)arg2 infoDictionary:(id)arg3 entitlements:(id)arg4 usesVisibiliyOverride:(_Bool)arg5;
@end

@interface SBSApplicationShortcutItem : NSObject
- (void)setBundleIdentifierToLaunch:(id)arg1;
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(NSString *)arg1;
- (void)setUserInfo:(id)arg1;
- (void)setUserInfoData:(id)arg1;
@property (nonatomic, copy) NSString *bundleIdentifierToLaunch;
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, retain) NSData *userInfoData;
- (NSArray*)notAllowed;
@end

@interface SBIcon : NSObject
- (void)launchFromLocation:(int)location;
- (BOOL)isFolderIcon;// iOS 4+
- (NSString*)applicationBundleID;
- (SBApplication*)application;
- (id)generateIconImage:(int)arg1;
- (id)displayName;
-(id)leafIdentifier;
- (id)displayNameForLocation:(int)arg1;
@end

@interface SBFolder : NSObject
- (SBIcon*)iconAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface SBFolderIcon : NSObject
- (SBFolder*)folder;
@end

@interface SBFolderIconView : SBIconView
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *CCAppBundleIdentifier;
@property (nonatomic, retain) UIForceGestureRecognizerQC *forcePressQC;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPressQC;
- (SBFolderIcon*)folderIcon;
@end


@interface SBIconView (Hoppin)
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUp;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDown;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUpEdit;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDownEdit;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPress;
@property (nonatomic, retain) UIForceGestureRecognizerQC *forcePress;
@end

@interface SBApplicationShortcutMenu : UIView <CameraViewDelegate>
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) AVCaptureSession *capture;
@property(retain, nonatomic) SBApplication *application;
@property(nonatomic, retain) SBFolderIconView *iconView;
@property(retain ,nonatomic) id applicationShortcutMenuDelegate;
- (void)_peekWithContentFraction:(double)arg1 smoothedBlurFraction:(double)arg2;
- (void)updateFromPressGestureRecognizer:(id)arg1;
- (void)menuContentView:(id)arg1 activateShortcutItem:(id)arg2 index:(long long)arg3;
- (void)dismissAnimated:(BOOL)arg1 completionHandler:(id)arg2;
- (id)initWithFrame:(CGRect)arg1 application:(id)arg2 iconView:(id)arg3 interactionProgress:(id)arg4 orientation:(long long)arg5;
- (void)presentAnimated:(_Bool)arg1;
- (void)interactionProgressDidUpdate:(id)arg1;
- (int)maxNumberOfShortcuts;
- (SBFolderIconView*)iconView;
- (void)_setupViews;
- (NSArray *)notAllowed;
- (void)setTransformedContainerView:(id)arg1;
- (BOOL)shortcutItemIsAllowed:(id)arg1;
+ (void)cancelPrepareForPotentialPresentationWithReason:(id)arg1;
- (void)_dismissAnimated:(_Bool)arg1 finishPeeking:(_Bool)arg2 ignorePresentState:(_Bool)arg3 completionHandler:(id)arg4;
@end

@interface UITouch (Private)
- (void)_setPressure:(float)arg1 resetPrevious:(BOOL)arg2;
- (float)_pathMajorRadius;
- (float)majorRadius;
- (id)_hidEvent;
@end

@interface SBIconController : UIViewController
@property (nonatomic, retain) NSMutableArray *controlCenterFolders;
@property(retain, nonatomic) SBApplicationShortcutMenu *presentedShortcutMenu;
+ (id)sharedInstance;
- (void)_revealMenuForIconView:(id)iconView presentImmediately:(BOOL)now;
- (void)_revealMenuForIconView:(id)iconView;
- (void)setIsEditing:(BOOL)arg1;
- (BOOL)isEditing;
- (void)_dismissShortcutMenuAnimated:(BOOL)arg1 completionHandler:(id)arg1;
- (void)_launchIcon:(id)icon;
- (void)_handleShortcutMenuPeek:(id)arg1;
- (id)presentedShortcutMenu;
- (void)applicationShortcutMenuDidPresent:(id)arg1;
@end

@interface UIApplicationShortcutItem (Private)

+ (unsigned int)_sbsActivationModeFromUIActivationMode:(unsigned int)arg1;
+ (unsigned int)_uiActivationModeFromSBSActivationMode:(unsigned int)arg1;
- (id)initWithSBSApplicationShortcutItem:(id)arg1;
@end
@interface SBSApplicationShortcutIcon : NSObject

@end

@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
@end

@interface SBSApplicationShortcutIcon (UF)
- (id)initWithType:(UIApplicationShortcutIconType)arg1;
@end

@interface SBSApplicationShortcutContactIcon : SBSApplicationShortcutIcon
-(instancetype)initWithContactIdentifier:(NSString *)contactIdentifier;
-(instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
-(instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName imageData:(NSData *)imageData;
@end

@interface SBCCWiFiSetting : NSObject
- (UIImage*)glyphImageForState:(int)arg1;
@end

@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
@property (nonatomic, readonly, retain) NSData *imagePNGData;
-(instancetype)initWithImagePNGData:(NSData *)imageData;
@end

@interface SBWebApplication : SBApplication
@end

@interface SBControlCenterController : UIViewController
+ (instancetype)sharedInstance;
@end
@interface SBApplicationShortcutMenuContentView : UIView
@property (nonatomic, assign) BOOL cameraOnScreen;
- (UILongPressGestureRecognizer *)highlightGesture;
- (void)_presentForFraction:(double)arg1;
- (void)_configureForMenuPosition:(NSInteger)arg1 menuItemCount:(NSInteger)arg2;
@end

@interface WFWiFiManager : NSObject
+(id)sharedInstance;
+(void)awakeFromBundle;
-(id)knownNetworks;
-(void)scan;
@end
@interface WiFiManager : NSObject
+(instancetype)sharedInstance;
@end
@interface SBControlCenterButton : UIView
@property (nonatomic, retain) SBFolderIconView *helpIconView;
@property (nonatomic, retain) SBApplicationShortcutMenu *shortcut;
-(UIImage*)_imageFromRect:(CGRect)arg1;
- (UIImage*)sourceGlyphImage;
- (UIImage*)_backgroundImage;
- (UIImage*)_backgroundImageWithGlyphImage:(UIImage*)arg1 state:(NSInteger)arg1;
+ (instancetype)_buttonWithBGImage:(id)arg1 glyphImage:(id)arg2 naturalHeight:(float)arg3;
- (void)testMenu:(id)iconView;
- (void)testABC;
- (void)add3DTouchHelpers;
@end

@interface SBApplicationShortcutMenuItemView : UIView
@property(retain, nonatomic) SBSApplicationShortcutItem *shortcutItem;
@property (nonatomic, retain) UISwitch *DnDSwitch;
@property (nonatomic, retain) UISwitch *alarmSwitchCC;
@property (nonatomic) BOOL *highlighted;
@end

@interface Alarm : NSObject

@property (getter=isActive, nonatomic, readonly) BOOL active;
@property (nonatomic, retain) NSString *alarmID;
@property (nonatomic, retain) NSURL *alarmIDURL;
@property (nonatomic) BOOL allowsSnooze;
@property (nonatomic) unsigned int daySetting;
@property (nonatomic, readonly) Alarm *editingProxy;
@property (nonatomic) unsigned int hour;
@property (nonatomic, readonly) NSDate *lastModified;
@property (nonatomic) unsigned int minute;
@property (nonatomic, readonly) UILocalNotification *notification;
@property (nonatomic, readonly) NSArray *repeatDays;
@property (nonatomic, readonly) BOOL repeats;
@property (nonatomic, readonly) unsigned int revision;
@property (nonatomic, readonly) NSDictionary *settings;
@property (getter=isSnoozed, nonatomic, readonly) BOOL snoozed;
@property (nonatomic, readonly) NSString *sound;
@property (nonatomic, readonly) int soundType;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, readonly) NSString *uiTitle;
@property (nonatomic, retain) NSString *vibrationID;

+ (id)_newSettingsFromNotification:(id)arg1;
+ (BOOL)_verifyNotificationSettings:(id)arg1 againstAlarmSettings:(id)arg2;
+ (BOOL)_verifyNotificationSettings:(id)arg1 againstUserInfo:(id)arg2;
+ (BOOL)isSnoozeNotification:(id)arg1;
+ (id /* block */)timeComparator;
+ (BOOL)verifyDaySetting:(id)arg1 withMessageList:(id)arg2;
+ (BOOL)verifyHourSetting:(id)arg1 withMessageList:(id)arg2;
+ (BOOL)verifyIdSetting:(id)arg1 withMessageList:(id)arg2;
+ (BOOL)verifyMinuteSetting:(id)arg1 withMessageList:(id)arg2;
+ (BOOL)verifySettings:(id)arg1;

- (id)_newBaseDateComponentsForDay:(int)arg1;
- (id)_newNotification:(int)arg1;
- (unsigned int)_notificationsCount;
- (id)alarmID;
- (id)alarmIDURL;
- (BOOL)allowsSnooze;
- (void)applyChangesFromEditingProxy;
- (void)applySettings:(id)arg1;
- (void)cancelNotifications;
- (int)compareTime:(id)arg1;
- (unsigned int)daySetting;
- (id)debugDescription;
- (id)delegate;
- (id)description;
- (void)dropEditingProxy;
- (void)dropNotifications;
- (id)editingProxy;
- (void)handleAlarmFired:(id)arg1;
- (void)handleNotificationSnoozed:(id)arg1 notifyDelegate:(BOOL)arg2;
- (unsigned int)hash;
- (unsigned int)hour;
- (id)init;
- (id)initWithDefaultValues;
- (id)initWithNotification:(id)arg1;
- (id)initWithSettings:(id)arg1;
- (BOOL)isActive;
- (BOOL)isEqual:(id)arg1;
- (BOOL)isSnoozed;
- (id)lastModified;
- (void)markModified;
- (unsigned int)minute;
- (id)nextFireDate;
- (id)nextFireDateAfterDate:(id)arg1;
- (id)nextFireDateAfterDate:(id)arg1 notification:(id)arg2 day:(int)arg3;
- (id)notification;
- (id)nowDateForOffsetCalculation;
- (void)prepareEditingProxy;
- (void)prepareNotifications;
- (void)refreshActiveState;
- (id)repeatDays;
- (BOOL)repeats;
- (unsigned int)revision;
- (void)scheduleNotifications;
- (void)setAlarmID:(id)arg1;
- (void)setAlarmIDURL:(id)arg1;
- (void)setAllowsSnooze:(BOOL)arg1;
- (void)setDaySetting:(unsigned int)arg1;
- (void)setDelegate:(id)arg1;
- (void)setHour:(unsigned int)arg1;
- (void)setMinute:(unsigned int)arg1;
- (void)setSound:(id)arg1 ofType:(int)arg2;
- (void)setTitle:(id)arg1;
- (void)setVibrationID:(id)arg1;
- (id)settings;
- (id)sound;
- (int)soundType;
- (id)timeZoneForOffsetCalculation;
- (id)title;
- (BOOL)tryAddNotification:(id)arg1;
- (id)uiTitle;
- (id)vibrationID;

@end



@interface AlarmManager : NSObject
@property (nonatomic, readonly) NSArray *alarms;
@property (nonatomic, readonly) NSString *defaultSound;
@property (nonatomic, readonly) int defaultSoundType;
@property (nonatomic, retain) NSString *defaultVibrationID;
@property (nonatomic) BOOL invalidAlarmsDetected;
@property (nonatomic, retain) NSDate *lastModified;
@property (nonatomic, retain) NSMutableArray *logMessageList;

+ (id)copyReadAlarmsFromPreferences;
+ (BOOL)discardOldVersion;
+ (BOOL)isAlarmNotification:(id)arg1;
+ (id)sharedManager;
+ (BOOL)upgrade;
+ (void)writeAlarmsToPreferences:(id)arg1;

- (void)addAlarm:(id)arg1 active:(BOOL)arg2;
- (void)addObserver:(id)arg1;
- (Alarm*)alarmWithId:(id)arg1;
- (id)alarmWithIdUrl:(id)arg1;
- (id)alarms;
- (BOOL)checkIfAlarmsModified;
- (void)countAlarmsInAggregateDictionary;
- (void)dealloc;
- (id)defaultSound;
- (int)defaultSoundType;
- (id)defaultVibrationID;
- (void)handleAlarm:(id)arg1 startedUsingSong:(id)arg2;
- (void)handleAlarm:(id)arg1 stoppedUsingSong:(id)arg2;
- (void)handleAnyNotificationChanges;
- (void)handleExpiredOrSnoozedNotificationsOnly:(id)arg1;
- (void)handleNotificationFired:(id)arg1;
- (void)handleNotificationSnoozed:(id)arg1;
- (id)init;
- (BOOL)invalidAlarmsDetected;
- (id)lastModified;
- (void)loadAlarms;
- (void)loadDefaultSoundAndType;
- (void)loadScheduledNotifications;
- (void)loadScheduledNotificationsWithCancelUnused:(BOOL)arg1;
- (id)logMessageList;
- (id)nextAlarmForDate:(id)arg1 activeOnly:(BOOL)arg2 allowRepeating:(BOOL)arg3;
- (void)reloadScheduledNotifications;
- (void)reloadScheduledNotificationsWithRefreshActive:(BOOL)arg1 cancelUnused:(BOOL)arg2;
- (void)removeAlarm:(id)arg1;
- (void)removeObserver:(id)arg1;
- (void)saveAlarms;
- (void)setAlarm:(id)arg1 active:(BOOL)arg2;
- (void)setDefaultSound:(id)arg1 ofType:(int)arg2;
- (void)setDefaultVibrationID:(id)arg1;
- (void)setInvalidAlarmsDetected:(BOOL)arg1;
- (void)setLastModified:(id)arg1;
- (void)setLogMessageList:(id)arg1;
- (void)unloadAlarms;
- (void)updateAlarm:(id)arg1 active:(BOOL)arg2;

@end

@interface NotificationRelay : NSObject

@property (nonatomic) BOOL refreshManagers;

+ (id)sharedRelay;

- (id)init;
- (BOOL)refreshManagers;
- (void)refreshManagersForPreferences:(BOOL)arg1 localNotifications:(BOOL)arg2;
- (void)relayFrameworkNotification:(id)arg1;
- (void)setRefreshManagers:(BOOL)arg1;

@end