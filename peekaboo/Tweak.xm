#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#include <spawn.h>
#include <dispatch/dispatch.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <substrate.h>
#import "headers.h"

// %config(generator=internal);

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

id callSuper(Class classPassed, id object, SEL selector) {
	objc_super $super = {object, classPassed};
	return objc_msgSendSuper(&$super, selector);
}

static int HardPress;
// static BOOL isKeyboardShowing;

static CGFloat xT;
static CGFloat yT;

/*static BOOL [[prefs objectForKey:@"Enabled"] boolValue];
static BOOL [prefs boolForKey:@"messageActionsEnabled"];
static BOOL [[prefs objectForKey:@"hapticFeedbackPeekEnabled"] boolValue];
static BOOL [prefs boolForKey:@"hapticFeedbackPopEnabled"];
static CGFloat [[prefs objectForKey:@"peekForceSensitivity"] floatValue];
static CGFloat [[prefs objectForKey:@"popForceSensitivity"] floatValue]; */
#define PREFS_BUNDLE_ID (@"com.creatix.peekaboo")

NSDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creatix.peekaboo.plist"];
//NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:PREFS_BUNDLE_ID];
static CGFloat peek = [[prefs objectForKey:@"peekForceSensitivity"] floatValue];
static CGFloat pop = [[prefs objectForKey:@"popForceSensitivity"] floatValue];

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
 - (void)setMajorRadius:(CGFloat)arg1 {
 	reloadPrefs();
 	xT = arg1;

 	//NSLog(@"Prefs: %@", prefs);
 	// [prefs registerDefaults:prefsDict];
 	//NSLog(@"Prefs: %@", prefs);
 	//reloadPrefs();
 	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
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
	%orig;
}
- (CGFloat)_pressure {
    yT = xT * (peek/1000);
    return yT;
}
- (BOOL)_supportsForce {
	return YES;
}
- (CGFloat)_unclampedForce {
	yT = xT * (peek/750);
    return yT;
}
-(void)_setPressure:(CGFloat)arg1 resetPrevious:(BOOL)arg2 {
	yT = xT * (peek/1000);
	%orig(yT,arg2);
}

%end
%hook UIScreen
- (NSInteger)_forceTouchCapability {
	return 2;
}
%end

%hook UITraitCollection
- (NSInteger)forceTouchCapability {
	return 2;
}
+ (id)traitCollectionWithForceTouchCapability:(NSInteger)arg1 {
	return %orig(2);
}
%end

