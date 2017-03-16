#include "QCRSecurityListController.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <Preferences/PSSpecifier.h>
#import "CWStatusBarNotification.h"



@implementation QCRSecurityListController

- (NSArray *)specifiers {

	if (!_specifiers) {
  _prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.creatix.quickcenter"];
	_specifiers = [self loadSpecifiersFromPlistName:@"Security" target:self];
	NSMutableArray *modifiedSpecs = [NSMutableArray new];
  PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:@""
							target:self
							   set:NULL
							   get:NULL
							detail:Nil
							  cell:-1
							  edit:Nil];
  [specifier setProperty:NSClassFromString(@"ACUIAppInstallCell") forKey:@"cellClass"];
  [specifier setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/quickcenter.bundle/security.png"] forKey:@"ACUIAppInstallIcon"];
  [specifier setProperty:@"QuickCenter" forKey:@"ACUIAppInstallPublisher"];
  [specifier setProperty:@"Security" forKey:@"ACUIAppInstallName"];
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
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/quickcenter.bundle/heart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(heart)];
	self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:255.0f/255.0f
		green:58.0f/255.0f
		 blue:45.0f/255.0f
		alpha:1.0f];
  if ([_prefs synchronize]) {

  }
}
- (BOOL)resetSettings {
  [_prefs setBool:@YES forKey:@"inAppAccessEnabled"];
  [_prefs setBool:@YES forKey:@"lockScreenAccessEnabled"];
  [_prefs setBool:@YES forKey:@"wiFiLockAccessEnabled"];
  CWStatusBarNotification *notification = [CWStatusBarNotification new];
  notification.notificationLabelBackgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.957 alpha:1];
  notification.notificationLabelTextColor = [UIColor blackColor];
  [notification displayNotificationWithMessage:[NSString stringWithFormat:@"Security settings were reset to their defaults."]
                           forDuration:2.0f];
  notification = nil;
  [self reload];
  if ([_prefs synchronize]) {

  }
   CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.creatix.quickcenter/settingschanged"), NULL, NULL, TRUE);
  return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
@end

