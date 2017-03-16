#import <substrate.h>
#import "interface.h"

%hook FYAppDelegate
- (id)init {
  %orig;

  UIMutableApplicationShortcutItem *newPatch = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.johncoates.Flex.NewPatch" localizedTitle:@"New Patch" localizedSubtitle:nil icon:[[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeAdd]] userInfo:nil];
  [[UIApplication sharedApplication] setShortcutItems: @[ newPatch ]]; // set new patch shortcut item
  return %orig;

}

%end

%ctor {
	if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.johncoates.Flex"]) { // Flex 2 App
          %init;
     }
}