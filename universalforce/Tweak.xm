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

// struct rawTouch {
//     float density;
//     float minorRadius;
//     float majorRadius;
//     float quality;
//     float x;
//     float y;
//     float pressure;
//     float tiltX;
//     float tiltY;
//     float altitude;
//     float azimuth;
// } lastTouch;

struct rawTouch {
    float density;
    float radius;
    float quality;
    float x;
    float y;
    float pressure;
} lastTouch;

CGFloat lastQuality = 0;
CGFloat lastDensity = 0;
CGFloat lastRadius = 0;
CGFloat pressure = 0;
CGFloat force = 0;

// BOOL hasIncreasedByPercent(float percent, float value1, float value2) {

//     if (value1 <= 0 || value2 <= 0)
//         return NO;
//     if (value1 >= value2 + (value2 / percent))
//         return YES;
//     return NO;
// }

// void touch_event(void* target, void* refcon, IOHIDServiceRef service, IOHIDEventRef event) {

//     if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {

//         //get child events (individual finger)
//         NSArray *children = (__bridge NSArray *)IOHIDEventGetChildren(event);
//         if ([children count] == 1) { //single touch

//             struct rawTouch touch;

//             touch.density = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
//             touch.radius = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
//             touch.quality = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
//             touch.x = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
//             touch.y = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 

//             if (hasIncreasedByPercent(10, touch.density, lastTouch.density) && hasIncreasedByPercent(5, touch.radius, lastTouch.radius) && hasIncreasedByPercent(5, touch.quality, lastTouch.quality)) {
                
//                 //make sure we arent being triggered by some swipe by canceling out touches that go beyond 10px of orig touch
//                 if ((lastTouch.x - touch.x >= 10 || lastTouch.x - touch.x <= -10) || (lastTouch.y - touch.y >= 10 || lastTouch.y - touch.y <= -10)) {
//                     return;
//                 }

//                 NSLog(@"Force touch at location {%f:%f} with y diff %f", touch.x, touch.y, lastTouch.y - touch.y);

//                 BKSHIDServicesCancelTouchesOnMainDisplay();
//                 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//             }

//             lastTouch = touch;
//         }
//     }
// }

@interface UITouch (Private)
@property (assign,setter=_setHidEvent:,nonatomic) IOHIDEventRef _hidEvent; 
// @property (nonatomic, assign) CGFloat fakeForce;
// @property (nonatomic, assign) CGFloat fakePressure;
// @property (nonatomic, assign) BOOL calculatedFakeForce;
- (CGFloat)_unclampedForce; 
// - (void)calculateFakeForce;
@end

%hook UITouch
// %property (nonatomic, assign) CGFloat fakeForce;
// %property (nonatomic, assign) CGFloat fakePressure;
// %property (nonatomic, assign) BOOL calculatedFakeForce;
// -(void)_setHidEvent:(IOHIDEventRef)event  {
// 	%orig;
// 	NSLog(@"SET EVENT");
// 	if (event) {
// 		if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {

//         //get child events (individual finger)
// 	        NSArray *children = (__bridge NSArray *)IOHIDEventGetChildren(event);
// 	        if ([children count] == 1) { //single touch

// 	            struct rawTouch touch;

// 	            touch.density = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
// 	            touch.radius = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
// 	            touch.quality = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
// 	            touch.x = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
// 	            touch.y = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 

// 	            NSLog(@"DENSITY: %@\nRADIUS: %@\nQUALITY: %@", [NSNumber numberWithFloat:touch.density], [NSNumber numberWithFloat:touch.radius], [NSNumber numberWithFloat:touch.quality]);

// 	            // if (hasIncreasedByPercent(10, touch.density, lastTouch.density) && hasIncreasedByPercent(5, touch.radius, lastTouch.radius) && hasIncreasedByPercent(5, touch.quality, lastTouch.quality)) {
	                
