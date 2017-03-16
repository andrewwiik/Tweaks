//
//  IBKMobileTimerResources.m
//  MobileTimer
//
//  Created by Matt Clarke on 03/04/2015.
//
//

#import "IBKMobileTimerResources.h"

static NSDictionary *settings;

@implementation IBKMobileTimerResources

+(BOOL)hasNumbers {
    id temp = settings[@"hasNumbers"];
    return (temp ? [temp boolValue] : YES);
}

+(BOOL)hasGraduations {
    id temp = settings[@"hasGraduations"];
    return (temp ? [temp boolValue] : NO);
}

+(void)reloadSettings {
    settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.mobiletimer.ibkwidget.plist"];
}

@end
