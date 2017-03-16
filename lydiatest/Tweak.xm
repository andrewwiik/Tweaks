#import <UIKit/UIKit.h>
#import <pop/POP.h>

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
@end

@interface _UIBackdropViewSettingsCombiner : _UIBackdropViewSettings
@property (nonatomic, retain) _UIBackdropViewSettings *inputSettingsA;
@property (nonatomic, retain) _UIBackdropViewSettings *inputSettingsB;
@property CGFloat weighting;
@end

@interface CPGPresentationWindow : UIWindow
@property (nonatomic, retain) _UIBackdropViewSettings *fullBlurSettings;
@property (nonatomic, retain) _UIBackdropViewSettings *noBlurSettings;
@property (nonatomic, retain) _UIBackdropView *backgroundBlurView;
@property (nonatomic, assign) CGFloat backgroundBlurProgress;
- (void)applyBlur;
- (void)_setBlurProgress:(CGFloat)progress;
- (void)animateBackgroundBlurFromWeight:(CGFloat)startWeight toWeight:(CGFloat)endWeight;
@end

%hook CPGPresentationWindow
%property (nonatomic, retain) _UIBackdropViewSettings *fullBlurSettings;
%property (nonatomic, retain) _UIBackdropViewSettings *noBlurSettings;
%property (nonatomic, retain) _UIBackdropView *backgroundBlurView;
%property (nonatomic, assign) CGFloat backgroundBlurProgress;
- (void)presentLydiaViewForAppBundleIdentifier:(NSString *)arg1 {
	self.fullBlurSettings= [_UIBackdropViewSettings settingsForStyle:2020];
	[self.fullBlurSettings setBlurRadius:15];
	self.fullBlurSettings.grayscaleTintAlpha = 0.05;
	self.fullBlurSettings.colorTint = [UIColor blackColor];
	self.fullBlurSettings.colorTintAlpha = 0.07;

	self.noBlurSettings = [_UIBackdropViewSettings settingsForStyle:2020];
	[self.noBlurSettings setBlurRadius:0];
	self.noBlurSettings.grayscaleTintAlpha = 0.05;
	self.noBlurSettings.colorTint = [UIColor blackColor];
	self.noBlurSettings.colorTintAlpha = 0.07;

	self.backgroundBlurView = [[_UIBackdropView alloc] initWithSettings:self.noBlurSettings];
	[self.backgroundBlurView setAppliesOutputSettingsAnimationDuration:0];

	[self addSubview:self.backgroundBlurView];
	
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundBlurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

	[self animateBackgroundBlurFromWeight:0 toWeight:1];
	%orig;
}

%new
- (void)animateBackgroundBlurFromWeight:(CGFloat)startWeight toWeight:(CGFloat)endWeight {
	if (self.fullBlurSettings && self.backgroundBlurView) {
		
		POPBasicAnimation *anim = [POPBasicAnimation linearAnimation];
		POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"com.cpdigitaldarkroom.gazelle.blur" initializer:^(POPMutableAnimatableProperty *prop) {
  		
			prop.readBlock = ^(CPGPresentationWindow *obj, CGFloat values[]) {

  			  values[0] = [obj backgroundBlurProgress];
  			};
		
  			prop.writeBlock = ^(CPGPresentationWindow *obj, const CGFloat values[]) {

  			  [obj setBackgroundBlurProgress:values[0]];
  			  _UIBackdropViewSettings *settings = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:2020];
			  [settings setBlurRadius:15*values[0]];
			  settings.grayscaleTintAlpha = 0.05;
			  settings.colorTint = [UIColor blackColor];
			  settings.colorTintAlpha = 0.07;
			  //obj.fullBlurSettings.blurRadius = 15*values[0];
  		 	  [obj.backgroundBlurView transitionToSettings:settings];
  			};

  			prop.threshold = 0.0001;
		}];

		anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
		[self pop_removeAnimationForKey:@"blur"];
		};

		anim.property = prop;
		anim.fromValue = @(startWeight);
		anim.toValue = @(endWeight);
		anim.duration = 0.15;
		[self pop_addAnimation:anim forKey:@"blur"];
	}
}


- (void)tearDownAnimated:(BOOL)animated {
	if (animated) {
		[self animateBackgroundBlurFromWeight:1 toWeight:0];
		%orig;

}
}
%end

%hook _UIBackdropViewSettings
%new
+ (instancetype)settingsForStyle:(int)style weighting:(CGFloat)weight previousSettings:(_UIBackdropViewSettings *)previous {
	if (style == 1447) {
		_UIBackdropViewSettingsCombiner *settings = [[NSClassFromString(@"_UIBackdropViewSettingsCombiner") alloc] init];
		// _UIBackdropViewSettings *settingsA = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:2020];
		// settingsA.blurRadius = 0;
		// settingsA.grayscaleTintAlpha = 0.05;
		// settingsA.colorTint = [UIColor blackColor];
		// settingsA.colorTintAlpha = 0.07;
		settings.inputSettingsA = previous;
		_UIBackdropViewSettings *settingsB = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:2020];
		settingsB.blurRadius = 15;
		settingsB.grayscaleTintAlpha = 0.05;
		settingsB.colorTint = [UIColor blackColor];
		settingsB.colorTintAlpha = 0.07;
		settings.inputSettingsB = settingsB;
		settings.weighting = weight;

		return settings;
	}
	else return nil;
}
%end

