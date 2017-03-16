#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <MobileGestalt/MobileGestalt.h>
// #import "DMNetworksManager.h"
// #import "DMNetwork.h"
#include <spawn.h>
#include <dispatch/dispatch.h>
#import <objc/runtime.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "ZKSwizzle.h"


// #define SCREEN ([UIScreen mainScreen].bounds)


// %config(generator=MobileSubstrate)
@interface UIForceGestureRecognizer : UILongPressGestureRecognizer
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(NSString *)bid;
@end
@interface SBApplicationShortcutStoreManager : NSObject
+ (instancetype)sharedManager;
- (id)shortcutItemsForBundleIdentifier:(id)arg1;
@end
@interface SBIconView : UIView
@property(nonatomic) _Bool isEditing;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUp;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDown;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUpEdit;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDownEdit;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPress;
@property (nonatomic, retain) UIForceGestureRecognizer *forcePress;
- (void)setUpHoppinGestures;
- (void)changeGestures;
- (void)openMenuSwipe:(UISwipeGestureRecognizer *)sender;
- (void)openMenuHold:(UILongPressGestureRecognizer *)sender;
- (void)editActivate:(UISwipeGestureRecognizer *)sender;
- (void)disableAllGestures;
- (void)_handleSecondHalfLongPressTimer:(id)arg1;
+ (CGSize)defaultIconSize;
- (UIImageView *)_iconImageView;
@end

@interface SBApplication : NSObject
@property(copy, nonatomic) NSArray *dynamicShortcutItems;
@property(copy, nonatomic) NSArray *staticShortcutItems;
- (NSString*)bundleIdentifier;
- (NSString*)displayName;
- (id)initWithApplicationInfo:(id)arg1 bundle:(id)arg2 infoDictionary:(id)arg3 entitlements:(id)arg4 usesVisibiliyOverride:(_Bool)arg5;
@end

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *type;
- (void)setBundleIdentifierToLaunch:(id)arg1;
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(NSString*)arg1;
- (void)setLocalizedTitle:(NSString*)arg1;
- (void)setType:(NSString*)arg1;
- (void)setUserInfo:(id)arg1;
- (void)setUserInfoData:(id)arg1;
- (NSArray*)notAllowed;
@end

@interface SBIcon : NSObject
- (void)launchFromLocation:(int)location;
- (BOOL)isFolderIcon;// iOS 4+
- (NSString*)applicationBundleID;
- (SBApplication*)application;
- (id)generateIconImage:(int)arg1;
- (id)displayName;
-(id)leafIdentifier;
- (id)displayNameForLocation:(int)arg1;
@end

@interface SBFolder : NSObject
- (SBIcon*)iconAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface SBFolderIcon : NSObject
- (SBFolder*)folder;
@end

@interface SBFolderIconView : SBIconView
- (SBFolderIcon*)folderIcon;
@end


@interface SBIconView (Hoppin)
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUp;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDown;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUpEdit;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDownEdit;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPress;
@property (nonatomic, retain) UIForceGestureRecognizer *forcePress;
@end

@interface SBApplicationShortcutMenu : UIView
@property(retain, nonatomic) SBApplication *application;
@property(nonatomic, retain) SBFolderIconView *iconView;
@property(retain ,nonatomic) id applicationShortcutMenuDelegate;
- (void)_peekWithContentFraction:(double)arg1 smoothedBlurFraction:(double)arg2;
- (void)updateFromPressGestureRecognizer:(id)arg1;
- (void)menuContentView:(id)arg1 activateShortcutItem:(id)arg2 index:(long long)arg3;
- (void)dismissAnimated:(BOOL)arg1 completionHandler:(id)arg2;
- (id)initWithFrame:(CGRect)arg1 application:(id)arg2 iconView:(id)arg3 interactionProgress:(id)arg4 orientation:(long long)arg5;
- (void)presentAnimated:(_Bool)arg1;
- (void)interactionProgressDidUpdate:(id)arg1;
- (int)maxNumberOfShortcuts;
- (SBFolderIconView*)iconView;
- (void)_setupViews;
- (NSArray *)notAllowed;
- (void)setTransformedContainerView:(id)arg1;
- (BOOL)shortcutItemIsAllowed:(id)arg1;
+ (void)cancelPrepareForPotentialPresentationWithReason:(id)arg1;
- (void)_dismissAnimated:(_Bool)arg1 finishPeeking:(_Bool)arg2 ignorePresentState:(_Bool)arg3 completionHandler:(id)arg4;
@end

@interface UITouch (Private)
- (void)_setPressure:(float)arg1 resetPrevious:(BOOL)arg2;
- (float)_pathMajorRadius;
- (float)majorRadius;
- (id)_hidEvent;
@end

@interface SBIconController : UIViewController
@property(retain, nonatomic) SBApplicationShortcutMenu *presentedShortcutMenu;
+ (id)sharedInstance;
- (void)_revealMenuForIconView:(id)iconView presentImmediately:(BOOL)now;
- (void)_revealMenuForIconView:(id)iconView;
- (void)setIsEditing:(BOOL)arg1;
- (BOOL)isEditing;
- (void)_dismissShortcutMenuAnimated:(BOOL)arg1 completionHandler:(id)arg1;
- (void)_launchIcon:(id)icon;
- (void)_handleShortcutMenuPeek:(id)arg1;
- (id)presentedShortcutMenu;
- (void)applicationShortcutMenuDidPresent:(id)arg1;
@end

@interface UIApplicationShortcutItem (Private)

+ (unsigned int)_sbsActivationModeFromUIActivationMode:(unsigned int)arg1;
+ (unsigned int)_uiActivationModeFromSBSActivationMode:(unsigned int)arg1;
- (id)initWithSBSApplicationShortcutItem:(id)arg1;
@end
@interface SBSApplicationShortcutIcon : NSObject

@end

@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
@end

@interface SBSApplicationShortcutIcon (UF)
- (id)initWithType:(UIApplicationShortcutIconType)arg1;
@end

