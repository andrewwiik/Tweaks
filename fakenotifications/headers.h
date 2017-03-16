#import "headers/headers.h"

@interface NCLookViewBackdropViewSettings : _UIBackdropViewSettings
@property (getter=_isBlurred,nonatomic,readonly) BOOL blurred; 
@property (getter=_isDarkened,nonatomic,readonly) BOOL darkened; 
+(id)lookViewBackdropViewSettingsWithBlur:(BOOL)arg1 darken:(BOOL)arg2 ;
+(id)lookViewBackdropViewSettingsWithBlur:(BOOL)arg1 ;
-(void)setDefaultValues;
-(BOOL)_isDarkened;
-(BOOL)_isBlurred;
@end

@interface NCShortLookView : UIView
@end

@interface NCNotificationShortLookView : UIView
@end

@interface NCLookHeaderContentView : UIView
@end

@interface NCNotificationContentView : UIView
@end

@interface MPUControlCenterTransportButton : UIButton
- (void)_updateEffectForStateChange:(NSUInteger)state;
@end

@interface CCUIControlCenterSlider : UIView
@end

@interface CCUIControlCenterPagePlatterView : UIView
@end

@interface _UIBackdropViewSettingsATVAdaptiveLighten : _UIBackdropViewSettings
@end

@interface OYGBackdropViewSettingsBlurred : _UIBackdropViewSettingsATVAdaptiveLighten
@end

@interface OYGBackdropViewSettings : _UIBackdropViewSettingsATVAdaptiveLighten
@end

@interface WGShortLookStyleButton : UIButton
@end

@interface CALayer (OGY)
@property (nonatomic, retain) NSArray *disabledFilters;
@property (nonatomic, assign) BOOL isDarkModeEnabled;
@property (nonatomic, assign) BOOL hasChangeListener;
@property (nonatomic, retain) UIColor *correctContentsMultiplyColor;
@property (nonatomic, retain) UIColor *substitutedContentsMultiplyColor;
@property (nonatomic, assign) BOOL isCheckingDarkMode;
- (void)setDarkModeEnabled:(BOOL)enabled;
- (void)reloadFilters;
@end

@interface UILabel (OYG)
@property (nonatomic, retain) UIColor *correctTextColor;
@property (nonatomic, retain) UIColor *substitutedTextColor;
- (void)setDarkModeEnabled:(BOOL)enabled;
@end

@interface UIView (OYG)
@property (nonatomic, assign) BOOL isDarkModeEnabled;
@property (nonatomic, assign) BOOL hasChangeListener;
@property (nonatomic, assign) BOOL darkModeChangeInProgress;
@property (nonatomic, retain) UIColor *correctBackgroundColor;
@property (nonatomic, retain) UIColor *substitutedBackgroundColor;
- (void)setDarkModeEnabled:(BOOL)enabled;
-(void)_setMaskView:(id)arg1 ;
@end

@interface _UIBackdropView (OYG)
- (void)setDarkModeEnabled:(BOOL)enabled;
- (void)darkModeChanged:(NSNotification *)notification;
@end

@interface UIImageView (OYG)
- (void)behaveAsWhiteLayerView;
@property (nonatomic, assign) BOOL isWhiteLayerView;
@property (nonatomic, retain) UIView *contentsMultiplyView;
@end

@interface NCMaterialView : UIView
@property (nonatomic, retain) _UIBackdropView *substitutedBackdropView;
+(id)materialViewWithStyleOptions:(NSUInteger)arg1;
-(void)_setSubviewsContinuousCornerRadius:(CGFloat)arg1 ;

@end

@interface CAFilter (OYG)
@property (nonatomic, assign) BOOL isDarkModeFilter;
@end


@interface UIActivityIndicatorView (OYG)
@property (nonatomic, retain) UIColor *correctSpinnerColor;
@property (nonatomic, retain) UIColor *substitutedSpinnerColor;
@end

@interface NCNotificationTextInputView : UIView
@end

@interface CAShapeLayer (OYG)
@property (nonatomic, retain) UIColor *correctFillColor;
@property (nonatomic, retain) UIColor *substitutedFillColor;
@end

@interface SBTestDataProvider (FNT)
@property (nonatomic, retain) NSString *sectionIdentifierReplacement;
@end

@interface _UIBackdropViewSettingsATVDark : _UIBackdropViewSettings
@end

@interface _UIBackdropViewSettingsATVAccessoryLight : _UIBackdropViewSettings
-(void)setDefaultValues;
@end

extern NSString * const kCAFilterVibrantDark;