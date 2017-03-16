#import <UIKit/UIKit.h>

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(id)arg1;
@end
@interface SBApplicationShortcutStoreManager : NSObject
+ (id)sharedManager;
- (void)saveSynchronously;
- (void)setShortcutItems:(id)arg1 forBundleIdentifier:(id)arg2;
- (id)shortcutItemsForBundleIdentifier:(NSString*)arg1;
- (id)init;
@end
@interface SBApplication : NSObject
@property(copy, nonatomic) NSArray *staticShortcutItems;
- (NSString*)bundleIdentifier;
@end;

@interface SBApplicationShortcutMenu : UIView
@property(retain, nonatomic) SBApplication *application;
- (id)initWithFrame:(CGRect)arg1 application:(id)arg2 iconView:(id)arg3 interactionProgress:(id)arg4 orientation:(long long)arg5;
- (void)_setupViews;
- (void)_peekWithContentFraction:(double)arg1 smoothedBlurFraction:(double)arg2;
- (void)dismissAnimated:(_Bool)arg1 completionHandler:(id)arg2;
- (id)_shortcutItemsToDisplay;
@end
@interface SpringBoard : UIApplication
- (void)reboot;
- (void)powerDown;
@end
@interface SBApplicationShortcutMenuContentView : UIView
- (void)_presentForFraction:(double)arg1;
@end

@interface UIApplicationShortcutIcon()
@end
@interface SBSApplicationShortcutIcon : NSObject
@end
@interface SBSApplicationShortcutItem : NSObject
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
@end
@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
- (id)initWithType:(UIApplicationShortcutIconType)arg1;
@end
@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
- (id)initWithImagePNGData:(id)arg1;
@end
@interface SBSApplicationShortcutContactIcon : SBSApplicationShortcutIcon
-(instancetype)initWithContactIdentifier:(NSString *)contactIdentifier;
-(instancetype)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName;
-(instancetype)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName imageData:(NSData*)imageData;
@end
