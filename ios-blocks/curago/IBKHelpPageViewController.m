//
//  IBKHelpPageViewController.m
//  curago
//
//  Created by Matt Clarke on 21/03/2015.
//
//

#import "IBKHelpPageViewController.h"

@interface IBKHelpPageViewController ()

@end

@implementation IBKHelpPageViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initialiseWithBundleIdentifier:(NSString*)bundleIdentifer {
    self.bundleIdentifier = bundleIdentifer;
    
    // Setup data source.
    
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    // To the right
    int index = (int)[self.viewCs indexOfObject:viewController];
    
    if (index >= self.viewCs.count-1) {
        return nil;
    }
    
    return [self.viewCs objectAtIndex:index+1];
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    // To the left
    int index = (int)[self.viewCs indexOfObject:viewController];
    
    if (index <= 0) {
        return nil;
    }
    
    return [self.viewCs objectAtIndex:index-1];
}

@end
