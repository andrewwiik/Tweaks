#import "CCXSettingsPageViewController.h"

typedef NS_ENUM(NSUInteger, MIIconVariant) {
									// iphone  ipad
	MIIconVariantSmall,				// 29x29   29x29
	MIIconVariantSpotlight,			// 40x40   40x40
	MIIconVariantDefault,			// 62x62   78x78
	MIIconVariantGameCenter,		// 42x42   78x78
	MIIconVariantDocumentFull,		// 37x48   37x48
	MIIconVariantDocumentSmall,		// 37x48   37z48
	MIIconVariantSquareBig,			// 82x82   128x128
	MIIconVariantSquareDefault,		// 62x62   78x78
	MIIconVariantTiny,				// 20x20   20x20
	MIIconVariantDocument,			// 37x48   247x320
	MIIconVariantDocumentLarge,		// 37x48   247x320
	MIIconVariantUnknownGradient,	// 300x150 300x150
	MIIconVariantSquareGameCenter,	// 42x42   42x42
	MIIconVariantUnknownDefault,	// 62x62   78x78

	/*
	 todo: find out what UnknownGradient and UnknownDefault are for.
	 UnknownGradient is a static gradient on iphone, and half of the
	 icon on ipad. UnknownDefault is the same thing as Default.
	*/
};

//[self.navigationController pushViewController:self.settingsViewController animated:YES];



%subclass CCXSettingsPageViewController : UIViewController
%property (nonatomic, retain) CCUIControlCenterPageContainerViewController *delegate;
%property (nonatomic, retain) _UIVisualEffectLayerConfig *primaryEffectConfig;
%property (nonatomic, retain) UIView *headerView;
%property (nonatomic, retain) CCXSettingsPageTableViewController *mainViewController;
%property (nonatomic, retain) ICGNavigationController *navigationController;
%property (nonatomic, retain) CCXSettingsNavigationBar *navigationBar;
%new
-(void)controlCenterWillPresent {
	return;
}
%new
-(void)controlCenterDidDismiss {
	return;
}
%new
-(void)controlCenterWillBeginTransition {
	return;
}
%new
-(void)controlCenterDidFinishTransition{
	return;
}

