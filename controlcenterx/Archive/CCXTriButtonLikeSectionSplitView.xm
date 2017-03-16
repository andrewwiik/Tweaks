#import "CCXTriButtonLikeSectionSplitView.h"

%subclass CCXTriButtonLikeSectionSplitView : CCUIButtonLikeSectionSplitView
%property (nonatomic, retain) CCUIControlCenterPushButton *middleSection;
%property (nonatomic, retain) CCUIControlCenterPushButton *secondMiddleSection;

- (id)init {
	[[NSClassFromString(@"__NSBundleTables") bundleTables] setBundle:[[NSClassFromString(@"__NSBundleTables") bundleTables] bundleForClass:[self superclass]] forClass:[self class]];
	return %orig;
}
- (CGRect)_frameForSectionSlot:(int)slot {
	if (self.mode == 3) {
		if (slot == 0) {
			CGRect frame = CGRectMake(0,0,self.frame.size.height <= 60 ? self.frame.size.height : 60,self.frame.size.height);
			return frame;
		} else if (slot == 1) {
			CGRect frame = CGRectMake((self.frame.size.height < 60 ? self.frame.size.height : 60) + 1,0,self.frame.size.width-2-(2*(self.frame.size.height <= 60 ? self.frame.size.height : 60)),self.frame.size.height);
			return frame;
		} else {
			CGRect frame = CGRectMake(self.frame.size.width-(self.frame.size.height < 60 ? self.frame.size.height : 60),0,self.frame.size.height <= 60 ? self.frame.size.height : 60,self.frame.size.height);
			return frame;
		}
	} else if (self.mode == 4) {
		CGRect frame = CGRectMake((self.frame.size.width/4)*slot+1,0,self.frame.size.width/self.mode-1, self.frame.size.height);
		return frame;
	}
	else return %orig;
}

- (CCUIControlCenterPushButton *)_viewForSectionSlot:(int)slot {
	if (self.mode == 3) {
		if (slot == 0) {
			return self.leftSection;
		} else if (slot == 1) {
			return self.middleSection;
		} else {
			return self.rightSection;
		}
	} else if (self.mode == 4) {
		if (slot == 0) {
			return self.leftSection;
		} else if (slot == 1) {
			return self.middleSection;
		} else if (slot == 2) {
			return self.secondMiddleSection;
		} else {
			return self.rightSection;
		}
	} else return %orig;
}

- (void)setLeftSection:(CCUIControlCenterPushButton *)section {
	%orig;
	if (self.mode == 3 || self.mode == 4) {
		NSMutableArray *glyphViews = [NSMutableArray new];
		[glyphViews addObject:[section valueForKey:@"_alteredStateGlyphImageView"]];
		[glyphViews addObject:[section valueForKey:@"_glyphImageView"]];
		for (UIImageView *glyphView in glyphViews) {
			glyphView.translatesAutoresizingMaskIntoConstraints = NO;
			[section addConstraint:[NSLayoutConstraint constraintWithItem:glyphView
	                                                      attribute:NSLayoutAttributeCenterX
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:section
	                                                      attribute:NSLayoutAttributeCenterX
	                                                     multiplier:1
	                                                       constant:0]];

			[section addConstraint:[NSLayoutConstraint constraintWithItem:glyphView
	                                                      attribute:NSLayoutAttributeCenterY
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:section
	                                                      attribute:NSLayoutAttributeCenterY
	                                                     multiplier:1
	                                                       constant:0]];
		}
		[(UILabel *)[section valueForKey:@"_alteredStateLabel"] setHidden:YES];
		[(UILabel *)[section valueForKey:@"_label"] setHidden:YES];
	}
}

