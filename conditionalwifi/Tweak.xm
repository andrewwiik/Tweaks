#include <substrate.h>
#include <CoreFoundation/CoreFoundation.h>
#include <notify.h>
#import <CFNetwork/CFNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

#if __cplusplus
extern "C" {
#endif

	CFSetRef SBSCopyDisplayIdentifiers();
	NSString * SBSCopyLocalizedApplicationNameForDisplayIdentifier(NSString *identifier);

#if __cplusplus
}
#endif

extern "C" CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);
extern "C" void BKSTerminateApplicationForReasonAndReportWithDescription(NSString *app, int a, int b, NSString *description);

61710 2400
@interface FBSSystemService : NSObject
+ (instancetype)sharedService;
- (void)terminateApplication:(NSString *)application forReason:(long long)reason andReport:(bool)shouldReport withDescription:(NSString *)description;
@end

typedef enum {
    ConnectionType3G,
    ConnectionTypeWiFi
} ConnectionType;


ConnectionType connectionType()
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, "8.8.8.8");
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        return ConnectionType3G;
    } else {
        return ConnectionTypeWiFi;
    }
}


%group Preferences

@interface APNetworksController : PSListController
@property (nonatomic, retain) NSMutableDictionary *wifiUsage;
@end

@interface APSettingsController : PSListController
@property (nonatomic, retain) NSMutableDictionary *wifiUsage;
@end

NSString *useWifiFor;
%hook APNetworksController
%property (nonatomic, retain) NSMutableDictionary *wifiUsage;

- (NSMutableArray *)specifiers {
    NSMutableArray *specifiers = %orig;
    NSArray *displayIdentifiers = [(__bridge NSSet *)SBSCopyDisplayIdentifiers() allObjects];
    NSMutableArray *applicationSpecifiers = [NSMutableArray new];
    if (!useWifiFor) {
    	NSString *useCellularDataFor = [[NSBundle bundleWithIdentifier:@"com.apple.preferences-ui-framework"] localizedStringForKey:@"USE_CELLULAR_DATA" value:@"" table:@"Network"];
		NSString *cellularData = [[NSBundle bundleWithIdentifier:@"com.apple.preferences-ui-framework"] localizedStringForKey:@"MOBILE_DATA_SETTINGS" value:@"" table:@"Network"];
		NSString *wifi = [[NSBundle bundleWithIdentifier:@"com.apple.settings.airport"] localizedStringForKey:@"Wi-Fi" value:@"" table:@"AirPort"];
		useWifiFor = [useCellularDataFor stringByReplacingOccurrencesOfString:cellularData withString:wifi];
    }

    PSSpecifier *wifiLabel = [%c(PSSpecifier) preferenceSpecifierNamed:useWifiFor
					target:self
					   set:NULL
					   get:NULL
					detail:Nil
					  cell:PSGroupCell
					  edit:Nil];

  	[wifiLabel setProperty:useWifiFor forKey:@"label"];
  	[wifiLabel setProperty:@"wifi_label" forKey:@"id"];
  	[specifiers addObject:wifiLabel];
  
  
    for (NSString *displayIdentifier in displayIdentifiers) {
        PSSpecifier *specifier = [%c(PSSpecifier) preferenceSpecifierNamed:SBSCopyLocalizedApplicationNameForDisplayIdentifier(displayIdentifier) target:self set:@selector(setWifiUsageValue:forSpecifier:) get:@selector(wifiUsageValueForSpecifier:) detail:nil cell:PSSwitchCell edit:nil];
        [specifier setProperty:displayIdentifier forKey:@"appIDForLazyIcon"];
        [specifier setProperty:@YES forKey:@"useLazyIcons"];
        [applicationSpecifiers addObject:specifier];
    }
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" 
    ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [applicationSpecifiers sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [specifiers addObjectsFromArray:applicationSpecifiers];
    return specifiers;
}

%new
- (void)setWifiUsageValue:(id)value forSpecifier:(PSSpecifier *)specifier {

	if (!self.wifiUsage) self.wifiUsage = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creatix.conditionalwifi.plist"];
	if (!self.wifiUsage) self.wifiUsage = [NSMutableDictionary new];
	[self.wifiUsage setObject:value forKey:[specifier propertyForKey:@"appIDForLazyIcon"]];

	if ([self.wifiUsage writeToFile:@"/User/Library/Preferences/com.creatix.conditionalwifi.plist" atomically:NO]) {

		NSMutableDictionary *userInfo = [NSMutableDictionary new];
		[userInfo setObject:[specifier propertyForKey:@"appIDForLazyIcon"] forKey:@"bundleID"];


		CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), CFSTR("com.creatix.conditionalwifi.settingsChanged"), NULL, (__bridge CFDictionaryRef)userInfo, YES);
	}
}
%new
- (id)wifiUsageValueForSpecifier:(PSSpecifier *)specifier {

	if (!self.wifiUsage) self.wifiUsage = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creatix.conditionalwifi.plist"];
    if (!self.wifiUsage) self.wifiUsage = [NSMutableDictionary new];

    if ([[self.wifiUsage objectForKey:[specifier propertyForKey:@"appIDForLazyIcon"]] isEqual: @NO]) return @NO;
    return @YES;
}
%end

