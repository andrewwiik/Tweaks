#import "CBRPrefsManager.h"

#import "Defines.h"
#import "NSDistributedNotificationCenter.h"

#define PREFS_NAME "com.golddavid.colorbanners"

#define BANNERS_KEY @"BannersEnabled"
#define BANNERS_GRADIENT_KEY @"BannerGradient"
#define BANNER_ALPHA_KEY @"BannerAlpha"
#define BANNER_BG_KEY @"BannerBackgroundColor"
#define BANNER_CONSTANT_KEY @"BannerUseConstant"

#define BANNER_DEEP_ANALYSIS_KEY @"WantsDeepBannerAnalyzing"
#define BANNER_LIVE_ANALYSIS_KEY @"WantsLiveAnalysis"
#define BANNERS_BLUR_KEY @"RemoveBannersBlur"
#define RECT_KEY @"HideQRRect"
#define GRABBER_KEY @"HideGrabber"

#define LS_KEY @"LSEnabled"
#define LS_GRADIENT_KEY @"LSGradient"
#define LS_ALPHA_KEY @"LSAlpha"
#define LS_BG_KEY @"LSBackgroundColor"
#define LS_CONSTANT_KEY @"LSUseConstant"

#define CORNERS_KEY @"RoundCorners"
#define BLUR_KEY @"RemoveBlur"
#define SEPARATORS_KEY @"ShowSeparators"
#define DIMMING_KEY @"DisableDimming"
#define COLOR_BUTTON_KEY @"ColorDismissButton"
#define WHITE_TEXT_KEY @"PrefersWhiteText"

#define NC_KEY @"NCEnabled"
#define NC_GRADIENT_KEY @"NCGradient"
#define NC_ALPHA_KEY @"NCAlpha"
#define NC_BG_KEY @"NCBackgroundColor"
#define NC_CONSTANT_KEY @"NCUseConstant"

// From ColorBadges.h.
#define GETRED(rgb) ((rgb >> 16) & 0xFF)
#define GETGREEN(rgb) ((rgb >> 8) & 0xFF)
#define GETBLUE(rgb) (rgb & 0xFF)

// Default to white.
#define DEFAULT_COLOR 0xFFFFFF

// Expected format: #<hex int>.
static int RGBColorFromNSString(NSString *str) {
  unsigned hexColor = DEFAULT_COLOR;
  NSScanner *scanner = [NSScanner scannerWithString:str];
  [scanner setScanLocation:1]; // Skip over the '#'.
  [scanner scanHexInt:&hexColor];
  return (int)hexColor;
}

@implementation CBRPrefsManager

+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  static CBRPrefsManager *cache;
  dispatch_once(&onceToken, ^{ cache = [[CBRPrefsManager alloc] init]; } );
  return cache;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self reload];
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self 
                                                        selector:@selector(reload)
                                                            name:INTERNAL_NOTIFICATION_NAME 
                                                          object:nil];
  }
  return self;
}

- (NSDictionary *)prefsDictionary {
  CFStringRef appID = CFSTR(PREFS_NAME);
  CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
  if (!keyList) {
    CBRLOG(@"Unable to obtain preferences keyList!");
    return nil;
  }
  NSDictionary *dictionary = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
  CFRelease(keyList);
  return [dictionary autorelease];
}

- (void)reload {
  NSDictionary *prefs = [self prefsDictionary];

  _bannersEnabled = [self boolForValue:prefs[BANNERS_KEY] withDefault:YES];
  _useBannerGradient = [self boolForValue:prefs[BANNERS_GRADIENT_KEY] withDefault:YES];
  _bannerAlpha = [self floatForValue:prefs[BANNER_ALPHA_KEY] withDefault:0.7];
  _bannerBackgroundColor = [self rgbColorForNSString:prefs[BANNER_BG_KEY] withDefault:DEFAULT_COLOR];
  _bannersUseConstantColor = [self boolForValue:prefs[BANNER_CONSTANT_KEY] withDefault:NO];

  _wantsDeepBannerAnalyzing = [self boolForValue:prefs[BANNER_DEEP_ANALYSIS_KEY] withDefault:YES];
  _wantsLiveAnalysis = [self boolForValue:prefs[BANNER_LIVE_ANALYSIS_KEY] withDefault:YES];
  _removeBannersBlur = [self boolForValue:prefs[BANNERS_BLUR_KEY] withDefault:NO];
  _hideQRRect = [self boolForValue:prefs[RECT_KEY] withDefault:NO];
  _hideGrabber = [self boolForValue:prefs[GRABBER_KEY] withDefault:NO];

  _lsEnabled = [self boolForValue:prefs[LS_KEY] withDefault:YES];
  _useLSGradient = [self boolForValue:prefs[LS_GRADIENT_KEY] withDefault:YES];
  _lsAlpha = [self floatForValue:prefs[LS_ALPHA_KEY] withDefault:0.7];
  _lsBackgroundColor = [self rgbColorForNSString:prefs[LS_BG_KEY] withDefault:DEFAULT_COLOR];
  _lsUseConstantColor = [self boolForValue:prefs[LS_CONSTANT_KEY] withDefault:NO];

  _roundCorners = [self boolForValue:prefs[CORNERS_KEY] withDefault:NO];
  _removeLSBlur = [self boolForValue:prefs[BLUR_KEY] withDefault:NO];
  _showSeparators = [self boolForValue:prefs[SEPARATORS_KEY] withDefault:NO];
  _disableDimming = [self boolForValue:prefs[DIMMING_KEY] withDefault:YES];
  _colorDismissButton = [self boolForValue:prefs[COLOR_BUTTON_KEY] withDefault:YES];
  _prefersWhiteText = [self boolForValue:prefs[WHITE_TEXT_KEY] withDefault:NO];

  _ncEnabled = [self boolForValue:prefs[NC_KEY] withDefault:YES];
  _useNCGradient = [self boolForValue:prefs[NC_GRADIENT_KEY] withDefault:YES];
  _ncAlpha = [self floatForValue:prefs[NC_ALPHA_KEY] withDefault:0.7];
  _ncBackgroundColor = [self rgbColorForNSString:prefs[NC_BG_KEY] withDefault:DEFAULT_COLOR];
  _ncUseConstantColor = [self boolForValue:prefs[NC_CONSTANT_KEY] withDefault:NO];
}

- (BOOL)boolForValue:(NSNumber *)value withDefault:(BOOL)defaultValue {
  return (value) ? [value boolValue] : defaultValue;
}

- (CGFloat)floatForValue:(NSNumber *)value withDefault:(CGFloat)defaultValue {
  return (value) ? (CGFloat)[value floatValue] : defaultValue;
}

- (int)rgbColorForNSString:(NSString *)string withDefault:(int)defaultValue {
  return (string) ? RGBColorFromNSString(string) : defaultValue;
}

- (void)dealloc {
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:INTERNAL_NOTIFICATION_NAME object:nil];
  [super dealloc];
}

@end
