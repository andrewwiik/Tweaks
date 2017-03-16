#import "CCXSharedResources.h"

@implementation CCXSharedResources
+ (instancetype)sharedInstance
{
	static CCXSharedResources *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
	return _sharedInstance;
}

- (ICGNavigationController *)settingsNavigationController {
	return _settingsNavigationController;
}

- (void)setSettingsNavigationController:(ICGNavigationController *)navigationController {
	_settingsNavigationController = navigationController;
}

- (CCXSettingsNavigationBar *)settingsNavigationBar {
	return _settingsNavigationBar;
}

- (void)setSettingsNavigationBar:(CCXSettingsNavigationBar *)navigationBar {
	_settingsNavigationBar = navigationBar;
}
@end