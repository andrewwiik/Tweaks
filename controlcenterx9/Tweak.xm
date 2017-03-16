#include <MediaPlayer/MediaPlayer.h>
#include <CoreGraphics/CoreGraphics.h>
#import "headers.h"

@interface UIView (CCX9Stuff)
- (void)applyBackdropStyle:(NSString *)style;
@end

@interface _UIBackdropViewSettingsATVAdaptiveLighten : _UIBackdropViewSettings
@end

@interface _UIBackdropViewSettingsCCXDark : _UIBackdropViewSettingsATVAdaptiveLighten
@end

@interface NCLookViewBackdropViewSettings : _UIBackdropViewSettings
+ (instancetype)lookViewBackdropViewSettingsWithBlur:(BOOL)blur darken:(BOOL)darken;
- (BOOL)_isDarkened;
- (BOOL)_isBlurred;
@end
@interface NCUnblurredBackdropViewSettings : NCLookViewBackdropViewSettings
@end
@interface NCDarkenedBlurBackdropViewSettings : NCLookViewBackdropViewSettings
@end

%subclass _UIBackdropViewSettingsCCXDark : _UIBackdropViewSettingsATVAdaptiveLighten
- (void)setDefaultValues {
	%orig;
	self.colorBurnTintAlpha = 0.3;
	self.colorBurnTintLevel = 0;
	self.colorOffsetAlpha = 1;
	self.colorTint = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.359];
	self.colorTintAlpha = 0.0;
	self.colorTintMaskAlpha = 1;
	self.usesColorBurnTintView = YES;
	self.usesColorOffset = YES;
	self.usesColorTintView = YES;
	self.darkeningTintAlpha = 0.2;
	self.darkeningTintBrightness = 0.35;
	self.darkeningTintHue = 0.8;
	self.darkeningTintSaturation = 0;
	self.usesDarkeningTintView = YES;
	self.grayscaleTintAlpha = 0.5;
	self.grayscaleTintLevel = 0.2;
	self.lightenGrayscaleWithSourceOver = YES;
	self.usesGrayscaleTintView = YES;
	self.saturationDeltaFactor = 1.8;
	self.lightenGrayscaleWithSourceOver = YES;
	self.blurRadius = 40;
}
%end

%hook UIView
%new
- (void)addWhiteThing {
	UIView *whiteView = [[UIView alloc] initWithFrame:self.frame];
	whiteView.backgroundColor = nil;
	UIView *subStuff = [[UIView alloc] initWithFrame:self.frame];
	subStuff.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
	[whiteView addSubview:subStuff];
	//[[whiteView layer] setContentsMultiplyColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor];
	[self addSubview:whiteView];
	// [[self superview] sendSubviewToBack:whiteView];
	// [self sendSubviewToBack:whiteView];
	CAFilter *multiplyFilter = [[CAFilter alloc] initWithName:@"multiplyColor"];
    [multiplyFilter setValue:(id) [[UIColor colorWithWhite:1 alpha:0.5] CGColor] forKey:@"inputColor"];
    [[whiteView layer] setFilters:[NSArray arrayWithObject:multiplyFilter]];

	[self applyBackdropStyle:@"NCDarkenedBlurBackdropViewSettings"];
	// UIView *whiteView = [[UIView alloc] initWithFrame:self.frame];
	// whiteView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
	// //[[whiteView layer] setContentsMultiplyColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor];
	// [self addSubview:whiteView];
	// CAFilter *multiplyFilter = [[CAFilter alloc] initWithName:@"multiplyColor"];
 //    [multiplyFilter setValue:(id) [[UIColor colorWithWhite:1 alpha:0.5] CGColor] forKey:@"inputColor"];
 //    [[whiteView layer] setFilters:[NSArray arrayWithObject:multiplyFilter]];
	// UIView *whiteView = [[UIView alloc] initWithFrame:self.frame];
	// whiteView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
	// [[whiteView layer] setContentsMultiplyColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor];
	// [self addSubview:whiteView];
}

%new
- (void)applyBackdropStyle:(NSString *)style {

	_UIBackdropViewSettings *backdropSettings = (_UIBackdropViewSettings *)[[NSClassFromString(style) alloc] init];
	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:backdropSettings];
	[self addSubview:backdropView];
	[self sendSubviewToBack:backdropView];
}
%end



%group iOS9

@implementation NCLookViewBackdropViewSettings
+ (id)lookViewBackdropViewSettingsWithBlur:(BOOL)blurred {
	return [NSClassFromString(@"NCLookViewBackdropViewSettings") lookViewBackdropViewSettingsWithBlur:blurred darken:NO];
}

+ (id)lookViewBackdropViewSettingsWithBlur:(BOOL)blurred darken:(BOOL)darkened {
	if (blurred && darkened) {
		return [[NSClassFromString(@"NCDarkenedBlurBackdropViewSettings") alloc] init];
	} else if (blurred) {
		return [[NSClassFromString(@"NCBackdropViewSettings") alloc] init];
	} else {
		return [[NSClassFromString(@"NCUnblurredBackdropViewSettings") alloc] init];
	}
}

- (BOOL)_isBlurred {
	return YES;
}
- (BOOL)_isDarkened {
	return NO;
}

- (void)setDefaultValues {
	[super setDefaultValues];

	BOOL reduceTransparencyEnabled = UIAccessibilityIsReduceTransparencyEnabled();
	[self setRequiresColorStatistics:NO];
	[self setUsesColorTintView:YES];
	[self setGrayscaleTintLevel:0];
	[self setGrayscaleTintAlpha:0];
	[self setGrayscaleTintMaskAlpha:1];
	[self setGrayscaleTintMaskImage:nil];

	UIColor *tintColor = [UIColor whiteColor];
	if ([self _isDarkened]) {
		tintColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
	}
	[self setColorTint:tintColor];

	CGFloat colorTintAlpha = 0.65;
	if ([self _isDarkened] && !reduceTransparencyEnabled) {
		colorTintAlpha = 0.56;
	} else if (!reduceTransparencyEnabled) {
		colorTintAlpha = 0.65;
	}
	[self setColorTintAlpha:colorTintAlpha];
	[self setColorTintMaskAlpha:1];
	[self setColorTintMaskImage:nil];

	if ([self _isBlurred]) {
		if (reduceTransparencyEnabled) {
			[self setBlurRadius:0];
		} else {
			[self setBlurRadius:30];
		}
	}

	if (reduceTransparencyEnabled) {
		[self setSaturationDeltaFactor:0];
	} else {
		[self setSaturationDeltaFactor:2.04];
	}

	[self setFilterMaskAlpha:1];
	[self setFilterMaskImage:nil];
	[self setLegibleColor:[UIColor blackColor]];
}
@end

@implementation NCDarkenedBlurBackdropViewSettings
- (BOOL)_isBlurred {
	return YES;
}
- (BOOL)_isDarkened {
	return YES;
}
@end

@implementation NCUnblurredBackdropViewSettings
- (BOOL)_isBlurred {
	return NO;
}
- (BOOL)_isDarkened {
	return NO;
}
@end
%end

%ctor {
	if (!NSClassFromString(@"NCLookViewBackdropViewSettings")) {
		%init(iOS9);
	}
	%init;
}