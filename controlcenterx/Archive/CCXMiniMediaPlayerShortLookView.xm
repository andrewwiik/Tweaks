#import "CCXMiniMediaPlayerShortLookView.h"
#import "CCXMiniMediaPlayerShortLookViewController.h"
%subclass CCXMiniMediaPlayerShortLookView : MPUControlCenterMediaControlsView
- (CGSize)intrinsicContentSize {
	CGSize orig = %orig;
	// if ([self delegate].fakeContentSize) {
	// 	CGFloat correctHeight = 0;
	// 	correctHeight += [self artworkView].frame.origin.x*2;
	// 	correctHeight += ((UIView *)[self valueForKey:@"_timeView"]).frame.origin.y;
	// 	correctHeight += ((UIView *)[self valueForKey:@"_timeView"]).frame.size.height + 2;
	// 	orig.height = correctHeight;
	// 	// NSLog(@"%@",[self artworkView]);
	// }


//   orig.height += 24.5;

// CGFloat height = orig.height;
// // CGFloat width = orig.width;

// orig.width = height;
  UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
  if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
     orig.height += 24.5;
  } else {
    orig.height = [[UIScreen mainScreen] bounds].size.height - 32*2;
  }
	return orig;
} // albumLabel is lowest in view;

- (void)_layoutPhoneRegularStyle {
	%orig;
	if (self.pickedRouteHeaderView) {
		[self.pickedRouteHeaderView layoutSubviews];
	}
// 	if ([self valueForKey:@"_routingContainerView"])
// 		[(UIView*)[self valueForKey:@"_routingContainerView"] setHidden:YES];
// 	if ([self valueForKey:@"_routingView"])
// 		[(UIView*)[self valueForKey:@"_routingView"] setHidden:YES];
// 	if ([self valueForKey:@"_pickedRouteHeaderView"])
// 		[(UIView*)[self valueForKey:@"_pickedRouteHeaderView"] setHidden:YES];
	if ([self valueForKey:@"_volumeView"])
		[(UIView*)[self valueForKey:@"_volumeView"] setHidden:YES];
}