%hook UIDevice
- (BOOL)_supportsForceTouch {
		return TRUE;
}
// - (NSInteger)_feedbackSupportLevel {
// 	return 3;
// }
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
		else if (HardPress == 2) {
			if (sizeof(void*) == 4) {
	      		%orig((float) yT);
	    	} 
	    	else if (sizeof(void*) == 8) {
	      		%orig((double) yT);
	    	}
		}
		else if (HardPress == 1) {
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

%hook _UIForceMessage
- (void)setTouchForce:(CGFloat)touchForce {
	yT = xT * (peek/1000);
	%orig(yT);
	return;
	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
		if (HardPress == 3) {
			if (sizeof(void*) == 4) {
	      		%orig((float) yT);
	    	}
	    	else if (sizeof(void*) == 8) {
	      		%orig((double) yT);
	    	}
		}
		else if (HardPress == 2) {
			if (sizeof(void*) == 4) {
	      		%orig((float) yT);
	    	} 
	    	else if (sizeof(void*) == 8) {
	      		%orig((double) yT);
	    	}
		}
		else if (HardPress == 1) {
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
- (CGFloat)touchForce {
	yT = xT * (peek/1000);
	return yT;
}
%end

%hook _UITouchForceObservationMessageReader
- (void)setTouchForce:(CGFloat)touchForce {
	yT = xT * (peek/1000);
	%orig(yT);
	return;
	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
		if (HardPress == 3) {
			if (sizeof(void*) == 4) {
	      		%orig((float) yT);
	    	}
	    	else if (sizeof(void*) == 8) {
	      		%orig((double) yT);
	    	}
		}
		else if (HardPress == 2) {
			if (sizeof(void*) == 4) {
	      		%orig((float) yT);
	    	} 
	    	else if (sizeof(void*) == 8) {
	      		%orig((double) yT);
	    	}
		}
		else if (HardPress == 1) {
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
- (CGFloat)touchForce {
	yT = xT * (peek/1000);
	return yT;
}
%end

%hook _UIDeepPressAnalyzer
- (CGFloat)_touchForceFromTouches:(id)arg1 {
	yT = xT * (peek/1000);
	return yT;
}
%end

%hook _UIPreviewInteractionSystemAnimator
- (void)setTouchForce:(CGFloat)touchForce {
	yT = xT * (peek/1000);
	%orig(yT);
	return;
	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
		if (HardPress == 3) {
			if (sizeof(void*) == 4) {
	      		%orig((float) yT);
	    	}
	    	else if (sizeof(void*) == 8) {
	      		%orig((double) yT);
	    	}
		}
		else if (HardPress == 2) {
			if (sizeof(void*) == 4) {
	      		%orig((float) yT);
	    	} 
	    	else if (sizeof(void*) == 8) {
	      		%orig((double) yT);
	    	}
		}
		else if (HardPress == 1) {
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
- (CGFloat)touchForce {
	yT = xT * (peek/1000);
	return yT;
}
%end



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


@interface PUPhotosAlbumViewController : UICollectionViewController
- (id)registerForPreviewingWithDelegate:(id)arg1 sourceView:(id)arg2;
@end
// %hook PUPhotosAlbumViewController
// - (void)viewDidLoad {
// 	%orig;
// 	[self registerForPreviewingWithDelegate:self sourceView:self.collectionView];
// }
// %new
// - (void)fixPreview {
// }
// %end

%group Photos
%hook UICollectionView
- (void)setDelegate:(id)arg1 {
	%orig;
	if (
		[arg1 respondsToSelector:@selector(previewingContext:viewControllerForLocation:)] &&
		[arg1 respondsToSelector:@selector(previewingContext:commitViewController:)]
	) {
		[arg1 performSelector:@selector(registerForPreviewingWithDelegate:sourceView:) withObject:arg1 withObject:self];

	}
}
%end
%end

extern "C" BOOL MGGetBoolAnswer(CFStringRef);
%hookf(BOOL, MGGetBoolAnswer, CFStringRef key)
{
	#define k(key_) CFEqual(key, CFSTR(key_))
	if (k("eQd5mlz0BN0amTp/2ccMoA")
	 	|| k("n/aVhqpGjESEbIjvJbEHKg") 
	  	|| k("+fgL2ovGydvB5CWd1JI1qg") )
		return YES;
	return %orig;
}

// extern "C" CFPropertyListRef MGCopyAnswer(CFStringRef);
// %hookf(CFPropertyListRef, MGCopyAnswer, CFStringRef key)
// {
// 	// #define k(key_) CFEqual(key, CFSTR(key_))
// 	// if (k("SupportsForceTouch"))
// 	// 	return kCFBooleanTrue;
// 	return %orig;
// }

// %hook _UITouchForceObservable
// - (CGFloat)_unclampedTouchForceForTouches:(NSArray *)touches {
// 	yT = xT * (peek/1000);
//     return yT;
// }
// %end

static NSInteger const UITapticEngineFeedbackPeek = 0;
static NSInteger const UITapticEngineFeedbackPop = 1;
static NSInteger const UITapticEngineFeedbackCancel = 2;

%hook _UITapticEngine
-(void)actuateFeedback:(NSInteger)feedback {
	NSLog(@"FEEDBACK ACTUATED: %@", [NSNumber numberWithInt:feedback]);
	if (feedback == UITapticEngineFeedbackPop) {
		hapticPopVibe();
	} else if (feedback == UITapticEngineFeedbackPeek) {
		hapticPeekVibe();
	} else if (feedback == UITapticEngineFeedbackCancel) {
		hapticPeekVibe();
	}
	%orig;
}
- (void)setFeedbackBehavior:(id)behavior {
	NSLog(@"SET BEHAVIOR");
	%orig;
}
%end

%hook NCTransitionManager
-(void)longLookTransitionDelegate:(id)arg1 didBeginTransitionWithAnimator:(id)arg2 {
	hapticPeekVibe();
	%orig;
}
%end

%hook _UIFeedbackAVHapticPlayer
-(void)_playFeedback:(id)arg1 atTime:(CGFloat)arg2  {
	//hapticPeekVibe();
	NSLog(@"FEEDBACK: %@\n TIME: %@", arg1, [NSNumber numberWithFloat:arg2]);
	return;
}
%end

// %hook _UIFeedbackHapticEngine
// +(BOOL)_supportsPlayingFeedback:(id)arg1 {
// 	return YES;
// }
// %end
%hook HapticClient 
- (id)initAndReturnError:(id*)error {
	return [NSClassFromString(@"HapticClient") new];
}

- (void)doInit {
	return;
}
-(BOOL)setupConnectionAndReturnError:(id*)arg1 {
	// NSLog(@"CALLED SOMETHING HAPTICS");
	return YES;
}
-(BOOL)loadHapticPreset:(id)arg1 error:(id*)arg2 {
	NSLog(@"CALLED SOMETHING HAPTICS 1");
	return YES;
}
-(BOOL)prepareHapticSequence:(unsigned long long)arg1 error:(id*)arg2  {
	NSLog(@"CALLED SOMETHING HAPTICS 2");
	return YES;
}
-(BOOL)enableSequenceLooping:(unsigned long long)arg1 enable:(BOOL)arg2 error:(id*)arg3 {
	NSLog(@"CALLED SOMETHING HAPTICS 3");
	return YES;
}
-(BOOL)startHapticSequence:(unsigned long long)arg1 atTime:(double)arg2 withOffset:(double)arg3 {
	NSLog(@"CALLED SOMETHING HAPTICS 4");
	return YES;
}
-(BOOL)stopHapticSequence:(unsigned long long)arg1 atTime:(double)arg2 {
	NSLog(@"CALLED SOMETHING HAPTICS 5");
	return YES;
}
-(BOOL)detachHapticSequence:(unsigned long long)arg1 atTime:(double)arg2 {
	NSLog(@"CALLED SOMETHING HAPTICS 6");
	return YES;
}
-(void)startRunning:(/*^block*/id)arg1 {
	NSLog(@"CALLED SOMETHING HAPTICS 7");
	return;
}
-(BOOL)setChannelEventBehavior:(unsigned long long)arg1 channel:(unsigned long long)arg2 {
	NSLog(@"CALLED SOMETHING HAPTICS 8");
	return YES;
}
-(BOOL)startEventAndReturnToken:(unsigned long long)arg1 type:(unsigned long long)arg2 atTime:(double)arg3 channel:(unsigned long long)arg4 eventToken:(unsigned long long*)arg5 {
	NSLog(@"CALLED SOMETHING HAPTICS 9");
	return YES;
}
-(BOOL)stopEventWithToken:(unsigned long long)arg1 atTime:(double)arg2 channel:(unsigned long long)arg3 {
	NSLog(@"CALLED SOMETHING HAPTICS 10");
	return YES;
}
-(BOOL)clearEventsFromTime:(double)arg1 channel:(unsigned long long)arg2 {
	NSLog(@"CALLED SOMETHING HAPTICS 11");
	return YES;
}
-(BOOL)setParameter:(unsigned long long)arg1 atTime:(double)arg2 value:(float)arg3 channel:(unsigned long long)arg4 {
	NSLog(@"CALLED SOMETHING HAPTICS 12");
	return YES;
}
-(BOOL)loadHapticSequence:(id)arg1 reply:(/*^block*/id)arg2 {
	NSLog(@"CALLED SOMETHING HAPTICS 13");
	return YES;
}
-(BOOL)finish:(/*^block*/id)arg1 {
	NSLog(@"CALLED SOMETHING HAPTICS 14");
	return YES;
}
-(BOOL)setNumberOfChannels:(unsigned long long)arg1 error:(id*)arg2 {
	//hapticPeekVibe();
	NSLog(@"CALLED SOMETHING HAPTICS 15");
	return YES;
}
%end



%hook _UIKeyboardTextSelectionGestureController
-(BOOL)forceTouchGestureRecognizerShouldBegin:(id)arg1 {
	return NO;
}
%end

%hook _UIPreviewPresentationController
// -(void)_revealTransitionDidComplete:(BOOL)arg1 {
// 	if (arg1) {
// 		hapticPopVibe();
// 	}
// 	%orig;
// }
// -(void)_previewTransitionDidComplete:(BOOL)arg1 {
// 	if(arg1) {
// 		hapticPeekVibe();
// 	}
// 	%orig;
// }
// -(void)_dismissTransitionDidComplete:(BOOL)arg1 {
// 	%orig;
// }
%end

%hook UIPreviewInteractionController
-(void)commitInteractivePreview {
	hapticPopVibe();
	%orig;
}
-(BOOL)startInteractivePreviewWithGestureRecognizer:(id)arg1 {
	BOOL orig = %orig;
	if (orig) {
		hapticPeekVibe();
	}
	return orig;
}
%end

%ctor {
	reloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback)reloadPrefs,
        CFSTR("com.creatix.peekaboo.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	 %init;
	if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.MobileSMS"]) { // Messages App
          %init(Messages);
      }
      if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.mobileslideshow"]) { // Photos App
          %init(Photos);
  	}
} 