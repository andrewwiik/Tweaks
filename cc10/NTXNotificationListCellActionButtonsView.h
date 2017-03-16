#import "NTXNotificationListCellActionButton.h"
#import "NTXVibrancyStyling.h"
#import "NTXMaterialView.h"
#import "NTXBackdropViewSettings.h"

#import "headers/BulletinBoard/BulletinBoard.h"

@interface NTXNotificationListCellActionButtonsView : UIView {
    BOOL  _adjustsFontForContentSizeCategory;
    BOOL  _backgroundBlurred;
    UIStackView * _buttonsStackView;
    UIView * _clippingView;
    CGFloat  _defaultWidth;
    CGFloat  _stretchedWidth;
}

@property (nonatomic) BOOL adjustsFontForContentSizeCategory;
@property (getter=isBackgroundBlurred, nonatomic) BOOL backgroundBlurred;
@property (nonatomic, retain) UIStackView *buttonsStackView;
@property (nonatomic, retain) UIView *clippingView;
@property (nonatomic, copy) NSString *preferredContentSizeCategory;
@property (nonatomic) CGFloat stretchedWidth;

+ (id)_actionButtonDescriptionsForNotificationRequest:(id)arg1 cell:(id)arg2;
+ (unsigned int)numberOfActionButtonsForNotificationRequest:(id)arg1 cell:(id)arg2;

- (void)_configureButtonsStackViewIfNecessary;
- (void)_configureClippingViewIfNecessary;
- (void)_configureDefaultWidth;
- (void)_layoutButtonsStackView;
- (void)_layoutClippingView;
- (CGFloat)_maxAllowedButtonWidth;
- (BOOL)adjustForContentSizeCategoryChange;
- (BOOL)adjustsFontForContentSizeCategory;
- (UIStackView *)buttonsStackView;
- (UIView *)clippingView;
- (void)configureCellActionButtonsForNotificationRequest:(id)arg1 cell:(id)arg2;
- (CGFloat)defaultWidth;
- (BOOL)isBackgroundBlurred;
- (void)layoutSubviews;
- (void)setAdjustsFontForContentSizeCategory:(BOOL)arg1;
- (void)setBackgroundBlurred:(BOOL)arg1;
- (void)setButtonsStackView:(UIStackView *)arg1;
- (void)setClippingView:(UIView *)arg1;
- (void)setStretchedWidth:(CGFloat)arg1;
- (CGSize)sizeThatFits:(CGSize)arg1;
- (CGFloat)stretchedWidth;
- (void)traitCollectionDidChange:(id)arg1;
- (void)willMoveToSuperview:(id)arg1;

@end