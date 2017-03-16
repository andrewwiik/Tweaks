#import <substrate.h>
#import "interface.h"

@interface MTAppShortcutManager : NSObject
-(id)_shortcutItems;
@end

%hook MTAppDelegate_iOS
- (id)init {
  %orig;
  NSArray *shortcuts = [[[%c(MTAppShortcutManager) alloc] init] _shortcutItems];
  [UIApplication sharedApplication].shortcutItems = shortcuts;
  return %orig;
}
%end

%ctor {
	if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.podcasts"]) { // Podcasts App
          %init;
     }
}