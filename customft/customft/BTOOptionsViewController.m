#import "BTOOptionsViewController.h"

#define SCREEN ([UIScreen mainScreen].bounds)

@implementation BTOOptionsViewController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"CustomFT_Options" target:self] retain];
	}
	return _specifiers;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Traverse";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}
- (void)back {
  [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showExample1 {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://iphonedevwiki.net/index.php/NSURL"]];
}
- (void)showExample2 {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://wiki.akosma.com/IPhone_URL_Schemes"]];
}
@end
