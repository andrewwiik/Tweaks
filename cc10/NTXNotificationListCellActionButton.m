#import "NTXNotificationListCellActionButton.h"

@implementation NTXNotificationListCellActionButton

- (void)_configureBackgroundOverlayViewIfNecessary {
	if (!_backgroundOverlayView) {
		_backgroundOverlayView = [NTXMaterialView materialViewWithStyleOptions:8];
		[_backgroundOverlayView setUserInteractionEnabled:NO];
		[_backgroundOverlayView setHidden:NO];
		[self addSubview:_backgroundOverlayView];
		[self sendSubviewToBack:_backgroundOverlayView];

		_backgroundOverlayView.translatesAutoresizingMaskIntoConstraints = NO;

		[self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundOverlayView
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1
                                                       constant:0]];

		[self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundOverlayView
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1
                                                       constant:0]];

		[self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundOverlayView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1
                                                       constant:0]];

		[self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundOverlayView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1
                                                       constant:0]];
	}
}

- (void)_configureBackgroundViewIfNecessary {
	if (!_backgroundView) {
		// if (!_customBackgroundView) {
		// 	//NTXBackdropViewSettings *_backdropSettings = [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
		// 	_backgroundView = [[NSClassFromString(@"SBWallpaperEffectView") alloc] initWithWallpaperVariant:0];
		// 	[_backgroundView setStyle:11];
		// 	[_backgroundView setUserInteractionEnabled:NO];
		// 	[self addSubview:_backgroundView];
		// 	[self sendSubviewToBack:_backgroundView];
		// 	_backgroundView.translatesAutoresizingMaskIntoConstraints = NO;

		// 	[self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView
  //                                                     attribute:NSLayoutAttributeCenterX
  //                                                     relatedBy:NSLayoutRelationEqual
  //                                                        toItem:self
  //                                                     attribute:NSLayoutAttributeCenterX
  //                                                    multiplier:1
  //                                                      constant:0]];

		// 	[self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView
	 //                                                      attribute:NSLayoutAttributeCenterY
	 //                                                      relatedBy:NSLayoutRelationEqual
	 //                                                         toItem:self
	 //                                                      attribute:NSLayoutAttributeCenterY
	 //                                                     multiplier:1
	 //                                                       constant:0]];

		// 	[self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView
	 //                                                      attribute:NSLayoutAttributeWidth
	 //                                                      relatedBy:NSLayoutRelationEqual
	 //                                                         toItem:self
	 //                                                      attribute:NSLayoutAttributeWidth
	 //                                                     multiplier:1
	 //                                                       constant:0]];

		// 	[self addConstraint:[NSLayoutConstraint constraintWithItem:_backgroundView
	 //                                                      attribute:NSLayoutAttributeHeight
	 //                                                      relatedBy:NSLayoutRelationEqual
	 //                                                         toItem:self
	 //                                                      attribute:NSLayoutAttributeHeight
	 //                                                     multiplier:1
	 //                                                       constant:0]];
		// }
	}
}

- (void)_configureTitleLabelIfNecessary {
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
		[_titleLabel setTextAlignment:1];
		[_titleLabel setMinimumScaleFactor:0.5];
		[_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[_titleLabel setAdjustsFontSizeToFitWidth:YES];

		NSString *title = [self title];
		if (!title) {
			title = ((UIButton *)[_notificationAction _button]).currentTitle;
		}
		if (!title) {
			if ([[_notificationAction _button] isKindOfClass:NSClassFromString(@"SBTableViewCellDismissActionButton")]) {
				title = [NSString stringWithFormat:@"Clear"];
			}
		}

		_titleLabel.numberOfLines = ([self _wordCountForText:title] > 1) + 1;

		_titleLabel.text = title;
		[self _updateTitleLabelFont];
		_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

		[self addSubview:_titleLabel];

		[self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1
                                                       constant:0]];

		[self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1
                                                       constant:0]];

		[self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1
                                                       constant:0]];

		[self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1
                                                       constant:0]];

		NTXApplyVibrantStyling([NTXVibrantPrimaryStyling new], _titleLabel);
		// if (_notificationAction.action.appearance.style == 1) {
		// 	[_titleLabel setTextColor:[UIColor systemRedColor]];
		// }
		[_titleLabel sizeToFit];


	}
}

- (void)_highlightButton:(UIControl *)button {
	[button setHighlighted:YES];
}
;
- (void)_layoutBackgroundOverlayView {
	return;
}

- (void)_layoutBackgroundView {
	return;
}

- (void)_layoutTitleLabel {
	return;
}

- (void)_unHighlightButton:(id)arg1 {
	[self setHighlighted:NO];
}

- (void)_updateTitleLabelFont {

	UIFontDescriptor *descriptor = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline] fontDescriptorWithFamily:@".SFUIText"];
	// if (_titleLabel.numberOfLines > 1)
	// 	descriptor = [descriptor fontDescriptorWithSymbolicTraits:3];
	UIFont *font = [UIFont fontWithDescriptor:descriptor size:0];
	_titleLabel.font = font;
	[_titleLabel sizeToFit];
}

