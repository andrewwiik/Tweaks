@protocol CCXSectionControllerDelegate
@required
+ (NSString *)sectionIdentifier;
+ (NSString *)sectionName;
+ (UIImage *)sectionImage;
@optional
+ (Class)settingsControllerClass;
+ (UIViewController *)configuredSettingsController;
+ (BOOL)respondsToSelector:(SEL)selector;
+ (id)alloc;
- (id)init;
@end