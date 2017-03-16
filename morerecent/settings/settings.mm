#import <Preferences/PSListController.h>

@interface settingsListController: PSListController {
}
@end

@implementation settingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"settings" target:self] retain];
	}
	return _specifiers;
}
@end



// vim:ft=objc
