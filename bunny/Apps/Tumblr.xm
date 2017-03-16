#import <substrate.h>
#import "interface.h"

@interface MessagingCoordinator : NSObject
- (void)blogYnitiateConversationFromBlogUUID:(id)arg1 toBlogUUID:(id)arg2;
@end

@interface ApplicationCoordinator : NSObject
- (MessagingCoordinator *)createMessagingCoordinator:(id)arg1;
@end

@interface TMBlogViewController : UIViewController
- (void)initiateConversation;
@end

@interface TMBlogViewControllerCreator : NSObject
+ (TMBlogViewController *)controllerForBlogName:(id)name theme:(id)theme postID:(id)post tag:(id)tag referringPost:(id)postRefer dataServiceFactory:(id)dataFactory requestSenderFactory:(id)requestFactory;
@end

@interface TMDiskCache : NSObject
+ (instancetype)sharedCache;
- (id)objectForKey:(id)key;
- (id)keyForEncodedFileURL:(id)url;
@end

@interface TMImageController : NSObject
+ (instancetype)sharedInstance;
- (TMDiskCache *)diskCache;
@end

@interface Message : NSObject
@property(retain, nonatomic) NSString *body;
@end

@interface Conversation : NSObject
@property(retain, nonatomic) Message *latestMessage;
@property(retain, nonatomic) NSMutableSet *participants;
@property(retain, nonatomic) NSString *identifier;
+ (instancetype)fetchConversationWithID:(id)arg1 context:(id)arg2;
@end

@interface TMBlog : NSObject
@property(retain, nonatomic) NSMutableSet *conversations;
@property(retain, nonatomic) NSString *uuid;
@property(retain, nonatomic) NSString *title;
@property(retain, nonatomic) NSString *name;
@end

@interface TMUser : NSObject
- (TMBlog *)primaryBlog;
@end

@interface TMTumblrCoreDataController : NSObject
- (TMUser *)mainContextUser;
@end

@interface TMAppDelegate : NSObject
+ (instancetype)sharedAppDelegate;
- (TMTumblrCoreDataController *)coreDataController;
- (ApplicationCoordinator *)applicationCoordinator;
- (void)updateShortcuts;
@end

@interface NSString (NSString_Extended)
- (NSString *)urlencode;
@end

@interface TMNavigationController : UINavigationController
@end

@implementation NSString (NSString_Extended)

- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' || 
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}
@end

@interface UIViewController (Creatix)
- (UINavigationController *)detailNavigationController;
@end

%hook TMAppDelegate
- (void)applicationDidEnterBackground:(id)arg1 {
   [self updateShortcuts];
   %orig;
}
%new
- (void)updateShortcuts {
   NSMutableArray *shortcutItems = [[NSMutableArray alloc] init];
   UIApplicationShortcutIcon *searchShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeSearch]];
   NSMutableDictionary* userInfoDataSearch = [NSMutableDictionary new];
   [userInfoDataSearch setObject: @"https://www.tumblr.com/search" forKey:@"url"];
   UIMutableApplicationShortcutItem *search = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"Search"] localizedTitle:@"Search" localizedSubtitle: nil icon:searchShortcutIcon userInfo:userInfoDataSearch];
   [shortcutItems addObject:search];
   NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"lastModified"  ascending:NO];
   NSMutableArray *conversations = [[[[[[self coreDataController] mainContextUser] primaryBlog].conversations allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sort,nil]] mutableCopy];
   NSUInteger conversationsCount = [conversations count];
   for (NSUInteger i = 0; i < conversationsCount; i++) {
      Conversation *conversation = [conversations objectAtIndex:i];
      NSString *otherPersonName = NULL;
      NSString *otherPersonURL = NULL;
      NSMutableArray *participants = [[conversation.participants allObjects] mutableCopy];
      NSUInteger participantCount = [participants count];
      NSData *otherPersonImageData = NULL;
      TMBlog *otherBlog = NULL;
      for (NSUInteger p = 0; p < participantCount; p++) {
         TMBlog *blog = [participants objectAtIndex:p];
         if (![blog.uuid isEqualToString:[[[self coreDataController] mainContextUser] primaryBlog].uuid]) {
            otherBlog = blog;
            otherPersonURL = blog.uuid;
            otherPersonName = blog.title;
         }
      }
      otherPersonImageData = [[[%c(TMImageController) sharedInstance] diskCache] objectForKey:[[[%c(TMImageController) sharedInstance] diskCache] keyForEncodedFileURL:[[NSString stringWithFormat:@"https://api.tumblr.com/v2/blog/%@/avatar/96", otherPersonURL] urlencode]]];
      NSArray *FirstLastArray = [otherPersonName componentsSeparatedByString:@" "];
      NSString *firstName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 0]];
      NSString *lastName = NULL;
      if ([FirstLastArray count] > 1) {
         lastName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 1]];
      }
      else {
         otherPersonName = otherBlog.name;
      }
      NSMutableDictionary* userInfoData = [NSMutableDictionary new];
      [userInfoData setObject: otherBlog.uuid forKey:@"BlogID"];
      //[userInfoData setObject: conversation.identifier forKey:@"ConversationID"];
      UIApplicationShortcutIcon *conversationIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: firstName lastName: lastName imageData:otherPersonImageData]];
      UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.tumblr.tumblr.conversation"] localizedTitle:otherPersonName localizedSubtitle: conversation.latestMessage.body icon:conversationIcon userInfo:userInfoData];
      [shortcutItems addObject:recentConversation];
   }
   [UIApplication sharedApplication].shortcutItems = shortcutItems;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
   %orig;
   if ([shortcutItem.type isEqualToString:@"com.tumblr.tumblr.conversation"]) {
      NSDictionary *userInfo = shortcutItem.userInfo;
      NSString *blogID = [NSString stringWithFormat:@"%@", [userInfo valueForKey:@"BlogID"]];
      [[[self applicationCoordinator] createMessagingCoordinator:[[[[UIApplication sharedApplication] keyWindow] rootViewController] detailNavigationController]] blogInitiateConversationFromBlogUUID:[[[self coreDataController] mainContextUser] primaryBlog].uuid toBlogUUID:blogID];

   }
   completionHandler(YES);
}
%end
%hook TumblrShortcutHelper
- (void)ensureHasSearch {
   [[%c(TMAppDelegate) sharedAppDelegate] updateShortcuts];
}
%end

%ctor {
  if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.tumblr.tumblr"]) { // Tumblr App
          %init(TumblrShortcutHelper=objc_getClass("Tumblr.ShortcutItemHelper"));
      }
}