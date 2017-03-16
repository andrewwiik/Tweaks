#import <Preferences/Preferences.h>

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
- (void)openGithubPage {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/bolencki13/Point-And-Shoot"]];//url to github
}
@end

// vim:ft=objc
