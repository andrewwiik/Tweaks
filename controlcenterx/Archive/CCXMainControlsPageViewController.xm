#import "CCXMainControlsPageViewController.h"
#import <dlfcn.h>

%subclass CCXMainControlsPageViewController : CCUISystemControlsPageViewController <UINavigationControllerDelegate, CCUIControlCenterPageContentProviding, CCUIControlCenterSectionViewControllerDelegate>
%property (nonatomic, retain) CCXAirAndNightSectionController *airAndNightController;
%property (nonatomic, retain) CCXMiniMediaPlayerSectionController *miniMediaPlayerController;
%property (nonatomic, retain) CCUIBrightnessSectionController *volumeAndBrightnessController;
%property (nonatomic, retain) CCUIBrightnessSectionController *brightnessController;
%property (nonatomic, retain) LQDNightSectionController *noctisNightModeController;
%property (nonatomic, assign) BOOL isNoctisInstalled;
// %property (nonatomic, retain) CCXMainControlsPageView *view;
%property (nonatomic, assign) CGFloat animationProgressValueReal;
//%property (nonatomic, retain) CCXSettingsPageViewController *settingsViewController;
//%property (nonatomic, retain) CCXMainControlsPageViewController *duplicatedViewController;
// %property (nonatomic, retain) JVTransitionAnimator *transitionAnimator;
%property (nonatomic, retain) NSBundle *templateBundle;
%property (nonatomic, retain) NSString *enabledKey;
%property (nonatomic, retain) NSMutableArray *enabledIdentifiers;
%property (nonatomic, retain) NSString *disabledKey;
%property (nonatomic, retain) NSMutableArray *disabledIdentifiers;
%property (nonatomic, retain) NSArray *allSwitches;
%property (nonatomic, retain) NSString *settingsFile;
%property (nonatomic, retain) NSString *preferencesApplicationID;
%property (nonatomic, retain) NSString *notificationName;
%property (nonatomic, retain) UIImageView *backgroundCutoutView;
%property (nonatomic, retain) UIImageView *maskingView;

%new
- (CGFloat)animationProgressValue {
	return self.animationProgressValueReal;
}

