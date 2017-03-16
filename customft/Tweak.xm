#import <CoreGraphics/CoreGraphics.h>
#include <libactivator/libactivator.h>
#import <UIKit/UIKit.h>

#import "customft/BTOShortCutManager.h"
#import "customft/BTOAddShortCutViewController.h"

#define NSLog(FORMAT, ...) NSLog(@"[%@]: %@",@"Traverse" , [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])


@interface SBApplicationShortcutStoreManager : NSObject
+ (id)sharedManager;
- (void)saveSynchronously;
- (void)setShortcutItems:(id)arg1 forBundleIdentifier:(id)arg2;
- (id)shortcutItemsForBundleIdentifier:(NSString*)arg1;
- (id)init;
@end
@interface SBApplication : NSObject
@property(copy, nonatomic) NSArray *staticShortcutItems;
- (NSString*)bundleIdentifier;
@end;
@interface SBApplicationShortcutMenu : UIView
@property(retain, nonatomic) SBApplication *application;
- (void)dismissAnimated:(_Bool)arg1 completionHandler:(id)arg2;
- (id)_shortcutItemsToDisplay;
@end
@interface SpringBoard : UIApplication
- (void)reboot;
- (void)powerDown;
@end
@interface SBApplicationShortcutMenuContentView : UIView
@end

@interface UIApplicationShortcutIcon()
@end
@interface SBSApplicationShortcutIcon : NSObject
@end
@interface SBSApplicationShortcutItem : NSObject
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
@end
@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
- (id)initWithType:(UIApplicationShortcutIconType)arg1;
@end
@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
- (id)initWithImagePNGData:(id)arg1;
@end
@interface SBSApplicationShortcutContactIcon : SBSApplicationShortcutIcon
-(instancetype)initWithContactIdentifier:(NSString *)contactIdentifier;
-(instancetype)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName;
-(instancetype)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName imageData:(NSData*)imageData;
@end

%hook SBApplicationShortcutStoreManager
- (id)shortcutItemsForBundleIdentifier:(NSString*)arg1 {
		NSString *bundleID = arg1;
		NSArray *aryItems = [NSArray new];
		if (%orig != NULL || %orig != nil) {
			aryItems = %orig;
		}
		NSMutableArray *aryShortcuts = [aryItems mutableCopy];

		if ([[BTOShortCutManager sharedInstance] containsBundleID:bundleID] == YES) {
			NSArray *aryObjects = [[BTOShortCutManager sharedInstance] shortCutsForAppWithBundleID:bundleID];
			NSMutableArray *correctObjects = [NSMutableArray new];

			for (NSArray *item in aryObjects) {
				SBSApplicationShortcutItem *action = [[SBSApplicationShortcutItem alloc] init];
				if ([[item objectAtIndex:4] intValue] == 7) {
					[action setIcon:[[SBSApplicationShortcutCustomImageIcon alloc] initWithImagePNGData:[[BTOShortCutManager sharedInstance] customImageForBundleID:[item objectAtIndex:2] withTitle:[item objectAtIndex:0]]]];
				} else {
					[action setIcon:[[SBSApplicationShortcutSystemIcon alloc] initWithType:[[BTOShortCutManager sharedInstance] iconTypeForNumber:[[item objectAtIndex:4] intValue]]]];
				}
				[action setLocalizedTitle:[item objectAtIndex:0]];
				if ([[item objectAtIndex:1] isEqualToString:@"*ignore*"]) {
					[action setLocalizedSubtitle:nil];
				} else {
					[action setLocalizedSubtitle:[item objectAtIndex:1]];
				}
				[action setType:[NSString stringWithFormat:@"%@-%@",[item objectAtIndex:2],[item objectAtIndex:0]]];
				[correctObjects addObject:action];
			}
			[aryShortcuts addObjectsFromArray:correctObjects];
		}
		return aryShortcuts;
}
%end

