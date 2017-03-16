#import <ControlCenterUI/CCUIControlCenterSectionViewControllerDelegate-Protocol.h>

@interface CCUISystemControlsPageViewController : UIViewController <CCUIControlCenterSectionViewControllerDelegate>
- (void)_updateColumns;
@end