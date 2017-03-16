- (void)_revealActionButtonsViewForContentOffset:(CGPoint)offset {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat logicalOffset = [self _logicalContentOffsetForAbsoluteOffset:[scrollView contentOffset]];
	CGFloat defaultActionThreshold = [self _defaultActionExecuteThreshold];

	if (logicalOffset > defaultActionThreshold) {
		[self _executeDefaultActionIfCompleted];
	}

	if (logicalOffset < 0.0) {
		if (![_contentScrollView bounces]) {
			[_contentScrollView setBounces:YES];
		}
		CGPoint offset = [scrollView contentOffset];
		[self _revealActionButtonsViewForContentOffset:offset];
	}

	if ([[UIDevice currentDevice] userInterfaceIdiom] != 1) {
		[self setClipsToBounds:NO];
	}

	if (logicalOffset == 0.0 || ![self  supportsSwipeToDefaultAction]) {
		if ([[UIDevice currentDevice] userInterfaceIdiom] != 1) {
			[self setClipsToBounds:NO];
		}
		return;
	}
	// [self.layer setMaskedCorners:10];
	[self _setContinuousCornerRadius:13.0];
	[self setClipsToBounds:YES];
}

- (void)_configureFullActionsRevealContentOffset {
	CGFloat actionViewWidth = [self _actionButtonsViewWidthWithMargin];
	CGPoint offset = [self _absoluteContentOffsetForLogicalOffset:actionViewWidth];
}

- (void)_configureClippingRevealViewIfNecessary {
	if (!_clippingRevealView) {
		[self _configureCellScrollViewIfNecessary];
		_clippingRevealView = [[UIView alloc] initWithFrame:CGRectZero];
		_clippingRevealView.clipsToBounds = YES;
		_clippingRevealView.alpha = 0;
		_clippingRevealView.userInteractionEnabled = YES;
		[_clippingRevealView _setContinuousCornerRadius:13.0];
		[_cellScrollView addSubview:_clippingRevealView];
		[_cellScrollView sendSubviewToBack:_clippingRevealView];
	}
}

- (void)_configureActionButtonsViewHierarchyForPercentRevealed:(CGFloat)percentRevealed {
	[_clippingRevealView setHidden:(percentRevealed<=0)];
}

- (void)setInitialContentOffset:(CGPoint)offset {
	_initialContentOffset = offset;
}

- (CGFloat)_actionButtonsViewAlphaForPercentRevealed:(CGFloat)percent {
	CGFloat arg1;
	CGFloat arg2;
	CGFloat arg3;

	arg1 = fmin((CGFloat)1.0,percent);
	arg3 = [self _actionButtonsViewWidthWithMargin];
	arg2 = (CGFloat)0.0;
	if ((arg1 * arg3) > 30.0) {
		arg2 = ((arg1 * arg3) + -30.0) / (arg3 + -30.0);
	}
	return arg2;
}

- (void)_configureInitialContentOffset {
	CGPoint offset = [self _absoluteContentOffsetForLogicalOffset:0];
	[self setInitialContentOffset:offset];
}

- (CGFloat)_actionButtonsViewPercentRevealedForContentOffset:(CGPoint)offset {
	CGFloat logicalOffset = [self _logicalContentOffsetForAbsoluteOffset:offset];
	CGFloat percentRevealed = (-8.0 - logicalOffset)/[self _actionButtonsViewWidthWithMargin];
	return percentRevealed;
}

- (CGFloat)_actionButtonsViewWidthWithMargin {
	return _actionViewWidthConstraint.constant + 8;
}

- (CGFloat)_defaultActionExecuteThreshold {
	CGFloat cellWidth = self.frame.size.width;
	return _insetMargins.right + cellWidth;
}

- (BOOL)supportsSwipeToDefaultAction {
	return YES;
}

- (CGFloat)_defaultActionOvershootContentOffset {
	CGFloat cellWidth = self.frame.size.width;
	CGFloat value = _insetMargins.right + cellWidth * 1.2;
	return value;
}

-(BOOL)_shouldReverseLayoutDirection {
	return NO;
}

- (void)_executeDefaultActionIfCompleted {

}

- (CGPoint)_absoluteContentOffsetForLogicalOffset:(CGFloat)offset {

	CGPoint value = CGPointZero;
	if ([self _shouldReverseLayoutDirection]) {
		value.x = offset + [self _actionButtonsViewWidthWithMargin];
	} else if ([self supportsSwipeToDefaultAction]) {
		value.x = [self _defaultActionOvershootContentOffset] - offset;
	} else {
		value.x = offset;
	}
	return value;
}

- (CGFloat)_logicalContentOffsetForAbsoluteOffset:(CGPoint)offset {
	if ([self _shouldReverseLayoutDirection]) {
		return offset.x - [self _actionButtonsViewWidthWithMargin];
	} else if ([self supportsSwipeToDefaultAction]) {
		return [self _defaultActionOvershootContentOffset] - offset.x;
	} else {
		return offset.x;
	}
}

- (CGFloat)_defaultActionTriggerThreshold {
	return self.frame.size.width * 0.5;
}

[[self delegate] buttonModule:self willExecuteSecondaryActionWithCompletionHandler:nil];

@interface SBUIAction : NSObject
- (id)initWithTitle:(id)arg1 handler:(id /* block */)arg2;
- (id)initWithTitle:(id)arg1 subtitle:(id)arg2 handler:(id /* block */)arg3;
- (id)initWithTitle:(id)arg1 subtitle:(id)arg2 image:(id)arg3 badgeView:(id)arg4 handler:(id /* block */)arg5;
- (id)initWithTitle:(id)arg1 subtitle:(id)arg2 image:(id)arg3 handler:(id /* block */)arg4;
@end

@protocol CCUIButtonModuleDelegate <NSObject>
@required
- (void)buttonModule:(void *)arg1 willExecuteSecondaryActionWithCompletionHandler:(id /* block */))arg2;
@end

@interface CCUIButtonModule : NSObject
- (id<CCUIButtonModuleDelegate>)delegate;
@end

@interface CCUIWiFiSetting : CCUIButtonModule
@end

%hook CCUIWiFiSetting
- (int)orbBehavior {
	return 2; // returning 2 allows the 3D touch to be enabled and also tells it where to pull the options from.
}

- (NSArray *)buttonActions {
	NSMutableArray *actions = [NSMutableArray new];

	// SBUIAction can be thought of as UIApplicationShortcutItem in a way
	SBUIAction *network = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:@"Network" subtitle:@"disconnected" handler:^(void) {
    	NSLog(@"Connected to Network");
    	[[self delegate] buttonModule:self willExecuteSecondaryActionWithCompletionHandler:nil]; // this must be called to dismiss the 3D Touch Menu
	}];
	[actions addObject:network];

	return [actions copy];
}
%end