%hook APSettingsController
%property (nonatomic, retain) NSMutableDictionary *wifiUsage;

- (NSMutableArray *)specifiers {
    NSMutableArray *specifiers = %orig;
    NSArray *displayIdentifiers = [(__bridge NSSet *)SBSCopyDisplayIdentifiers() allObjects];
    NSMutableArray *applicationSpecifiers = [NSMutableArray new];
    if (!useWifiFor) {
    	NSString *useCellularDataFor = [[NSBundle bundleWithIdentifier:@"com.apple.preferences-ui-framework"] localizedStringForKey:@"USE_CELLULAR_DATA" value:@"" table:@"Network"];
		NSString *cellularData = [[NSBundle bundleWithIdentifier:@"com.apple.preferences-ui-framework"] localizedStringForKey:@"MOBILE_DATA_SETTINGS" value:@"" table:@"Network"];
		NSString *wifi = [[NSBundle bundleWithIdentifier:@"com.apple.settings.airport"] localizedStringForKey:@"Wi-Fi" value:@"" table:@"AirPort"];
		useWifiFor = [useCellularDataFor stringByReplacingOccurrencesOfString:cellularData withString:wifi];
    }

    PSSpecifier *wifiLabel = [%c(PSSpecifier) preferenceSpecifierNamed:useWifiFor
					target:self
					   set:NULL
					   get:NULL
					detail:Nil
					  cell:PSGroupCell
					  edit:Nil];

  	[wifiLabel setProperty:useWifiFor forKey:@"label"];
  	[wifiLabel setProperty:@"wifi_label" forKey:@"id"];
  	[specifiers addObject:wifiLabel];
  
  
    for (NSString *displayIdentifier in displayIdentifiers) {
        PSSpecifier *specifier = [%c(PSSpecifier) preferenceSpecifierNamed:SBSCopyLocalizedApplicationNameForDisplayIdentifier(displayIdentifier) target:self set:@selector(setWifiUsageValue:forSpecifier:) get:@selector(wifiUsageValueForSpecifier:) detail:nil cell:PSSwitchCell edit:nil];
        [specifier setProperty:displayIdentifier forKey:@"appIDForLazyIcon"];
        [specifier setProperty:@YES forKey:@"useLazyIcons"];
        [applicationSpecifiers addObject:specifier];
    }
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" 
    ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [applicationSpecifiers sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [specifiers addObjectsFromArray:applicationSpecifiers];
    return specifiers;
}

%new
- (void)setWifiUsageValue:(id)value forSpecifier:(PSSpecifier *)specifier {

	if (!self.wifiUsage) self.wifiUsage = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creatix.conditionalwifi.plist"];
	if (!self.wifiUsage) self.wifiUsage = [NSMutableDictionary new];
	[self.wifiUsage setObject:value forKey:[specifier propertyForKey:@"appIDForLazyIcon"]];

	if ([self.wifiUsage writeToFile:@"/User/Library/Preferences/com.creatix.conditionalwifi.plist" atomically:NO]) {

		NSMutableDictionary *userInfo = [NSMutableDictionary new];
		[userInfo setObject:[specifier propertyForKey:@"appIDForLazyIcon"] forKey:@"bundleID"];


		CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), CFSTR("com.creatix.conditionalwifi.settingsChanged"), NULL, (__bridge CFDictionaryRef)userInfo, YES);
	}
}
%new
- (id)wifiUsageValueForSpecifier:(PSSpecifier *)specifier {

	if (!self.wifiUsage) self.wifiUsage = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creatix.conditionalwifi.plist"];
    if (!self.wifiUsage) self.wifiUsage = [NSMutableDictionary new];

    if ([[self.wifiUsage objectForKey:[specifier propertyForKey:@"appIDForLazyIcon"]] isEqual: @NO]) return @NO;
    return @YES;
}
%end
%end



