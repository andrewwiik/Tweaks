#import <substrate.h>
#import "interface.h"

@interface ConversationsViewController : NSObject
- (void)didSelectChat:(id)chat;
@end

@interface KikUser : NSObject
- (NSString *)getDisplayName;
@end

@interface KikChat : NSObject
@property (nonatomic,retain) KikUser* user;
- (id)chatIdentifier;
@end

@interface KikProfilePictureHelper : NSObject
- (UIImage *)retrieveThumbProfilePictureForUser:(id)user;
@end

@interface KikChatHelper : NSObject
- (NSArray *)allChats;
- (NSMutableArray *)allChatsMutable;
-(id)chatForID:(id)arg1;
@end

@interface KikStorage : NSObject
- (KikChatHelper *)chats;
@end

@interface ChatManager : NSObject
- (KikStorage *)storage;
@end

@interface Core : NSObject
- (ChatManager *)chatManager;
- (KikProfilePictureHelper *)profilePictureHelper;
@end

@interface AppDelegate : NSObject
- (Core *)singleCore;
- (NSMutableArray*)allChats;
- (ConversationsViewController *)conversationsViewController;
+ (instancetype)appDelegate;
- (void)updateShortcuts;
@property (nonatomic, retain) NSArray *allChatsOrdered;
@end

%hook KikChatHelper
%new
- (NSMutableArray *)allChatsMutable {
  return [[self allChats] mutableCopy];
}
%end

%hook ChatManager
%new
- (id)storage {
  return  MSHookIvar<id>(self,"_storage");
}
%end

%hook AppDelegate
%property (nonatomic, retain) NSArray *allChatsOrdered; 
%new
- (void)allChats {
   if (self.allChatsOrdered) {

   }
   else {
      NSMutableArray *allChatsInitialArray = [[[[[self singleCore] chatManager] storage] chats] allChatsMutable];
  NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"dateUpdated"  ascending:NO];
  NSArray *correctOrderArray = [allChatsInitialArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
  self.allChatsOrdered = correctOrderArray;
   }
}