@interface SBSApplicationShortcutContactIcon : SBSApplicationShortcutIcon
-(instancetype)initWithContactIdentifier:(NSString *)contactIdentifier;
-(instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
-(instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName imageData:(NSData *)imageData;
@end

@interface SBCCWiFiSetting : NSObject
- (UIImage*)glyphImageForState:(int)arg1;
@end

@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
@property (nonatomic, readonly, retain) NSData *imagePNGData;
-(instancetype)initWithImagePNGData:(NSData *)imageData;
@end

@interface SBWebApplication : SBApplication
@end

@interface NSString (Creatix)
- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end;
@end

@implementation NSString (Creatix)
- (NSString*) stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;   
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
           targetRange.length = endRange.location - targetRange.location;
           return [self substringWithRange:targetRange];
        }
    }
    return nil;
}
@end


#define PREFS_BUNDLE_ID CFSTR("com.creatix.hoppin")

static BOOL activateMenu;
static CGFloat menuForceSensitivity = 40.37f;
static BOOL isEnabled = YES;
static BOOL autoClose = NO;
static BOOL folderShortcutsEnabled = YES;
static BOOL dyanmicShortcutsEnabled = YES;
static float activationType = 4.0f;
static float editingType = 1.0f;
static BOOL hapticFeedbackEnabled = YES;
static float longPressHoldDuration = 0.2f;
static float hapticFeedbackDuration = 30.0f;
static float maxItems = 11.0f;
static BOOL folderShortcutsAlternativeEnabled = NO;


static void reloadPrefs() {
	// Synchronize prefs
	CFPreferencesAppSynchronize(PREFS_BUNDLE_ID);
	// Get if enabled
	Boolean isEnabledExists = NO;
	Boolean isEnabledRef = CFPreferencesGetAppBooleanValue(CFSTR("Enabled"), PREFS_BUNDLE_ID, &isEnabledExists);
	isEnabled = (isEnabledExists ? isEnabledRef : YES);

	Boolean hapticFeedbackEnabledExists = NO;
	Boolean hapticFeedbackEnabledRef = CFPreferencesGetAppBooleanValue(CFSTR("hapticFeedbackEnabled"), PREFS_BUNDLE_ID, &hapticFeedbackEnabledExists);
	hapticFeedbackEnabled = (hapticFeedbackEnabledExists ? hapticFeedbackEnabledRef : YES);

	Boolean autoCloseExists = NO;
	Boolean autoCloseRef = CFPreferencesGetAppBooleanValue(CFSTR("autoClose"), PREFS_BUNDLE_ID, &autoCloseExists);
	autoClose = (autoCloseExists ? autoCloseRef : NO);

	Boolean isfolderShortcutsAlternativeEnabledExists = NO;
	Boolean isfolderShortcutsAlternativeEnabledRef = CFPreferencesGetAppBooleanValue(CFSTR("folderShortcutsAlternativeEnabled"), PREFS_BUNDLE_ID, &isfolderShortcutsAlternativeEnabledExists);
	folderShortcutsAlternativeEnabled = (isfolderShortcutsAlternativeEnabledExists ? isfolderShortcutsAlternativeEnabledRef : NO);

	Boolean isfolderShortcutsEnabledExists = NO;
	Boolean isfolderShortcutsEnabledRef = CFPreferencesGetAppBooleanValue(CFSTR("folderShortcutsEnabled"), PREFS_BUNDLE_ID, &isfolderShortcutsEnabledExists);
	folderShortcutsEnabled = (isfolderShortcutsEnabledExists ? isfolderShortcutsEnabledRef : YES);

	Boolean isdyanmicShortcutsEnabledExists = NO;
	Boolean isdyanmicShortcutsEnabledRef = CFPreferencesGetAppBooleanValue(CFSTR("dyanmicShortcutsEnabled"), PREFS_BUNDLE_ID, &isdyanmicShortcutsEnabledExists);
	dyanmicShortcutsEnabled = (isdyanmicShortcutsEnabledExists ? isdyanmicShortcutsEnabledRef : YES);

	CFPropertyListRef menuForceSensitivityRef = CFPreferencesCopyAppValue(CFSTR("menuForceSensitivity"), PREFS_BUNDLE_ID);
	menuForceSensitivity = (menuForceSensitivityRef ? [(__bridge NSNumber*)menuForceSensitivityRef floatValue] : 48.37f);

	CFPropertyListRef activationTypeRef = CFPreferencesCopyAppValue(CFSTR("activationType"), PREFS_BUNDLE_ID);
	activationType = (activationTypeRef ? [(__bridge NSNumber*)activationTypeRef floatValue] : 1.0f);

	CFPropertyListRef editingTypeRef = CFPreferencesCopyAppValue(CFSTR("editingType"), PREFS_BUNDLE_ID);
	editingType = (editingTypeRef ? [(__bridge NSNumber*)editingTypeRef floatValue] : 1.0f);

	CFPropertyListRef longPressHoldDurationRef = CFPreferencesCopyAppValue(CFSTR("longPressHoldDuration"), PREFS_BUNDLE_ID);
	longPressHoldDuration = (longPressHoldDurationRef ? [(__bridge NSNumber*)longPressHoldDurationRef floatValue] : 0.5f);

	CFPropertyListRef hapticFeedbackDurationRef = CFPreferencesCopyAppValue(CFSTR("hapticFeedbackDuration"), PREFS_BUNDLE_ID);
	hapticFeedbackDuration = (hapticFeedbackDurationRef ? [(__bridge NSNumber*)hapticFeedbackDurationRef floatValue] : 30.0f);

	CFPropertyListRef maxItemsRef = CFPreferencesCopyAppValue(CFSTR("maxItems"), PREFS_BUNDLE_ID);
	maxItems = (maxItemsRef ? [(__bridge NSNumber*)maxItemsRef floatValue] : 11.0f);
}

extern "C" void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id unknown, NSDictionary *options);

