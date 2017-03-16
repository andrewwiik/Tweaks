#import "headers/_UIVisualEffectVibrantLayerConfig.h"
#import "headers/_UIVisualEffectTintLayerConfig.h"

#include <CoreGraphics/CoreGraphics.h>
#import "headers/CAFilter.h"

@class UIVibrancyEffect;
@class CAFilter;
@interface WNVibrantStyling : NSObject {
    CGFloat  _alpha;
    NSString * _blendMode;
    UIColor * _burnColor;
    UIColor * _color;
    CAFilter * _composedFilter;
    UIColor * _darkenColor;
    BOOL  _inputReversed;
    long long  _style;
}
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly, copy) NSString *blendMode;
@property (getter=_burnColor, nonatomic, readonly, copy) UIColor *burnColor;
@property (nonatomic, readonly) UIColor *color;
@property (nonatomic, readonly, copy) CAFilter *composedFilter;
@property (getter=_darkenColor, nonatomic, readonly, copy) UIColor *darkenColor;
@property (getter=_inputReversed, nonatomic, readonly) BOOL inputReversed;
@property (nonatomic, readonly) long long style;
- (UIColor *)_burnColor;
- (UIColor *)_darkenColor;
- (BOOL)_inputReversed;
- (_UIVisualEffectLayerConfig *)_layerConfig;
- (CGFloat)alpha;
- (NSString *)blendMode;
- (UIColor *)color;
- (CAFilter *)composedFilter;
- (long long)style;
@end

@interface WNVibrantLightStyling : WNVibrantStyling
- (_UIVisualEffectLayerConfig *)_layerConfig;
- (NSString *)blendMode;
- (CAFilter *)composedFilter;
@end

@interface WNPlusDStyling : WNVibrantStyling
- (NSString *)blendMode;
@end

@interface WNVibrantSecondaryStyling : WNVibrantLightStyling
- (UIColor *)_burnColor;
- (UIColor *)_darkenColor;
- (BOOL)_inputReversed;
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface WNVibrantHighContrastStyling : WNVibrantStyling
- (CGFloat)alpha;
- (NSString *)blendMode;
- (UIColor *)color;
- (long long)style;
@end

@interface WNVibrantPrimaryStyling : WNVibrantStyling
- (CGFloat)alpha;
- (NSString *)blendMode;
- (UIColor *)color;
- (long long)style;
@end

@interface WNVibrantRuleStyling : WNVibrantLightStyling
- (UIColor *)_burnColor;
- (UIColor *)_darkenColor;
- (BOOL)_inputReversed;
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface WNVibrantSecondaryAlternateStyling : WNVibrantLightStyling
- (UIColor *)_burnColor;
- (UIColor *)_darkenColor;
- (BOOL)_inputReversed;
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface WNVibrantWidgetPrimaryHighlightStyling : WNPlusDStyling
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface WNVibrantWidgetPrimaryStyling : WNPlusDStyling
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface WNVibrantWidgetQuaternaryStyling : WNPlusDStyling
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface WNVibrantWidgetSecondaryHighlightStyling : WNPlusDStyling
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface WNVibrantWidgetSecondaryStyling : WNPlusDStyling
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface WNVibrantWidgetTertiaryStyling : WNPlusDStyling
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end