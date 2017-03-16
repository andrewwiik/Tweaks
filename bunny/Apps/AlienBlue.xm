#import "interface.h"
#import <substrate.h>
@interface NavigationManager : NSObject
+ (instancetype)shared;
- (void)showCreatePostScreen;
@end

@interface AlienBlueAppDelegate : NSObject
@end

%hook AlienBlueAppDelegate
- (id)init {
  %orig;
  NSMutableArray *shortcutItems = [[NSMutableArray alloc] init];
  UIApplicationShortcutIcon *newPostShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeCompose]];
  //UIApplicationShortcutIcon *newChatShortcutIcon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType: UIApplicationShortcutIconTypeCompose];
  UIApplicationShortcutItem *NewPost = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"NewPost" localizedTitle:@"New Post" localizedSubtitle: nil icon:newPostShortcutIcon userInfo:nil];
  [shortcutItems addObject: NewPost];
  [UIApplication sharedApplication].shortcutItems = shortcutItems;
  return %orig;
}
%new
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
  if ([shortcutItem.type isEqualToString:@"NewPost"]) {
    [[%c(NavigationManager) shared] showCreatePostScreen];
  }
  completionHandler(YES);
}
%end

%ctor {
  if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.reddit.alienblue"]) { //AlienBlue
          %init;
      }
}