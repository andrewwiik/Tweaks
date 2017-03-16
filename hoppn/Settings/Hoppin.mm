#import <Preferences/PSListController.h>
#include <dlfcn.h> // We need this to Bust Open the LS View
#import <objc/runtime.h> // I need to mess with runtime stuff too

@interface HoppinListController: PSListController {
}
@end

@implementation HoppinListController
- (id)specifiers {
	if(_specifiers == nil) {
		//dlopen("/System/Library/PreferenceBundles/AccessibilitySettings.bundle/AccessibilitySettings", RTLD_LAZY | RTLD_NOLOAD);
		_specifiers = [[self loadSpecifiersFromPlistName:@"Hoppin" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