%new
- (void)setAnimationProgressValue:(CGFloat)value {
	self.animationProgressValueReal = value;
	[self.delegate.view _rerenderPunchThroughMaskIfNecessary];
}
%new
- (BOOL)wantsVisible {
	return YES;
}
%new
- (CGFloat)requestedPageHeightForHeight:(CGFloat)height {
	return height+40;
}
- (void)loadView {
	%orig;

	// CCUIControlCenterPagePlatterView *platterView = [self.view ccuiPunchOutMaskedContainer];
	// self.maskingView = nil;
	// NSLog(@"Platter View: %@", platterView);
	// for (UIView *subview in [platterView subviews]) {
	// 	NSLog(@"GOT A SUBVIEW: %@", subview);
	// 	if ([subview isKindOfClass:NSClassFromString(@"UIImageView")]) {
	// 		self.maskingView = (UIImageView *)subview;
	// 		break;
	// 	}
	// }

	// if (self.maskingView) {
	// 	self.backgroundCutoutView = [[UIImageView alloc] initWithFrame:self.maskingView.frame];
	// 	self.backgroundCutoutView.image = self.maskingView.image;
	// 	if (self.maskingView.layer.filters) {
	// 		self.backgroundCutoutView.layer.filters = [self.maskingView.layer.filters copy];
	// 	}
	// 	self.backgroundCutoutView.layer.contentsMultiplyColor = [self.maskingView.layer contentsMultiplyColor];

	// 	[self.view addSubview:self.backgroundCutoutView];
	// 	[self.view sendSubviewToBack:self.backgroundCutoutView];

	// 	self.backgroundCutoutView.translatesAutoresizingMaskIntoConstraints = NO;
	// 	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCutoutView
	// 			                                             attribute:NSLayoutAttributeCenterY
	// 			                                             relatedBy:NSLayoutRelationEqual
	// 			                                                toItem:self.view
	// 			                                             attribute:NSLayoutAttributeCenterY
	// 			                                            multiplier:1
	// 			                                              constant:0]];
	// 	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCutoutView
	// 			                                             attribute:NSLayoutAttributeCenterX
	// 			                                             relatedBy:NSLayoutRelationEqual
	// 			                                                toItem:self.view
	// 			                                             attribute:NSLayoutAttributeCenterX
	// 			                                            multiplier:1
	// 			                                              constant:0]];
	// 	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCutoutView
	// 			                                             attribute:NSLayoutAttributeWidth
	// 			                                             relatedBy:NSLayoutRelationEqual
	// 			                                                toItem:self.view
	// 			                                             attribute:NSLayoutAttributeWidth
	// 			                                            multiplier:1
	// 			                                              constant:0]];
	// 	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCutoutView
	// 			                                             attribute:NSLayoutAttributeHeight
	// 			                                             relatedBy:NSLayoutRelationEqual
	// 			                                                toItem:self.view
	// 			                                             attribute:NSLayoutAttributeHeight
	// 			                                            multiplier:1
	// 			                                              constant:0]];
	// }


	//self.view = [[NSClassFromString(@"CCXMainControlsPageView") alloc] initWithFrame:CGRectZero];
	//%orig;

	//[self.view removeFromSuperview];
	//self.duplicatedViewController = [[NSClassFromString(@"CCXMainControlsPageViewController") alloc] init];
	// self.navigationController = [[UINavigationController alloc] initWithRootViewController:self];
	// self.navigationController.navigationBarHidden = YES;
	// [[self.view superview] addSubview:self.navigationController.view];
	//self.settingsViewController =  [[NSClassFromString(@"CCXSettingsPageViewController") alloc] init];
	//[self addChildViewController:self.settingsViewController];
	// self.transitionAnimator = [[JVTransitionAnimator alloc] init];
	// self.transitionAnimator.fromViewController = self;
 //    self.transitionAnimator.toViewController = self.settingsViewController;

 //    // enabling interactive transitions
 //    self.transitionAnimator.enabledInteractiveTransitions = NO;

 //    // also don't forget to tell the new UIViewController to be presented that we will be using our animator & choose the animation
 //    self.transitionAnimator.slideUpDownAnimation = YES;
 //    self.settingsViewController.transitioningDelegate = self.transitionAnimator;

	// self.navigationController.delegate = self;
	//%orig;
	//NSMutableArray *sections = (NSMutableArray *)[self valueForKey:@"_sectionList"];
	// UIStackView *stackView = nil;
	// for (UIViewController *section in sections) {
	// 	if ([section.view superview] && !stackView) {
	// 		if ([[section.view superview] isKindOfClass:NSClassFromString(@"UIStackView")]) {
	// 			stackView = (UIStackView *)[section.view superview];
	// 			break;
	// 		}
	// 	}
	// 	//[section.view removeFromSuperview];
	// }
	//[sections removeAllObjects];

	if (NSClassFromString(@"LQDNightSectionController")) {
		self.isNoctisInstalled = YES;
	}

	self.settingsFile = @"/var/mobile/Library/Preferences/com.atwiiks.controlcenterx.plist";
	self.preferencesApplicationID = @"com.atwiiks.controlcenterx";
	self.notificationName = @"com.atwiiks.controlcenterx.settingschanged";
	NSDictionary *settings = nil;
	self.enabledKey = @"SectionsEnabledIdentifiers";
	self.disabledKey = @"SectionsDisabledIdentifiers";
	if (self.settingsFile) {
		if (self.preferencesApplicationID) {
			CFPreferencesAppSynchronize((__bridge CFStringRef)self.preferencesApplicationID);
			CFArrayRef keyList = CFPreferencesCopyKeyList((__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
			if (keyList) {
				settings = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost));
			}
		} else {
			settings = [NSDictionary dictionaryWithContentsOfFile:self.settingsFile];
		}
	}
	self.allSwitches = [(CCXSectionsPanel *)[NSClassFromString(@"CCXSectionsPanel") sharedInstance] sortedSectionIdentifiers];
	NSArray *originalEnabled = [settings objectForKey:self.enabledKey];
	self.enabledIdentifiers = [originalEnabled mutableCopy];


	[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(reloadSectionSettings)
	                                             	 name:self.notificationName
	                                           	   object:nil];

	CCXSectionsPanel *panel = (CCXSectionsPanel *)[NSClassFromString(@"CCXSectionsPanel") sharedInstance];

	self.airAndNightController = [[NSClassFromString(@"CCXAirAndNightSectionController") alloc] init];
	self.airAndNightController.delegate = self;
	[(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:self.airAndNightController];

	self.miniMediaPlayerController = [[NSClassFromString(@"CCXMiniMediaPlayerSectionController") alloc] init];
	self.miniMediaPlayerController.delegate = self;
	[(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:self.miniMediaPlayerController];

	// self.settingsSectionController = [[NSClassFromString(@"CCUISettingsSectionController") alloc] init];
	// self.settingsSectionController.delegate = self;
	// [(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:self.settingsSectionController];

	self.volumeAndBrightnessController = [[NSClassFromString(@"CCUIBrightnessSectionController") alloc] init];
	self.volumeAndBrightnessController.delegate = self;
	[(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:self.volumeAndBrightnessController];

	if (self.isNoctisInstalled) {
		self.noctisNightModeController = [[NSClassFromString(@"LQDNightSectionController") alloc] init];
		[self.noctisNightModeController setDelegate:self];
		[(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:self.noctisNightModeController];
	}

	// self.quickLaunchController = [[NSClassFromString(@"CCUIQuickLaunchSectionController") alloc] init];
	// self.quickLaunchController.delegate = self;
	// [(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:self.quickLaunchController];

	// self.brightnessController = [[NSClassFromString(@"CCUIBrightnessSectionController") alloc] init];
	// self.brightnessController.delegate = self;

	// self.nightShiftController = [[NSClassFromString(@"CCUINightShiftSectionController") alloc] init];
	// self.nightShiftController.delegate = self;

	// self.airStuffController = [[NSClassFromString(@"CCUIAirStuffSectionController") alloc] init];
	// self.airStuffController.delegate = self;
	// self.airStuffController.view.mode = 0;

	//[(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:self.brightnessController];


	NSMutableArray *switchIdentifiers = [self.allSwitches mutableCopy];
	// for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
	// 	if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
	// 		if ([self.enabledIdentifiers containsObject:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
	// 			[switchIdentifiers removeObject:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]];
	// 		}
	// 	}
	// }
	NSLog(@"SWITCHES: %@", switchIdentifiers);
	for (NSString *identifier in switchIdentifiers) {
		BOOL makeController = YES;
		CCXSectionObject *sectionData = [panel sectionObjectForIdentifier:identifier];
		if (sectionData) {
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([viewController class] == sectionData.controllerClass) {
					makeController = NO;
				}
			}
		}
		if (makeController) {
			id<CCUIControlCenterPageContentProviding> sectionController = [[sectionData.controllerClass alloc] init];
			sectionController.delegate = (id<CCUIControlCenterPageContentViewControllerDelegate>)self;
			[(NSMutableArray *)[self valueForKey:@"_sectionList"] addObject:sectionController];
		}
	}


	NSMutableArray *columnStackViews = [[self valueForKey:@"_columnStackViews"] mutableCopy];
	if ([columnStackViews count] == 1) {
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.volumeAndBrightnessController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.miniMediaPlayerController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.volumeAndBrightnessController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.airAndNightController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view];
		NSMutableArray *processedViewControllers = [NSMutableArray new];
		for (int x = 0; x < [self.enabledIdentifiers count]; x++) {
			NSString *currentSectionIdentifier = self.enabledIdentifiers[x];
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
						[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:viewController.view];
						viewController.view.hidden = NO;
						[processedViewControllers addObject:viewController];
					}
				}
			}
		}
		for (int y = 0; y < [self.disabledIdentifiers count]; y++) {
			NSString *currentSectionIdentifier = self.enabledIdentifiers[y];
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
						viewController.view.hidden = YES;
						[processedViewControllers addObject:viewController];
					}
				}
			}
		}
		for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
			if (![processedViewControllers containsObject:viewController]) {
				viewController.view.hidden = YES;
			}
		}
	} else if ([columnStackViews count] == 2) {
		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view];
		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.volumeAndBrightnessController.view];
		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.airAndNightController.view];
		//[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.brightnessController.view];
		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view];
		[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.miniMediaPlayerController.view];
	//	[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.volumeAndBrightnessController.view];
		//self.miniMediaPlayerController.view.frame = CGRectMake(0,0,((UIStackView *)[columnStackViews objectAtIndex:0]).frame.size.width,((UIStackView *)[columnStackViews objectAtIndex:0]).frame.size.height);
	} else if ([columnStackViews count] == 3) {
		//NSLog(@"Setting up for 3 Colum View");
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view];

		// [(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.miniMediaPlayerController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.volumeAndBrightnessController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:((CCUIAirStuffSectionController *)[self valueForKey:@"_airStuffSection"]).view];
		// if (self.isNoctisInstalled) {
		// 	[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.noctisNightModeController.view];
		// } else {
		// 	[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:((CCUINightShiftSectionController *)[self valueForKey:@"_nightShiftSection"]).view];
		// }
		// [(UIStackView *)[columnStackViews objectAtIndex:2] addArrangedSubview:((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view];
		// ((CCUIAirStuffSectionController *)[self valueForKey:@"_airStuffSection"]).view.mode = 0;
		NSMutableArray *processedViewControllers = [NSMutableArray new];
		for (int x = 0; x < [self.enabledIdentifiers count]; x++) {
			NSString *currentSectionIdentifier = self.enabledIdentifiers[x];
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
						[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:viewController.view];
						viewController.view.hidden = NO;
						[processedViewControllers addObject:viewController];
					}
				}
			}
		}
		for (int y = 0; y < [self.disabledIdentifiers count]; y++) {
			NSString *currentSectionIdentifier = self.enabledIdentifiers[y];
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
						viewController.view.hidden = YES;
						[processedViewControllers addObject:viewController];
					}
				}
			}
		}
		for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
			if (![processedViewControllers containsObject:viewController]) {
				viewController.view.hidden = YES;
			}
		}
	//	self.airStuffController.view.mode = 0;
	}

	// ((UIViewController *)[self valueForKey:@"_airStuffSection"]).view.hidden = YES;
	((UIViewController *)[self valueForKey:@"_auxillaryAirStuffSection"]).view.hidden = YES;
	((UIViewController *)[self valueForKey:@"_brightnessSection"]).view.hidden = YES;
	if (self.isNoctisInstalled)
	self.lqdNightSectionController.view.hidden = YES;
	[(CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"] viewWillAppear:YES];
	[(CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"] viewWillLayoutSubviews];
	[(CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"] viewWillAppear:YES];
	[(CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"] viewWillLayoutSubviews];
	//((UIViewController *)[self valueForKey:@"_quickLaunchSection"]).view.hidden = YES;
	[self _updateColumns];
}

%new
- (void)reloadSectionSettings {
	NSDictionary *settings = nil;
	if (self.settingsFile) {
		if (self.preferencesApplicationID) {
			CFPreferencesAppSynchronize((__bridge CFStringRef)self.preferencesApplicationID);
			CFArrayRef keyList = CFPreferencesCopyKeyList((__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
			if (keyList) {
				settings = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost));
			}
		} else {
			settings = [NSDictionary dictionaryWithContentsOfFile:self.settingsFile];
		}
	}
	self.allSwitches = [(CCXSectionsPanel *)[NSClassFromString(@"CCXSectionsPanel") sharedInstance] sortedSectionIdentifiers];
	NSArray *originalEnabled = [settings objectForKey:self.enabledKey];
	self.enabledIdentifiers = [originalEnabled mutableCopy];
	[self _updateAllSectionVisibilityAnimated:NO];
}

-(void)_updateAllSectionVisibilityAnimated:(BOOL)arg1 {
	%orig;
	[(CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"] viewWillAppear:YES];
	[(CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"] viewWillLayoutSubviews];
	[(CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"] viewWillAppear:YES];
	[(CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"] viewWillLayoutSubviews];
	NSMutableArray *columnStackViews = [[self valueForKey:@"_columnStackViews"] mutableCopy];
	if ([columnStackViews count] == 1) {
		// ((UIViewController *)[self valueForKey:@"_settingsSection"]).view.hidden = NO;
		// self.miniMediaPlayerController.view.hidden = NO;
		// self.volumeAndBrightnessController.view.hidden = NO;
		// self.airAndNightController.view.hidden = NO;
		// ((UIViewController *)[self valueForKey:@"_quickLaunchSection"]).view.hidden = NO;
		// ((UIViewController *)[self valueForKey:@"_nightShiftSection"]).view.hidden = YES;
		// if (self.isNoctisInstalled) {
		// 	self.noctisNightModeController.view.hidden = YES;
		// }
		// ((CCUIAirStuffSectionController *)[self valueForKey:@"_airStuffSection"]).view.hidden = YES;
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.volumeAndBrightnessController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.miniMediaPlayerController.view];
		// //[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.volumeAndBrightnessController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.airAndNightController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view];
		NSMutableArray *processedViewControllers = [NSMutableArray new];
		for (int x = 0; x < [self.enabledIdentifiers count]; x++) {
			NSString *currentSectionIdentifier = self.enabledIdentifiers[x];
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
						[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:viewController.view];
						viewController.view.hidden = NO;
						[processedViewControllers addObject:viewController];
					}
				}
			}
		}
		for (int y = 0; y < [self.disabledIdentifiers count]; y++) {
			NSString *currentSectionIdentifier = self.enabledIdentifiers[y];
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
						viewController.view.hidden = YES;
						[processedViewControllers addObject:viewController];
					}
				}
			}
		}
		for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
			if (![processedViewControllers containsObject:viewController]) {
				viewController.view.hidden = YES;
			}
		}

	} else if ([columnStackViews count] == 2) {
		((UIViewController *)[self valueForKey:@"_settingsSection"]).view.hidden = NO;
		self.airAndNightController.view.hidden = NO;
		((UIViewController *)[self valueForKey:@"_quickLaunchSection"]).view.hidden = NO;
		if (self.isNoctisInstalled) {
			self.noctisNightModeController.view.hidden = YES;
		}
		((UIViewController *)[self valueForKey:@"_nightShiftSection"]).view.hidden = YES;
		((CCUIAirStuffSectionController *)[self valueForKey:@"_airStuffSection"]).view.hidden = YES;
		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view];
		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.volumeAndBrightnessController.view];
		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.airAndNightController.view];
		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view];
		[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.miniMediaPlayerController.view];

	} else if ([columnStackViews count] == 3) {
		// ((UIViewController *)[self valueForKey:@"_settingsSection"]).view.hidden = NO;
		// ((UIViewController *)[self valueForKey:@"_quickLaunchSection"]).view.hidden = NO;
		// self.miniMediaPlayerController.view.hidden = NO;
		// self.volumeAndBrightnessController.view.hidden = NO;
		// ((CCUIAirStuffSectionController *)[self valueForKey:@"_airStuffSection"]).view.hidden = NO;
		// ((CCUIAirStuffSectionController *)[self valueForKey:@"_airStuffSection"]).view.mode = 0;
		// self.airAndNightController.view.hidden = YES;
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view];
		// [(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.miniMediaPlayerController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.volumeAndBrightnessController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:((CCUIAirStuffSectionController *)[self valueForKey:@"_airStuffSection"]).view];
		// if (self.isNoctisInstalled) {
		// 	[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.noctisNightModeController.view];
		// 	self.noctisNightModeController.view.hidden = NO;
		// } else {
		// 	[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:((CCUINightShiftSectionController *)[self valueForKey:@"_nightShiftSection"]).view];
		// 	((CCUINightShiftSectionController *)[self valueForKey:@"_nightShiftSection"]).view.hidden = NO;
		// }
		// [(UIStackView *)[columnStackViews objectAtIndex:2] addArrangedSubview:((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view];
		
		NSMutableArray *processedViewControllers = [NSMutableArray new];
		for (int x = 0; x < [self.enabledIdentifiers count]; x++) {
			NSString *currentSectionIdentifier = self.enabledIdentifiers[x];
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
						[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:viewController.view];
						viewController.view.hidden = NO;
						[processedViewControllers addObject:viewController];
					}
				}
			}
		}
		for (int y = 0; y < [self.disabledIdentifiers count]; y++) {
			NSString *currentSectionIdentifier = self.enabledIdentifiers[y];
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
						viewController.view.hidden = YES;
						[processedViewControllers addObject:viewController];
					}
				}
			}
		}
		for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
			if (![processedViewControllers containsObject:viewController]) {
				viewController.view.hidden = YES;
			}
		}
	}



	//((UIViewController *)[self valueForKey:@"_airStuffSection"]).view.hidden = YES;
	((UIViewController *)[self valueForKey:@"_auxillaryAirStuffSection"]).view.hidden = YES;
	((UIViewController *)[self valueForKey:@"_brightnessSection"]).view.hidden = YES;
	if (self.isNoctisInstalled)
	self.lqdNightSectionController.view.hidden = YES;
	//((UIViewController *)[self valueForKey:@"_quickLaunchSection"]).view.hidden = YES;
	//((UIViewController *)[self valueForKey:@"_settingsSection"]).view.hidden = YES;

	[self updateCutoutView];
}

