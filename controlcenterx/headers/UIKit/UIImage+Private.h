@interface UIImage (Private)
- (UIImage *)_applyBackdropViewSettings:(id)arg1;
- (UIImage *)_applyBackdropViewSettings:(id)arg1 includeTints:(BOOL)arg2 includeBlur:(BOOL)arg3;
- (UIImage *)sbf_scaleImage:(CGFloat)scale;
+ (UIImage *)imageNamed:(NSString *)arg1 inBundle:(id)arg2 ;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)arg1 format:(int)arg2 ;
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)arg1 format:(NSInteger)arg2 scale:(CGFloat)arg3 ;
@end