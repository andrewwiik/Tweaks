#include "QCRConfigurationListController.h"
#import "CWStatusBarNotification.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTextFieldSpecifier.h>


@implementation QCRConfigurationListController
- (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
- (BOOL)is6S {
    _isForceNative = ([[[self platform] substringToIndex: 7] isEqualToString:@"iPhone8"]);
    return ([[[self platform] substringToIndex: 7] isEqualToString:@"iPhone8"]);
}
- (NSArray *)specifiers {

	if (!_specifiers) {
  BOOL isForceNative = [self is6S];
  _prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.creatix.quickcenter"];
  _longPressSpecifiers = [NSMutableArray new];
  _forceTouchSpecifiers = [NSMutableArray new];
  NSString *fullPath = [NSString stringWithFormat:@"/System/Library/PreferenceBundles/AccessibilitySettings.bundle"];
  NSBundle *bundle;
  bundle = [NSBundle bundleWithPath:fullPath];
  BOOL loaded = [bundle load];
  if (!isForceNative)
	_specifiers = [self loadSpecifiersFromPlistName:@"Configuration" target:self];
  else _specifiers = [self loadSpecifiersFromPlistName:@"Configuration_S" target:self];
	NSMutableArray *modifiedSpecs = [NSMutableArray new];
  PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:@""
							target:self
							   set:NULL
							   get:NULL
							detail:Nil
							  cell:-1
							  edit:Nil];
  [specifier setProperty:NSClassFromString(@"ACUIAppInstallCell") forKey:@"cellClass"];
  [specifier setProperty:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/quickcenter.bundle/configuration.png"] forKey:@"ACUIAppInstallIcon"];
  [specifier setProperty:@"QuickCenter" forKey:@"ACUIAppInstallPublisher"];
  [specifier setProperty:@"Configuration" forKey:@"ACUIAppInstallName"];
  [specifier setProperty:[NSNumber numberWithInt:81] forKey:@"height"];
  [specifier setProperty:@YES forKey:@"ACUIAppIsAvailable"];
  [specifier setProperty:@YES forKey:@"enabled"];
  [specifier setProperty:@YES forKey:@"Custom"];
  [specifier setProperty:@"RESET" forKey:@"CustomTitle"];
  [specifier setProperty:@"RESET NOW" forKey:@"CustomConfirmation"];
  [specifier setProperty:@YES forKey:@"ResetButton"];
  [modifiedSpecs addObject:specifier];

  PSSpecifier* stepper = [PSSpecifier preferenceSpecifierNamed:@""
					  target:self
						   set:NULL
						   get:@selector(stringValueForSpecifier:)
					  detail:Nil
						  cell:4
						  edit:Nil];
  [stepper setProperty:NSClassFromString(@"AXEditableTableCellWithStepper") forKey:@"cellClass"];
  [stepper setProperty:@"NumericalPreferencePickerIdentifier" forKey:@"id"];
  [stepper setProperty:@"longHoldTime" forKey:@"key"];
  [stepper setProperty:[NSNumber numberWithFloat:15.0] forKey:@"maximumValue"];
  [stepper setProperty:[NSNumber numberWithFloat:0.01] forKey:@"minimumValue"];
  [stepper setProperty:[NSNumber numberWithFloat:0.01] forKey:@"stepValue"];
  [stepper setProperty:@"STEPPER" forKey:@"id"];
  [stepper setProperty:[NSNumber numberWithFloat:1] forKey:@"default"];
  [stepper setProperty:@"com.creatix.quickcenter/settingschanged" forKey:@"PostNotification"];

  //[modifiedSpecs addObject:stepper];

  [_longPressSpecifiers addObject:stepper];
  PSSpecifier *forceActionLabel = [PSSpecifier preferenceSpecifierNamed:@"Activation"
					target:self
						 set:NULL
						 get:NULL
					detail:Nil
						cell:PSGroupCell
						edit:Nil];
  if ([_prefs integerForKey:@"activationAction"] == 0 && !isForceNative)
  [forceActionLabel setProperty:[NSString stringWithFormat:@"Adjust the amount of pressure needed to activate 3D touch. Light sensitivity reduces the amount of pressure required; Firm sensitivity increases it."] forKey:@"footerText"];
  if ([_prefs integerForKey:@"activationAction"] == 0 && isForceNative)
  [forceActionLabel setProperty:[NSString stringWithFormat:@"Use the native 3D touch on your device."] forKey:@"footerText"];
  if ([_prefs integerForKey:@"activationAction"] == 1)
  [forceActionLabel setProperty:[NSString stringWithFormat:@"Adjust the minimum amount of time needed to activate 3D touch. A lower value reduces the amount of time required; a higher value increases it."] forKey:@"footerText"];
  [forceActionLabel setProperty:@"Activation" forKey:@"label"];
  [forceActionLabel setProperty:[NSNumber numberWithInt:0] forKey:@"footerAlignment"];
  [forceActionLabel setProperty:@"Action_Label" forKey:@"id"];
  [modifiedSpecs addObject:forceActionLabel];
  PSSpecifier* sense = [PSSpecifier preferenceSpecifierNamed:@""
					 target:self
						  set:@selector(setSliderValue:specifier:)
						  get:@selector(readSliderValue:)
					 detail:Nil
						 cell:4
						 edit:Nil];
  [sense setProperty:NSClassFromString(@"AXForceTouchSensitivitySliderCell") forKey:@"cellClass"];
  [sense setProperty:@YES forKey:@"isSegmented"];
  [sense setProperty:@NO forKey:@"isContinuous"];
  [sense setProperty:@YES forKey:@"custom"];
  [sense setProperty:[NSNumber numberWithFloat:2.0] forKey:@"segmentCount"];
  [sense setProperty:@"sensitivity" forKey:@"key"];
  [sense setProperty:[NSNumber numberWithFloat:71.0] forKey:@"height"];
  [sense setProperty:@"SEN" forKey:@"id"];
  [sense setProperty:@"com.creatix.quickcenter/settingschanged" forKey:@"PostNotification"];
  if (!isForceNative)
  [_forceTouchSpecifiers addObject:sense];
  
  
  if ([_prefs integerForKey:@"activationAction"] == 0) {
    [_specifiers addObjectsFromArray:_forceTouchSpecifiers];
  }
  if ([_prefs integerForKey:@"activationAction"] == 1) {
    [_specifiers addObjectsFromArray:_longPressSpecifiers];
  }
  
  PSSpecifier *shortcutMenuLabel = [PSSpecifier preferenceSpecifierNamed:@"Shortcut Menu"
					target:self
						 set:NULL
						 get:NULL
					detail:Nil
						cell:PSGroupCell
						edit:Nil];
	[shortcutMenuLabel setProperty:[NSString stringWithFormat:@"The maximum number of shortcuts to display in a shortcut menu activated through Control Center."] forKey:@"footerText"];
  [shortcutMenuLabel setProperty:@"Shortcut Menu" forKey:@"label"];
	[shortcutMenuLabel setProperty:[NSNumber numberWithInt:0] forKey:@"footerAlignment"];
  [shortcutMenuLabel setProperty:@"ShortcutMenu_Label" forKey:@"id"];
  
  //[modifiedSpecs addObject:shortcutMenuLabel];
  
  PSSpecifier *maxShortcutsStepper = [PSSpecifier preferenceSpecifierNamed:@""
					  target:self
						   set:NULL
						   get:@selector(stringValueForSpecifier:)
					  detail:Nil
						  cell:4
						  edit:Nil];
  [maxShortcutsStepper setProperty:NSClassFromString(@"AXEditableTableCellWithStepper") forKey:@"cellClass"];
  [maxShortcutsStepper setProperty:@"maxShortcuts" forKey:@"key"];
  [maxShortcutsStepper setProperty:[NSNumber numberWithFloat:20.0f] forKey:@"maximumValue"];
  [maxShortcutsStepper setProperty:[NSNumber numberWithFloat:2.0f] forKey:@"minimumValue"];
  [maxShortcutsStepper setProperty:[NSNumber numberWithFloat:1.0f] forKey:@"stepValue"];
  [maxShortcutsStepper setProperty:@"maxShortcuts" forKey:@"id"];
  [maxShortcutsStepper setProperty:@YES forKey:@"custom"];
  [maxShortcutsStepper setProperty:@"Shortcuts" forKey:@"customLabel"];
  [maxShortcutsStepper setProperty:@"com.creatix.quickcenter/settingschanged" forKey:@"PostNotification"];
	//[modifiedSpecs addObject:maxShortcutsStepper];
  
	[modifiedSpecs addObjectsFromArray:_specifiers];
	[modifiedSpecs addObject:shortcutMenuLabel];
	[modifiedSpecs addObject:maxShortcutsStepper];
	
	_specifiers = [modifiedSpecs copy];
  if ([[_prefs objectForKey:@"longHoldTime"] floatValue] == 0) {
    [_prefs setObject:[NSNumber numberWithFloat:1.0f] forKey:@"longHoldTime"];
  }
  if ([[_prefs objectForKey:@"maxShortcuts"] floatValue] == 0) {
    [_prefs setObject:[NSNumber numberWithFloat:4.0] forKey:@"maxShortcuts"];
  }
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
}
- (BOOL)resetSettings {
  if ([_prefs integerForKey:@"activationAction"] == 0) {
    if ([[_prefs objectForKey:@"sensitivity"] floatValue] > 1) {
      [[[_specifiers specifierForID:@"SEN"] propertyForKey:@"cellObject"] accessibilityDecrement];
    }
    if ([[_prefs objectForKey:@"sensitivity"] floatValue] < 1) {
      [[[_specifiers specifierForID:@"SEN"] propertyForKey:@"cellObject"] accessibilityIncrement];
    }
  }
  [_prefs setObject:[NSNumber numberWithFloat:1.0] forKey:@"sensitivity"];
  [_prefs setObject:[NSNumber numberWithFloat:0.5] forKey:@"longHoldTime"];
  [_prefs setObject:[NSNumber numberWithFloat:4.0] forKey:@"maxShortcuts"];
  [_prefs setInteger:0 forKey:@"activationAction"];
  [self setPreferenceValue:0 specifier:[_specifiers specifierForID:@"ACTIVATION_ACTION"]];
  CWStatusBarNotification *notification = [CWStatusBarNotification new];
  notification.notificationLabelBackgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.957 alpha:1];
  notification.notificationLabelTextColor = [UIColor blackColor];
  [notification displayNotificationWithMessage:[NSString stringWithFormat:@"Configuration settings were reset to their defaults."]
                           forDuration:2.0f];
  notification = nil;
  [self reload];
   CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.creatix.quickcenter/settingschanged"), NULL, NULL, TRUE);
  return YES;
}
- (CGFloat)maximumValueForSpecifier:(id)arg1 {
    return [[arg1 propertyForKey:@"maximumValue"] floatValue];
}

- (CGFloat)minimumValueForSpecifier:(PSSpecifier*)arg1 {
    return [[arg1 propertyForKey:@"minimumValue"] floatValue];
}

- (CGFloat)stepValueForSpecifier:(id)arg1 {
  if ([[arg1 propertyForKey:@"stepValue"] floatValue] == 0) return 1;
  return [[arg1 propertyForKey:@"stepValue"] floatValue];
}

- (id)stringValueForSpecifier:(PSSpecifier *)arg1 {
	if ([arg1 propertyForKey:@"cellClass"] == NSClassFromString(@"AXEditableTableCellWithStepper"))
	return [NSString stringWithFormat:@"%.2f", [[_prefs objectForKey:[arg1 propertyForKey:@"key"]] floatValue]];
}

- (void)specifier:(PSSpecifier *)arg1 setValue:(CGFloat)arg2 {
	if ([arg1 propertyForKey:@"cellClass"] == NSClassFromString(@"AXEditableTableCellWithStepper")) {
    [_prefs setObject:[NSNumber numberWithFloat:arg2] forKey:[arg1 propertyForKey:@"key"]];
    if ([[arg1 propertyForKey:@"cellObject"] class] == NSClassFromString(@"AXEditableTableCellWithStepper")) {
    [arg1 propertyForKey:@"cellObject"];
    }
	}

}

- (CGFloat)valueForSpecifier:(PSSpecifier *)arg1 {
	if ([arg1 propertyForKey:@"cellClass"] == NSClassFromString(@"AXEditableTableCellWithStepper"))
	return [[_prefs objectForKey:[arg1 propertyForKey:@"key"]] floatValue];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)setSliderValue:(id)value specifier:(PSSpecifier *)specifier {
  [_prefs setObject:value forKey:[specifier propertyForKey:@"key"]];
}
- (id)readSliderValue:(PSSpecifier *)specifier {
    return [_prefs objectForKey:[specifier propertyForKey:@"key"]];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.creatix.quickcenter/settingschanged"), NULL, NULL, TRUE);
  [super setPreferenceValue:value specifier:specifier];
  if ([[specifier propertyForKey:@"key"] isEqualToString:@"activationAction"]) {
    if ([_prefs integerForKey:@"activationAction"] == 0) {
      BOOL isPresent = NO;
      NSMutableArray *temp = [NSMutableArray new];
      for (PSSpecifier* spec in _specifiers) {
	      if ([[spec propertyForKey:@"key"] isEqualToString: @"longHoldTime"]) {
	        [temp addObject:spec];
	      }
	      if ([[spec propertyForKey:@"key"] isEqualToString: @"sensitivity"]) {
	        isPresent = YES;
	      }
      }
      for (PSSpecifier* spec in temp) {
	      [self removeSpecifier:spec animated:YES];
      }
      if (!isPresent) {
	      [self insertContiguousSpecifiers:_forceTouchSpecifiers atIndex:[_specifiers indexOfObject:specifier]+1 animated:YES];
	      [[_specifiers specifierForID:@"Action_Label"] setProperty:@"Adjust the amount of pressure needed to activate 3D touch. Light sensitivity reduces the amount of pressure required; Firm sensitivity increases it." forKey:@"footerText"];
	      [self reloadSpecifierID:@"Action_Label" animated:YES];
      }
    }
    if ([_prefs integerForKey:@"activationAction"] == 1) {
      BOOL isPresent = NO;
      //[self insertContiguousSpecifiers:_longPressSpecifiers atIndex:[_specifiers indexOfObject:specifier]+1 animated:YES];
      //[self removeContiguousSpecifiers:_forceTouchSpecifiers animated:YES];
      NSMutableArray *temp = [NSMutableArray new];
      for (PSSpecifier* spec in _specifiers) {
	      if ([[spec propertyForKey:@"key"] isEqualToString: @"sensitivity"]) {
	        [temp addObject:spec];
	      }
	      if ([[spec propertyForKey:@"key"] isEqualToString: @"longHoldTime"]) {
	        isPresent = YES;
	      }
      }
      for (PSSpecifier* spec in temp) {
	      [self removeSpecifier:spec animated:YES];
      }
      if (!isPresent) {
	      [self insertContiguousSpecifiers:_longPressSpecifiers atIndex:[_specifiers indexOfObject:specifier]+1 animated:YES];
	      [[_specifiers specifierForID:@"Action_Label"] setProperty:@"Adjust the minimum amount of time needed to activate 3D touch. A lower value reduces the amount of time required; a higher value increases it." forKey:@"footerText"];
	      [self reloadSpecifierID:@"Action_Label" animated:YES];
      }
    }
  }
  //NSLog([NSString stringWithFormat:@"%@", value]);
  if ([_prefs synchronize]) {

  }
}

@end