%new
-(UIEdgeInsets)contentInsets {
	return UIEdgeInsetsMake(0,0,0,0);
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
- (void)updateCutoutView {
	self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
	self.view.layer.contentsMultiplyColor = [[UIColor colorWithWhite:1 alpha:0.5] CGColor];
}

- (void)loadView {
	%orig;
	self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
	self.view.layer.contentsMultiplyColor = [[UIColor colorWithWhite:1 alpha:0.5] CGColor];
}

- (void)viewDidLoad {
	%orig;
	self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
	self.view.layer.contentsMultiplyColor = [[UIColor colorWithWhite:1 alpha:0.5] CGColor];

	self.mainViewController = [[NSClassFromString(@"CCXSettingsPageTableViewController") alloc] initWithStyle:UITableViewStyleGrouped];
	self.navigationController = [[ICGNavigationController alloc] initWithRootViewController:self.mainViewController];
	self.navigationController.navigationBarHidden = YES;

	[CCXSharedResources sharedInstance].settingsNavigationController = self.navigationController;

	ICGLayerAnimation *layerAnimation = [[ICGSlideOverAnimation alloc] initWithType:ICGLayerAnimationCover];
  	self.navigationController.animationController = layerAnimation;

	//self.mainViewController.navigationController = self.navigationController;
	//self.navigationController.delegate = self;
	[self.view addSubview:self.navigationController.view];
	//[self addChildViewController:self.mainViewController];
	// [self.view addSubview:self.mainViewController.view];
     CCUIControlCenterVisualEffect *effect = [NSClassFromString(@"CCUIControlCenterVisualEffect")  _primaryRegularTextOnPlatterEffect];
    _UIVisualEffectConfig *effectConfig = [effect effectConfig];
   	self.primaryEffectConfig = effectConfig.contentConfig;
   	[self _layoutHeaderView];
   	if (self.delegate) {
   		self.delegate.view.layer.cornerRadius = 13;
   		self.delegate.view.clipsToBounds = YES;
   		[self.mainViewController setDelegate:self.delegate];
   		//[self.delegate.view _rerenderPunchThroughMaskIfNecessary];
   	}
	// self.view.layer.cornerRadius = 13;
	// self.view.clipsToBounds = YES;
}

- (void)viewDidAppear:(BOOL)arg1 {
	%orig;
	[self updateCutoutView];
}

-(void)viewWillLayoutSubviews {
	%orig;
	[self updateCutoutView];
}

%new
- (void)_layoutHeaderView {
	if (!self.navigationBar) {
		
		self.navigationBar = [[NSClassFromString(@"CCXSettingsNavigationBar") alloc] initWithFrame:CGRectZero];
		((CCXSharedResources *)[NSClassFromString(@"CCXSharedResources") sharedInstance]).settingsNavigationBar = self.navigationBar;

		self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:self.navigationBar];

		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:nil
		                                             attribute:NSLayoutAttributeNotAnAttribute
		                                             multiplier:1
		                                               constant:36]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar
		                                             attribute:NSLayoutAttributeTop
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.view
		                                             attribute:NSLayoutAttributeTop
		                                             multiplier:1
		                                               constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar
		                                             attribute:NSLayoutAttributeWidth
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.view
		                                             attribute:NSLayoutAttributeWidth
		                                             multiplier:1
		                                               constant:0]];

		self.navigationController.view.translatesAutoresizingMaskIntoConstraints = NO;

		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationController.view
		                                             attribute:NSLayoutAttributeTop
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.view
		                                             attribute:NSLayoutAttributeTop
		                                             multiplier:1
		                                               constant:36]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationController.view
		                                             attribute:NSLayoutAttributeLeft
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.view
		                                             attribute:NSLayoutAttributeLeft
		                                             multiplier:1
		                                               constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationController.view
		                                             attribute:NSLayoutAttributeRight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.view
		                                             attribute:NSLayoutAttributeRight
		                                             multiplier:1
		                                               constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationController.view
		                                             attribute:NSLayoutAttributeBottom
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:self.view
		                                             attribute:NSLayoutAttributeBottom
		                                             multiplier:1
		                                               constant:0]];


	// CGFloat dummyViewHeight = 40;
	// UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainViewController.tableView.bounds.size.width, dummyViewHeight)];
	// self.navigationBar.frame = CGRectMake(0,0,self.view.frame.size.width, 36);
	// self.mainViewController.tableView.tableHeaderView = self.navigationBar;
	// self.mainViewController.tableView.contentInset = UIEdgeInsetsMake(36, 0, 0, 0);
	}
}

- (void)viewWillAppear:(BOOL)willAppear {
	%orig;
	[self updateCutoutView];
}

-(void)viewDidLayoutSubviews {
	%orig;
	[self updateCutoutView];
}
-(void)viewDidMoveToWindow:(id)arg1 shouldAppearOrDisappear:(BOOL)arg2  {
	%orig;
	[self updateCutoutView];
}
-(void)viewWillMoveToWindow:(id)arg1 {
	%orig;
	[self updateCutoutView];
}
-(void)viewWillTransitionToSize:(CGSize)arg1 withTransitionCoordinator:(id)arg2 {
	%orig;
	[self updateCutoutView];
}
%new
+ (UIFont *)headerFont {
	UIFontDescriptor *descriptor = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote] fontDescriptorWithFamily:@".SFUIText"];
	descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitCondensed];
	return [UIFont fontWithDescriptor:descriptor size:0];
// 	return [UIFont fontWithName:@".SFUIText" size:font.pointSize-1*[UIScreen mainScreen].scale) traits:[font traits]];
}
%end