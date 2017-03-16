#import "CCXMiniMediaPlayerViewController.h"
#import "CCXMiniMediaPlayerShortLookViewController.h"

%subclass CCXMiniMediaPlayerViewController : MPUControlCenterMediaControlsViewController <MPUControlCenterMediaControlsViewDelegate, SBUIIconForceTouchControllerDataSource, UIGestureRecognizerDelegate>
%property (nonatomic, retain) SBUIIconForceTouchController *iconForceTouchController;
%property (nonatomic, retain) SBUIForceTouchGestureRecognizer *forceTouchGestureRecognizer;
%property (nonatomic, retain) UILongPressGestureRecognizer *longPressGestureRecognizer;
%property (nonatomic, retain) UIView *forceTouchView;
// %property (nonatomic, retain) SBUIForceTouchGestureRecognizer *emptyNowPlayingForceTouchGestureRecognizer;
// %property (nonatomic, retain) SBUIForceTouchGestureRecognizer *nowPlayingTitleForceTouchGestureRecognizer;
// %property (nonatomic, retain) SBUIForceTouchGestureRecognizer *nowPlayingSubtitleForceTouchGestureRecognizer;

+ (Class)controlsViewClass {
	return NSClassFromString(@"CCXMiniMediaPlayerMediaControlsView");
}

%new
- (CGRect)iconForceTouchController:(SBUIIconForceTouchController *)arg1 iconViewFrameForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	if (self.view.emptyNowPlayingView.hidden == YES) {
		return [self.view convertRect:self.view.artworkView.frame toCoordinateSpace:[[UIScreen mainScreen] fixedCoordinateSpace]];
	} else {
		return [self.view convertRect:((UIImageView *)[self.view.emptyNowPlayingView valueForKey:@"_appIconImageView"]).frame toCoordinateSpace:[[UIScreen mainScreen] fixedCoordinateSpace]];
	}
}

%new
- (NSInteger)iconForceTouchController:(SBUIIconForceTouchController *)arg1 layoutStyleForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	return 1;
}

%new
- (BOOL)iconForceTouchController:(SBUIIconForceTouchController *)arg1 shouldUseSecureWindowForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	return YES;
}

%new
- (UIView *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 newIconViewCopyForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
	if (self.view.emptyNowPlayingView.hidden == YES) {
		iconView.image = [[self.view artworkView] artworkImage];
		iconView.layer.cornerRadius = [(UIImageView *)[[self.view artworkView] valueForKey:@"_artworkImageView"] layer].cornerRadius;
	} else {
		iconView.image = ((UIImageView *)[self.view.emptyNowPlayingView valueForKey:@"_appIconImageView"]).image;
		iconView.layer.cornerRadius = ((UIImageView *)[self.view.emptyNowPlayingView valueForKey:@"_appIconImageView"]).layer.cornerRadius;
	}
	iconView.clipsToBounds = YES;
	return iconView;

	//return [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
}

%new
-(CGFloat)iconForceTouchController:(SBUIIconForceTouchController *)arg1 iconImageCornerRadiusForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	return [(UIImageView *)[[self.view artworkView] valueForKey:@"_artworkImageView"] layer].cornerRadius;
}

%new
- (BOOL)dismissModalFullScreenIfNeeded {
	if(self.iconForceTouchController.state != 0) {
		[self.iconForceTouchController _dismissAnimated:YES withCompletionHandler:nil];
		return YES;
	}
	return NO;
}

%new
- (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 primaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	// return nil;
	CCXMiniMediaPlayerShortLookViewController *controller = [[NSClassFromString(@"CCXMiniMediaPlayerShortLookViewController") alloc] init];
	//[controller.view setUseCompactStyle:NO];
	//[controller.view setLayoutStyle:0];
	// if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	// 	[controller.view setLayoutStyle:0];
	// }
	[controller setDelegate:[self delegate]];
	// if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	// 	[controller.view setLayoutStyle:0];
	// }
	controller.view.frame = CGRectMake(0,0,[controller.view intrinsicContentSize].width,[controller.view intrinsicContentSize].height);
	//[controller.view layoutSubviews];
	// controller.fakeContentSize = YES;
	return controller;

	// CCXTestViewController *controller = [[CCXTestViewController alloc] init];
	// [controller loadView];
	// return controller;

// 	CCXPopupControlCenterMediaControlsViewController *controller = [[NSClassFromString(@"CCXPopupControlCenterMediaControlsViewController") alloc] init];
// 	[controller.view setUseCompactStyle:NO];
// 	//[controller setDelegate:[[self valueForKey:@"_viewDelegate"] valueForKey:@"_delegate"]];
// 	controller.view.frame = CGRectMake(0,0,[controller.view intrinsicContentSize].width,[controller.view intrinsicContentSize].height);
// 	[controller.view layoutSubviews];
// 	controller.fakeContentSize = YES;
// 	return controller;
// }
}

