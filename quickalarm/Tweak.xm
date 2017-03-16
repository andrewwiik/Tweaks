#define SCREEN ([UIScreen mainScreen].bounds)

@interface SBIconView : UIView
@property(nonatomic) _Bool isEditing;
- (void)setUpHoppinGestures;
- (void)changeGestures;
- (void)openMenuSwipe:(UISwipeGestureRecognizer *)sender;
- (void)openMenuHold:(UILongPressGestureRecognizer *)sender;
- (void)editActivate:(UISwipeGestureRecognizer *)sender;
- (void)disableAllGestures;
- (void)_handleSecondHalfLongPressTimer:(id)arg1;
+ (CGSize)defaultIconSize;
- (UIImageView *)_iconImageView;
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


@interface SBApplication : NSObject
@property(copy) NSString* displayIdentifier;
@property(copy) NSString* bundleIdentifier;
@property(copy, nonatomic) NSArray *dynamicShortcutItems;
@property(copy, nonatomic) NSArray *staticShortcutItems;
@end

@interface SBApplicationShortcutMenu : UIView
@property(retain, nonatomic) SBApplication *application;
@property(nonatomic, retain) SBIconView *iconView;
- (int)maxNumberOfShortcuts;
@end
@interface SBSApplicationShortcutItem : NSObject
- (void)setBundleIdentifierToLaunch:(id)arg1;
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
- (void)setUserInfo:(id)arg1;
- (void)setUserInfoData:(id)arg1;
@property (nonatomic, copy) NSString *bundleIdentifierToLaunch;
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, retain) NSData *userInfoData;
@end

@interface SBIconController : UIViewController
+ (id)sharedInstance;
- (void)_dismissShortcutMenuAnimated:(BOOL)arg1 completionHandler:(id)arg1;
@end

@interface SBApplicationShortcutMenuItemView : UIView

@property(retain, nonatomic) SBSApplicationShortcutItem *shortcutItem;
@property (nonatomic, retain) UISwitch *alarmSwitch;
@property (nonatomic) BOOL *highlighted;


@end


@interface SBApplicationShortcutStoreManager : NSObject

+ (id)sharedManager;
- (id)_stateLock_storeForBundleIdentifier:(id)arg1;
- (void)_installedAppsDidChange:(id)arg1;
- (void)saveSynchronously;
- (void)setShortcutItems:(id)arg1 forBundleIdentifier:(id)arg2;
- (NSMutableArray *)shortcutItemsForBundleIdentifier:(id)arg1;
- (id)init;

@end


%hook SBApplicationShortcutStoreManager
- (NSMutableArray*)shortcutItemsForBundleIdentifier:(NSString*)arg1 {
	if ([arg1 isEqualToString: @"com.apple.mobiletimer"]) {
		NSMutableArray *shortcuts = [NSMutableArray new];
		AlarmManager *manager = [%c(AlarmManager) sharedManager];
		[[%c(NotificationRelay) sharedRelay] refreshManagersForPreferences:YES localNotifications:YES];
		[manager loadAlarms];
		[manager loadScheduledNotifications];
		NSMutableArray *alarms = [manager alarms];
		
		for (Alarm *alarm in alarms) {
		NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
		[comps setHour:alarm.hour];
		[comps setMinute:alarm.minute];
		NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comps];
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"hh:mm a"];
		NSString* dateString = [formatter stringFromDate:date];
		
		 	NSString *alarmTitle = alarm.title;
		 	NSString *alarmID = alarm.alarmID;
		 	NSMutableDictionary *userInfoDict = [NSMutableDictionary new];
		 	[userInfoDict setObject: alarmID forKey:@"alarmID"];
		 	if (alarm.isActive) {
		 		[userInfoDict setObject:@"On" forKey:@"alarmState"];
		 	}
		 	else {
		 		[userInfoDict setObject:@"Off" forKey:@"alarmState"];
		 	}
		 	SBSApplicationShortcutItem *alarmShortcut = [[SBSApplicationShortcutItem alloc] init];
		 	[alarmShortcut setLocalizedTitle:alarmTitle];
		 	[alarmShortcut setLocalizedSubtitle:dateString];
		 	[alarmShortcut setUserInfo:userInfoDict];
		 	[alarmShortcut setType:@"com.apple.mobiletimer.alarm"];
		 	[shortcuts addObject:alarmShortcut];
		 }
		 return shortcuts;
	}
	else {
		return %orig;
	}


		/*NSArray *aryItems = [NSArray new];
		if (%orig != NULL || %orig != nil) {
			aryItems = %orig;
		}
		NSMutableArray *aryShortcuts = [aryItems mutableCopy];
		if ([[[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:arg1] badgeNumberOrString]) {
			SBSApplicationShortcutItem *newAction = [[SBSApplicationShortcutItem alloc] init];
			NSString *humanSub;
			if ([[NSString stringWithFormat:@"%@", [[[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:arg1] badgeNumberOrString]] isEqualToString: @"1"]) {
				humanSub = [NSString stringWithFormat:@"%@ Unread Notification", [[[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:arg1] badgeNumberOrString]];
			}
			else humanSub = [NSString stringWithFormat:@"%@ Unread Notifications", [[[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:arg1] badgeNumberOrString]];
    		//[newAction setIcon:[[SBSApplicationShortcutSystemIcon alloc] initWithType:UIApplicationShortcutIconTypeAdd]];
    		[newAction setLocalizedTitle:@"Clear Badge"];
    		[newAction setLocalizedSubtitle:humanSub];
    		[newAction setType:[NSString stringWithFormat:@"resetBadge"]];
    		[aryShortcuts addObject:newAction];
		}
		return aryShortcuts; */
}
%end

