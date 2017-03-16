#import <substrate.h>
#import "interface.h"

@interface VDBConversation : NSObject
+ (instancetype)mantleConversationFromManagedObject:(id)conversation;
@end

@interface Conversation : NSObject
@property(retain, nonatomic) NSDate *date;
@property(retain, nonatomic) NSString *name;
@property(retain, nonatomic) NSString *lastMessageText;
@property(retain, nonatomic) NSSet *phoneNumIndexes;
@property(retain, nonatomic) NSNumber *uid;
- (NSString*)iconURL;
@end

@interface DBManager : NSObject
- (NSArray*)conversationLines;
- (Conversation *)conversationWithUID:(id)arg1;
@end

@interface VIBInjector : NSObject
- (DBManager *)database;
@end

@interface VIBUIManager : NSObject
- (void)openConversationForPhoneNumIndex:(id)arg1 withScreenMode:(NSInteger)arg2 anim:(BOOL)arg3;
@end

@interface ViberAppDelegate : NSObject
- (VIBInjector *)injector;
- (VIBUIManager *)uiManager;
- (void)updateShortcuts;
@end

%hook ViberAppDelegate
- (void)applicationDidEnterBackground:(id)arg1 {
   [self updateShortcuts];
   %orig;
}
- (void)applicationDidBecomeActive:(id)arg1 {
   [self updateShortcuts];
   %orig;
}
%new
- (void)updateShortcuts {
   NSMutableArray *shortcutItems = [NSMutableArray new];
   NSMutableArray *conversations = [[[[self injector] database] conversationLines] mutableCopy];

   for (Conversation* conversation in conversations) {
      UIImage *conversationImage = [UIImage imageWithContentsOfFile:[conversation iconURL]];
      NSData *conversationImageData = UIImagePNGRepresentation(conversationImage);
      NSArray *FirstLastArray = [conversation.name componentsSeparatedByString:@" "];
      NSString *firstName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 0]];
      NSString *lastName = NULL;
      if ([FirstLastArray count] > 1) {
         lastName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 1]];
      }
      NSMutableDictionary* userInfoData = [NSMutableDictionary new];
      [userInfoData setObject: conversation.uid forKey:@"ConversationID"];
      UIApplicationShortcutIcon *conversationIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: firstName lastName: lastName imageData:conversationImageData]];
      //NSLog(@"Conversation Object: %@", conversation);

      UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.viber.conversation"] localizedTitle:conversation.name localizedSubtitle: conversation.lastMessageText icon:conversationIcon userInfo:userInfoData];
      [shortcutItems addObject:recentConversation];
   }
   [UIApplication sharedApplication].shortcutItems = shortcutItems;

}
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
   %orig;
   if ([shortcutItem.type isEqualToString:@"com.viber.conversation"]) {
      NSDictionary *userInfo = shortcutItem.userInfo;
      NSNumber *conversationID = @([[userInfo valueForKeyPath:@"ConversationID"] intValue]);
      //NSLog(@"Conversation ID: %@", [userInfo valueForKeyPath:@"ConversationID"]);
      //NSLog(@"Conversation: %@", [[[self injector] database] conversationWithUID:conversationID]);
      //[[self uiManager] _openConversation:[[[self injector] database] conversationWithUID:conversationID] withArgs:nil];
      //[[[self applicationCoordinator] createMessagingCoordinator:[[[[UIApplication sharedApplication] keyWindow] rootViewController] detailNavigationController]] initiateConversation:[[[self coreDataController] mainContextUser] primaryBlog].name toBlogName:blogID];
      [[self uiManager] openConversationForPhoneNumIndex:[[[[[self injector] database] conversationWithUID:conversationID].phoneNumIndexes allObjects] objectAtIndex:0] withScreenMode:0 anim:TRUE];
   }
   completionHandler(YES);
}
%end

%hook Conversation
//[[[[[self injector] database] conversationWithUID:conversationID].phoneNumIndexes allObjects] objectAtIndex:0]
%new
- (NSString*)iconURL {

   return [[[self.phoneNumIndexes allObjects] objectAtIndex:0] performSelector:@selector(iconPath)];
}
%end

%ctor {
   if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.viber"]) { // Viber App
          %init;
   }
}