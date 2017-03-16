#import "headers/headers.h"
#import "OGYUIControlCenterVisualEffect.h"

struct CAColorMatrix {
    float m11, m12, m13, m14, m15;
    float m21, m22, m23, m24, m25;
    float m31, m32, m33, m34, m35;
    float m41, m42, m43, m44, m45;
};

@interface OYGBackdropViewSettingsBlurred : _UIBackdropViewSettingsATVAdaptiveLighten
@end

@interface OYGBackdropViewSettings : _UIBackdropViewSettingsATVAdaptiveLighten
@end

@interface CALayer (OGY)
@property (nonatomic, retain) NSArray *disabledFilters;
@property (nonatomic, assign) BOOL isDarkModeEnabled;
@property (nonatomic, assign) BOOL hasChangeListener;
@property (nonatomic, retain) UIColor *correctContentsMultiplyColor;
@property (nonatomic, retain) UIColor *substitutedContentsMultiplyColor;
@property (nonatomic, assign) BOOL isCheckingDarkMode;
@property (nonatomic, retain) NSString *substitutedCompositingFilter;
@property (nonatomic, retain) NSString *correctCompositingFilter;
- (void)setDarkModeEnabled:(BOOL)enabled;
- (void)reloadFilters;
@end

@interface UILabel (OYG)
@property (nonatomic, retain) UIColor *correctTextColor;
@property (nonatomic, retain) UIColor *substitutedTextColor;
@property (nonatomic, retain) NSString *vibrantStylingType;
- (void)setDarkModeEnabled:(BOOL)enabled;
@end

@interface UIView (OYG)
@property (nonatomic, assign) BOOL isDarkModeEnabled;
@property (nonatomic, assign) BOOL hasChangeListener;
@property (nonatomic, assign) BOOL darkModeChangeInProgress;
@property (nonatomic, retain) UIColor *correctBackgroundColor;
@property (nonatomic, retain) UIColor *substitutedBackgroundColor;
@property (nonatomic, retain) UIColor *correctAlpha;
@property (nonatomic, retain) UIColor *substitutedAlpha;
- (void)setDarkModeEnabled:(BOOL)enabled;
- (void)_updateEffects;
@end

@interface _UIBackdropView (OYG)
@property (nonatomic, retain) _UIBackdropView *duplicatedBackdropView;
- (void)setDarkModeEnabled:(BOOL)enabled;
- (void)darkModeChanged:(NSNotification *)notification;
@end

@interface UIImageView (OYG)
- (void)behaveAsWhiteLayerView;
@property (nonatomic, assign) BOOL isWhiteLayerView;
@property (nonatomic, assign) BOOL shouldForceTemplateImage;
@property (nonatomic, retain) UIView *contentsMultiplyView;
@property (nonatomic, retain) UIColor *correctTintColor;
@property (nonatomic, retain) UIColor *substitutedTintColor;
@end

@interface UIButton (OYG)
@property (nonatomic, retain) UIColor *correctTintColor;
@property (nonatomic, retain) UIColor *substitutedTintColor;
- (void)setDarkModeEnabled:(BOOL)enabled;
@end

@interface NCMaterialView (OYG)
@property (nonatomic, retain) _UIBackdropView *substitutedBackdropView;
@end

@interface CAFilter (OYG)
@property (nonatomic, assign) BOOL isDarkModeFilter;
@end


@interface UIActivityIndicatorView (OYG)
@property (nonatomic, retain) UIColor *correctSpinnerColor;
@property (nonatomic, retain) UIColor *substitutedSpinnerColor;
@end

@interface CAShapeLayer (OYG)
@property (nonatomic, retain) UIColor *correctFillColor;
@property (nonatomic, retain) UIColor *substitutedFillColor;
@end

@interface SBControlCenterContentContainerView (OYG)
@property (nonatomic, retain) _UIBackdropView *substitutedBackdropView;
@property (nonatomic, retain) UIView *fakeWhiteLayerView;
@end

@interface MPAVRoutingTableViewCell (OYG)
- (void)setDarkModeEnabled:(BOOL)enabled;
@end

@interface UIVisualEffect (OGY)
@property (nonatomic, assign) BOOL isDarkModeEnabled;
@property (nonatomic, assign) BOOL hasChangeListener;
@property (nonatomic, retain) UIVisualEffect *substitutedEffect;
@property (nonatomic, retain) UIVisualEffectView *effectView;
- (void)setDarkModeEnabled:(BOOL)enabled;
- (void)darkModeChanged:(NSNotification *)notification;
-(_UIVisualEffectConfig *)effectConfig;
@end

@interface UIVisualEffectView (OGY)
- (void)_configureForCurrentEffect;
@end

@interface NSValue(Details)
+ (NSValue *)valueWithCAColorMatrix:(CAColorMatrix)t;
@end