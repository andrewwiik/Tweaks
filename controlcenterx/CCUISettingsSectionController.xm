#import "headers.h"
#import "CCXSettingsFlipControlCenterViewController.h"

%hook CCUISettingsSectionController
%new
+ (NSString *)sectionIdentifier {
	return @"com.apple.controlcenter.settings";
}

%new
+ (NSString *)sectionName {
	return @"Toggles";
}

%new
+ (UIViewController *)configuredSettingsController {
	CCXSettingsFlipControlCenterViewController *viewController = [[NSClassFromString(@"CCXSettingsFlipControlCenterViewController") alloc] init];
	viewController.templateBundle = [[NSBundle alloc] initWithPath:@"/Library/Application Support/FlipControlCenter/TopShelf8.bundle"];
	viewController.settingsFile = @"/var/mobile/Library/Preferences/com.rpetrich.flipcontrolcenter.plist";
	viewController.preferencesApplicationID = @"com.rpetrich.flipcontrolcenter";
	viewController.notificationName = @"com.rpetrich.flipcontrolcenter.settingschanged";
	viewController.enabledKey = @"EnabledIdentifiers";
	viewController.disabledKey = @"DisabledIdentifiers";
	return viewController;
}

%new
+ (UIImage *)sectionImage {
	return [[UIImage imageNamed:@"Settings_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

%new
+ (Class)settingsControllerClass {
	return NSClassFromString(@"CCXSettingsFlipControlCenterViewController");
}
%end