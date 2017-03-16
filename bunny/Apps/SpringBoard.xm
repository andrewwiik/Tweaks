#import <substrate.h>
#import "interface.h"

@interface SpringBoard
- (void)relaunchSpringBoard;
- (void)reboot;
- (void)_rebootNow:(id)arg1;
- (void)_powerDownNow;
-(void)_relaunchSpringBoardNow;
@end

@interface SBApplicationShortcutMenu : NSObject
- (void)killMe;
- (void)safeMode;
- (void)reboot;
- (void)powerDown;
- (void)respring;
@end

%hook SBApplicationShortcutServer
- (id)_sanitizeShortcutItems:(id)arg1 entitlements:(unsigned long long)arg2 {
   return arg1;
}
%end

%hook SBApplicationShortcutStoreManager
- (id)shortcutItemsForBundleIdentifier:(id)identifier {
   if ([identifier isEqualToString:@"com.apple.Preferences"]) {
      UIApplicationShortcutItem *respring = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple.Preferences.respring" localizedTitle:@"Respring"];
      UIApplicationShortcutItem *reboot = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple.Preferences.reboot" localizedTitle:@"Reboot"];
      UIApplicationShortcutItem *power = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple.Preferences.powerdown" localizedTitle:@"Power Down"];
      UIApplicationShortcutItem *safemode = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple.Preferences.safemode" localizedTitle:@"Safe Mode"];
      return [NSMutableArray arrayWithObjects:respring, reboot, power, safemode, nil];
   }
   else return %orig;
}
%end

%hook SBApplicationShortcutMenu
%new
- (void)respring {
   [(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
}
%new
- (void)safeMode {
   [self killMe];
}
%new
- (void)reboot {
   [(SpringBoard *)[UIApplication sharedApplication] _rebootNow:nil];
}
%new
- (void)powerDown {
   [(SpringBoard *)[UIApplication sharedApplication] _powerDownNow];
}

- (void)menuContentView:(id)arg1 activateShortcutItem:(UIApplicationShortcutItem*)arg2 index:(long long)arg3 {
   NSString *input = arg2.type;

   if ([input isEqualToString:@"com.apple.Preferences.respring"]) {
      [self respring];
      return;
   }
   else if ([input isEqualToString:@"com.apple.Preferences.reboot"]) {
      [self reboot];
      return;
   }
   else if ([input isEqualToString:@"com.apple.Preferences.powerdown"]) {
      [self powerDown];
      return;
   }
   else if ([input isEqualToString:@"com.apple.Preferences.safemode"]) {
      [self safeMode];
      return;
   }
   else {
      %orig;
   }
}
%end

%hook SBSApplicationShortcutItem
- (id)bundleIdentifierToLaunch {
   if ([[self type] isEqualToString:@"com.apple.callservicesd.dialrecent"]) {
   return [NSString stringWithFormat:@"com.apple.InCallService"];
   }
   else return %orig;
}
%end
%ctor {
   if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) { // SpringBoard
          %init;
   }
}