%hook SBApplicationShortcutMenuContentView
- (id)initWithInitialFrame:(struct CGRect)arg1 containerBounds:(struct CGRect)arg2 orientation:(long long)arg3 shortcutItems:(NSArray <UIApplicationShortcutItem *>*)arg4 application:(SBApplication*)arg5 {
	// NSLog(@"%@",[%c(LAActivator) sharedInstance].availableEventNames);
	return %orig;
}
%end

%hook SBApplicationShortcutMenu
- (id)_shortcutItemsToDisplay {


	if (self.application == nil) {
		return %orig;
	}
	NSMutableArray *objects = [NSMutableArray new];
	[objects addObjectsFromArray:self.application.staticShortcutItems];
	[objects addObjectsFromArray:[[%c(SBApplicationShortcutStoreManager) sharedManager] shortcutItemsForBundleIdentifier:self.application.bundleIdentifier]];

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.customft"];
	if ([prefs boolForKey:@"addMenu"] == YES) {
			if ([prefs boolForKey:@"addNotEvery"] == NO) {
				SBSApplicationShortcutItem *newAction = [[SBSApplicationShortcutItem alloc] init];
				[newAction setIcon:[[SBSApplicationShortcutSystemIcon alloc] initWithType:UIApplicationShortcutIconTypeAdd]];
				[newAction setLocalizedTitle:@"New"];
				[newAction setLocalizedSubtitle:@"Add New Action"];
				[newAction setType:@"com.bolencki13.customft-newAction"];
				[objects addObject:newAction];
			} else if ([prefs boolForKey:@"addNotEvery"] == YES && [objects count] == 0) {
				SBSApplicationShortcutItem *newAction = [[SBSApplicationShortcutItem alloc] init];
				[newAction setIcon:[[SBSApplicationShortcutSystemIcon alloc] initWithType:UIApplicationShortcutIconTypeAdd]];
				[newAction setLocalizedTitle:@"New"];
				[newAction setLocalizedSubtitle:@"Add New Action"];
				[newAction setType:@"com.bolencki13.customft-newAction"];
				[objects addObject:newAction];
			}
	}

	return objects;
}
- (void)menuContentView:(id)arg1 activateShortcutItem:(UIApplicationShortcutItem*)arg2 index:(long long)arg3 {
	NSString *input = arg2.type;
	if ([input isEqualToString:@"com.bolencki13.customft-newAction"]) {
		[self dismissAnimated:YES completionHandler:nil];
		BTOAddShortCutViewController *controller = [BTOAddShortCutViewController new];
		controller.isOutsideSettings = YES;

		UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
		UIViewController *rootView = [[UIApplication sharedApplication].keyWindow rootViewController];
		[rootView presentViewController:navigation animated:YES completion:^{
			controller.txtBundleID.text = self.application.bundleIdentifier;
    }];
		return;
	}
	NSString *bundleID = @"";
	NSString *title = @"";

	if ([input containsString:@"-"]) {
		NSArray *arySplitString = [input componentsSeparatedByString:@"-"];
		bundleID = [arySplitString objectAtIndex:0];
		title = [arySplitString objectAtIndex:1];
  }

	if ([[BTOShortCutManager sharedInstance] containsBundleID:bundleID] == YES) {

		NSString *url = [[BTOShortCutManager sharedInstance] getURLSchemeForBundleID:bundleID withTitle:title];

		if ([url isEqualToString:@"respring"]) {
				system("killall backboardd");
		} else if ([url isEqualToString:@"shutdown"]) {
				[[%c(SpringBoard) sharedApplication] powerDown];
		} else if ([url isEqualToString:@"reboot"]) {
				[[%c(SpringBoard) sharedApplication] reboot];
		} else if ([url isEqualToString:@"safemode"]) {
				NSArray *aryTemp = @[@"Crash"];
				NSString *crashTime;
				crashTime = [aryTemp objectAtIndex:2];
		} else if ([url containsString:@"shellScript://"]) {
			const char *command = [[url stringByReplacingOccurrencesOfString:@"shellScript://" withString:@""] UTF8String];
			system(command);
		} else if ([url containsString:@"activator://"]) {
			NSString *BTOShortCutActivatorEventName = [url stringByReplacingOccurrencesOfString:@"activator://" withString:@""];
			LAEvent *event = [%c(LAEvent) eventWithName:BTOShortCutActivatorEventName mode:[[%c(LAActivator) sharedInstance] currentEventMode]];
			[[%c(LAActivator) sharedInstance] sendEventToListener:event];
		} else {
			if ([url containsString:@"\%@"]) {
				UIAlertController *alert = [UIAlertController
																		alertControllerWithTitle:@"Traverse"
																		message:@"Enter Search Parameters"
																		preferredStyle:UIAlertControllerStyleAlert];

				UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault
																								 handler:^(UIAlertAction * action) {
																										 UITextField *txtInput = [alert.textFields objectAtIndex:0];
																										 NSString *finalURL = [NSString stringWithFormat:@"%@%@",[url stringByReplacingOccurrencesOfString:@"\%@" withString:@""],[txtInput.text stringByReplacingOccurrencesOfString:@" " withString:@"\%20"]];
																										 [[%c(SpringBoard) sharedApplication] applicationOpenURL:[NSURL URLWithString:finalURL]];
																								 }];
				UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
																										 handler:^(UIAlertAction * action) {
																												 [alert dismissViewControllerAnimated:YES completion:nil];
																										 }];
				[alert addAction:ok];
				[alert addAction:cancel];

				[alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
						textField.placeholder = @"Search Text";
				}];
				UIViewController *rootView = [[UIApplication sharedApplication].keyWindow rootViewController];
				[rootView presentViewController:alert animated:YES completion:nil];
			} else {
				[[%c(SpringBoard) sharedApplication] applicationOpenURL:[NSURL URLWithString:url]];
			}
		}

		[self dismissAnimated:YES completionHandler:nil];
	} else {
		%orig;
	}
}

