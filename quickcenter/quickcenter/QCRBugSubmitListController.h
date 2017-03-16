#import <Preferences/PSListController.h>
#import <Preferences/PSViewController.h>
#import <CrashReport/libcrashreport.h>
#import "../common/crashlog_util.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTextFieldSpecifier.h>
#import <libpackageinfo/libpackageinfo.h>

@interface NSArray ()
- (PSSpecifier *)specifierForID:(NSString *)arg1;
- (void)addObjectsFromArray:(id)arg1;
@end

@interface PSTableCell ()
-(id)tableValue;
@end

@interface PSSpecifier (PSButton)
- (void)setButtonAction:(SEL)action;
@end
@interface QCRBugSubmitListController : PSListController {
	NSUserDefaults *_prefs;
	CRCrashReport *_report;
	NSString *_crashPath;
	NSString *_syslogPath;
}
@end