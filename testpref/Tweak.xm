#import <Foundation/Foundation.h>
#import <Foundation/NSDistributedNotificationCenter.h>
#import <Preferences/Preferences.h>
@interface AXForceTouchController : UIViewController
- (NSArray*)customSpecifiers;
-(void)addSpecifiersFromArray:(id)arg1;
@end
%group TouchSettings
%hook AXForceTouchController
- (id)specifiers {
		bool first = (MSHookIvar<id>(self, "_specifiers") == nil);
		if(first) {
			%orig;
		NSMutableArray *ConditionalWiFiArray = MSHookIvar<id>(self, "_specifiers");
		NSLog(@"Origianl Specifers %@",ConditionalWiFiArray);
		NSArray *ConditionalWiFiSettings = [self customSpecifiers];
		NSLog(@"Conditional WiFi Settings %@",ConditionalWiFiSettings);
		[ConditionalWiFiArray addObjectsFromArray:ConditionalWiFiSettings];

	return ConditionalWiFiArray;
}
else {
	return MSHookIvar<id>(self, "_specifiers");
}
}
-(void)viewWillAppear:(BOOL)arg1 {
	%orig;
	self.view.center = CGPointMake(self.view.center.x,self.view.center.y + 44);
}
%new
-(void)asshole {

}
%new
-(NSArray *) customSpecifiers
{
    return @[
             @{ @"footerText": @"Quickly enable or disable Quick Access." },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.efrederickson.reachapp.settings",
                 @"key": @"ncAppEnabled",
                 @"label": @"Enabled",
                 @"PostNotification": @"com.efrederickson.reachapp.settings/reloadSettings",
                 },
             @{ @"footerText": @"Instead of using the app's name, the tab label will simply show \"App\"." },
             @{ 
                 @"cell": @"PSSwitchCell",
                 @"default": @NO,
                 @"defaults": @"com.efrederickson.reachapp.settings",
                 @"key": @"quickAccessUseGenericTabLabel",
                 @"label": @"Use Generic Tab Label",
                 @"PostNotification": @"com.efrederickson.reachapp.settings/reloadSettings",
                 },
             @{ @"footerText": @"Instead of displaying a label, this will completely hide the Quick Access tab on the Lock Screen." },
             @{ 
                 @"cell": @"PSSwitchCell",
                 @"default": @NO,
                 @"defaults": @"com.efrederickson.reachapp.settings",
                 @"key": @"ncAppHideOnLS",
                 @"label": @"Hide on Lock Screen",
                 @"PostNotification": @"com.efrederickson.reachapp.settings/reloadSettings",
                 },
                 @{ },
            @{
                 @"cell": @"PSLinkListCell",
                 @"detail": @"RANCAppSelectorView",
                 @"label": @"Selected App",
                 },
            ];
}
%end
%end
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	if ([((NSDictionary *)userInfo)[NSLoadedClasses] containsObject:@"AXForceTouchController"]) {
		%init(TouchSettings);
	}
}
 
%ctor {
	%init;
	CFNotificationCenterAddObserver(
		CFNotificationCenterGetLocalCenter(), NULL,
		notificationCallback,
		(CFStringRef)NSBundleDidLoadNotification,
		NULL, CFNotificationSuspensionBehaviorCoalesce);
}