// 	            //     //make sure we arent being triggered by some swipe by canceling out touches that go beyond 10px of orig touch
// 	            //     if ((lastTouch.x - touch.x >= 10 || lastTouch.x - touch.x <= -10) || (lastTouch.y - touch.y >= 10 || lastTouch.y - touch.y <= -10)) {
// 	            //         return;
// 	            //     }

// 	            //     NSLog(@"Force touch at location {%f:%f} with y diff %f", touch.x, touch.y, lastTouch.y - touch.y);

// 	            //     BKSHIDServicesCancelTouchesOnMainDisplay();
// 	            //     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
// 	            // }

// 	            // lastTouch = touch;
// 	        }
//     	}
// 	}
// }

// -(void)_updateWithChildEvent:(IOHIDEventRef)event  {
// 	%orig;
// 	NSLog(@"SET EVENT");
// 	if (event) {
// 		if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {

//         //get child events (individual finger)
// 	        NSArray *children = (__bridge NSArray *)IOHIDEventGetChildren(event);
// 	        if ([children count] == 1) { //single touch

// 	            struct rawTouch touch;

// 	            touch.density = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
// 	            touch.radius = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
// 	            touch.quality = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
// 	            touch.x = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
// 	            touch.y = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 

// 	            NSLog(@"DENSITY: %@\nRADIUS: %@\nQUALITY: %@", [NSNumber numberWithFloat:touch.density], [NSNumber numberWithFloat:touch.radius], [NSNumber numberWithFloat:touch.quality]);

// 	            // if (hasIncreasedByPercent(10, touch.density, lastTouch.density) && hasIncreasedByPercent(5, touch.radius, lastTouch.radius) && hasIncreasedByPercent(5, touch.quality, lastTouch.quality)) {
	                
// 	            //     //make sure we arent being triggered by some swipe by canceling out touches that go beyond 10px of orig touch
// 	            //     if ((lastTouch.x - touch.x >= 10 || lastTouch.x - touch.x <= -10) || (lastTouch.y - touch.y >= 10 || lastTouch.y - touch.y <= -10)) {
// 	            //         return;
// 	            //     }

// 	            //     NSLog(@"Force touch at location {%f:%f} with y diff %f", touch.x, touch.y, lastTouch.y - touch.y);

// 	            //     BKSHIDServicesCancelTouchesOnMainDisplay();
// 	            //     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
// 	            // }

// 	            // lastTouch = touch;
// 	        }
//     	}
// 	}
// }

// -(IOHIDEventRef)_hidEvent {
// 	IOHIDEventRef event = %orig;
// 	NSLog(@"SET EVENT");
// 	if (event) {
// 		if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {

//         //get child events (individual finger)
// 	        NSArray *children = (__bridge NSArray *)IOHIDEventGetChildren(event);
// 	        if ([children count] == 1) { //single touch

// 	            struct rawTouch touch;

// 	            touch.density = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
// 	            touch.radius = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
// 	            touch.quality = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
// 	            touch.x = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
// 	            touch.y = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 

// 	            NSLog(@"DENSITY: %@\nRADIUS: %@\nQUALITY: %@", [NSNumber numberWithFloat:touch.density], [NSNumber numberWithFloat:touch.radius], [NSNumber numberWithFloat:touch.quality]);

// 	            // if (hasIncreasedByPercent(10, touch.density, lastTouch.density) && hasIncreasedByPercent(5, touch.radius, lastTouch.radius) && hasIncreasedByPercent(5, touch.quality, lastTouch.quality)) {
	                
// 	            //     //make sure we arent being triggered by some swipe by canceling out touches that go beyond 10px of orig touch
// 	            //     if ((lastTouch.x - touch.x >= 10 || lastTouch.x - touch.x <= -10) || (lastTouch.y - touch.y >= 10 || lastTouch.y - touch.y <= -10)) {
// 	            //         return;
// 	            //     }

// 	            //     NSLog(@"Force touch at location {%f:%f} with y diff %f", touch.x, touch.y, lastTouch.y - touch.y);