%end

@interface UIVisualEffectView(Private)
- (void)_setEffect:(id)arg1;
@end
%hook SBApplicationShortcutMenuBackgroundView
- (void)layoutSubviews {
	%orig;

	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/org.thebigboss.shortcutix.list"]) {
		return;
	}

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.customft"];
	switch ([prefs integerForKey:@"blur"]) {
    case 0: {
		UIVisualEffectView *mybackdropView = MSHookIvar<UIVisualEffectView *>(self, "_backdropView");
		[mybackdropView _setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
	}break;
		case 1:{
		UIVisualEffectView *mybackdropView = MSHookIvar<UIVisualEffectView *>(self, "_backdropView");
		[mybackdropView _setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
	}break;
		case 2:{
		UIVisualEffectView *mybackdropView = MSHookIvar<UIVisualEffectView *>(self, "_backdropView");
		[mybackdropView _setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
	}break;

    default:{
		UIVisualEffectView *mybackdropView = MSHookIvar<UIVisualEffectView *>(self, "_backdropView");
		[mybackdropView _setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
	}break;
    }
}
%end

@interface SBApplicationShortcutMenuItemView : UIView
@property(retain, nonatomic) UIApplicationShortcutItem *shortcutItem; // @synthesize shortcutItem=_shortcutItem;
- (UIImage *)invertImage:(UIImage *)image;
@end
%hook SBApplicationShortcutMenuItemView
- (id)initWithShortcutItem:(id)arg1 menuPosition:(long long)arg2 orientation:(long long)arg3 application:(id)arg4 assetManagerProvider:(id)arg5 monogrammerProvider:(id)arg6 options:(unsigned long long)arg7 {

	return %orig;
}
- (void)_setupViewsWithIcon:(id)arg1 title:(id)arg2 subtitle:(id)arg3 {
	%orig;

	if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/org.thebigboss.shortcutix.list"]) {
		return;
	}

	UILabel *mytitleLabel = MSHookIvar<UILabel *>(self, "_titleLabel");

	UIImageView *myiconView = MSHookIvar<UIImageView *>(self, "_iconView");
	if ([[NSString stringWithFormat:@"%@",[mytitleLabel.text lowercaseString]] isEqualToString:@"respring"]) {
			myiconView.image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/CustomFT/kCustomFT.bundle/respring.png"];
	} else if ([[NSString stringWithFormat:@"%@",[mytitleLabel.text lowercaseString]] isEqualToString:@"reboot"]) {
			myiconView.image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/CustomFT/kCustomFT.bundle/reboot.png"];
	} else if ([[NSString stringWithFormat:@"%@",[mytitleLabel.text lowercaseString]] isEqualToString:@"shutdown"]) {
			myiconView.image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/CustomFT/kCustomFT.bundle/powerOff.png"];
	} else if ([[NSString stringWithFormat:@"%@",[mytitleLabel.text lowercaseString]] isEqualToString:@"safemode"] || [[NSString stringWithFormat:@"%@",[mytitleLabel.text lowercaseString]] isEqualToString:@"safe mode"]) {
			myiconView.image = [UIImage imageWithContentsOfFile:@"/Library/Application Support/CustomFT/kCustomFT.bundle/safeMode.png"];
	}

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.bolencki13.customft"];

	if ([prefs integerForKey:@"blur"] == 2) {
		UILabel *mytitleLabel = MSHookIvar<UILabel *>(self, "_titleLabel");
		UIImageView *myiconView = MSHookIvar<UIImageView *>(self, "_iconView");

		mytitleLabel.textColor = [UIColor whiteColor];

		UILabel *mysubtitleLabel = MSHookIvar<UILabel *>(self, "_subtitleLabel");
		mysubtitleLabel.textColor = [UIColor whiteColor];

		if ([arg3 isEqualToString:@"FaceTime"] || [arg3 isEqualToString:@"home"] || [arg3 isEqualToString:@"work"] || [arg3 isEqualToString:@"iPhone"] || [arg3 isEqualToString:@"mobile"] || [arg3 isEqualToString:@"main"] || [arg3 isEqualToString:@"home fax"] || [arg3 isEqualToString:@"work fax"] || [arg3 isEqualToString:@"pager"] || [arg3 isEqualToString:@"other"]) return;

		myiconView.image = [self invertImage:myiconView.image];
	}
}
%new
- (UIImage *)invertImage:(UIImage *)originalImage {
    UIGraphicsBeginImageContext(originalImage.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
    CGRect imageRect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    [originalImage drawInRect:imageRect];

    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, originalImage.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    //mask the image
    CGContextClipToMask(UIGraphicsGetCurrentContext(), imageRect,  originalImage.CGImage);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(),[UIColor whiteColor].CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, originalImage.size.width, originalImage.size.height));
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return returnImage;
}
%end



// static NSString *BTO_TraverseEventDummy1 = @"com.bolencki13.traverse.dummy.one";
// static NSString *BTO_TraverseEventDummy2 = @"com.bolencki13.traverse.dummy.two";
// static NSString *BTO_TraverseEventDummy3 = @"com.bolencki13.traverse.dummy.three";
//
// @interface BTO_TraverseEventDataSource: NSObject <LAEventDataSource> {
// }
// + (id)sharedInstance;
// @end
// @implementation BTO_TraverseEventDataSource
// + (id)sharedInstance {
// 	static BTO_TraverseEventDataSource *shared = nil;
// 	if (!shared) {
// 		shared = [[BTO_TraverseEventDataSource alloc] init];
// 	}
// 	return shared;
// }
// - (id)init {
// 	if ((self = [super init])) {
// 		[[objc_getClass("LAActivator") sharedInstance] registerEventDataSource:self forEventName:BTO_TraverseEventDummy1];
// 		[[objc_getClass("LAActivator") sharedInstance] registerEventDataSource:self forEventName:BTO_TraverseEventDummy2];
// 		[[objc_getClass("LAActivator") sharedInstance] registerEventDataSource:self forEventName:BTO_TraverseEventDummy3];
// 	}
// 	return self;
// }
// - (void)dealloc {
// 	if ([[objc_getClass("LAActivator") sharedInstance] isRunningInsideSpringBoard]) {
// 		[[objc_getClass("LAActivator") sharedInstance] unregisterEventDataSourceWithEventName:BTO_TraverseEventDummy1];
// 		[[objc_getClass("LAActivator") sharedInstance] unregisterEventDataSourceWithEventName:BTO_TraverseEventDummy2];
// 		[[objc_getClass("LAActivator") sharedInstance] unregisterEventDataSourceWithEventName:BTO_TraverseEventDummy3];
// 	}
// 	[super dealloc];
// }
// - (NSString *)localizedTitleForEventName:(NSString *)eventName {
// 	NSString *title = @"";
//
// 	if ([eventName isEqualToString:BTO_TraverseEventDummy1]) {
// 		title = @"Dummy One";
// 	} else if ([eventName isEqualToString:BTO_TraverseEventDummy2]) {
// 		title = @"Dummy Two";
// 	} else if ([eventName isEqualToString:BTO_TraverseEventDummy3]) {
// 		title = @"Dummy Three";
// 	}
//
// 	return title;
// }
// - (NSString *)localizedGroupForEventName:(NSString *)eventName {
// 	return @"Traverse";
// }
// - (NSString *)localizedDescriptionForEventName:(NSString *)eventName {
// 	NSString *description = @"";
//
// 	if ([eventName isEqualToString:BTO_TraverseEventDummy1]) {
// 		description = @"Dummy Event #1 for Traverse";
// 	} else if ([eventName isEqualToString:BTO_TraverseEventDummy2]) {
// 		description = @"Dummy Event #2 for Traverse";
// 	} else if ([eventName isEqualToString:BTO_TraverseEventDummy3]) {
// 		description = @"Dummy Event #3 for Traverse";
// 	}
//
// 	return description;
// }
// - (BOOL)eventWithNameIsHidden:(NSString *)eventName {
// 	return NO;
// }
// - (BOOL)eventWithNameRequiresAssignment:(NSString *)eventName {
// 	return NO;
// }
// - (BOOL)eventWithName:(NSString *)eventName isCompatibleWithMode:(NSString *)eventMode {
//   if ([eventMode isEqualToString:@"springboard"]) {
//     return YES;
//   }
//   return NO;
// }
// - (BOOL)eventWithNameSupportsUnlockingDeviceToSend:(NSString *)eventName {
// 	return NO;
// }
// @end
// %ctor {
// 	%init;
// 	[%c(BTO_TraverseEventDataSource) sharedInstance];
// }



// %hook SpringBoard
// - (void)applicationDidFinishLaunching {
// 	%orig;
//
// #define INITIAL_SET_UP(file) if ([file isEqualToString:@"/var/lib/dpkg/info/com.bolencki13.customft.list"] || [file isEqualToString:@"/var/lib/dpkg/info/org.thebigboss.customft.list"]) { if([[NSFileManager defaultManager] fileExistsAtPath:file]) { [[[UIAlertView alloc] initWithTitle:@"CustomFT" message:@"Please buy CustomFT. The developer put a lot of effort into it." delegate:nil cancelButtonTitle:@"I'll buy it" otherButtonTitles:nil, nil] show]; } } else { [[[UIAlertView alloc] initWithTitle:@"CustomFT" message:@"Please buy CustomFT. The developer put a lot of effort into it." delegate:nil cancelButtonTitle:@"I'll buy it" otherButtonTitles:nil, nil] show];};
// #define SET_UP @"/var/lib/dpkg/info/com.bolencki13.customft.list"
//     INITIAL_SET_UP(SET_UP);
// #undef INITIAL_SET_UP
// #undef SET_UP
// }
// %end
