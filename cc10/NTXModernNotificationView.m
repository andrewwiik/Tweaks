#import "NTXModernNotificationView.h"

/* Primary Label:

Font: UIFontTextStyleSubheadline
Text Color: [UIColor blackColor]
Number of Lines: 1

[[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];

UIFontDescriptorTraitBold
Secondary Label:

Text Color: 0.95,0.95,0.95,1
Text Size: 13
Font: .SFUIText-Regular

Help Label:



shortlookstyle = 0
*/

// [[[[NSClassFromString(@"SBWallpaperController") sharedInstance] lockscreenWallpaperView] wallpaperImage] _applyBackdropViewSettings:[NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES] includeTints:YES includeBlur:YES]

@implementation NTXModernNotificationView
- (id)init {
	self = [super init];
	if (self) {
		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.backgroundColor = nil;
		self.opaque = YES;
		self.clipsToBounds = NO;

		_isPanning = NO;

		// _cellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		// [_cellScrollView setAutoresizingMask:16];
		// [_cellScrollView setShowsHorizontalScrollIndicator:NO];
		// [_cellScrollView setShowsVerticalScrollIndicator:NO];
		// [_cellScrollView setDecelerationRate:UIScrollViewDecelerationRateFast];
		// [_cellScrollView setDelaysContentTouches:NO];
		// [_cellScrollView setClipsToBounds:NO];
		// [_cellScrollView setBounces:NO];
		// _cellScrollView.backgroundColor = nil;
		// _cellScrollView.delegate = self;
		// _cellScrollView.translatesAutoresizingMaskIntoConstraints = NO;

		// [self addSubview:_cellScrollView];

		_notificationView = [[UIView alloc] initWithFrame:CGRectMake(8,0,398,98)];
		_notificationView.backgroundColor = nil;
		_notificationView.layer.cornerRadius = 13;
		_notificationView.layer.masksToBounds = YES;
		_notificationView.clipsToBounds = YES;
		_notificationView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_notificationView];

		_actionsClippingView = [[UIView alloc] initWithFrame:CGRectMake(8,0,0,0)];
		_actionsClippingView.backgroundColor = nil;
		_actionsClippingView.layer.cornerRadius = 13;
		_actionsClippingView.layer.masksToBounds = YES;
		_actionsClippingView.clipsToBounds = YES;
		_actionsClippingView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_actionsClippingView];

		_actionsClippingBackgroundView = [[NSClassFromString(@"SBWallpaperEffectView") alloc] initWithWallpaperVariant:0];
		[_actionsClippingBackgroundView setStyle:32];
		[_actionsClippingBackgroundView setUserInteractionEnabled:NO];
		_actionsClippingBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
		[_actionsClippingView addSubview:_actionsClippingBackgroundView];
		[_actionsClippingView sendSubviewToBack:_actionsClippingBackgroundView];

		_actionsView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
		_actionsView.backgroundColor = nil;
		// _actionsView.layer.cornerRadius = 14;
		// _actionsView.layer.masksToBounds = YES;
		// _actionsView.clipsToBounds = YES;
		_actionsView.translatesAutoresizingMaskIntoConstraints = NO;
		// _actionsView.alpha
		[_actionsClippingView addSubview:_actionsView];

		// _backdropSettings = [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
		// _backdropView = [[_UIBackdropView alloc] initWithSettings:_backdropSettings];
		_backdropView = [[NSClassFromString(@"SBWallpaperEffectView") alloc] initWithWallpaperVariant:0];
		[_backdropView setStyle:32];
		_backdropView.translatesAutoresizingMaskIntoConstraints = NO;
		[_notificationView addSubview:_backdropView];
		[_notificationView sendSubviewToBack:_backdropView];
		NSLog(@"%@", _backdropView);


		_headerView = [NTXMaterialView materialViewWithStyleOptions:8];
		_headerView.translatesAutoresizingMaskIntoConstraints = NO;
		[_notificationView addSubview:_headerView];

		_contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
		_contentView.backgroundColor = nil;
		_contentView.translatesAutoresizingMaskIntoConstraints = NO;
		[_notificationView addSubview:_contentView];


		_iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];
		_iconView.translatesAutoresizingMaskIntoConstraints = NO;
		[_headerView addSubview:_iconView];

		_appLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_appLabel.font = [[self class] appLabelFont];
		_appLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[_headerView addSubview:_appLabel];
		NTXApplyVibrantStyling([[NTXVibrantSecondaryStyling alloc] init], _appLabel);

		_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_dateLabel.font = [[self class] dateLabelFont];
		_dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
		[_headerView addSubview:_dateLabel];
		NTXApplyVibrantStyling([[NTXVibrantSecondaryStyling alloc] init], _dateLabel);

		_primaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_primaryLabel.font = [[self class] primaryLabelFont];
		_primaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_primaryLabel.numberOfLines = 1;
		[_contentView addSubview:_primaryLabel];
		NTXApplyVibrantStyling([[NTXVibrantPrimaryStyling alloc] init], _primaryLabel);

	    _primarySubtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	    _primarySubtitleLabel.font = [[self class] primarySubtitleLabelFont];
	    _primarySubtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	    _primarySubtitleLabel.numberOfLines = 1;
	    [_contentView addSubview:_primarySubtitleLabel];
	    NTXApplyVibrantStyling([[NTXVibrantPrimaryStyling alloc] init], _primarySubtitleLabel);

		_secondaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_secondaryLabel.font = [[self class] secondaryLabelFont];
		_secondaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_secondaryLabel.numberOfLines = 0;
		[_contentView addSubview:_secondaryLabel];
		NTXApplyVibrantStyling([[NTXVibrantPrimaryStyling alloc] init],_secondaryLabel);

		_hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		_hintLabel.font = [[self class] hintLabelFont];
		_hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_hintLabel.numberOfLines = 1;
		[_contentView addSubview:_hintLabel];
		NTXApplyVibrantStyling([[NTXVibrantSecondaryStyling alloc] init], _hintLabel);

		_thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];
		_thumbnailView.clipsToBounds = YES;
		[_thumbnailView _setContinuousCornerRadius:3.0];
		_thumbnailView.translatesAutoresizingMaskIntoConstraints = NO;
		[_contentView addSubview:_thumbnailView];

		_rightSideConstraints = [NSMutableArray new];

		_addedConstraints = NO;

		self.revealGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    	self.revealGesture.delegate = self;
    	[self addGestureRecognizer:self.revealGesture];
    	[_notificationView sendSubviewToBack:_backdropView];
	}
	return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // note: we might be called from an internal UITableViewCell long press gesture

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {

        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGestureRecognizer translationInView:_notificationView];

        // Check for horizontal gesture
        if (fabs(translation.x) > fabs(translation.y))
        {
            return YES;
        }

    }

    return NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {

	CGPoint translation = [gesture translationInView:self];
	CGPoint location = [gesture locationInView:self];
	CGPoint velocity = [gesture velocityInView:self];

	if(gesture.state == UIGestureRecognizerStateBegan) {

		if (((SBLockScreenNotificationCell *)[self superview]).delegate.draggedCell) {
			if (((SBLockScreenNotificationCell *)[self superview]).delegate.draggedCell != self) {
				self.revealGesture.enabled = NO;
				self.revealGesture.enabled = YES;
				[((SBLockScreenNotificationCell *)[self superview]).delegate.draggedCell closeActionsView];
				((SBLockScreenNotificationCell *)[self superview]).delegate.draggedCell = nil;
				return;
			}
		} else {
			((SBLockScreenNotificationCell *)[self superview]).delegate.draggedCell = self;
		}
		_isPanning = YES;
            //NSLog(@"Received a pan gesture");
		_startingPoint = location.x;

    	_panningX = translation.x;

    	[((SBLockScreenNotificationCell *)[self superview]).delegate _disableIdleTimer:YES];
    }

    if (gesture.state == UIGestureRecognizerStateChanged) {
    	_lastChange = CFAbsoluteTimeGetCurrent();
    	if (location.x > _startingPoint) {
    		_startingPoint = location.x;
    	}
    	CGFloat translated = translation.x - _panningX;
    	if (_notificationViewLeftConstraint.constant + translated <= 8) {
    		if (_notificationViewLeftConstraint.constant + translated <= (self.frame.size.width*0.95)*-1) {
    			_notificationViewLeftConstraint.constant = (self.frame.size.width*0.95)*-1;
    		} else {
	    		_notificationViewLeftConstraint.constant += translated;
	    		// _actionsClippingView.alpha = [self alphaForPercentRevealed:(CGFloat)((CGFloat)(_notificationViewLeftConstraint.constant-8)/_actionViewWidthConstraint.constant)];
	    	}
	    } else if (_notificationViewLeftConstraint.constant + translated > 8) {
	    	_notificationViewLeftConstraint.constant += translated;
	    }
	    _panningX = translation.x;
    }

    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {

    	CGFloat curTime = CFAbsoluteTimeGetCurrent(); 
        CGFloat timeElapsed = curTime - _lastChange;
        CGPoint finalSpeed;
         if ( timeElapsed < 0.5 )
              finalSpeed = velocity;
         else
              finalSpeed = CGPointZero;

          NSLog(@"FINAL SPEED: %@", NSStringFromCGPoint(finalSpeed));


    	if (_notificationViewLeftConstraint.constant*-1 > _actionViewWidthConstraint.constant || (finalSpeed.x < (CGFloat)-500 && _notificationViewLeftConstraint.constant < 8)) {
    		_notificationViewLeftConstraint.constant = _actionViewWidthConstraint.constant*-1;
    	} else {
    		if ((finalSpeed.x > (CGFloat)200 && _notificationViewLeftConstraint.constant > 8) || (_notificationViewLeftConstraint.constant > self.frame.size.width/(2/3))) {
    			 [((SBLockScreenNotificationCell *)[self superview]).delegate.model handleLockScreenActionWithContext:((SBLockScreenNotificationCell *)[self superview]).lockScreenActionContext];
    			// if (((SBLockScreenNotificationCell *)[self superview]).delegate.draggedCell == self) {
    			// 	((SBLockScreenNotificationCell *)[self superview]).delegate.draggedCell = nil;
    			// }
    			_notificationViewLeftConstraint.constant = self.frame.size.width*1;
    			[((SBLockScreenNotificationCell *)[self superview]).delegate _disableIdleTimer:YES];
    			[_notificationView setNeedsUpdateConstraints];
			    [_actionsClippingView setNeedsUpdateConstraints];
			    [_actionsView setNeedsUpdateConstraints];

			    [UIView animateWithDuration:0.25f animations:^{
			   		[_notificationView layoutIfNeeded];
			   		[_actionsClippingView layoutIfNeeded];
			    	[_actionsView layoutIfNeeded];
			    	// _actionsClippingView.alpha = [self alphaForPercentRevealed:(CGFloat)((CGFloat)(ABS(_notificationViewLeftConstraint.constant)-8)/_actionViewWidthConstraint.constant)];
				}];
				_isPanning = NO;
				return;
	    	}
    		_notificationViewLeftConstraint.constant = 8;
    		if (((SBLockScreenNotificationCell *)[self superview]).delegate.draggedCell == self) {
    			((SBLockScreenNotificationCell *)[self superview]).delegate.draggedCell = nil;
    		}
    		[((SBLockScreenNotificationCell *)[self superview]).delegate _disableIdleTimer:NO];
    	}
    	[_notificationView setNeedsUpdateConstraints];
	    [_actionsClippingView setNeedsUpdateConstraints];
	    [_actionsView setNeedsUpdateConstraints];

	    [UIView animateWithDuration:0.25f animations:^{
	   		[_notificationView layoutIfNeeded];
	   		[_actionsClippingView layoutIfNeeded];
	    	[_actionsView layoutIfNeeded];
	    	 _actionsClippingView.alpha = [self alphaForPercentRevealed:(CGFloat)((CGFloat)(ABS(_notificationViewLeftConstraint.constant)-8)/_actionViewWidthConstraint.constant)];
		}];

		_isPanning = NO;

		return;
    }

    [_notificationView setNeedsUpdateConstraints];
    [_actionsClippingView setNeedsUpdateConstraints];
    [_actionsView setNeedsUpdateConstraints];

    _actionsClippingView.alpha = [self alphaForPercentRevealed:(CGFloat)((CGFloat)(ABS(_notificationViewLeftConstraint.constant)-8)/_actionViewWidthConstraint.constant)];
   	[_notificationView layoutIfNeeded];
   	[_actionsClippingView layoutIfNeeded];
    [_actionsView layoutIfNeeded];

    // CGFloat newX = [gesture locationInView:_notificationView].x;
    // float dX = newCoord-_panningX;
}

