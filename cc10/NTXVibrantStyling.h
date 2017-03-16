#import "headers/_UIVisualEffectVibrantLayerConfig.h"
#import "headers/_UIVisualEffectTintLayerConfig.h"

#include <CoreGraphics/CoreGraphics.h>
#import "headers/CAFilter.h"

@class UIVibrancyEffect;
@class CAFilter;
@interface NTXVibrantStyling : NSObject {
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

@interface NTXVibrantLightStyling : NTXVibrantStyling
- (_UIVisualEffectLayerConfig *)_layerConfig;
- (NSString *)blendMode;
- (CAFilter *)composedFilter;
@end

@interface NTXPlusDStyling : NTXVibrantStyling
- (NSString *)blendMode;
@end

@interface NTXVibrantSecondaryStyling : NTXVibrantLightStyling
- (UIColor *)_burnColor;
- (UIColor *)_darkenColor;
- (BOOL)_inputReversed;
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface NTXVibrantHighContrastStyling : NTXVibrantStyling
- (CGFloat)alpha;
- (NSString *)blendMode;
- (UIColor *)color;
- (long long)style;
@end

@interface NTXVibrantPrimaryStyling : NTXVibrantStyling
- (CGFloat)alpha;
- (NSString *)blendMode;
- (UIColor *)color;
- (long long)style;
@end

@interface NTXVibrantRuleStyling : NTXVibrantLightStyling
- (UIColor *)_burnColor;
- (UIColor *)_darkenColor;
- (BOOL)_inputReversed;
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface NTXVibrantSecondaryAlternateStyling : NTXVibrantLightStyling
- (UIColor *)_burnColor;
- (UIColor *)_darkenColor;
- (BOOL)_inputReversed;
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface NTXVibrantWidgetPrimaryHighlightStyling : NTXPlusDStyling
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface NTXVibrantWidgetPrimaryStyling : NTXPlusDStyling
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface NTXVibrantWidgetQuaternaryStyling : NTXPlusDStyling
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface NTXVibrantWidgetSecondaryHighlightStyling : NTXPlusDStyling
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface NTXVibrantWidgetSecondaryStyling : NTXPlusDStyling
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end

@interface NTXVibrantWidgetTertiaryStyling : NTXPlusDStyling
- (CGFloat)alpha;
- (UIColor *)color;
- (long long)style;
@end
void NTXApplyVibrantStyling(NTXVibrantStyling *style, id value);