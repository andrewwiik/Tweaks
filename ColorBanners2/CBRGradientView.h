#import <CoreGraphics/CoreGraphics.h>

@interface CBRGradientView : UIView {
  NSArray *_colors;
}

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setColors:(NSArray *)colors;
- (void)setSolidColor:(UIColor *)color;

@end
