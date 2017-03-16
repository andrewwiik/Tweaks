#import <Preferences/PSListController.h>

@interface CarrotListController: PSListController {
}
@end

@implementation CarrotListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Carrot" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