- (void)addConstraintsNow {
	if (!_addedConstraints) {
	if ([self superview]) {

		// Start Constraining Self
		[[self superview] addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:[self superview]
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1
                                                       constant:0]];
		// [[self superview] addConstraint:[NSLayoutConstraint constraintWithItem:self
  //                                                     attribute:NSLayoutAttributeHeight
  //                                                     relatedBy:NSLayoutRelationEqual
  //                                                        toItem:[self superview]
  //                                                     attribute:NSLayoutAttributeHeight
  //                                                    multiplier:1
  //                                                      constant:0]];
		[[self superview] addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:[self superview]
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0]];
		[[self superview] addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:[self superview]
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0]];
		// End Constraining Self
	}

	// [self addConstraint:[NSLayoutConstraint constraintWithItem:_cellScrollView
 //                                                      attribute:NSLayoutAttributeTop
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:self
 //                                                      attribute:NSLayoutAttributeTop
 //                                                     multiplier:1
 //                                                       constant:0]];
	// [self addConstraint:[NSLayoutConstraint constraintWithItem:_cellScrollView
 //                                                      attribute:NSLayoutAttributeLeft
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:self
 //                                                      attribute:NSLayoutAttributeLeft
 //                                                     multiplier:1
 //                                                       constant:0]];
	// [self addConstraint:[NSLayoutConstraint constraintWithItem:_cellScrollView
 //                                                      attribute:NSLayoutAttributeRight
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:self
 //                                                      attribute:NSLayoutAttributeRight
 //                                                     multiplier:1
 //                                                       constant:0]];

	// [self addConstraint:[NSLayoutConstraint constraintWithItem:_cellScrollView
 //                                                      attribute:NSLayoutAttributeBottom
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:self
 //                                                      attribute:NSLayoutAttributeBottom
 //                                                     multiplier:1
 //                                                       constant:0]];

	// Start Constraining Notification View
	[self addConstraint:[NSLayoutConstraint constraintWithItem:_notificationView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0]];

	_notificationViewLeftConstraint = [NSLayoutConstraint constraintWithItem:_notificationView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:8];

	[self addConstraint:_notificationViewLeftConstraint];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:_notificationView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1
                                                       constant:-16]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:_notificationView
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:0]];
	// End Constraining Notification View

	[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_backdropView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0]];

	[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_backdropView
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:0]];

	[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_backdropView
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:0]];
	[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_backdropView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0]];

	// Start Constraining Header View

	[self addConstraint:[NSLayoutConstraint constraintWithItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:-8]];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:8]];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0]];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:0]];

	// COnfiguring Actions CLipping View Background view

	[_actionsClippingView addConstraint:[NSLayoutConstraint constraintWithItem:_actionsClippingBackgroundView
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1
                                                       constant:0]];

	[_actionsClippingView addConstraint:[NSLayoutConstraint constraintWithItem:_actionsClippingBackgroundView
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1
                                                       constant:0]];

	[_actionsClippingView addConstraint:[NSLayoutConstraint constraintWithItem:_actionsClippingBackgroundView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1
                                                       constant:0]];

	[_actionsClippingView addConstraint:[NSLayoutConstraint constraintWithItem:_actionsClippingBackgroundView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1
                                                       constant:0]];

	_actionViewWidthConstraint = [NSLayoutConstraint constraintWithItem:_actionsView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:150];

	[_actionsClippingView addConstraint:_actionViewWidthConstraint];

	[_actionsClippingView addConstraint:[NSLayoutConstraint constraintWithItem:_actionsView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0]];

	[_actionsClippingView addConstraint:[NSLayoutConstraint constraintWithItem:_actionsView
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:0]];

	[_actionsClippingView addConstraint:[NSLayoutConstraint constraintWithItem:_actionsView
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:0]];

	NSLayoutConstraint *actionViewLeftConstraint = [NSLayoutConstraint constraintWithItem:_actionsView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0];
	actionViewLeftConstraint.priority = 999;

	[_actionsClippingView addConstraint:actionViewLeftConstraint];

	[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_headerView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0]];
	[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_headerView
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:0]];
	[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_headerView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0]];
	[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_headerView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:32]];

	// End Constraining Header View

	// Start Constraining Content View

	[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_headerView
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:8]];
	[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:15]];
	[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:-15]];
	// End Constraining Content View

	// Start Constraining Icon View

	[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_iconView
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_headerView
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1
                                                       constant:0]];
	[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_iconView
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_headerView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:8]];
	[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_iconView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:20]];
	[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_iconView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:20]];

	// End Constraining Icon View

	// Start Constraining App Label

	[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_appLabel
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_headerView
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1
                                                       constant:0]];
	[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_appLabel
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_headerView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:36]];

	// End Constraining App Label

	// Start Constraining Date Label
	[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_dateLabel
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_appLabel
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:0]];
	[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_dateLabel
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_headerView
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:-15]];

	// End Constraining Date Label

	// Start Constraining Attachment Thumbnail 
	[_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:35]];

	[_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:35]];

	[_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailView
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_contentView
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:0]];

	[_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_thumbnailView
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_contentView
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:0]];



	// Start Constraining Primary Label

	[_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryLabel
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_contentView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0]];
	[_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primaryLabel
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_contentView
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:-2]];
	NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_primaryLabel
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_thumbnailView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0];
	[_contentView addConstraint:rightConstraint];
	[_rightSideConstraints addObject:rightConstraint];

	// End Constraining Primary Label

	// Start Constraining Primary Subtitle Label

	[_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primarySubtitleLabel
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_contentView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0]];
	[_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_primarySubtitleLabel
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_primaryLabel
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:0]];
	rightConstraint = [NSLayoutConstraint constraintWithItem:_primarySubtitleLabel
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_thumbnailView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0];
	[_contentView addConstraint:rightConstraint];
	[_rightSideConstraints addObject:rightConstraint];

	// End Constraining Primary Subtitle Label

	// Start Constraining Secondary Label

	[_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondaryLabel
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_contentView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0]];

	rightConstraint = [NSLayoutConstraint constraintWithItem:_secondaryLabel
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_thumbnailView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0];
	[_contentView addConstraint:rightConstraint];
	[_rightSideConstraints addObject:rightConstraint];

	[_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_secondaryLabel
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_primarySubtitleLabel
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:0]];
	// End Constraining Secondary Label

	// Start Constraining Hint Label

	[_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_hintLabel
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_contentView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0]];

	rightConstraint = [NSLayoutConstraint constraintWithItem:_hintLabel
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_thumbnailView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0];
	[_contentView addConstraint:rightConstraint];
	[_rightSideConstraints addObject:rightConstraint];

	_hintLabelTopConstraint = [NSLayoutConstraint constraintWithItem:_hintLabel
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_secondaryLabel
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:0];
	[_contentView addConstraint:_hintLabelTopConstraint];

	// End Constraining Hint Label

	// [self superview].translatesAutoresizingMaskIntoConstraints = NO;

	_contentViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_contentView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                      constant:0];

	[self addConstraint:_contentViewHeightConstraint];

	_contentViewPaddingConstraint = [NSLayoutConstraint constraintWithItem:self
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_contentView
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                      constant:8];

	[[self superview] addConstraint:_contentViewPaddingConstraint];
	// [[[self superview] superview] addConstraint:[NSLayoutConstraint constraintWithItem:[self superview]
 //                                                      attribute:NSLayoutAttributeHeight
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:self
 //                                                      attribute:NSLayoutAttributeHeight
 //                                                     multiplier:1
 //                                                      constant:8]];
	// [[[self superview] superview] addConstraint:[NSLayoutConstraint constraintWithItem:[self superview]
 //                                                      attribute:NSLayoutAttributeWidth
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:[[self superview] superview]
 //                                                      attribute:NSLayoutAttributeWidth
 //                                                     multiplier:1
 //                                                      constant:0]];
	// [[[self superview] superview] addConstraint:[NSLayoutConstraint constraintWithItem:[self superview]
 //                                                      attribute:NSLayoutAttributeLeft
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:[[self superview] superview]
 //                                                      attribute:NSLayoutAttributeLeft
 //                                                     multiplier:1
 //                                                      constant:0]];


	// End Constraining Secondary Label

	[self setNeedsLayout];
	}

	_addedConstraints = YES;
}

