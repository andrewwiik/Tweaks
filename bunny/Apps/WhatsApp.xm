#import <substrate.h>
#import "interface.h"

NSArray* shortcutItemsShared; // Shared Shortcut Items

@interface WAVoiceCallViewController : UIViewController
- (void)minimizeWithAnimation:(_Bool)arg1;
@end

@interface WhatsAppAppDelegate : NSObject {
   WAVoiceCallViewController *_activeVoiceCallViewController;
}
@property(readonly, nonatomic) _Bool isCallWindowVisible;
@property(readonly, nonatomic) UITabBarController *tabBarController; // @synthesize 
@property(retain, nonatomic) NSString *chatJID; // @synthesize chatJID=_chatJID;
- (void)revm_PerformLastChat;
- (void)openChatAnimated:(_Bool)arg1 presentKeyboard:(_Bool)arg2;
- (void)updateDynamicQuickActions;
- (void)openConversationWithID:(NSString *)arg1;
@end

@interface WAApplication : UIApplication
+ (WhatsAppAppDelegate *)wa_delegate;
@end

@interface WAChatSession : NSObject
@property(retain, nonatomic) NSString *contactJID; // @dynamic contactJID;
@property(retain, nonatomic) NSString *partnerName; // @dynamic partnerName;
@end

@interface WAChatStorage : NSObject
- (NSArray *)allChatSessions;
@end

@interface WAProfilePictureManager
- (id)pictureDataForJID:(id)arg1;
- (id)profilePictureThumbnailForJID:(id)arg1;
@end

@interface WASharedAppData : NSObject
+ (WAChatStorage *)chatStorage;
+ (WAProfilePictureManager *)profilePictureManager;
@end

%hook ChatManager
- (void)chatStorage:(id)arg1 didUpdateChatSessions:(id)arg2 {
   %orig;
   [[%c(WAApplication) wa_delegate] updateDynamicQuickActions];
}
%end

%hook WhatsAppAppDelegate
%new
- (void)updateDynamicQuickActions {
   dispatch_async(dispatch_get_main_queue(), ^{ // Update shortcut items
      NSArray* recentConversations =  [[%c(WASharedAppData) chatStorage] allChatSessions]; // get list of conversations
      NSMutableArray* shortcutItems = [[NSMutableArray alloc] init]; // create a new array to hodl the shortcut items
      
      // UIApplicationShortcutIcon *searchShortcutIcon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeSearch];
      UIApplicationShortcutIcon *searchShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeSearch]];
      UIApplicationShortcutItem *Search = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"Search" localizedTitle:@"Search" localizedSubtitle: nil icon:searchShortcutIcon userInfo:nil];
      [shortcutItems addObject: Search]; // add the search shortcut items to our shortcut items array
   
      UIApplicationShortcutIcon *newChatShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeCompose]];
      //UIApplicationShortcutIcon *newChatShortcutIcon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType: UIApplicationShortcutIconTypeCompose];
      UIApplicationShortcutItem *NewChat = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"NewChat" localizedTitle:@"New Chat" localizedSubtitle: nil icon:newChatShortcutIcon userInfo:nil];
      [shortcutItems addObject: NewChat]; // add the new chat shortcut item to our shortcut items array
   
      NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"lastMessageDate"  ascending:NO]; // How to sort conversations
      NSMutableArray *correctOrderArray = [[recentConversations sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]]mutableCopy]; // Sort Conversations by date
      NSArray *FinalConversationArray = [correctOrderArray copy]; // create nonmutable array
      recentConversations = FinalConversationArray; // set our final Conversations array
      
      NSUInteger count = [recentConversations count]; // number of recent conversations
      // NSLog(@"Recent Conversatons: %@", recentConversations);
      for (NSUInteger i = 0; i < count; i++) {
         if (i < 4) {
         WAChatSession *conversation = [recentConversations objectAtIndex: i];
         NSArray *FirstLastArray = [conversation.partnerName componentsSeparatedByString:@" "];
         NSString *FirstName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 0]];
         if ([FirstLastArray count] > 1) {
            UIImage *conversationContactAvatarImage = [[%c(WASharedAppData) profilePictureManager] profilePictureThumbnailForJID: conversation.contactJID];
            NSData *conversationContactAvatarImageData = UIImagePNGRepresentation(conversationContactAvatarImage);
            NSString *LastName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 1]];
            UIApplicationShortcutIcon *conversationContactAvatarShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: FirstName lastName: LastName imageData:conversationContactAvatarImageData]];
            NSMutableDictionary* userInfoData = [NSMutableDictionary new];
            [userInfoData setObject: conversation.contactJID forKey:@"contactJID"];
            UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"net.whatsapp.WhatsApp.conversation"] localizedTitle:conversation.partnerName localizedSubtitle: nil icon:conversationContactAvatarShortcutIcon userInfo:userInfoData];
            [shortcutItems addObject: recentConversation];
         }
         else {
            UIImage *conversationContactAvatarImage = [[%c(WASharedAppData) profilePictureManager] profilePictureThumbnailForJID: conversation.contactJID];
            NSData *conversationContactAvatarImageData = UIImagePNGRepresentation(conversationContactAvatarImage);
            UIApplicationShortcutIcon *conversationContactAvatarShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: FirstName lastName: nil imageData:conversationContactAvatarImageData]];
            NSMutableDictionary* userInfoData = [NSMutableDictionary new];
            [userInfoData setObject: conversation.contactJID forKey:@"contactJID"];
            UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"net.whatsapp.WhatsApp.conversation"] localizedTitle:conversation.partnerName localizedSubtitle: nil icon:conversationContactAvatarShortcutIcon userInfo:userInfoData];
            [shortcutItems addObject: recentConversation];
         }
      }
   
      }
      // NSLog(@"Chat Updated");
      shortcutItemsShared = shortcutItems; // set our shared shortcut items
      [UIApplication sharedApplication].shortcutItems = shortcutItems; // add shortcut items to the app
   });

}

- (void)configureShortcutItemsForApplication:(UIApplication *)arg1 {
   [self updateDynamicQuickActions]; // update shortcut items
}

- (void)application:(id)arg1 performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(id)arg3 {
   %orig;
   if ([shortcutItem.type isEqualToString:@"net.whatsapp.WhatsApp.conversation"]) {
      NSDictionary *userInfo = shortcutItem.userInfo;
      NSString *contactJID = [NSString stringWithFormat:@"%@", [userInfo valueForKey:@"contactJID"]];
      [self openConversationWithID: contactJID];
   }
}

%new
- (void)openConversationWithID:(NSString *)ChatID {
if ([self isCallWindowVisible]) {
      WAVoiceCallViewController *callVC = MSHookIvar<WAVoiceCallViewController *>(self, "_activeVoiceCallViewController");
      [callVC minimizeWithAnimation:NO];
   }
   [self setChatJID:ChatID];
   if (self.tabBarController.selectedViewController.presentedViewController) {
      [[self.tabBarController selectedViewController] dismissViewControllerAnimated:NO completion:nil];
   }
   [self openChatAnimated:YES presentKeyboard:NO];
}
%end

%ctor {
   if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"net.whatsapp.WhatsApp"]) { // WhatsApp ,m n 
          %init;
   }
}