// 	            //     BKSHIDServicesCancelTouchesOnMainDisplay();
// 	            //     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
// 	            // }

// 	            // lastTouch = touch;
// 	        }
//     	}
// 	}
//     return event;
// }

// -(CGFloat)_unclampedForce {
// 	IOHIDEventRef event = self._hidEvent;
// 	NSLog(@"SET EVENT");
// 	if (event) {
// 		if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {

//         //get child events (individual finger)
// 	        NSArray *children = (__bridge NSArray *)IOHIDEventGetChildren(event);
// 	        if ([children count] == 1) { //single touch

// 	            struct rawTouch touch;

// 	            touch.density = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
// 	            touch.radius = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
// 	            touch.quality = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
// 	            touch.x = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
// 	            touch.y = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 

// 	            NSLog(@"DENSITY: %@\nRADIUS: %@\nQUALITY: %@", [NSNumber numberWithFloat:touch.density], [NSNumber numberWithFloat:touch.radius], [NSNumber numberWithFloat:touch.quality]);

// 	            // if (hasIncreasedByPercent(10, touch.density, lastTouch.density) && hasIncreasedByPercent(5, touch.radius, lastTouch.radius) && hasIncreasedByPercent(5, touch.quality, lastTouch.quality)) {
	                
// 	            //     //make sure we arent being triggered by some swipe by canceling out touches that go beyond 10px of orig touch
// 	            //     if ((lastTouch.x - touch.x >= 10 || lastTouch.x - touch.x <= -10) || (lastTouch.y - touch.y >= 10 || lastTouch.y - touch.y <= -10)) {
// 	            //         return;
// 	            //     }

// 	            //     NSLog(@"Force touch at location {%f:%f} with y diff %f", touch.x, touch.y, lastTouch.y - touch.y);

// 	            //     BKSHIDServicesCancelTouchesOnMainDisplay();
// 	            //     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
// 	            // }

// 	            // lastTouch = touch;
// 	        }
//     	}
// 	}
//     return %orig;
// }

// -(void)setTimestamp:(CGFloat)arg1 {
// 	IOHIDEventRef event = self._hidEvent;
// 	NSLog(@"SET EVENT");
// 	if (event) {
// 		NSLog(@"EVENT TYPE: %i", IOHIDEventGetType(event));
// 		if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {

//         //get child events (individual finger)
// 	        NSArray *children = (__bridge NSArray *)IOHIDEventGetChildren(event);
// 	        if ([children count] == 1) { //single touch

// 	            struct rawTouch touch;

// 	            touch.density = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
// 	            touch.radius = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
// 	            touch.quality = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
// 	            touch.x = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
// 	            touch.y = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 

// 	            NSLog(@"DENSITY: %@\nRADIUS: %@\nQUALITY: %@", [NSNumber numberWithFloat:touch.density], [NSNumber numberWithFloat:touch.radius], [NSNumber numberWithFloat:touch.quality]);

// 	            // if (hasIncreasedByPercent(10, touch.density, lastTouch.density) && hasIncreasedByPercent(5, touch.radius, lastTouch.radius) && hasIncreasedByPercent(5, touch.quality, lastTouch.quality)) {
	                
// 	            //     //make sure we arent being triggered by some swipe by canceling out touches that go beyond 10px of orig touch
// 	            //     if ((lastTouch.x - touch.x >= 10 || lastTouch.x - touch.x <= -10) || (lastTouch.y - touch.y >= 10 || lastTouch.y - touch.y <= -10)) {
// 	            //         return;
// 	            //     }

// 	            //     NSLog(@"Force touch at location {%f:%f} with y diff %f", touch.x, touch.y, lastTouch.y - touch.y);

// 	            //     BKSHIDServicesCancelTouchesOnMainDisplay();
// 	            //     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
// 	            // }

// 	            // lastTouch = touch;
// 	        }
//     	}
// 	}
//     %orig;
// }

