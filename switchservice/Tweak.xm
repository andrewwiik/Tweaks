#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import "PulsingHaloLayer.h"
#include <sys/types.h>
#include <sys/sysctl.h>

extern "C" void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id unknown, NSDictionary *options);

void hapticVibe(){
	NSMutableDictionary* VibrationDictionary = [NSMutableDictionary dictionary];
	NSMutableArray* VibrationArray = [NSMutableArray array ];
	[VibrationArray addObject:[NSNumber numberWithBool:YES]];
	[VibrationArray addObject:[NSNumber numberWithInt:30]]; //vibrate for 50ms
	[VibrationDictionary setObject:VibrationArray forKey:@"VibePattern"];
	[VibrationDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
	AudioServicesPlaySystemSoundWithVibration(4095,nil,VibrationDictionary);
}

#define PREFS_BUNDLE_ID CFSTR("com.creatix.switchservice")
static BOOL isEnabled = YES;
static BOOL vibrationEnabled = YES;
static BOOL autoSwitchEnabled = NO;
static CGFloat holdTime = 1.f;

@interface IMServiceImpl : NSObject
+ (id)serviceWithName:(NSString *)arg1;
@end
@interface IMService : NSObject
@property (nonatomic, retain) NSString* name;
@end
@interface IMSender : NSObject
@property (nonatomic, retain) IMService* service;
@end
@interface IMMessage : NSObject
@property (nonatomic, retain) IMSender* sender;
@end
@interface IMChat : NSObject
@property (nonatomic, retain) IMMessage* lastFinishedMessage;
- (void)_targetToService:(id)arg1 newComposition:(BOOL)arg2;
- (BOOL)_hasCommunicatedOnService:(id)arg1;
@end

@interface CKConversation : NSObject
@property (nonatomic, retain) IMChat *chat;
- (IMChat *)chat;
- (NSString *)serviceDisplayName;
@end

@interface CKMessageEntryView : UIView
@property (nonatomic, retain) CKConversation *conversation;
@property (nonatomic, retain) UIButton *sendButton;
- (CKConversation *)conversation;
- (UIButton *)sendButton;
- (void)pulse;
- (void)hapticFeedback;
- (BOOL)is6S;
- (NSString*)platform;
- (BOOL)isSameSending;
@end

static int const UITapticEngineFeedbackPop = 1002;
@interface UITapticEngine : NSObject
- (void)actuateFeedback:(int)arg1;
- (void)endUsingFeedback:(int)arg1;
- (void)prepareUsingFeedback:(int)arg1;
@end
@interface UIDevice (Private)
-(UITapticEngine*)_tapticEngine;
@end

static UILongPressGestureRecognizer *switchServiceGesture = nil;
BOOL isForced = NO;
%hook CKMessageEntryView // The Messages App Entry View
%new -(void)switchSendingServiceGesture:(UILongPressGestureRecognizer *)gesture { // We started holding the send button
	if(!isEnabled) return; // it's not enabled, don't do anything
	if(gesture.state == UIGestureRecognizerStateBegan) { // oh look it began
		BOOL isIMessage = [[self.conversation serviceDisplayName] isEqualToString:@"iMessage"]; // are we currently send  an iMessage or SMS?
		IMServiceImpl *serviceImpl = [%c(IMServiceImpl) serviceWithName:(isIMessage ? @"SMS" : @"iMessage")]; // the opposite
			[self.conversation.chat _targetToService:serviceImpl newComposition:!isIMessage]; // set the opposite service
			[self pulse]; // do that cool pulse animation 
			isForced = YES;
			if (vibrationEnabled == TRUE) [self hapticFeedback]; // give you some feedback if you have it enabled
	}
}
- (void)setSendButton:(id)arg1 {
	%orig;
	if(!isEnabled) return; // If the tweak isn't enabled jsut end it now
	switchServiceGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(switchSendingServiceGesture:)]; // initlize switch service gesture
    switchServiceGesture.minimumPressDuration = holdTime; // set the time needed to activate from settings
    switchServiceGesture.allowableMovement = 25.0f;
    [self.sendButton addGestureRecognizer: switchServiceGesture]; // add the switch service gesture to the send button
}

