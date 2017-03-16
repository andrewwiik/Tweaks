#import "CCXNavigationViewController.h"

%subclass CCXNavigationViewController : UIViewController <UINavigationControllerDelegate, CCUIControlCenterPageContentProviding>
%property (nonatomic, retain) _UIVisualEffectLayerConfig *primaryEffectConfig;
%property (nonatomic, retain) ICGNavigationController *navigationController;
%property (nonatomic, retain) CCXMainControlsPageViewController *mainViewController;
%property (nonatomic, retain) CCUIControlCenterPageContainerViewController *delegate;
%property (nonatomic, retain) CCXSettingsPageViewController *settingsViewController;
%property (nonatomic, retain) UIView *headerView;
%property (nonatomic, retain) WATodayAutoupdatingLocationModel *weatherModel;
%property (nonatomic, retain) UIColor *specialColor;
%property (nonatomic, retain) UIImageView *secondaryBackgroundView;
%property (nonatomic, retain) UIImageView *primaryBackgroundView;
%property (nonatomic, retain) UIImageView *maskingView;
%property (nonatomic, retain) CCUIControlCenterPagePlatterView *platterView;

- (id)init {
	CCXNavigationViewController *orig = %orig;
	if (orig) {
		orig.mainViewController = [[NSClassFromString(@"CCXMainControlsPageViewController") alloc] init];
		orig.settingsViewController = [[NSClassFromString(@"CCXSettingsPageViewController") alloc] init];
		orig.navigationController = [[ICGNavigationController alloc] initWithRootViewController:self.mainViewController];
		orig.navigationController.navigationBarHidden = YES;
		orig.navigationController.delegate = self;

		ICGLayerAnimation *layerAnimation = [[ICGLayerAnimation alloc] initWithType:ICGLayerAnimationCover];
  		self.navigationController.animationController = layerAnimation;

		WeatherPreferences *preferences = [NSClassFromString(@"WeatherPreferences") sharedPreferences];
		orig.weatherModel = [NSClassFromString(@"WATodayModel") autoupdatingLocationModelWithPreferences:preferences effectiveBundleIdentifier:@"com.apple.springboard"];
		[[NSNotificationCenter defaultCenter] addObserver:orig
	                                             selector:@selector(showSettingsPage)
	                                             	 name:@"com.horseshoe.activatesettings"
	                                           	   object:nil];
	}
	return orig;
}

%new
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
	return [self.navigationController navigationController:navigationController animationControllerForOperation:operation fromViewController:fromVC toViewController:toVC];
}

%new
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
	return [self.navigationController navigationController:navigationController interactionControllerForAnimationController:animationController];
}

%new
-(void)navigationController:(id)controller didShowViewController:(id)viewController animated:(BOOL)animated {
	// if (viewController == self.settingsViewController) {
	// 	self.mainViewController.view.hidden = YES;
	//[self _rerenderPunchThroughMaskIfNecessary];
	// }
	if (self.platterView) {
		if (viewController == self.mainViewController) {
			self.platterView.suppressRenderingMask = NO;
		}
	}
}

%new
- (UIImageView *)copyOfImageView:(UIImageView *)view {
	UIImageView *copy = [[UIImageView alloc] initWithFrame:view.frame];
	copy.image = view.image;
	if (view.layer.filters) {
		copy.layer.filters = [view.layer.filters copy];
	}
	copy.layer.contentsMultiplyColor = [view.layer contentsMultiplyColor];
	// copy.layer.cornerRadius = view.layer.cornerRadius;
	// copy.clipsToBounds = view.clipsToBounds;
	return copy;
}