- (void)closeActionsView {
	_notificationViewLeftConstraint.constant = 8;
    [_notificationView setNeedsUpdateConstraints];
	[_actionsClippingView setNeedsUpdateConstraints];
	[_actionsView setNeedsUpdateConstraints];

	[UIView animateWithDuration:0.2f animations:^{
	   	[_notificationView layoutIfNeeded];
	   	[_actionsClippingView layoutIfNeeded];
	    [_actionsView layoutIfNeeded];
	}];
}

- (void)_configureCellScrollViewIfNecessary {

}

-(void)layoutSubviews {
	[super layoutSubviews];
	if (!_isPanning) {
		[self updateHeight];
	}
	if (_notificationViewLeftConstraint.constant < 0) {
		if ([self superview]) {
			[self superview].clipsToBounds = NO;
			if ([[self superview] superview]) {

				if (![[[[self superview] superview] superview] superview].layer.mask) {
					CALayer *mask = [CALayer new];
					CGRect workingFrame = [[[[self superview] superview] superview] superview].frame;
					mask.frame = CGRectMake(-1*workingFrame.size.width,0,workingFrame.size.width*3,workingFrame.size.height);
					mask.backgroundColor = [[UIColor blackColor] CGColor];
					[[[[self superview] superview] superview] superview].layer.mask = mask;
				}
				[[[self superview] superview] superview].clipsToBounds = NO;
				[[[[self superview] superview] superview] superview].clipsToBounds = NO;
			}
		}
	} else {
		if ([self superview]) {
			[self superview].clipsToBounds = YES;
			if ([[self superview] superview]) {
				if ([[[[self superview] superview] superview] superview].layer.mask) {
					[[[[self superview] superview] superview] superview].layer.mask = nil;
				}
				[[[self superview] superview] superview].clipsToBounds = YES;
				[[[[self superview] superview] superview] superview].clipsToBounds = YES;
			}
		}
	}
}

