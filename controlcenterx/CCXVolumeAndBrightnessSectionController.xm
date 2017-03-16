#import "CCXVolumeAndBrightnessSectionController.h"

%subclass CCXVolumeAndBrightnessSectionController : CCUIControlCenterSectionViewController
%property (nonatomic, retain) CCUIControlCenterSlider *slider;
%property (nonatomic, retain) CCUIControlCenterSlider *brightnessSlider;
%property (nonatomic, retain) CCUIControlCenterSlider *volumeSlider;
%property (nonatomic, retain) CCUIBrightnessSectionController *brightnessSectionController;
%property (nonatomic, retain) MPUMediaControlsVolumeView *volumeSectionController;
%property (nonatomic, assign) BOOL isCurrentlyShowingVolume;
%property (nonatomic, retain) UIView *toggleBackgroundView;
%property (nonatomic, retain) CCUIControlCenterButton *toggleButton;
%property (nonatomic, retain) SBUIIconForceTouchController *iconForceTouchController;
%property (nonatomic, retain) SBUIForceTouchGestureRecognizer *forceTouchGestureRecognizer;

+ (Class)viewClass {
	return NSClassFromString(@"CCXVolumeAndBrightnessSectionView");
}

- (id)init {
	CCXVolumeAndBrightnessSectionController *orig = %orig;
	if (orig) {
		self.brightnessSectionController = [[NSClassFromString(@"CCUIBrightnessSectionController") alloc] init];
		self.volumeSectionController = [(MPUMediaControlsVolumeView *)[NSClassFromString(@"MPUMediaControlsVolumeView") alloc] initWithStyle:4];
	}
	return orig;
}

