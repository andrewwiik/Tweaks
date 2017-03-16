#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
#import "BTOAddShortCutViewController.h"
#import "BTOOptionsViewController.h"
#import "BTOActionSearchViewController.h"

@interface PSViewController ()
- (void)viewDidLoad;
- (UIView*)view;
- (void)presentViewController:(id)arg1 animated:(BOOL)arg2 completion:(/*^block*/id)arg3 ;
@end

@interface CustomFTListController: PSViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *aryShortCuts;
    UITableView *tblShortCuts;
    UIRefreshControl *refreshControl;
}
@end

#define DONATE (@"Donations accepted.\nThe developer put a lot\nof time and effort into this tweak.")
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CustomFTListController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Traverse";
    self.view.backgroundColor = [UIColor whiteColor];
    [self getAllObjects];

		UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		btnEdit.frame = CGRectMake(0,0,20,20);
		[btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
		[btnEdit addTarget:self action:@selector(editTable) forControlEvents:UIControlEventTouchUpInside];
		[btnEdit setShowsTouchWhenHighlighted:YES];
		[btnEdit sizeToFit];
		UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
		[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:buttonBar, nil] animated:NO];

    UIButton *btnDatabase = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDatabase addTarget:self action:@selector(dataBase) forControlEvents:UIControlEventTouchUpInside];
    [btnDatabase setBackgroundColor:UIColorFromRGB(0x27AE60)];
    [btnDatabase setFrame:CGRectMake(0, 70, SCREEN.size.width/2, 50)];
    [btnDatabase setTitle:@"Database" forState:UIControlStateNormal];
    btnDatabase.showsTouchWhenHighlighted = YES;
    [self.view addSubview:btnDatabase];

    UIButton *btnOptions = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOptions addTarget:self action:@selector(options) forControlEvents:UIControlEventTouchUpInside];
    [btnOptions setBackgroundColor:UIColorFromRGB(0x2980b9)];
    [btnOptions setFrame:CGRectMake(SCREEN.size.width/2, 70, SCREEN.size.width/2, 50)];
    [btnOptions setTitle:@"Options" forState:UIControlStateNormal];
    btnOptions.showsTouchWhenHighlighted = YES;
    [self.view addSubview:btnOptions];

    CGRect frame = CGRectMake(0,200,self.view.bounds.size.width,self.view.bounds.size.height-200);
    if (self.view.bounds.size.width > 400) {
      frame.size.width = 400;
    }
    tblShortCuts = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tblShortCuts.dataSource = self;
    tblShortCuts.delegate = self;
    // tblShortCuts.backgroundColor = UIColorFromRGB(0xf39c12);
    [self.view addSubview:tblShortCuts];

    UIButton *btnDonations = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDonations addTarget:self action:@selector(donate) forControlEvents:UIControlEventTouchUpInside];
    [btnDonations setBackgroundColor:UIColorFromRGB(0xf39c12)];
    [btnDonations setFrame:CGRectMake(0, 120, SCREEN.size.width, 80)];
    [btnDonations setTitle:DONATE forState:UIControlStateNormal];
    [btnDonations.titleLabel setNumberOfLines:0];
    [btnDonations.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btnDonations setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnDonations.showsTouchWhenHighlighted = YES;
    [self.view addSubview:btnDonations];

    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [tblShortCuts addSubview:refreshControl];
}

#pragma mark - UIButton Functions
- (void)editTable {
		if ([tblShortCuts isEditing] == YES) {
        [tblShortCuts setEditing:NO animated:YES];
				[[self navigationItem] setLeftBarButtonItem:nil];
    } else {
        [tblShortCuts setEditing:YES animated:YES];

				UIButton *btnAddCell = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				btnAddCell.frame = CGRectMake(0,0,20,20);
				[btnAddCell setTitle:@"  +  " forState:UIControlStateNormal];
				[btnAddCell addTarget:self action:@selector(addTableCell) forControlEvents:UIControlEventTouchUpInside];
				[btnAddCell setShowsTouchWhenHighlighted:YES];
				[btnAddCell sizeToFit];
				UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:btnAddCell];
				UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
				negativeSpacer.width = 0;
				[self.navigationItem setLeftBarButtonItem:buttonBar animated:NO];
    }
}
- (void)addTableCell {
    BTOAddShortCutViewController *controller = [BTOAddShortCutViewController new];
    controller.isOutsideSettings = NO;

    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigation animated:YES completion:nil];
}
- (void)options {
  BTOOptionsViewController *controller = [BTOOptionsViewController new];
  UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
	[self presentViewController:navigation animated:YES completion:nil];
}
- (void)donate {
    SFSafariViewController *webViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=TFA6F7EYKKT7E&lc=US&item_name=3D%2b&item_number=com%2ebolencki13%2e3d%2b&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted"]];
    [self presentViewController:webViewController animated:YES completion:nil];
}
- (void)dataBase {
    [self pushController:[BTOActionSearchViewController new] animate:YES];
}

#pragma mark - RefreshTable
- (void)refreshTable {
    [refreshControl beginRefreshing];
    [self getAllObjects];
    [tblShortCuts reloadData];
    [refreshControl endRefreshing];
}
- (void)getAllObjects {
    NSDictionary *tempDict = [[BTOShortCutManager sharedInstance] getShortCuts];
    NSArray *keys = [tempDict allKeys];

    aryShortCuts = [[NSMutableArray alloc] init];

    for (NSString *key in keys) {
        if (![key isEqualToString:@"com.bolencki13.test-ShortCut"]) {
            NSArray *allObjects = [tempDict objectForKey:key];
            for (NSArray *object in allObjects) {
                NSString *text = [NSString stringWithFormat:@"%@-%@",[object objectAtIndex:2],[object objectAtIndex:0]];
                [aryShortCuts addObject:text];
            }
        }
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [aryShortCuts count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [aryShortCuts objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    // cell.backgroundColor = UIColorFromRGB(0xf39c12);

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  NSString *cellText = ((UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath]).textLabel.text;
  NSArray *listItems = [cellText componentsSeparatedByString:@"-"];
  NSString *identifier = [listItems objectAtIndex:0];
  NSString *title = [listItems objectAtIndex:([listItems count]-1)];
  NSArray *item = [[BTOShortCutManager sharedInstance] itemForBundleID:identifier withTitle:title];

  BTOAddShortCutViewController *controller = [BTOAddShortCutViewController new];
  [self presentViewController:controller animated:YES completion:^{
    controller.txtTitle.text = [item objectAtIndex:0];
    controller.txtSubTitle.text = [item objectAtIndex:1];
    controller.txtBundleID.text = [item objectAtIndex:2];
    [controller setURLText:[item objectAtIndex:3]];
    [controller setIconNumber:[[item objectAtIndex:4] intValue]];
  }];

  [[BTOShortCutManager sharedInstance] deleteShortCutWithBundleID:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
  [aryShortCuts removeObject:[aryShortCuts objectAtIndex:indexPath.row]];
  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Additional Options"] || [[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:DONATE] || [[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Shortcut Database"]) {
    return NO;
  } else {
    return YES;
  }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [[BTOShortCutManager sharedInstance] deleteShortCutWithBundleID:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        [aryShortCuts removeObject:[aryShortCuts objectAtIndex:indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end

// vim:ft=objc