- (long long)_wordCountForText:(NSString *)string {
	 __block NSUInteger wordCount = 0;
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length)
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *character, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        wordCount++;
    }];
    return (long long)wordCount;
}

- (BOOL)adjustForContentSizeCategoryChange {
	NSString *new = [[UIApplication sharedApplication] preferredContentSizeCategory];
	if (![new isEqualToString:[self preferredContentSizeCategory]]) {
		[self setPreferredContentSizeCategory:new];
		[self _updateTitleLabelFont];
		[self setNeedsLayout];
	}
	return (![new isEqualToString:[self preferredContentSizeCategory]]);
}

- (BOOL)adjustsFontForContentSizeCategory {
	return _adjustsFontForContentSizeCategory;
}

- (UIView *)backgroundOverlayView {
	return _backgroundOverlayView;
}

- (SBWallpaperEffectView *)backgroundView {
	return _backgroundView;
}

- (UIView *)customBackgroundView {
	return _customBackgroundView;
}

- (instancetype)initWithFrame:(CGRect)frame {
	NTXNotificationListCellActionButton *button = [super initWithFrame:frame];
	if (button) {
		[button addTarget:button action:@selector(_highlightButton:) forControlEvents:1];
		[button addTarget:button action:@selector(_unHighlightButton:) forControlEvents:64];
		[button addTarget:button action:@selector(_highlightButton:) forControlEvents:16];
		[button addTarget:button action:@selector(_unHighlightButton:) forControlEvents:32];
		//[button addTarget:self  action:@selector(methodTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	}
	return button;
}

- (BOOL)isBackgroundBlurred {
	return _backgroundBlurred;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self _configureTitleLabelIfNecessary];
	[self _configureBackgroundOverlayViewIfNecessary];
	[self _configureBackgroundViewIfNecessary];
	[self _layoutTitleLabel];
	[self _layoutBackgroundOverlayView];
	[self _layoutBackgroundView];
}

- (UITableViewRowAction *)notificationAction {
	return _notificationAction;
}

- (NSString *)preferredContentSizeCategory {
	NSString *cat = _preferredContentSizeCategory;
	if (!cat) {
		_preferredContentSizeCategory = nil;
	}
	return _preferredContentSizeCategory;
}

- (void)setAdjustsFontForContentSizeCategory:(BOOL)arg1 {
	if (_adjustsFontForContentSizeCategory != arg1) {
		if (arg1) {
			NSString *new = [[UIApplication sharedApplication] preferredContentSizeCategory];
			[self setPreferredContentSizeCategory:new];
		}
		[self adjustForContentSizeCategoryChange];
	}
}

- (void)setBackgroundBlurred:(BOOL)arg1 {
	if (arg1 != _backgroundBlurred) {
		_backgroundBlurred = arg1;
		[_backgroundView removeFromSuperview];
		_backgroundView = nil;
		[self setNeedsLayout];
	}
}

- (void)setBackgroundOverlayView:(UIView *)arg1 {
	_backgroundOverlayView = arg1;
}

- (void)setBackgroundView:(SBWallpaperEffectView *)arg1 {
	_backgroundView = arg1;
}

- (void)setCustomBackgroundView:(UIView *)arg1 {
	if (_customBackgroundView != arg1) {
		_customBackgroundView = arg1;
		[_backgroundView removeFromSuperview];
		_backgroundView = nil;
		[self setNeedsLayout];
	}
}

- (void)setHighlighted:(BOOL)arg1 {
	[super setHighlighted:arg1];
	[_backgroundOverlayView setHidden:arg1];
}

- (void)setNotificationAction:(UITableViewRowAction *)arg1 {
	if (_notificationAction != arg1) {
		_notificationAction = arg1;
		[_titleLabel removeFromSuperview];
		_titleLabel = nil;
		[self _configureTitleLabelIfNecessary];
		[self setNeedsLayout];
	}
}

- (void)setTitle:(NSString *)arg1 {
	if (_title != arg1) {
		_title = arg1;
		[_titleLabel removeFromSuperview];
		_titleLabel = nil;
		[self _configureTitleLabelIfNecessary];
		[self setNeedsLayout];
	}
}

- (void)setTitleLabel:(UILabel *)arg1 {
	_titleLabel = arg1;
}

- (UILabel *)titleLabel {
	return _titleLabel;
}

- (void)traitCollectionDidChange:(id)arg1 {
	[super traitCollectionDidChange:arg1];
	if ([self adjustsFontForContentSizeCategory]) {
		[self adjustForContentSizeCategoryChange];
	}
}

- (void)willMoveToSuperview:(id)arg1 {
	[self.layer setAllowsGroupBlending:NO];
}

@end