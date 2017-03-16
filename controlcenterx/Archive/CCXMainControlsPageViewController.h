#import "CCXAirAndNightSectionController.h"
#import "CCXMiniMediaPlayerSectionController.h"
#import "CCXVolumeAndBrightnessSectionController.h"
#import "CCXSettingsPageViewController.h"
#import "JVTransitionAnimator.h"
#import "CCXMainControlsPageView.h"
#import "Noctis.h"
#import "CCXSectionsPanel.h"
#import "CCXSectionObject.h"

@interface CCXMainControlsPageViewController : CCUISystemControlsPageViewController <UINavigationControllerDelegate, CCUIControlCenterPageContentProviding, CCUIControlCenterSectionViewControllerDelegate>
@property (nonatomic, retain) CCXAirAndNightSectionController *airAndNightController;
@property (nonatomic, retain) CCXMiniMediaPlayerSectionController *miniMediaPlayerController;
@property (nonatomic, retain) CCUIBrightnessSectionController *volumeAndBrightnessController;
@property (nonatomic, retain) LQDNightSectionController *noctisNightModeController;
@property (nonatomic, assign) BOOL isNoctisInstalled;
@property (nonatomic, retain) CCXSettingsPageViewController *settingsViewController;
@property (nonatomic, retain) CCXMainControlsPageViewController *duplicatedViewController;
@property (nonatomic, retain) JVTransitionAnimator *transitionAnimator;
// @property (nonatomic, retain) CCXMainControlsPageView *view;
@property (nonatomic, assign) CGFloat animationProgressValue;
@property (nonatomic, assign) CGFloat animationProgressValueReal;
@property (nonatomic, retain) CCUIControlCenterPageContainerViewController *delegate;
@property (nonatomic, retain) NSBundle *templateBundle;
@property (nonatomic, retain) NSString *enabledKey;
@property (nonatomic, retain) NSMutableArray *enabledIdentifiers;
@property (nonatomic, retain) NSString *disabledKey;
@property (nonatomic, retain) NSMutableArray *disabledIdentifiers;
@property (nonatomic, retain) NSArray *allSwitches;
@property (nonatomic, retain) NSString *settingsFile;
@property (nonatomic, retain) NSString *preferencesApplicationID;
@property (nonatomic, retain) NSString *notificationName;
@property (nonatomic, retain) UIImageView *backgroundCutoutView;
@property (nonatomic, retain) UIImageView *maskingView;
- (void)loadView;
- (CGFloat)requestedPageHeightForHeight:(CGFloat)height;
- (void)_dismissButtonActionPlatterWithCompletion:(id)arg1;
- (void)updateCutoutView;
@end