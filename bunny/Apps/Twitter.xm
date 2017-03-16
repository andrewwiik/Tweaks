#import <substrate.h>
#import "interface.h"

@interface T1ApplicationShortcuts : NSObject
+ (void)registerShortcutItemsWithNewMessageEnabled:(BOOL)arg1;
@end

%hook T1ApplicationShortcuts
+ (BOOL)_apiAvailable {
   return YES;
}
+ (void)unregisterShortcutItems {
   return;
}
%end

%ctor {
	if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.atebits.Tweetie2"]) { // Twitter
        %init;
    }
}