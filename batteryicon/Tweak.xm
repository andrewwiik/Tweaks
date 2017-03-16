#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_1_2
#define kCFCoreFoundationVersionNumber_iOS_7_1_2 847.27
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
#define kCFCoreFoundationVersionNumber_iOS_8_0 1140.10
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_1_1
#define kCFCoreFoundationVersionNumber_iOS_8_1_1 1145.15 
#endif

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define CURRENT_INTERFACE_ORIENTATION iPad ? [[UIApplication sharedApplication] statusBarOrientation] : [[UIApplication sharedApplication] activeInterfaceOrientation]

#define iOS8 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0 \
&& kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_8_1_1

#define iOS7 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0 \
&& kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_7_1_2

@class SBIconView;
@interface UIWebClip : NSObject
@property (nonatomic, retain) UIImage *iconImage;
+ (id)_contentForMetaName:(id)arg1 inWebDocumentView:(id)arg2;
+ (BOOL)_webClipFullScreenValueForMetaTagContent:(id)arg1;
+ (id)_webClipLinkTagsFromWebDocumentView:(id)arg1;
+ (unsigned int)_webClipOrientationsForMetaTagContent:(id)arg1;
+ (int)_webClipStatusBarStyleForMetaTagContent:(id)arg1;
+ (BOOL)bundleIdentifierContainsWebClipIdentifier:(id)arg1;
+ (id)pathForWebClipCacheWithIdentifier:(id)arg1;
+ (id)pathForWebClipStorageWithIdentifier:(id)arg1;
+ (id)pathForWebClipWithIdentifier:(id)arg1;
+ (id)urlForWebClipWithIdentifier:(id)arg1;
+ (BOOL)webClipClassicModeValueForWebDocumentView:(id)arg1;
+ (BOOL)webClipFullScreenValueForWebDocumentView:(id)arg1;
+ (id)webClipIconsForWebClipLinkTags:(id)arg1 pageURL:(id)arg2;
+ (id)webClipIconsForWebDocumentView:(id)arg1;
+ (id)webClipIdentifierFromBundleIdentifier:(id)arg1;
+ (unsigned int)webClipOrientationsForWebDocumentView:(id)arg1;
+ (int)webClipStatusBarStyleForWebDocumentView:(id)arg1;
+ (id)webClipTitleForWebDocumentView:(id)arg1;
+ (id)webClipWithIdentifier:(id)arg1;
+ (id)webClipWithURL:(id)arg1;
+ (id)webClips;
+ (id)webClipsDirectoryPath;

- (id)_bundleImageWithName:(id)arg1;
- (id)_bundleResourceWithName:(id)arg1;
- (id)_info;
- (id)_initWithIdentifier:(id)arg1;
- (void)_reloadProperties;
- (void)_setIconImage:(id)arg1 isPrecomposed:(BOOL)arg2 isScreenShotBased:(BOOL)arg3;
- (BOOL)_writeImage:(id)arg1 toDiskWithFileName:(id)arg2;
- (id)bundleIdentifier;
- (void)cancelMediaUpdate;
- (BOOL)classicMode;
- (void)configureWithMetaTags:(id)arg1 linkTags:(id)arg2;
- (void)connection:(id)arg1 didFailWithError:(id)arg2;
- (void)connection:(id)arg1 didReceiveData:(id)arg2;
- (void)connection:(id)arg1 didReceiveResponse:(id)arg2;
- (void)connectionDidFinishLoading:(id)arg1;
- (BOOL)createOnDisk;
- (void)dealloc;
- (id)delegate;
- (BOOL)fullScreen;
- (id)generateIconImageForFormat:(int)arg1 scale:(float)arg2;
- (id)getStartupImage:(int)arg1;
- (id)iconImage;
- (id)iconImagePath;
- (BOOL)iconIsPrecomposed;
- (BOOL)iconIsPrerendered;
- (BOOL)iconIsScreenShotBased;
- (id)icons;
- (id)identifier;
- (id)initialLaunchImage;
- (id)pageURL;
- (BOOL)removalDisallowed;
- (BOOL)removeFromDisk;
- (void)requestCustomIconUpdate;
- (void)requestCustomLandscapeStartupImageUpdate;
- (void)requestCustomPortraitStartupImageUpdate;
- (void)requestIconUpdateInSpringBoard;
- (void)setClassicMode:(BOOL)arg1;
- (void)setDelegate:(id)arg1;
- (void)setFullScreen:(BOOL)arg1;
- (void)setIconImage:(id)arg1 isPrecomposed:(BOOL)arg2;
- (void)setIconImageFromScreenshot:(id)arg1;
- (void)setIcons:(id)arg1;
- (void)setIdentifier:(id)arg1;
- (void)setInitialLaunchImage:(id)arg1;
- (void)setPageURL:(id)arg1;
- (void)setRemovalDisallowed:(BOOL)arg1;
- (void)setStartupImage:(id)arg1;
- (void)setStartupImageURL:(id)arg1;
- (void)setStartupLandscapeImage:(id)arg1;
- (void)setStartupLandscapeImageURL:(id)arg1;
- (void)setStatusBarStyle:(int)arg1;
- (void)setSupportedOrientations:(unsigned int)arg1;
- (void)setTitle:(id)arg1;
- (id)startupImage;
- (id)startupImageURL;
- (id)startupLandscapeImage;
- (id)startupLandscapeImageURL;
- (int)statusBarStyle;
- (void)stopLoadingCustomIcon;
- (void)stopLoadingStartupImage;
- (void)stopLoadingStartupLandscapeImage;
- (unsigned int)supportedOrientations;
- (id)title;
- (BOOL)tryLoadingNextCustomIcon;
- (void)updateCustomMediaLocationsFromWebDocumentView:(id)arg1;
- (void)updateCustomMediaLocationsWithWebClipLinkTags:(id)arg1 baseURL:(id)arg2;
- (BOOL)updateOnDisk;
@end

