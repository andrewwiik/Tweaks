#import "AWApolloListController.h"
#import "AWApolloPreferences.h"

#define tweakSettingsPath @"/User/Library/Preferences/com.atwiiks.apollo.plist"


@implementation AWApolloListController

- (id)specifiersForPlistName:(NSString *)plistName {
    NSArray *specs = [[self loadSpecifiersFromPlistName:plistName target:self] retain];
    return [[AWApolloLocalizer sharedLocalizer] localizedSpecifiersForSpecifiers:specs];
}

-(id) readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *tweakSettings = [NSDictionary dictionaryWithContentsOfFile:tweakSettingsPath];
    if (!tweakSettings[specifier.properties[@"key"]]) {
        return specifier.properties[@"default"];
    }
    return tweakSettings[specifier.properties[@"key"]];
}
 
-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:tweakSettingsPath]];
    [defaults setObject:value forKey:specifier.properties[@"key"]];
    [defaults writeToFile:tweakSettingsPath atomically:YES];
    CFStringRef tweakPost = (CFStringRef)specifier.properties[@"PostNotification"];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), tweakPost, NULL, NULL, YES);
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (iOS8) {
        self.navigationController.navigationController.navigationBar.tintColor = MAIN_TINTCOLOR;
        self.navigationController.navigationController.navigationBar.barTintColor = NAVBACKGROUND_TINTCOLOR;
        self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    } else {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        self.navigationController.navigationBar.tintColor = MAIN_TINTCOLOR;
        self.navigationController.navigationBar.barTintColor = NAVBACKGROUND_TINTCOLOR;
    }
    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = SWITCH_TINTCOLOR;

    prevStatusStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

   if (iOS8) {
        self.navigationController.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationController.navigationBar.barTintColor = nil;
        self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
    } else {
        self.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationBar.barTintColor = nil;
        self.navigationController.navigationBar.titleTextAttributes = nil;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:prevStatusStyle];
}

- (PSTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSTableCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    ((UILabel *)cell.titleLabel).textColor = LABEL_TINTCOLOR;
    return cell;
}

@end