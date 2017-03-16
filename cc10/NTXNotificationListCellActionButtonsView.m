#import "NTXNotificationListCellActionButtonsView.h"

@implementation NTXNotificationListCellActionButtonsView

- (void)_configureButtonsStackViewIfNecessary {
	if (!_buttonsStackView) {
		_buttonsStackView = [[UIStackView alloc] initWithFrame:CGRectMake(0,0,0,0)];
		[_buttonsStackView setAutoresizingMask:2];
		[_buttonsStackView setAxis:0];
		[_buttonsStackView setDistribution:1];
		[_buttonsStackView setSpacing:1];
		[_clippingView addSubview:_buttonsStackView];
	}
}

- (void)_configureClippingViewIfNecessary {
	if (!_clippingView) {
		_clippingView = [[UIView alloc] initWithFrame:self.bounds];
		_clippingView.clipsToBounds = YES;
		[_clippingView _setContinuousCornerRadius:13.0f];
		[self addSubview:_clippingView];
	}
}

- (void)_configureDefaultWidth {
	
	for (UIView *view in [])
}

- (void)_layoutButtonsStackView {

}

- (void)_layoutClippingView {

}

- (CGFloat)_maxAllowedButtonWidth {

}

- (BOOL)adjustForContentSizeCategoryChange {

}

- (BOOL)adjustsFontForContentSizeCategory {

}

- (UIStackView *)buttonsStackView {

}

- (UIView *)clippingView {

}

- (void)configureCellActionButtonsForNotificationRequest:(id)arg1 cell:(id)arg2 {

}

- (CGFloat)defaultWidth {

}

- (BOOL)isBackgroundBlurred {

}

- (void)layoutSubviews {

}

- (void)setAdjustsFontForContentSizeCategory:(BOOL)arg1 {

}

- (void)setBackgroundBlurred:(BOOL)arg1 {

}

- (void)setButtonsStackView:(UIStackView *)arg1 {

}

- (void)setClippingView:(UIView *)arg1 {

}

- (void)setStretchedWidth:(CGFloat)arg1 {

}

- (CGSize)sizeThatFits:(CGSize)arg1 {

}

- (CGFloat)stretchedWidth {

}

- (void)traitCollectionDidChange:(id)arg1 {

}

- (void)willMoveToSuperview:(id)arg1 {

}

@end
