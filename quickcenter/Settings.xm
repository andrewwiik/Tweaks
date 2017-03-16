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
		UIView *test = MSHookIvar<UIView*>(self,"_installButton");
		[[test retain] setTitle:[self.specifier propertyForKey:@"CustomTitle"]];
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
- (void)_buttonAction:(id)arg1 {
  ///NSLog(@"Confirm Test SUCCEDED TWICE YAYA");
  if ([[self cellTarget] resetSettings])
  [arg1 setShowingConfirmation:NO animated:YES];

}
%new
- (void)_cancelConfirmationAction:(id)arg1 {
  [arg1 setShowingConfirmation:NO animated:YES];
}
%new
- (void)_showConfirmationAction:(id)arg1 {
  [arg1 setShowingConfirmation:YES animated:YES];
}
%new
- (void)testing123:(id)button {
	[button setShowingConfirmation:YES animated:YES];
}

%new
- (void)handleTap:(UITapGestureRecognizer *)sender {
	if (sender) {
		if (sender.state == UIGestureRecognizerStateEnded) {
			if (sender.view) {
				if ([[sender.view isShowingConfirmation] boolValue] == NO) {
					[sender.view setShowingConfirmation:YES animated:YES];
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