%new
+ (UIImage *)imageFromColor:(UIColor *)color andSize:(CGRect)imgBounds {
    UIGraphicsBeginImageContextWithOptions(imgBounds.size, NO, 0);
    [color setFill];
    UIRectFill(imgBounds);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

%new
-(void)navigationController:(id)controller willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	self.delegate.view.layer.cornerRadius = 13;
   	self.delegate.view.clipsToBounds = YES;

   	if (!self.platterView) {
		self.platterView = [self.view ccuiPunchOutMaskedContainer];
	}

	if (!self.maskingView && self.platterView) {
		for (UIView *subview in [self.platterView subviews]) {
			if ([subview isKindOfClass:NSClassFromString(@"UIImageView")]) {
				self.maskingView = (UIImageView *)subview;
				break;
			}
		}
	}

	if (self.platterView) {
		self.platterView.suppressRenderingMask = YES;
	}

	if (viewController == self.settingsViewController) {
		

		[self.settingsViewController updateCutoutView];

		ICGLayerAnimation *layerAnimation = [[ICGLayerAnimation alloc] initWithType:ICGLayerAnimationCover];
  		self.navigationController.animationController = layerAnimation;
		// self.settingsViewController.view.hidden = NO;
		// self.mainViewController.view.hidden = YES;
		//self.settingsViewController.view.frame = self.mainViewController.view.frame;
		if (self.delegate) {
			//[self.delegate.view _rerenderPunchThroughMaskIfNecessary];
		}

		//[self.platterView _rerenderPunchThroughMaskIfNecessary];
		//self.mainViewController.view.hidden = NO;
		//self.delegate.view.hidden = NO;

	} else if (viewController == self.mainViewController) {
		// self.mainViewController.view.hidden = NO;
		if (self.platterView) {
			self.platterView.suppressRenderingMask = NO;
		}
		ICGLayerAnimation *layerAnimation = [[ICGLayerAnimation alloc] initWithType:ICGLayerAnimationCover];
  		self.navigationController.animationController = layerAnimation;

		//ICGLayerAnimation *layerAnimation = [[ICGLayerAnimation alloc] initWithType:ICGLayerAnimationCover];
  // 		self.navigationController.animationController = nil;
		// self.settingsViewController.view.hidden = YES;
		//[self.delegate.view _rerenderPunchThroughMaskIfNecessary];
		//maskingView.frame = self.mainViewController.view.frame;
		// if (self.rightView) {
		// 	self.rightView.hidden = YES;
		// }
		// if (self.middleView) {
		// 	self.middleView.hidden = YES;
		// }
		//self.mainViewController.view.frame = self.settingsViewController.view.frame;
		//[self.platterView _rerenderPunchThroughMaskIfNecessary];
	}
}

