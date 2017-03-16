#import "interface.h"
#import <substrate.h>

@interface CNContact : NSObject

@property (nonatomic, readonly, copy) NSString *identifier;

@end

@interface TUApplicationDialShortcut : NSObject

+ (BOOL)isShortcutItemType:(id)arg1;
+ (id)sharedFormatter;
+ (id)shortcutItemForContact:(id)arg1 withLabeledPhoneNumber:(id)arg2;
+ (id)shortcutItemForFavorite:(id)arg1 withAddressBookIdentifier:(int)arg2;
+ (id)shortcutItemForRecent:(id)arg1 withContactIdentifier:(id)arg2;
+ (id)shortcutItemWithTitle:(id)arg1 subtitle:(id)arg2 contactIdentifier:(id)arg3 URL:(id)arg4;
+ (id)urlForUserInfo:(id)arg1;

@end

@interface PHRecentsViewController : UIViewController

- (NSMutableArray *)recentCalls;
- (CNContact *)_contactForCall:(id)arg1;
- (void)updateShortcuts;

@end

%hook PHRecentsViewController
- (void)callHistoryControllerDatabaseDidChange:(id)arg1 {
   %orig;
   [self updateShortcuts];
}
- (void)setRecentCalls:(id)arg1 {
   %orig;
   [self updateShortcuts];
}
%new
- (void)updateShortcuts {
   NSMutableArray *calls = [self recentCalls];
   NSUInteger count = [calls count];
   NSMutableArray* shortcuts = [[NSMutableArray alloc] init];
   if (count > 11) {
      count = 11;
   }
   for (NSUInteger i = 0; i < count; i++) {

      CNContact *contact = [self _contactForCall:[calls objectAtIndex:i]];
      NSString *contactIdentifier = contact.identifier;
      //NSLog(@"Contact ID: %@",contactIdentifier);
      SBSApplicationShortcutItem *recentCallModify = [%c(TUApplicationDialShortcut) shortcutItemForRecent:[calls objectAtIndex:i] withContactIdentifier:contactIdentifier];
      //NSLog(@"Recent Call Shortcut: %@", recentCall);
      [recentCallModify setBundleIdentifierToLaunch:@"com.apple.InCallService"];
      UIApplicationShortcutItem *recentCall = [[%c(UIApplicationShortcutItem) alloc] initWithSBSApplicationShortcutItem:recentCallModify];
      [shortcuts addObject:recentCall];
   }
   [UIApplication sharedApplication].shortcutItems = shortcuts;
}
%end
%ctor {
   if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.mobilephone"]) { // Phone App
      %init;
   }
}