// -(CGFloat)force {
// 	IOHIDEventRef event = self._hidEvent;
// 	NSLog(@"SET EVENT");
// 	if (event) {
// 		NSLog(@"EVENT TYPE: %i", IOHIDEventGetType(event));
// 		if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {

//         //get child events (individual finger)
// 	        NSArray *children = (__bridge NSArray *)IOHIDEventGetChildren(event);
// 	        if ([children count] == 1) { //single touch

// 	            struct rawTouch touch;

// 	            touch.density = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
// 	            touch.radius = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
// 	            touch.quality = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
// 	            touch.x = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
// 	            touch.y = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 

// 	            NSLog(@"DENSITY: %@\nRADIUS: %@\nQUALITY: %@", [NSNumber numberWithFloat:touch.density], [NSNumber numberWithFloat:touch.radius], [NSNumber numberWithFloat:touch.quality]);

// 	            // if (hasIncreasedByPercent(10, touch.density, lastTouch.density) && hasIncreasedByPercent(5, touch.radius, lastTouch.radius) && hasIncreasedByPercent(5, touch.quality, lastTouch.quality)) {
	                
// 	            //     //make sure we arent being triggered by some swipe by canceling out touches that go beyond 10px of orig touch
// 	            //     if ((lastTouch.x - touch.x >= 10 || lastTouch.x - touch.x <= -10) || (lastTouch.y - touch.y >= 10 || lastTouch.y - touch.y <= -10)) {
// 	            //         return;
// 	            //     }

// 	            //     NSLog(@"Force touch at location {%f:%f} with y diff %f", touch.x, touch.y, lastTouch.y - touch.y);

// 	            //     BKSHIDServicesCancelTouchesOnMainDisplay();
// 	            //     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
// 	            // }

// 	            // lastTouch = touch;
// 	        }
//     	}
// 	}
// 	return %orig;
// }

// -(CGFloat)_pressure {
// 	IOHIDEventRef event = self._hidEvent;
// 	NSLog(@"SET EVENT");
// 	if (event) {
// 		NSLog(@"EVENT TYPE: %i", IOHIDEventGetType(event));
// 		if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {
// 			NSLog(@"IS DIGITIZER EVENT");

//         //get child events (individual finger)
// 	        NSArray *children = (__bridge NSArray *)IOHIDEventGetChildren(event);
// 	        if ([children count] == 1) { //single touch

// 	            struct rawTouch touch;

// 	            touch.density = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
// 	            touch.radius = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
// 	            touch.quality = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
// 	            touch.x = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
// 	            touch.y = IOHIDEventGetFloatValue((__bridge __IOHIDEvent *)children[0], (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 

// 	            NSLog(@"DENSITY: %@\nRADIUS: %@\nQUALITY: %@", [NSNumber numberWithFloat:touch.density], [NSNumber numberWithFloat:touch.radius], [NSNumber numberWithFloat:touch.quality]);

// 	            // if (hasIncreasedByPercent(10, touch.density, lastTouch.density) && hasIncreasedByPercent(5, touch.radius, lastTouch.radius) && hasIncreasedByPercent(5, touch.quality, lastTouch.quality)) {
	                
// 	            //     //make sure we arent being triggered by some swipe by canceling out touches that go beyond 10px of orig touch
// 	            //     if ((lastTouch.x - touch.x >= 10 || lastTouch.x - touch.x <= -10) || (lastTouch.y - touch.y >= 10 || lastTouch.y - touch.y <= -10)) {
// 	            //         return;
// 	            //     }

// 	            //     NSLog(@"Force touch at location {%f:%f} with y diff %f", touch.x, touch.y, lastTouch.y - touch.y);

// 	            //     BKSHIDServicesCancelTouchesOnMainDisplay();
// 	            //     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
// 	            // }

// 	            // lastTouch = touch;
// 	        }
//     	}
// 	}
// 	return %orig;
// }

