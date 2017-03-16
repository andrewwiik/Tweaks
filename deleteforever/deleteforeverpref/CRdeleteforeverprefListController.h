#import <Preferences/Preferences.h>
@interface CRdeleteforeverprefListController : PSListController
{
	UIStatusBarStyle prevStatusStyle;
}
-(id)specifiersForPlistName:(NSString *)plistName;
@end