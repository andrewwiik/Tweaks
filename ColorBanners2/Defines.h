// #define DEBUG

#ifdef DEBUG
    #define CBRLOG(fmt, ...) NSLog(@"[ColorBanners]-%d %@", __LINE__, [NSString stringWithFormat:fmt, ##__VA_ARGS__])
#else
    #define CBRLOG(fmt, ...)
#endif

#define INFO(fmt, ...) NSLog(@"[ColorBanners] INFO %@", [NSString stringWithFormat:fmt, ##__VA_ARGS__])

#define INTERNAL_NOTIFICATION_NAME @"CBRReloadPreferences"
#define TEST_LS "com.golddavid.colorbanners/test-ls-notification"
#define TEST_BANNER "com.golddavid.colorbanners/test-banner"
#define RESPRING "com.golddavid.colorbanners/respring"

#ifndef kCFCoreFoundationVersionNumber_iOS_9_0
#define kCFCoreFoundationVersionNumber_iOS_9_0 1240.10
#endif

#define IS_IOS9_OR_NEWER (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_9_0)