// %new
// - (void)calculateFakeForce {
// 	IOHIDEventRef event = self._hidEvent;
// 	if (event) {
// 		if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {
// 			if (IOHIDEventIsAbsolute(event)) {
// 				struct rawTouch touch;
// 	            touch.density = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
// 	            touch.radius = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
// 	            touch.quality = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
// 	            touch.x = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
// 	            touch.y = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 
	            

// 	            pressure = 0;
// 	            CGFloat qualityValue = (CGFloat)lastQuality + (((CGFloat)touch.quality - (CGFloat)lastTouch.quality)*10);
// 	            self.fakePressure = (CGFloat)100*(CGFloat)qualityValue;
// 	            self.fakeForce = self.fakePressure/(CGFloat)60;
// 	            lastQuality = qualityValue;
// 	            lastTouch = touch;
// 	            self.calculatedFakeForce = YES;
// 	            return;
// 	            //touch.pressure = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerPressure);
// 			}
//     	}
// 	}
// 	self.fakeForce = 0;
// 	self.fakePressure = 0;
// }

// - (CGFloat)_pressure {
// 	if (!self.calculatedFakeForce) {
// 		[self calculateFakeForce];
// 	}
// 	if (self.fakePressure) {
// 		return self.fakePressure;
// 	} else return 0;
// }

- (CGFloat)_unclampedForce {
	IOHIDEventRef event = self._hidEvent;
	if (event) {
		if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {
			if (IOHIDEventIsAbsolute(event)) {
				struct rawTouch touch;
	            touch.density = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
	            touch.radius = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
	            touch.quality = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
	            touch.x = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
	            touch.y = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 
	            

	            CGFloat densityValue = (CGFloat)lastDensity + (((CGFloat)touch.density - (CGFloat)lastTouch.density)*2);
	            CGFloat qualityValue = (CGFloat)lastQuality + (((CGFloat)touch.quality - (CGFloat)lastTouch.quality)*1.5);
	            CGFloat radiusValue = (CGFloat)lastRadius + (((CGFloat)touch.radius - (CGFloat)lastTouch.radius)*3);

	            pressure = ((((CGFloat)100*(CGFloat)qualityValue)+((CGFloat)100*(CGFloat)densityValue))/2)*(radiusValue+1);
	            lastQuality = qualityValue;
	            lastDensity = densityValue;
	            lastRadius = radiusValue;
	            lastTouch = touch;
	            force = pressure/(CGFloat)2;
	            CGFloat forceToReturn = force;
	            // if ([self phase] == UITouchPhaseEnded || [self phase] == UITouchPhaseCancelled || (lastTouch.x - touch.x >= 10 || lastTouch.x - touch.x <= -10) || (lastTouch.y - touch.y >= 10 || lastTouch.y - touch.y <= -10)) {
	            // 	lastQuality = 0;
	            // 	lastDensity = 0;
	            // 	lastTouch.density = 0;
	            // 	lastTouch.quality = 0;
	            // 	lastTouch.radius = 0;
	            // 	lastTouch.x = 0;
	            // 	lastTouch.y = 0;
	            // 	lastRadius = 0;
	            // 	force = 0;
	            // 	pressure = 0;
	            // 	forceToReturn = 0;
	            // }
	            return forceToReturn;
			}
    	}
	}
	return %orig;
}

