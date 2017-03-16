// Adapted from https://github.com/thisandagain/color.

#import <UIKit/UIKit.h>

@interface UIColor(ColorBanners)

+ (UIColor *)cbr_colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation lightness:(CGFloat)lightness alpha:(CGFloat)alpha;
- (void)cbr_getHue:(CGFloat *)hue saturation:(CGFloat *)saturation lightness:(CGFloat *)lightness alpha:(CGFloat *)alpha;
- (UIColor *)cbr_offsetWithHue:(CGFloat)h saturation:(CGFloat)s lightness:(CGFloat)l alpha:(CGFloat)alpha;
- (UIColor *)cbr_lighten:(CGFloat)amount;
- (UIColor *)cbr_darken:(CGFloat)amount;

@end
