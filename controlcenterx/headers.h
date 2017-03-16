// ATVMediumDark
// ATVSemiDark
// AccessoryDark
// Adaptive
// MenuDark

// darken - blavck, 0.75
// color tint - 0.149,359 viewalpha - 0.3
// other 0.2,0.4


// settings.colorBurnTintAlpha = 0.3
// settings.colorBurnTintLevel = 0;
// settings.colorOffsetAlpha = 1;
// settings.colorTint = [UIColor colorWithRed:0.149 green:0.149 blue:0.149 alpha:0.359];
// settings.colorTintAlpha = 0.3
// settings.colorTintMaskAlpha = 1;
// settings.usesColorBurnTintView = YES;
// settings.usesColorOffset = YES;
// settings.usesColorTintView = YES;
// settings.darkeningTintAlpha = 0.75;
// settings.darkeningTintBrightness = 0.75;
// settings.darkeningTintHue = 0;
// settings.darkeningTintSaturation = 0;
// settings.usesDarkeningTintView = YES;
// settings.grayscaleTintAlpha = 0.5;
// settings.grayscaleTintLevel = 0.2;
// settings.lightenGrayscaleWithSourceOver = YES;
// settings.usesGrayscaleTintView = YES;
// settings.saturationDeltaFactor = 0.6;
// setting.lightenGrayscaleWithSourceOver = YES;


// @interface CCUINightShiftContentView : UIView
// @property (nonatomic, readonly) CCUIControlCenterPushButton *button;
// - (void)addMediaControlsView;
// @end

// @interface CCUIButtonStack : UIView
// @property(nonatomic) id layoutDelegate; // CCUIButtonStackPagingView
// @property(copy, nonatomic) NSArray *buttons;
// @property(nonatomic) long long axis;
// @property(nonatomic) CGFloat interButtonPadding;
// - (void)removeButton:(id)arg1;
// - (void)addButton:(id)arg1;
// - (void)resortButtons;
// - (void)_updateStretching;
// - (void)layoutSubviews;
// - (id)initWithFrame:(CGRect)arg1;
// @end

// @interface CCUIButtonStackPagingView : UIView
// @property(copy, nonatomic) NSArray *buttons;
// @property(nonatomic) NSUInteger maxButtonsPerPage;
// @property(nonatomic) NSInteger pagingAxis;
// - (void)_organizeButtonsInPages;
// @end

#import "headers/headers.h"
#import "CCUIControlCenterPagePlatterView+Private.h"
@interface UIView (RemoveConstraints)
- (void)removeAllConstraints;
@end

@interface CCXTestViewController : UIViewController
- (CGSize)intrinsicContentSize;
- (void)loadView;
@end

@interface CCTXTestView : UIView
- (CGSize)intrinsicContentSize;
@end

@protocol CCXPageHeight
@required
- (CGFloat)requestedPageHeightForHeight:(CGFloat)height;
@end