%new
- (void)updateShortcuts {
   dispatch_async(dispatch_get_main_queue(), ^{
      NSMutableArray *shortcutItems = [[NSMutableArray alloc] init];
      NSArray *chats = self.allChatsOrdered;
      NSUInteger count = [chats count];
      if (count >= 4) {
         for (NSUInteger i = 0; i < 4; i++) {
            KikChat *chatSession = [chats objectAtIndex: i];
            KikUser *otherPerson = chatSession.user;
            NSArray *FirstLastArray = [[otherPerson getDisplayName] componentsSeparatedByString:@" "];
            NSString *FirstName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 0]];
            if ([FirstLastArray count] > 1) {
               UIImage *conversationContactAvatarImage = [[[self singleCore] profilePictureHelper] retrieveThumbProfilePictureForUser: otherPerson];
               NSData *conversationContactAvatarImageData = UIImagePNGRepresentation(conversationContactAvatarImage);
               NSString *LastName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 1]];
               UIApplicationShortcutIcon *conversationContactAvatarShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: FirstName lastName: LastName imageData:conversationContactAvatarImageData]];
               NSMutableDictionary* userInfoData = [NSMutableDictionary new];
               [userInfoData setObject: [chatSession chatIdentifier] forKey:@"contactID"];
               UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.kik.chat.conversation"] localizedTitle:[otherPerson getDisplayName] localizedSubtitle: nil icon:conversationContactAvatarShortcutIcon userInfo:userInfoData];
               [shortcutItems addObject: recentConversation];
            }
            else {
               UIImage *conversationContactAvatarImage = [[[self singleCore] profilePictureHelper] retrieveThumbProfilePictureForUser: otherPerson];
               NSData *conversationContactAvatarImageData = UIImagePNGRepresentation(conversationContactAvatarImage);
               UIApplicationShortcutIcon *conversationContactAvatarShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: FirstName lastName: nil imageData:conversationContactAvatarImageData]];
               NSMutableDictionary* userInfoData = [NSMutableDictionary new];
               [userInfoData setObject: [chatSession chatIdentifier] forKey:@"contactID"];
               UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.kik.chat.conversation"] localizedTitle:[otherPerson getDisplayName] localizedSubtitle: nil icon:conversationContactAvatarShortcutIcon userInfo:userInfoData];
               [shortcutItems addObject: recentConversation];
            }
         }
      }
      else {
         for (NSUInteger i = 0; i < count; i++) {
            KikChat *chatSession = [chats objectAtIndex: i];
            KikUser *otherPerson = chatSession.user;
            NSArray *FirstLastArray = [[otherPerson getDisplayName] componentsSeparatedByString:@" "];
            NSString *FirstName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 0]];
            if ([FirstLastArray count] > 1) {
              UIImage *conversationContactAvatarImage = [[[self singleCore] profilePictureHelper] retrieveThumbProfilePictureForUser: otherPerson];
              NSData *conversationContactAvatarImageData = UIImagePNGRepresentation(conversationContactAvatarImage);
              NSString *LastName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 1]];
              UIApplicationShortcutIcon *conversationContactAvatarShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: FirstName lastName: LastName imageData:conversationContactAvatarImageData]];
              NSMutableDictionary* userInfoData = [NSMutableDictionary new];
              [userInfoData setObject: [chatSession chatIdentifier] forKey:@"contactID"];
              UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.kik.chat.conversation"] localizedTitle:[otherPerson getDisplayName] localizedSubtitle: nil icon:conversationContactAvatarShortcutIcon userInfo:userInfoData];
              [shortcutItems addObject: recentConversation];
            }
            else {
              UIImage *conversationContactAvatarImage = [[[self singleCore] profilePictureHelper] retrieveThumbProfilePictureForUser: otherPerson];
              NSData *conversationContactAvatarImageData = UIImagePNGRepresentation(conversationContactAvatarImage);
              UIApplicationShortcutIcon *conversationContactAvatarShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: FirstName lastName: nil imageData:conversationContactAvatarImageData]];
              NSMutableDictionary* userInfoData = [NSMutableDictionary new];
              [userInfoData setObject: [chatSession chatIdentifier] forKey:@"contactID"];
              UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.kik.chat.conversation"] localizedTitle:[otherPerson getDisplayName] localizedSubtitle: nil icon:conversationContactAvatarShortcutIcon userInfo:userInfoData];
              [shortcutItems addObject: recentConversation];
            }
         }
      }
      [UIApplication sharedApplication].shortcutItems = shortcutItems;
   });
}

%new
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
  if ([shortcutItem.type isEqualToString:@"com.kik.chat.conversation"]) {
    NSDictionary *userInfo = shortcutItem.userInfo;
    NSString *contactID = [NSString stringWithFormat:@"%@", [userInfo valueForKey:@"contactID"]];
    KikChat *currentChat = [[[[[self singleCore] chatManager] storage] chats] chatForID: contactID];
    [[self conversationsViewController] didSelectChat: currentChat];
  }
  completionHandler(YES);
}
%end

%hook KikStorage
/* - (void)watchAutoSave{
  %orig;
  [[%c(AppDelegate) appDelegate] updateShortcuts];
} */

- (void)save {
  %orig;
  [[%c(AppDelegate) appDelegate] allChats];
  [[%c(AppDelegate) appDelegate] updateShortcuts];
}


/*- (void)doSave {
  %orig;
  [[%c(AppDelegate) appDelegate] updateShortcuts];
} */

/* - (void)saveImmediately:(BOOL)arg1 {
    %orig;
  [[%c(AppDelegate) appDelegate] updateShortcuts];
} */

%end

%ctor {
  if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.kik.chat"]) { //Kik
          %init;
  }
}