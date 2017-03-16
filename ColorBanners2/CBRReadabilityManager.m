#import "CBRReadabilityManager.h"

static CFStringRef kUseLightTextNotification = CFSTR("ColorBanners_Readability_Light");
static CFStringRef kUseDarkTextNotification = CFSTR("ColorBanners_Readability_Dark");
static CFStringRef kPrefsAppID = CFSTR("com.golddavid.colorbanners");
static CFStringRef kPrefsUseDarkTextKey = CFSTR("Readability_UseDarkText"); 

@implementation CBRReadabilityManager

static void callBack(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object,
    CFDictionaryRef userInfo) {
  CBRReadabilityManager *self = (CBRReadabilityManager *)observer;
  NSString *notificationName = (NSString *)name;

  self.shouldUseDarkText = [notificationName isEqualToString:(NSString *)kUseDarkTextNotification];
}

static void notify(BOOL useDarkText) {
  CFStringRef notification = (useDarkText) ? kUseDarkTextNotification : kUseLightTextNotification;
  CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                       notification,
                                       NULL,
                                       NULL,
                                       true);
}

+ (instancetype)sharedInstance {
  static dispatch_once_t predicate;
  static CBRReadabilityManager *manager;
  dispatch_once(&predicate, ^{ manager = [[CBRReadabilityManager alloc] init]; });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    self,
                                    &callBack,
                                    kUseDarkTextNotification,
                                    NULL,
                                    0);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    self,
                                    &callBack,
                                    kUseLightTextNotification,
                                    NULL,
                                    0);
    [self refresh];
  }
  return self;
}

- (void)setShouldUseDarkText:(BOOL)useDarkText {
  if (_shouldUseDarkText != useDarkText) {
    _shouldUseDarkText = useDarkText;
    [self.delegate managersReadabilityStateDidChange:self];
  }
}

- (void)dealloc {
  CFNotificationCenterRemoveEveryObserver(CFNotificationCenterGetDarwinNotifyCenter(), self);
  [super dealloc];
}

- (void)refresh {
  CFPreferencesAppSynchronize(kPrefsAppID);
  Boolean keyExists = false;
  Boolean useDarkText = CFPreferencesGetAppBooleanValue(kPrefsUseDarkTextKey,
                                                        kPrefsAppID,
                                                        &keyExists);
  if (keyExists) {
    self.shouldUseDarkText = (BOOL)useDarkText;
  }
}

- (void)setShouldUseDarkTextAndSynchronize:(BOOL)useDarkText {
  if (_shouldUseDarkText != useDarkText) {
    _shouldUseDarkText = useDarkText;
    CFPreferencesSetAppValue(kPrefsUseDarkTextKey, @(useDarkText), kPrefsAppID);
    CFPreferencesAppSynchronize(kPrefsAppID);
    notify(useDarkText);
  }
}
@end