- (void)viewDidLoad {
	%orig;
	[self.brightnessSectionController viewDidLoad];
	self.slider = [[NSClassFromString(@"CCUIControlCenterSlider") alloc] initWithFrame:CGRectZero];
	[self.slider addTarget:self action:@selector(_sliderDidEndTracking:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
	[self.slider addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
	[self.slider addTarget:self action:@selector(_sliderDidBeginTracking:) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:self.slider];
	self.isCurrentlyShowingVolume = YES;
	if (self.slider) {
		if (self.isCurrentlyShowingVolume) {
			[self.slider setValue:self.volumeSectionController.volumeController.volumeValue];
			[self.slider setMaximumValueImage:((CCUIControlCenterSlider *)[self.volumeSectionController valueForKey:@"_slider"]).maximumValueImage];
			//[self.slider setMinimumValueImage:((CCUIControlCenterSlider *)[self.brightnessSectionController valueForKey:@"_slider"]).minimumValueImage];
		} else {
			[self.slider setValue:[self.brightnessSectionController _backlightLevel]];
			[self.slider setMaximumValueImage:((CCUIControlCenterSlider *)[self.brightnessSectionController valueForKey:@"_slider"]).maximumValueImage];
			//[self.slider setMinimumValueImage:((CCUIControlCenterSlider *)[self.volumeSectionController valueForKey:@"_slider"]).minimumValueImage];
		}
	}

	self.brightnessSlider = (CCUIControlCenterSlider *)[self.brightnessSectionController valueForKey:@"_slider"];
	self.volumeSlider = (CCUIControlCenterSlider *)[self.volumeSectionController valueForKey:@"_slider"];
	[self.brightnessSectionController setValue:self.slider forKey:@"_slider"];
	[self.volumeSectionController setValue:self.slider forKey:@"_slider"];
	
	self.toggleButton = [NSClassFromString(@"CCXSliderToggleButton")  smallCircularButtonWithSelectedColor:[UIColor clearColor]];
	//self.nightModeSection.text = [NSString stringWithFormat:@"Mode Théâtre:\nArrêt"];
	//self.nightModeSection.numberOfLines = 2;
	self.toggleButton.selectedGlyphImage = self.volumeSlider.minimumValueImage;
	self.toggleButton.glyphImage = self.brightnessSlider.minimumValueImage;
	[self.toggleButton addTarget:self action:@selector(_handleSliderToggle:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.toggleButton];

	if (CFPreferencesGetAppBooleanValue((CFStringRef)@"HasPrefferedSlider", CFSTR("com.atwiiks.horseshoe"), NULL)) {
		self.isCurrentlyShowingVolume = CFPreferencesGetAppBooleanValue((CFStringRef)@"VolumeIsPrefferedSlider", CFSTR("com.atwiiks.horseshoe"), NULL);
		[self.slider setMaximumValueImage:self.isCurrentlyShowingVolume ? self.volumeSlider.maximumValueImage : self.brightnessSlider.maximumValueImage];
		[self.slider _setValue:self.isCurrentlyShowingVolume ? self.volumeSectionController.volumeController.volumeValue : [self.brightnessSectionController _backlightLevel] andSendAction:NO];
	}

	self.toggleButton.selected = self.isCurrentlyShowingVolume;

	self.forceTouchGestureRecognizer = [[NSClassFromString(@"SBUIForceTouchGestureRecognizer") alloc] initWithTarget:self action:nil];
	self.forceTouchGestureRecognizer.delegate = self;
	self.forceTouchGestureRecognizer.cancelsTouchesInView = YES;
	[self.toggleButton addGestureRecognizer:self.forceTouchGestureRecognizer];

	self.iconForceTouchController = [[NSClassFromString(@"SBUIIconForceTouchController") alloc] init];
	[self.iconForceTouchController setDataSource:self];
	[self.iconForceTouchController setDelegate:self];
	[self.iconForceTouchController startHandlingGestureRecognizer:self.forceTouchGestureRecognizer];
	[NSClassFromString(@"SBUIIconForceTouchController") _addIconForceTouchController:self.iconForceTouchController];
	// self.toggleBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	// self.toggleBackgroundView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
	// [self.view addSubview:self.toggleBackgroundView];
	// [self.view sendSubviewToBack:self.toggleBackgroundView];


}

- (void)viewDidLayoutSubviews {
	CGFloat multiplier = 1;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		multiplier = 1;
	}
	[self.brightnessSectionController viewDidLayoutSubviews];
	if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
		self.slider.frame = CGRectMake(0,[self.brightnessSectionController _yOffsetFromCenterForSlider],self.view.frame.size.width, self.view.frame.size.height);
		self.toggleButton.frame = CGRectMake(self.slider.frame.size.width-35,self.slider.center.y-self.slider.frame.size.height,35,35);
		self.toggleButton.center = CGPointMake(self.toggleButton.center.x,self.slider.center.y);
		self.slider.frame = CGRectMake(0,self.slider.frame.origin.y,self.slider.frame.size.width-self.toggleButton.frame.size.width-3,self.slider.frame.size.height);
	} else {
		self.slider.frame = CGRectMake(0,[self.brightnessSectionController _yOffsetFromCenterForSlider],self.view.frame.size.width, self.view.frame.size.height);
		self.toggleButton.frame = CGRectMake(0,self.slider.center.y-self.slider.frame.size.height,35,35);
		self.toggleButton.center = CGPointMake(self.toggleButton.center.x,self.slider.center.y);
		self.slider.frame = CGRectMake(self.toggleButton.frame.size.width+3,self.slider.frame.origin.y,self.slider.frame.size.width-self.toggleButton.frame.size.width-3,self.slider.frame.size.height);
	}
}

- (void)setDelegate:(id<CCUIControlCenterSectionViewControllerDelegate>)delegate {
	%orig;
	[self.brightnessSectionController setDelegate:delegate];
}

%new
- (void)_sliderDidBeginTracking:(CCUIControlCenterSlider *)slider {
	if (self.isCurrentlyShowingVolume) {
		//[(CCUIControlCend evterSlider *)[self.volumeSectionController valueForKey:@"_slider"] setTracking:[self.slider isTracking]];
		[self.volumeSectionController _volumeSliderBeganChanging:slider];
	} else {
		//[(CCUIControlCenterSlider *)[self.brightnessSectionController valueForKey:@"_slider"] setTracking:[self.slider isTracking]];
		[self.brightnessSectionController _sliderDidBeginTracking:slider];
	}
}
%new
- (void)_sliderDidEndTracking:(CCUIControlCenterSlider *)slider {
	if (self.isCurrentlyShowingVolume) {
		//[(CCUIControlCenterSlider *)[self.volumeSectionController valueForKey:@"_slider"] setTracking:[self.slider isTracking]];
		[self.volumeSectionController _volumeSliderStoppedChanging:slider];
	} else {
		//[(CCUIControlCenterSlider *)[self.brightnessSectionController valueForKey:@"_slider"] setTracking:[self.slider isTracking]];
		[self.brightnessSectionController _sliderDidEndTracking:slider];
	}
}
%new
- (void)_sliderValueDidChange:(CCUIControlCenterSlider *)slider {
	if (self.isCurrentlyShowingVolume) {
		//[(CCUIControlCenterSlider *)[self.volumeSectionController valueForKey:@"_slider"] setTracking:[self.slider isTracking]];
		[self.volumeSectionController _volumeSliderValueChanged:slider];
	} else {
		//[(CCUIControlCenterSlider *)[self.brightnessSectionController valueForKey:@"_slider"] setTracking:[self.slider isTracking]];
		[self.brightnessSectionController _sliderValueDidChange:slider];
	}
}
%new
- (void)_handleSliderToggle:(CCXSliderToggleButton *)toggle {
	//if (self.isCurrentlyShowingVolume != toggle.selected) {
		//self.isCurrentlyShowingVolume = toggle.selected;
		self.isCurrentlyShowingVolume = toggle.selected;
		[self.slider setMaximumValueImage:self.isCurrentlyShowingVolume ? self.volumeSlider.maximumValueImage : self.brightnessSlider.maximumValueImage];
		[self.slider _setValue:toggle.selected ? self.volumeSectionController.volumeController.volumeValue : [self.brightnessSectionController _backlightLevel] andSendAction:NO];
		//self.isCurrentlyShowingVolume = toggle.selected;
	//}
}


/* 3D Touch Delegation */


%new
- (CGRect)iconForceTouchController:(SBUIIconForceTouchController *)arg1 iconViewFrameForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	return [self.view convertRect:self.toggleButton.frame toCoordinateSpace:[[UIScreen mainScreen] fixedCoordinateSpace]];
}

%new
- (NSInteger)iconForceTouchController:(SBUIIconForceTouchController *)arg1 layoutStyleForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	return 0;
}

