#import <Preferences/PSListController.h>

@interface MoreRecentListController: PSListController {
}
@end

@implementation MoreRecentListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"MoreRecent" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