- (void)viewDidLoad {
	%orig;
	if (self.delegate) {
		self.delegate.view.clipsToBounds = YES;
	}

	[self addChildViewController:self.navigationController];

	// self.transitionAnimator = [[JVTransitionAnimator alloc] init];
	// self.transitionAnimator.fromViewController = self.mainViewController;
 //    self.transitionAnimator.toViewController = self.settingsViewController;

 //    // enabling interactive transitions
 //    self.transitionAnimator.enabledInteractiveTransitions = NO;

 //    // also don't forget to tell the new UIViewController to be presented that we will be using our animator & choose the animation
 //    self.transitionAnimator.slideUpDownAnimation = YES;
 //    self.settingsViewController.transitioningDelegate = self.transitionAnimator;
	// if (self.mainViewController) {
	// 	[self.navigationController addChildViewController:self.mainViewController];
	// }
	// if (self.settingsViewController) {
	// 	[self.navigationController addChildViewController:self.settingsViewController];
	// }

	 CCUIControlCenterVisualEffect *effect = [NSClassFromString(@"CCUIControlCenterVisualEffect")  _primaryRegularTextOnPlatterEffect];
    _UIVisualEffectConfig *effectConfig = [effect effectConfig];
   	self.primaryEffectConfig = effectConfig.contentConfig;
   //	[self _layoutHeaderView];

	if (self.mainViewController) {
		if (!self.mainViewController.delegate && self.delegate) {
			self.mainViewController.delegate = self.delegate;
		} 
	}

	if (self.navigationController.view && ![self.navigationController.view superview]) {

		[self.view addSubview:self.navigationController.view];
		self.navigationController.view.translatesAutoresizingMaskIntoConstraints = NO;

		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationController.view
			                                             attribute:NSLayoutAttributeTop
			                                             relatedBy:NSLayoutRelationEqual
			                                                toItem:self.view
			                                             attribute:NSLayoutAttributeTop
			                                            multiplier:1
			                                              constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationController.view
			                                             attribute:NSLayoutAttributeBottom
			                                             relatedBy:NSLayoutRelationEqual
			                                                toItem:self.view
			                                             attribute:NSLayoutAttributeBottom
			                                            multiplier:1
			                                              constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationController.view
			                                             attribute:NSLayoutAttributeWidth
			                                             relatedBy:NSLayoutRelationEqual
			                                                toItem:self.view
			                                             attribute:NSLayoutAttributeWidth
			                                            multiplier:1
			                                              constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationController.view
			                                             attribute:NSLayoutAttributeHeight
			                                             relatedBy:NSLayoutRelationEqual
			                                                toItem:self.view
			                                             attribute:NSLayoutAttributeHeight
			                                            multiplier:1
			                                              constant:0]];
	}
}
%new
-(void)controlCenterWillPresent {
	if (self.mainViewController) {
		if (!self.mainViewController.delegate && self.delegate) {
			self.mainViewController.delegate = self.delegate;
		} 
		[self.mainViewController controlCenterWillPresent];
	}
	return;
}
%new
-(void)controlCenterDidDismiss {
	if (self.mainViewController) {
		if (!self.mainViewController.delegate && self.delegate) {
			self.mainViewController.delegate = self.delegate;
		} 
		[self.mainViewController controlCenterDidDismiss];
	}
}
%new
-(void)controlCenterWillBeginTransition {
	if (self.mainViewController) {
		if (!self.mainViewController.delegate && self.delegate) {
			self.mainViewController.delegate = self.delegate;
		} 
		[self.mainViewController controlCenterWillBeginTransition];
	}
}

%new
-(void)controlCenterDidFinishTransition {

	// NSLog(@"Stuff It Jerry");
	// if (self.delegate) {
	// 	// if (self.delegate.revealPercentage > 1) {
	// 		[self showSettings];
	// 		NSLog(@"Transition Progress: %@", [NSNumber numberWithFloat:self.delegate.revealPercentage]);
	// 	// }
	// }
	if (self.mainViewController) {
		if (!self.mainViewController.delegate && self.delegate) {
			self.mainViewController.delegate = self.delegate;
		} 
		[self.mainViewController controlCenterDidFinishTransition];
	}
}

%new
-(UIEdgeInsets)contentInsets {
	// if (self.mainViewController) {
	// 	return [self.mainViewController contentInsets];
	// }
	return UIEdgeInsetsMake(0,0,0,0);
}

%new
- (void)_dismissButtonActionPlatterWithCompletion:(id)arg1 {
	if (self.mainViewController) {
		[self.mainViewController _dismissButtonActionPlatterWithCompletion:arg1];
	}
}

%new
-(void)_rerenderPunchThroughMaskIfNecessary {
	// if (self.platterView) {
	// 	[self.platterView _rerenderPunchThroughMaskIfNecessary];
	// } else if ([self.delegate.view respondsToSelector:@selector(_rerenderPunchThroughMaskIfNecessary)]) {
	// 	[self.delegate.view _rerenderPunchThroughMaskIfNecessary];
	// }
}

%new
- (void)showSettingsPage {
	if (self.delegate) {
	//	[self.delegate beginSuppressingPunchOutMaskCachingForReason:@"CCXSettingsVisible"];
	}
	if (self.navigationController.visibleViewController != self.settingsViewController) {
		// ICGLayerAnimation *layerAnimation = [[ICGLayerAnimation alloc] initWithType:ICGLayerAnimationCover];
  // 		self.navigationController.animationController = layerAnimation;
		//[self presentViewController:self.settingsViewController animated:YES completion:nil];;
		[self.navigationController pushViewController:self.settingsViewController animated:YES];
		//self.mainViewController.view.hidden =YES;
		// [self _rerenderPunchThroughMaskIfNecessary];
	} else {
		//ICGSlideAnimation *layerAnimation = [[ICGSlideAnimation alloc] initWithType:ICGSlideAnimationFromTop];
  		//self.navigationController.animationController = layerAnimation;
		//self.mainViewController.view.hidden = NO;
		// [self _rerenderPunchThroughMaskIfNecessary];
		[[self navigationController] popViewControllerAnimated:YES];
		// [self.navigationController pushViewController:self.navigationController.previousViewController animated:YES];
		// [self _rerenderPunchThroughMaskIfNecessary];
	}
	// else
	// 	[self.navigationController pushViewController:self.navigationController.previousController animated:YES]l
}

