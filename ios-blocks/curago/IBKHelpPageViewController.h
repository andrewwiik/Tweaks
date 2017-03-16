//
//  IBKHelpPageViewController.h
//  curago
//
//  Created by Matt Clarke on 21/03/2015.
//
//

#import <UIKit/UIKit.h>

@interface IBKHelpPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) NSString *bundleIdentifier;
@property (nonatomic, strong) NSArray *viewCs;

@end
