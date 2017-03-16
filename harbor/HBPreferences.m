#import "HBPreferences.h"
#import <notify.h>

#define PREFS_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/com.eswick.harbor.plist"]


/* Dictionary tools */

/* ======== */

static NSDictionary* defaults() {
	return @{
		#define PREF(TYPE, NAME, DEFAULT, LABEL, CELL_TYPE, ...) @#NAME : DEFAULT,
		#include "Preferences.def"
	};
}

@implementation HBPreferences

#define PREF(TYPE, NAME, DEFAULT, LABEL, CELL_TYPE, ...) \
- (TYPE)get##NAME { \
	return self.dictionary[@#NAME] ? self.dictionary[@#NAME] : defaults()[@#NAME]; \
} \
\
- (void)set##NAME:(TYPE)newValue { \
	self.dictionary[@#NAME] = newValue; \
	[self.dictionary writeToFile:PREFS_PATH atomically:true]; \
	notify_post("com.eswick.harbor.preferences_changed"); \
}

#include "Preferences.def"

- (NSMutableDictionary*)dictionary {
	if (!_dictionary)
		self.dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:PREFS_PATH];

	return _dictionary;
}

+ (id)sharedInstance {
    static HBPreferences *_prefs;

    if (_prefs == nil) {
        _prefs = [[self alloc] init];

        if (![[NSFileManager defaultManager] fileExistsAtPath:PREFS_PATH]) {
        	/* Write defaults */
        	[defaults() writeToFile:PREFS_PATH atomically:true];
        }

				int token, status;

				status = notify_register_dispatch("com.eswick.harbor.preferences_changed", &token,
					dispatch_get_main_queue(), ^(int t) {
						[_prefs setDictionary:nil];
				});
    }

    return _prefs;
}

@end