- (void)setRightSection:(CCUIControlCenterPushButton *)section {
	%orig;
	if (self.mode == 3 || self.mode == 4) {

		NSMutableArray *glyphViews = [NSMutableArray new];
		[glyphViews addObject:[section valueForKey:@"_alteredStateGlyphImageView"]];
		[glyphViews addObject:[section valueForKey:@"_glyphImageView"]];
		for (UIImageView *glyphView in glyphViews) {
			glyphView.translatesAutoresizingMaskIntoConstraints = NO;
			[section addConstraint:[NSLayoutConstraint constraintWithItem:glyphView
	                                                      attribute:NSLayoutAttributeCenterX
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:section
	                                                      attribute:NSLayoutAttributeCenterX
	                                                     multiplier:1
	                                                       constant:0]];

			[section addConstraint:[NSLayoutConstraint constraintWithItem:glyphView
	                                                      attribute:NSLayoutAttributeCenterY
	                                                      relatedBy:NSLayoutRelationEqual
	                                                         toItem:section
	                                                      attribute:NSLayoutAttributeCenterY
	                                                     multiplier:1
	                                                       constant:0]];
		}
		[(UILabel *)[section valueForKey:@"_alteredStateLabel"] setHidden:YES];
		[(UILabel *)[section valueForKey:@"_label"] setHidden:YES];
	}
}

- (void)layoutSubviews {
	%orig;
	if (self.middleSection) {
		if (self.middleSection.superview != self) {
			[self.middleSection removeFromSuperview];
			[self addSubview:self.middleSection];
		}
	}
	if (self.secondMiddleSection) {
		if (self.secondMiddleSection.superview != self) {
			[self.secondMiddleSection removeFromSuperview];
			[self addSubview:self.secondMiddleSection];
		}
	}
	if (self.mode == 4) {
		[self fixGlyphs];
	}
	if (self.mode == 3 || self.mode == 4) {
		[self _updateButtonsCorners];
		[self _updateLabelParameters];
	}
	if (self.mode == 3) {
		[self _viewForSectionSlot:0].frame = [self _frameForSectionSlot:0];
		[self _viewForSectionSlot:1].frame = [self _frameForSectionSlot:1];
		[self _viewForSectionSlot:2].frame = [self _frameForSectionSlot:2];
	} else if (self.mode == 4) {
		[self _viewForSectionSlot:0].frame = [self _frameForSectionSlot:0];
		[self _viewForSectionSlot:1].frame = [self _frameForSectionSlot:1];
		[self _viewForSectionSlot:2].frame = [self _frameForSectionSlot:2];
		[self _viewForSectionSlot:3].frame = [self _frameForSectionSlot:3];
	}
}

%new
- (void)addedMiddleSection {
	[self.middleSection removeFromSuperview];
	[self addSubview:self.middleSection];
	self.mode = 3;
	[self _updateButtonsCorners];
	[self _updateLabelParameters];
}