// Initialize Preference App hooks because the Networks Bundle has loaded
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	if ([((__bridge NSDictionary *)userInfo)[NSLoadedClasses] containsObject:@"APNetworksController"]) { // The Network Bundle is Loaded
		%init(Preferences);
	}
}


// WiFi Access For Each App

// Blocking and Unblocking Internet
static BOOL internet = YES;
void (*orig_start)(id *self);
void end_tcp_now (id *self) {
	if (connectionType() != ConnectionTypeWiFi || internet == YES) {
		orig_start(self);
	}
}

static void wifiAccessChanged(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
 	
 	NSDictionary *userInfoDict = (__bridge NSDictionary *)userInfo;

	if ([[userInfoDict objectForKey:@"bundleID"] isEqualToString:@"com.apple.Preferences"]) {
	}
	else BKSTerminateApplicationForReasonAndReportWithDescription([userInfoDict objectForKey:@"bundleID"], 5, 1, @"ConditionalWiFi needed to kill the app");
}

void wifiSettingsReload() {
		NSDictionary *values = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.creatix.conditionalwifi.plist"];
		if ([values objectForKey:[NSBundle mainBundle].bundleIdentifier]) internet = [[values objectForKey:[NSBundle mainBundle].bundleIdentifier] boolValue];
}

%group UniversalApplicationDelegateHookMethodNotPresent
%hook UniversalApplicationDelegate
%new
- (void)applicationWillEnterForeground:(UIApplication *)application {
	wifiSettingsReload();
}
%end
%end

%group UniversalApplicationDelegateHookMethodPresent
%hook UniversalApplicationDelegate
- (void)applicationWillEnterForeground:(UIApplication *)application {
	wifiSettingsReload();
	%orig;
}
%end
%end

%group UniversalApplicationDelegateHook
%hook UniversalApplicationDelegate
+ (id)alloc {
   	%orig;
   	if ([self respondsToSelector:@selector(applicationWillEnterForeground:)]) {
   		%init(UniversalApplicationDelegateHookMethodPresent,UniversalApplicationDelegate=[[[UIApplication sharedApplication] delegate] class]);
   	}
   	else {
   		%init(UniversalApplicationDelegateHookMethodNotPresent,UniversalApplicationDelegate=[[[UIApplication sharedApplication] delegate] class]);
   	}
   	return %orig;
}

%new
- (void)turnOnAccess {
	internet = YES;
}
%new
- (void)turnOffAccess {
	internet = NO;
}
%new
- (BOOL)canAccessInternet {
	return internet;
}
%end
%end


void ApplicationDelegateHasLoaded() {
   %init(UniversalApplicationDelegateHook,UniversalApplicationDelegate=[[[UIApplication sharedApplication] delegate] class]);
}

%hook UIApplication
- (void)setDelegate:(id)delegate {
   %orig;
   ApplicationDelegateHasLoaded();
}
%end

%ctor {
	if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.Preferences"]) {
		CFNotificationCenterAddObserver(
			CFNotificationCenterGetLocalCenter(), NULL,
			notificationCallback,
			(CFStringRef)NSBundleDidLoadNotification,
			NULL, CFNotificationSuspensionBehaviorCoalesce);
	}
	if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
		CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(), NULL, wifiAccessChanged, CFSTR("com.creatix.conditionalwifi.settingsChanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	}
	%init;
	
	MSHookFunction((void *)MSFindSymbol(NULL,"_tcp_connection_start"), (void *)end_tcp_now, (void **)&orig_start);

	NSDictionary *values = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.creatix.conditionalwifi.plist"];
	if ([values objectForKey:[NSBundle mainBundle].bundleIdentifier]) internet = [[values objectForKey:[NSBundle mainBundle].bundleIdentifier] boolValue];
}





