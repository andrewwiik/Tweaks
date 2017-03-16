#import <Preferences/Preferences.h>
@interface AWApolloListController : PSListController
{
	UIStatusBarStyle prevStatusStyle;
}
-(id)specifiersForPlistName:(NSString *)plistName;
@end