- (void)updateHeight {
	if (_listItem) {
		CGFloat properHeight = 0;

		[_appLabel sizeToFit];
	  	[_dateLabel sizeToFit];
	  	[_primaryLabel sizeToFit];
	  	[_primarySubtitleLabel sizeToFit];
	  	[_secondaryLabel sizeToFit];
	  	[_hintLabel sizeToFit];

		properHeight+= _primaryLabel.frame.size.height;
		properHeight+= _primarySubtitleLabel.frame.size.height;
		properHeight+= _secondaryLabel.frame.size.height;
		properHeight+= _hintLabel.frame.size.height;

		if (_hintIsShowing) {
			properHeight+= 2;
		}
		if (_thumbnailView.image) {
			if (properHeight < _thumbnailView.frame.size.height) {
				properHeight = _thumbnailView.frame.size.height;
			}
		}
		if (_contentViewHeightConstraint.constant != properHeight) {
			_contentViewHeightConstraint.constant = properHeight;
			[self setNeedsLayout];
			[_contentView setNeedsLayout];
			[_notificationView setNeedsLayout];
			[_contentView layoutIfNeeded];
			[_notificationView layoutIfNeeded];
			[self layoutIfNeeded];
			if ([[self superview] isKindOfClass:NSClassFromString(@"SBLockScreenNotificationCell")]) {
				[((SBLockScreenNotificationCell *)[self superview]).delegate updateListItem:_listItem withHeight:_notificationView.frame.size.height+8];
				CGRect origFrame = [self superview].frame;
				origFrame.size.height = self.frame.size.height+8;
				[self superview].frame = origFrame;
			}

			// dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			// 	[self updateHeight];
			// });
			// if ([[self superview] isKindOfClass:NSClassFromString(@"SBLockScreenNotificationCell")]) {
			// 	[((SBLockScreenNotificationCell *)[self superview]).delegate updateListItem:_listItem withHeight:_notificationView.frame.size.height];
			// 	CGRect origFrame = [self superview].frame;
			// 	origFrame.size.height = self.frame.size.height+8;
			// 	[self superview].frame = origFrame;
			// }
		}

		// if ([[self superview] isKindOfClass:NSClassFromString(@"SBLockScreenNotificationCell")]) {
		// 	[((SBLockScreenNotificationCell *)[self superview]).delegate updateListItem:_listItem withHeight:_notificationView.frame.size.height+8];
		// 	CGRect origFrame = [self superview].frame;
		// 	origFrame.size.height = self.frame.size.height+8;
		// 	[self superview].frame = origFrame;
		// }

		// [self layoutSubviews];
		// if (self.cell) {
		// 	NSMutableDictionary *_cachedHeights = (NSMutableDictionary *)[self.cell.delegate valueForKey:@"_heightForListItemCache"];
		// 	[_cachedHeights setObject:[NSNumber numberWithFloat:self.frame.size.height + 8] forKey:_listItem];
		// 	self.cell.frame = CGRectMake(self.cell.frame.origin.x,self.cell.frame.origin.y,self.cell.frame.size.width,self.frame.size.height + 8);
		// 	[self.cell.delegate _updateTotalContentHeight];
		// }
	}
}

