#import <Preferences/PSListController.h>
#import "global.h"

#define TWEAK_NAME @"exsto"
#define TWEAK_BUNDLE_PATH [NSString stringWithFormat:@"/Library/PreferenceBundles/%@.bundle", TWEAK_NAME]

@interface exstoListController: PSListController {
}
@end

@implementation exstoListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"exsto" target:self];
	}
	return _specifiers;
}

-(void)viewDidLoad{
	[super viewDidLoad];
	UIImage* headerImage = [UIImage imageWithContentsOfFile:[TWEAK_BUNDLE_PATH stringByAppendingPathComponent:@"ExstoOutline"]];
	UIImageView * imageView = [[UIImageView alloc] initWithImage: headerImage];
	self.navigationItem.titleView = imageView;
}

- (void)visitTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/zachatrocity"]];
}

- (void)donateButton:(id)sender{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=HXGEK6Y8GJNVW&lc=US&item_name=ZachAtrocity&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted"]];
}

- (void)opencircleGithub:(id)sender{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/JaNd3r/CKCircleMenuView"]];
}


// vim:ft=objc
@end