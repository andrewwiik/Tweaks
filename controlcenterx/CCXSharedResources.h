#import "ICGTransitionAnimation/ICGNavigationController.h"
#import "CCXSettingsNavigationBar.h"

@interface CCXSharedResources : NSObject {
	ICGNavigationController *_settingsNavigationController;
	CCXSettingsNavigationBar *_settingsNavigationBar;
}
@property (nonatomic, retain) ICGNavigationController *settingsNavigationController;
@property (nonatomic, retain) CCXSettingsNavigationBar *settingsNavigationBar;
+ (instancetype)sharedInstance;
@end