%new
- (void)pulse {
	PulsingHaloLayer *halo = [[PulsingHaloLayer alloc] initWithRepeatCount: 1]; // Initilize the Halo
	halo.position = [self convertPoint:self.sendButton.center toView:self]; // set the halo's position in relation to the message entry view and send button
	halo.radius = self.sendButton.frame.size.width * 3; // set the halo's radius to 3 times the send button's width
	halo.backgroundColor = self.sendButton.currentTitleColor.CGColor; // set the halo color to the messaging service the user is switching to
	halo.animationDuration = 1; // set the duration to 1 second
	// halo.pulseInterval = .001;
	// halo.useTimingFunction = YES;

	[self.layer addSublayer:halo];
}
/*- (void)messageEntryContentViewDidBeginEditing:(id)arg1 {
		NSString* lastMessageServiceName = self.conversation.chat.lastFinishedMessage.sender.service.name;
	NSLog(@"lastMessageServiceName: %@", lastMessageServiceName);
		BOOL isIMessage = [[self.conversation serviceDisplayName] isEqualToString:@"iMessage"];
	IMServiceImpl *serviceImpl = [%c(IMServiceImpl) serviceWithName:lastMessageServiceName];
	[self.conversation.chat _targetToService:serviceImpl newComposition:!isIMessage];
	[self pulse];
	%orig;
} */
- (void)touchUpInsideSendButton:(id)arg1 {
	//isForced = NO;
	%orig;
}
%new
- (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
%new
- (BOOL)is6S {
	return ([[[self platform] substringToIndex: 8] isEqualToString:@"iPhone8,"]);
}
%new
- (void)hapticFeedback {
	if ([self is6S]) {
		if ([[UIDevice currentDevice] respondsToSelector:@selector(_tapticEngine)]) {
		UITapticEngine *tapticEngine = [UIDevice currentDevice]._tapticEngine;
		if (tapticEngine) {
	    [tapticEngine actuateFeedback:UITapticEngineFeedbackPop];
		}
		}
	}
	else {
	hapticVibe();
    }
}
%new
- (BOOL)isSameSending {
	NSString *current = [self.conversation serviceDisplayName];
	NSString *previous = self.conversation.chat.lastFinishedMessage.sender.service.name;
	if ([current isEqualToString:@"Text Message"]) {
		current = [NSString stringWithFormat:@"SMS"];
	}
	HBLogInfo([NSString stringWithFormat:@"Current Service: %@, Previous Service: %@",current, previous]);
	if ([current isEqualToString:previous])
	return TRUE;
	else return FALSE;
	
}
%end
@interface CKMessageEntryContentView : UIView
- (CKMessageEntryView*)delegate;
@end
%hook CKMessageEntryContentView

- (void)textViewDidChange:(UITextField *)textField {
	%orig;
	if(!isEnabled) return;
	if (isForced == NO && autoSwitchEnabled == YES) {
		NSString* lastMessageServiceName = [self delegate].conversation.chat.lastFinishedMessage.sender.service.name;
		NSLog(@"lastMessageServiceName: %@", lastMessageServiceName);
		BOOL isIMessage = [[[self delegate].conversation serviceDisplayName] isEqualToString:@"iMessage"];
		IMServiceImpl *serviceImpl = [%c(IMServiceImpl) serviceWithName:lastMessageServiceName];
		if (![[self delegate] isSameSending]) {
			[[self delegate].conversation.chat _targetToService:serviceImpl newComposition:!isIMessage];
			[[self delegate] pulse];
		}
	}
}
%end
%hook CKConversation
- (void)sendMessage:(id)arg1 onService:(id)arg2 newComposition:(BOOL)arg3 {
	%orig(arg1, arg2, arg3);
	isForced = NO;
}
%end

static void reloadPrefs() {
	// Synchronize prefs
	CFPreferencesAppSynchronize(PREFS_BUNDLE_ID);
	// Get if enabled
	Boolean isEnabledExists = NO;
	Boolean isEnabledRef = CFPreferencesGetAppBooleanValue(CFSTR("Enabled"), PREFS_BUNDLE_ID, &isEnabledExists);
	isEnabled = (isEnabledExists ? isEnabledRef : YES);

	Boolean vibrationEnabledExists = NO;
	Boolean vibrationEnabledRef = CFPreferencesGetAppBooleanValue(CFSTR("vibrationEnabled"), PREFS_BUNDLE_ID, &vibrationEnabledExists);
	vibrationEnabled = (vibrationEnabledExists ? vibrationEnabledRef : YES);

	Boolean autoSwitchExists = NO;
	Boolean autoSwitchRef = CFPreferencesGetAppBooleanValue(CFSTR("autoSwitch"), PREFS_BUNDLE_ID, &autoSwitchExists);
	autoSwitchEnabled = (autoSwitchExists ? autoSwitchRef : YES);
	// Get set slider hold time
	CFPropertyListRef holdTimeRef = CFPreferencesCopyAppValue(CFSTR("HoldTime"), PREFS_BUNDLE_ID);
	holdTime = (holdTimeRef ? [(__bridge NSNumber*)holdTimeRef floatValue] : 1.f);
	// Reset hold gesture
	if(switchServiceGesture && [switchServiceGesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
		if(!isEnabled) [switchServiceGesture.view removeGestureRecognizer:switchServiceGesture];
		else switchServiceGesture.minimumPressDuration = holdTime;
	}
}

%ctor {
	reloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
	(CFNotificationCallback)reloadPrefs,
	CFSTR("com.creatix.switchservice.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
