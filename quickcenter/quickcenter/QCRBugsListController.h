#import <Preferences/PSListController.h>

@interface QCRBugsListController : PSListController {
    NSUserDefaults *_prefs;
    NSMutableArray *_symbolicatedReports;
    NSMutableArray *_notSymbolicatedReports;
    NSMutableArray *_blamedReports;
    NSMutableArray *_notBlamedReports;
    NSMutableArray *_crashReports;
}

- (void)loadCrashReports;
- (void)symbolicateReports;
@end