//
//  ZKSwizzle.h
//  ZKSwizzle
//
//  Created by Alexander S Zielenski on 7/24/14.
//  Copyright (c) 2014 Alexander S Zielenski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include <sys/cdefs.h>
#import <UIKit/UIKit.h>

// This is a class for streamlining swizzling. Simply create a new class of any name you want and

// Example:
/*
 
 @interface ZKHookClass : NSObject
 
 - (NSString *)description; // hooks -description on NSObject
 - (void)addedMethod; // all subclasses of NSObject now respond to -addedMethod
 
 @end
 
 @implementation ZKHookClass
 
 ...
 
 @end
 
 [ZKSwizzle swizzleClass:ZKClass(ZKHookClass) forClass:ZKClass(destination)];
 
 */

// CRAZY MACROS FOR DYNAMIC PROTOTYPE CREATION
#define VA_NUM_ARGS(...) VA_NUM_ARGS_IMPL(0, ## __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5 ,4 ,3 ,2, 1, 0)
#define VA_NUM_ARGS_IMPL(_0, _1,_2,_3,_4,_5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20 ,N,...) N

#define WRAP0()
#define WRAP1(VARIABLE) , typeof ( VARIABLE )
#define WRAP2(VARIABLE, ...) WRAP1(VARIABLE) WRAP1(__VA_ARGS__)
#define WRAP3(VARIABLE, ...) WRAP1(VARIABLE) WRAP2(__VA_ARGS__)
#define WRAP4(VARIABLE, ...) WRAP1(VARIABLE) WRAP3(__VA_ARGS__)
#define WRAP5(VARIABLE, ...) WRAP1(VARIABLE) WRAP4(__VA_ARGS__)
#define WRAP6(VARIABLE, ...) WRAP1(VARIABLE) WRAP5(__VA_ARGS__)
#define WRAP7(VARIABLE, ...) WRAP1(VARIABLE) WRAP6(__VA_ARGS__)
#define WRAP8(VARIABLE, ...) WRAP1(VARIABLE) WRAP7(__VA_ARGS__)
#define WRAP9(VARIABLE, ...) WRAP1(VARIABLE) WRAP8(__VA_ARGS__)
#define WRAP10(VARIABLE, ...) WRAP1(VARIABLE) WRAP9(__VA_ARGS__)
#define WRAP11(VARIABLE, ...) WRAP1(VARIABLE) WRAP10(__VA_ARGS__)
#define WRAP12(VARIABLE, ...) WRAP1(VARIABLE) WRAP11(__VA_ARGS__)
#define WRAP13(VARIABLE, ...) WRAP1(VARIABLE) WRAP12(__VA_ARGS__)
#define WRAP14(VARIABLE, ...) WRAP1(VARIABLE) WRAP13(__VA_ARGS__)
#define WRAP15(VARIABLE, ...) WRAP1(VARIABLE) WRAP14(__VA_ARGS__)
#define WRAP16(VARIABLE, ...) WRAP1(VARIABLE) WRAP15(__VA_ARGS__)
#define WRAP17(VARIABLE, ...) WRAP1(VARIABLE) WRAP16(__VA_ARGS__)
#define WRAP18(VARIABLE, ...) WRAP1(VARIABLE) WRAP17(__VA_ARGS__)
#define WRAP19(VARIABLE, ...) WRAP1(VARIABLE) WRAP18(__VA_ARGS__)
#define WRAP20(VARIABLE, ...) WRAP1(VARIABLE) WRAP19(__VA_ARGS__)

#define CAT(A, B) A ## B
#define INVOKE(MACRO, NUMBER, ...) CAT(MACRO, NUMBER)(__VA_ARGS__)
#define WRAP_LIST(...) INVOKE(WRAP, VA_NUM_ARGS(__VA_ARGS__), __VA_ARGS__)


// Gets the a class with the name CLASS
#define ZKClass(CLASS) objc_getClass(#CLASS)

// returns the value of an instance variable.
#if !__has_feature(objc_arc)
#define ZKHookIvar(OBJECT, TYPE, NAME) (*(TYPE *)ZKIvarPointer(OBJECT, NAME))
#else
#define ZKHookIvar(OBJECT, TYPE, NAME) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wignored-attributes\"") \
(*(__unsafe_unretained TYPE *)ZKIvarPointer(OBJECT, NAME)) \
_Pragma("clang diagnostic pop")
#endif
// returns the original implementation of the swizzled function or null or not found
#define ZKOrig(TYPE, ...) ((TYPE (*)(id, SEL WRAP_LIST(__VA_ARGS__)))(ZKOriginalImplementation(self, _cmd, __PRETTY_FUNCTION__)))(self, _cmd, ##__VA_ARGS__)

