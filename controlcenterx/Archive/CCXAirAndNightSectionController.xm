#import "CCXAirAndNightSectionController.h"

%subclass CCXAirAndNightSectionController : CCUIAirStuffSectionController
%property (nonatomic, retain) CCUINightShiftSectionController *nightShiftController;
%property (nonatomic, retain) CCUIControlCenterPushButton *nightShiftSection;
%property (nonatomic, retain) CCUIControlCenterPushButton *nightModeSection;
%property (nonatomic, retain) LQDNightSectionController *nightModeController;
%property (nonatomic, assign) BOOL isNoctisInstalled;

+ (Class)viewClass {
	return NSClassFromString(@"CCXTriButtonLikeSectionSplitView");
}
- (id)init {
	[[NSClassFromString(@"__NSBundleTables") bundleTables] setBundle:[[NSClassFromString(@"__NSBundleTables") bundleTables] bundleForClass:[self superclass]] forClass:[self class]];
	CCXAirAndNightSectionController *orig = %orig;
	if (orig) {
		orig.nightShiftController = [[NSClassFromString(@"CCUINightShiftSectionController") alloc] init];
	}
	return orig;
}
- (void)loadView {
	%orig;
	((CCXTriButtonLikeSectionSplitView *)self.view).mode = 3;
}
- (void)viewDidLoad {
	[self.nightShiftController viewDidLoad];
	if (!self.nightShiftSection) {
		self.nightShiftSection = self.nightShiftController.view.button;
		[self.nightShiftSection removeFromSuperview];
	}
	if (NSClassFromString(@"LQDNightSectionController")) {
		self.isNoctisInstalled = YES;
	}
	if (self.isNoctisInstalled) {
		self.nightModeController = [[NSClassFromString(@"LQDNightSectionController") alloc] init];
		[self.nightModeController setDelegate:[self delegate]];
		[self.nightModeController viewDidLoad];
		self.nightModeSection = self.nightModeController.nightModeSection;
		self.view.secondMiddleSection = self.nightModeSection;

	}
	[self.view setMode:4];
	%orig;
	((CCXTriButtonLikeSectionSplitView *)self.view).middleSection = self.nightShiftSection;
	[self.view layoutSubviews];
}

-(void)viewWillAppear:(BOOL)arg1 {
	[self.nightShiftController viewWillAppear:arg1];
	%orig;
}
-(void)setDelegate:(id<CCUIControlCenterSectionViewControllerDelegate>)delegate {
	%orig;
	[self.nightShiftController setDelegate:delegate];
}
%new
+ (NSString *)sectionIdentifier {
	return @"com.atwiiks.controlcenterx.air-night";
}
%new
+ (NSString *)sectionName {
	return @"Air & Night";
}
%new
+ (UIImage *)sectionImage {
	return [[UIImage imageNamed:@"Button_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
%end