void hapticVibe(){
        NSMutableDictionary* VibrationDictionary = [NSMutableDictionary dictionary];
        NSMutableArray* VibrationArray = [NSMutableArray array ];
        [VibrationArray addObject:[NSNumber numberWithBool:YES]];
        [VibrationArray addObject:[NSNumber numberWithInt:hapticFeedbackDuration]]; //vibrate for 50ms
        [VibrationDictionary setObject:VibrationArray forKey:@"VibePattern"];
        [VibrationDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
        AudioServicesPlaySystemSoundWithVibration(4095,nil,VibrationDictionary);
}

/* Special Force Touch Gesture Recognizer :) */
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface NSString (UIForceGestureRecognizer)
- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end;
@end

@implementation NSString (UIForceGestureRecognizer)
- (NSString*) stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;   
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
           targetRange.length = endRange.location - targetRange.location;
           return [self substringWithRange:targetRange];
        }
    }
    return nil;
}
@end

@interface UITouch (UIForceGestureRecognizer)
- (CGFloat)getQuality;
- (CGFloat)getRadius;
- (CGFloat)getDensity;
- (int)getX;
- (int)getY;
@end

@implementation UITouch (UIForceGestureRecognizer)

- (CGFloat)getQuality {
	return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Quality:" andString:@"Density:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}

- (CGFloat)getDensity {
	return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Density:" andString:@"Irregularity:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];	
}