// returns the original implementation of the superclass of the object swizzled
#define ZKSuper(TYPE, ...) ((TYPE (*)(id, SEL WRAP_LIST(__VA_ARGS__)))(ZKSuperImplementation(self, _cmd, __PRETTY_FUNCTION__)))(self, _cmd, ##__VA_ARGS__)

// Ripped off from MobileSubstrate
// Bootstraps your swizzling class so that it requires no setup
// outside of this macro call
// If you override +load you must call ZKSwizzle(CLASS_NAME, TARGET_CLASS)
// yourself, otherwise the swizzling would not take place
#define ZKSwizzleInterface(CLASS_NAME, TARGET_CLASS, SUPERCLASS) \
@interface _$ ## CLASS_NAME : SUPERCLASS @end \
@implementation _$ ## CLASS_NAME \
+ (void)initialize {} \
@end \
@interface CLASS_NAME : _$ ## CLASS_NAME @end \
@implementation CLASS_NAME (ZKSWIZZLE) \
+ (void)load { \
ZKSwizzle(CLASS_NAME, TARGET_CLASS); \
} \
@end

// thanks OBJC_OLD_DISPATCH_PROTOTYPES=0
typedef id (*ZKIMP)(id, SEL, ...);

__BEGIN_DECLS

// returns a pointer to the instance variable "name" on the object
void *ZKIvarPointer(id self, const char *name);
// returns the original implementation of a method with selector "sel" of an object hooked by the methods below
ZKIMP ZKOriginalImplementation(id self, SEL sel, const char *info);
// returns the implementation of a method with selector "sel" of the superclass of object
ZKIMP ZKSuperImplementation(id object, SEL sel, const char *info);

// hooks all the implemented methods of source with destination
// adds any methods that arent implemented on destination to destination that are implemented in source
#define ZKSwizzle(src, dst) _ZKSwizzle(ZKClass(src), ZKClass(dst))
BOOL _ZKSwizzle(Class src, Class dest);

// Calls above method with the superclass of source for desination
#define ZKSwizzleClass(src) _ZKSwizzleClass(ZKClass(src))
BOOL _ZKSwizzleClass(Class cls);

__END_DECLS

static NSMutableDictionary *classTable;

void *ZKIvarPointer(id self, const char *name) {
    Ivar ivar = class_getInstanceVariable(object_getClass(self), name);
    return ivar == NULL ? NULL : (__bridge void *)self + ivar_getOffset(ivar);
}

static SEL destinationSelectorForSelector(SEL cmd, Class dst) {
    return NSSelectorFromString([@"_ZK_old_" stringByAppendingFormat:@"%s_%@", class_getName(dst), NSStringFromSelector(cmd)]);
}

static Class classFromInfo(const char *info) {
    NSUInteger bracket_index = -1;
    for (NSUInteger i = 0; i < strlen(info); i++) {
        if (info[i] == '[') {
            bracket_index = i;
        }
    }
    bracket_index++;
    
    if (bracket_index == -1) {
        [NSException raise:@"Failed to parse info" format:@"Couldn't find swizzle class for info: %s", info];
        return NULL;
    }
    
    char after_bracket[255];
    memcpy(after_bracket, &info[bracket_index], strlen(info) - bracket_index - 1);
    
    for (NSUInteger i = 0; i < strlen(info); i++) {
        if (after_bracket[i] == ' ') {
            after_bracket[i] = '\0';
        }
    }
    
    return objc_getClass(after_bracket);
}

// takes __PRETTY_FUNCTION__ for info which gives the name of the swizzle source class
/*
 
 We add the original implementation onto the swizzle class
 On ZKOrig, we use __PRETTY_FUNCTION__ to get the name of the swizzle class
 Then we get the implementation of that selector on the swizzle class
 Then we call it directly, passing in the correct selector and self
 
 */