- (CGFloat)force {
	IOHIDEventRef event = self._hidEvent;
	if (event) {
		if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {
			if (IOHIDEventIsAbsolute(event)) {
				struct rawTouch touch;
	            touch.density = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
	            touch.radius = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
	            touch.quality = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
	            touch.x = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
	            touch.y = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 
	            

	            CGFloat densityValue = (CGFloat)lastDensity + (((CGFloat)touch.density - (CGFloat)lastTouch.density)*2);
	            CGFloat qualityValue = (CGFloat)lastQuality + (((CGFloat)touch.quality - (CGFloat)lastTouch.quality)*1.5);
	            CGFloat radiusValue = (CGFloat)lastRadius + (((CGFloat)touch.radius - (CGFloat)lastTouch.radius)*3);

	            pressure = ((((CGFloat)100*(CGFloat)qualityValue)+((CGFloat)100*(CGFloat)densityValue))/2)*(radiusValue+1);
	            lastQuality = qualityValue;
	            lastDensity = densityValue;
	            lastRadius = radiusValue;
	            lastTouch = touch;
	            force = pressure/(CGFloat)2;
	            CGFloat forceToReturn = force;
	            // if ([self phase] == UITouchPhaseEnded || [self phase] == UITouchPhaseCancelled || (lastTouch.x - touch.x >= 5 || lastTouch.x - touch.x <= -5) || (lastTouch.y - touch.y >= 5 || lastTouch.y - touch.y <= -5)) {
	            // 	lastQuality = 0;
	            // 	lastDensity = 0;
	            // 	lastTouch.density = 0;
	            // 	lastTouch.quality = 0;
	            // 	lastTouch.radius = 0;
	            // 	lastTouch.x = 0;
	            // 	lastTouch.y = 0;
	            // 	lastRadius = 0;
	            // 	force = 0;
	            // 	pressure = 0;
	            // 	forceToReturn = 0;
	            // }
	            return forceToReturn;
			}
    	}
	}
	return %orig;
}



// -(CGPoint)locationInView:(id)arg1 {
// 	IOHIDEventRef event = self._hidEvent;
// 	//NSLog(@"SET EVENT");
// 	if (event) {
// 		//NSLog(@"EVENT TYPE: %i", IOHIDEventGetType(event));
// 		if (IOHIDEventGetType(event) == kIOHIDEventTypeDigitizer) {
// 			//NSLog(@"IS DIGITIZER EVENT");
// 			if (IOHIDEventIsAbsolute(event)) {
// 				//NSLog(@"EVENT IS ABSOLUTE");
// 				struct rawTouch touch;

// 	            touch.density = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerDensity);
// 	            touch.majorRadius = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerMajorRadius);
// 	            touch.minorRadius = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerMinorRadius);
// 	            touch.quality = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerQuality);
// 	            touch.x = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerX) * [[UIScreen mainScreen] bounds].size.width;
// 	            touch.y = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerY) * [[UIScreen mainScreen] bounds].size.height; 
// 	            touch.pressure = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerPressure);
// 	            touch.tiltX = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerTiltX);
// 	            touch.tiltY = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerTiltY);
// 	            touch.altitude = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerAltitude);
// 	            touch.azimuth = IOHIDEventGetFloatValue(event, (IOHIDEventField)kIOHIDEventFieldDigitizerAzimuth);

// 	      //       kIOHIDEventFieldDigitizerTiltX,
// 			    // kIOHIDEventFieldDigitizerTiltY,
// 			    // kIOHIDEventFieldDigitizerAltitude,
// 			    // kIOHIDEventFieldDigitizerAzimuth,

// 	            NSLog(@"DENSITY: %@\nMINOR RADIUS: %@\nMAJOR RADIUS: %@\nQUALITY: %@\nPRESSURE: %@\nUNCLAMPED FORCE: %@\nFORCE: %@\nTILT X: %@\nTILT Y: %@\nALTITUDE: %@\nAZIMUTH: %@",
// 	            		  [NSNumber numberWithFloat:touch.density],
// 	            		  [NSNumber numberWithFloat:touch.minorRadius],
// 	            		  [NSNumber numberWithFloat:touch.majorRadius],
// 	            		  [NSNumber numberWithFloat:touch.quality],
// 	            		  [NSNumber numberWithFloat:touch.pressure],
// 	            		  [NSNumber numberWithFloat:[self _unclampedForce]],
// 	            		  [NSNumber numberWithFloat:[self force]],
// 	            		  [NSNumber numberWithFloat:touch.tiltX],
// 	            		  [NSNumber numberWithFloat:touch.tiltY],
// 	            		  [NSNumber numberWithFloat:touch.altitude],
// 	            		  [NSNumber numberWithFloat:touch.azimuth]);
// 			}
//     	}
// 	}
// 	return %orig;
// }

