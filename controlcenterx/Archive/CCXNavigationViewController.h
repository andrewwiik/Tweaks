#import "headers.h"

#import "CCXMainControlsPageViewController.h"
#import "CCXSettingsPageViewController.h"
#import "CCXNoEffectsButton.h"
#import "CCXPunchOutView.h"
#import "JVTransitionAnimator.h"
#import "ICGTransitionAnimation/ICGNavigationController.h"
#import "ICGTransitionAnimation/AnimationControllers/ICGLayerAnimation.h"
#import "ICGTransitionAnimation/AnimationControllers/ICGSlideAnimation.h"

@interface CCXNavigationViewController : UIViewController <UINavigationControllerDelegate, CCUIControlCenterPageContentProviding>
@property (nonatomic, retain) _UIVisualEffectLayerConfig *primaryEffectConfig;
@property (nonatomic, retain) ICGNavigationController *navigationController;
@property (nonatomic, retain) CCXMainControlsPageViewController *mainViewController;
@property (nonatomic, retain) CCUIControlCenterPageContainerViewController *delegate;
@property (nonatomic, retain) CCXSettingsPageViewController *settingsViewController;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) WATodayAutoupdatingLocationModel *weatherModel;
@property (nonatomic, retain) UIColor *specialColor;
@property (nonatomic, retain) UIImageView *secondaryBackgroundView;
@property (nonatomic, retain) UIImageView *primaryBackgroundView;
@property (nonatomic, retain) UIImageView *maskingView;
@property (nonatomic, retain) CCUIControlCenterPagePlatterView *platterView;
- (id)init;
- (void)viewDidLoad;
- (void)controlCenterWillPresent;
- (void)controlCenterDidDismiss;
- (void)controlCenterWillBeginTransition;
- (void)controlCenterDidFinishTransition;
- (void)_layoutHeaderView;
- (UIEdgeInsets)contentInsets;
+ (UIFont *)headerFont;
- (void)showSettingsPage;
- (void)_rerenderPunchThroughMaskIfNecessary;
- (UIImageView *)copyOfImageView:(UIImageView *)view;
+ (UIImage *)imageFromColor:(UIColor *)color andSize:(CGRect)imgBounds;
@end