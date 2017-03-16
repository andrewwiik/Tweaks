@interface NSBlock : NSObject
- (void)performAfterDelay:(CGFloat)arg1;
- (NSBlock *)copy;
- (void)invoke;
@end