%new
- (void)updateCutoutView {
	[self.delegate.view _rerenderPunchThroughMaskIfNecessary];
	// if (!self.maskingView && self.view) {
	// 	CCUIControlCenterPagePlatterView *platterView = [self.view ccuiPunchOutMaskedContainer];
	// 	for (UIView *subview in [platterView subviews]) {
	// 		if ([subview isKindOfClass:NSClassFromString(@"UIImageView")]) {
	// 			self.maskingView = (UIImageView *)subview;
	// 			break;
	// 		}
	// 	}
	// }

	// if (self.maskingView && !self.backgroundCutoutView && self.view) {
	// 	self.backgroundCutoutView = [[UIImageView alloc] initWithFrame:self.maskingView.frame];
	// 	self.backgroundCutoutView.image = self.maskingView.image;
	// 	if (self.maskingView.layer.filters) {
	// 		self.backgroundCutoutView.layer.filters = [self.maskingView.layer.filters copy];
	// 	}
	// 	self.backgroundCutoutView.layer.contentsMultiplyColor = [self.maskingView.layer contentsMultiplyColor];

	// 	[self.view addSubview:self.backgroundCutoutView];
	// 	[self.view sendSubviewToBack:self.backgroundCutoutView];

	// 	self.backgroundCutoutView.translatesAutoresizingMaskIntoConstraints = NO;
	// 	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCutoutView
	// 			                                             attribute:NSLayoutAttributeCenterY
	// 			                                             relatedBy:NSLayoutRelationEqual
	// 			                                                toItem:self.view
	// 			                                             attribute:NSLayoutAttributeCenterY
	// 			                                            multiplier:1
	// 			                                              constant:0]];
	// 	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCutoutView
	// 			                                             attribute:NSLayoutAttributeCenterX
	// 			                                             relatedBy:NSLayoutRelationEqual
	// 			                                                toItem:self.view
	// 			                                             attribute:NSLayoutAttributeCenterX
	// 			                                            multiplier:1
	// 			                                              constant:0]];
	// 	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCutoutView
	// 			                                             attribute:NSLayoutAttributeWidth
	// 			                                             relatedBy:NSLayoutRelationEqual
	// 			                                                toItem:self.view
	// 			                                             attribute:NSLayoutAttributeWidth
	// 			                                            multiplier:1
	// 			                                              constant:0]];
	// 	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundCutoutView
	// 			                                             attribute:NSLayoutAttributeHeight
	// 			                                             relatedBy:NSLayoutRelationEqual
	// 			                                                toItem:self.view
	// 			                                             attribute:NSLayoutAttributeHeight
	// 			                                            multiplier:1
	// 			                                              constant:0]];
	// }
	// if (self.maskingView && self.backgroundCutoutView) {
	// 	self.backgroundCutoutView.image = self.maskingView.image;
	// 	if (self.maskingView.layer.filters) {
	// 		self.backgroundCutoutView.layer.filters = [self.maskingView.layer.filters copy];
	// 	}
	// 	self.backgroundCutoutView.layer.contentsMultiplyColor = [self.maskingView.layer contentsMultiplyColor];
	// }
}