%hook SBApplicationShortcutMenuItemView

%property (nonatomic, retain) UISwitch *alarmSwitch;
///Icon courtesy of Icons8.com
- (void)_setupViewsWithIcon:(UIImage*)icon title:(NSString*)title subtitle:(NSString*)subtitle
{
	%orig;
	if ([self.shortcutItem.type isEqualToString: @"com.apple.mobiletimer.alarm"]) {
		UISwitch *onoff = [[UISwitch alloc] initWithFrame: CGRectMake(self.frame.size.width - 10,13,52,26)];
		onoff.transform = CGAffineTransformMakeScale(0.75, 0.75);
		if ([[self.shortcutItem.userInfo valueForKey:@"alarmState"] isEqualToString: @"On"]) {
			[onoff setOn:YES animated:NO];
		}
		else {
			[onoff setOn:NO animated:NO];
		}
		[onoff addTarget: self action: @selector(flip:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:onoff];
		self.alarmSwitch = onoff;
	}
   
}
- (void)layoutSubviews {
	%orig;
	if ([self.shortcutItem.type isEqualToString: @"com.apple.mobiletimer.alarm"]) {
		if (self.alarmSwitch) {
			self.alarmSwitch.frame = CGRectMake(self.frame.size.width - self.alarmSwitch.frame.size.width,((self.frame.size.height - self.alarmSwitch.frame.size.height)/2) *1.25 ,self.alarmSwitch.frame.size.width,self.alarmSwitch.frame.size.height);
		}
	}
}
%new
- (void)flip:(UISwitch *)sender {
	AlarmManager *manager = [%c(AlarmManager) sharedManager];
	if (sender.on) {
		[manager setAlarm:[manager alarmWithId:[self.shortcutItem.userInfo valueForKey:@"alarmID"]] active:YES];
		[manager updateAlarm:[manager alarmWithId:[self.shortcutItem.userInfo valueForKey:@"alarmID"]] active:YES];
		//Switched on

	}
	else  {
		// Switched Off
		[[manager alarmWithId:[self.shortcutItem.userInfo valueForKey:@"alarmID"]] cancelNotifications];
	}  
	[[%c(NotificationRelay) sharedRelay] refreshManagersForPreferences:YES localNotifications:YES];
}
%end

%hook SBApplicationShortcutMenu
- (void)menuContentView:(id)arg1 activateShortcutItem:(UIApplicationShortcutItem*)arg2 index:(long long)arg3 {
	NSString *shortcutType = arg2.type;
	if ([shortcutType isEqualToString: @"com.apple.mobiletimer.alarm"]) {
		SBApplicationShortcutMenuItemView *itemView = [MSHookIvar<NSMutableArray*>(arg1,"_itemViews") objectAtIndex:arg3];
		if (itemView.alarmSwitch.on) [itemView.alarmSwitch setOn:NO animated:YES];
		else [itemView.alarmSwitch setOn:YES animated:YES];
		[itemView flip:itemView.alarmSwitch];
		itemView.highlighted = NO;

		//[[self.iconView.icon application] setBadge:nil];

		//[[%c(SBIconController) sharedInstance] _dismissShortcutMenuAnimated:YES completionHandler:nil];
	}
	else {
		%orig;
	}
}

- (id)_shortcutItemsToDisplay {
	if ([self.application.bundleIdentifier isEqualToString: @"com.apple.mobiletimer.alarm"]) {
		NSMutableArray *shortcuts = [NSMutableArray new];
		for (NSUInteger i = 0; i < [[[%c(SBApplicationShortcutStoreManager) sharedManager] shortcutItemsForBundleIdentifier:self.application.bundleIdentifier] count] && i < [self maxNumberOfShortcuts]; i++) {
      		[shortcuts addObject:[[[%c(SBApplicationShortcutStoreManager) sharedManager] shortcutItemsForBundleIdentifier:self.application.bundleIdentifier] objectAtIndex: i]];
    	}
    	return [shortcuts copy];
	}
	else {
		return %orig;
	}
}

%new
- (int)maxNumberOfShortcuts {
    NSInteger shortcutHeight = [%c(SBIconView) defaultIconSize].width;
    //[self.iconView.superview convertPoint:self.iconView.frame.origin toView:nil] - [%c(SBIconView) defaultIconSize].height/2;
    NSInteger currentY = [[self.iconView _iconImageView] convertPoint:CGPointMake(0,0) toView:nil].y;
    int width = [%c(SBIconView) defaultIconSize].width;
    BOOL isUp = YES;
    if (currentY < SCREEN.size.height/2+20) {
        isUp = NO;
    }
    
    if (isUp == YES) {
        CGFloat sizeToTop = [[self.iconView _iconImageView] convertPoint:CGPointMake(0,0) toView:nil].y - width/4 - width/4;
        int yx = sizeToTop;
        return floor(yx/shortcutHeight);
    } else {

        CGFloat sizeToBottom = SCREEN.size.height - currentY - width/4 - width - width/5;
        return floor(sizeToBottom/shortcutHeight);
    }
}
%end