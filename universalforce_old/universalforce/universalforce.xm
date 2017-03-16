#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Additions.h"

#define THEOS_INSTANCE_NAME

/*
 * Copyright (c) 2014 Apple Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_LICENSE_HEADER_END@
 */

/*	CFLogUtilities.h
	Copyright (c) 2004-2014, Apple Inc. All rights reserved.
 */

/*
 APPLE SPI:  NOT TO BE USED OUTSIDE APPLE!
 */

#if !defined(__COREFOUNDATION_CFLOGUTILITIES__)
#define __COREFOUNDATION_CFLOGUTILITIES__ 1

#include <CoreFoundation/CFBase.h>
#include <CoreFoundation/CFString.h>


CF_EXTERN_C_BEGIN


enum {	// Legal level values for CFLog()
    kCFLogLevelEmergency = 0,
    kCFLogLevelAlert = 1,
    kCFLogLevelCritical = 2,
    kCFLogLevelError = 3,
    kCFLogLevelWarning = 4,
    kCFLogLevelNotice = 5,
    kCFLogLevelInfo = 6,
    kCFLogLevelDebug = 7,
};

CF_EXPORT void CFLog(int32_t level, CFStringRef format, ...);
/*	Passing in a level value which is outside the range of 0-7 will cause the the call to do nothing.
	CFLog() logs the message using the asl.h API, and uses the level parameter as the log level.
	Note that the asl subsystem ignores some log levels by default.
	CFLog() is not fast, and is not going to be guaranteed to be fast.
	Even "no-op" CFLogs are not necessarily fast.
	If you care about performance, you shouldn't be logging.
 */

CF_EXTERN_C_END

#endif /* ! __COREFOUNDATION_CFLOGUTILITIES__ */


#ifdef __DEBUG__
#define HB_LOG_FORMAT(color) CFSTR("\e[1;3" #color "m[%s] \e[m\e[0;3" #color "m%s:%d\e[m \e[0;30;4" #color "m%s:\e[m %@")
#else
#define HB_LOG_FORMAT(color) CFSTR("[%s: %s:%d] %s: %@")
#endif

#define HB_LOG_INTERNAL(color, level, type, ...) CFLog(level, HB_LOG_FORMAT(color), THEOS_INSTANCE_NAME, __BASE_FILE__, __LINE__, type, (__bridge CFStringRef)[NSString stringWithFormat:__VA_ARGS__]);

#ifdef __DEBUG__
#define HBLogDebug(...) HB_LOG_INTERNAL(6, kCFLogLevelNotice, "DEBUG", __VA_ARGS__)
#else
#define HBLogDebug(...)
#endif

#define HBLogInfo(...)
#define HBLogWarn(...)
#define HBLogError(...)

UITouch *previousTouch;
static CGFloat pressureChange = 0;
static CGFloat previousForce = 0;


@interface UITouch (E)
- (id)_hidEvent;
- (void)calculateNewForce;
@end
%hook UITouch
- (void)setMajorRadius:(float)arg1 {
    [self calculateNewForce];
    %orig;
}
%new
- (CGFloat)getQuality {
    return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Quality:" andString:@"Density:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}
%new
- (CGFloat)getDensity {
    return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Density:" andString:@"Irregularity:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}
%new
- (CGFloat)getRadius {
    return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"MajorRadius:" andString:@"MinorRadius:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}
%new
- (int)getX {
    return [[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"X:" andString:@"Y:"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
}
%new
- (int)getY {
    return [[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Y:" andString:@"Z:"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
}
%new
- (void)calculateNewForce {
    if (previousTouch) {
        CGFloat radiusChange = ([self getRadius]/[previousTouch getRadius] - 1);
        CGFloat densityChange = ([self getDensity]/[previousTouch getDensity] - 1);
//        CGFloat qualityChange = ([self getQuality]/[previousTouch getQuality] - 1);
    
        CGFloat finalChange = (densityChange + radiusChange);
        pressureChange = finalChange;
        previousTouch = self;
    }
    else {
        pressureChange = 0;
        previousTouch = self;
    }
}
%end

%hook _UITouchForceMessage
- (void)setUnclampedTouchForce:(CGFloat)touchForce {
    double yT;
    if (previousForce)
        yT = previousForce * (1 + pressureChange);
    else
        yT = 300 * (1 + pressureChange);
        
    previousForce = yT;
    if (sizeof(void*) == 4) {
        %orig((float) yT);
    }
    else if (sizeof(void*) == 8) {
        %orig((double) yT);
    }
}
%end

%hook UIScreen
- (long long)_forceTouchCapability {
    return 2;
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
    return TRUE;
}
%end

//%ctor {
//    %init;
//}
