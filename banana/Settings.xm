#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface SKUIItemOfferButton : UIControl

- (void)_adjustViewOrderingForProperties:(id)arg1;
- (id)_buttonPropertiesForState:(id)arg1;
- (void)_cancelGestureAction:(id)arg1;
- (float)_horizontalInsetForTitleStyle:(int)arg1;
- (void)_insertBorderView;
- (void)_insertCancelGestureRecognizer;
- (void)_insertImageView;
- (void)_insertLabel;
- (void)_insertProgressIndicator;
- (void)_insertUniversalView;
- (void)_reloadForCurrentState:(BOOL)arg1;
- (void)_removeAllAnimations:(BOOL)arg1;
- (void)_removeCancelGestureRecognizer;
- (void)_sendDidAnimate;
- (void)_sendWillAnimate;
- (BOOL)_touchInBounds:(id)arg1;
- (void)_transitionFromImage:(id)arg1 toImage:(id)arg2 withDuration:(float)arg3 completion:(id /* block */)arg4;
- (void)_transitionFromProgress:(id)arg1 toProgress:(id)arg2 withDuration:(float)arg3 completion:(id /* block */)arg4;
- (void)_transitionFromProgress:(id)arg1 toTitleOrImage:(id)arg2 withDuration:(float)arg3 completion:(id /* block */)arg4;
- (void)_transitionFromTitle:(id)arg1 toTitle:(id)arg2 withDuration:(float)arg3 completion:(id /* block */)arg4;
- (void)_transitionFromTitleOrImage:(id)arg1 toProgress:(id)arg2 withDuration:(float)arg3 completion:(id /* block */)arg4;
- (void)_updateForChangedConfirmationTitleProperty;
- (void)_updateForChangedTitleProperty;
- (BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2;
- (void)cancelTrackingWithEvent:(id)arg1;
- (id)cloudTintColor;
- (id)confirmationTitle;
- (int)confirmationTitleStyle;
- (BOOL)continueTrackingWithTouch:(id)arg1 withEvent:(id)arg2;
- (void)dealloc;
- (id)delegate;
- (void)didMoveToWindow;
- (void)drawRect:(CGRect)arg1;
- (void)endTrackingWithTouch:(id)arg1 withEvent:(id)arg2;
- (int)fillStyle;
- (id)image;
- (id)initWithFrame:(CGRect)arg1;
- (BOOL)isShowingConfirmation;
- (BOOL)isUniversal;
- (id)itemOfferDelegate;
- (CGSize)layoutSizeThatFits:(CGSize)arg1;
- (void)layoutSubviews;
- (float)progress;
- (int)progressType;
- (void)removeButtonStateAnimations;
- (void)setBackgroundColor:(id)arg1;
- (void)setCloudTintColor:(id)arg1;
- (void)setColoringWithAppearance:(id)arg1;
- (void)setConfirmationTitle:(id)arg1;
- (void)setConfirmationTitleStyle:(int)arg1;
- (void)setDelegate:(id)arg1;
- (void)setEnabled:(BOOL)arg1;
- (void)setFillStyle:(int)arg1;
- (void)setFrame:(CGRect)arg1;
- (void)setImage:(id)arg1;
- (void)setItemOfferDelegate:(id)arg1;
- (void)setProgress:(float)arg1;
- (void)setProgress:(float)arg1 animated:(BOOL)arg2;
- (void)setProgressType:(int)arg1;
- (void)setProgressType:(int)arg1 animated:(BOOL)arg2;
- (void)setShowingConfirmation:(BOOL)arg1 animated:(BOOL)arg2;
- (void)setShowsConfirmationState:(BOOL)arg1;
- (void)setTitle:(id)arg1;
- (BOOL)setTitle:(id)arg1 confirmationTitle:(id)arg2 itemState:(id)arg3 clientContext:(id)arg4 animated:(BOOL)arg5;
- (void)setTitleStyle:(int)arg1;
- (void)setUniversal:(BOOL)arg1;
- (BOOL)setValuesUsingBuyButtonDescriptor:(id)arg1 itemState:(id)arg2 clientContext:(id)arg3 animated:(BOOL)arg4;
- (BOOL)setValuesUsingItemOffer:(id)arg1 itemState:(id)arg2 clientContext:(id)arg3 animated:(BOOL)arg4;
- (void)showCloudImage;
- (BOOL)showsConfirmationState;
- (CGSize)arg1;
- (void)tintColorDidChange;
- (id)title;
- (int)titleStyle;
- (void)setInteractionTintColor:(UIColor *)arg1;
@end

@interface PSTableCell (BNAPrivate)
- (id)value;
@end

@interface UIViewController (BNAPrivate)
- (BOOL)resetSettings;
@end

@class SKUIItemOfferButton;

UIColor *semiTrans = [UIColor colorWithRed:255.0f/255.0f
		green:255.0f/255.0f
		 blue:255.0f/255.0f
		alpha:0.5f];
UIColor *selectBlue = [UIColor colorWithRed:0.0f/255.0f
		green:122.0f/255.0f
		 blue:255.0f/255.0f
		alpha:1.0f];
UIColor *redReset = [UIColor colorWithRed:255.0f/255.0f
		green:0.0f/255.0f
		 blue:0.0f/255.0f
		alpha:1.0f];


%hook PSTableCell
%new
-(id)tableValue {
	return [self value];
}
%end
@interface ACUIAppInstallCell : PSTableCell
@end
%hook ACUIAppInstallCell
/*- (id)_createInstallButton {
	if ([[self.specifier objectForKey:@"Custom"] boolValue] == YES) {
		UIView *test = %orig;
		[test setTitle:@"PURCHASED"];
		return test;
	}
	else {
		%orig;
	}
}*/
- (void)_updateInstallButtonWithState:(int)arg1 {
	if ([[self.specifier propertyForKey:@"Custom"] boolValue] == YES) {
		%orig;
	}
	else {
		%orig;
	}
}
- (void)_updateSubviewsWithInstallState:(int)arg1 {
	if ([[self.specifier propertyForKey:@"Custom"] boolValue] == YES) {
		%orig;
		SKUIItemOfferButton *test = MSHookIvar<SKUIItemOfferButton *>(self,"_installButton");
		[test setTitle:[self.specifier propertyForKey:@"CustomTitle"]];
		//[test setTitleStyle:1];
		if ([[self.specifier propertyForKey:@"ResetButton"] boolValue] == YES) {
			[test addTarget:self action:@selector(_buttonAction:) forControlEvents:131072];
			[test addTarget:self action:@selector(_cancelConfirmationAction:) forControlEvents:65536];
			[test addTarget:self action:@selector(_showConfirmationAction:) forControlEvents:262144];
			[test setConfirmationTitle:[self.specifier propertyForKey:@"CustomConfirmation"]];
			[test setShowsConfirmationState:YES];
			[test setEnabled:YES];
			[test layoutSubviews];
			//UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] retain];
			//if (![[test gestureRecognizers] count] == 1) {
				//[test addGestureRecognizer:tap];
			//}
			[test setInteractionTintColor:selectBlue];
			MSHookIvar<UIColor*>(test,"_confirmationColor") = redReset;
		}
	}
	else {
		%orig;
	}
}
%new
- (void)_buttonAction:(SKUIItemOfferButton *)arg1 {
  ///NSLog(@"Confirm Test SUCCEDED TWICE YAYA");
  if ([(UIViewController *)[self cellTarget] resetSettings])
  [arg1 setShowingConfirmation:NO animated:YES];

}
%new
- (void)_cancelConfirmationAction:(SKUIItemOfferButton *)arg1 {
  [arg1 setShowingConfirmation:NO animated:YES];
}
%new
- (void)_showConfirmationAction:(SKUIItemOfferButton *)arg1 {
  [arg1 setShowingConfirmation:YES animated:YES];
}
%new
- (void)testing123:(SKUIItemOfferButton *)button {
	[button setShowingConfirmation:YES animated:YES];
}

%new
- (void)handleTap:(UITapGestureRecognizer *)sender {
	if (sender) {
		if (sender.state == UIGestureRecognizerStateEnded) {
			if (sender.view) {
				if ([(SKUIItemOfferButton *)sender.view isShowingConfirmation] == NO) {
					[(SKUIItemOfferButton *)sender.view setShowingConfirmation:YES animated:YES];
					//UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] retain];
					//[sender.view addGestureRecognizer:tap];
					//[sender setEnabled:NO];

				}
			}
		}
	}
}
%end

%ctor {
   if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.Preferences"]) { // Phone App
      %init;
   }
}
