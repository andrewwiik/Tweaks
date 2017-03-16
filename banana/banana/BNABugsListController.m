#include "BNABugsListController.h"
#import <CrashReport/libcrashreport.h>
#import <Preferences/PSSpecifier.h>
#import "../common/crashlog_util.h"

@implementation BNABugsListController

- (NSArray *)specifiers {

	if (!_specifiers) {
    _specifiers = [NSMutableArray new];
    _prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.creatix.banana"];
    NSMutableArray *modifiedSpecs = [NSMutableArray new];
    PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:@""
              target:self
                 set:NULL
                 get:NULL
              detail:Nil
                cell:-1
                edit:Nil];
  [specifier setProperty:NSClassFromString(@"ACUIAppInstallCell") forKey:@"cellClass"];
  [specifier setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/bugProduct.png"] forKey:@"ACUIAppInstallIcon"];
  [specifier setProperty:@"Banana" forKey:@"ACUIAppInstallPublisher"];
  [specifier setProperty:@"Bugs" forKey:@"ACUIAppInstallName"];
  [specifier setProperty:[NSNumber numberWithInt:81] forKey:@"height"];
  [specifier setProperty:@YES forKey:@"ACUIAppIsAvailable"];
  [specifier setProperty:@YES forKey:@"enabled"];
  [specifier setProperty:@YES forKey:@"Custom"];
  [specifier setProperty:@"CLEAR" forKey:@"CustomTitle"];
  [specifier setProperty:@"CLEAR NOW" forKey:@"CustomConfirmation"];
  [specifier setProperty:@YES forKey:@"ResetButton"];
  [modifiedSpecs addObject:specifier];

  PSSpecifier *crashesLabel = [PSSpecifier preferenceSpecifierNamed:@"Crashes"
          target:self
             set:NULL
             get:NULL
          detail:Nil
            cell:PSGroupCell
            edit:Nil];
  [crashesLabel setProperty:@"Crashes" forKey:@"label"];
  [crashesLabel setProperty:[NSNumber numberWithInt:0] forKey:@"footerAlignment"];
  [crashesLabel setProperty:[NSString stringWithFormat:@"Listed above are all the crashes that were possibly caused by Banana, you may select a crash to submit a bug report to us."] forKey:@"footerText"];
  [crashesLabel setProperty:@"CRASHES_LABEL" forKey:@"id"];
  [modifiedSpecs addObject:crashesLabel];

    [self loadCrashReports];
    NSMutableArray *crashes = _crashReports;
    for (NSString *crashPath in crashes) {
      PSSpecifier *spec = [PSSpecifier preferenceSpecifierNamed:@"title"
                                                            target:self
                                                               set:NULL
                                                               get:NULL
                                                            detail:NSClassFromString(@"BNABugSubmitListController")
                                                              cell:1
                                                              edit:Nil];
       [spec setProperty:NSClassFromString(@"BNACrashCell") forKey:@"cellClass"];
       [spec setProperty:crashPath forKey:@"crashPath"];
       [spec setProperty:NSClassFromString(@"BNABugSubmitListController") forKey:@"detail"];
       [spec setProperty:@YES forKey:@"enabled"];
       [spec setProperty:@YES forKey:@"isController"];
       [spec setProperty:[NSNumber numberWithFloat:50.0] forKey:@"height"];
       [modifiedSpecs addObject:spec];

    }
    [modifiedSpecs addObjectsFromArray:_specifiers];
    _specifiers = [modifiedSpecs copy];
  }
	return _specifiers;
}

- (void)loadView {
	[super loadView];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/heart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(heart)];
	self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:255.0f/255.0f
		green:58.0f/255.0f
		 blue:45.0f/255.0f
		alpha:1.0f];
  [self setTitle:[NSString stringWithFormat:@"Bugs"]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


- (void)loadCrashReports {
  _symbolicatedReports = [NSMutableArray new];
  _notSymbolicatedReports = [NSMutableArray new];
  NSString *crashLogsRoot = [NSString stringWithFormat:@"/User/Library/Logs/CrashReporter/"];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *crashLogsDirectoryContents = [fileManager contentsOfDirectoryAtPath:crashLogsRoot error:nil];
  NSPredicate *springboardFilter = [NSPredicate predicateWithFormat:@"self BEGINSWITH 'SpringBoard'"];
  NSPredicate *bananaFilter = [NSPredicate predicateWithFormat:@"self CONTAINS 'Banana'"];
  NSMutableArray *onlySpringBoard = [[crashLogsDirectoryContents filteredArrayUsingPredicate:springboardFilter] mutableCopy];
  NSMutableArray *crashReports = [NSMutableArray new];
  for (NSString *path in onlySpringBoard) {
    CRCrashReport *crash = [CRCrashReport crashReportWithFile:[NSString stringWithFormat:@"/User/Library/Logs/CrashReporter/%@", path] filterType:CRCrashReportFilterTypePackage];
    if (crash.isSymbolicated) {
      NSArray *blames = [crash.properties objectForKey:@"blame"];
      if (blames) {
        NSMutableArray *blamesFiltered = [[blames filteredArrayUsingPredicate:bananaFilter] mutableCopy];
        if ([blamesFiltered count] > 0) {
          [crashReports addObject:[NSString stringWithFormat:@"/User/Library/Logs/CrashReporter/%@", path]];
          NSString *syslogPath = syslogPathForFile([NSString stringWithFormat:@"/User/Library/Logs/CrashReporter/%@", path]);
          if (syslogPath) {
            NSMutableDictionary *props = [crash.properties mutableCopy];
            [props setObject:syslogPath forKey:@"syslog"];
            [props setObject:[NSString stringWithFormat:@"/User/Library/Logs/CrashReporter/%@", path] forKey:@"crashURL"];
            [crash setProperties:[props copy]];
          }
        }
      }
    }
  }
  _crashReports = crashReports;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}
- (void)sortBlame {

}
- (void)resetSettings {

}
@end

