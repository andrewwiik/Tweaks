#import <Preferences/Preferences.h>
@interface AWmusicsListController : PSListController
{
	UIStatusBarStyle prevStatusStyle;
}
-(id)specifiersForPlistName:(NSString *)plistName;
@end