#import <substrate.h>
#import "interface.h"

@interface GBMConversationsStore : NSObject
@end

@interface GBMConversationSyncer : NSObject
@end

@interface GBMUserClient : NSObject
@property(retain, nonatomic) GBMConversationSyncer *conversationsClient;
@end

@interface GBMAvatar : NSObject
- (id)cachedAvatarForType:(int)type;
@end

@interface GBMConversation : NSObject
- (NSString*)displayName;
- (NSMutableArray*)participantPersons;
@end

@interface GPCPerson : NSObject
- (GBMAvatar *)avatar;
@end

@interface GBAConversationListViewController : UIViewController
-(NSArray*)conversations;
@end

@interface GBAApplicationDelegate : NSObject
- (void)navigateToConversation:(id)arg1 userInfo:(id)arg2;
- (void)navigateToCompose:(id)arg1 groupChat:(int)arg2 withEntities:(id)arg3;
- (void)updateDynamicQuickActions:(NSArray*)recentConversations;
+ (id)sharedDelegate;
- (NSMutableArray*)conversations;
- (void)setupNewViewControllers;
- (GBMUserClient *)savedUserClient;
@end

NSArray* RecentConversationsDataSource; // Recent Conversations
NSMutableArray* ConversationsInstances; // Instances of GBMConversation
GBMConversationSyncer* ConversationsLookUp; // Where to find conversations
GBAConversationListViewController* ConversationListController; // The Conversation List controller

%hook GBAApplicationDelegate
%new
- (NSMutableArray *)conversations { //get all the conversations 
   GBMConversationSyncer *conversationsListPartOne = [self savedUserClient].conversationsClient;
   GBMConversationsStore *ConversationsStore = MSHookIvar<id>(conversationsListPartOne,"_conversationsStore");
   NSMutableOrderedSet *ConversationSetPartTwo = MSHookIvar<id>(ConversationsStore,"_conversationsKeepAliveLRUCache");
   NSArray *FinalConversationsStoreArray = [ConversationSetPartTwo array];
   NSMutableArray *Final = [FinalConversationsStoreArray mutableCopy]; 
   return Final;
}
%new
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
   if ([shortcutItem.type isEqualToString:@"com.google.hangouts.newchat"]) { // if the shortcut was meant to create a new chat
      [self navigateToCompose:nil groupChat:nil withEntities:nil];
   }
   if ([shortcutItem.type isEqualToString:@"com.google.hangouts.conversation"]) { // if the shortcut was to a recent conversation
      NSDictionary *userInfo = shortcutItem.userInfo;
      NSString *DisplayName = [NSString stringWithFormat:@"%@", [userInfo valueForKey:@"Conversation_Name"]];
      NSMutableArray *ConversationsArray = [self conversations];
      NSUInteger count = [ConversationsArray count];
      for (NSUInteger i = 0; i < count; i++) {
         GBMConversation *conversation = [ConversationsArray objectAtIndex: i];
         if ([[conversation displayName] isEqualToString: DisplayName]) {
            [self navigateToConversation: conversation userInfo:nil];
         }
      }
      [self setupNewViewControllers];
      //NSLog(@"Conversations: %@", ConversationListController);

   }
    //NSLog(@"%@-%@-%@", shortcutItem.type, shortcutItem.localizedTitle, shortcutItem.localizedSubtitle);
    
    completionHandler(YES);
}
%new
-(void)updateDynamicQuickActions:(NSArray*)recentConversations { // update the recent conversations shortcut items
   NSMutableArray* shortcutItems = [[NSMutableArray alloc] init];
   UIApplicationShortcutIcon *newChatShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeCompose]];
   //UIApplicationShortcutIcon *newChatShortcutIcon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType: UIApplicationShortcutIconTypeCompose];
   UIApplicationShortcutItem *NewChat = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.google.hangouts.newchat" localizedTitle:@"New Chat" localizedSubtitle: nil icon:newChatShortcutIcon userInfo:nil];
   [shortcutItems addObject: NewChat];
   NSUInteger count = [recentConversations count];
   if (count > 0) {
      for (GBMConversation* conversation in recentConversations) {
            if ([conversation isKindOfClass:[%c(GBMConversation) class]]) {
            GPCPerson *conversationContact = [[conversation participantPersons] objectAtIndex: 0];
            GBMAvatar *conversationContactAvatar = [conversationContact avatar];
            UIImage *conversationContactAvatarImage = [conversationContactAvatar cachedAvatarForType: 0];
            NSArray *FirstLastArray = [[conversation displayName] componentsSeparatedByString:@" "];
            NSString *FirstName = nil;
            NSString *LastName = nil;
            if ([FirstLastArray count] > 0) {
            FirstName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 0]];
            if ([FirstLastArray count] > 1)
            LastName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 1]];
            }
            // UIImage *conversationContactAvatarImageRounded = [conversationContactAvatarImage th_roundedCornerImage: conversationContactAvatarImage.size.width / 2 borderSize: 0];
            NSData *conversationContactAvatarImageData = UIImagePNGRepresentation(conversationContactAvatarImage);
            UIApplicationShortcutIcon *conversationContactAvatarShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: FirstName lastName: LastName imageData:conversationContactAvatarImageData]];
            //NSLog(@"Recent Conversation %@", conversation);
            NSString* conversationID = MSHookIvar<NSString *>(conversation,"_conversationId");
            NSMutableDictionary* userInfoData = [NSMutableDictionary new];
            [userInfoData setObject: conversationID forKey:@"ConversationID"];
            if (conversationContactAvatarImageData) {
               [userInfoData setObject: conversationContactAvatarImageData forKey:@"Avatar"];
            }
            [userInfoData setObject: [conversation displayName] forKey:@"Conversation_Name"];

            UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.google.hangouts.conversation"] localizedTitle:[conversation displayName] localizedSubtitle: nil icon:conversationContactAvatarShortcutIcon userInfo:userInfoData];
            [shortcutItems addObject: recentConversation];
      
   }
   }
   }
   [[UIApplication sharedApplication] setShortcutItems: nil];
   [UIApplication sharedApplication].shortcutItems = nil;
   [[UIApplication sharedApplication] setShortcutItems: shortcutItems];
   [UIApplication sharedApplication].shortcutItems = shortcutItems;
}
%end

%hook GBAConversationListViewController
- (void)updateConversationViewIfNecessary {
   %orig;
   [[%c(GBAApplicationDelegate) sharedDelegate] updateDynamicQuickActions:[self conversations]]; // update shortcut items
}
%end

%ctor {
   if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.google.hangouts"]) { // Google Hangouts
          %init;
      }
}