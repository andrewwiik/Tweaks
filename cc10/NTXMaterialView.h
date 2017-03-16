#import "headers/_UIBackdropView.h"
#import "NTXBackdropViewSettings.h"
#import "headers/UIView+Private.h"
#import "headers/CALayer+Private.h"

@interface NTXMaterialView : UIView {
    _UIBackdropView * _backdropView;
    UIView * _colorInfusionView;
    CGFloat  _colorInfusionViewAlpha;
    UIView * _cutoutOverlayView;
    UIView * _lightOverlayView;
    unsigned int  _styleOptions;
    CGFloat  _subviewsContinuousCornerRadius;
    UIView * _whiteOverlayView;
}

@property (nonatomic, retain) UIView *colorInfusionView;
@property (getter=_colorInfusionViewAlpha, setter=_setColorInfusionViewAlpha:, nonatomic) CGFloat colorInfusionViewAlpha;
@property (nonatomic) CGFloat grayscaleValue;
@property (nonatomic, copy) NSString *groupName;
@property (getter=_subviewsContinuousCornerRadius, setter=_setSubviewsContinuousCornerRadius:, nonatomic) CGFloat subviewsContinuousCornerRadius;

+ (instancetype)materialViewWithStyleOptions:(unsigned int)arg1;

- (CGFloat)_colorInfusionViewAlpha;
- (void)_configureBackdropViewIfNecessary;
- (void)_configureColorInfusionViewIfNecessary;
- (void)_configureCutoutOverlayViewIfNecessary;
- (void)_configureIfNecessary;
- (void)_configureLightOverlayViewIfNecessary;
- (void)_configureWhiteOverlayViewIfNecessary;
- (void)_reduceTransparencyStatusDidChange;
- (void)_setColorInfusionViewAlpha:(CGFloat)arg1;
- (void)_setSubviewsContinuousCornerRadius:(CGFloat)arg1;
- (CGFloat)_subviewsContinuousCornerRadius;
- (UIView *)colorInfusionView;
- (CGFloat)grayscaleValue;
- (NSString *)groupName;
- (instancetype)initWithStyleOptions:(unsigned int)options;
- (void)setColorInfusionView:(UIView *)view;
- (void)setGrayscaleValue:(CGFloat)value;
- (void)setGroupName:(NSString *)name;

@end