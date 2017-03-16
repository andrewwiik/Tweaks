#import "CCXTriButtonLikeSectionSplitView.h"
#import "headers.h"
// #import "CCUISystemControlsPageViewController.h"
#import "Noctis.h"

@interface CCXAirAndNightSectionController : CCUIAirStuffSectionController
@property (nonatomic, retain) CCXTriButtonLikeSectionSplitView *view;
@property (nonatomic, retain) CCUINightShiftSectionController *nightShiftController;
@property (nonatomic, retain) CCUIControlCenterPushButton *nightShiftSection;
@property (nonatomic, retain) CCUIControlCenterPushButton *nightModeSection;
@property (nonatomic, retain) LQDNightSectionController *nightModeController;
@property (nonatomic, assign) BOOL isNoctisInstalled;
- (void)viewWillAppear:(BOOL)arg1;
- (void)viewDidLoad;

+ (NSString *)sectionIdentifier;
+ (NSString *)sectionName;
+ (UIImage *)sectionImage;
@end