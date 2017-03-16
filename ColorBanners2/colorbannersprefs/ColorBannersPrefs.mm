#import "ColorBannersPrefs.h"

#import "../NSDistributedNotificationCenter.h"


#define PREFS_NAME "com.golddavid.colorbanners"

#define INTERNAL_NOTIFICATION_NAME @"CBRReloadPreferences"
#define TEST_LS "com.golddavid.colorbanners/test-ls-notification"
#define TEST_BANNER "com.golddavid.colorbanners/test-banner"
#define RESPRING "com.golddavid.colorbanners/respring"


#define DEEP_ANALYSIS_INFO @"Analyzes the view located below the banner when deciding the text color. Use this if you have a fairly low alpha level."
#define LIVE_ANALYSIS_INFO @"Live analysis will continually check the view located below the banner for changes and update the text color as necessary."

static void refreshPrefs(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  [[NSDistributedNotificationCenter defaultCenter] postNotificationName:INTERNAL_NOTIFICATION_NAME object:nil];
}

static void refreshPrefsVolatile(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  PSListController *controller = (PSListController *)observer;
  [controller clearCache];
  [controller reload];
  [[NSDistributedNotificationCenter defaultCenter] postNotificationName:INTERNAL_NOTIFICATION_NAME object:nil];
}

@implementation ColorBannersPrefsListController

- (instancetype)init {
  self = [super init];
  if (self) {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), 
                                    self,
                                    &refreshPrefs,
                                    CFSTR("com.golddavid.colorbanners/reloadprefs"),
                                    NULL,
                                    0);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), 
                                    self,
                                    &refreshPrefsVolatile,
                                    CFSTR("com.golddavid.colorbanners/reloadprefs-main"),
                                    NULL,
                                    0);
  }
  return self;
}

- (void)dealloc {
  CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                     self,
                                     CFSTR("com.golddavid.colorbanners/reloadprefs"),
                                     NULL);
  CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                     self,
                                     CFSTR("com.golddavid.colorbanners/reloadprefs-main"),
                                     NULL);
  [super dealloc];
}

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ColorBannersPrefs" target:self] retain];
	}
	return _specifiers;
}

- (id)getLabelForSpecifier:(PSSpecifier *)specifier {
  NSNumber *value = [self readPreferenceValue:specifier];
  if (value) {
    return ([value boolValue]) ? @"On" : @"Off";
  }

  NSNumber *defaultValue = [specifier propertyForKey:@"default"];
  return ([defaultValue boolValue]) ? @"On" : @"Off";
}

- (void)testLockScreenNotification {
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                       CFSTR(TEST_LS),
                                       nil,
                                       nil,
                                       true);
}

- (void)testBanner {
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                       CFSTR(TEST_BANNER),
                                       nil,
                                       nil,
                                       true); 
}

@end

@implementation ColorBannersBannerPrefsController

- (instancetype)init {
  self = [super init];
  if (self) {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), 
                                    self,
                                    &refreshPrefsVolatile,
                                    CFSTR("com.golddavid.colorbanners/reloadprefs-banners"),
                                    NULL,
                                    0);
  }
  return self;
}

- (void)dealloc {
  CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                     self,
                                     CFSTR("com.golddavid.colorbanners/reloadprefs-banners"),
                                     NULL);
  [_constantColorSpecifiers release];
  [_liveAnalysisSpecifiers release];
  [super dealloc];
}

// Thanks to MultitaskingGestures (https://github.com/hamzasood/MultitaskingGestures).
- (void)setBannerConstantColorsEnabled:(NSNumber *)value forSpecifier:(PSSpecifier *)specifier {
  [self setPreferenceValue:value specifier:specifier];
  if ([value boolValue]) {
    int index = [_specifiers indexOfObject:[_specifiers specifierForID:@"CUSTOM_COLOR_MINUS_ONE"]] + 1;
    [self insertContiguousSpecifiers:_constantColorSpecifiers 
                             atIndex:index
                            animated:YES];
  } else {
    [self removeContiguousSpecifiers:_constantColorSpecifiers animated:YES];
  }
}