%new
- (UIView *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 newIconViewCopyForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	
	UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
	backgroundView.layer.cornerRadius = self.toggleButton.frame.size.height/2;
	backgroundView.clipsToBounds = YES;

	UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
	iconView.image = [self.isCurrentlyShowingVolume ? self.volumeSlider.minimumValueImage : self.brightnessSlider.minimumValueImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	//iconView.layer.cornerRadius = ((UIImageView *)[self.view.emptyNowPlayingView valueForKey:@"_appIconImageView"]).layer.cornerRadius;
	//iconView.clipsToBounds = YES;
	iconView.tintColor = [UIColor blackColor];
	[backgroundView addSubview:iconView];
	iconView.translatesAutoresizingMaskIntoConstraints = NO;
	[backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:iconView
		                                                      attribute:NSLayoutAttributeCenterX
		                                                      relatedBy:NSLayoutRelationEqual
		                                                         toItem:backgroundView
		                                                      attribute:NSLayoutAttributeCenterX
		                                                     multiplier:1
		                                                       constant:0]];
	[backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:iconView
		                                                      attribute:NSLayoutAttributeCenterY
		                                                      relatedBy:NSLayoutRelationEqual
		                                                         toItem:backgroundView
		                                                      attribute:NSLayoutAttributeCenterY
		                                                     multiplier:1
		                                                       constant:0]];
	return backgroundView;

}

%new
-(CGFloat)iconForceTouchController:(SBUIIconForceTouchController *)arg1 iconImageCornerRadiusForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	return self.toggleButton.frame.size.height/2;
}