- (void)setListItem:(SBAwayBulletinListItem *)item withActions:(NSArray *)actions {

	// Reset View

	_appLabel.text = nil;
	_thumbnailView.image = nil;
	_primaryLabel.text = nil;
	_primarySubtitleLabel.text = nil;
	_secondaryLabel.text = nil;
	_hintLabel.text = nil;
	_hintLabelText = nil;
	_hintIsShowing = NO;
	_iconView.image = nil;
	_dateLabel.text = nil;
	_contentViewPaddingConstraint.constant = 8.0;
	_hintLabelTopConstraint.constant = 0;
	_actionViewWidthConstraint.constant = 0;
	self.revealGesture.enabled = YES;
	for (NSLayoutConstraint *constraint in _rightSideConstraints) {
		constraint.constant = 0;
	}
	for (UIView *view in [_actionsView subviews]) {
		[view removeFromSuperview];
	}
	[_backdropView removeFromSuperview];
	_backdropView = nil;
	[_actionsClippingBackgroundView removeFromSuperview];
	_actionsClippingBackgroundView = nil;

	_notificationViewLeftConstraint.constant = 8;

	_listItem = item;
	if (item) {
		_backdropView = [[NSClassFromString(@"SBWallpaperEffectView") alloc] initWithWallpaperVariant:0];
		[_backdropView setStyle:32];
		_backdropView.translatesAutoresizingMaskIntoConstraints = NO;
		[_notificationView addSubview:_backdropView];
		[_notificationView sendSubviewToBack:_backdropView];

		[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_backdropView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_notificationView
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0]];

		[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_backdropView
	                                                      attribute:NSLayoutAttributeBottom
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:_notificationView
	                                                      attribute:NSLayoutAttributeBottom
	                                                     multiplier:1
	                                                       constant:0]];

		[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_backdropView
	                                                      attribute:NSLayoutAttributeRight
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:_notificationView
	                                                      attribute:NSLayoutAttributeRight
	                                                     multiplier:1
	                                                       constant:0]];
		[_notificationView addConstraint:[NSLayoutConstraint constraintWithItem:_backdropView
	                                                      attribute:NSLayoutAttributeLeft
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:_notificationView
	                                                      attribute:NSLayoutAttributeLeft
	                                                     multiplier:1
	                                                       constant:0]];

		_actionsClippingBackgroundView = [[NSClassFromString(@"SBWallpaperEffectView") alloc] initWithWallpaperVariant:0];
		[_actionsClippingBackgroundView setStyle:32];
		[_actionsClippingBackgroundView setUserInteractionEnabled:NO];
		_actionsClippingBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
		[_actionsClippingView addSubview:_actionsClippingBackgroundView];

		[_actionsClippingView addConstraint:[NSLayoutConstraint constraintWithItem:_actionsClippingBackgroundView
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsClippingView
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1
                                                       constant:0]];

		[_actionsClippingView addConstraint:[NSLayoutConstraint constraintWithItem:_actionsClippingBackgroundView
	                                                      attribute:NSLayoutAttributeCenterY
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:_actionsClippingView
	                                                      attribute:NSLayoutAttributeCenterY
	                                                     multiplier:1
	                                                       constant:0]];

		[_actionsClippingView addConstraint:[NSLayoutConstraint constraintWithItem:_actionsClippingBackgroundView
	                                                      attribute:NSLayoutAttributeWidth
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:_actionsClippingView
	                                                      attribute:NSLayoutAttributeWidth
	                                                     multiplier:1
	                                                       constant:0]];

		[_actionsClippingView addConstraint:[NSLayoutConstraint constraintWithItem:_actionsClippingBackgroundView
	                                                      attribute:NSLayoutAttributeHeight
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:_actionsClippingView
	                                                      attribute:NSLayoutAttributeHeight
	                                                     multiplier:1
	                                                       constant:0]];






		BOOL appNameAvailable = NO;
		NSString *appLabel = SBSCopyLocalizedApplicationNameForDisplayIdentifier([_listItem activeBulletin].sectionID);
		_iconView.image = [item iconImage];
	  	if (!appLabel) {
	  		if ([[_listItem activeBulletin].sectionID isEqualToString:@"com.apple.DuetHeuristic-BM"]) {
	  			appLabel = [NSString stringWithFormat:@"Battery"];
	  		}
	  	}
	  	if (appLabel) {
	  		appNameAvailable = YES;
	  		_appLabel.text = [appLabel uppercaseString];
	  	} else {
	  		if ([_listItem activeBulletin].content.title && [_listItem activeBulletin].content.message) {
	  			_appLabel.text = [[_listItem activeBulletin].content.title uppercaseString];
	  		}
	  	}
	  	if ([_listItem attachmentImageForKey:@"SBAwayBulletinListAttachmentKey"]) {
	  		_thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
	  		_thumbnailView.image = [_listItem attachmentImageForKey:@"SBAwayBulletinListAttachmentKey"];
	  		_contentViewPaddingConstraint.constant = 15.0;
			for (NSLayoutConstraint *constraint in _rightSideConstraints) {
				constraint.constant = -15.0;
			}
	  	}
	  	if ([_listItem activeBulletin].content.title && appNameAvailable) {
	  		_primaryLabel.text = [_listItem activeBulletin].content.title;
	  	}
	  	if ([_listItem activeBulletin].content.subtitle) {
	  		_primarySubtitleLabel.text = [_listItem activeBulletin].content.subtitle;
	  	}
	  	if ([_listItem activeBulletin].content.message) {
	  		_secondaryLabel.text = [_listItem activeBulletin].content.message;
	  	}
	  	if ([_listItem activeBulletin].fullUnlockActionLabel) {
	  		_hintLabelText = [_listItem activeBulletin].fullUnlockActionLabel;
	  	}

	  	_actions = actions;

	  	if (actions) {
	  		NSArray *buttons = actions;
	  		if ([buttons count] > 0) {

	  			CGFloat multiplier = (CGFloat)1.0/((CGFloat)[buttons count]);

	  			NTXNotificationListCellActionButton *prevModernButton;
	  			_actionViewWidthConstraint.constant = (90*[buttons count]) + ([buttons count] -1);
	  			for (int x = 0; x < [buttons count]; x++) {
	  				NTXNotificationListCellActionButton *modernButton;
	  				modernButton = [[NTXNotificationListCellActionButton alloc] initWithFrame:CGRectMake(0,0,0,0)];
	  				[modernButton addTarget:self  action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	  				modernButton.translatesAutoresizingMaskIntoConstraints = NO;
	  				[modernButton setNotificationAction:[buttons objectAtIndex:x]];
	  				[_actionsView addSubview:modernButton];

	  				[_actionsView addConstraint:[NSLayoutConstraint constraintWithItem:modernButton
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsView
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0]];

	  				[_actionsView addConstraint:[NSLayoutConstraint constraintWithItem:modernButton
                                                      attribute:NSLayoutAttributeBottom
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsView
                                                      attribute:NSLayoutAttributeBottom
                                                     multiplier:1
                                                       constant:0]];
	  				if (prevModernButton) {
	  					[_actionsView addConstraint:[NSLayoutConstraint constraintWithItem:modernButton
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:prevModernButton
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:0]];

	  				} else {
	  					[_actionsView addConstraint:[NSLayoutConstraint constraintWithItem:modernButton
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:0]];
	  				}

	  				if (!(x == [buttons count] - 1)) {
	  					[_actionsView addConstraint:[NSLayoutConstraint constraintWithItem:modernButton
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:_actionsView
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:multiplier
                                                       constant:1]];
	  					UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
	  					divider.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.35];
	  					divider.translatesAutoresizingMaskIntoConstraints = NO;
	  					[_actionsView addSubview:divider];
	  					[_actionsView addConstraint:[NSLayoutConstraint constraintWithItem:divider
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:1]];
	  					[_actionsView addConstraint:[NSLayoutConstraint constraintWithItem:divider
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:modernButton
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1
                                                       constant:0]];
	  					[_actionsView addConstraint:[NSLayoutConstraint constraintWithItem:divider
                                                      attribute:NSLayoutAttributeRight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:modernButton
                                                      attribute:NSLayoutAttributeRight
                                                     multiplier:1
                                                       constant:0]];

	  					UIView *dividerVibrantView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
	  					dividerVibrantView.translatesAutoresizingMaskIntoConstraints = NO;
	  					[divider addSubview:dividerVibrantView];
	  					NTXApplyVibrantStyling([[NTXVibrantSecondaryStyling alloc] init],dividerVibrantView);
	  					[divider addConstraint:[NSLayoutConstraint constraintWithItem:dividerVibrantView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:divider
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1
                                                       constant:0]];
	  					[divider addConstraint:[NSLayoutConstraint constraintWithItem:dividerVibrantView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:divider
                                                      attribute:NSLayoutAttributeHeight
                                                     multiplier:1
                                                       constant:0]];
	  					[divider addConstraint:[NSLayoutConstraint constraintWithItem:dividerVibrantView
                                                      attribute:NSLayoutAttributeCenterX
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:divider
                                                      attribute:NSLayoutAttributeCenterX
                                                     multiplier:1
                                                       constant:0]];
	  					[divider addConstraint:[NSLayoutConstraint constraintWithItem:dividerVibrantView
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:divider
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1
                                                       constant:0]];
	  				} else {
		  				[_actionsView addConstraint:[NSLayoutConstraint constraintWithItem:modernButton
	                                                      attribute:NSLayoutAttributeWidth
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:_actionsView
	                                                      attribute:NSLayoutAttributeWidth
	                                                     multiplier:multiplier
	                                                       constant:0]];
		  			}
	  				prevModernButton = modernButton;
	  				[modernButton setNeedsLayout];
	  			}
	  			// _actionViewWidthConstraint.constant = (90*[buttons count]) + ([buttons count] -1);

	  			[_actionsClippingView setNeedsLayout];

	  		}
	  	}

	  	[_headerView setNeedsLayout];
	  	[_contentView setNeedsLayout];
	  	[_actionsView setNeedsLayout];
	  	[_headerView layoutIfNeeded];
	  	[_contentView layoutIfNeeded];
	  	[_actionsView layoutIfNeeded];
	  	[_notificationView layoutIfNeeded];
	  	[self layoutIfNeeded];
	  	// [self layoutSubviews];
	  	[self updateHeight];
	  	[_actionsClippingView sendSubviewToBack:_actionsClippingBackgroundView];
	}
}

