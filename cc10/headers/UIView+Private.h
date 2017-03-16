@interface UIView (Private)
@property (assign,setter=_setContinuousCornerRadius:,nonatomic) CGFloat _continuousCornerRadius; 
-(void)_setContinuousCornerRadius:(CGFloat)radius;
@end