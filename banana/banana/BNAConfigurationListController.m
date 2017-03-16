#include "BNAConfigurationListController.h"
#import "CWStatusBarNotification.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTextFieldSpecifier.h>


@implementation BNAConfigurationListController
- (NSArray *)specifiers {

	if (!_specifiers) {
  _prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.creatix.banana"];
	_specifiers = [self loadSpecifiersFromPlistName:@"Configuration" target:self];
	NSMutableArray *modifiedSpecs = [NSMutableArray new];
  PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:@""
							target:self
							   set:NULL
							   get:NULL
							detail:Nil
							  cell:-1
							  edit:Nil];
  [specifier setProperty:NSClassFromString(@"ACUIAppInstallCell") forKey:@"cellClass"];
  [specifier setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/Banana.bundle/configuration.png"] forKey:@"ACUIAppInstallIcon"];
  [specifier setProperty:@"Banana" forKey:@"ACUIAppInstallPublisher"];
  [specifier setProperty:@"Configuration" forKey:@"ACUIAppInstallName"];
  [specifier setProperty:[NSNumber numberWithInt:81] forKey:@"height"];
  [specifier setProperty:@YES forKey:@"ACUIAppIsAvailable"];
  [specifier setProperty:@YES forKey:@"enabled"];
  [specifier setProperty:@YES forKey:@"Custom"];
  [specifier setProperty:@"RESET" forKey:@"CustomTitle"];
  [specifier setProperty:@"RESET NOW" forKey:@"CustomConfirmation"];
  [specifier setProperty:@YES forKey:@"ResetButton"];
  [modifiedSpecs addObject:specifier];

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
}
- (BOOL)resetSettings {
  CWStatusBarNotification *notification = [CWStatusBarNotification new];
  notification.notificationLabelBackgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.957 alpha:1];
  notification.notificationLabelTextColor = [UIColor blackColor];
  [notification displayNotificationWithMessage:[NSString stringWithFormat:@"Configuration settings were reset to their defaults."]
                           forDuration:2.0f];
  notification = nil;
  [self reload];
   CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.creatix.banana/settingschanged"), NULL, NULL, TRUE);
  return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)selectedCity:(City *)city {
  [_prefs setObject:[city dictionaryRepresentation] forKey:@"customCity"];
}


@end

