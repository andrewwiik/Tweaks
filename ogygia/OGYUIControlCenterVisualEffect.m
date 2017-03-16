#import "OGYUIControlCenterVisualEffect.h"

@implementation OGYUIControlCenterVisualEffect

+ (instancetype)effectWithStyle:(NSInteger)style {
	OGYUIControlCenterVisualEffect *effect = [[OGYUIControlCenterVisualEffect alloc] initWithStyle:style];
	return effect;
}

- (id)initWithStyle:(NSInteger)style {
	self = [super init];
	if (self) {
		_style = style;
	}
	return self;
}

- (_UIVisualEffectConfig *)effectConfig {
	UIColor *vibrantColor = nil;
	UIColor *tintColor = nil;
	NSString *filterType = nil;

	if (_style == 0) {
		vibrantColor = [UIColor colorWithWhite:0.065 alpha:1];
		tintColor = [UIColor colorWithWhite:1 alpha:0.1];
		filterType = @"vibrantDark";
	}

	_UIVisualEffectVibrantLayerConfig *contentConfig = [NSClassFromString(@"_UIVisualEffectVibrantLayerConfig") layerWithVibrantColor:vibrantColor tintColor:tintColor filterType:filterType];
	_UIVisualEffectConfig *effectConfig = [NSClassFromString(@"_UIVisualEffectConfig") configWithContentConfig:contentConfig];
	return effectConfig;
}
@end