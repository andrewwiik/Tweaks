#import "CBRAppList.h"

#import <objc/runtime.h>

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)allBundleIdentifiers;
@end

@implementation CBRAppList

+ (NSArray *)allAppIdentifiers {
  static NSArray *allAppIdentifiers = nil;
  static dispatch_once_t predicate;

  dispatch_once(&predicate, ^{ 
      NSMutableArray *array = [NSMutableArray array];
      SBApplicationController *controller = [objc_getClass("SBApplicationController") sharedInstance];
      NSSet *hiddenIdentifiers = [self hiddenIdentifiers];

      for (NSString *bundleIdentifier in [controller allBundleIdentifiers]) {
        if (![hiddenIdentifiers containsObject:bundleIdentifier]) {
          [array addObject:bundleIdentifier];
        }
      }

      allAppIdentifiers = [array copy];
  });

  return allAppIdentifiers;
}

+ (NSString *)randomAppIdentifier {
  NSArray *identifiers = [self allAppIdentifiers];
  return identifiers[arc4random() % [identifiers count]];
}

// Thanks to AppList (https://github.com/rpetrich/AppList).
+ (NSSet *)hiddenIdentifiers {
  return [NSSet setWithObjects:
      @"com.apple.AdSheet",
      @"com.apple.AdSheetPhone",
      @"com.apple.AdSheetPad",
      @"com.apple.DataActivation",
      @"com.apple.DemoApp",
      @"com.apple.Diagnostics",
      @"com.apple.fieldtest",
      @"com.apple.iosdiagnostics",
      @"com.apple.iphoneos.iPodOut",
      @"com.apple.TrustMe",
      @"com.apple.WebSheet",
      @"com.apple.springboard",
      @"com.apple.purplebuddy",
      @"com.apple.datadetectors.DDActionsService",
      @"com.apple.FacebookAccountMigrationDialog",
      @"com.apple.iad.iAdOptOut",
      @"com.apple.ios.StoreKitUIService",
      @"com.apple.TextInput.kbd",
      @"com.apple.MailCompositionService",
      @"com.apple.mobilesms.compose",
      @"com.apple.quicklook.quicklookd",
      @"com.apple.ShoeboxUIService",
      @"com.apple.social.remoteui.SocialUIService",
      @"com.apple.WebViewService",
      @"com.apple.gamecenter.GameCenterUIService",
      @"com.apple.appleaccount.AACredentialRecoveryDialog",
      @"com.apple.CompassCalibrationViewService",
      @"com.apple.WebContentFilter.remoteUI.WebContentAnalysisUI",
      @"com.apple.PassbookUIService",
      @"com.apple.uikit.PrintStatus",
      @"com.apple.Copilot",
      @"com.apple.MusicUIService",
      @"com.apple.AccountAuthenticationDialog",
      @"com.apple.MobileReplayer",
      @"com.apple.SiriViewService",
      @"com.apple.TencentWeiboAccountMigrationDialog",
      // iOS 8.
      @"com.apple.AskPermissionUI",
      @"com.apple.CoreAuthUI",
      @"com.apple.family",
      @"com.apple.mobileme.fmip1",
      @"com.apple.GameController",
      @"com.apple.HealthPrivacyService",
      @"com.apple.InCallService",
      @"com.apple.mobilesms.notification",
      @"com.apple.PhotosViewService",
      @"com.apple.PreBoard",
      @"com.apple.PrintKit.Print-Center",
      @"com.apple.share",
      @"com.apple.SharedWebCredentialViewService",
      @"com.apple.webapp",
      @"com.apple.webapp1",
      nil];
}

@end
