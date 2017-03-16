#line 1 "/Users/awiik/Dropbox/tweaks/universalforce/universalforce/universalforce.xm"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Additions.h"

#define THEOS_INSTANCE_NAME
































#if !defined(__COREFOUNDATION_CFLOGUTILITIES__)
#define __COREFOUNDATION_CFLOGUTILITIES__ 1

#include <CoreFoundation/CFBase.h>
#include <CoreFoundation/CFString.h>


CF_EXTERN_C_BEGIN


enum {	
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








CF_EXTERN_C_END

#endif 


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



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class _UITouchForceMessage; @class UIDevice; @class UIScreen; @class UITraitCollection; @class UITouch; 
static void (*_logos_orig$_ungrouped$UITouch$setMajorRadius$)(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST, SEL, float); static void _logos_method$_ungrouped$UITouch$setMajorRadius$(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST, SEL, float); static CGFloat _logos_method$_ungrouped$UITouch$getQuality(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST, SEL); static CGFloat _logos_method$_ungrouped$UITouch$getDensity(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST, SEL); static CGFloat _logos_method$_ungrouped$UITouch$getRadius(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST, SEL); static int _logos_method$_ungrouped$UITouch$getX(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST, SEL); static int _logos_method$_ungrouped$UITouch$getY(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$UITouch$calculateNewForce(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$_UITouchForceMessage$setUnclampedTouchForce$)(_LOGOS_SELF_TYPE_NORMAL _UITouchForceMessage* _LOGOS_SELF_CONST, SEL, CGFloat); static void _logos_method$_ungrouped$_UITouchForceMessage$setUnclampedTouchForce$(_LOGOS_SELF_TYPE_NORMAL _UITouchForceMessage* _LOGOS_SELF_CONST, SEL, CGFloat); static long long (*_logos_orig$_ungrouped$UIScreen$_forceTouchCapability)(_LOGOS_SELF_TYPE_NORMAL UIScreen* _LOGOS_SELF_CONST, SEL); static long long _logos_method$_ungrouped$UIScreen$_forceTouchCapability(_LOGOS_SELF_TYPE_NORMAL UIScreen* _LOGOS_SELF_CONST, SEL); static int (*_logos_orig$_ungrouped$UITraitCollection$forceTouchCapability)(_LOGOS_SELF_TYPE_NORMAL UITraitCollection* _LOGOS_SELF_CONST, SEL); static int _logos_method$_ungrouped$UITraitCollection$forceTouchCapability(_LOGOS_SELF_TYPE_NORMAL UITraitCollection* _LOGOS_SELF_CONST, SEL); static id (*_logos_meta_orig$_ungrouped$UITraitCollection$traitCollectionWithForceTouchCapability$)(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static id _logos_meta_method$_ungrouped$UITraitCollection$traitCollectionWithForceTouchCapability$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, int); static BOOL (*_logos_orig$_ungrouped$UIDevice$_supportsForceTouch)(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$_ungrouped$UIDevice$_supportsForceTouch(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST, SEL); 

#line 96 "/Users/awiik/Dropbox/tweaks/universalforce/universalforce/universalforce.xm"
@interface UITouch (E)
- (id)_hidEvent;
- (void)calculateNewForce;
@end

static void _logos_method$_ungrouped$UITouch$setMajorRadius$(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST self, SEL _cmd, float arg1) {
    [self calculateNewForce];
    _logos_orig$_ungrouped$UITouch$setMajorRadius$(self, _cmd, arg1);
}

static CGFloat _logos_method$_ungrouped$UITouch$getQuality(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST self, SEL _cmd) {
    return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Quality:" andString:@"Density:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}

static CGFloat _logos_method$_ungrouped$UITouch$getDensity(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST self, SEL _cmd) {
    return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Density:" andString:@"Irregularity:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}

static CGFloat _logos_method$_ungrouped$UITouch$getRadius(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST self, SEL _cmd) {
    return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"MajorRadius:" andString:@"MinorRadius:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}

static int _logos_method$_ungrouped$UITouch$getX(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST self, SEL _cmd) {
    return [[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"X:" andString:@"Y:"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
}

static int _logos_method$_ungrouped$UITouch$getY(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST self, SEL _cmd) {
    return [[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Y:" andString:@"Z:"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
}

static void _logos_method$_ungrouped$UITouch$calculateNewForce(_LOGOS_SELF_TYPE_NORMAL UITouch* _LOGOS_SELF_CONST self, SEL _cmd) {
    if (previousTouch) {
        CGFloat radiusChange = ([self getRadius]/[previousTouch getRadius] - 1);
        CGFloat densityChange = ([self getDensity]/[previousTouch getDensity] - 1);

    
        CGFloat finalChange = (densityChange + radiusChange);
        pressureChange = finalChange;
        previousTouch = self;
    }
    else {
        pressureChange = 0;
        previousTouch = self;
    }
}



static void _logos_method$_ungrouped$_UITouchForceMessage$setUnclampedTouchForce$(_LOGOS_SELF_TYPE_NORMAL _UITouchForceMessage* _LOGOS_SELF_CONST self, SEL _cmd, CGFloat touchForce) {
    double yT;
    if (previousForce)
        yT = previousForce * (1 + pressureChange);
    else
        yT = 300 * (1 + pressureChange);
        
    previousForce = yT;
    if (sizeof(void*) == 4) {
        _logos_orig$_ungrouped$_UITouchForceMessage$setUnclampedTouchForce$(self, _cmd, (float) yT);
    }
    else if (sizeof(void*) == 8) {
        _logos_orig$_ungrouped$_UITouchForceMessage$setUnclampedTouchForce$(self, _cmd, (double) yT);
    }
}



static long long _logos_method$_ungrouped$UIScreen$_forceTouchCapability(_LOGOS_SELF_TYPE_NORMAL UIScreen* _LOGOS_SELF_CONST self, SEL _cmd) {
    return 2;
}



static int _logos_method$_ungrouped$UITraitCollection$forceTouchCapability(_LOGOS_SELF_TYPE_NORMAL UITraitCollection* _LOGOS_SELF_CONST self, SEL _cmd) {
    return 2;
}
static id _logos_meta_method$_ungrouped$UITraitCollection$traitCollectionWithForceTouchCapability$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST self, SEL _cmd, int arg1) {
    return _logos_meta_orig$_ungrouped$UITraitCollection$traitCollectionWithForceTouchCapability$(self, _cmd, 2);
}



static BOOL _logos_method$_ungrouped$UIDevice$_supportsForceTouch(_LOGOS_SELF_TYPE_NORMAL UIDevice* _LOGOS_SELF_CONST self, SEL _cmd) {
    return TRUE;
}





static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$UITouch = objc_getClass("UITouch"); if (_logos_class$_ungrouped$UITouch) {MSHookMessageEx(_logos_class$_ungrouped$UITouch, @selector(setMajorRadius:), (IMP)&_logos_method$_ungrouped$UITouch$setMajorRadius$, (IMP*)&_logos_orig$_ungrouped$UITouch$setMajorRadius$);} else {HBLogError(@"logos: nil class %s", "UITouch");}{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(CGFloat), strlen(@encode(CGFloat))); i += strlen(@encode(CGFloat)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$UITouch, @selector(getQuality), (IMP)&_logos_method$_ungrouped$UITouch$getQuality, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(CGFloat), strlen(@encode(CGFloat))); i += strlen(@encode(CGFloat)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$UITouch, @selector(getDensity), (IMP)&_logos_method$_ungrouped$UITouch$getDensity, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(CGFloat), strlen(@encode(CGFloat))); i += strlen(@encode(CGFloat)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$UITouch, @selector(getRadius), (IMP)&_logos_method$_ungrouped$UITouch$getRadius, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'i'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$UITouch, @selector(getX), (IMP)&_logos_method$_ungrouped$UITouch$getX, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'i'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$UITouch, @selector(getY), (IMP)&_logos_method$_ungrouped$UITouch$getY, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$UITouch, @selector(calculateNewForce), (IMP)&_logos_method$_ungrouped$UITouch$calculateNewForce, _typeEncoding); }Class _logos_class$_ungrouped$_UITouchForceMessage = objc_getClass("_UITouchForceMessage"); if (_logos_class$_ungrouped$_UITouchForceMessage) {MSHookMessageEx(_logos_class$_ungrouped$_UITouchForceMessage, @selector(setUnclampedTouchForce:), (IMP)&_logos_method$_ungrouped$_UITouchForceMessage$setUnclampedTouchForce$, (IMP*)&_logos_orig$_ungrouped$_UITouchForceMessage$setUnclampedTouchForce$);} else {HBLogError(@"logos: nil class %s", "_UITouchForceMessage");}Class _logos_class$_ungrouped$UIScreen = objc_getClass("UIScreen"); if (_logos_class$_ungrouped$UIScreen) {MSHookMessageEx(_logos_class$_ungrouped$UIScreen, @selector(_forceTouchCapability), (IMP)&_logos_method$_ungrouped$UIScreen$_forceTouchCapability, (IMP*)&_logos_orig$_ungrouped$UIScreen$_forceTouchCapability);} else {HBLogError(@"logos: nil class %s", "UIScreen");}Class _logos_class$_ungrouped$UITraitCollection = objc_getClass("UITraitCollection"); Class _logos_metaclass$_ungrouped$UITraitCollection = object_getClass(_logos_class$_ungrouped$UITraitCollection); if (_logos_class$_ungrouped$UITraitCollection) {MSHookMessageEx(_logos_class$_ungrouped$UITraitCollection, @selector(forceTouchCapability), (IMP)&_logos_method$_ungrouped$UITraitCollection$forceTouchCapability, (IMP*)&_logos_orig$_ungrouped$UITraitCollection$forceTouchCapability);} else {HBLogError(@"logos: nil class %s", "UITraitCollection");}if (_logos_metaclass$_ungrouped$UITraitCollection) {MSHookMessageEx(_logos_metaclass$_ungrouped$UITraitCollection, @selector(traitCollectionWithForceTouchCapability:), (IMP)&_logos_meta_method$_ungrouped$UITraitCollection$traitCollectionWithForceTouchCapability$, (IMP*)&_logos_meta_orig$_ungrouped$UITraitCollection$traitCollectionWithForceTouchCapability$);} else {HBLogError(@"logos: nil class %s", "UITraitCollection");}Class _logos_class$_ungrouped$UIDevice = objc_getClass("UIDevice"); if (_logos_class$_ungrouped$UIDevice) {MSHookMessageEx(_logos_class$_ungrouped$UIDevice, @selector(_supportsForceTouch), (IMP)&_logos_method$_ungrouped$UIDevice$_supportsForceTouch, (IMP*)&_logos_orig$_ungrouped$UIDevice$_supportsForceTouch);} else {HBLogError(@"logos: nil class %s", "UIDevice");}} }
#line 185 "/Users/awiik/Dropbox/tweaks/universalforce/universalforce/universalforce.xm"