ZKIMP ZKOriginalImplementation(id self, SEL sel, const char *info) {
    if (sel == NULL || self == NULL || info == NULL) {
        [NSException raise:@"Invalid Arguments" format:@"One of self: %@, self: %@, or info: %s is NULL", self, NSStringFromSelector(sel), info];
        return NULL;
    }
    
    Class cls = classFromInfo(info);
    Class dest = object_getClass(self);
    
    if (cls == NULL || dest == NULL) {
        [NSException raise:@"Failed obtain class pair" format:@"src: %@ | dst: %@ | sel: %@", NSStringFromClass(cls), NSStringFromClass(dest), NSStringFromSelector(sel)];
        return NULL;
    }
    
    SEL destSel = destinationSelectorForSelector(sel, cls);
    
    Method method =  class_getInstanceMethod(dest, destSel);
    
    if (method == NULL) {
        [NSException raise:@"Failed to retrieve method" format:@"Got null for the source class %@ with selector %@ (%@)", NSStringFromClass(cls), NSStringFromSelector(sel), NSStringFromSelector(destSel)];
        return NULL;
    }
    
    ZKIMP implementation = (ZKIMP)method_getImplementation(method);
    if (implementation == NULL) {
        [NSException raise:@"Failed to get implementation" format:@"The objective-c runtime could not get the implementation for %@ on the class %@. There is no fix for this", NSStringFromClass(cls), NSStringFromSelector(sel)];
    }
    
    return implementation;
}

ZKIMP ZKSuperImplementation(id object, SEL sel, const char *info) {
    if (sel == NULL || object == NULL) {
        [NSException raise:@"Invalid Arguments" format:@"One of self: %@, self: %@ is NULL", object, NSStringFromSelector(sel)];
        return NULL;
    }
    
    Class cls = object_getClass(object);
    if (cls == NULL) {
        [NSException raise:@"Invalid Argument" format:@"Could not obtain class for the passed object"];
        return NULL;
    }
    
    // Two scenarios:
    // 1.) The superclass was not swizzled, no problem
    // 2.) The superclass was swizzled, problem
    
    // We want to return the swizzled class's superclass implementation
    // If this is a subclass of such a class, we want two behaviors:
    // a.) If this imp was also swizzled, no problem, return the superclass's swizzled imp
    // b.) This imp was not swizzled, return the class that was originally swizzled's superclass's imp
    Class sourceClass = classFromInfo(info);
    if (sourceClass != NULL) {
        BOOL isClassMethod = class_isMetaClass(cls);
        // This was called from a swizzled method, get the class it was swizzled with
        NSString *className = classTable[NSStringFromClass(sourceClass)];
        if (className != NULL) {
            cls = NSClassFromString(className);
            // make sure we get a class method if we asked for one
            if (isClassMethod) {
                cls = object_getClass(cls);
            }
        }
    }
    
    cls = class_getSuperclass(cls);
    
    // This is a root class, it has no super class
    if (cls == NULL) {
        [NSException raise:@"Invalid Argument" format:@"Could not obtain superclass for the passed object"];
        return NULL;
    }
    
    Method method = class_getInstanceMethod(cls, sel);
    if (method == NULL) {
        [NSException raise:@"Failed to retrieve method" format:@"We could not find the super implementation for the class %@ and selector %@, are you sure it exists?", NSStringFromClass(cls), NSStringFromSelector(sel)];
        return NULL;
    }
    
    ZKIMP implementation = (ZKIMP)method_getImplementation(method);
    if (implementation == NULL) {
        [NSException raise:@"Failed to get implementation" format:@"The objective-c runtime could not get the implementation for %@ on the class %@. There is no fix for this", NSStringFromClass(cls), NSStringFromSelector(sel)];
    }
    
    return implementation;
}

static BOOL enumerateMethods(Class, Class);
BOOL _ZKSwizzle(Class src, Class dest) {
    if (dest == NULL)
        return NO;
    
    NSString *destName = NSStringFromClass(dest);
    if (!destName) {
        return NO;
    }
    
    NSLog(@"ZKSwizzle: Swizzling %@ with %@", NSStringFromClass(src), NSStringFromClass(dest));
    if (!classTable) {
        classTable = [[NSMutableDictionary alloc] init];
    }
    
    if ([classTable objectForKey:NSStringFromClass(src)]) {
        [NSException raise:@"Invalid Argument"
                    format:@"This source class was already swizzled with another"];
        return NO;
    }
    
    BOOL success = enumerateMethods(dest, src);
    // The above method only gets instance methods. Do the same method for the metaclass of the class
    success     &= enumerateMethods(object_getClass(dest), object_getClass(src));
    
    [classTable setObject:destName forKey:NSStringFromClass(src)];
    return success;
}

BOOL _ZKSwizzleClass(Class cls) {
    return _ZKSwizzle(cls, [cls superclass]);
}

