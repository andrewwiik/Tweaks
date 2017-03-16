#import <Preferences/Preferences.h>
@interface CRDeleteForeverListController : PSListController
{
	UIStatusBarStyle prevStatusStyle;
}
-(id)specifiersForPlistName:(NSString *)plistName;
@end