- (void)layoutSubviews {
	%orig;
	if (self.pickedRouteHeaderView) {
		[self.pickedRouteHeaderView layoutSubviews];
	}
	if ([self superview]) {
		if (self.frame.origin.y != [self artworkView].frame.origin.x) {
			CGRect newFrame = self.frame;
      newFrame.size.height = [self superview].frame.size.height;
			newFrame.origin.y = [self artworkView].frame.origin.x;
			newFrame.size.height = newFrame.size.height-newFrame.origin.y;
			self.frame = newFrame;

			
		}
	}

	// if ([self valueForKey:@"_routingContainerView"])
	// 	[(UIView*)[self valueForKey:@"_routingContainerView"] setHidden:YES];
	// if ([self valueForKey:@"_routingView"])
	// 	[(UIView*)[self valueForKey:@"_routingView"] setHidden:YES];
	// if ([self valueForKey:@"_pickedRouteHeaderView"])
	// 	[(UIView*)[self valueForKey:@"_pickedRouteHeaderView"] setHidden:YES];
	if ([self valueForKey:@"_volumeView"])
		[(UIView*)[self valueForKey:@"_volumeView"] setHidden:YES];

	// MPUControlCenterMetadataView *firstLabel = (MPUControlCenterMetadataView *)[self valueForKey:@"_titleLabel"];
	// MPUControlCenterMetadataView *middleLabel = (MPUControlCenterMetadataView *)[self valueForKey:@"_artistLabel"];
	// MPUControlCenterMetadataView *lastLabel = (MPUControlCenterMetadataView *)[self valueForKey:@"_albumLabel"];
	// UIView *controls = (UIView *)[self valueForKey:@"_transportControls"];
	// [controls removeAllConstraints];
	// [firstLabel removeAllConstraints];
	// [middleLabel removeAllConstraints];
	// [lastLabel removeAllConstraints];
	// lastLabel.translatesAutoresizingMaskIntoConstraints = NO;
	// firstLabel.translatesAutoresizingMaskIntoConstraints = NO;
	// middleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	// controls.translatesAutoresizingMaskIntoConstraints = NO;
	// [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLabel
 //                                                      attribute:NSLayoutAttributeTop
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:[self artworkView]
 //                                                      attribute:NSLayoutAttributeTop
 //                                                     multiplier:1
 //                                                       constant:0]];
	// [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLabel
 //                                                      attribute:NSLayoutAttributeLeft
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:[self artworkView]
 //                                                      attribute:NSLayoutAttributeRight
 //                                                     multiplier:1
 //                                                       constant:[self artworkView].frame.origin.x]];
	// [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLabel
 //                                                      attribute:NSLayoutAttributeRight
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:self
 //                                                      attribute:NSLayoutAttributeRight
 //                                                     multiplier:1
 //                                                       constant:-1*[self artworkView].frame.origin.x]];
	// [self addConstraint:[NSLayoutConstraint constraintWithItem:firstLabel
 //                                                      attribute:NSLayoutAttributeHeight
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:nil
 //                                                      attribute:NSLayoutAttributeNotAnAttribute
 //                                                     multiplier:1
 //                                                       constant:[firstLabel label].frame.size.height]];

	// [self addConstraint:[NSLayoutConstraint constraintWithItem:middleLabel
 //                                                      attribute:NSLayoutAttributeTop
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:firstLabel
 //                                                      attribute:NSLayoutAttributeBottom
 //                                                     multiplier:1
 //                                                       constant:0]];
	// [self addConstraint:[NSLayoutConstraint constraintWithItem:middleLabel
 //                                                      attribute:NSLayoutAttributeLeft
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:[self artworkView]
 //                                                      attribute:NSLayoutAttributeRight
 //                                                     multiplier:1
 //                                                       constant:[self artworkView].frame.origin.x]];
	// [self addConstraint:[NSLayoutConstraint constraintWithItem:middleLabel
 //                                                      attribute:NSLayoutAttributeRight
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:self
 //                                                      attribute:NSLayoutAttributeRight
 //                                                     multiplier:1
 //                                                       constant:-1*[self artworkView].frame.origin.x]];
	// [self addConstraint:[NSLayoutConstraint constraintWithItem:middleLabel
 //                                                      attribute:NSLayoutAttributeHeight
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:nil
 //                                                      attribute:NSLayoutAttributeNotAnAttribute
 //                                                     multiplier:1
 //                                                       constant:[middleLabel label].frame.size.height]];

	// [self addConstraint:[NSLayoutConstraint constraintWithItem:lastLabel
 //                                                      attribute:NSLayoutAttributeTop
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:middleLabel
 //                                                      attribute:NSLayoutAttributeBottom
 //                                                     multiplier:1
 //                                                       constant:0]];
	// [self addConstraint:[NSLayoutConstraint constraintWithItem:lastLabel
 //                                                      attribute:NSLayoutAttributeLeft
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:[self artworkView]
 //                                                      attribute:NSLayoutAttributeRight
 //                                                     multiplier:1
 //                                                       constant:[self artworkView].frame.origin.x]];
	// [self addConstraint:[NSLayoutConstraint constraintWithItem:lastLabel
 //                                                      attribute:NSLayoutAttributeRight
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:self
 //                                                      attribute:NSLayoutAttributeRight
 //                                                     multiplier:1
 //                                                       constant:-1*[self artworkView].frame.origin.x]];
	// [self addConstraint:[NSLayoutConstraint constraintWithItem:lastLabel
 //                                                      attribute:NSLayoutAttributeHeight
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:nil
 //                                                      attribute:NSLayoutAttributeNotAnAttribute
 //                                                     multiplier:1
 //                                                       constant:[lastLabel label].frame.size.height]];


	// 		NSLayoutConstraint *constant1 = [NSLayoutConstraint constraintWithItem:controls
 //                                                      attribute:NSLayoutAttributeTop
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:lastLabel
 //                                                      attribute:NSLayoutAttributeBottom
 //                                                     multiplier:1
 //                                                       constant:0];

	// 		NSLayoutConstraint *constant2 = [NSLayoutConstraint constraintWithItem:controls
 //                                                      attribute:NSLayoutAttributeLeft
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:lastLabel
 //                                                      attribute:NSLayoutAttributeLeft
 //                                                     multiplier:1
 //                                                       constant:0];
	// 		NSLayoutConstraint *constant3 = [NSLayoutConstraint constraintWithItem:controls
 //                                                      attribute:NSLayoutAttributeRight
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:lastLabel
 //                                                      attribute:NSLayoutAttributeRight
 //                                                     multiplier:1
 //                                                       constant:0];
	// 		NSLayoutConstraint *constant4 = [NSLayoutConstraint constraintWithItem:controls
 //                                                      attribute:NSLayoutAttributeBottom
 //                                                      relatedBy:NSLayoutRelationEqual
 //                                                         toItem:[self artworkView]
 //                                                      attribute:NSLayoutAttributeBottom
 //                                                     multiplier:1
 //                                                       constant:0];
	// 		constant1.priority = 1000;
	// 		constant2.priority = 1000;
	// 		constant3.priority = 1000;
	// 		constant4.priority = 1000;
	// 		[self addConstraint:constant1];
	// 		[self addConstraint:constant2];
	// 		[self addConstraint:constant3];
	// 		[self addConstraint:constant4];

			// [self setNeedsLayout];
			// [self updateConstraints];
}

// - (void)_reloadNowPlayingInfoLabels {
// 	%orig;
// 	[self layoutSubviews];
// }

- (void)_layoutPhoneRegularStyleMediaControlsUsingBounds:(CGRect)bounds {
  //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
   // %orig(CGRectMake(bounds.origin.x,bounds.origin.y,bounds.size.width*2,bounds.size.height));
  %orig;
  if (self.pickedRouteHeaderView) {
		[self.pickedRouteHeaderView layoutSubviews];
	}
    // if (self.volumeController) {
    //  self.volumeController.view.frame = CGRectMake(0,0,((UIView*)[self valueForKey:@"_volumeView"]).frame.size.width,((UIView*)[self valueForKey:@"_volumeView"]).frame.size.height);
    // }
  //} else %orig;
}
-(void)setPickedRoute:(id)arg1 {
	%orig;
	if (self.pickedRouteHeaderView) {
		[self.pickedRouteHeaderView layoutSubviews];
	}
}
%end