-(void)_updateSectionVisibility:(id)arg1 animated:(BOOL)arg2 {
	%orig;
	//((UIViewController *)[self valueForKey:@"_airStuffSection"]).view.hidden = YES;
	((UIViewController *)[self valueForKey:@"_auxillaryAirStuffSection"]).view.hidden = YES;
	((UIViewController *)[self valueForKey:@"_brightnessSection"]).view.hidden = YES;
	if (self.isNoctisInstalled)
	self.lqdNightSectionController.view.hidden = YES;
	//((UIViewController *)[self valueForKey:@"_nightShiftSection"]).view.hidden = YES;
	//((UIViewController *)[self valueForKey:@"_quickLaunchSection"]).view.hidden = YES;
	//((UIViewController *)[self valueForKey:@"_settingsSection"]).view.hidden = YES;
	[self updateCutoutView];
}

-(UIEdgeInsets)contentInsets {
	return UIEdgeInsetsMake(0,0,0,0);
}

- (void)setLayoutStyle:(NSInteger)style {
	%orig;
	[self.volumeAndBrightnessController.view setLayoutStyle:style];
	[self updateCutoutView];
}

- (void)_updateColumns {
	%orig;
	NSMutableArray *columnStackViews = [[self valueForKey:@"_columnStackViews"] mutableCopy];
	self.volumeAndBrightnessController.view.layoutStyle = self.layoutStyle;
	[(CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"] viewWillAppear:YES];
	[(CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"] viewWillLayoutSubviews];
	[(CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"] viewWillAppear:YES];
	[(CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"] viewWillLayoutSubviews];
	if ([columnStackViews count] == 1) {
		// ((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view.axis = 0;
		// ((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view.axis = 0;
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.volumeAndBrightnessController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.miniMediaPlayerController.view];
		// //[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.volumeAndBrightnessController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.airAndNightController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view];
		NSMutableArray *processedViewControllers = [NSMutableArray new];
		for (int x = 0; x < [self.enabledIdentifiers count]; x++) {
			NSString *currentSectionIdentifier = self.enabledIdentifiers[x];
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
						viewController.view.hidden = NO;
						[processedViewControllers addObject:viewController];
					}
				}
			}
		}
		for (int y = 0; y < [self.disabledIdentifiers count]; y++) {
			NSString *currentSectionIdentifier = self.enabledIdentifiers[y];
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
						viewController.view.hidden = YES;
						[processedViewControllers addObject:viewController];
					}
				}
			}
		}
		for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
			if (![processedViewControllers containsObject:viewController]) {
				viewController.view.hidden = YES;
			}
		}
	} else if ([columnStackViews count] == 2) {
		((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view.axis = 0;
		((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view.axis = 0;
		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view];
		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.volumeAndBrightnessController.view];
		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.airAndNightController.view];
		//[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.brightnessController.view];
		[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view];
		[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.miniMediaPlayerController.view];
	//	[(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:self.volumeAndBrightnessController.view];
		//self.miniMediaPlayerController.view.frame = CGRectMake(0,0,((UIStackView *)[columnStackViews objectAtIndex:0]).frame.size.width,((UIStackView *)[columnStackViews objectAtIndex:0]).frame.size.height);
	} else if ([columnStackViews count] == 3) {
		// ((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view.axis = 1;
		// ((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view.axis = 1;
		// [(UIStackView *)[columnStackViews objectAtIndex:0] addArrangedSubview:((CCUISettingsSectionController *)[self valueForKey:@"_settingsSection"]).view];
		// [(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.miniMediaPlayerController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.volumeAndBrightnessController.view];
		// //[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.brightnessController.view];
		// [(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:((CCUIAirStuffSectionController *)[self valueForKey:@"_airStuffSection"]).view];
		// if (self.isNoctisInstalled) {
		// 	[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.noctisNightModeController.view];
		// } else {
		// 	[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:((CCUINightShiftSectionController *)[self valueForKey:@"_nightShiftSection"]).view];
		// }
		// [(UIStackView *)[columnStackViews objectAtIndex:2] addArrangedSubview:((CCUIQuickLaunchSectionController *)[self valueForKey:@"_quickLaunchSection"]).view];
		// //[(UIStackView *)[columnStackViews objectAtIndex:1] addArrangedSubview:self.airAndNightController.view];
		// ((CCUIAirStuffSectionController *)[self valueForKey:@"_airStuffSection"]).view.mode = 0;
		// // self.airAndNightController.view.hidden = YES;
		// if (self.isNoctisInstalled)
		// self.noctisNightModeController.view.hidden = NO;
		NSMutableArray *processedViewControllers = [NSMutableArray new];
		for (int x = 0; x < [self.enabledIdentifiers count]; x++) {
			NSString *currentSectionIdentifier = self.enabledIdentifiers[x];
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
						viewController.view.hidden = NO;
						[processedViewControllers addObject:viewController];
					}
				}
			}
		}
		for (int y = 0; y < [self.disabledIdentifiers count]; y++) {
			NSString *currentSectionIdentifier = self.enabledIdentifiers[y];
			for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
				if ([(id<CCXSectionControllerDelegate>)[viewController class] respondsToSelector:@selector(sectionIdentifier)]) {
					if ([currentSectionIdentifier isEqualToString:[(id<CCXSectionControllerDelegate>)[viewController class] sectionIdentifier]]) {
						viewController.view.hidden = YES;
						[processedViewControllers addObject:viewController];
					}
				}
			}
		}
		for (UIViewController *viewController in (NSMutableArray *)[self valueForKey:@"_sectionList"]) {
			if (![processedViewControllers containsObject:viewController]) {
				viewController.view.hidden = YES;
			}
		}
	}

	//[self _updateAllSectionVisibilityAnimated:NO];
}
- (void)_updateSectionViews {
	%orig;
	// if (![self.navigationController.view superview] && [self.view superview]) {
	// 	[[self.view superview] addSubview:self.navigationController.view];
	// 	self.navigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
	// 	[[self.view superview] addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationController.view
	// 		                                             attribute:NSLayoutAttributeCenterY
	// 		                                             relatedBy:NSLayoutRelationEqual
	// 		                                                toItem:[self.view superview]
	// 		                                             attribute:NSLayoutAttributeCenterY
	// 		                                            multiplier:1
	// 		                                              constant:0]];
	// 	[[self.view superview] addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationController.view
	// 		                                             attribute:NSLayoutAttributeCenterX
	// 		                                             relatedBy:NSLayoutRelationEqual
	// 		                                                toItem:[self.view superview]
	// 		                                             attribute:NSLayoutAttributeCenterX
	// 		                                            multiplier:1
	// 		                                              constant:0]];
	// 	[[self.view superview] addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationController.view
	// 		                                             attribute:NSLayoutAttributeWidth
	// 		                                             relatedBy:NSLayoutRelationEqual
	// 		                                                toItem:[self.view superview]
	// 		                                             attribute:NSLayoutAttributeWidth
	// 		                                            multiplier:1
	// 		                                              constant:0]];
	// 	[[self.view superview] addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationController.view
	// 		                                             attribute:NSLayoutAttributeHeight
	// 		                                             relatedBy:NSLayoutRelationEqual
	// 		                                                toItem:[self.view superview]
	// 		                                             attribute:NSLayoutAttributeHeight
	// 		                                            multiplier:1
	// 		                                              constant:0]];
	// }
	if (self.airAndNightController) {
		[self addChildViewController:self.airAndNightController];
	}

	[self updateCutoutView];
}

- (void)_dismissButtonActionPlatterWithCompletion:(id)arg1 {
	if ([NSClassFromString(@"SBUIIconForceTouchViewController") _isPeekingOrShowing]) {
		[NSClassFromString(@"SBUIIconForceTouchViewController") _dismissAnimated:YES withCompletionHandler:arg1];
	}
	//%orig;
}

%new
- (void)pushingSettingsController {
	//[self presentViewController:self.settingsViewController animated:YES completion:nil];
	// self.view.hidden = YES;
	// [self.navigationController pushViewController:self.settingsViewController animated:YES];
}
%end

%ctor {
	dlopen("/Library/MobileSubstrate/DynamicLibraries/Noctis.dylib", RTLD_NOW);
	%init;
}