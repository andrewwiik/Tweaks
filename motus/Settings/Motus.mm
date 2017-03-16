#import <Preferences/PSListController.h>

@interface MotusListController: PSListController {
}
@end

@implementation MotusListController
- (id)specifiers {
	if(_specifiers == nil) {
		//dlopen("/System/Library/PreferenceBundles/AccessibilitySettings.bundle/AccessibilitySettings", RTLD_LAZY | RTLD_NOLOAD);
		_specifiers = [[self loadSpecifiersFromPlistName:@"Motus" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
