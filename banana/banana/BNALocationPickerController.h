#import <Preferences/PSViewController.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "../headers.h"
#import "BNAConfigurationListController.h"

@interface PSViewController (BNAPrivate)
- (void)dismissAnimated:(BOOL)arg1;
@end

@interface BNALocationPickerController : PSViewController <UISearchBarDelegate, UISearchControllerDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
// Search
@property (strong, nonatomic) UISearchController *locationSearchController;
@property (strong, nonatomic) MKLocalSearchCompleter *localSearchCompleter;
@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) City *selectedCity;
@property (strong, nonatomic) BNAConfigurationListController *delegate;

- (BNAConfigurationListController *)backViewController;
- (void)cancelButtonPressed;

@end