// Thanks to MultitaskingGestures (https://github.com/hamzasood/MultitaskingGestures).
- (void)setDeepBannerAnalysisEnabled:(NSNumber *)value forSpecifier:(PSSpecifier *)specifier {
  PSSpecifier *groupSpecifier = [_specifiers specifierForID:@"AL GORE"];
  [self setPreferenceValue:value specifier:specifier];

  if ([value boolValue]) {
    [groupSpecifier setProperty:LIVE_ANALYSIS_INFO forKey:@"footerText"];
    [self reloadSpecifier:groupSpecifier animated:NO];

    int index = [_specifiers indexOfObject:[_specifiers specifierForID:@"LIVE_ANALYSIS_MINUS_ONE"]] + 1;
    [self insertContiguousSpecifiers:_liveAnalysisSpecifiers 
                             atIndex:index
                            animated:YES];
  } else {
    [groupSpecifier setProperty:DEEP_ANALYSIS_INFO forKey:@"footerText"];
    [self reloadSpecifier:groupSpecifier animated:NO];

    [self removeContiguousSpecifiers:_liveAnalysisSpecifiers animated:YES];
  }
}

// Thanks to MultitaskingGestures (https://github.com/hamzasood/MultitaskingGestures).
- (id)specifiers {
  if(_specifiers == nil) {
    NSMutableArray *specifiers = [[self loadSpecifiersFromPlistName:@"Banners" target:self] mutableCopy];

    // Handle constant color settings.
    [_constantColorSpecifiers release];
    _constantColorSpecifiers = [[NSMutableArray alloc] init];
    // Populate the _constantColorSpecifiers array.
    int index = [specifiers indexOfObject:[specifiers specifierForID:@"CUSTOM_COLOR_MINUS_ONE"]] + 1;
    for (int i = index; i < specifiers.count; ++i) {
      PSSpecifier *currentSpec = specifiers[i];
      if (![currentSpec.identifier isEqualToString:@"CUSTOM_COLOR_GROUP"] &&
           [[PSTableCell stringFromCellType:currentSpec.cellType] isEqualToString:@"PSGroupCell"]) {
        break;
      }
      [_constantColorSpecifiers addObject:currentSpec];
    }

    Boolean keyExists = false;
    if (!CFPreferencesGetAppBooleanValue(CFSTR("BannerUseConstant"),
                                         CFSTR(PREFS_NAME),
                                         &keyExists) || !keyExists) {
      [specifiers removeObjectsInArray:_constantColorSpecifiers];
    }

    // Handle analysis settings.
    [_liveAnalysisSpecifiers release];
    _liveAnalysisSpecifiers = [NSArray arrayWithObject:[specifiers specifierForID:@"LIVE_ANALYSIS_CELL"]];
    [_liveAnalysisSpecifiers retain];

    // Find group specifier (to update footerText).
    PSSpecifier *groupSpecifier = [specifiers specifierForID:@"AL GORE"];

    keyExists = false;
    if (!CFPreferencesGetAppBooleanValue(CFSTR("WantsDeepBannerAnalyzing"),
                                         CFSTR(PREFS_NAME),
                                         &keyExists) && keyExists) {
      [specifiers removeObjectsInArray:_liveAnalysisSpecifiers];
      [groupSpecifier setProperty:DEEP_ANALYSIS_INFO forKey:@"footerText"];
    } else {
      [groupSpecifier setProperty:LIVE_ANALYSIS_INFO forKey:@"footerText"];
    }

    _specifiers = [specifiers copy];
    [specifiers release];
  }
  return _specifiers;
}

- (void)testBanner:(id)sender {
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                       CFSTR(TEST_BANNER),
                                       nil,
                                       nil,
                                       true); 
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Test"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(testBanner:)];
  self.navigationItem.rightBarButtonItem = [button autorelease];
}

@end

@implementation ColorBannersLSPrefsController

- (instancetype)init {
  self = [super init];
  if (self) {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), 
                                    self,
                                    &refreshPrefsVolatile,
                                    CFSTR("com.golddavid.colorbanners/reloadprefs-ls"),
                                    NULL,
                                    0);
  }
  return self;
}

- (void)dealloc {
  CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                     self,
                                     CFSTR("com.golddavid.colorbanners/reloadprefs-ls"),
                                     NULL);
  [_constantColorSpecifiers release];
  [super dealloc];
}

// Thanks to MultitaskingGestures (https://github.com/hamzasood/MultitaskingGestures).
- (void)setLSConstantColorsEnabled:(NSNumber *)value forSpecifier:(PSSpecifier *)specifier {
  [self setPreferenceValue:value specifier:specifier];
  if ([value boolValue]) {
    int index = [_specifiers indexOfObject:[_specifiers specifierForID:@"CUSTOM_COLOR_MINUS_ONE"]] + 1;
    [self insertContiguousSpecifiers:_constantColorSpecifiers 
                             atIndex:index
                            animated:YES];
  } else {
    [self removeContiguousSpecifiers:_constantColorSpecifiers animated:YES];
  }
}

