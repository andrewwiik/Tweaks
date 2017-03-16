#import <ControlCenterUI/CCUIControlCenterSectionViewController.h>
#import <ControlCenterUI/CCUIControlCenterPushButton.h>
#import <ControlCenterUI/CCUINightShiftSectionController.h>

@interface LQDNightSectionController : CCUIControlCenterSectionViewController
@property (nonatomic, retain) CCUINightShiftSectionController *nightShiftController;
@property (nonatomic, retain) CCUIControlCenterPushButton *nightShiftSection;
@property (nonatomic, retain) CCUIControlCenterPushButton *nightModeSection;
@end

@interface CCUISystemControlsPageViewController (LQD)
@property (nonatomic, retain) LQDNightSectionController *lqdNightSectionController;
@end