- (CGFloat)getRadius {
	return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"MajorRadius:" andString:@"MinorRadius:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}

- (int)getX {
return [[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"X:" andString:@"Y:"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
}

- (int)getY {
	return [[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Y:" andString:@"Z:"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
}

@end

// @interface NSArray (compare)
// + (NSArray *)removeDuplicatesInArray:(NSArray*)arrayToFilter;
// @end
// @implementation NSArray (compare)
// + (NSArray *)removeDuplicatesInArray:(NSArray*)arrayToFilter{

//     NSMutableSet *seenDates = [NSMutableSet set];
//     NSPredicate *dupDatesPred = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind) {
//         DMNetwork *e = (DMNetwork*)obj;
//         BOOL seen = [seenDates containsObject:e.SSID];
//         if (!seen) {
//             [seenDates addObject:e.SSID];
//         }
//         return !seen;
//     }];
//     return [arrayToFilter filteredArrayUsingPredicate:dupDatesPred];
// }
// @end


static CGFloat Density;
static CGFloat Radius;
static CGFloat Quality;
static int X;
static int Y;

static CGFloat lastDensity;
static CGFloat lastRadius;
static CGFloat lastQuality;
static int lastX;
static int lastY;

BOOL hasIncreasedByPercent(float percent, float value1, float value2) {

    if (value1 <= 0 || value2 <= 0)
        return NO;
    if (value1 >= value2 + (value2 / percent))
        return YES;
    return NO;
}

@implementation UIForceGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action{
    if ((self = [super initWithTarget:target action:action])){
        // so simple there's no setup
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    Radius = [touch getRadius];
	X = [touch getX];
	Y = [touch getY];
	Density = [touch getDensity];
	Quality = [touch getQuality];
	//touchPoint = CGPointMake( X, Y);
	/* if ([touch _pathMajorRadius] > 40) {
		self.state = UIGestureRecognizerStateBegan;
		MenuOpen = YES;
	} */
	if (hasIncreasedByPercent(15, Density, lastDensity) && hasIncreasedByPercent(15, Radius, lastRadius)) {
		self.state = UIGestureRecognizerStateBegan;
    //self.cancelsTouchesInView = YES;
		NSLog(@"Begin Complete");
		//MenuOpen = YES;
	}
	lastRadius = Radius;
	lastX = X;
	lastY = Y;
	lastDensity = Density;
	lastQuality = Quality;
}
// - (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//     // If one of our subviews wants it, return YES
//     for (UIView *subview in self.subviews) {
//         CGPoint pointInSubview = [subview convertPoint:point fromView:self.view];
//         if ([subview pointInside:pointInSubview withEvent:event]) {
//             return YES;
//         }
//     }
//     // otherwise return NO, as if userInteractionEnabled were NO
//     return NO;
// }
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesMoved:touches withEvent:event];
	UITouch *touch = [touches anyObject];
  	Radius = [touch getRadius];
	X = [touch getX];
	Y = [touch getY];
	Density = [touch getDensity];
	Quality = [touch getQuality];
	//touchPoint = CGPointMake( X, Y);
	if (self.state == UIGestureRecognizerStatePossible) { 
		if ((lastX - [touch getX] >= 10 || lastX - [touch getX] <= -10) || (lastY - [touch getY] >= 10 || lastY - [touch getY] <= -10)) {
			self.state = UIGestureRecognizerStateFailed;
		 	NSLog(@"Too Much Movement");
     	}
		else if (hasIncreasedByPercent(15, Density, lastDensity) && hasIncreasedByPercent(15, Radius, lastRadius)) {
			self.state = UIGestureRecognizerStateBegan;
      // self.cancelsTouchesInView = YES;
			//MenuOpen = YES;
		}
	}
	if (self.state == UIGestureRecognizerStateChanged) {
		self.state = UIGestureRecognizerStateChanged;
	}
	lastRadius = Radius;
	lastX = X;
	lastY = Y;
	lastDensity = Density;
	lastQuality = Quality;
	//touchPoint = CGPointMake( X, Y);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
    [self reset];
    //MenuOpen = NO;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
    [self reset];
}

-(void)reset{
	[super reset];
  lastRadius = 0;
  lastX = 0;
  lastY = 0;
  lastDensity = 0;
  lastQuality = 0;
  //touchPoint = CGPointMake( 0, 0);
}
@end

/* End of Special force touch gesture recognizer for iOS 9 */

ZKSwizzleInterface($_Lamo_SBApplicationShortcutMenu, SBApplicationShortcutMenu, NSObject)
@implementation $_Lamo_SBApplicationShortcutMenu
/*- (void)_handleDismissGesture:(id)arg1 {
	%orig;
	
}*/
- (void)_dismissAnimated:(_Bool)arg1 finishPeeking:(_Bool)arg2 ignorePresentState:(_Bool)arg3 completionHandler:(id)arg4 {
	ZKOrig(void, arg1,arg2,arg3,arg4);
	if (arg3 == YES)
	[self dismissAnimated:YES completionHandler:nil];
}
// - (void)layoutSubviews {
// 	%orig;
// }
// %new
// - (BOOL)shortcutItemIsAllowed:(SBSApplicationShortcutItem *)shortcut {
// 	BOOL allowed = YES;
// 	for (NSDictionary* notItem in [self notAllowed])
// 	{
//     	if ([shortcut.localizedTitle isEqualToString:[notItem objectForKey:@"title"]] && [shortcut.type isEqualToString:[notItem objectForKey:@"type"]] && ![[notItem objectForKey:@"enabled"] boolValue]) {
//     		allowed = NO;
//     	}
// 	}
// 	return allowed;
// }
// %new
// - (NSArray *)notAllowed {
// 	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/jp.r-plus.Cloaky.Shortcut.plist"];
// 	return [dict objectForKey:self.application.bundleIdentifier];
// }
// %new
// - (int)heightEleven {
// 	CGFloat sizeToTop = [[self.iconView _iconImageView] convertPoint:CGPointMake(0,0) toView:nil].y;
//     int yx = sizeToTop;
//         return yx;
// }
// %new
// - (int)maxNumberOfShortcuts {
//     NSInteger shortcutHeight = [%c(SBIconView) defaultIconSize].width;
//     //[self.iconView.superview convertPoint:self.iconView.frame.origin toView:nil] - [%c(SBIconView) defaultIconSize].height/2;
//     NSInteger currentY = [[self.iconView _iconImageView] convertPoint:CGPointMake(0,0) toView:nil].y;
//     int width = [%c(SBIconView) defaultIconSize].width;
//     BOOL isUp = YES;
//     if (currentY < SCREEN.size.height/2+20) {
//         isUp = NO;
//     }
    
//     if (isUp == YES) {
//         CGFloat sizeToTop = [[self.iconView _iconImageView] convertPoint:CGPointMake(0,0) toView:nil].y - width/4 - width/4;
//         int yx = sizeToTop;
//         return floor(yx/shortcutHeight);
//     } else {

//         CGFloat sizeToBottom = SCREEN.size.height - currentY - width/4 - width - width/5;
//         int finalNumber = floor(sizeToBottom/shortcutHeight);
//         if (finalNumber < 4) finalNumber = 4;
//         return finalNumber;
//     }
// }
// - (id)_shortcutItemsToDisplay {
	
// 	NSMutableArray *aryItems = [NSMutableArray new];
//   if ([self.iconView isKindOfClass:[NSClassFromString(@"SBFolderIconView") class]]) {
//     if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.bolencki13.appendix.list"]) {
//       return %orig;
//     }
//     else if (folderShortcutsEnabled) {
//     	int maxNumberOfShortcuts = [self maxNumberOfShortcuts];
//     	if (dyanmicShortcutsEnabled) {
//     		if (maxNumberOfShortcuts > maxItems) maxNumberOfShortcuts = maxItems;
//     	}
//     	else {
//     		maxNumberOfShortcuts = 4;
//     	}
//     	  for (int x = 0; x < maxNumberOfShortcuts; x++) {
//     	  	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:x inSection:0];
//     	    NSString *bundleID = [[[self iconView].folderIcon.folder iconAtIndexPath:indexPath] leafIdentifier];
//     	  	if (folderShortcutsAlternativeEnabled) {
//     	  		return [[%c(SBApplicationShortcutStoreManager) sharedManager] shortcutItemsForBundleIdentifier: bundleID];
//     	  	}
//     	    UIImage *icon1 = [[[self iconView].folderIcon.folder iconAtIndexPath:indexPath] generateIconImage:2];
//     	    if (icon1 == nil) {
//     	      break;
//     	    }
//     	    //NSString *folderName = @"Jailbreak";
  	
//   	  	    SBSApplicationShortcutItem *action = [[%c(SBSApplicationShortcutItem) alloc] init];
//   	  	    [action setIcon:[[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:UIImagePNGRepresentation(icon1)]];
//   	  	    NSString *appName = [[[self iconView].folderIcon.folder iconAtIndexPath:indexPath] displayNameForLocation:1];
//   	  	    [action setLocalizedTitle:appName];
//   	  	    if ([[self iconView].folderIcon.folder iconAtIndexPath:indexPath].application == nil) {
//   	  	      // [action setType:@"UniversalForce_Web"];
//   	  	      NSMutableDictionary* userInfoData = [NSMutableDictionary new];
//   	  	      [userInfoData setObject: bundleID forKey:@"webID"];
//   	  	      [action setBundleIdentifierToLaunch:[NSString stringWithFormat:@"com.apple.webapp.%@", bundleID]];
//   	  	      [action setUserInfo:userInfoData];
//   	  	    }
//   	  	    else {
//   	  	      [action setType:@"UniversalForce"];
//   	  	      [action setBundleIdentifierToLaunch:bundleID];
//   	  	    }
// 			[aryItems addObject:action];
// 	    }
//     }
//   }
//   else {
// 	  [aryItems addObjectsFromArray:self.application.staticShortcutItems];
// 	  [aryItems addObjectsFromArray:self.application.dynamicShortcutItems];
//     NSUInteger itemsAvailible = [aryItems count];
//     NSMutableArray *FinalShortcutItemsArray = [[NSMutableArray alloc] init];
//     int maxNumberOfShortcuts = [self maxNumberOfShortcuts];
//     if (dyanmicShortcutsEnabled) {
//     	if (maxNumberOfShortcuts > maxItems) maxNumberOfShortcuts = maxItems;
//     }
//     else {
//     	maxNumberOfShortcuts = 4;
//     }
//     for (NSUInteger i = 0; i < itemsAvailible && i < maxNumberOfShortcuts; i++) {
//       [FinalShortcutItemsArray addObject:[aryItems objectAtIndex: i]];
//     }
//   aryItems = FinalShortcutItemsArray;
//   }
//   NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
//   for (SBSApplicationShortcutItem* shortcut in aryItems) {
//   	if (![self shortcutItemIsAllowed:shortcut]) {
//   		[indexes addIndex:[aryItems indexOfObject:shortcut]];
//   	}
//   }
//   [aryItems removeObjectsAtIndexes:indexes];
//   return aryItems;
//  //  [[%c(DMNetworksManager) sharedInstance] scan];
//  // NSMutableArray *networks = [[%c(DMNetworksManager) sharedInstance] networks];
//  // NSMutableArray *shortcuts = [[NSMutableArray alloc] init];
//  // if (networks) {
//  // if ([networks count] >= 4) {
//  // for (int x = 0; x < 4; x++) {
//  // 	DMNetwork *network = [networks objectAtIndex:x];
//  // 	SBSApplicationShortcutCustomImageIcon *shortcutIcon = [[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:UIImagePNGRepresentation([[[%c(SBCCWiFiSetting) alloc] init] glyphImageForState:1])];
//  // 	SBSApplicationShortcutItem *shortcut = [[%c(SBSApplicationShortcutItem) alloc] init];
//  // 	[shortcut setLocalizedTitle:network.SSID];
//  // 	[shortcut setIcon:shortcutIcon];
//  // 	if (network.requiresPassword) {
//  // 		[shortcut setLocalizedSubtitle:@"Secured"];
//  // 	}
//  // 	else {
//  // 		[shortcut setLocalizedSubtitle:@"Open"];
//  // 	}
//  // 	[shortcuts addObject:shortcut];
//  // }
//  // }
//  // else {
//  // 	for (int x = 0; x < [networks count]; x++) {
//  // 	DMNetwork *network = [networks objectAtIndex:x];
//  // 	SBSApplicationShortcutCustomImageIcon *shortcutIcon = [[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:UIImagePNGRepresentation([[[%c(SBCCWiFiSetting) alloc] init] glyphImageForState:1])];
//  // 	SBSApplicationShortcutItem *shortcut = [[%c(SBSApplicationShortcutItem) alloc] init];
//  // 	[shortcut setLocalizedTitle:network.SSID];
//  // 	[shortcut setIcon:shortcutIcon];
//  // 	if (network.requiresPassword) {
//  // 		[shortcut setLocalizedSubtitle:@"Secured"];
//  // 	}
//  // 	else {
//  // 		[shortcut setLocalizedSubtitle:@"Open"];
//  // 	}
//  // 	[shortcuts addObject:shortcut];
//  // }
//  // }
//  // }
//  // return shortcuts;


//  //   UIApplicationShortcutItem *respring = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple.Preferences.respring" localizedTitle:@"Respring"];
//  //   UIApplicationShortcutItem *reboot = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple.Preferences.reboot" localizedTitle:@"Reboot"];
//  //   UIApplicationShortcutItem *power = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple.Preferences.powerdown" localizedTitle:@"Power Down"];
//  //   UIApplicationShortcutItem *safemode = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple.Preferences.safemode" localizedTitle:@"Safe Mode"];
//  //   return [NSMutableArray arrayWithObjects:respring, reboot, power, safemode, nil];
// }
@end
ZKSwizzleInterface($_Lamo_UITouch, UITouch, NSObject);
@implementation $_Lamo_UITouch
 - (void)setMajorRadius:(float)arg1 {
 	if (isEnabled && activationType == 1) {
		if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
	 		NSInteger forcePress = menuForceSensitivity;
	 		if ((long)[self _pathMajorRadius] > forcePress) {
				//MSHookIvar<float>(self,"_pressure") = 1;
				activateMenu = YES;
				//popForceSensitivity = 4.0f;
			}
			else {
				activateMenu = NO;
			}
		}
	}
	ZKOrig(void, arg1);
}
@end
ZKSwizzleInterface($_Lamo__UITouchForceMessage, _UITouchForceMessage, NSObject);
@implementation $_Lamo__UITouchForceMessage
- (void)setUnclampedTouchForce:(CGFloat)touchForce {
	if (isEnabled && [[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
		if (activateMenu) {
			if (sizeof(void*) == 4) {
				ZKOrig(void, (float) 200);
	    	}
	    	else if (sizeof(void*) == 8) {
	      		ZKOrig(void, (double) 200);
	    	}
		}
	}
	else {
  		ZKOrig(void, touchForce);
	}
}
@end
@interface SBControlCenterController : UIViewController
+ (instancetype)sharedInstance;
@end
@interface SBApplicationShortcutMenuContentView : UIView
- (void)_presentForFraction:(double)arg1;
- (void)_configureForMenuPosition:(NSInteger)arg1 menuItemCount:(NSInteger)arg2;
@end
// %hook SBControlCenterController
// %new
// - (void)test {
// 	SBApplicationShortcutMenu *test = [[%c(SBApplicationShortcutMenu) alloc] initWithFrame:CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height) application:[[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:@"com.apple.Music"] iconView:nil interactionProgress:nil orientation:1];
// 	[self.view addSubview:test];
// 	[test _setupViews];
// 	//[test presentAnimated:TRUE];
// 	[test _peekWithContentFraction:1 smoothedBlurFraction:1];
// 	SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(	test,"_contentView");
// 	if (contentView)
// 	[contentView _presentForFraction:1];




// //- (id)initWithFrame:(struct CGRect)arg1 application:(id)arg2 iconView:(id)arg3 interactionProgress:(id)arg4 orientation:(long long)arg5;
// }
// %end
ZKSwizzleInterface($_Lamo_SBIconController, SBIconController, NSObject);
@implementation $_Lamo_SBIconController
// %new
// - (void)test {
// 	SBApplicationShortcutMenu *test = [[%c(SBApplicationShortcutMenu) alloc] initWithFrame:CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height) application:[[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:@"com.apple.Music"] iconView:nil interactionProgress:nil orientation:1];
// 	[self.view addSubview:test];	

// //- (id)initWithFrame:(struct CGRect)arg1 application:(id)arg2 iconView:(id)arg3 interactionProgress:(id)arg4 orientation:(long long)arg5;
// }

- (BOOL)canRevealShortcutMenu {
	if (isEnabled)
	return YES;
	else return ZKOrig(BOOL);
}

- (BOOL)_canRevealShortcutMenu {
    if (isEnabled)
    return YES;
    else return ZKOrig(BOOL);
}

- (void)viewMap:(id)map configureIconView:(SBIconView *)iconView {
	ZKOrig(void,map,iconView);
	if (isEnabled) {
		[iconView setUpHoppinGestures];
		[iconView changeGestures];
	}
}

// - (void)_revealMenuForIconView:(id)arg1 presentImmediately:(_Bool)arg2 {
// 	if (isEnabled) {
// 		ZKOrig(void, arg1, YES);
// 		if ([arg1 class] == [NSClassFromString(@"SBFolderIconView") class]) {
// 			if (folderShortcutsEnabled && hapticFeedbackEnabled) {
// 				// hapticVibe();
// 			}
// 		}
// 		else if (hapticFeedbackEnabled) {
// 			// hapticVibe();
// 		}
// 	}
// 	else {
// 		ZKOrig(void, arg1, arg2);
// 	}
// }

- (void)_revealMenuForIconView:(id)arg1 {
    if (isEnabled) {
        ZKOrig(void, arg1);
        if ([self presentedShortcutMenu]) [[self presentedShortcutMenu] presentAnimated:YES];
        if ([arg1 class] == [NSClassFromString(@"SBFolderIconView") class]) {
            if (folderShortcutsEnabled && hapticFeedbackEnabled) {
                hapticVibe();
            }
        }
        else if (hapticFeedbackEnabled) {
            hapticVibe();
        }
    }
    else {
        ZKOrig(void, arg1);
    }
}

- (void)_handleShortcutMenuPeek:(UILongPressGestureRecognizer *)sender {
	ZKOrig(void, sender);
	if (isEnabled && autoClose) {
		if (sender.state == UIGestureRecognizerStateEnded) {
			[self _dismissShortcutMenuAnimated:YES completionHandler:nil];
		}
	}
	/*if (sender.state == UIGestureRecognizerStateCancelled) {

		[[%c(SBApplicationShortcutMenu) class] cancelPrepareForPotentialPresentationWithReason:nil];
		//[self cancelPrepareForPotentialPresentationWithReason:nil];
	} */
}
/*- (void)_cleanupForDismissingShortcutMenu:(id)arg1 {
	[[%c(SBApplicationShortcutMenu) class] cancelPrepareForPotentialPresentationWithReason:nil];
	%orig;
}*/
@end

ZKSwizzleInterface($_Lamo_NSObject, NSObject, NSObject);
@implementation $_Lamo_NSObject
/*- (BOOL)isKindOfClass:(Class)aClass {
	if (aClass == [NSClassFromString(@"SBIconView") class] && folderShortcutsEnabled) {
		return YES;
	}
	else return %orig;
} */
- (void)updateReflection {

}
- (id)webClip {
	return nil;
}
- (id)matchedWebApplication {
	return nil;
}
@end
@interface WFWiFiManager : NSObject
+(id)sharedInstance;
+(void)awakeFromBundle;
-(id)knownNetworks;
-(void)scan;
@end
@interface WiFiManager : NSObject
+(instancetype)sharedInstance;
@end
@interface SBControlCenterButton : UIView
@property (nonatomic, retain) UIView *helpIconView;
@property (nonatomic, retain) SBApplicationShortcutMenu *shortcut;
-(UIImage*)_imageFromRect:(CGRect)arg1;
- (UIImage*)sourceGlyphImage;
- (UIImage*)_backgroundImage;
- (UIImage*)_backgroundImageWithGlyphImage:(UIImage*)arg1 state:(NSInteger)arg1;
+ (instancetype)_buttonWithBGImage:(id)arg1 glyphImage:(id)arg2 naturalHeight:(float)arg3;
- (void)testMenu:(id)iconView;
- (void)testABC;
@end
static BOOL isShortcutOpen = NO;
// %hook SBControlCenterButton
// %property (nonatomic, retain) UIView *helpIconView;
// %property (nonatomic, retain) SBApplicationShortcutMenu *shortcut;
// - (void)setIdentifier:(id)arg1 {
// 	UIForceGestureRecognizer *forcePress = [[UIForceGestureRecognizer alloc] initWithTarget:self action:@selector(_handleShortcutMenuPeek:)];
// 	forcePress.minimumPressDuration = 300;
// 	[self addGestureRecognizer:forcePress];
// 	SBFolderIconView *iconView = [[%c(SBFolderIconView) alloc] initWithFrame:self.frame];
// 		[iconView setUpHoppinGestures];
// 		[iconView changeGestures];
// 		self.helpIconView = iconView;
// 		[self addSubview:self.helpIconView];
// }
// %new
// - (void)testABC {
// 	[self testMenu:self.helpIconView];
// }
// %new
// - (void)resetStuff {
// 	isShortcutOpen = NO;
// }
// %new
// - (void)testMenu:(id)iconView {
// 			SBApplicationShortcutMenu *test = [[%c(SBApplicationShortcutMenu) alloc] initWithFrame:CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height) application:[[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:@"com.apple.Music"] iconView:iconView interactionProgress:nil orientation:1];
// 			SBControlCenterController *sbcc = [%c(SBControlCenterController) sharedInstance];
// 			[sbcc.view addSubview:test];
// 			//test.delegate = [%c(SBIconController) sharedInstance];
// 			//test.applicationShortcutMenuDelegate = [%c(SBIconController) sharedInstance];
// 			[test _setupViews];
// 			//[test setTransformedContainerView:sbcc];
// 	//[test presentAnimated:TRUE];
// 			[test _peekWithContentFraction:1 smoothedBlurFraction:1];
// 			SBApplicationShortcutMenuContentView *contentView = [test objectForKey:@"_contentView"];
// 			if (contentView) {
// 			//[contentView _configureForMenuPosition:12 menuItemCount:4];
// 			[contentView _presentForFraction:1];
// 			}
// 			SBIconView *proxyView = [test objectForKey:@"_proxyIconView"];
// 			SBControlCenterButton *proxyButton = [%c(SBControlCenterButton) _buttonWithBGImage:[self _backgroundImageWithGlyphImage:[self sourceGlyphImage] state:1] glyphImage:[self sourceGlyphImage] naturalHeight:self.frame.size.height];
// 			[proxyView addSubview:proxyButton];
// 			//proxyButton.frame = [proxyView superview].frame;
			

// }

// %new
// -(void)_handleShortcutMenuPeek:(UILongPressGestureRecognizer*)sender {
// 	if (isShortcutOpen == NO) {
// 	SBApplicationShortcutMenu *test = [[%c(SBApplicationShortcutMenu) alloc] initWithFrame:CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height) application:[[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:@"com.apple.Music"] iconView:self.helpIconView interactionProgress:nil orientation:1];
// 	SBControlCenterController *sbcc = [%c(SBControlCenterController) sharedInstance];
// 	[sbcc.view addSubview:test];
// 			//test.delegate = [%c(SBIconController) sharedInstance];
// 			//test.applicationShortcutMenuDelegate = [%c(SBIconController) sharedInstance];
// 	[test _setupViews];
// 	self.shortcut = test;
// 	isShortcutOpen = YES;
// 	SBIconView *proxyView = [test objectForKey:@"_proxyIconView"];
// 	SBControlCenterButton *proxyButton = [%c(SBControlCenterButton) _buttonWithBGImage:[self _backgroundImageWithGlyphImage:[self sourceGlyphImage] state:1] glyphImage:[self sourceGlyphImage] naturalHeight:self.frame.size.height];
// 	[proxyView addSubview:proxyButton];
// 	proxyButton.center = [proxyView convertPoint:proxyView.center fromView:proxyView.superview];
// 	[proxyView.layer setCornerRadius:proxyView.frame.size.width/2];
// 	proxyView.backgroundColor = [UIColor whiteColor];
// 	}
// 	if (self.shortcut)
// 	[self.shortcut updateFromPressGestureRecognizer:sender];
// 	SBApplicationShortcutMenu *test = self.shortcut;

// 			//[test setTransformedContainerView:sbcc];
// 	//[test presentAnimated:TRUE];
// 	[test _peekWithContentFraction:1 smoothedBlurFraction:1];
// 	SBApplicationShortcutMenuContentView *contentView = [test objectForKey:@"_contentView"];
// 	if (contentView) {
// 			//[contentView _configureForMenuPosition:12 menuItemCount:4];
// 		[contentView _presentForFraction:1];
// 	}
// //	[[objc_getClass("WFWiFiManager") sharedInstance] awakeFromBundle];
// 	//[[objc_getClass("WiFiManager") sharedInstance]
// 	HBLogInfo([NSString stringWithFormat:@"%@", [[objc_getClass("WFWiFiManager") sharedInstance] knownNetworks]]);
	
// }
// %new
// - (id)wifi {

// dlopen("/System/Library/Frameworks/Preferences.framework/Preferences", RTLD_LAZY);
// dlopen("/System/Library/PreferenceBundles/AirPortSettings.bundle/AirPortSettings", RTLD_LAZY);
// return [objc_getClass("DMNetworksManager") sharedInstance];
// }

%hook SBIconView
%property (nonatomic, retain) UISwipeGestureRecognizer *swipeUp;
%property (nonatomic, retain) UISwipeGestureRecognizer *swipeDown;
%property (nonatomic, retain) UISwipeGestureRecognizer *swipeUpEdit;
%property (nonatomic, retain) UISwipeGestureRecognizer *swipeDownEdit;
%property (nonatomic, retain) UILongPressGestureRecognizer *longPress;
%property (nonatomic, retain) UIForceGestureRecognizer *forcePress;
%end


ZKSwizzleInterface($_Lamo_SBIconView, SBIconView, UIView);

@interface $_Lamo_SBIconView (Help)
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUp;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDown;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeUpEdit;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDownEdit;
@property (nonatomic, retain) UILongPressGestureRecognizer *longPress;
@property (nonatomic, retain) UIForceGestureRecognizer *forcePress;
@property(nonatomic) _Bool isEditing;
@end

@implementation $_Lamo_SBIconView

- (BOOL)isKindOfClass:(Class)aClass {
	if (aClass == [NSClassFromString(@"SBIconView") class] && folderShortcutsEnabled) {
		return YES;
	}
	else return ZKOrig(BOOL, aClass);
}

- (void)setUpHoppinGestures {
	if (isEnabled) {
		if (self.swipeUp && self.swipeDown && self.longPress) {

		}
		else {
			UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openMenuSwipe:)];
			UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openMenuSwipe:)];
			UISwipeGestureRecognizer *swipeUpEdit = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(editActivate:)];
			UISwipeGestureRecognizer *swipeDownEdit = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(editActivate:)];
			SBIconController *iconController = [objc_getClass("SBIconController") sharedInstance];
			UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:iconController action:@selector(_handleShortcutMenuPeek:)];
			UIForceGestureRecognizer *forcePress = [[UIForceGestureRecognizer alloc] initWithTarget:iconController action:@selector(_handleShortcutMenuPeek:)];
		
			swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
			swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
			swipeUpEdit.direction = UISwipeGestureRecognizerDirectionUp;
			swipeDownEdit.direction = UISwipeGestureRecognizerDirectionDown;
			longPress.minimumPressDuration = longPressHoldDuration;
			forcePress.minimumPressDuration = 300;
		
			swipeUp.cancelsTouchesInView = YES;
			swipeDown.cancelsTouchesInView = YES;
			swipeUpEdit.cancelsTouchesInView = YES;
			swipeDownEdit.cancelsTouchesInView = YES;

			// longPress.cancelsTouchesInView = YES;
		
			swipeUp.enabled = NO;
			swipeDown.enabled = NO;
			swipeUpEdit.enabled = NO;
			swipeDownEdit.enabled = NO;
			longPress.enabled = NO;
			forcePress.enabled = NO;

			self.swipeUp = swipeUp;
			self.swipeDown = swipeDown;
			self.swipeUpEdit = swipeUpEdit;
			self.swipeDownEdit = swipeDownEdit;
			self.longPress = longPress;
			self.forcePress = forcePress;
		
			[self addGestureRecognizer:self.swipeUp];
			[self addGestureRecognizer:self.swipeDown];
			[self addGestureRecognizer:self.swipeUpEdit];
			[self addGestureRecognizer:self.swipeDownEdit];
			[self addGestureRecognizer:self.longPress];
			[self addGestureRecognizer:self.forcePress];
		}	
	}
}