-(void)actionButtonPressed:(NTXNotificationListCellActionButton *)button {

	[((NSBlock *)[button.notificationAction valueForKey:@"_handler"]) invoke];
	if ([self superview]) {

		// SBLockScreenNotificationListView *delegate = ((SBLockScreenNotificationCell *)[self superview]).delegate;
		// [delegate _handleAction:button.notificationAction.action forBulletin:[_listItem activeBulletin]];
		// NSLog(@"Action: %@ \n Bulletin: %@", button.notificationAction.action, [_listItem activeBulletin]);
		_notificationViewLeftConstraint.constant = 8;
    	[_notificationView setNeedsUpdateConstraints];
	    [_actionsClippingView setNeedsUpdateConstraints];
	    [_actionsView setNeedsUpdateConstraints];

	    [UIView animateWithDuration:0.2f animations:^{
	   		[_notificationView layoutIfNeeded];
	   		[_actionsClippingView layoutIfNeeded];
	    	[_actionsView layoutIfNeeded];
		}];
	}
}

- (void)setAppName:(NSString *)text {
	_appLabel.text = text;
	[_appLabel sizeToFit];
	[_headerView setNeedsLayout];
	// [self updateHeight];
}

- (void)setIconImage:(UIImage *)image {
	_iconView.image = image;
	// [self layoutSubviews];
	// [self updateHeight];
}

