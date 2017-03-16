//    ALEWeatherUtility.m
//    The Weather Utility Implementation
//    Created by Andrew Wiik <andrew.wiik@vtsd.com> 04/06/2016
//    © Creatix <ioscreatix@gmail.com>. All rights reserved.
//
//
//

#import "ALEWeatherUtility.h"

@implementation ALEWeatherUtility

+ (NSString *)celsiusToFahrenheit:(NSString *)celsius withDegree:(BOOL)withDegree {

	double tempValue = (([celsius intValue]*9)/5) + 32;
	if (!withDegree)
		return [NSString stringWithFormat:@"%d", (unsigned int)tempValue];
	else
		return [NSString stringWithFormat:@"%dO", (unsigned int)tempValue];
}

+ (NSString *)localizedConditionDescriptionForConditionCode:(int)conditionCode {
	return [[ALEWeatherUtility weatherBundle] localizedStringForKey:[NSClassFromString(@"WeatherIconsUtility") lookupWeatherDescription:conditionCode] value:@"" table:@"WeatherFrameworkLocalizableStrings"];
}

+ (NSString *)localizedDayOfWeekShort:(int)dayNumber {
	NSBundle *strings = [ALEWeatherUtility weatherBundle];
	NSString *dayString;
	switch (dayNumber) {
        case 1:
            dayString = [strings localizedStringForKey:@"SUN" value:@"Sun" table:@"WeatherFrameworkLocalizableStrings"];
            break;
        case 2:
            dayString = [strings localizedStringForKey:@"MON" value:@"Mon" table:@"WeatherFrameworkLocalizableStrings"];
            break;
        case 3:
            dayString = [strings localizedStringForKey:@"TUE" value:@"Tue" table:@"WeatherFrameworkLocalizableStrings"];
            break;
        case 4:
            dayString = [strings localizedStringForKey:@"WED" value:@"Wed" table:@"WeatherFrameworkLocalizableStrings"];
            break;
        case 5:
            dayString = [strings localizedStringForKey:@"THU" value:@"Thu" table:@"WeatherFrameworkLocalizableStrings"];
            break;
        case 6:
            dayString = [strings localizedStringForKey:@"FRI" value:@"Fri" table:@"WeatherFrameworkLocalizableStrings"];
            break;
        case 7:
            dayString = [strings localizedStringForKey:@"SAT" value:@"Sat" table:@"WeatherFrameworkLocalizableStrings"];
            break;
        default:
            dayString = [strings localizedStringForKey:@"SUN" value:@"Sun" table:@"WeatherFrameworkLocalizableStrings"];
            break;
    }
    return dayString;

}

+ (NSBundle *)weatherBundle {
	return [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Weather.framework"];
}

+ (UIImage *)imageForConditionCode:(int)conditionCode {
	return [[NSClassFromString(@"WeatherImageLoader") conditionImageWithConditionIndex:conditionCode] maskWithColor:[UIColor blackColor]];
}

+ (NSString *)localizedShortTime:(NSString *)time {
	NSString *hour = [time substringToIndex:2];
	NSString *shortTime;
	if ([[hour substringToIndex:1] isEqualToString: @"0"]) {
		hour = [hour substringWithRange:NSMakeRange(1, 1)];
	}
	if ([hour intValue] >= 12) {
		shortTime = [NSString stringWithFormat:@"%@PM", hour];
	}
	else {
		shortTime = [NSString stringWithFormat:@"%@AM", hour];
	}
	if ([hour intValue] == 0) {
		shortTime = [NSString stringWithFormat:@"12AM"];
	}
	return shortTime;
}

+ (NSString *)temperatureForHigh:(NSString *)high andLow:(NSString *)low celsius:(BOOL)celsius withDegree:(BOOL)withDegree {
	double highValue = [high intValue];
	double lowValue = [low intValue];
	if (!celsius) {
		highValue = ((highValue*9)/5) + 32;
		lowValue = ((lowValue*9)/5) + 32;
	}
	double finalValue = (highValue + lowValue)/2;
	if (!withDegree)
		return [NSString stringWithFormat:@"%d", (unsigned int)finalValue];
	else
		return [NSString stringWithFormat:@"%dO", (unsigned int)finalValue]; 
}
@end