- (void)changeGestures {
	if (isEnabled) {
		if (self.swipeDown) {

		}
		else {
			[self setUpHoppinGestures];
		}
		if (self.isEditing) {
			self.swipeDown.enabled = NO;
			self.swipeUp.enabled = NO;
			self.swipeDownEdit.enabled = NO;
			self.swipeUpEdit.enabled = NO;
			self.longPress.enabled = NO;
			self.forcePress.enabled = NO;
			self.longPress.minimumPressDuration = longPressHoldDuration;
		}
		else {
			if (activationType == 2.0f) { // Swipe UP
				self.swipeUp.enabled = YES;
				self.longPress.enabled = NO;
				self.swipeDown.enabled = NO;
				self.forcePress.enabled = NO;
			}
			if (activationType == 3.0f) { // Swipe Down
				self.swipeDown.enabled = YES;
				self.longPress.enabled = NO;
				self.swipeUp.enabled = NO;
				self.forcePress.enabled = NO;
	
			}
			if (activationType == 4.0f) { // Long Press
				self.longPress.enabled = YES;
				self.longPress.minimumPressDuration = longPressHoldDuration;
				self.swipeDown.enabled = NO;
				self.swipeUp.enabled = NO;
				self.forcePress.enabled = NO;
	
			}
			if (activationType == 5.0f) { // Long Press
				self.forcePress.enabled = YES;
				self.longPress.minimumPressDuration = longPressHoldDuration;
				self.longPress.enabled = NO;
				self.swipeDown.enabled = NO;
				self.swipeUp.enabled = NO;
	
			}
			if (activationType == 1.0f) {
				self.swipeDown.enabled = NO;
				self.swipeUp.enabled = NO;
				self.longPress.enabled = NO;
				self.forcePress.enabled = NO;
			}
			if (editingType == 1.0f) {
				self.swipeDownEdit.enabled = NO;
				self.swipeUpEdit.enabled = NO;
			}
			if (editingType == 2.0f) {
				self.swipeDownEdit.enabled = NO;
				self.swipeUpEdit.enabled = YES;
			}
			if (editingType == 3.0f) {
				self.swipeDownEdit.enabled = YES;
				self.swipeUpEdit.enabled = NO;
			}
		}
	}
	else {
		if (self.swipeDown) self.swipeDown.enabled = NO;
		if (self.swipeUp) self.swipeUp.enabled = NO;
		if (self.swipeUpEdit) self.swipeDown.enabled = NO;
		if (self.swipeDownEdit) self.swipeDown.enabled = NO;
		if (self.longPress) self.longPress.enabled = NO;
		if (self.forcePress) self.forcePress.enabled = NO;
	}
}