%new
- (void)_layoutHeaderView {
	if (!self.headerView) {
		self.headerView = [[UIView alloc] initWithFrame:CGRectZero];
		//self.headerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];



		UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
		iconView.image =  [NSClassFromString(@"WeatherImageLoader") conditionImageWithConditionIndex:self.weatherModel.forecastModel.currentConditions.conditionCode];
		//iconView.image = [UIImage imageNamed:@"General" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Preferences.framework/"]];
		// WeatherPreferences *preferences = [NSClassFromString(@"WeatherPreferences") sharedPreferences];
		// WATodayAutoupdatingLocationModel *todayModel = [NSClassFromString(@"WATodayModel") autoupdatingLocationModelWithPreferences:preferences effectiveBundleIdentifier:@"com.apple.springboard"];
		// NSInteger conditionCode = todayModel.forecastModel.currentConditions.conditionCode;
		// UIImage *conditionImage = [NSClassFromString(@"WeatherImageLoader") conditionImageWithConditionIndex:conditionCode];


		// iconView.layer.cornerRadius = 2;
		// iconView.clipsToBounds = YES;
		[self.headerView addSubview:iconView];

		iconView.translatesAutoresizingMaskIntoConstraints = NO;

		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:iconView
		                                             attribute:NSLayoutAttributeCenterY
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.headerView
		                                             attribute:NSLayoutAttributeCenterY
		                                             multiplier:1
		                                               constant:0]];
		// [self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:iconView
		//                                              attribute:NSLayoutAttributeWidth
		//                                              relatedBy:NSLayoutRelationGreaterThanOrEqual
		//                                                 toItem:nil
		//                                              attribute:NSLayoutAttributeNotAnAttribute
		//                                              multiplier:1
		//                                                constant:20]];
		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:iconView
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationLessThanOrEqual
		                                                toItem:nil
		                                             attribute:NSLayoutAttributeNotAnAttribute
		                                             multiplier:1
		                                               constant:20]];
		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:iconView
		                                             attribute:NSLayoutAttributeLeft
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.headerView
		                                             attribute:NSLayoutAttributeLeft
		                                             multiplier:1
		                                               constant:24]];
		[iconView sizeToFit];
		[iconView setNeedsLayout];
		[self.headerView setNeedsLayout];
		if (iconView.frame.size.height < 22) {
			iconView.transform = CGAffineTransformMakeScale(1.15, 1.15);
		}

		[self.primaryEffectConfig configureLayerView:iconView];

		UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		headerLabel.font = [[self class] headerFont];
		headerLabel.textColor = [UIColor whiteColor];
		//headerLabel.text = @"SETTINGS";
		headerLabel.text = [NSString stringWithFormat:@"%@° • Showers",[NSNumber numberWithFloat:self.weatherModel.forecastModel.currentConditions.temperature.fahrenheit]];
		[self.primaryEffectConfig configureLayerView:headerLabel];
		[self.headerView addSubview:headerLabel];

		headerLabel.translatesAutoresizingMaskIntoConstraints = NO;

		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerLabel
		                                             attribute:NSLayoutAttributeCenterY
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.headerView
		                                             attribute:NSLayoutAttributeCenterY
		                                             multiplier:1
		                                               constant:0]];
		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerLabel
		                                             attribute:NSLayoutAttributeLeft
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:iconView
		                                             attribute:NSLayoutAttributeRight
		                                             multiplier:1
		                                               constant:8]];
		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerLabel
		                                             attribute:NSLayoutAttributeRight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.headerView
		                                             attribute:NSLayoutAttributeCenterX
		                                             multiplier:1
		                                               constant:0]];
		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerLabel
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.headerView
		                                             attribute:NSLayoutAttributeHeight
		                                             multiplier:1
		                                               constant:0]];


		CCXNoEffectsButton *editButton = [NSClassFromString(@"CCXNoEffectsButton") capsuleButtonWithText:@"Edit"];
		editButton.translatesAutoresizingMaskIntoConstraints = NO;
		editButton.font = [[self class] headerFont];
		UIView *editBackgroundView = (UIView *)[editButton valueForKey:@"_backgroundFlatColorView"];
		//editBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
		editBackgroundView.layer.cornerRadius = 13;

		[self.headerView addSubview:editButton];
		editButton.translatesAutoresizingMaskIntoConstraints = NO;

		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:editButton
		                                             attribute:NSLayoutAttributeRight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.headerView
		                                             attribute:NSLayoutAttributeRight
		                                             multiplier:1
		                                               constant:-24]];
		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:editButton
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:nil
		                                             attribute:NSLayoutAttributeNotAnAttribute
		                                             multiplier:1
		                                               constant:18]];
		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:editButton
		                                             attribute:NSLayoutAttributeCenterY
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.headerView
		                                             attribute:NSLayoutAttributeCenterY
		                                             multiplier:1
		                                               constant:0]];
		// [self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:editButton
		//                                              attribute:NSLayoutAttributeWidth
		//                                              relatedBy:NSLayoutRelationEqual
		//                                                 toItem:nil
		//                                              attribute:NSLayoutAttributeNotAnAttribute
		//                                              multiplier:1
		//                                                constant:100]];

		CCXPunchOutView *separatorView = [[NSClassFromString(@"CCXPunchOutView") alloc] initWithFrame:CGRectZero];
		separatorView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.headerView addSubview:separatorView];
		
		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:separatorView
		                                             attribute:NSLayoutAttributeTop
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.headerView
		                                             attribute:NSLayoutAttributeBottom
		                                             multiplier:1
		                                               constant:-0.5]];
		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:separatorView
		                                             attribute:NSLayoutAttributeWidth
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.headerView
		                                             attribute:NSLayoutAttributeWidth
		                                             multiplier:1
		                                               constant:0]];
		[self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:separatorView
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:nil
		                                             attribute:NSLayoutAttributeNotAnAttribute
		                                             multiplier:1
		                                               constant:0.5]];

		self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:self.headerView];

		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:nil
		                                             attribute:NSLayoutAttributeNotAnAttribute
		                                             multiplier:1
		                                               constant:36]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
		                                             attribute:NSLayoutAttributeTop
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.view
		                                             attribute:NSLayoutAttributeTop
		                                             multiplier:1
		                                               constant:-24]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
		                                             attribute:NSLayoutAttributeWidth
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.view
		                                             attribute:NSLayoutAttributeWidth
		                                             multiplier:1
		                                               constant:0]];


			// CGFloat dummyViewHeight = 40;
	// UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewController.tableView.bounds.size.width, dummyViewHeight)];
	// self.headerView.frame = CGRectMake(0,0,self.view.frame.size.width, 36);
	// self.tableViewController.tableView.tableHeaderView = self.headerView;
	// self.tableViewController.tableView.contentInset = UIEdgeInsetsMake(36, 0, 0, 0);
	}
	[self.view sendSubviewToBack:self.navigationController.view];
}

%new
+ (UIFont *)headerFont {
	UIFontDescriptor *descriptor = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote] fontDescriptorWithFamily:@".SFUIText"];
	descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitCondensed];
	return [UIFont fontWithDescriptor:descriptor size:0];
// 	return [UIFont fontWithName:@".SFUIText" size:font.pointSize-1*[UIScreen mainScreen].scale) traits:[font traits]];
}



%new


%end