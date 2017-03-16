#import <ControlCenterUI/CCUIControlCenterSectionViewController.h>
#import "CCUISystemControlsPageViewController.h"

@interface CCUIAirStuffSectionController : CCUIControlCenterSectionViewController
@property (nonatomic, retain) CCUIButtonLikeSectionSplitView *view;
@property (assign, nonatomic) CCUISystemControlsPageViewController *delegate;
-(void)_updateForAirDropStateChange;
@end