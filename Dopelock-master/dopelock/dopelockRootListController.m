
#include "dopelockRootListController.h"

#import <Social/SLComposeViewController.h>
#import <Social/SLServiceTypes.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>
#import "Generic.h"

@implementation dopelockRootListController

- (NSArray *)specifiers {
if (!_specifiers) {
    _specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
}

return _specifiers;
}



-(void)loadView {
[super loadView];
	UIImage* image;
	image = [UIImage imageNamed:@"images/heart.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
	image = [image changeImageColor:[UIColor colorWithRed:0.17 green:0.24 blue:0.31 alpha:1.0]];
	CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
     
    [someButton addTarget:self action:@selector(heartWasTouched) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *heartButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    ((UINavigationItem*)self.navigationItem).rightBarButtonItem = heartButton;
}

-(void) viewWillAppear:(BOOL) animated{
[super viewWillAppear:animated];
UIView *header;
header = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, 60)];
UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, header.frame.size.width, header.frame.size.height - 10)];
label.text = @"DopeLock";
label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:48];
label.backgroundColor = [UIColor clearColor];
label.textColor = [UIColor colorWithRed:0.17 green:0.24 blue:0.31 alpha:1.0];
label.textAlignment = NSTextAlignmentCenter;

header.frame = CGRectMake(header.frame.origin.x, header.frame.origin.y, header.frame.size.width, header.frame.size.height + 35);
label.frame = CGRectMake(label.frame.origin.x, 10, label.frame.size.width, label.frame.size.height - 5);
[header addSubview:label];
UILabel *subText = [[UILabel alloc] initWithFrame:CGRectMake(header.frame.origin.x, label.frame.origin.y + label.frame.size.height, header.frame.size.width, 20)];
subText.text = @"Stay on top of your day, the dope way!";
subText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
subText.backgroundColor = [UIColor clearColor];
subText.textColor = [UIColor colorWithRed:0.17 green:0.24 blue:0.31 alpha:1.0];
subText.textAlignment = NSTextAlignmentCenter;

[header addSubview:subText];
[self.table setTableHeaderView:header];
	[super viewWillAppear:animated];
	[self setupHeader];
}

-(void)setupHeader{
	UIView *header = nil;
    header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    NSLog(@"%f", self.view.bounds.size.width);
    UIImage *headerImage;
    headerImage = [UIImage imageNamed:@"images/banner.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:headerImage];
    //header.frame = (CGRect){ header.frame.origin, headerImage.size };
    imageView.frame = CGRectMake(header.frame.origin.x, 10, self.view.bounds.size.width, 100);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [header addSubview:imageView];
    [self.table setTableHeaderView:header];
}

- (void)didRotateFromInterfaceOrientation:(long long)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self setupHeader];
}


-(void)respring
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
system("killall -9 SpringBoard");
#pragma clang diagnostic pop
}

-(void)emailDev {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:wizagesmax@gmail.com,ziph0ntweak@gmail.com?subject=DopeLock%20Support"]];
}


-(void)heartWasTouched
{
	SLComposeViewController *composeController = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
    [composeController setInitialText:@"Make your lockscreen dope using dopelock by @Wizages @Ziph0n @iBuzzeh"];
    
    [self presentViewController:composeController animated:YES completion:nil];
}

@end
