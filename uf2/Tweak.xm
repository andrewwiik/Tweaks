#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@interface _UITouchForceMessage : NSObject
@property (nonatomic) double timestamp;
@property (nonatomic) float unclampedTouchForce;
- (void)setUnclampedTouchForce:(float)touchForce;
- (float)unclampedTouchForce;
@end

@interface UITouch (Private)
- (void)_setPressure:(float)arg1 resetPrevious:(BOOL)arg2;
- (float)_pathMajorRadius;
- (float)majorRadius;
@end

@interface UIPreviewInteractionController : NSObject
- (BOOL)startInteractivePreviewAtLocation:(id)arg1 inView:(id)arg2;
- (BOOL)startInteractivePreviewWithGestureRecognizer:(id)arg1;
- (void)commitInteractivePreview;
@end

@interface SBIconController : UIViewController
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

extern "C" void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id unknown, NSDictionary *options);
void hapticPeekVibe(){
        NSMutableDictionary* VibrationDictionary = [NSMutableDictionary dictionary];
        NSMutableArray* VibrationArray = [NSMutableArray array ];
        [VibrationArray addObject:[NSNumber numberWithBool:YES]];
        [VibrationArray addObject:[NSNumber numberWithInt:30]]; //vibrate for 50ms
        [VibrationDictionary setObject:VibrationArray forKey:@"VibePattern"];
        [VibrationDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
        AudioServicesPlaySystemSoundWithVibration(4095,nil,VibrationDictionary);
}

void hapticPopVibe(){
        NSMutableDictionary* VibrationDictionary = [NSMutableDictionary dictionary];
        NSMutableArray* VibrationArray = [NSMutableArray array ];
        [VibrationArray addObject:[NSNumber numberWithBool:YES]];
        [VibrationArray addObject:[NSNumber numberWithInt:30]]; //vibrate for 50ms
        [VibrationDictionary setObject:VibrationArray forKey:@"VibePattern"];
        [VibrationDictionary setObject:[NSNumber numberWithInt:2] forKey:@"Intensity"];
        AudioServicesPlaySystemSoundWithVibration(4095,nil,VibrationDictionary);
}

static int HardPress;
// static BOOL isKeyboardShowing;

static double xT;
static double yT;

/*static BOOL [[prefs objectForKey:@"Enabled"] boolValue];
static BOOL [prefs boolForKey:@"messageActionsEnabled"];
static BOOL [[prefs objectForKey:@"hapticFeedbackPeekEnabled"] boolValue];
static BOOL [prefs boolForKey:@"hapticFeedbackPopEnabled"];
static CGFloat [[prefs objectForKey:@"peekForceSensitivity"] floatValue];
static CGFloat [[prefs objectForKey:@"popForceSensitivity"] floatValue]; */
#define PREFS_BUNDLE_ID (@"com.creatix.peekaboo")

NSDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creatix.peekaboo.plist"];
//NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:PREFS_BUNDLE_ID];
static float peek = [[prefs objectForKey:@"peekForceSensitivity"] floatValue];
static float pop = [[prefs objectForKey:@"popForceSensitivity"] floatValue];

static void reloadPrefs() {
	dispatch_async(dispatch_get_main_queue(), ^{
		prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creatix.peekaboo.plist"];

		peek = [[prefs objectForKey:@"peekForceSensitivity"] floatValue];
		pop = [[prefs objectForKey:@"popForceSensitivity"] floatValue];
		if ([prefs objectForKey:@"popForceSensitivity"]) {
			NSUserDefaults *prefs2 = [[NSUserDefaults alloc] initWithSuiteName:PREFS_BUNDLE_ID];
			[prefs2 setBool:YES forKey:@"defaultsSet"];
			//NSLog([prefsDict objectForKey:@"popForceSensitivity"] ? @"Yes" : @"No");
		}
		if (![[prefs objectForKey:@"defaultsSet"] boolValue]) {
			NSUserDefaults *prefs2 = [[NSUserDefaults alloc] initWithSuiteName:PREFS_BUNDLE_ID];
			[prefs2 setBool:YES forKey:@"Enabled"];
			[prefs2 setBool:YES forKey:@"hapticFeedbackPeekEnabled"];
			[prefs2 setBool:YES forKey:@"hapticFeedbackPopEnabled"];
			[prefs2 setBool:YES forKey:@"messageActionsEnabled"];
			[prefs2 setBool:YES forKey:@"defaultsSet"];
			[prefs2 setFloat:48.37f forKey:@"peekForceSensitivity"];
			[prefs2 setFloat:60.38f forKey:@"popForceSensitivity"];
		}
		// [prefs registerDefaults:prefsDict];
	});
}

// %hook UIKeyboardImpl
// - (void)showKeyboard {
// 	%orig;
// 	isKeyboardShowing = YES;
// }
// - (void)dismissKeyboard {
// 	%orig;
// 	isKeyboardShowing = NO;
// }
// %end
%hook UITouch
 - (void)setMajorRadius:(float)arg1 {
 	reloadPrefs();
 	xT = [self _pathMajorRadius];

 	//NSLog(@"Prefs: %@", prefs);
 	// [prefs registerDefaults:prefsDict];
 	//NSLog(@"Prefs: %@", prefs);
 	//reloadPrefs();
 	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
		if (![[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com1.apple.springboard"]) {
	 		float lightPress = peek;
	 		float DeepPress = pop;
	 		if ([self _pathMajorRadius] > DeepPress) {
				//MSHookIvar<float>(self,"_pressure") = 1;
				HardPress = 3;
				//[[prefs objectForKey:@"popForceSensitivity"] floatValue] = 4.0f;
			}
			else if ([self _pathMajorRadius] > lightPress) {
				//MSHookIvar<float>(self,"_pressure") = 1;
				HardPress = 2;
	    	}
			else if ([self _pathMajorRadius] < lightPress) {
				//MSHookIvar<float>(self,"_pressure") = 1;
				HardPress = 1;
			}
		}
	}
	%orig;
}
%end
%hook UIScreen
- (long long)_forceTouchCapability {
	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
		return 2;
	}
	else {
		return %orig;
	}
}
%end

%hook UITraitCollection
- (int)forceTouchCapability {
	return 2;
}
+ (id)traitCollectionWithForceTouchCapability:(int)arg1 {
	return %orig(2);
}
%end

%hook UIDevice
- (BOOL)_supportsForceTouch {
	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
		return TRUE;
	}
	else {
		return %orig;
	}
}
%end
%hook _UITouchForceMessage
- (void)setUnclampedTouchForce:(CGFloat)touchForce {
	yT = xT * (peek/1000);
	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
		if (HardPress == 3) {
			if (sizeof(void*) == 4) {
	      		%orig((float) yT);
	    	}
	    	else if (sizeof(void*) == 8) {
	      		%orig((double) yT);
	    	}
		}
		if (HardPress == 2) {
			if (sizeof(void*) == 4) {
	      		%orig((float) yT);
	    	} 
	    	else if (sizeof(void*) == 8) {
	      		%orig((double) yT);
	    	}
		}
		if (HardPress == 1) {
			if (sizeof(void*) == 4) {
	      		%orig((float) yT);
	    	} 
	    	else if (sizeof(void*) == 8) {
	      		%orig((double) yT);
	    	}
		}
	}
	else {
  		%orig;
	}
}
%end

