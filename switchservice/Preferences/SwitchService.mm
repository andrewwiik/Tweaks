#import <Preferences/PSListController.h>

@interface SwitchServiceListController: PSListController {
}
@end

@implementation SwitchServiceListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"SwitchService" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
