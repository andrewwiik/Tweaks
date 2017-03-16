#import "headers.h"
#import "CCXSettingsPageTableViewController.h"
#import "CCXNoEffectsButton.h"

@interface CCXSettingsPageViewController : UITableViewController
@property (nonatomic, retain) CCUIControlCenterPageContainerViewController *delegate;
@property (nonatomic, retain) _UIVisualEffectLayerConfig *primaryEffectConfig;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) CCXSettingsPageTableViewController *mainViewController;
@property (nonatomic, retain) UIImageView *backgroundCutoutView;
@property (nonatomic, retain) UIImageView *maskingView;
@property (nonatomic, retain) UINavigationController *navigationController;
-(void)controlCenterWillPresent;
-(void)controlCenterDidDismiss;
-(void)controlCenterWillBeginTransition;
-(void)controlCenterDidFinishTransition;
+ (UIFont *)headerFont;
- (void)_layoutHeaderView;
+ (UIImage *)imageFromColor:(UIColor *)color andSize:(CGRect)imgBounds;
- (void)updateCutoutView;
@end