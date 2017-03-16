#import <Preferences/Preferences.h>
@interface CRKeyForceListController : PSListController
{
	UIStatusBarStyle prevStatusStyle;
}
-(id)specifiersForPlistName:(NSString *)plistName;
@end