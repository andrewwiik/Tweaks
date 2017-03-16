#import "WNVibrantStyling.h"

extern NSString * const kCAFilterVibrantDark;
extern NSString * const kCAFilterVibrantLight;
extern NSString * const kCAFilterPlusD;

@implementation WNVibrantStyling
- (UIColor *)_burnColor {
	return (UIColor *)[self valueForKey:@"_burnColor"];
}
- (UIColor *)_darkenColor {
	return (UIColor *)[self valueForKey:@"_darkenColor"];
}
- (BOOL)_inputReversed {
	return NO;
}
- (_UIVisualEffectLayerConfig *)_layerConfig {
	_UIVisualEffectTintLayerConfig *layerConfig;
	layerConfig = [_UIVisualEffectTintLayerConfig layerWithTintColor:[self color]
														  filterType:[self blendMode]];
	return layerConfig;
}
- (CGFloat)alpha {
	return self.alpha;
}
- (NSString *)blendMode {
	return (NSString *)[self valueForKey:@"_blendMode"];
}
- (UIColor *)color {
	return (UIColor *)[self valueForKey:@"_color"];
}
- (CAFilter *)composedFilter {
	return (CAFilter *)[self valueForKey:@"_composedFilter"];
}
- (long long)style {
	return 0;
}
@end

@implementation WNVibrantLightStyling
- (_UIVisualEffectLayerConfig *)_layerConfig {

	NSDictionary *filterAttributes = @{@"inputReversed":[NSNumber numberWithBool:[self _inputReversed]]};
	_UIVisualEffectVibrantLayerConfig *layerConfig;
	layerConfig = [_UIVisualEffectVibrantLayerConfig layerWithVibrantColor:[self _burnColor]
																 tintColor:[self _darkenColor]
															    filterType:[self blendMode]
														  filterAttributes:filterAttributes];
	return layerConfig;
}
- (NSString *)blendMode {
	return kCAFilterVibrantLight;
}
- (CAFilter *)composedFilter {
	if (![self valueForKey:@"_composedFilter"]) {
		CAFilter *composedFilter = [CAFilter filterWithType:[self blendMode]];
		[composedFilter setValue:(id)[[self _burnColor] CGColor] forKey:@"inputColor0"];
		[composedFilter setValue:(id)[[self _darkenColor] CGColor] forKey:@"inputColor1"];
		[composedFilter setValue:[NSNumber numberWithBool:[self _inputReversed]] forKey:@"inputReversed"];
		[self setValue:composedFilter forKey:@"_composedFilter"];
	}
	return (CAFilter *)[self valueForKey:@"_composedFilter"];
}
@end

@implementation WNPlusDStyling
- (NSString *)blendMode {
	return kCAFilterPlusD;
}
@end

@implementation WNVibrantSecondaryStyling
- (UIColor *)_burnColor {
	return [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
}
- (UIColor *)_darkenColor {
	return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
}
- (BOOL)_inputReversed {
	return YES;
}
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor whiteColor];
}
- (long long)style {
	return 2;
}
@end

@implementation WNVibrantHighContrastStyling
- (CGFloat)alpha {
	return 1;
}
- (NSString *)blendMode {
	return nil;
}
- (UIColor *)color {
	return [UIColor blackColor];
}
- (long long)style {
	return 0;
}
@end

@implementation WNVibrantPrimaryStyling
- (CGFloat)alpha {
	return 1;
}
- (NSString *)blendMode {
	return nil;
}
- (UIColor *)color {
	return [UIColor blackColor];
}
- (long long)style {
	return 1;
}
@end

@implementation WNVibrantRuleStyling
- (UIColor *)_burnColor {
	return [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
}
- (UIColor *)_darkenColor {
	return [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
}
- (BOOL)_inputReversed {
	return TRUE;
}
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor whiteColor];
}
- (long long)style {
	return 4;
}
@end

@implementation WNVibrantSecondaryAlternateStyling
- (UIColor *)_burnColor {
	return [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
}
- (UIColor *)_darkenColor {
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
}
- (BOOL)_inputReversed {
	return TRUE;
}
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor whiteColor];
}
- (long long)style {
	return 3;
}
@end

@implementation WNVibrantWidgetPrimaryHighlightStyling
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}
- (long long)style {
	return 9;
}
@end

@implementation WNVibrantWidgetPrimaryStyling
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
}
- (long long)style {
	return 5;
}
@end

@implementation WNVibrantWidgetQuaternaryStyling
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
}
- (long long)style {
	return 8;
}
@end

@implementation WNVibrantWidgetSecondaryHighlightStyling
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.42];
}
- (long long)style {
	return 10;
}
@end

@implementation WNVibrantWidgetSecondaryStyling
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}
- (long long)style {
	return 6;
}
@end

@implementation WNVibrantWidgetTertiaryStyling
- (CGFloat)alpha {
	return 1.0;
}
- (UIColor *)color {
	return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.13];
}
- (long long)style {
	return 7;
}
@end