- (BOOL)_supportsForce {
	return YES;
}

-(void)_setPressure:(CGFloat)arg1 resetPrevious:(BOOL)arg2 {
	%orig(pressure, arg2);
}
%end

%hook _UITouchForceMessage
- (void)setUnclampedTouchForce:(CGFloat)touchForce {
	%orig(force);
}
%end

%hook _UIForceMessage
- (void)setTouchForce:(CGFloat)touchForce {
	%orig(force);
}
- (CGFloat)touchForce {
	return force;
}
%end

%hook _UITouchForceObservationMessageReader
- (void)setTouchForce:(CGFloat)touchForce {
	%orig(force);
}
- (CGFloat)touchForce {
	return force;
}
%end

%hook _UIDeepPressAnalyzer
- (CGFloat)_touchForceFromTouches:(id)arg1 {
	return force;
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

%hook SBMainSwitcherGestureCoordinator
-(void)_handleSwitcherForcePressGesture:(id)arg1 {
    NSLog(@"SWITHCER GESTURE: %@", arg1);
    %orig;
}

-(void)_forcePressGestureBeganWithGesture:(id)arg1 {
    NSLog(@"SWITHCER GESTURE: %@", arg1);
    %orig;
}
- (void)handleSwitcherForcePressGesture:(id)arg1 {
    NSLog(@"SWITHCER GESTURE: %@", arg1);
    %orig;
}
%end

%hook SBUIController
-(void)_handleSwitcherForcePressGesture:(id)arg1 {
    NSLog(@"SWITHCER GESTURE: %@", arg1);
    %orig;
}
%end

@interface _UIScreenEdgePanRecognizerSettings : NSObject
@property (assign,nonatomic) BOOL analysisLoggingEnabled;                                            //@synthesize analysisLoggingEnabled=_analysisLoggingEnabled - In the implementation block
@property (assign,nonatomic) BOOL analysisFailureOverlayVisible;                                     //@synthesize analysisFailureOverlayVisible=_analysisFailureOverlayVisible - In the implementation block
@property (assign,nonatomic) BOOL analysisLoggingOverlayVisible;  
@end

%hook _UIScreenEdgePanRecognizerSettings
- (void)setDefaultValues {
    %orig;
    [self setAnalysisLoggingEnabled:YES];
    [self setAnalysisFailureOverlayVisible:YES];
    [self setAnalysisLoggingOverlayVisible:YES];
}
-(BOOL)analysisLoggingEnabled {
    return YES;
}
-(BOOL)analysisFailureOverlayVisible {
    return YES;
}
-(BOOL)analysisLoggingOverlayVisible {
    return YES;
}

-(void)setAnalysisLoggingEnabled:(BOOL)arg1 {
    %orig(YES);
}
-(void)setAnalysisFailureOverlayVisible:(BOOL)arg1 {
    %orig(YES);
}
-(void)setAnalysisLoggingOverlayVisible:(BOOL)arg1 {
    %orig(YES);
}
%end

extern "C" BOOL CPIsInternalDevice();
%hookf(BOOL, CPIsInternalDevice)
{
    return YES;
}

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



// %ctor {


// 	// clientCreatePointer clientCreate;
//  //    void *handle = dlopen(0, 9);
//  //    *(void**)(&clientCreate) = dlsym(handle,"IOHIDEventSystemClientCreate");
//  //    IOHIDEventSystemClientRef ioHIDEventSystem = (__IOHIDEventSystemClient *)clientCreate(kCFAllocatorDefault);
//  //    IOHIDEventSystemClientScheduleWithRunLoop(ioHIDEventSystem, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
//  //    IOHIDEventSystemClientRegisterEventCallback(ioHIDEventSystem, (IOHIDEventSystemClientEventCallback)touch_event, NULL, NULL);

// }