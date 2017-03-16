#import "NTXVibrantStyling.h"

extern NSString * const kCAFilterVibrantDark;
extern NSString * const kCAFilterVibrantLight;
extern NSString * const kCAFilterPlusD;

void NTXApplyVibrantStyling(NTXVibrantStyling *style, id value) {
	if ([value isKindOfClass:[UILabel class]]) {
		UILabel *label = (UILabel *)value;
		[label setAlpha:[style alpha]];
		if ([style composedFilter]) {
			[label.layer setFilters:@[[style composedFilter]]];
		}
		[label setTextColor:[style color]];
	}
	else if ([value isKindOfClass:[UIView class]]) {
		UIView *view = (UIView *)value;
		[view setAlpha:[style alpha]];
		if ([style composedFilter]) {
			[view.layer setFilters:@[[style composedFilter]]];
		}
		[view setBackgroundColor:[style color]];
	}
	else if ([value isKindOfClass:[UIImageView class]]) {
		UIImageView *imageView = (UIImageView *)value;
		[imageView setAlpha:[style alpha]];
		if ([style composedFilter]) {
			[imageView.layer setFilters:@[[style composedFilter]]];
		}
		[imageView setTintColor:[style color]];
	}
}

@implementation NTXVibrantStyling
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

@implementation NTXVibrantLightStyling
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

@implementation NTXPlusDStyling
- (NSString *)blendMode {
	return kCAFilterPlusD;
}
@end

@implementation NTXVibrantSecondaryStyling
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
	return [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1];
}
- (long long)style {
	return 2;
}
@end

@implementation NTXVibrantHighContrastStyling
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

@implementation NTXVibrantPrimaryStyling
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

@implementation NTXVibrantRuleStyling
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

@implementation NTXVibrantSecondaryAlternateStyling
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

@implementation NTXVibrantWidgetPrimaryHighlightStyling
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

@implementation NTXVibrantWidgetPrimaryStyling
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

@implementation NTXVibrantWidgetQuaternaryStyling
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

@implementation NTXVibrantWidgetSecondaryHighlightStyling
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

@implementation NTXVibrantWidgetSecondaryStyling
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

@implementation NTXVibrantWidgetTertiaryStyling
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

