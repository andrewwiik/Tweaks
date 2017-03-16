#import <Preferences/PSListController.h>

@interface PeekaBooListController: PSListController {
}
@end

@implementation PeekaBooListController
- (id)specifiers {
	if(_specifiers == nil) {
		//dlopen("/System/Library/PreferenceBundles/AccessibilitySettings.bundle/AccessibilitySettings", RTLD_LAZY | RTLD_NOLOAD);
		_specifiers = [[self loadSpecifiersFromPlistName:@"PeekaBoo" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
