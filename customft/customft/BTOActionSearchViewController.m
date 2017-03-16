//
//  BTOActionSearchViewController.m
//  test
//
//  Created by Brian Olencki on 11/8/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import "BTOActionSearchViewController.h"
#import "BTOShortCutManager.h"

#define SCREEN ([UIScreen mainScreen].bounds)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define URL (@"http://traversedb.com")
#define URL_ALL (@"http://traversedb.com/json")
#define URL_SEARCH (@"http://traversedb.com/json/srs/")
#define URL_NUMBER (@"http://traversedb.com/json/conf/")
#define URL_DOWNLOADED (@"http://traversedb.com/in/")

@implementation BTOActionSearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!aryTableView) {
        aryTableView = [NSMutableArray new];
    }

    urlString = URL_ALL;
    [self getMoreActions];

    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnSearch.frame = CGRectMake(0,0,20,20);
    [btnSearch setTitle:@"Search" forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [btnSearch setShowsTouchWhenHighlighted:YES];
    [btnSearch sizeToFit];
    UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:buttonBar, nil] animated:NO];

    UIButton *btnDatabase = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDatabase addTarget:self action:@selector(website) forControlEvents:UIControlEventTouchUpInside];
    [btnDatabase setBackgroundColor:UIColorFromRGB(0x27AE60)];
    [btnDatabase setFrame:CGRectMake(0, 70, SCREEN.size.width, 50)];
    [btnDatabase setTitle:@"http://traversedb.com" forState:UIControlStateNormal];
    [self.view addSubview:btnDatabase];

    CGRect frame = CGRectMake(0,150,self.view.bounds.size.width,self.view.bounds.size.height-150);
    if (self.view.bounds.size.width > 400) {
      frame.size.width = 400;
    }
    tblActions = [[UITableView alloc] initWithFrame:frame];
    tblActions.delegate = self;
    tblActions.dataSource = self;
    tblActions.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tblActions];

    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    [tblActions addSubview:refreshControl];
}

#pragma mark - Gather Data
- (void)getMoreActions {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [aryTableView removeAllObjects];

        NSURL *url = [NSURL URLWithString:urlString];
        NSData *jsonData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:nil error:nil];

        NSArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];

        for (NSDictionary *objectSet in json) {
            NSArray *aryItem = [[NSArray alloc] initWithObjects:[objectSet objectForKey:@"id"],[NSString stringWithFormat:@"%@-%@",[objectSet objectForKey:@"bundleId"],[objectSet objectForKey:@"title"]], nil];
            [aryTableView addObject:aryItem];
        }

        dispatch_async(dispatch_get_main_queue(), ^(void){
            [tblActions reloadData];
            [refreshControl endRefreshing];
            urlString = URL_ALL;
        });
    });
}

#pragma mark - UIButton Functions
- (void)search {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Traverse" message:@"Enter Search Paramaters" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Search", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"Search...";
    [alert show];
}
- (void)website {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([aryTableView count] > 0) {
        return [aryTableView count];
    } else {
        return 15;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    if (indexPath.row < [aryTableView count]) {
        cell.textLabel.text = [((NSArray*)[aryTableView objectAtIndex:indexPath.row]) objectAtIndex:1]; ;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *add = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@" Add Action " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSString *itemNumber = [((NSArray*)[aryTableView objectAtIndex:indexPath.row]) objectAtIndex:0];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_NUMBER,itemNumber]];
            NSData *jsonData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:nil error:nil];

            NSArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];

            for (NSDictionary *objectSet in json) {
                [[BTOShortCutManager sharedInstance] addShortCutWithTitle:[objectSet objectForKey:@"title"] withSubTitle:[objectSet objectForKey:@"subtitle"] withBundleID:[objectSet objectForKey:@"bundleId"] withURL:[objectSet objectForKey:@"url_scheme"] withIcon:[((NSString*)[objectSet objectForKey:@"icon"]) integerValue] withImage:@""];
                break;
            }

            [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_DOWNLOADED,itemNumber]]] returningResponse:nil error:nil];

            dispatch_async(dispatch_get_main_queue(), ^(void){
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Traverse"
                                            message:@"Shortcut Added"
                                            preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault
                                                           handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            });
        });
    }];
    add.backgroundColor = UIColorFromRGB(0x27AE60);

    return @[add];
}
- (void)refreshTable:(UIRefreshControl*)sender {
    [sender beginRefreshing];

    [aryTableView removeAllObjects];
    [self getMoreActions];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
      NSString *text = [alertView textFieldAtIndex:0].text;
      if ([text containsString:@" "]) {
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
      }
      urlString = [NSString stringWithFormat:@"%@%@",URL_SEARCH,text];
      [self getMoreActions];
    }
}
@end
