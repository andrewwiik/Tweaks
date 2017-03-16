#import <pop/POP.h>

@class _UIBackdropView;
@class _UIBackdropViewSettings;
@class _UIBackdropViewSettingsCombiner;
@interface _UIBackdropView : UIView
@property(retain) _UIBackdropViewSettings *outputSettings;
@property(retain) UIView * contentView;
- (id)initWithStyle:(int)arg1;
- (id)initWithSettings:(_UIBackdropViewSettings *)arg1;
- (void)transitionIncrementallyToPrivateStyle:(int)arg1 weighting:(CGFloat)arg2;
- (void)transitionIncrementallyToStyle:(int)arg1 weighting:(CGFloat)arg2;
- (void)transitionIncrementallyToSettings:(_UIBackdropViewSettings *)arg1 weighting:(CGFloat)arg2;
- (void)setAppliesOutputSettingsAnimationDuration:(CGFloat)duation;
- (void)transitionToSettings:(id)arg1;	
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
- (id)initWithPrivateStyle:(int)arg1;
- (void)setBlurFilterWithRadius:(float)arg1 blurQuality:(id)arg2 blurHardEdges:(int)arg3;
- (void)setBlurFilterWithRadius:(float)arg1 blurQuality:(id)arg2;
- (void)setBlurHardEdges:(int)arg1;
- (void)setInputSettings:(id)arg1;
- (void)setBlurQuality:(id)arg1;
- (void)setBlurRadius:(float)arg1;
- (void)setBlurRadiusSetOnce:(BOOL)arg1;
- (void)setBlursBackground:(BOOL)arg1;
- (void)setBlursWithHardEdges:(BOOL)arg1;


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
+ (id)settingsForStyle:(NSInteger)arg1;
+ (instancetype)settingsForStyle:(int)style weighting:(CGFloat)weight previousSettings:(_UIBackdropViewSettings *)previous;
@end

@interface _UIBackdropViewSettingsCombiner : _UIBackdropViewSettings
@property (nonatomic, retain) _UIBackdropViewSettings *inputSettingsA;
@property (nonatomic, retain) _UIBackdropViewSettings *inputSettingsB;
@property (nonatomic, retain) _UIBackdropViewSettings *outputSettingsA;
@property (nonatomic, retain) _UIBackdropViewSettings *SettingsB;
@property CGFloat weighting;
@end

@interface CRTXBlurView : UIView
@property(retain) UIView * contentView;
- (id)initWithFrame:(CGRect)frame;
- (void)activateBlur;
- (void)deactivateBlurWithView:(UIView *)view;
@end