- (void)openMenuSwipe:(UISwipeGestureRecognizer*)sender { // Swipe Up or Down
		SBIconController *iconController = [objc_getClass("SBIconController") sharedInstance];
    if ([[objc_getClass("SBIconController") sharedInstance] respondsToSelector:@selector(_revealMenuForIconView:presentImmediately:)]) {
      [iconController _revealMenuForIconView: self presentImmediately:YES];
    }
		else {
      [iconController _revealMenuForIconView: self];
    }
}

- (void)openMenuHold:(UILongPressGestureRecognizer*)sender { // Long Press
		SBIconController *iconController = [objc_getClass("SBIconController") sharedInstance];
		if ([[objc_getClass("SBIconController") sharedInstance] respondsToSelector:@selector(_revealMenuForIconView:presentImmediately:)]) {
      [iconController _revealMenuForIconView: self presentImmediately:YES];
    }
    else {
      [iconController _revealMenuForIconView: self];
    }
}

- (void)editActivate:(UISwipeGestureRecognizer *)sender {
	[self _handleSecondHalfLongPressTimer:nil];
}
- (void)_applyEditingStateAnimated:(BOOL)arg1 {
	if (isEnabled) {
		[self changeGestures];
	}
	ZKOrig(void, arg1);
}
- (void)setIsEditing:(BOOL)arg1 animated:(BOOL)arg2 {
	if (isEnabled) {
		[self changeGestures];
	}
	ZKOrig(void, arg1, arg2);
}
- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {
	if (isEnabled) {
		reloadPrefs();
		[self changeGestures];
	}
	ZKOrig(void, arg1, arg2);
}
- (void)touchesEnded:(id)arg1 withEvent:(id)arg2 {
	ZKOrig(void, arg1, arg2);
	SBIconController *iconController = [objc_getClass("SBIconController") sharedInstance];
	if (isEnabled && autoClose && iconController.presentedShortcutMenu) {
		[iconController _dismissShortcutMenuAnimated: YES completionHandler:nil];
	}
}
@end

