
#import "BNALocationPickerController.h"
@implementation BNALocationPickerController
- (void)viewDidLoad {
	[super viewDidLoad];
	self.delegate = [self backViewController];
	
	// Keep the subviews inside the top and bottom layout guides
	self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
	// Fix black glow on navigation bar
	[self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
	
	// Set up search operators
	[self setupSearchController];
	[self setupSearchBar];
	
	// Should make search bar extend underneath status bar (DOES NOT WORK)
	self.definesPresentationContext = YES;
}

- (void)setupSearchController {
	
	// The TableViewController used to display the results of a search
	UITableViewController *locationSearchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
	locationSearchResultsController.automaticallyAdjustsScrollViewInsets = NO; // Remove table view insets
	locationSearchResultsController.tableView.dataSource = self;
	locationSearchResultsController.tableView.delegate = self;
	
	// Initialize our UISearchController
	self.locationSearchController = [[UISearchController alloc] initWithSearchResultsController:locationSearchResultsController];
	self.locationSearchController.delegate = self;
	self.locationSearchController.searchBar.delegate = self;

	self.localSearchCompleter = [[NSClassFromString(@"MKLocalSearchCompleter") alloc] init];

}
- (void)setupSearchBar {

	[self.view addSubview:self.locationSearchController.searchBar];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.locationSearchController.searchBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
  	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.locationSearchController.searchBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.locationSearchController.searchBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
	// Add SearchController's search bar to our view and bring it to front
	[self.view bringSubviewToFront:self.locationSearchController.searchBar];

}

- (void)searchLocation:(NSString *)query {
  // Cancel any previous searches.
  	[self.localSearchCompleter setFragment:query];
  	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;



	NSMutableArray *results = [NSMutableArray new];
	for (MKSearchCompletion *item in [self.localSearchCompleter results]) {
	  	City *city = [[NSClassFromString(@"City") alloc] init];
	  	city.searchCompletion = item;
	  	if ([item geoCompletionItem]) {
	  		if ([[item geoCompletionItem] entry]) {
	  			if ([[[item geoCompletionItem] entry] hasAddress]) {
	  				if ([[[[item geoCompletionItem] entry] address] hasCenter]) {
	  					CGFloat lat = [[[[[item geoCompletionItem] entry] address] center] lat];
	  					CGFloat lng = [[[[[item geoCompletionItem] entry] address] center] lng];
	  					city.latitude = (double)lat;
	  					city.longitude = (double)lng;
	  					[self setCityNameForCity:city];
	  					[results addObject:city];
	  				}
	  			}
	  		}
	  	}
	}
  self.results = results;

  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  [[(UITableViewController *)self.locationSearchController.searchResultsController tableView] reloadData];
  [(UITableViewController *)self.locationSearchController.searchResultsController tableView].frame = CGRectMake(0,self.view.frame.origin.y, [(UITableViewController *)self.locationSearchController.searchResultsController tableView].frame.size.width,[(UITableViewController *)self.locationSearchController.searchResultsController tableView].frame.size.height);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.results count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.locationSearchController setActive:NO];
    self.selectedCity = [self.results objectAtIndex:indexPath.row];
    [self.delegate selectedCity:(City *)[self.results objectAtIndex:indexPath.row]];

    //putting 1/3 of delay
}
- (void)setCityNameForCity:(City *)city;
 {
 	CLLocation *location = city.location;
      CLGeocoder *geocoder = [[CLGeocoder alloc] init];
      [geocoder reverseGeocodeLocation:location
               completionHandler:^(NSArray *array, NSError *error){
    if (error){
        NSLog(@"Geocode failed with error: %@", error);
        return;
    }
    CLPlacemark *placemark = [array objectAtIndex:0];
    ///NSLog(@"placemark: %@", placemark);
     city.name = [NSString stringWithFormat:@"%@", placemark.locality];
     return;
     }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *IDENTIFIER = @"SearchResultsCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
	}
	
	City *city = [self.results objectAtIndex:indexPath.row];
	[self setCityNameForCity:city];
	
	cell.textLabel.text = [city.searchCompletion queryLine];
	cell.detailTextLabel.text = city.name;
	return cell;
}
-(void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
	[self searchLocation:aSearchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	
	if (![searchText isEqualToString:@""]) {
		[self searchLocation:searchText];
	}
}
- (BNAConfigurationListController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;

    if (numberOfViewControllers < 2)
        return nil;
    else
        return (BNAConfigurationListController *)[self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}
@end

