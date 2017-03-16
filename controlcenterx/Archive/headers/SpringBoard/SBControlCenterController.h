#import <ControlCenterUI/CCUIControlCenterViewController.h>

@interface SBControlCenterController : NSObject
+ (instancetype)sharedInstance;
- (CCUIControlCenterViewController *)_controlCenterViewController;
@end