%new
- (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 primaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	NSMutableArray *actions = [NSMutableArray new];

   // SBUIAction can be thought of as an UIApplicationShortcutItem
	NSString *volumeSubtitleText;
	NSString *brightnessSubtitleText;
	NSString *shouldUseDefaultSubtitleText;
	if (CFPreferencesGetAppBooleanValue((CFStringRef)@"HasPrefferedSlider", CFSTR("com.atwiiks.horseshoe"), NULL)) {
		if (CFPreferencesGetAppBooleanValue((CFStringRef)@"VolumeIsPrefferedSlider", CFSTR("com.atwiiks.horseshoe"), NULL)) {
			volumeSubtitleText = @"Enabled";
			brightnessSubtitleText = nil;
			shouldUseDefaultSubtitleText = nil;
		} else {
			volumeSubtitleText = nil;
			brightnessSubtitleText =  @"Enabled";
			shouldUseDefaultSubtitleText = nil;
		}
	} else {
		volumeSubtitleText = nil;
		brightnessSubtitleText =  nil;
		shouldUseDefaultSubtitleText = @"Enabled";
	}
   SBUIAction *volumeSlider = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:@"Use Volume Slider" subtitle:volumeSubtitleText image:self.volumeSlider.maximumValueImage handler:^(void) {
       CFPreferencesSetAppValue((CFStringRef)@"HasPrefferedSlider", (CFPropertyListRef)[NSNumber numberWithBool:YES], CFSTR("com.atwiiks.horseshoe"));
       CFPreferencesSetAppValue ((CFStringRef)@"VolumeIsPrefferedSlider", (CFPropertyListRef)[NSNumber numberWithBool:YES], CFSTR("com.atwiiks.horseshoe"));
       [self.iconForceTouchController _dismissAnimated:YES withCompletionHandler:nil];
   }];
   SBUIAction *brightnessSlider = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:@"Use Brightness Slider" subtitle:brightnessSubtitleText image:self.brightnessSlider.maximumValueImage handler:^(void) {
        CFPreferencesSetAppValue((CFStringRef)@"HasPrefferedSlider", (CFPropertyListRef)[NSNumber numberWithBool:YES], CFSTR("com.atwiiks.horseshoe"));
       CFPreferencesSetAppValue ((CFStringRef)@"VolumeIsPrefferedSlider", (CFPropertyListRef)[NSNumber numberWithBool:NO], CFSTR("com.atwiiks.horseshoe"));
        [self.iconForceTouchController _dismissAnimated:YES withCompletionHandler:nil];
       //[[self delegate] buttonModule:self willExecuteSecondaryActionWithCompletionHandler:nil]; // this must be called to dismiss the 3D Touch Menu
   }];
   SBUIAction *useDefaultSlider = [[NSClassFromString(@"SBUIAction") alloc] initWithTitle:@"No Default Slider" subtitle:shouldUseDefaultSubtitleText image:nil handler:^(void) {
       CFPreferencesSetAppValue((CFStringRef)@"HasPrefferedSlider", (CFPropertyListRef)[NSNumber numberWithBool:NO], CFSTR("com.atwiiks.horseshoe"));
        [self.iconForceTouchController _dismissAnimated:YES withCompletionHandler:nil];
       //[[self delegate] buttonModule:self willExecuteSecondaryActionWithCompletionHandler:nil]; // this must be called to dismiss the 3D Touch Menu
   }];
   [actions addObject:useDefaultSlider];
   [actions addObject:brightnessSlider];
   [actions addObject:volumeSlider];

	return [[NSClassFromString(@"SBUIActionPlatterViewController") alloc] initWithActions:[actions copy] gestureRecognizer:arg2];
}

%new
- (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 secondaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	return nil;
}

%new
- (BOOL)iconForceTouchController:(SBUIIconForceTouchController *)arg1 shouldUseSecureWindowForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	return YES;
}

- (void)controlCenterWillPresent {
	%orig;
	if (self.slider && self.volumeSectionController && self.brightnessSectionController) {
		if (CFPreferencesGetAppBooleanValue((CFStringRef)@"HasPrefferedSlider", CFSTR("com.atwiiks.horseshoe"), NULL)) {
			self.isCurrentlyShowingVolume = CFPreferencesGetAppBooleanValue((CFStringRef)@"VolumeIsPrefferedSlider", CFSTR("com.atwiiks.horseshoe"), NULL);
			[self.slider setMaximumValueImage:self.isCurrentlyShowingVolume ? self.volumeSlider.maximumValueImage : self.brightnessSlider.maximumValueImage];
			[self.slider _setValue:self.isCurrentlyShowingVolume ? self.volumeSectionController.volumeController.volumeValue : [self.brightnessSectionController _backlightLevel] andSendAction:NO];
		}
	}
}

%new
+ (NSString *)sectionIdentifier {
	return @"com.atwiiks.controlcenterx.multi-slider";
}
%new
+ (NSString *)sectionName {
	return @"Multi-Slider";
}
%new
+ (UIImage *)sectionImage {
	return [[UIImage imageNamed:@"Sliders_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
%end

// 0x8cd675a844024379

