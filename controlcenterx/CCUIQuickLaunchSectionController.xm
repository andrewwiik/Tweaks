#import "headers.h"

%hook CCUIQuickLaunchSectionController
%new
+ (NSString *)sectionIdentifier {
	return @"com.apple.controlcenter.quick-launch";
}
%new
+ (NSString *)sectionName {
	return @"Shortcuts";
}
%new
+ (UIImage *)sectionImage {
	return [[UIImage imageNamed:@"Shortcuts_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
%new
+ (Class)settingsControllerClass {
	return NSClassFromString(@"CCXSectionObject");
}
%end