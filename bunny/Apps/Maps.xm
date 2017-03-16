#import <substrate.h>
#import "interface.h"

%hook MapsAppDelegate
- (id)init {
  %orig;
  UIApplicationShortcutIcon *directionsIcon = [%c(UIApplicationShortcutIcon) iconWithTemplateImageName:@"action-home-OrbHW"];
  UIApplicationShortcutIcon *markIcon = [%c(UIApplicationShortcutIcon) iconWithTemplateImageName:@"action-drop-pin-OrbHW"];

  UIMutableApplicationShortcutItem *directionHome = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.Maps.directions" localizedTitle:[[NSBundle mainBundle] localizedStringForKey:@"QUICK_ACTION_DIRECTIONS_HOME" value:@"" table:@"InfoPlist-OrbHW"] localizedSubtitle:nil icon:directionsIcon userInfo:nil];
  UIMutableApplicationShortcutItem *markLocation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.Maps.mark-my-location" localizedTitle:[[NSBundle mainBundle] localizedStringForKey:@"QUICK_ACTION_MARK_MY_LOCATION" value:@"" table:@"InfoPlist-OrbHW"] localizedSubtitle:nil icon:markIcon userInfo:nil];
  UIMutableApplicationShortcutItem *shareLocation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.Maps.share-location" localizedTitle:[[NSBundle mainBundle] localizedStringForKey:@"QUICK_ACTION_SEND_MY_LOCATION" value:@"" table:@"InfoPlist-OrbHW"] localizedSubtitle:nil icon:[[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeShare]] userInfo:nil];
  UIMutableApplicationShortcutItem *searchNearBy = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.Maps.search-nearby" localizedTitle:[[NSBundle mainBundle] localizedStringForKey:@"QUICK_ACTION_SEARCH_NEARBY" value:@"" table:@"InfoPlist-OrbHW"] localizedSubtitle:nil icon:[[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeSearch]] userInfo:nil];
  [[UIApplication sharedApplication] setShortcutItems: @[ directionHome, markLocation, shareLocation, searchNearBy ]];
  return %orig;
}
%end

%ctor {
	if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.Maps"]) { // Maps App
          %init;
    }
}