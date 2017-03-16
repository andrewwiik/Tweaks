@interface CNContact : NSObject
@property (nonatomic, readonly, copy) NSString *identifier;
@end
@interface CKEntity : NSObject
@property (nonatomic, retain) CNContact *cnContact;
@end

@interface IMChat : NSObject
@property (nonatomic, readonly) NSString *guid;
@end

@interface CKConversation : NSObject
@property (nonatomic, retain) IMChat *chat;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, readonly, retain) NSString *previewText;
@property (nonatomic, readonly, retain) CKEntity *recipient;
@end

@interface CKConversationList : NSObject
+ (instancetype)sharedConversationList;
- (NSMutableArray*)conversations;
@end

%hook UIApplication
- (id)shortcutItems {
   NSMutableArray *conversations = [[%c(CKConversationList) sharedConversationList] conversations];
   NSUInteger count = [conversations count];
   NSMutableArray* shortcuts = [[NSMutableArray alloc] init];
   if (count > 11) {
      count = 11;
   }
   for (NSUInteger i = 0; i < count; i++) {
      CKConversation *conversation = [conversations objectAtIndex:i];
      CNContact *contact = conversation.recipient.cnContact;
      NSString *displayName = conversation.name;
      NSString *guid = conversation.chat.guid;
      NSString *subText = conversation.previewText;
      NSMutableDictionary* userInfoData = [NSMutableDictionary new];
      [userInfoData setObject: guid forKey:@"CKSBActionUserInfoKeyChatGUID"];
      UIApplicationShortcutIcon *shortcutIcon = [%c(UIApplicationShortcutIcon) iconWithContact:contact];
      UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.apple.mobilesms.conversation"] localizedTitle:displayName localizedSubtitle: subText icon:shortcutIcon userInfo:userInfoData];
      [shortcuts addObject:recentConversation];
   }
   return shortcuts;
}
-(void)setShortcutItems:(id)arg1 {
   NSMutableArray *conversations = [[%c(CKConversationList) sharedConversationList] conversations];
   NSUInteger count = [conversations count];
   NSMutableArray* shortcuts = [[NSMutableArray alloc] init];
   if (count > 11) {
      count = 11;
   }
   for (NSUInteger i = 0; i < count; i++) {
      CKConversation *conversation = [conversations objectAtIndex:i];
      CNContact *contact = conversation.recipient.cnContact;
      NSString *displayName = conversation.name;
      NSString *guid = conversation.chat.guid;
      NSString *subText = conversation.previewText;
      NSMutableDictionary* userInfoData = [NSMutableDictionary new];
      [userInfoData setObject: guid forKey:@"CKSBActionUserInfoKeyChatGUID"];
      UIApplicationShortcutIcon *shortcutIcon = [%c(UIApplicationShortcutIcon) iconWithContact:contact];
      UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.apple.mobilesms.conversation"] localizedTitle:displayName localizedSubtitle: subText icon:shortcutIcon userInfo:userInfoData];
      [shortcuts addObject:recentConversation];
   }
   %orig(shortcuts);
}
%end
/*%hook SMSApplication
- (BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 { // Messages App finished Launching
   %orig; // call original action 
   [[%c(CKSpringBoardActionManager) alloc] updateShortcutItems]; // Get Shortcut Actions Manager for Messages App
   return %orig(arg1, arg2); // return original object
}
- (void)_chatItemsDidChange:(id)arg1 { // We recieved or sent a message
   %orig; // call original method
   NSMutableArray *conversations = [[%c(CKConversationList) sharedConversationList] conversations];
   NSUInteger count = [conversations count];
   NSMutableArray* shortcuts = [[NSMutableArray alloc] init];
   if (count > 11) {
      count = 11;
   }
   for (NSUInteger i = 0; i < count; i++) {
      CKConversation *conversation = [conversations objectAtIndex:i];
      CNContact *contact = conversation.recipient.cnContact;
      NSString *displayName = conversation.name;
      NSString *guid = conversation.chat.guid;
      NSString *subText = conversation.previewText;
      NSMutableDictionary* userInfoData = [NSMutableDictionary new];
      [userInfoData setObject: guid forKey:@"CKSBActionUserInfoKeyChatGUID"];
      UIApplicationShortcutIcon *shortcutIcon = [%c(UIApplicationShortcutIcon) iconWithContact:contact];
      UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.apple.mobilesms.conversation"] localizedTitle:displayName localizedSubtitle: subText icon:shortcutIcon userInfo:userInfoData];
      [shortcuts addObject:recentConversation];
   }
   [UIApplication sharedApplication].shortcutItems = shortcuts;

}
%end*/

%ctor {
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.MobileSMS"]) { // Messages App
          %init;
     }
}