#import "CCXMiniMediaPlayerSectionController.h"

%subclass CCXMiniMediaPlayerSectionController : CCUIControlCenterSectionViewController
%property (nonatomic, retain) CCXMiniMediaPlayerViewController *mediaControlsViewController;

+ (Class)viewClass {
	return NSClassFromString(@"CCXMiniMediaPlayerSectionView");
}

- (id)init {
	CCXMiniMediaPlayerSectionController *orig = %orig;
	if (orig) {
		orig.mediaControlsViewController = [[NSClassFromString(@"CCXMiniMediaPlayerViewController") alloc] init];
	}
	return orig;
}

- (void)viewDidLoad {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (self.view.frame.size.height == [self.view superview].frame.size.height) {
			CGRect newFrame = self.view.frame;
			newFrame.size.height = newFrame.size.height+24;
			self.view.frame = newFrame;
		}
	}

	// MPULayoutInterpolator *_marginLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
	// [_marginLayoutInterpolator addValue:0 forReferenceMetric:300];
	// [_marginLayoutInterpolator addValue:0 forReferenceMetric:360];
	// [self.mediaControlsViewController.view setValue:_marginLayoutInterpolator forKey:@"_marginLayoutInterpolator"];
	// MPULayoutInterpolator *_landscapeMarginLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
	// [_landscapeMarginLayoutInterpolator addValue:0 forReferenceMetric:552];
	// [_landscapeMarginLayoutInterpolator addValue:0 forReferenceMetric:650];
	// [self.mediaControlsViewController.view setValue:_landscapeMarginLayoutInterpolator forKey:@"_landscapeMarginLayoutInterpolator"];



	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	// 		MPULayoutInterpolator* _artworkNormalContentSizeLayoutInterpolator;
	// MPULayoutInterpolator* _artworkLargeContentSizeLayoutInterpolator;
	// MPULayoutInterpolator* _artworkLandscapePhoneLayoutInterpolator;
		MPULayoutInterpolator *_contentSizeInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[_contentSizeInterpolator addValue:92 forReferenceMetric:300];
		[_contentSizeInterpolator addValue:115 forReferenceMetric:360];
		[self.mediaControlsViewController.view setValue:_contentSizeInterpolator forKey:@"_artworkNormalContentSizeLayoutInterpolator"];
	} else {
		MPULayoutInterpolator *_marginLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[_marginLayoutInterpolator addValue:0 forReferenceMetric:300];
		[_marginLayoutInterpolator addValue:0 forReferenceMetric:360];
		[self.mediaControlsViewController.view setValue:_marginLayoutInterpolator forKey:@"_marginLayoutInterpolator"];
		MPULayoutInterpolator *_landscapeMarginLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[_landscapeMarginLayoutInterpolator addValue:0 forReferenceMetric:552];
		[_landscapeMarginLayoutInterpolator addValue:0 forReferenceMetric:650];
		[self.mediaControlsViewController.view setValue:_landscapeMarginLayoutInterpolator forKey:@"_landscapeMarginLayoutInterpolator"];
	MPULayoutInterpolator *_transportControlsWidthCompactLayoutInterpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[_transportControlsWidthCompactLayoutInterpolator addValue:98 forReferenceMetric:360];
		[self.mediaControlsViewController.view setValue:_transportControlsWidthCompactLayoutInterpolator forKey:@"_transportControlsWidthCompactLayoutInterpolator"];
	}

	[self.mediaControlsViewController viewDidLoad];
	%orig;
	self.view.mediaControlsView = self.mediaControlsViewController.view;
	[self.view addSubview:self.mediaControlsViewController.view];
	[self.mediaControlsViewController.view setDelegate:self.mediaControlsViewController];
}

-(void)viewWillAppear:(BOOL)arg1 {
	[self.mediaControlsViewController viewWillAppear:arg1];
	%orig;
}

-(void)setDelegate:(id<CCUIControlCenterSectionViewControllerDelegate>)delegate {
	%orig;
	[self.mediaControlsViewController setDelegate:[delegate delegate]];
}
- (void)controlCenterDidDismiss {
	%orig;
	if (self.mediaControlsViewController) {
		if (self.mediaControlsViewController.iconForceTouchController) {
			if (self.mediaControlsViewController.iconForceTouchController.state) {
				[self.mediaControlsViewController.iconForceTouchController _dismissAnimated:YES withCompletionHandler:nil];
			}
		}
	}
}

%new
- (BOOL)dismissModalFullScreenIfNeeded {
	if (self.mediaControlsViewController) {
		return [self.mediaControlsViewController dismissModalFullScreenIfNeeded];
	} else return NO;
}

%new
+ (NSString *)sectionIdentifier {
	return @"com.atwiiks.controlcenterx.mini-media-player";
}
%new
+ (NSString *)sectionName {
	return @"Music";
}
%new
+ (UIImage *)sectionImage {
	return [[UIImage imageNamed:@"Music_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
%end