static BOOL enumerateMethods(Class destination, Class source) {
    unsigned int methodCount;
    Method *methodList = class_copyMethodList(source, &methodCount);
    BOOL success = YES;
    for (int i = 0; i < methodCount; i++) {
        Method method = methodList[i];
        SEL selector  = method_getName(method);
        NSString *methodName = NSStringFromSelector(selector);
        
        // We only swizzle methods that are implemented
        if (class_respondsToSelector(destination, selector)) {
            Method originalMethod = class_getInstanceMethod(destination, selector);
            
            const char *originalType = method_getTypeEncoding(originalMethod);
            const char *newType = method_getTypeEncoding(method);
            if (strcmp(originalType, newType) != 0) {
                NSLog(@"ZKSwizzle: incompatible type encoding for %@. (expected %s, got %s)", methodName, originalType, newType);
                // Incompatible type encoding
                success = NO;
                continue;
            }
            
            // We are re-adding the destination selector because it could be on a superclass and not on the class itself. This method could fail
            class_addMethod(destination, selector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            
            SEL destSel = destinationSelectorForSelector(selector, source);
            if (!class_addMethod(destination, destSel, method_getImplementation(method), method_getTypeEncoding(originalMethod))) {
                NSLog(@"ZKSwizzle: failed to add method %@ onto class %@ with selector %@", NSStringFromSelector(selector), NSStringFromClass(source), NSStringFromSelector(destSel));
                success = NO;
                continue;
            }
            
            method_exchangeImplementations(class_getInstanceMethod(destination, selector), class_getInstanceMethod(destination, destSel));
        } else {
            // Add any extra methods to the class but don't swizzle them
            success &= class_addMethod(destination, selector, method_getImplementation(method), method_getTypeEncoding(method));
        }
    }
    
    unsigned int propertyCount;
    objc_property_t *propertyList = class_copyPropertyList(source, &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        const char *name = property_getName(property);
        unsigned int attributeCount;
        objc_property_attribute_t *attributes = property_copyAttributeList(property, &attributeCount);
        
        if (class_getProperty(destination, name) == NULL) {
            class_addProperty(destination, name, attributes, attributeCount);
        } else {
            class_replaceProperty(destination, name, attributes, attributeCount);
        }
        
        free(attributes);
    }
    
    free(propertyList);
    free(methodList);
    return success;
}





ZKSwizzleInterface($_Lamo_UIApplication, UIApplication, NSObject);

@implementation $_Lamo_UIApplication

- (id)init {
    
    //we dont want to register springboard for notifications
    NSString *dispident = [(UIApplication *)self displayIdentifier];
    if (![dispident isEqualToString:@"com.apple.springboard"]) {

        //if we get here, we're inside an app. register notification for rotation
        //notification will be appidentifierLamoRotate
        NSString *rotationLandscapeNotification = [NSString stringWithFormat:@"%@LamoLandscapeRotate", dispident];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), (CFNotificationCallback)receivedLandscapeRotate, (CFStringRef)rotationLandscapeNotification, NULL, CFNotificationSuspensionBehaviorDrop);
        
        //portrait
        NSString *rotationPortraitNotification = [NSString stringWithFormat:@"%@LamoPortraitRotate", dispident];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), (CFNotificationCallback)receivedPortraitRotate, (CFStringRef)rotationPortraitNotification, NULL, CFNotificationSuspensionBehaviorDrop);
        
        //create statusbar notification
        NSString *changeStatusBarNotification = [NSString stringWithFormat:@"%@LamoStatusBarChange", dispident];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(), (__bridge const void *)(self), (CFNotificationCallback)receivedStatusBarChange, (CFStringRef)changeStatusBarNotification, NULL, CFNotificationSuspensionBehaviorDrop);
        
        //create window size notification
        NSString *windowSizeNotification = [NSString stringWithFormat:@"Resize-%@", dispident];
        CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(), (__bridge const void *)(self), (CFNotificationCallback)recievedResize, (CFStringRef)windowSizeNotification, NULL, CFNotificationSuspensionBehaviorDrop);
                
    }
    
    return ZKOrig(id, 1);
}

void receivedStatusBarChange(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {

    //set hidden based on isHidden key
    [[UIApplication sharedApplication] setStatusBarHidden:[[(__bridge NSDictionary *)userInfo valueForKey:@"isHidden"] boolValue] animated:YES];
}

void receivedLandscapeRotate() {
    
    //rotate all windows
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        
        [window _setRotatableViewOrientation:UIInterfaceOrientationLandscapeRight updateStatusBar:YES duration:0.45 force:YES];
        
    }
}

void receivedPortraitRotate() {
    
    //rotate all windows
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        
        [window _setRotatableViewOrientation:UIInterfaceOrientationPortrait updateStatusBar:YES duration:0.45 force:YES];
        
    }
}

void recievedResize(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    
    //resize all windows
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        
        [window setFrame:[[(__bridge NSDictionary *)userInfo valueForKey:@"frame"] CGRectValue]];
        
    }
}

@end