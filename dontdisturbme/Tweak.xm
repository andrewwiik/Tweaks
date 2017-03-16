#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
@interface BBServer : NSObject
+ (id)sharedInstance;
@end
@interface BBSectionInfo : NSObject
- (void)setAllowsNotifications:(BOOL)arg1;
@property (nonatomic, copy) NSString *sectionID;
@end
%hook BBSectionInfo
%new
-(void)turnOffNOtifications {
	if (![self.sectionID isEqualToString:@"com.apple.mobiletimer"]) {
	[self setAllowsNotifications:FALSE];
}
else [self setAllowsNotifications:TRUE];
}
%new
-(void)turnOnNotifications {
	[self setAllowsNotifications:TRUE];
}
%end
%hook DoNotDisturbSwitch
-(void)applyState:(int)state forSwitchIdentifier:(id)identifier {
	if (state == 1) {
		BBServer *doNotDisturbServer = [%c(BBServer) sharedInstance];
		NSDictionary *AppNotificationOptions = MSHookIvar<id>(doNotDisturbServer, "_sectionInfoByID");
		NSArray *AppNotificationOptionsArray = [AppNotificationOptions allObjects];
		[AppNotificationOptionsArray makeObjectsPerformSelector:@selector(turnOffNOtifications)];
		NSLog(@"buttHead");	
	}
	else {
		BBServer *doNotDisturbServer = [%c(BBServer) sharedInstance];
		NSDictionary *AppNotificationOptions = MSHookIvar<id>(doNotDisturbServer, "_sectionInfoByID");
		NSArray *AppNotificationOptionsArray = [AppNotificationOptions allObjects];
		[AppNotificationOptionsArray makeObjectsPerformSelector:@selector(turnOnNotifications)];
		MSHookIvar<id>(doNotDisturbServer, "_sectionInfoByID"); 
		NSLog(@"butt Fuck");
	}
	%orig;
}
%end
%hook SBCCDoNotDisturbSetting
- (void)activate {
	%orig;
	NSLog(@"activating DND");
}
- (void)deactivate {
	%orig;
	NSLog(@"deactivating DND");
}
-(void)_setDNDStatus:(NSInteger)arg1 {
	%orig;
	NSLog(@"DND state changed");
}
-(void)_setDNDEnabled:(BOOL)arg1 updateServer:(BOOL)arg2 source:(NSUInteger)arg3 {
	if (arg1 == YES) {
		BBServer *doNotDisturbServer = [%c(BBServer) sharedInstance];
		NSDictionary *AppNotificationOptions = MSHookIvar<id>(doNotDisturbServer, "_sectionInfoByID");
		NSArray *AppNotificationOptionsArray = [AppNotificationOptions allObjects];
		[AppNotificationOptionsArray makeObjectsPerformSelector:@selector(turnOffNOtifications)];
		NSLog(@"buttHead");	
	}
	else {
		BBServer *doNotDisturbServer = [%c(BBServer) sharedInstance];
		NSDictionary *AppNotificationOptions = MSHookIvar<id>(doNotDisturbServer, "_sectionInfoByID");
		NSArray *AppNotificationOptionsArray = [AppNotificationOptions allObjects];
		[AppNotificationOptionsArray makeObjectsPerformSelector:@selector(turnOnNotifications)];
		MSHookIvar<id>(doNotDisturbServer, "_sectionInfoByID"); 
		NSLog(@"butt Fuck");
	}
	%orig;
}
%end