%hook BSPlatform
%new
- (CGFloat)width {
    return 150.0;
}
%end
//%hook SBIcon
/*- (_Bool)isBookmarkIcon {
	if (folderShortcutsEnabled)
	return YES;
	else return %orig;

} */

/*- (id)application {
	%orig;
	if (self.application) {
		return %orig;
	}
	else {
		return [[%c(SBApplication) alloc] initWithApplicationInfo:nil bundle:nil infoDictionary:nil entitlements:nil usesVisibiliyOverride:NO];
	}
} */
//%end 
// %hook SBApplicationIcon
// %new
// - (id)webClip {
// 	return nil;
// }
// %end
// %hook SBFolderIcon
// - (_Bool)isBookmarkIcon {
// 	if (folderShortcutsEnabled)
// 	return YES;
// 	else return %orig;

// }
// %new
// - (id)matchedWebApplication {
// 		return [[%c(SBWebApplication) alloc] init];
// }
// %end
// %hook _SBAnimatableCorneredView
// %new
// - (void)updateReflection {

// }
// %end
// %hook STKEmptyIcon
// %new
// - (id)matchedWebApplication {
// 	return nil;
// }
// %end


// %group iOS9X
// %hook SBIconController
// %new
// - (void)_revealMenuForIconView:(id)iconView presentImmediately:(BOOL)arg2 {
//   [self _revealMenuForIconView:iconView];
// }
// %end
// // %end 


// xcrun simctl spawn booted launchctl debug system/com.apple.SpringBoard --environment DYLD_INSERT_LIBRARIES=~/Desktop/FLEXDylib.dylib:~/Desktop/stuff.dylib

// xcrun simctl spawn booted launchctl stop com.apple.SpringBoard



