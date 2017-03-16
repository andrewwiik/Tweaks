#import <Preferences/PSListController.h>

@interface NSArray ()
- (PSSpecifier *)specifierForID:(NSString *)arg1;
- (void)addObjectsFromArray:(id)arg1;
@end
@interface PSListController ()
- (void)setPreferenceValue:(id)arg1 forSpecifier:(PSSpecifier *)arg2;
@end
@interface QCRRootListController : PSListController {
	NSUserDefaults *_prefs;
}

@end