%new
- (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 secondaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2 {
	return nil;
	// CCXMiniMediaPlayerShortLookViewController *controller = [[NSClassFromString(@"CCXMiniMediaPlayerShortLookViewController") alloc] init];
	// [controller.view setUseCompactStyle:NO];
	// //[controller setDelegate:[[self valueForKey:@"_viewDelegate"] valueForKey:@"_delegate"]];
	// controller.view.frame = CGRectMake(0,0,[controller.view intrinsicContentSize].width,[controller.view intrinsicContentSize].height);
	// [controller.view layoutSubviews];
	// controller.fakeContentSize = YES;
	// return controller;

	// CCXPopupControlCenterMediaControlsViewController *controller = [[NSClassFromString(@"CCXPopupControlCenterMediaControlsViewController") alloc] init];
	// [controller.view setUseCompactStyle:NO];
	// //[controller setDelegate:[[self valueForKey:@"_viewDelegate"] valueForKey:@"_delegate"]];
	// controller.view.frame = CGRectMake(0,0,[controller.view intrinsicContentSize].width,[controller.view intrinsicContentSize].height);
	// [controller.view layoutSubviews];
	// controller.fakeContentSize = YES;
	// return controller;
	// CCXTestViewController *controller = [CCXTestViewController alloc] init];
	// [controller loadView];
	// return controller;
}

- (void)viewDidLoad {
	%orig;
	// [self.view addSubview:self.forceTouchView];
	// self.forceTouchView.translatesAutoresizingMaskIntoConstraints = NO;
	// [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forceTouchView
	// 	                                               	attribute:NSLayoutAttributeTop
	// 	                                                relatedBy:NSLayoutRelationEqual
	// 	                                                   toItem:self.view.emptyNowPlayingView
	// 	                                                attribute:NSLayoutAttributeTop
	// 	                                               multiplier:1
	// 	                                                 constant:0]];
	// [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forceTouchView
	// 	                                               	attribute:NSLayoutAttributeBottom
	// 	                                                relatedBy:NSLayoutRelationEqual
	// 	                                                   toItem:self.view.emptyNowPlayingView
	// 	                                                attribute:NSLayoutAttributeBottom
	// 	                                               multiplier:1
	// 	                                                 constant:0]];
	// [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forceTouchView
	// 	                                               	attribute:NSLayoutAttributeLeft
	// 	                                                relatedBy:NSLayoutRelationEqual
	// 	                                                   toItem:self.view.emptyNowPlayingView
	// 	                                                attribute:NSLayoutAttributeLeft
	// 	                                               multiplier:1
	// 	                                                 constant:0]];
	// [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.forceTouchView
	// 	                                               	attribute:NSLayoutAttributeRight
	// 	                                                relatedBy:NSLayoutRelationEqual
	// 	                                                   toItem:self.view.emptyNowPlayingView
	// 	                                                attribute:NSLayoutAttributeRight
	// 	                                               multiplier:1
	// 	                                                 constant:0]];

	self.forceTouchGestureRecognizer = [[NSClassFromString(@"SBUIForceTouchGestureRecognizer") alloc] initWithTarget:self action:nil];
	self.forceTouchGestureRecognizer.delegate = self;
	self.forceTouchGestureRecognizer.cancelsTouchesInView = YES;
	[self.view addGestureRecognizer:self.forceTouchGestureRecognizer];

	//self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];

	// self.emptyNowPlayingForceTouchGestureRecognizer = [[NSClassFromString(@"SBUIForceTouchGestureRecognizer") alloc] initWithTarget:self action:nil];
	// self.emptyNowPlayingForceTouchGestureRecognizer.delegate = self;
	// [[self.view emptyNowPlayingView] addGestureRecognizer:self.femptyNowPlayingForceTouchGestureRecognizer];

	// self.nowPlayingTitleForceTouchGestureRecognizer = [[NSClassFromString(@"SBUIForceTouchGestureRecognizer") alloc] initWithTarget:self action:nil];
	// self.nowPlayingTitleForceTouchGestureRecognizer.delegate = self;
	// [(UIView *)[self.view valueForKey:@"_titleLabel"] addGestureRecognizer:self.nowPlayingTitleForceTouchGestureRecognizer];

	// self.forceTouchGestureRecognizer = [[NSClassFromString(@"SBUIForceTouchGestureRecognizer") alloc] initWithTarget:self action:nil];
	// self.forceTouchGestureRecognizer.delegate = self;
	// [(UIView *)[self.view valueForKey:@"_artistAlbumConcatenatedLabel"] addGestureRecognizer:self.forceTouchGestureRecognizer];

	self.iconForceTouchController = [[NSClassFromString(@"SBUIIconForceTouchController") alloc] init];
	[self.iconForceTouchController setDataSource:self];
	[self.iconForceTouchController setDelegate:self];
	[self.iconForceTouchController startHandlingGestureRecognizer:self.forceTouchGestureRecognizer];
	[NSClassFromString(@"SBUIIconForceTouchController")_addIconForceTouchController:self.iconForceTouchController];
}

- (NSArray *)allowedTransportControlTypes {
	self.view.fakeCompactStyle = YES;
	NSArray *orig = %orig;
	self.view.fakeCompactStyle = NO;
	return orig;
}

- (NSUInteger)_currentLayoutStyle {
	return 0;
}

%new
- (void)openManually {
	[self.iconForceTouchController _setupWithGestureRecognizer:self.forceTouchGestureRecognizer];
	[self.iconForceTouchController _presentAnimated:YES withCompletionHandler:nil];
}
%end