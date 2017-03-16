#include "QCRRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <SafariServices/SFSafariViewController.h>
CGFloat secs = 0;

@interface UIResponder (FirstResponder)
+ (id)currentFirstResponder;
@end

static __weak id currentFirstResponder;
@implementation UIResponder (FirstResponder)
+ (id)currentFirstResponder {
  currentFirstResponder = nil;
  [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
  return currentFirstResponder;
}
- (void)findFirstResponder:(id)sender {
  currentFirstResponder = self;
}
@end

@implementation QCRRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
    _prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.creatix.quickcenter"];
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		NSMutableArray *modifiedSpecs = [NSMutableArray new];
		PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:@""
                                                        target:self
                                                           set:NULL
                                                           get:NULL
                                                        detail:Nil
                                                          cell:-1
                                                          edit:Nil];
            [specifier setProperty:NSClassFromString(@"ACUIAppInstallCell") forKey:@"cellClass"];
            [specifier setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/quickcenter.bundle/product.png"] forKey:@"ACUIAppInstallIcon"];
            [specifier setProperty:@"Creatix" forKey:@"ACUIAppInstallPublisher"];
            [specifier setProperty:@"QuickCenter" forKey:@"ACUIAppInstallName"];
            [specifier setProperty:[NSNumber numberWithInt:81] forKey:@"height"];
            [specifier setProperty:@YES forKey:@"ACUIAppIsAvailable"];
            [specifier setProperty:@YES forKey:@"enabled"];
            [specifier setProperty:@YES forKey:@"Custom"];
            [specifier setProperty:@"PURCHASED" forKey:@"CustomTitle"];
            [modifiedSpecs addObject:specifier];
            /*PSSpecifier* stepper = [PSSpecifier preferenceSpecifierNamed:@""
                                                        target:self
                                                           set:NULL
                                                           get:@selector(stringValueForSpecifier:)
                                                        detail:Nil
                                                          cell:4
                                                          edit:Nil];
            [stepper setProperty:NSClassFromString(@"AXEditableTableCellWithStepper") forKey:@"cellClass"];
            [stepper setProperty:@"NumericalPreferencePickerIdentifier" forKey:@"id"];
            [stepper setProperty:@"time" forKey:@"key"];
            [stepper setProperty:[NSNumber numberWithFloat:15.0] forKey:@"maximumValue"];
            [stepper setProperty:[NSNumber numberWithFloat:0.1] forKey:@"minimumValue"];
            [stepper setProperty:[NSNumber numberWithFloat:0.1] forKey:@"stepValue"];
            [modifiedSpecs addObject:stepper];*/
			[modifiedSpecs addObjectsFromArray:_specifiers];
			_specifiers = [modifiedSpecs copy];
      /*if ([_prefs boolForKey:@"Enabled"] == NO) {
       [[_specifiers specifierForID:@"CONFIGURATION"] setProperty:@NO forKey:@"enabled"];
       [[_specifiers specifierForID:@"SECURITY"] setProperty:@NO forKey:@"enabled"];
      }
      else {
      [[_specifiers specifierForID:@"CONFIGURATION"] setProperty:@YES forKey:@"enabled"];
      [[_specifiers specifierForID:@"SECURITY"] setProperty:@YES forKey:@"enabled"];
      }
      [self testEnable];*/
  }
 // [self testEnable];
	return _specifiers;
}
/*- (void)testEnable {
  if ([_prefs boolForKey:@"Enabled"] == NO) {
       [[_specifiers specifierForID:@"CONFIGURATION"] setProperty:@NO forKey:@"enabled"];
       [[_specifiers specifierForID:@"SECURITY"] setProperty:@NO forKey:@"enabled"];
      }
      else {
      [[_specifiers specifierForID:@"CONFIGURATION"] setProperty:@YES forKey:@"enabled"];
      [[_specifiers specifierForID:@"SECURITY"] setProperty:@YES forKey:@"enabled"];
      }
  if ([_prefs boolForKey:@"Enabled"] == NO) {
       [[[_specifiers specifierForID:@"CONFIGURATION"] propertyForKey:@"cellObject"] setCellEnabled:NO];
       [[[_specifiers specifierForID:@"SECURITY"] propertyForKey:@"cellObject"] setCellEnabled:NO];
    }
    else {
      [[[_specifiers specifierForID:@"CONFIGURATION"] propertyForKey:@"cellObject"] setCellEnabled:YES];
      [[[_specifiers specifierForID:@"SECURITY"] propertyForKey:@"cellObject"] setCellEnabled:YES];
    }
} */
- (void)loadView {
  NSString *fullPath = [NSString stringWithFormat:@"/System/Library/PreferenceBundles/AccessibilitySettings.bundle"];
  NSBundle *bundle;
  bundle = [NSBundle bundleWithPath:fullPath];
  BOOL loaded = [bundle load];
	[super loadView];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/quickcenter.bundle/heart.png"] style:UIBarButtonItemStylePlain target:self action:@selector(heart)];
	self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:255.0f/255.0f
                green:58.0f/255.0f
                 blue:45.0f/255.0f
                alpha:1.0f];
  [[[_specifiers specifierForID:@"GUIDE"] propertyForKey:@"cellObject"] setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
 // UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
  
  //[_tableView addGestureRecognizer:gestureRecognizer];
}

