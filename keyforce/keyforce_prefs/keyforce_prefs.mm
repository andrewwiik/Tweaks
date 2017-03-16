#import <Preferences/Preferences.h>

@interface keyforce_prefsListController: PSListController {
}
@end

@implementation keyforce_prefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"keyforce_prefs" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