-(void)_updateButtonsCorners {
	%orig;
	if (self.mode == 3) {
		//((UIView *)[[self _viewForSectionSlot:0] valueForKey:@"_backgroundFlatColorView"]).layer.cornerRadius = 0;
		((UIView *)[[self _viewForSectionSlot:1] valueForKey:@"_backgroundFlatColorView"]).layer.cornerRadius = 0;
		//((UIView *)[[self _viewForSectionSlot:2] valueForKey:@"_backgroundFlatColorView"]).layer.cornerRadius = 0;
		[self _viewForSectionSlot:0].roundCorners = 5;
		[self _viewForSectionSlot:1].roundCorners = 0;
		[self _viewForSectionSlot:2].roundCorners = 10;
	} else if (self.mode == 4) {
		//((UIView *)[[self _viewForSectionSlot:0] valueForKey:@"_backgroundFlatColorView"]).layer.cornerRadius = 0;
		((UIView *)[[self _viewForSectionSlot:1] valueForKey:@"_backgroundFlatColorView"]).layer.cornerRadius = 0;
		((UIView *)[[self _viewForSectionSlot:2] valueForKey:@"_backgroundFlatColorView"]).layer.cornerRadius = 0;
		//((UIView *)[[self _viewForSectionSlot:3] valueForKey:@"_backgroundFlatColorView"]).layer.cornerRadius = 0;
		[self _viewForSectionSlot:0].roundCorners = 5;
		[self _viewForSectionSlot:1].roundCorners = 0;
		[self _viewForSectionSlot:2].roundCorners = 0;
		[self _viewForSectionSlot:3].roundCorners = 10;

	}
}
-(void)_updateLabelParameters {
	%orig;
	if (self.mode == 3) {
		[self _viewForSectionSlot:2].text = nil;
		[self _viewForSectionSlot:0].text = nil;
	} else if (self.mode == 4) {
		[self _viewForSectionSlot:0].text = nil;
		[self _viewForSectionSlot:1].text = nil;
		[self _viewForSectionSlot:2].text = nil;
		[self _viewForSectionSlot:3].text = nil;
	}
}
- (NSUInteger)mode {
	if (self.secondMiddleSection) {
		return 4;
	} else return 3;
}
%new
- (void)fixGlyphs {
	for (CCUIControlCenterButton *section in [self subviews]) {
			section.translatesAutoresizingMaskIntoConstraints = YES;
			NSMutableArray *glyphViews = [NSMutableArray new];
			[glyphViews addObject:[section valueForKey:@"_alteredStateGlyphImageView"]];
			[glyphViews addObject:[section valueForKey:@"_glyphImageView"]];
			for (UIImageView *glyphView in glyphViews) {
				[glyphView removeAllConstraints];
				glyphView.translatesAutoresizingMaskIntoConstraints = NO;
				[section addConstraint:[NSLayoutConstraint constraintWithItem:glyphView
		                                                      attribute:NSLayoutAttributeCenterY
		                                                      relatedBy:NSLayoutRelationEqual
		                                                         toItem:section
		                                                      attribute:NSLayoutAttributeCenterY
		                                                     multiplier:1
		                                                       constant:0]];

				[section addConstraint:[NSLayoutConstraint constraintWithItem:glyphView
		                                                      attribute:NSLayoutAttributeCenterX
		                                                      relatedBy:NSLayoutRelationEqual
		                                                         toItem:section
		                                                      attribute:NSLayoutAttributeCenterX
		                                                     multiplier:1
		                                                       constant:0]];

			}
			//[(UILabel *)[section valueForKey:@"_alteredStateLabel"] setHidden:YES];
			[(UILabel *)[section valueForKey:@"_alteredStateLabel"] setHidden:YES];
			[(UILabel *)[section valueForKey:@"_label"] setHidden:YES];
			[section setNeedsLayout];
			// section.translatesAutoresizingMaskIntoConstraints = YES;
			// [glyphView1 setNeedsLayout];
			// [glyphView2 setNeedsLayout];
			//[section updateConstraints];
		}
	[self _updateLabelParameters];
    [self _updateButtonsCorners];
    [self _viewForSectionSlot:0].frame = [self _frameForSectionSlot:0];
	[self _viewForSectionSlot:1].frame = [self _frameForSectionSlot:1];
	[self _viewForSectionSlot:2].frame = [self _frameForSectionSlot:2];
	[self _viewForSectionSlot:3].frame = [self _frameForSectionSlot:3];
    [self setNeedsLayout];
}
- (void)setMode:(NSUInteger)mode {
	if (self.secondMiddleSection) {
		// for (CCUIControlCenterButton *section in [self subviews]) {
		// 	NSMutableArray *glyphViews = [NSMutableArray new];
		// 	[glyphViews addObject:[section valueForKey:@"_alteredStateGlyphImageView"]];
		// 	[glyphViews addObject:[section valueForKey:@"_glyphImageView"]];
		// 	for (UIImageView *glyphView in glyphViews) {
		// 		[glyphView removeAllConstraints];
		// 		glyphView.translatesAutoresizingMaskIntoConstraints = NO;
		// 		[section addConstraint:[NSLayoutConstraint constraintWithItem:glyphView
		//                                                       attribute:NSLayoutAttributeCenterX
		//                                                       relatedBy:NSLayoutRelationEqual
		//                                                          toItem:section
		//                                                       attribute:NSLayoutAttributeCenterX
		//                                                      multiplier:1
		//                                                        constant:0]];

		// 		[section addConstraint:[NSLayoutConstraint constraintWithItem:glyphView
		//                                                       attribute:NSLayoutAttributeCenterY
		//                                                       relatedBy:NSLayoutRelationEqual
		//                                                          toItem:section
		//                                                       attribute:NSLayoutAttributeCenterY
		//                                                      multiplier:1
		//                                                        constant:0]];

		// 	}
		// 	[(UILabel *)[section valueForKey:@"_alteredStateLabel"] setHidden:YES];
		// 	[(UILabel *)[section valueForKey:@"_label"] setHidden:YES];
		// 	[section setNeedsLayout];
		// 	[section updateConstraints];
		// }
		%orig(4);
		[self layoutSubviews];
	} else %orig(3);
}

-(CGSize)intrinsicContentSize {
		return CGSizeMake(-1,60);
}
%end