@interface SBIcon : NSObject
- (void)reloadIconImage;
- (id)application;
@end

@interface SBLeafIcon : SBIcon
- (id)initWithLeafIdentifier:(id)leafIdentifier applicationBundleID:(id)anId;
- (NSString *)leafIdentifier;
- (BOOL)launchEnabled;
- (NSString *)displayName;
- (id)generateIconImage:(int)image;
@end

@interface SBBookmark : NSObject
@property (nonatomic,retain,readonly) NSString * identifier;
-(id)initWithWebClip:(UIWebClip *)arg1;
@end

@interface SBBookmarkIcon : SBLeafIcon
+ (id)homescreenMap;
- (id)initWithBookmark:(SBBookmark *)arg1;
- (UIWebClip *)webClip;
@end

@interface SBIconModel : NSObject
- (void)addIcon:(id)icon;
- (id)addBookmarkIconForWebClip:(id)webClip;
- (NSMutableDictionary *)leafIconsByIdentifier;
@end

@interface SBUIController : NSObject
- (void)finishLaunching;
- (BOOL)doesBatteryIconExist;
- (BOOL)isBatteryIconEnabled;
- (BOOL)isBatteryCharging;
@end

@interface SBIconController : NSObject
+ (id)sharedInstance;
- (void)addNewIconToDesignatedLocation:(id)designatedLocation animate:(BOOL)animate scrollToList:(BOOL)list saveIconState:(BOOL)state;
- (void)iconTapped:(id)icon;
-(BOOL)canAddWebClip:(id)arg1;
-(void)uninstallIcon:(id)icon;
-(void)uninstallIcon:(SBIcon *)arg1 animate:(BOOL)arg2;
@end
@interface SBIconView : UIView
-(void)_updateIconImageViewAnimated:(BOOL)arg1;
@end
@interface SBIconImageView : UIView
-(void)iconImageDidUpdate:(UIImage *)iconImage;
-(id)squareContentsImage;
@property(readonly, retain, nonatomic) SBBookmarkIcon* icon;
- (SBBookmarkIcon *)icon;
@end
@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(id)arg1;
@end
SBBookmarkIcon* batteryBookmarkIcon;
UIWebClip* BatteryIcon;
static BOOL enabled;
%hook SBUIController
- (void)finishLaunching {
    %orig;
    [NSTimer scheduledTimerWithTimeInterval:5 target:(self) selector:@selector(updateBatteryIcon) userInfo:nil repeats:YES];
    if ([self isBatteryIconEnabled] == YES) {
        UIDevice *myDevice = [UIDevice currentDevice];
        [myDevice setBatteryMonitoringEnabled:YES];
        double batLeft = (float)[myDevice batteryLevel] * 100;
        SBIconController *iconController = [%c(SBIconController) sharedInstance];
        UIWebClip *BatteryIcon = [[UIWebClip alloc] _initWithIdentifier:@"com.creatix.batteryicon"];
        [BatteryIcon setPageURL:[NSURL URLWithString:@"prefs:root=General&path=USAGE/BATTERY_USAGE"]];
        [BatteryIcon setTitle:@"Battery"];
        [BatteryIcon setRemovalDisallowed:TRUE];
        if ([self isBatteryCharging]) {
            if (batLeft <= 100 && batLeft > 90) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging100.png"] isPrecomposed:FALSE];
}
if (batLeft <= 90 && batLeft > 80) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging90.png"] isPrecomposed:FALSE];
}
if (batLeft <= 80 && batLeft > 70) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging80.png"] isPrecomposed:FALSE];
}
if (batLeft <= 70 && batLeft > 60) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging70.png"] isPrecomposed:FALSE];
}
if (batLeft <= 60 && batLeft > 50) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging60.png"] isPrecomposed:FALSE];
}
if (batLeft <= 50 && batLeft > 40) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging50.png"] isPrecomposed:FALSE];
}
if (batLeft <= 40 && batLeft > 30) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging40.png"] isPrecomposed:FALSE];
}
if (batLeft <= 30 && batLeft > 20) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging30.png"] isPrecomposed:FALSE];
}
if (batLeft <= 20 && batLeft > 10) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging20.png"] isPrecomposed:FALSE];
}
if (batLeft <= 10 && batLeft >= 0) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging10.png"] isPrecomposed:FALSE];
}
        }
        else {
            if (batLeft <= 100 && batLeft > 90) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery100.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 90 && batLeft > 80) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery90.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 80 && batLeft > 70) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery80.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 70 && batLeft > 60) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery70.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 60 && batLeft > 50) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery60.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 50 && batLeft > 40) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery50.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 40 && batLeft > 30) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery40.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 30 && batLeft > 20) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery30.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 20 && batLeft > 10) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery20.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 10 && batLeft >= 0) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery10.png"] isPrecomposed:FALSE];
            }
        }
    NSLog(@"Deleting the Fuckin Icon");
     SBBookmark *batteryBookmark = [[%c(SBBookmark) alloc] initWithWebClip: BatteryIcon];
     [iconController uninstallIcon:batteryBookmarkIcon];
     SBBookmarkIcon *batteryBookmarkIcon = [[%c(SBBookmarkIcon) alloc] initWithBookmark: batteryBookmark];
     [(SBIconModel *)[iconController valueForKey:@"_iconModel"] addIcon:batteryBookmarkIcon];
    [iconController addNewIconToDesignatedLocation:batteryBookmarkIcon animate:YES scrollToList:NO saveIconState:YES];
}
}
%new
-(void)updateBatteryIcon {
    if ([self isBatteryIconEnabled] == YES) {
        if ([self doesBatteryIconExist] == YES) {
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    double batLeft = (float)[myDevice batteryLevel] * 100;
    SBIconController *iconController = [%c(SBIconController) sharedInstance];
    SBIconModel *AWIconModel = [iconController valueForKey:@"_iconModel"];
    NSMutableDictionary *AWIconDictionary = [AWIconModel leafIconsByIdentifier];
    SBBookmarkIcon *AWBookmarkIcon = [AWIconDictionary objectForKey:@"com.creatix.batteryicon"];
    NSHashTable *batteryIconHashTable = MSHookIvar<id>(AWBookmarkIcon, "_observers");
    NSLog(@"hashTable:%@", [batteryIconHashTable allObjects]);
    NSArray *batteryIconViews = [batteryIconHashTable allObjects];
    NSLog(@"%@", batteryIconViews);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isMemberOfClass: %@", [NSClassFromString(@"SBIconImageView") class]];
    NSArray *filteredData = [batteryIconViews filteredArrayUsingPredicate:predicate];
if (![filteredData count])
{
}
else {
    NSLog(@"%@", filteredData);
    SBIconImageView *AWBatteryViewImage = [filteredData objectAtIndex:0];
    NSLog(@"%@", AWBatteryViewImage);
    if ([self isBatteryCharging]) {
        if (batLeft <= 100 && batLeft > 90) {
    [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging100.png"] isPrecomposed:FALSE];
}
if (batLeft <= 90 && batLeft > 80) {
    [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging90.png"] isPrecomposed:FALSE];
}
if (batLeft <= 80 && batLeft > 70) {
    [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging80.png"] isPrecomposed:FALSE];
}
if (batLeft <= 70 && batLeft > 60) {
    [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging70.png"] isPrecomposed:FALSE];
}
if (batLeft <= 60 && batLeft > 50) {
    [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging60.png"] isPrecomposed:FALSE];
}
if (batLeft <= 50 && batLeft > 40) {
    [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging50.png"] isPrecomposed:FALSE];
}
if (batLeft <= 40 && batLeft > 30) {
    [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging40.png"] isPrecomposed:FALSE];
}
if (batLeft <= 30 && batLeft > 20) {
    [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging30.png"] isPrecomposed:FALSE];
}
if (batLeft <= 20 && batLeft > 10) {
    [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging20.png"] isPrecomposed:FALSE];
}
if (batLeft <= 10 && batLeft >= 0) {
    [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging10.png"] isPrecomposed:FALSE];
}
    }
    else {
        if (batLeft <= 100 && batLeft > 90) {
            [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery100.png"] isPrecomposed:FALSE];
        }
        if (batLeft <= 90 && batLeft > 80) {
            [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery90.png"] isPrecomposed:FALSE];
        }
        if (batLeft <= 80 && batLeft > 70) {
            [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery80.png"] isPrecomposed:FALSE];
        }
        if (batLeft <= 70 && batLeft > 60) {
            [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery70.png"] isPrecomposed:FALSE];
        }
        if (batLeft <= 60 && batLeft > 50) {
            [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery60.png"] isPrecomposed:FALSE];
        }
        if (batLeft <= 50 && batLeft > 40) {
            [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery50.png"] isPrecomposed:FALSE];
        }
        if (batLeft <= 40 && batLeft > 30) {
            [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery40.png"] isPrecomposed:FALSE];
        }
        if (batLeft <= 30 && batLeft > 20) {
            [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery30.png"] isPrecomposed:FALSE];
        }
        if (batLeft <= 20 && batLeft > 10) {
            [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery20.png"] isPrecomposed:FALSE];
        }
        if (batLeft <= 10 && batLeft >= 0) {
            [[[AWBatteryViewImage icon] webClip] setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery10.png"] isPrecomposed:FALSE];
        }
    }
    [[[AWBatteryViewImage icon] webClip] _reloadProperties];
    [[[AWBatteryViewImage icon] webClip] requestCustomIconUpdate];
    [[[AWBatteryViewImage icon] webClip] requestIconUpdateInSpringBoard];
    if ([[AWBatteryViewImage superview] class] == [NSClassFromString(@"BigifyContainer") class]) {
        [[[AWBatteryViewImage superview] superview] performSelector:@selector(_updateIconImageViewAnimated:) withObject:@YES];
    }
    else {
    [[AWBatteryViewImage superview] performSelector:@selector(_updateIconImageViewAnimated:) withObject:@YES];
}
}
}
if ([self doesBatteryIconExist] == NO) {
        UIDevice *myDevice = [UIDevice currentDevice];
        [myDevice setBatteryMonitoringEnabled:YES];
        double batLeft = (float)[myDevice batteryLevel] * 100;
        SBIconController *iconController = [%c(SBIconController) sharedInstance];
        UIWebClip *BatteryIcon = [[UIWebClip alloc] _initWithIdentifier:@"com.creatix.batteryicon"];
        [BatteryIcon setPageURL:[NSURL URLWithString:@"prefs:root=General&path=USAGE/BATTERY_USAGE"]];
        [BatteryIcon setTitle:@"Battery"];
        [BatteryIcon setRemovalDisallowed:TRUE];
        if ([self isBatteryCharging]) {
            if (batLeft <= 100 && batLeft > 90) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging100.png"] isPrecomposed:FALSE];
}
if (batLeft <= 90 && batLeft > 80) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging90.png"] isPrecomposed:FALSE];
}
if (batLeft <= 80 && batLeft > 70) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging80.png"] isPrecomposed:FALSE];
}
if (batLeft <= 70 && batLeft > 60) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging70.png"] isPrecomposed:FALSE];
}
if (batLeft <= 60 && batLeft > 50) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging60.png"] isPrecomposed:FALSE];
}
if (batLeft <= 50 && batLeft > 40) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging50.png"] isPrecomposed:FALSE];
}
if (batLeft <= 40 && batLeft > 30) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging40.png"] isPrecomposed:FALSE];
}
if (batLeft <= 30 && batLeft > 20) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging30.png"] isPrecomposed:FALSE];
}
if (batLeft <= 20 && batLeft > 10) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging20.png"] isPrecomposed:FALSE];
}
if (batLeft <= 10 && batLeft >= 0) {
    [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/batterycharging10.png"] isPrecomposed:FALSE];
}
        }
        else {
            if (batLeft <= 100 && batLeft > 90) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery100.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 90 && batLeft > 80) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery90.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 80 && batLeft > 70) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery80.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 70 && batLeft > 60) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery70.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 60 && batLeft > 50) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery60.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 50 && batLeft > 40) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery50.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 40 && batLeft > 30) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery40.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 30 && batLeft > 20) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery30.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 20 && batLeft > 10) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery20.png"] isPrecomposed:FALSE];
            }
            if (batLeft <= 10 && batLeft >= 0) {
                [BatteryIcon setIconImage:[UIImage imageWithContentsOfFile: @"/Library/Application Support/BatteryIcon/battery10.png"] isPrecomposed:FALSE];
            }
        }
    NSLog(@"Deleting the Fuckin Icon");
     SBBookmark *batteryBookmark = [[%c(SBBookmark) alloc] initWithWebClip: BatteryIcon];
     [iconController uninstallIcon:batteryBookmarkIcon];
     SBBookmarkIcon *batteryBookmarkIcon = [[%c(SBBookmarkIcon) alloc] initWithBookmark: batteryBookmark];
     [(SBIconModel *)[iconController valueForKey:@"_iconModel"] addIcon:batteryBookmarkIcon];
    [iconController addNewIconToDesignatedLocation:batteryBookmarkIcon animate:YES scrollToList:NO saveIconState:YES];
}
}
if ([self isBatteryIconEnabled] == NO) {
    if ([self doesBatteryIconExist] == YES) {
    SBIconController *iconController = [%c(SBIconController) sharedInstance];
    SBIconModel *AWIconModel = [iconController valueForKey:@"_iconModel"];
    NSMutableDictionary *AWIconDictionary = [AWIconModel leafIconsByIdentifier];
    SBBookmarkIcon *AWBookmarkIcon = [AWIconDictionary objectForKey:@"com.creatix.batteryicon"];
    [iconController uninstallIcon: AWBookmarkIcon animate: TRUE];
}
else {

}

}
}
%new
-(BOOL)doesBatteryIconExist {
    SBIconController *iconController = [%c(SBIconController) sharedInstance];
    SBIconModel *AWIconModel = [iconController valueForKey:@"_iconModel"];
    NSMutableDictionary *AWIconDictionary = [AWIconModel leafIconsByIdentifier];
    if ([AWIconDictionary objectForKey:@"com.creatix.batteryicon"]) {
    return YES;
} else {
    return NO;
}
}
%new
-(BOOL)isBatteryIconEnabled {
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.creatix.batteryicon.plist"];
    BOOL enabletest = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;
    if (enabletest == YES) {
        return YES;
    }
    else {
        return NO;
    }

}
%end
%hook SBIconController
- (void)iconTapped:(id)icon {
    if ([[(SBLeafIcon *)[icon valueForKey:@"_icon"] leafIdentifier] isEqualToString:@"com.creatix.batteryicon"]) {
        if (iOS8) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=USAGE/BATTERY_USAGE"]];
        }
        else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=BATTERY_USAGE"]];
    }
        %orig;
    }
    else {
        %orig;
    }
}
%end
static void loadPrefs() {
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.creatix.batteryicon.plist"];
    enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;
}

%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.creatix.batteryicon/saved"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}