- (BOOL)hasAddedConstraints {
	return _addedConstraints;
}

- (void)updateDate:(NCRelativeDateLabel *)label {

	_dateLabel.text = label.text;
	[_dateLabel sizeToFit];
	[_headerView setNeedsLayout];
	// [self layoutSubviews];
	// [self updateHeight];
}

- (void)setPrimaryText:(NSString *)text {
	_primaryLabel.text = text;
	[_primaryLabel sizeToFit];
	[_contentView setNeedsLayout];
	// [self layoutSubviews];
	[self updateHeight];
}

- (void)setPrimarySubtitleText:(NSString *)text {
	_primarySubtitleLabel.text = text;
	[_primarySubtitleLabel sizeToFit];
	// [_contentView setNeedsLayout];
	// [self layoutSubviews];
	[self updateHeight];
}


- (void)setSecondaryText:(NSString *)text {
	_secondaryLabel.text = text;
	[_secondaryLabel sizeToFit];
	// [_contentView setNeedsLayout];
	// [self layoutSubviews];
	[self updateHeight];
}

- (void)setHintText:(NSString *)text {
	if (text) {
		if ([text length] > 0) {
			_hintLabelTopConstraint.constant = 2;
			_hintLabel.text = [NSString stringWithFormat:@"%@%@",[[text substringToIndex:1] uppercaseString],[text substringFromIndex:1]];
			[_hintLabel sizeToFit];
			// [_contentView setNeedsLayout];
			// [self layoutSubviews];
			_hintIsShowing = YES;
			[self updateHeight];
			return;
		}
	}
	_hintLabelTopConstraint.constant = 0;
	_hintLabel.text = nil;
	[_hintLabel sizeToFit];
	// [_contentView setNeedsLayout];
	// [self layoutSubviews];
	_hintIsShowing = NO;
	[self updateHeight];
}

