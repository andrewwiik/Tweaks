#import <ControlCenterUI/CCUIControlCenterSectionViewControllerDelegate-Protocol.h>
#import "CCUIControlCenterPageContentProviding-Protocol.h"
#import "CCUIControlCenterPageContainerViewController.h"
@interface CCUISystemControlsPageViewController : UIViewController <CCUIControlCenterPageContentProviding, CCUIControlCenterSectionViewControllerDelegate>

- (void)_updateColumns;
- (void)_updateSectionVisibility:(id)arg1 animated:(BOOL)arg2;
- (void)_updateAllSectionVisibilityAnimated:(BOOL)arg1;
- (void)_presentAirDropWithCompletion:(/*^block*/id)arg1;
-(void)controlCenterDidScrollToThisPage:(BOOL)arg1 ;
-(void)controlCenterWillPresent;
-(void)controlCenterDidDismiss;
-(void)controlCenterWillBeginTransition;
-(void)controlCenterDidFinishTransition;
@end