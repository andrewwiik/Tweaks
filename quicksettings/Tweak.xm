#import <UIKit/UIKit.h>
@interface UIApplicationShortcutIcon : NSObject
+ (id)iconWithCustomImage:(id)arg1;
+ (id)iconWithTemplateImageName:(id)arg1;
+ (id)iconWithType:(int)arg1;
+ (BOOL)supportsSecureCoding;
- (unsigned int)hash;
- (id)initWithSBSApplicationShortcutIcon:(id)arg1;
- (BOOL)isEqual:(id)arg1;
- (id)sbsShortcutIcon;

// Image: /System/Library/Frameworks/ContactsUI.framework/ContactsUI

+ (id)iconWithContact:(id)arg1;

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
@interface UIApplication (QuickSettings)
@property (nonatomic, copy) NSArray *shortcutItems;
@end
%hook PreferencesAppController
%new
 - (void)createDynamicShortcutItems {
    
    UIApplicationShortcutIcon * photoIcon = [%c(UIApplicationShortcutIcon) iconWithCustomImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery70.png"]];
    UIApplicationShortcutItem *item1 = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple.Preferences.respring" localizedTitle:@"Respring"];
    UIApplicationShortcutItem *item2 = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple.Preferences.reboot" localizedTitle:@"Reboot"];
    UIApplicationShortcutItem *item3 = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple.Preferences.powerdown" localizedTitle:@"Power Down"];
    UIApplicationShortcutItem *item4 = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple.Preferences.safemode" localizedTitle:@"Safe Mode"];
    [item4 setIcon: photoIcon];
    // add all items to an array
    NSArray *items = @[item1, item2, item3, item4];
    
    // add the array to our app
    [UIApplication sharedApplication].shortcutItems = items;
}
%new
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    NSLog(@"%@-%@-%@", shortcutItem.type, shortcutItem.localizedTitle, shortcutItem.localizedSubtitle);
    
    completionHandler(YES);
}
%end
