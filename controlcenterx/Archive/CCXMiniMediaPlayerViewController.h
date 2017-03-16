#import "headers.h"
#import "CCXMiniMediaPlayerMediaControlsView.h"
@class CCXMiniMediaPlayerShortLookViewController;

@interface CCXMiniMediaPlayerViewController : MPUControlCenterMediaControlsViewController <MPUControlCenterMediaControlsViewDelegate, SBUIIconForceTouchControllerDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, retain) CCXMiniMediaPlayerMediaControlsView *view;
@property (nonatomic, retain) SBUIIconForceTouchController *iconForceTouchController;
@property (nonatomic, retain) SBUIForceTouchGestureRecognizer *forceTouchGestureRecognizer;
@property (nonatomic, retain) UIView *forceTouchView;
// @property (nonatomic, retain) SBUIForceTouchGestureRecognizer *emptyNowPlayingForceTouchGestureRecognizer;
// @property (nonatomic, retain) SBUIForceTouchGestureRecognizer *nowPlayingTitleForceTouchGestureRecognizer;
// @property (nonatomic, retain) SBUIForceTouchGestureRecognizer *nowPlayingSubtitleForceTouchGestureRecognizer;
+ (Class)controlsViewClass;
- (CGRect)iconForceTouchController:(SBUIIconForceTouchController *)arg1 iconViewFrameForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (NSInteger)iconForceTouchController:(SBUIIconForceTouchController *)arg1 layoutStyleForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (UIView *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 newIconViewCopyForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 primaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (UIViewController *)iconForceTouchController:(SBUIIconForceTouchController *)arg1 secondaryViewControllerForGestureRecognizer:(SBUIForceTouchGestureRecognizer *)arg2;
- (void)viewDidLoad;
- (BOOL)dismissModalFullScreenIfNeeded;
@end