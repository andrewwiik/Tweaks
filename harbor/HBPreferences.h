
#define prefs [HBPreferences sharedInstance]

@interface HBPreferences : NSObject

#define PREF(TYPE, NAME, DEFAULT, LABEL, CELL_TYPE, ...) @property (nonatomic, assign, setter=set##NAME:, getter=get##NAME) TYPE NAME;
#include "Preferences.def"

@property (nonatomic, retain) NSMutableDictionary *dictionary;

+ (id)sharedInstance;

@end
