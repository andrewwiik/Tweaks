//
//  IBKResources.m
//  curago
//
//  Created by Matt Clarke on 04/06/2014.
//
//

#import "IBKResources.h"
#import <SpringBoard7.0/SBIconListModel.h>
#import <objc/runtime.h>

@interface SBFAnimationFactory : NSObject
+ (id)factoryWithDuration:(double)arg1;
- (CGFloat)duration;
@end

#define plist @"/var/mobile/Library/Preferences/com.matchstic.curago.plist"

static NSMutableSet *widgetIdentifiers;
static NSDictionary *settings;

@implementation IBKResources

+(CGFloat)adjustedAnimationSpeed:(CGFloat)duration {
    if ([objc_getClass("SBFAnimationFactory") respondsToSelector:@selector(factoryWithDuration:)]) {
        return [(SBFAnimationFactory*)[objc_getClass("SBFAnimationFactory") factoryWithDuration:duration] duration];
    } else {
        return duration;
    }
}

+(NSSet*)widgetBundleIdentifiers {
    if (!widgetIdentifiers) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plist];
        widgetIdentifiers = [NSMutableSet setWithArray:[[dict objectForKey:@"loadedWidgets"] mutableCopy]];
        
        if (!widgetIdentifiers)
            widgetIdentifiers = [NSMutableSet set];
    }
    
    return widgetIdentifiers;
}

+(void)addNewIdentifier:(NSString*)arg1 {
    if (arg1) {
        [widgetIdentifiers addObject:arg1];
        [IBKResources saveIdentifiersToPlist];
        
        NSLog(@"That should have saved...");
    }
}

+(void)removeIdentifier:(NSString*)arg1 {
    if (arg1) {
        [widgetIdentifiers removeObject:arg1];
        
        NSLog(@"*** Attempted to remove %@", arg1);
        NSLog(@"*** Loaded widget identifiers are now %@", widgetIdentifiers);
        
        [IBKResources saveIdentifiersToPlist];
    }
}

+(void)saveIdentifiersToPlist {
    // Save to plist.
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plist];
    
    if (!dict)
        dict = [NSMutableDictionary dictionary];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *string in widgetIdentifiers)
        [array addObject:string];
    
    [dict setObject:array forKey:@"loadedWidgets"];
    [dict writeToFile:plist atomically:YES];
}

// TODO: THIS ASSUMES IT'S ALWAYS 4 ICONS PER ROW!

+(CGFloat)widthForWidget {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 252;
    else if (IS_IPHONE_6)
        return 147;
    else if (IS_IPHONE_6_PLUS)
        return 158;
    else
        return 136;
}

+(CGFloat)heightForWidget {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return 237;
    else if (IS_IPHONE_6)
        return 148;
    else if (IS_IPHONE_6_PLUS)
        return 158;
    else
        return 148;
}

+(NSArray*)generateWidgetIndexesForListView:(SBIconListView*)view {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *bundleID in [IBKResources widgetBundleIdentifiers]) {
        unsigned int index = [[view model] indexForLeafIconWithIdentifier:bundleID];
        if (index <= [objc_getClass("SBIconListModel") maxIcons])
            [array addObject:[NSNumber numberWithInt:index]];
    }
    
    return array;
}

+(NSString*)getRedirectedIdentifierIfNeeded:(NSString*)identifier {
    if (!settings)
        [IBKResources reloadSettings];
    
    NSDictionary *dict = settings[@"redirectedIdentifiers"];
    
    if (dict && [dict objectForKey:identifier])
        return [dict objectForKey:identifier];
    else
        return identifier;
}

+(NSString*)suffix {
    NSString *suffix = @"";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        suffix = @"~ipad";
    }
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (scale >= 2.0 && scale < 3.0) {
        suffix = [suffix stringByAppendingString:@"@2x.png"];
    } else if (scale >= 3.0) {
        suffix = [suffix stringByAppendingString:@"@3x.png"];
    } else if (scale < 2.0) {
        suffix = [suffix stringByAppendingString:@".png"];
    }
    
    return suffix;
}

//// BEGIN ACTUAL SETTINGS CHECKS.

+(BOOL)shouldHideBadgeWhenWidgetExpanded {
    id temp = settings[@"shouldHideBadge"];
    return (temp ? [temp boolValue] : NO);
}

+(BOOL)shouldReturnIconsIfNotMoved {
    id temp = settings[@"returnIcons"];
    return (temp ? [temp boolValue] : NO);
}

+(BOOL)transparentBackgroundForWidgets {
    id temp = settings[@"transparentWidgets"];
    return (temp ? [temp boolValue] : NO);
}

+(BOOL)showBorderWhenTransparent {
    id temp = settings[@"borderedWidgets"];
    return (temp ? [temp boolValue] : YES);
}

+(BOOL)hoverOnly {
    id temp = settings[@"hoverOnly"];
    return (temp ? [temp boolValue] : NO);
}

+(BOOL)debugLoggingEnabled {
    id temp = settings[@"debug"];
    return (temp ? [temp boolValue] : NO);
}

+(int)defaultColourType { // Used for switching which method to use for average colour of icon.
    id temp = settings[@"defaultColourType"];
    return (temp ? [temp intValue] : 0);
    
    // Enum:
    // 0 = average of 1px
    // 1 = dominant colour
}

#pragma mark Widget locking

+(BOOL)allWidgetsLocked {
    id temp = settings[@"allWidgetsLocked"];
    return (temp ? [temp boolValue] : NO);
}

+(BOOL)relockWidgets {
    NSNumber *temp = settings[@"relockWidgets"];
    if (temp) {
        return ([temp intValue] == 0 ? NO : YES);
    } else {
        return NO;
    }
}

+(NSString*)passcodeHash {
    id temp = settings[@"passcodeHash"];
    return (temp && ![temp isEqualToString:@""] ? temp : nil);
}

+(BOOL)isWidgetLocked:(NSString*)identifier {
    if (![IBKResources passcodeHash]) {
        return NO;
    } else if ([IBKResources allWidgetsLocked]) {
        return YES;
    }
    
    NSArray *lockedBundleIdentifiers = settings[@"lockedBundleIdentifiers"];
    return [lockedBundleIdentifiers containsObject:identifier];
}

+(void)reloadSettings {
    settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
}

@end