- (CGFloat)maximumValueForSpecifier:(id)arg1 {
    return [[arg1 propertyForKey:@"maximumValue"] floatValue];
}
- (CGFloat)minimumValueForSpecifier:(PSSpecifier*)arg1 {
    return [[arg1 propertyForKey:@"minimumValue"] floatValue];
}
- (CGFloat)stepValueForSpecifier:(id)arg1 {
    return [[arg1 propertyForKey:@"stepValue"] floatValue];
}
- (CGFloat)getSeconds {
return secs;
}
- (void)setSeconds:(CGFloat)arg1 {
	secs = arg1;
}
- (id)stringValueForSpecifier:(PSSpecifier *)arg1 {
    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.creatix.quickcenter"];
	if ([arg1 propertyForKey:@"cellClass"] == NSClassFromString(@"AXEditableTableCellWithStepper"))
	return [NSString stringWithFormat:@"%.2f", [prefs floatForKey:[arg1 propertyForKey:@"key"]]];
}
- (void)specifier:(PSSpecifier *)arg1 setValue:(CGFloat)arg2 {
   CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.creatix.quickcenter/settingschanged"), NULL, NULL, TRUE);
NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.creatix.quickcenter"];
	if ([arg1 propertyForKey:@"cellClass"] == NSClassFromString(@"AXEditableTableCellWithStepper")) {
    [prefs setFloat:arg2 forKey:[arg1 propertyForKey:@"key"]];
		//[[[arg1 propertyForKey:@"cellObject"] stepper] setValue:secs];
	}
}
- (CGFloat)valueForSpecifier:(PSSpecifier *)arg1 {
NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.creatix.quickcenter"];
	if ([arg1 propertyForKey:@"cellClass"] == NSClassFromString(@"AXEditableTableCellWithStepper"))
	return [prefs floatForKey:[arg1 propertyForKey:@"key"]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
  NSLog(@"Fuck This Shit You");
   CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.creatix.quickcenter/settingschanged"), NULL, NULL, TRUE);
  [super setPreferenceValue:value specifier:specifier];
  //[self testEnable];
  if ([_prefs synchronize]) {

  }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([[[[tableView cellForRowAtIndexPath:indexPath] specifier] propertyForKey:@"id"] isEqualToString:@"GUIDE"]) {
    NSLog(@"WE FUCKIN PRESSED GUIDE");
    NSURL *URL = [NSURL URLWithString:@"https://www.youtube.com/watch?v=MuAzAyCleFw"];
    SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:URL];
    sfvc.delegate = self;
    [self presentViewController:sfvc animated:YES completion:nil];
  }
  else {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  }
}
-(void)setPreferenceValue:(id)value forSpecifier:(PSSpecifier*)specifier {
   CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.creatix.quickcenter/settingschanged"), NULL, NULL, TRUE);
  [super setPreferenceValue:value forSpecifier:specifier];
  //[self testEnable];
  if ([_prefs synchronize]) {

  }
}

@end
