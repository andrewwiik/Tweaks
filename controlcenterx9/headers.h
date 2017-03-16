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

@class CCXControlCenterMediaControlsViewController;
@class CCXPopupControlCenterMediaControlsViewController;

@interface CCXControlCenterMediaControlsView : MPUControlCenterMediaControlsView
- (CCXControlCenterMediaControlsViewController *)delegate;
@end

@interface CCXPopupControlCenterMediaControlsView : MPUControlCenterMediaControlsView
- (CCXPopupControlCenterMediaControlsViewController *)delegate;
- (CGSize)intrinsicContentSize;
@end


@interface CCXControlCenterMediaControlsViewController : MPUControlCenterMediaControlsViewController <SBUIIconForceTouchControllerDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, retain) CCXControlCenterMediaControlsView *view;
@property (nonatomic, retain) SBUIIconForceTouchController *iconForceTouchController;
@property (nonatomic, retain) SBUIForceTouchGestureRecognizer *forceTouchGestureRecognizer;
- (CGRect)iconForceTouchController:(SBUIIconForceTouchController *)arg1 iconViewFrameForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (NSInteger)iconForceTouchController:(SBUIIconForceTouchController *)arg1 layoutStyleForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (UIView *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 newIconViewCopyForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 primaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 secondaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
@end

@interface CCXPopupControlCenterMediaControlsViewController : MPUControlCenterMediaControlsViewController
@property (nonatomic, retain) CCXPopupControlCenterMediaControlsView *view;
@property (nonatomic, assign) BOOL fakeContentSize;
@end


