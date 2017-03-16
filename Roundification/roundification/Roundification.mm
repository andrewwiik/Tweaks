#import <Preferences/PSListController.h>

@interface RoundificationListController: PSListController {
}
@end

@implementation RoundificationListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Roundification" target:self];
	}
	return _specifiers;
}

-(void)saveSettings{
	#pragma GCC diagnostic push
	#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
	system("killall -9 backboardd");
	#pragma GCC diagnostic pop
}

// - (void)resetDefaults:(PSSpecifier *)spec {
// 	[self setPreferenceValue:YES specifer: [self speciferForId: @"ENABLED_NC"]];
// 	[self setPreferenceValue:YES specifer: [self speciferForId: @"ENABLED_CC"]];
// 	[self setPreferenceValue:YES specifer: [self speciferForId: @"ENABLED_BANNERS"]];
// 	[self setPreferenceValue:YES specifer: [self speciferForId: @"ENABLED_DOCK"]];
// 	[self setPreferenceValue:YES specifer: [self speciferForId: @"ENABLE_APP_CARDS"]];
// 	[self setPreferenceValue:NO specifer: [self speciferForId: @"SHOWSTATUS"]];
// 	[self setPreferenceValue:YES specifer: [self speciferForId: @"ENABLE_UI_ALERT_MENU"]];
// 	[self setPreferenceValue:20.0 specifer: [self speciferForId: @"BANNER_PADDING_SIDE"]];
// 	[self setPreferenceValue:25.0 specifer: [self speciferForId: @"BANNER_PADDING_TOP"]];
// 	[self setPreferenceValue:40.0 specifer: [self speciferForId: @"BANNER_PADDING_BOTTOM"]];
// 	[self setPreferenceValue:YES specifer: [self speciferForId: @"ENABLE_UI_TEXT_FIELD"]];
// 	[self setPreferenceValue:20.0 specifer: [self speciferForId: @"NC_CORNER_RADIUS"]];
// 	[self setPreferenceValue:20.0 specifer: [self speciferForId: @"DOCK_CORNER_RADIUS"]];
// 	[self setPreferenceValue:20.0 specifer: [self speciferForId: @"CC_CORNER_RADIUS"]];
// 	[self setPreferenceValue:20.0 specifer: [self speciferForId: @"APP_CARD_RADIUS"]];
// 	[self setPreferenceValue:20.0 specifer: [self speciferForId: @"ALERT_MENU_RADIUS"]];
// 	[self setPreferenceValue:15.0 specifer: [self speciferForId: @"TEXT_CORNER_RADIUS"]];
// 	[self setPreferenceValue:15.0 specifer: [self speciferForId: @"BANNER_CORNER_RADIUS"]];
// 	[self reloadSpecifiers];
	
// 	CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
//     CFNotificationCenterPostNotification(r, (CFStringRef)@"com.atrocity.roundification/prefsChanged", NULL, NULL, true);
// }

- (void)donateButton:(id)sender{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=HXGEK6Y8GJNVW&lc=US&item_name=ZachAtrocity&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted"]];
	
}

- (void)visitWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.zachatrocity.com"]];
}

- (void)visitTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/zachatrocity"]];
}

- (void)visitCreditsTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/highdetalio"]];
}

- (void)testBulletin:(id)sender {
	CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterPostNotification(r, (CFStringRef)@"com.atrocity.roundification/prefsChanged", NULL, NULL, true);
}
@end


// vim:ft=objc
