@interface UIApplicationShortcutIcon (help)
- (id)initWithSBSApplicationShortcutIcon:(id)arg1;
+ (id)iconWithContact:(id)arg1;

@end

@interface UIApplicationShortcutItem (help)

+ (unsigned int)_sbsActivationModeFromUIActivationMode:(unsigned int)arg1;
+ (unsigned int)_uiActivationModeFromSBSActivationMode:(unsigned int)arg1;

- (id)_initWithType:(id)arg1 localizedTitle:(id)arg2 localizedSubtitle:(id)arg3 icon:(id)arg4 userInfoData:(id)arg5 activationMode:(unsigned int)arg6;
- (id)initWithSBSApplicationShortcutItem:(id)arg1;

@end

@interface SBSApplicationShortcutIcon : NSObject

@end

@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
-(NSInteger)type;
@end

@interface SBSApplicationShortcutIcon (UF)
- (id)initWithType:(UIApplicationShortcutIconType)arg1;
@end

@interface SBSApplicationShortcutContactIcon : SBSApplicationShortcutIcon
-(id)initWithContactIdentifier:(NSString *)contactIdentifier;
-(id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
-(id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName imageData:(NSData *)imageData;
@end

@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
@property (nonatomic, readonly, retain) NSData *imagePNGData;
-(instancetype)initWithImagePNGData:(NSData *)imageData;
@end

@interface SBIconController : UIViewController
@end

@interface SBSApplicationShortcutItem : NSObject
- (void)setBundleIdentifierToLaunch:(id)arg1;
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
- (void)setUserInfo:(id)arg1;
- (void)setUserInfoData:(id)arg1;
- (id)initWithXPCDictionary:(id)arg1;
@end

@interface UIApplication (Bunny)
@property (nonatomic, copy) NSArray *shortcutItems;
-(void)setShortcutItems:(NSArray*)arg1;
@end