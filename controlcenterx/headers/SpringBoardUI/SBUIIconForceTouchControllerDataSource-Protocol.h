#import <SpringBoardUI/SBUIIconForceTouchController.h>
#import <SpringBoardUI/SBUIForceTouchGestureRecognizer.h>

@protocol SBUIIconForceTouchControllerDataSource <NSObject>
@required
- (CGRect)iconForceTouchController:(SBUIIconForceTouchController *)arg1 iconViewFrameForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (NSInteger)iconForceTouchController:(SBUIIconForceTouchController *)arg1 layoutStyleForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (UIView *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 newIconViewCopyForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 primaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 secondaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;

@optional
- (CGFloat)iconForceTouchController:(SBUIIconForceTouchController *)arg1 iconImageCornerRadiusForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (UIEdgeInsets)iconForceTouchController:(SBUIIconForceTouchController *)arg1 iconImageInsetsForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (id)iconForceTouchController:(SBUIIconForceTouchController *)arg1 parallaxSettingsForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (CGFloat)iconForceTouchController:(SBUIIconForceTouchController *)arg1 wrapperViewCornerRadiusForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (CGPoint)iconForceTouchController:(SBUIIconForceTouchController *)arg1 zoomDownCenterForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (UIView *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 zoomDownViewForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
@end

