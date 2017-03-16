#import <substrate.h>
#import "interface.h"

@interface CNContact : NSObject
@property (nonatomic, readonly, copy) NSString *identifier;
@end

@interface PHFrecentViewController : UIViewController
- (NSMutableArray*)recentCalls;
- (void)updateShortcuts;
@end

@interface PHFrecentCell : NSObject
- (id)_contactForCall:(id)arg1;
@end

%hook PHFrecentViewController
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
   PHFrecentCell *contactHelper = [[%c(PHFrecentCell) alloc] init];
   if (count > 11) {
      count = 11;
   }
   for (NSUInteger i = 0; i < count; i++) {

      CNContact *contact = [contactHelper _contactForCall:[calls objectAtIndex:i]];
      NSString *contactIdentifier = contact.identifier;
      //NSLog(@"Contact ID: %@",contactIdentifier);
      UIApplicationShortcutItem *recentCall = [[%c(UIApplicationShortcutItem) alloc] initWithSBSApplicationShortcutItem:[%c(TUApplicationDialShortcut) shortcutItemForRecent:[calls objectAtIndex:i] withContactIdentifier:contactIdentifier]];
      //NSLog(@"Recent Call Shortcut: %@", recentCall);
      [shortcuts addObject:recentCall];
   }
   [UIApplication sharedApplication].shortcutItems = shortcuts;
}
%end

%ctor {
   if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.facetime"]) { // FaceTime App
      %init;
   }
}