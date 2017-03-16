//
//  BTOActionSearchViewController.h
//  test
//
//  Created by Brian Olencki on 11/8/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

@interface PSViewController ()
- (void)viewDidLoad;
- (UIView*)view;
- (void)presentViewController:(id)arg1 animated:(BOOL)arg2 completion:(/*^block*/id)arg3 ;
@end
@interface BTOActionSearchViewController : PSViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    NSMutableArray *aryTableView;
    UITableView *tblActions;
    UIRefreshControl *refreshControl;

    NSString *urlString;
}

@end
