@protocol CCXSectionControllerDelegate
@required
+ (NSString *)sectionIdentifier;
+ (NSString *)sectionName;
+ (UIImage *)sectionImage;
@optional
+ (Class)settingsControllerClass;
+ (BOOL)respondsToSelector:(SEL)selector;
+ (id)alloc;
- (id)init;
@end