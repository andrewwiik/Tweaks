#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#include <IOKit/hid/IOHIDEventSystem.h>
#include <IOKit/hid/IOHIDEventSystemClient.h>
#include <stdio.h>
#include <dlfcn.h>

int IOHIDEventSystemClientSetMatching(IOHIDEventSystemClientRef client, CFDictionaryRef match);
CFArrayRef IOHIDEventSystemClientCopyServices(IOHIDEventSystemClientRef, int);
typedef struct __IOHIDServiceClient * IOHIDServiceClientRef;
int IOHIDServiceClientSetProperty(IOHIDServiceClientRef, CFStringRef, CFNumberRef);
typedef void* (*clientCreatePointer)(const CFAllocatorRef);
extern "C" void BKSHIDServicesCancelTouchesOnMainDisplay();

struct rawTouch {
    float density;
    float radius;
    float quality;
    float x;
    float y;
} lastTouch;

BOOL hasIncreasedByPercent(float percent, float value1, float value2) {

    if (value1 <= 0 || value2 <= 0)
        return NO;
    if (value1 >= value2 + (value2 / percent))
        return YES;
    return NO;
}

void touch_event(void* target, void* refcon, IOHIDServiceRef service, IOHIDEventRef event) {

    if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {

        //get child events (individual finger)
        NSArray *children = (NSArray *)IOHIDEventGetChildren(event);
        if ([children count] == 1) { //single touch

            struct rawTouch touch;

            touch.density = IOHIDEventGetFloatValue((__IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
            touch.radius = IOHIDEventGetFloatValue((__IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
            touch.quality = IOHIDEventGetFloatValue((__IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
            touch.x = IOHIDEventGetFloatValue((__IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
            touch.y = IOHIDEventGetFloatValue((__IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 

            if (hasIncreasedByPercent(10, touch.density, lastTouch.density) && hasIncreasedByPercent(5, touch.radius, lastTouch.radius) && hasIncreasedByPercent(5, touch.quality, lastTouch.quality)) {
                
                //make sure we arent being triggered by some swipe by canceling out touches that go beyond 10px of orig touch
                if ((lastTouch.x - touch.x >= 10 || lastTouch.x - touch.x <= -10) || (lastTouch.y - touch.y >= 10 || lastTouch.y - touch.y <= -10)) {
                    return;
                }

                NSLog(@"Force touch at location {%f:%f} with y diff %f", touch.x, touch.y, lastTouch.y - touch.y);

                BKSHIDServicesCancelTouchesOnMainDisplay();
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }

            lastTouch = touch;
        }
    }
}

%ctor {

	clientCreatePointer clientCreate;
    void *handle = dlopen(0, 9);
    *(void**)(&clientCreate) = dlsym(handle,"IOHIDEventSystemClientCreate");
    IOHIDEventSystemClientRef ioHIDEventSystem = (__IOHIDEventSystemClient *)clientCreate(kCFAllocatorDefault);
    IOHIDEventSystemClientScheduleWithRunLoop(ioHIDEventSystem, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    IOHIDEventSystemClientRegisterEventCallback(ioHIDEventSystem, (IOHIDEventSystemClientEventCallback)touch_event, NULL, NULL);

}