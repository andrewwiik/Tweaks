#import <Preferences/PSListController.h>
#include <spawn.h>
#include <dispatch/dispatch.h>
#import <objc/runtime.h>
#import <sys/sysctl.h>
#import "../headers.h"
//@import 
@class City;
@interface NSArray ()
- (PSSpecifier *)specifierForID:(NSString *)arg1;
- (void)addObjectsFromArray:(id)arg1;
@end

@interface BNAConfigurationListController : PSListController {
    NSUserDefaults *_prefs;
}
- (void)selectedCity:(City *)city;
@end