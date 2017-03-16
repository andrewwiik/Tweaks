//
//  IBKSetupViewController.m
//  curago
//
//  Created by Matt Clarke on 12/04/2015.
//
//

/*
 * When setting up, we must handle:
 * - introduction
 * - how to use
 * Default user settings:
 * - Basically, show parts of Advanced settings
 * And also auto-detection ("Just checking a few more things" + ask user) for if:
 * - "hover" mode is needed eg for GridLock
 * - the user has Gotham/Glyphs enabled for transparency
*/

#import "IBKSetupViewController.h"

@interface IBKSetupViewController ()

@end

@implementation IBKSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView {
    UIView *base = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    base.backgroundColor = [UIColor clearColor];
    
    self.view = base;
}

-(UIView*)view {
    if (!self.view) {
        [self loadView];
    }
    
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Animate rotation!
    
}

@end
