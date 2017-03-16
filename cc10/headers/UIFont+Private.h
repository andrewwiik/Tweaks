@interface UIFont (Private)
- (int)traits;
+ (UIFont *)fontWithName:(NSString *)name size:(CGFloat)size traits:(int)traits;
@end