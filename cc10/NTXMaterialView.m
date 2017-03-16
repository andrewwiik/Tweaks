#import "NTXMaterialView.h"

@implementation NTXMaterialView

+ (instancetype)materialViewWithStyleOptions:(unsigned int)style {
	return [[self alloc] initWithStyleOptions:style];
}

- (CGFloat)_colorInfusionViewAlpha {
	return _colorInfusionViewAlpha;
}

- (void)_configureBackdropViewIfNecessary {
	if (_styleOptions & 7) {
		_UIBackdropView *previousBackdropView = _backdropView;
		[_backdropView removeFromSuperview];
		NTXBackdropViewSettings *backdropSettings;
		backdropSettings = [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:(_styleOptions & 6) darken:((_styleOptions >> 2) & 1)];
		_backdropView = [[_UIBackdropView alloc] initWithSettings:backdropSettings];
		[self addSubview:_backdropView];
		[_backdropView setFrame:[self bounds]];
		_backdropView.groupName = previousBackdropView.groupName;
		_backdropView._continuousCornerRadius = previousBackdropView._continuousCornerRadius;
		[self _setSubviewsContinuousCornerRadius:_backdropView._continuousCornerRadius];
	}
}

- (void)_configureColorInfusionViewIfNecessary {
	if (_colorInfusionView) {
		[_colorInfusionView setAlpha:_colorInfusionViewAlpha];
		[self addSubview:_colorInfusionView];
		[self sendSubviewToBack:_colorInfusionView];
		[_colorInfusionView setFrame:[self bounds]];
		_colorInfusionView.autoresizingMask = 18;
	}
}

- (void)_configureCutoutOverlayViewIfNecessary {
	unsigned int style = _styleOptions;
	if (style) {
		if (style != 32) {
			if (!_cutoutOverlayView) {
				_cutoutOverlayView = [[UIView alloc] init];
				[self addSubview:_cutoutOverlayView];
				_cutoutOverlayView.frame = [self bounds];
				_cutoutOverlayView.autoresizingMask = 18;
			}
		}
		_cutoutOverlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.04];
	}
}

- (void)_configureIfNecessary {

	[self _configureBackdropViewIfNecessary];
	[self _configureLightOverlayViewIfNecessary];
	[self _configureWhiteOverlayViewIfNecessary];
	[self _configureCutoutOverlayViewIfNecessary];
}

- (void)_configureLightOverlayViewIfNecessary {
	unsigned int style = _styleOptions;
	if (style) {
		if (style != 8) {
			if (!_lightOverlayView) {
				_lightOverlayView = [[UIView alloc] init];
				[self addSubview:_lightOverlayView];
				_lightOverlayView.frame = [self bounds];
				_lightOverlayView.autoresizingMask = 18;
			}
		}
		if (UIAccessibilityIsReduceTransparencyEnabled()) {
			[_lightOverlayView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
		} else {
			[_lightOverlayView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.2]];
		}
	}
}

- (void)_configureWhiteOverlayViewIfNecessary {
	unsigned int style = _styleOptions;
	if (style) {
		if (style != 16) {
			if (!_whiteOverlayView) {
				_whiteOverlayView = [[UIView alloc] init];
				[self addSubview:_whiteOverlayView];
				[_whiteOverlayView setFrame:[self bounds]];
				_whiteOverlayView.autoresizingMask = 18;

			}
		}
		[_whiteOverlayView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.35]];
	}
}

- (void)_reduceTransparencyStatusDidChange {
	[self _configureIfNecessary];
}
- (void)_setColorInfusionViewAlpha:(CGFloat)alpha {
	if (_colorInfusionViewAlpha != alpha) {
		_colorInfusionViewAlpha = alpha;
		[_colorInfusionView setAlpha:alpha];
		[self setNeedsDisplay];
	}
}

- (void)_setSubviewsContinuousCornerRadius:(CGFloat)radius {
	[_backdropView _setContinuousCornerRadius:radius];
	[_lightOverlayView _setContinuousCornerRadius:radius];
	[_whiteOverlayView _setContinuousCornerRadius:radius];
	[_cutoutOverlayView _setContinuousCornerRadius:radius];

	BOOL clips = radius != 0.0;
	[_lightOverlayView setClipsToBounds:clips];
	[_whiteOverlayView setClipsToBounds:clips];
	[_cutoutOverlayView setClipsToBounds:clips];
}
 
- (CGFloat)_subviewsContinuousCornerRadius {
	return _subviewsContinuousCornerRadius;

}

- (UIView *)colorInfusionView {
	return _colorInfusionView;
}

- (CGFloat)grayscaleValue {
	CGFloat value;
	[[[_backdropView grayscaleTintView] backgroundColor] getWhite:&value alpha:nil];
	return value;
}

- (NSString *)groupName {
	return [_backdropView groupName];
}

- (instancetype)initWithStyleOptions:(unsigned int)options {
	NTXMaterialView *view = [super init];
	if (view) {

		_styleOptions = options;
		_colorInfusionViewAlpha = 0.5;
		[view.layer setAllowsGroupBlending:NO];
		[view setUserInteractionEnabled:NO];
		[view setAutoresizesSubviews:TRUE];
		[view _configureIfNecessary];

		[[NSNotificationCenter defaultCenter] addObserver:view
												 selector:@selector(_reduceTransparencyStatusDidChange)
												 name:UIAccessibilityReduceTransparencyStatusDidChangeNotification
											   object:nil];

	}
	return view;
}

- (void)setColorInfusionView:(id)view {
	if (_colorInfusionView != view) {
		[_colorInfusionView removeFromSuperview];
		_colorInfusionView = view;
		[self _configureColorInfusionViewIfNecessary];
		[self setNeedsDisplay];
	}
}

- (void)setGrayscaleValue:(CGFloat)value {
	CGFloat alpha;
	UIColor *backgroundColor = [[_backdropView grayscaleTintView] backgroundColor];
	[backgroundColor getWhite:nil alpha:&alpha];
	UIColor *newColor = [UIColor colorWithWhite:value alpha:alpha];
	[[_backdropView grayscaleTintView] setBackgroundColor:newColor];
}

- (void)setGroupName:(NSString *)name {
	[_backdropView setGroupName:name];
}
@end