// Thanks to MultitaskingGestures (https://github.com/hamzasood/MultitaskingGestures).
- (id)specifiers {
  if(_specifiers == nil) {
    NSMutableArray *specifiers = [[self loadSpecifiersFromPlistName:@"LockScreen" target:self] mutableCopy];

    [_constantColorSpecifiers release];
    _constantColorSpecifiers = [[NSMutableArray alloc] init];
    // Populate the _constantColorSpecifiers array.
    int index = [specifiers indexOfObject:[specifiers specifierForID:@"CUSTOM_COLOR_MINUS_ONE"]] + 1;
    for (int i = index; i < specifiers.count; ++i) {
      PSSpecifier *currentSpec = specifiers[i];
      if (![currentSpec.identifier isEqualToString:@"CUSTOM_COLOR_GROUP"] &&
           [[PSTableCell stringFromCellType:currentSpec.cellType] isEqualToString:@"PSGroupCell"]) {
        break;
      }
      [_constantColorSpecifiers addObject:currentSpec];
    }

    Boolean keyExists = false;
    if (!CFPreferencesGetAppBooleanValue(CFSTR("LSUseConstant"),
                                         CFSTR(PREFS_NAME),
                                         &keyExists) || !keyExists) {
      [specifiers removeObjectsInArray:_constantColorSpecifiers];
    }

    _specifiers = [specifiers copy];
    [specifiers release];
  }
  return _specifiers;
}

- (void)testNotification:(id)sender {
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                       CFSTR(TEST_LS),
                                       nil,
                                       nil,
                                       true);
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Test"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(testNotification:)];
  self.navigationItem.rightBarButtonItem = [button autorelease];
}

@end

@implementation ColorBannersNCPrefsController

- (instancetype)init {
  self = [super init];
  if (self) {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), 
                                    self,
                                    &refreshPrefsVolatile,
                                    CFSTR("com.golddavid.colorbanners/reloadprefs-nc"),
                                    NULL,
                                    0);
  }
  return self;
}

- (void)dealloc {
  CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                     self,
                                     CFSTR("com.golddavid.colorbanners/reloadprefs-nc"),
                                     NULL);
  [_constantColorSpecifiers release];
  [super dealloc];
}

// Thanks to MultitaskingGestures (https://github.com/hamzasood/MultitaskingGestures).
- (void)setNCConstantColorsEnabled:(NSNumber *)value forSpecifier:(PSSpecifier *)specifier {
  [self setPreferenceValue:value specifier:specifier];
  if ([value boolValue]) {
    int index = [_specifiers indexOfObject:[_specifiers specifierForID:@"CUSTOM_COLOR_MINUS_ONE"]] + 1;
    [self insertContiguousSpecifiers:_constantColorSpecifiers 
                             atIndex:index
                            animated:YES];
  } else {
    [self removeContiguousSpecifiers:_constantColorSpecifiers animated:YES];
  }
}

// Thanks to MultitaskingGestures (https://github.com/hamzasood/MultitaskingGestures).
- (id)specifiers {
  if(_specifiers == nil) {
    NSMutableArray *specifiers = [[self loadSpecifiersFromPlistName:@"NotificationCenter" target:self] mutableCopy];

    [_constantColorSpecifiers release];
    _constantColorSpecifiers = [[NSMutableArray alloc] init];
    // Populate the _constantColorSpecifiers array.
    int index = [specifiers indexOfObject:[specifiers specifierForID:@"CUSTOM_COLOR_MINUS_ONE"]] + 1;
    for (int i = index; i < specifiers.count; ++i) {
      PSSpecifier *currentSpec = specifiers[i];
      if (![currentSpec.identifier isEqualToString:@"CUSTOM_COLOR_GROUP"] &&
           [[PSTableCell stringFromCellType:currentSpec.cellType] isEqualToString:@"PSGroupCell"]) {
        break;
      }
      [_constantColorSpecifiers addObject:currentSpec];
    }

    Boolean keyExists = false;
    if (!CFPreferencesGetAppBooleanValue(CFSTR("NCUseConstant"),
                                         CFSTR(PREFS_NAME),
                                         &keyExists) || !keyExists) {
      [specifiers removeObjectsInArray:_constantColorSpecifiers];
    }

    _specifiers = [specifiers copy];
    [specifiers release];
  }
  return _specifiers;
}

- (void)respring:(id)sender {
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                       CFSTR(RESPRING),
                                       nil,
                                       nil,
                                       true);
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Respring"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(respring:)];
  self.navigationItem.rightBarButtonItem = [button autorelease];
}

@end
