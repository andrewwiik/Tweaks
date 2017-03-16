#import "NTXBackdropViewSettings.h"

@implementation NTXBackdropViewSettings
+ (id)watchNotificationsBackdropViewSettingsWithBlur:(BOOL)blurred {
	return [self watchNotificationsBackdropViewSettingsWithBlur:blurred darken:NO];
}

+ (id)watchNotificationsBackdropViewSettingsWithBlur:(BOOL)blurred darken:(BOOL)darkened {
	if (blurred && darkened) {
		return [[NTXDarkenedBlurBackdropViewSettings alloc] init];
	} else if (blurred) {
		return [[NTXBackdropViewSettings alloc] init];
	} else {
		return [[NTXUnblurredBackdropViewSettings alloc] init];
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
		colorTintAlpha = 0.6;
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
		[self setSaturationDeltaFactor:2];
	}

	[self setFilterMaskAlpha:1];
	[self setFilterMaskImage:nil];
	[self setLegibleColor:[UIColor blackColor]];
}
@end

@implementation NTXDarkenedBlurBackdropViewSettings
- (BOOL)_isBlurred {
	return YES;
}
- (BOOL)_isDarkened {
	return YES;
}
@end

@implementation NTXUnblurredBackdropViewSettings
- (BOOL)_isBlurred {
	return NO;
}
- (BOOL)_isDarkened {
	return NO;
}
@end