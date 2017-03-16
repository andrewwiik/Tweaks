#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



typedef enum UIApplicationShortcutIconType : NSInteger {
   UIApplicationShortcutIconTypeCompose,
   UIApplicationShortcutIconTypePlay,
   UIApplicationShortcutIconTypePause,
   UIApplicationShortcutIconTypeAdd,
   UIApplicationShortcutIconTypeLocation,
   UIApplicationShortcutIconTypeSearch,
   UIApplicationShortcutIconTypeShare,
   UIApplicationShortcutIconTypeProhibit,
   UIApplicationShortcutIconTypeContact,
   UIApplicationShortcutIconTypeHome,
   UIApplicationShortcutIconTypeMarkLocation,
   UIApplicationShortcutIconTypeFavorite,
   UIApplicationShortcutIconTypeLove,
   UIApplicationShortcutIconTypeCloud,
   UIApplicationShortcutIconTypeInvitation,
   UIApplicationShortcutIconTypeConfirmation,
   UIApplicationShortcutIconTypeMail,
   UIApplicationShortcutIconTypeMessage,
   UIApplicationShortcutIconTypeDate,
   UIApplicationShortcutIconTypeTime,
   UIApplicationShortcutIconTypeCapturePhoto,
   UIApplicationShortcutIconTypeCaptureVideo,
   UIApplicationShortcutIconTypeTask,
   UIApplicationShortcutIconTypeTaskCompleted,
   UIApplicationShortcutIconTypeAlarm,
   UIApplicationShortcutIconTypeBookmark,
   UIApplicationShortcutIconTypeShuffle,
   UIApplicationShortcutIconTypeAudio,
   UIApplicationShortcutIconTypeUpdate 
} UIApplicationShortcutIconType;


@interface UIApplicationShortcutIcon : NSObject
+ (id)iconWithCustomImage:(id)arg1;
+ (id)iconWithTemplateImageName:(id)arg1;
+ (BOOL)supportsSecureCoding;
- (unsigned int)hash;
- (id)initWithSBSApplicationShortcutIcon:(id)arg1;
- (BOOL)isEqual:(id)arg1;
// Image: /System/Library/Frameworks/ContactsUI.framework/ContactsUI

+ (id)iconWithContact:(id)arg1;

@end

@interface SBIconView : UIView
@property(retain, nonatomic) UILongPressGestureRecognizer *shortcutMenuPeekGesture;
@property(assign, nonatomic) BOOL isEditing;
@property(retain, nonatomic) id icon;
- (void)_handleSecondHalfLongPressTimer:(id)arg1;
- (void)cancelLongPressTimer;
- (id)delegate;
@end

@interface SBApplication : NSObject
@property(copy, nonatomic) NSArray *dynamicShortcutItems;
@property(copy, nonatomic) NSArray *staticShortcutItems;
- (NSString*)bundleIdentifier;
- (NSString*)displayName;
@end

@interface SBIcon : NSObject
- (void)launchFromLocation:(int)location;
- (BOOL)isFolderIcon;// iOS 4+
- (NSString*)applicationBundleID;
- (SBApplication*)application;
- (id)generateIconImage:(int)arg1;
- (id)displayName;
-(id)leafIdentifier;
- (id)displayNameForLocation:(int)arg1;
@end
@interface SBFolder : NSObject
- (SBIcon*)iconAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface SBFolderIcon : NSObject
- (SBFolder*)folder;
@end
@interface SBFolderIconView : SBIconView
- (SBFolderIcon*)folderIcon;
@end

@interface IMDChatRegistry : NSObject
+ (instancetype)sharedInstance;
- (BOOL)loadChatsWithCompletionBlock:(id /* block */)arg1;
- (void)run;

+ (void)performBlockOnMainThreadSynchronously:(id)arg1;

@end
@interface UIPreviewInteractionController : NSObject
- (void)commitInteractivePreview;
@end
@interface UIApplicationShortcutItem : NSObject

+ (unsigned int)_sbsActivationModeFromUIActivationMode:(unsigned int)arg1;
+ (unsigned int)_uiActivationModeFromSBSActivationMode:(unsigned int)arg1;
+ (BOOL)supportsSecureCoding;

- (id)_initWithType:(id)arg1 localizedTitle:(id)arg2 localizedSubtitle:(id)arg3 icon:(id)arg4 userInfoData:(id)arg5 activationMode:(unsigned int)arg6;
- (unsigned int)activationMode;
- (id)description;
- (unsigned int)hash;
- (id)icon;
- (id)init;
- (id)initWithSBSApplicationShortcutItem:(id)arg1;
- (id)initWithType:(id)arg1 localizedTitle:(id)arg2;
- (id)initWithType:(id)arg1 localizedTitle:(id)arg2 localizedSubtitle:(id)arg3 icon:(id)arg4 userInfo:(id)arg5;
- (BOOL)isEqual:(id)arg1;
- (id)localizedSubtitle;
- (id)localizedTitle;
- (id)sbsShortcutItem;
- (void)setActivationMode:(unsigned int)arg1;
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
- (void)setUserInfo:(id)arg1;
- (void)setUserInfoData:(id)arg1;
- (id)type;
- (id)userInfo;
- (id)userInfoData;

