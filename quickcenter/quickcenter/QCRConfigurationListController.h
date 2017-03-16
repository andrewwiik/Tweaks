#import <Preferences/PSListController.h>
#include <spawn.h>
#include <dispatch/dispatch.h>
#import <objc/runtime.h>
#import <sys/sysctl.h>
//@import 
@interface NSArray ()
- (PSSpecifier *)specifierForID:(NSString *)arg1;
- (void)addObjectsFromArray:(id)arg1;
@end

@interface QCRConfigurationListController : PSListController {
	NSMutableArray *_longPressSpecifiers;
    NSMutableArray *_forceTouchSpecifiers;
    NSMutableArray *_longPressLabelSpecifiers;
    NSMutableArray *_forceTouchLabelSpecifiers;
    NSUserDefaults *_prefs;
    BOOL _isForceNative;
}
- (NSString *)platform;
- (BOOL)is6S;
@end