- (void)showHintLabel:(BOOL)shouldShow {

	if (shouldShow && [NSClassFromString(@"SBLockScreenNotificationCell") wantsUnlockActionText]) {
		if (!_hintIsShowing) {
			[self setHintText:_hintLabelText];
		}
	} else {
		if (_hintIsShowing) {
			[self setHintText:nil];
		}
	}
}

- (void)setThumbnailImage:(UIImage *)image {
	// image = [image imageByScalingAndCroppingForSize:CGSizeMake(68,68)];
	_thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
	_thumbnailView.image = image;
	if (image) {
		_contentViewPaddingConstraint.constant = 15.0;
		for (NSLayoutConstraint *constraint in _rightSideConstraints) {
			constraint.constant = -15.0;
		}
	}
	// [_contentView setNeedsLayout];
	// [self layoutSubviews];
	[self updateHeight];
}

- (SBAwayBulletinListItem *)listItem {
	return _listItem;
}


- (CGFloat)alphaForPercentRevealed:(CGFloat)percent {
	CGFloat arg1;
	CGFloat arg2;
	CGFloat arg3;

	arg1 = fmin((CGFloat)1.0,percent);
	arg3 = (CGFloat)_actionViewWidthConstraint.constant;
	arg2 = (CGFloat)0.0;
	if ((arg1 * arg3) > 30.0) {
		arg2 = ((arg1 * arg3) + -30.0) / (arg3 + -30.0);
	}
	return arg2;
}

// - (void)updateC

+ (UIFont *)primaryLabelFont {
	UIFontDescriptor *descriptor = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline] fontDescriptorWithFamily:@".SFUIText"];
	descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
	UIFont *font = [UIFont fontWithDescriptor:descriptor size:0];
	return [font fontWithSize:font.pointSize - 2];
}

+ (UIFont *)secondaryLabelFont {
	UIFontDescriptor *descriptor = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline] fontDescriptorWithFamily:@".SFUIText"];
	UIFont *font = [UIFont fontWithDescriptor:descriptor size:0];
	return [font fontWithSize:font.pointSize - 2];

}

+ (UIFont *)hintLabelFont {
	UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleCaption1];
	UIFont *font = [UIFont fontWithDescriptor:descriptor size:0];
	return [UIFont fontWithName:@".SFUIText" size:font.pointSize-1 traits:[font traits]];
// 	return [UIFont fontWithName:@".SFUIText" size:font.pointSize-1*[UIScreen mainScreen].scale) traits:[font traits]];
}

+ (UIFont *)appLabelFont {
	UIFontDescriptor *descriptor = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote] fontDescriptorWithFamily:@".SFUIText"];
	descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitCondensed];
	UIFont *font = [UIFont fontWithDescriptor:descriptor size:0];
	return [UIFont fontWithName:@".SFUIText" size:font.pointSize-1 traits:[font traits]];
}

+ (UIFont *)dateLabelFont {
	UIFontDescriptor *descriptor = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote] fontDescriptorWithFamily:@".SFUIText"];
	descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitCondensed];
	UIFont *font = [UIFont fontWithDescriptor:descriptor size:0];
	return [UIFont fontWithName:@".SFUIText" size:font.pointSize-1 traits:[font traits]];
}

+ (UIFont *)primarySubtitleLabelFont {
  	return [self primaryLabelFont];
}
@end