@end
@interface UIMutableApplicationShortcutItem : UIApplicationShortcutItem

@property (nonatomic) unsigned int activationMode;
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSDictionary *userInfo;

@end
@interface SBSApplicationShortcutIcon : NSObject

@end

@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
@end

@interface SBSApplicationShortcutIcon (UF)
- (id)initWithType:(UIApplicationShortcutIconType)arg1;
@end

@interface SBSApplicationShortcutContactIcon : SBSApplicationShortcutIcon
-(instancetype)initWithContactIdentifier:(NSString *)contactIdentifier;
-(instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
-(instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName imageData:(NSData *)imageData;
@end

@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
@property (nonatomic, readonly, retain) NSData *imagePNGData;
-(instancetype)initWithImagePNGData:(NSData *)imageData;
@end

@interface UIApplication (QuickSettings)
@property (nonatomic, copy) NSArray *shortcutItems;
-(void)setShortcutItems:(NSArray*)arg1;
@end

@interface CKSpringBoardActionManager
- (void)updateShortcutItems;
@end

@interface AXForceTouchController : UIViewController
@end

@interface SBSApplicationShortcutItem : NSObject
- (void)setBundleIdentifierToLaunch:(id)arg1;
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
- (void)setUserInfo:(id)arg1;
- (void)setUserInfoData:(id)arg1;
@end

@class SBApplicationShortcutMenu;
@protocol SBApplicationShortcutMenuDelegate <NSObject>
- (void)applicationShortcutMenu:(SBApplicationShortcutMenu *)arg1 launchApplicationWithIconView:(SBIconView *)arg2;
- (void)applicationShortcutMenu:(SBApplicationShortcutMenu *)arg1 startEditingForIconView:(SBIconView *)arg2;
- (void)applicationShortcutMenu:(SBApplicationShortcutMenu *)arg1 activateShortcutItem:(SBSApplicationShortcutItem *)arg2 index:(long long)arg3;

@optional
- (void)applicationShortcutMenuDidPresent:(SBApplicationShortcutMenu *)arg1;
- (void)applicationShortcutMenuDidDismiss:(SBApplicationShortcutMenu *)arg1;
@end



%group Maps
%hook MapsAppDelegate
- (id)init {
  %orig;
  UIApplicationShortcutIcon *directionsIcon = [%c(UIApplicationShortcutIcon) iconWithTemplateImageName:@"action-home-OrbHW"];
  UIApplicationShortcutIcon *markIcon = [%c(UIApplicationShortcutIcon) iconWithTemplateImageName:@"action-drop-pin-OrbHW"];

  UIMutableApplicationShortcutItem *directionHome = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.Maps.directions" localizedTitle:[[NSBundle mainBundle] localizedStringForKey:@"QUICK_ACTION_DIRECTIONS_HOME" value:@"" table:@"InfoPlist-OrbHW"] localizedSubtitle:nil icon:directionsIcon userInfo:nil];
  UIMutableApplicationShortcutItem *markLocation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.Maps.mark-my-location" localizedTitle:[[NSBundle mainBundle] localizedStringForKey:@"QUICK_ACTION_MARK_MY_LOCATION" value:@"" table:@"InfoPlist-OrbHW"] localizedSubtitle:nil icon:markIcon userInfo:nil];
  UIMutableApplicationShortcutItem *shareLocation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.Maps.share-location" localizedTitle:[[NSBundle mainBundle] localizedStringForKey:@"QUICK_ACTION_SEND_MY_LOCATION" value:@"" table:@"InfoPlist-OrbHW"] localizedSubtitle:nil icon:[[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeShare]] userInfo:nil];
  UIMutableApplicationShortcutItem *searchNearBy = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.Maps.search-nearby" localizedTitle:[[NSBundle mainBundle] localizedStringForKey:@"QUICK_ACTION_SEARCH_NEARBY" value:@"" table:@"InfoPlist-OrbHW"] localizedSubtitle:nil icon:[[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeSearch]] userInfo:nil];
  [[UIApplication sharedApplication] setShortcutItems: @[ directionHome, markLocation, shareLocation, searchNearBy ]];
  return %orig;
}
%end
%end
%ctor {
	%init;
	if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.Maps"]) {
          %init(Maps);
      }
 }