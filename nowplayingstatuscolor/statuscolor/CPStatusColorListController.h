#import <Preferences/Preferences.h>
@interface CPStatusColorListController : PSListController
{
	UIStatusBarStyle prevStatusStyle;
}
-(id)specifiersForPlistName:(NSString *)plistName;
@end