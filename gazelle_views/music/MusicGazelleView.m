//
//  MusicGazelleView.m
//  Music
//
//  Created by Creatix on 04/15/2016.
//  Copyright (c) Creatix. All rights reserved.
//

#import <Gazelle/Gazelle.h>
#import "MusicGazelleView.h"

@class _UIBackdropView;
@class _UIBackdropViewSettings;
@class _UIBackdropViewSettingsCombiner;
@interface _UIBackdropView : UIView
@property(retain) _UIBackdropViewSettings *outputSettings;
- (id)initWithStyle:(int)arg1;
- (id)initWithSettings:(_UIBackdropViewSettings *)arg1;
- (void)transitionIncrementallyToPrivateStyle:(int)arg1 weighting:(CGFloat)arg2;
- (void)transitionIncrementallyToStyle:(int)arg1 weighting:(CGFloat)arg2;
- (void)transitionIncrementallyToSettings:(_UIBackdropViewSettings *)arg1 weighting:(CGFloat)arg2;
- (void)setAppliesOutputSettingsAnimationDuration:(CGFloat)duation;
- (void)transitionToSettings:(id)arg1;

@end

@interface _UIBackdropViewSettings : NSObject
@property (nonatomic) BOOL appliesTintAndBlurSettings;
@property (nonatomic) int blurHardEdges;
@property (nonatomic, copy) NSString *blurQuality;
@property (nonatomic) CGFloat blurRadius;
@property (nonatomic) BOOL blursWithHardEdges;
@property (nonatomic) float colorBurnTintAlpha;
@property (nonatomic) float colorBurnTintLevel;
@property (nonatomic, retain) UIImage *colorBurnTintMaskImage;
@property (nonatomic) float colorOffsetAlpha;
@property (nonatomic, retain) NSValue *colorOffsetMatrix;
@property (nonatomic, retain) UIColor *colorTint;
@property (nonatomic) CGFloat colorTintAlpha;
@property (nonatomic) float colorTintMaskAlpha;
@property (nonatomic, retain) UIImage *colorTintMaskImage;
@property (nonatomic, readonly) UIColor *combinedTintColor;
@property (nonatomic) BOOL darkenWithSourceOver;
@property (nonatomic) float darkeningTintAlpha;
@property (nonatomic) float darkeningTintBrightness;
@property (nonatomic) float darkeningTintHue;
@property (nonatomic, retain) UIImage *darkeningTintMaskImage;
@property (nonatomic) float darkeningTintSaturation;
@property (nonatomic) BOOL explicitlySetGraphicsQuality;
@property (nonatomic) float extendedRangeClamp;
@property (nonatomic) float filterMaskAlpha;
@property (nonatomic, retain) UIImage *filterMaskImage;
@property (nonatomic) int graphicsQuality;
@property (nonatomic) CGFloat grayscaleTintAlpha;
@property (nonatomic) float grayscaleTintLevel;
@property (nonatomic) float grayscaleTintMaskAlpha;
@property (nonatomic, retain) UIImage *grayscaleTintMaskImage;
@property (nonatomic, retain) UIColor *legibleColor;
@property (nonatomic) BOOL lightenGrayscaleWithSourceOver;
@property (nonatomic) int renderingHint;
@property (nonatomic) BOOL requiresColorStatistics;
@property (nonatomic) float saturationDeltaFactor;
@property (nonatomic) float scale;
@property (nonatomic) int stackingLevel;
@property (nonatomic) double statisticsInterval;
@property (nonatomic, readonly) int style;
@property (nonatomic) int suppressSettingsDidChange;
@property (nonatomic) BOOL usesBackdropEffectView;
@property (nonatomic) BOOL usesColorBurnTintView;
@property (nonatomic) BOOL usesColorOffset;
@property (nonatomic) BOOL usesColorTintView;
@property (nonatomic) BOOL usesContentView;
@property (nonatomic) BOOL usesDarkeningTintView;
@property (nonatomic) BOOL usesGrayscaleTintView;
@property (nonatomic) unsigned int version;
@property (nonatomic) float zoom;
@property (nonatomic) BOOL zoomsBack;
+ (id)settingsForStyle:(int)arg1;
+ (instancetype)settingsForStyle:(int)style weighting:(CGFloat)weight previousSettings:(_UIBackdropViewSettings *)previous;
- (id)initWithDefaultValues;
+ (id)MPU_settingsForNowPlayingBackdrop;
@end

@interface _UIBackdropViewSettingsCombiner : _UIBackdropViewSettings
@property (nonatomic, retain) _UIBackdropViewSettings *inputSettingsA;
@property (nonatomic, retain) _UIBackdropViewSettings *inputSettingsB;
@property CGFloat weighting;
@end

@implementation MusicGazelleView

- (UIColor *)presentationBackgroundColor {
	return [UIColor clearColor];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        // Custom initialisation
    }

    return self;
}

- (void)layoutSubviews {
	if (!_blurTest) {
		//_UIBackdropViewSettings *settings = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:2071];
		_UIBackdropViewSettings *fullBlurSettings= [_UIBackdropViewSettings settingsForStyle:2020];
		[fullBlurSettings setBlurRadius:15];
		fullBlurSettings.grayscaleTintAlpha = 0.05;
		fullBlurSettings.colorTint = [UIColor blackColor];
		fullBlurSettings.colorTintAlpha = 0.07;
		_blurTest = [[NSClassFromString(@"_UIBackdropView") alloc] initWithSettings:fullBlurSettings];
		[self addSubview:blurTest];

		UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(20,190,210,40)];
		//view1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
		view1.layer.cornerRadius = 9;
		view1.clipsToBounds = YES;
		[self addSubview:view1];

		_UIBackdropViewSettings *settings1 = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:4000];
		//settings1.blurRadius = 0;
		_UIBackdropView *blur1 = [[NSClassFromString(@"_UIBackdropView") alloc] initWithSettings:settings1];
		[view1 addSubview:blur1];
	}
}

- (void)handleActionForIconTap  {
	/**
	* Decide what happens when the user taps on the icon view
	* Perhaps remove the presented view?
	*/
	[Gazelle tearDownAnimated:YES];

	/**
	* Or perhaps open the application?
	*/
	[Gazelle openApplicationForBundleIdentifier:@"com.apple.Music"];
}

- (void)setActivatedApplicationIdentifier:(NSString *)identifier {
	/*
	* This will be set during presentation, it will allow you to determine what app was swiped up on
	* incase user set your view for an app you didn't intend
	*/
	_swipedIdentifier = identifier;
}

@end
