#import "headers.h"
#import "CCXPunchOutView.h"
#import <Flipswitch/FSSwitchPanel.h>
#import <Flipswitch/FSSwitchState.h>
#import "CCXSectionObject.h"
#import "CCXSectionsPanel.h"
#import "CCXSettingsTableViewCell.h"
#import "ICGTransitionAnimation/ICGNavigationController.h"
#import "ICGTransitionAnimation/AnimationControllers/ICGSlideOverAnimation.h"
#import "CCXSharedResources.h"

@interface CCXSettingsPageTableViewController : UITableViewController
@property (nonatomic) CCUIControlCenterPageContainerViewController *delegate;
@property (nonatomic, retain) _UIVisualEffectLayerConfig *primaryEffectConfig;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) NSBundle *templateBundle;
@property (nonatomic, retain) NSString *enabledKey;
@property (nonatomic, retain) NSMutableArray *enabledIdentifiers;
@property (nonatomic, retain) NSString *disabledKey;
@property (nonatomic, retain) NSMutableArray *disabledIdentifiers;
@property (nonatomic, retain) NSArray *allSwitches;
@property (nonatomic, retain) NSString *settingsFile;
@property (nonatomic, retain) NSString *preferencesApplicationID;
@property (nonatomic, retain) NSString *notificationName;
@property (nonatomic, assign) BOOL usingFlipControlCenter;
@property (nonatomic, readonly) NSString *panelName;
- (void)_layoutHeaderView;
@property (nonatomic, retain) NSMutableArray *books;
+ (UIFont *)sectionHeaderFont;
- (NSArray *)arrayForSection:(NSInteger)section;
- (void)_flushSettings;

@end