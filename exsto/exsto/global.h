#define TWEAK_NAME @"exsto"

#define str(z, ...) [NSString stringWithFormat:z, ##__VA_ARGS__]
#define log(z) NSLog(@"%@", [NSString stringWithFormat:@"[%@] %@", TWEAK_NAME, z])
#define TWEAK_BUNDLE_PATH [NSString stringWithFormat:@"/Library/PreferenceBundles/%@.bundle", TWEAK_NAME]

// #define TWEAK_PREFS_COLOR [UIColor colorWithRed:0.08f green:0.75f blue:0.85f alpha:1.f]

#define prefsID CFSTR("com.zachatrocity.exsto")