#import "headers.h"

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
+ (UIImage *)sectionImage {
	return [[UIImage imageNamed:@"Settings_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
%end