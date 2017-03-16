//
//  CVLaunchpadModalController.m
//  Convergance-Prefs
//
//  Created by Matt Clarke on 18/08/2014.
//
//

#import "CVLaunchpadModalController.h"

static NSBundle *strings = nil;

@interface CVLaunchpadModalController ()

@end

@implementation CVLaunchpadModalController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init {
    // setup data sauce.
    self = [super init];
    if (self) {
        // Setup data from online.
        
        // Order data sources alphabetically.
        
        // Table view.
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStyleGrouped];
        _table.rowHeight = 50;
        _table.allowsMultipleSelection = NO;
        _table.allowsSelection = YES;
        _table.dataSource = self;
        _table.delegate = self;
        
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tablecell"];
        
        self.view = _table;
        
        /*if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
            self.navigationController.navigationBar.translucent = YES;
        }*/
        
        if (!strings)
            strings = [[NSBundle alloc] initWithPath:@"/Library/PreferenceBundles/curago.bundle"];
        
        // Cancel button.
        if ([self respondsToSelector:@selector(navigationItem)]) {
            [[self navigationItem] setTitle:[strings localizedStringForKey:@"Help Center" value:@"Help Center" table:nil]];
        }
        
        // That's all folks.
        [_table reloadData];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancel:(id)sender {
    // Just hide our modal controller.
    [self.delegate.parentController dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [self.articleTitlesPerSection objectForKey:[NSNumber numberWithInteger:section]];
    return arr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Initialise cells.
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"tablecell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tablecell"];
    
    NSString *articleTitle = self.articleTitlesPerSection[[NSNumber numberWithInteger:indexPath.section]][indexPath.row];
    cell.textLabel.text = articleTitle;
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.headerNames[section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Move to new page containing help article.
}

@end
