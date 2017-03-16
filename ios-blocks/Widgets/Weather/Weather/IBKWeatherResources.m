//
//  IBKWeatherResources.m
//  Weather
//
//  Created by Matt Clarke on 31/03/2015.
//
//

#import "IBKWeatherResources.h"

NSDictionary *settings;

@implementation IBKWeatherResources

+(BOOL)centeredMainUI {
    id temp = settings[@"centeredUI"];
    return (temp ? [temp boolValue] : NO);
}

+(BOOL)showFiveDayForecast {
    id temp = settings[@"showFiveDay"];
    return (temp ? [temp boolValue] : YES);
}

+(void)reloadSettings {
    settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.weather.ibkwidget.plist"];
}

@end