// %hook UIPreviewInteractionController
// - (BOOL)startInteractivePreviewAtLocation:(id)arg1 inView:(id)arg2 {
// 	//%orig;
// 	if ([[prefs objectForKey:@"hapticFeedbackPeekEnabled"] boolValue] && [[prefs objectForKey:@"Enabled"] boolValue]) {
// 		hapticPeekVibe();
// 	}
// 	return %orig;
// }

// - (BOOL)startInteractivePreviewWithGestureRecognizer:(id)arg1 {
// 	//%orig;
// 	if ([[prefs objectForKey:@"hapticFeedbackPeekEnabled"] boolValue] && [[prefs objectForKey:@"Enabled"] boolValue]) {
// 		hapticPeekVibe();
// 	}
// 	return %orig;
// }

// - (void)commitInteractivePreview {
// 	%orig;
// 	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
// 		if ([[prefs objectForKey:@"hapticFeedbackPopEnabled"] boolValue]) {
// 			//NSLog(@"Haptic Feed Back POP");
// 			//NSLog([[prefs objectForKey:@"Enabled"] boolValue] ? @"Yes" : @"No");
// 			//NSLog([prefs boolForKey:@"hapticFeedbackPopEnabled"] ? @"Yes" : @"No");
// 			//NSLog([[prefs objectForKey:@"hapticFeedbackPeekEnabled"] boolValue] ? @"Yes" : @"No");
// 			hapticPopVibe();
// 		}
// 	}
// }
// %end

%group Messages
@interface CKConversationListCell : UITableViewCell
- (void)layoutSubviews;
@end

@interface CKConversationListController : UITableViewController
- (id)registerForPreviewingWithDelegate:(id)arg1 sourceView:(id)arg2;
@end

%hook CKConversationListController
- (void)viewDidLoad {
	%orig;
	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
		[self registerForPreviewingWithDelegate:self sourceView:self.tableView];
	}
}
%end

%hook CKConversationListCell
- (void)layoutSubviews {
	%orig;
	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
		while (self.gestureRecognizers.count) {
    	    [self removeGestureRecognizer:[self.gestureRecognizers objectAtIndex:0]];
    	}
    }
}
%end

%hook CKTranscriptPreviewController
- (id)previewMenuItems {
	if ([[prefs objectForKey:@"messageActionsEnabled"] boolValue] && [[prefs objectForKey:@"Enabled"] boolValue]) {
		return %orig;
	}
	else {
		return NULL;
	}
}
%end
%end

@interface IGFeedItemPreviewingHandler : NSObject
- (id)initWithController:(id)arg1;
@end

@interface IGMainFeedViewController : UIViewController
- (id)registerForPreviewingWithDelegate:(id)arg1 sourceView:(id)arg2;
@end

%hook IGMainFeedViewController
- (id)init {
	%orig;
	[self registerForPreviewingWithDelegate:[[%c(IGFeedItemPreviewingHandler) alloc] initWithController:self] sourceView:self.view];
	return %orig;
}
%new
- (id)feedTestSeven {
	return [[%c(IGFeedItemPreviewingHandler) alloc] initWithController:self];
}
%end


%hook SBIconController
%new
- (void)_revealMenuForIconView:(id)iconView presentImmediately:(BOOL)arg2 {
  [self _revealMenuForIconView:iconView];
}
%end

%ctor {
	reloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback)reloadPrefs,
        CFSTR("com.creatix.switchservice.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	 %init;
	if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.MobileSMS"]) { // Messages App
          %init(Messages);
      }
} 