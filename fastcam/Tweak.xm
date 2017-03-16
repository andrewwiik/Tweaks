#include <substrate.h>
#include <notify.h>
#import <AudioToolbox/AudioServices.h>
#import <AudioToolbox/AudioToolbox.h>
#import "IOKit/pwr_mgt/IOPMLib.h"
#import "IOKit/hid/IOHIDEvent.h"
#import "IOKit/hid/IOHIDService.h"

extern "C" void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id unknown, NSDictionary *options);

static unsigned int *assertID;

void addSleepAssertions()
{

	IOReturn result = IOPMAssertionCreateWithName(CFSTR("NoIdleSleepAssertion"), 255, CFSTR("com.creatix.nosleep"), assertID);
	
	if (result != kIOReturnSuccess) {
		NSLog(@"Failed to Put Display to Sleep");
	}
 }

static int xStuff = 0;
static int xStuff1 = 0;
void togglePlayPause (CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	// [[NSClassFromString(@"SBMediaController") sharedInstance] togglePlayPause];
	// 
	xStuff++;
	if (xStuff == 4) {
		NSString *soundPath = @"/Library/Application Support/Tonus/Yosemite.aiff";
		SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
	AudioServicesPlaySystemSound (soundID);
	[soundPath release];
	xStuff = 0;
	}
	
}

void toggleTestSound (CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	// [[NSClassFromString(@"SBMediaController") sharedInstance] togglePlayPause];
	// 
	xStuff1++;
	if (xStuff1 == 4) {
		NSString *soundPath = @"/Library/Application Support/Tonus/CNN.aiff";
		SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
	AudioServicesPlaySystemSound (soundID);
	[soundPath release];
	xStuff1 = 0;
	}
}

void registerForEvents() {
	CFNotificationCenterRef notification = CFNotificationCenterGetDarwinNotifyCenter (); // 1
	CFNotificationCenterAddObserver(
		notification,
		NULL, 
		togglePlayPause,
		CFSTR("com.creatix.fastcam.togglePlayPause"),
		NULL,
		CFNotificationSuspensionBehaviorDeliverImmediately); // 2

	CFNotificationCenterAddObserver(
		notification,
		NULL, 
		toggleTestSound,
		CFSTR("com.creatix.fastcam.toggleTestSound"),
		NULL,
		CFNotificationSuspensionBehaviorDeliverImmediately); // 2
}

static void screenDisplayStatus(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
    uint64_t state;
    int token;
    notify_register_check("com.apple.iokit.hid.displayStatus", &token);
    notify_get_state(token, &state);
    notify_cancel(token);
    if (state) {
	// IOPMAssertionRelease(assertID);
    }
    else {
		addSleepAssertions();
    }
}

static void screenNoSleep(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
   
		addSleepAssertions();

}

void registerForScreenState() {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenDisplayStatus, CFSTR("com.apple.iokit.hid.displayStatus"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenNoSleep, CFSTR("com.creatix.nosleep"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

%hook SpringBoard
%new
- (void)keepScreenOn {

	CFNotificationCenterRef notification = CFNotificationCenterGetDarwinNotifyCenter ();
	CFNotificationCenterPostNotification(notification, CFSTR("com.creatix.nosleep"), NULL, NULL, YES);
	
}
%end

MSHook(IOHIDEventRef, IOHIDEventCreateDigitizerFingerEventWithQuality, CFAllocatorRef allocator, AbsoluteTime timeStamp,
       uint32_t index, uint32_t identity, uint32_t eventMask,
       IOHIDFloat x, IOHIDFloat y, IOHIDFloat z, IOHIDFloat tipPressure, IOHIDFloat twist,
       IOHIDFloat minorRadius, IOHIDFloat majorRadius, IOHIDFloat quality, IOHIDFloat density, IOHIDFloat irregularity,
       Boolean range, Boolean touch, IOOptionBits options) {
    
   
    CFNotificationCenterRef notification = CFNotificationCenterGetDarwinNotifyCenter ();
	CFNotificationCenterPostNotification(notification, CFSTR("com.creatix.fastcam.togglePlayPause"), NULL, NULL, YES);

    
    return _IOHIDEventCreateDigitizerFingerEventWithQuality(allocator, timeStamp, index, identity, eventMask, x, y, z, tipPressure, twist, minorRadius, majorRadius, quality, density, irregularity, range, touch, options);
}


MSHook(IOMobileFramebufferReturn, IOMobileFramebufferRequestPowerChange, void *buffer, int state, void *other, void *other2, void *other3) {

    state = 1;

	return _IOMobileFramebufferRequestPowerChange(buffer, state, other, other2, other3);

}


MSHook(Boolean, IOHIDServiceSetProperty, IOHIDServiceRef service, CFStringRef property, CFTypeRef value) {

	if ([(NSString *)property isEqualToString:[NSString stringWithFormat:@"InputDetectionMode"]]) {
		if ([value isEqual:[NSNumber numberWithInt:255]]) {

			value = [NSNumber numberWithInt:0];
		}
	}
    return _IOHIDServiceSetProperty(service,property,value);
}


%ctor {


	if ([[[NSClassFromString(@"NSProcessInfo") processInfo] processName] isEqualToString:@"backboardd"]) {

		registerForScreenState();

		MSHookFunction(&IOHIDEventCreateDigitizerFingerEventWithQuality, MSHake(IOHIDEventCreateDigitizerFingerEventWithQuality));
		MSHookFunction(&IOHIDServiceSetProperty, MSHake(IOHIDServiceSetProperty));
		MSHookFunction(&IOMobileFramebufferRequestPowerChange, MSHake(IOMobileFramebufferRequestPowerChange));

	}
	else {
		registerForEvents();
	}
}

// log