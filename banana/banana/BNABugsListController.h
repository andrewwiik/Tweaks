#import <Preferences/PSListController.h>

@interface BNABugsListController : PSListController {
    NSUserDefaults *_prefs;
    NSMutableArray *_symbolicatedReports;
    NSMutableArray *_notSymbolicatedReports;
    NSMutableArray *_blamedReports;
    NSMutableArray *_notBlamedReports;
    NSMutableArray *_crashReports;
}

- (void)loadCrashReports;
@end