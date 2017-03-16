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

+(CALayer*)colourBackingLayerForCondition:(int)condition isDay:(BOOL)isDay {
    CAGradientLayer *layer = [CAGradientLayer new];
    
    UIColor *color1;
    UIColor *color2;
    
    // Yes, this is huge. Oh well. It makes sense. ;P
    
    if (isDay) {
        switch (condition) {
            case 0:
                color1 = [UIColor colorWithRed:0.475000 green:0.486700 blue:0.500000 alpha:1];
                color2 = [UIColor colorWithRed:0.396000 green:0.400000 blue:0.376000 alpha:1];
                break;
            case 1:
                color1 = [UIColor colorWithRed:0.160100 green:0.197300 blue:0.218800 alpha:1];
                color2 = [UIColor colorWithRed:0.448500 green:0.529900 blue:0.577000 alpha:1];
                break;
            case 2:
                color1 = [UIColor colorWithRed:0.495400 green:0.519600 blue:0.551400 alpha:1];
                color2 = [UIColor colorWithRed:0.246000 green:0.274800 blue:0.300000 alpha:1];
                break;
            case 3:
                color1 = [UIColor colorWithRed:0.360700 green:0.440100 blue:0.478700 alpha:1];
                color2 = [UIColor colorWithRed:0.451000 green:0.539400 blue:0.587300 alpha:1];
                break;
            case 4:
                color1 = [UIColor colorWithRed:0.360700 green:0.440100 blue:0.478700 alpha:1];
                color2 = [UIColor colorWithRed:0.451000 green:0.539400 blue:0.587300 alpha:1];
                break;
            case 5:
                color1 = [UIColor colorWithRed:0.583400 green:0.620700 blue:0.663900 alpha:1];
                color2 = [UIColor colorWithRed:0.367700 green:0.400400 blue:0.433100 alpha:1];
                break;
            case 6:
                color1 = [UIColor colorWithRed:0.360700 green:0.440100 blue:0.478700 alpha:1];
                color2 = [UIColor colorWithRed:0.451000 green:0.539400 blue:0.587300 alpha:1];
                break;
            case 7:
                color1 = [UIColor colorWithRed:0.239800 green:0.286600 blue:0.342200 alpha:1];
                color2 = [UIColor colorWithRed:0.490200 green:0.521600 blue:0.545100 alpha:1];
                break;
            case 8:
                color1 = [UIColor colorWithRed:0.664000 green:0.783000 blue:0.830000 alpha:1];
                color2 = [UIColor colorWithRed:0.378000 green:0.477900 blue:0.540000 alpha:1];
                break;
            case 9:
                color1 = [UIColor colorWithRed:0.664000 green:0.783000 blue:0.830000 alpha:1];
                color2 = [UIColor colorWithRed:0.378000 green:0.477900 blue:0.540000 alpha:1];
                break;
            case 10:
                color1 = [UIColor colorWithRed:0.303800 green:0.421700 blue:0.490000 alpha:1];
                color2 = [UIColor colorWithRed:0.294000 green:0.361200 blue:0.420000 alpha:1];
                break;
            case 11:
                color1 = [UIColor colorWithRed:0.476000 green:0.605200 blue:0.680000 alpha:1];
                color2 = [UIColor colorWithRed:0.325000 green:0.427100 blue:0.500000 alpha:1];
                break;
            case 12:
                color1 = [UIColor colorWithRed:0.303800 green:0.421700 blue:0.490000 alpha:1];
                color2 = [UIColor colorWithRed:0.294000 green:0.361200 blue:0.420000 alpha:1];
                break;
            case 13:
                color1 = [UIColor colorWithRed:0.364900 green:0.482500 blue:0.585400 alpha:1];
                color2 = [UIColor colorWithRed:0.461200 green:0.563700 blue:0.639900 alpha:1];
                break;
            case 14:
                color1 = [UIColor colorWithRed:0.610200 green:0.768300 blue:0.875300 alpha:1];
                color2 = [UIColor colorWithRed:0.434400 green:0.513800 blue:0.576300 alpha:1];
                break;
            case 15:
                color1 = [UIColor colorWithRed:0.525000 green:0.630000 blue:0.700000 alpha:1];
                color2 = [UIColor colorWithRed:0.350000 green:0.425000 blue:0.500000 alpha:1];
                break;
            case 16:
                color1 = [UIColor colorWithRed:0.610200 green:0.768300 blue:0.875300 alpha:1];
                color2 = [UIColor colorWithRed:0.434400 green:0.513800 blue:0.576300 alpha:1];
                break;
            case 17:
                color1 = [UIColor colorWithRed:0.637400 green:0.663600 blue:0.688900 alpha:1];
                color2 = [UIColor colorWithRed:0.495900 green:0.579100 blue:0.667900 alpha:1];
                break;
            case 18:
                color1 = [UIColor colorWithRed:0.514900 green:0.593700 blue:0.646700 alpha:1];
                color2 = [UIColor colorWithRed:0.323600 green:0.397400 blue:0.437400 alpha:1];
                break;
            case 19:
                color1 = [UIColor colorWithRed:0.806300 green:0.795800 blue:0.752000 alpha:1];
                color2 = [UIColor colorWithRed:0.469400 green:0.467000 blue:0.441600 alpha:1];
                break;
            case 20:
                color1 = [UIColor colorWithRed:0.480000 green:0.556000 blue:0.600000 alpha:1];
                color2 = [UIColor colorWithRed:0.448500 green:0.529900 blue:0.577000 alpha:1];
                break;
            case 21:
                color1 = [UIColor colorWithRed:0.760000 green:0.742300 blue:0.684000 alpha:1];
                color2 = [UIColor colorWithRed:0.513900 green:0.560400 blue:0.554000 alpha:1];
                break;
            case 22:
                color1 = [UIColor colorWithRed:0.552600 green:0.583000 blue:0.628000 alpha:1];
                color2 = [UIColor colorWithRed:0.573400 green:0.571400 blue:0.559500 alpha:1];
                break;
            case 23:
                color1 = [UIColor colorWithRed:0.440000 green:0.726000 blue:0.880000 alpha:1];
                color2 = [UIColor colorWithRed:0.386900 green:0.587000 blue:0.730000 alpha:1];
                break;
            case 24:
                color1 = [UIColor colorWithRed:0.545600 green:0.726400 blue:0.847600 alpha:1];
                color2 = [UIColor colorWithRed:0.421500 green:0.511200 blue:0.600800 alpha:1];
                break;
            case 25:
                color1 = [UIColor colorWithRed:0.572000 green:0.736300 blue:0.880000 alpha:1];
                color2 = [UIColor colorWithRed:0.434000 green:0.567000 blue:0.700000 alpha:1];
                break;
            case 26:
                color1 = [UIColor colorWithRed:0.557600 green:0.627000 blue:0.680000 alpha:1];
                color2 = [UIColor colorWithRed:0.365000 green:0.437000 blue:0.500000 alpha:1];
                break;
            case 27:
                color1 = [UIColor colorWithRed:0.440000 green:0.726000 blue:0.880000 alpha:1];
                color2 = [UIColor colorWithRed:0.386900 green:0.587000 blue:0.730000 alpha:1];
                break;
            case 28:
                color1 = [UIColor colorWithRed:0.440000 green:0.726000 blue:0.880000 alpha:1];
                color2 = [UIColor colorWithRed:0.386900 green:0.587000 blue:0.730000 alpha:1];
                break;
            case 29:
                color1 = [UIColor colorWithRed:0.180000 green:0.531500 blue:0.750000 alpha:1];
                color2 = [UIColor colorWithRed:0.400000 green:0.666700 blue:0.800000 alpha:1];
                break;
            case 30:
                color1 = [UIColor colorWithRed:0.180000 green:0.531500 blue:0.750000 alpha:1];
                color2 = [UIColor colorWithRed:0.400000 green:0.666700 blue:0.800000 alpha:1];
                break;
            case 31:
                color1 = [UIColor colorWithRed:0.109500 green:0.543800 blue:0.730000 alpha:1];
                color2 = [UIColor colorWithRed:0.400000 green:0.666700 blue:0.800000 alpha:1];
                break;
            case 32:
                color1 = [UIColor colorWithRed:0.109500 green:0.543800 blue:0.730000 alpha:1];
                color2 = [UIColor colorWithRed:0.400000 green:0.666700 blue:0.800000 alpha:1];
                break;
            case 33:
                color1 = [UIColor colorWithRed:0.109500 green:0.543800 blue:0.730000 alpha:1];
                color2 = [UIColor colorWithRed:0.400000 green:0.666700 blue:0.800000 alpha:1];
                break;
            case 34:
                color1 = [UIColor colorWithRed:0.109500 green:0.543800 blue:0.730000 alpha:1];
                color2 = [UIColor colorWithRed:0.400000 green:0.666700 blue:0.800000 alpha:1];
                break;
            case 35:
                color1 = [UIColor colorWithRed:0.611200 green:0.702300 blue:0.806300 alpha:1];
                color2 = [UIColor colorWithRed:0.415800 green:0.463400 blue:0.540000 alpha:1];
                break;
            case 36:
                color1 = [UIColor colorWithRed:0.540000 green:0.858000 blue:0.900000 alpha:1];
                color2 = [UIColor colorWithRed:0.086790 green:0.528200 blue:0.802500 alpha:1];
                break;
            case 37:
                color1 = [UIColor colorWithRed:0.239800 green:0.286600 blue:0.342200 alpha:1];
                color2 = [UIColor colorWithRed:0.490200 green:0.521600 blue:0.545100 alpha:1];
                break;
            case 38:
                color1 = [UIColor colorWithRed:0.515900 green:0.618600 blue:0.670000 alpha:1];
                color2 = [UIColor colorWithRed:0.324000 green:0.372100 blue:0.400000 alpha:1];
                break;
            case 39:
                color1 = [UIColor colorWithRed:0.315500 green:0.693200 blue:0.896700 alpha:1];
                color2 = [UIColor colorWithRed:0.370600 green:0.555500 blue:0.687700 alpha:1];
                break;
            case 40:
                color1 = [UIColor colorWithRed:0.247800 green:0.365500 blue:0.420000 alpha:1];
                color2 = [UIColor colorWithRed:0.279400 green:0.326900 blue:0.349900 alpha:1];
                break;
            case 41:
                color1 = [UIColor colorWithRed:0.477500 green:0.618200 blue:0.768600 alpha:1];
                color2 = [UIColor colorWithRed:0.412900 green:0.555400 blue:0.680000 alpha:1];
                break;
            case 42:
                color1 = [UIColor colorWithRed:0.260700 green:0.315700 blue:0.389000 alpha:1];
                color2 = [UIColor colorWithRed:0.409800 green:0.486300 blue:0.573800 alpha:1];
                break;
            case 43:
                color1 = [UIColor colorWithRed:0.260700 green:0.315700 blue:0.389000 alpha:1];
                color2 = [UIColor colorWithRed:0.409800 green:0.486300 blue:0.573800 alpha:1];
                break;
            case 44:
                color1 = [UIColor colorWithRed:0.259900 green:0.558700 blue:0.747600 alpha:1];
                color2 = [UIColor colorWithRed:0.522900 green:0.712300 blue:0.830000 alpha:1];
                break;
            case 45:
                color1 = [UIColor colorWithRed:0.315500 green:0.693200 blue:0.896700 alpha:1];
                color2 = [UIColor colorWithRed:0.370600 green:0.555500 blue:0.687700 alpha:1];
                break;
            case 46:
                color1 = [UIColor colorWithRed:0.477500 green:0.618200 blue:0.768600 alpha:1];
                color2 = [UIColor colorWithRed:0.412900 green:0.555400 blue:0.680000 alpha:1];
                break;
            default:
                break;
        }
    } else {
        switch (condition) {
            case 0:
                color1 = [UIColor colorWithRed:0.071530 green:0.076640 blue:0.102200 alpha:1];
                color2 = [UIColor colorWithRed:0.226700 green:0.239400 blue:0.266700 alpha:1];
                break;
            case 1:
                color1 = [UIColor colorWithRed:0.495400 green:0.519600 blue:0.551400 alpha:1];
                color2 = [UIColor colorWithRed:0.246000 green:0.274800 blue:0.300000 alpha:1];
                break;
            case 2:
                color1 = [UIColor colorWithRed:0.270000 green:0.283500 blue:0.300000 alpha:1];
                color2 = [UIColor colorWithRed:0.036000 green:0.037800 blue:0.040000 alpha:1];
                break;
            case 3:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 4:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 5:
                color1 = [UIColor colorWithRed:0.071530 green:0.076640 blue:0.102200 alpha:1];
                color2 = [UIColor colorWithRed:0.226700 green:0.239400 blue:0.266700 alpha:1];
                break;
            case 6:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 7:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 8:
                color1 = [UIColor colorWithRed:0.079900 green:0.094430 blue:0.100200 alpha:1];
                color2 = [UIColor colorWithRed:0.067900 green:0.085840 blue:0.096990 alpha:1];
                break;
            case 9:
                color1 = [UIColor colorWithRed:0.079900 green:0.094430 blue:0.100200 alpha:1];
                color2 = [UIColor colorWithRed:0.067900 green:0.085840 blue:0.096990 alpha:1];
                break;
            case 10:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 11:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 12:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 13:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 14:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 15:
                color1 = [UIColor colorWithRed:0.071530 green:0.076640 blue:0.102200 alpha:1];
                color2 = [UIColor colorWithRed:0.226700 green:0.239400 blue:0.266700 alpha:1];
                break;
            case 16:
                color1 = [UIColor colorWithRed:0.087390 green:0.143200 blue:0.173400 alpha:1];
                color2 = [UIColor colorWithRed:0.252400 green:0.274000 blue:0.334700 alpha:1];
                break;
            case 17:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 18:
                color1 = [UIColor colorWithRed:0.071530 green:0.076640 blue:0.102200 alpha:1];
                color2 = [UIColor colorWithRed:0.226700 green:0.239400 blue:0.266700 alpha:1];
                break;
            case 19:
                color1 = [UIColor colorWithRed:0.054280 green:0.053080 blue:0.051000 alpha:1];
                color2 = [UIColor colorWithRed:0.193700 green:0.187400 blue:0.154700 alpha:1];
                break;
            case 20:
                color1 = [UIColor colorWithRed:0.140000 green:0.155800 blue:0.200000 alpha:1];
                color2 = [UIColor colorWithRed:0.061720 green:0.112400 blue:0.140800 alpha:1];
                break;
            case 21:
                color1 = [UIColor colorWithRed:0.141200 green:0.145100 blue:0.152900 alpha:1];
                color2 = [UIColor colorWithRed:0.172500 green:0.176500 blue:0.141200 alpha:1];
                break;
            case 22:
                color1 = [UIColor colorWithRed:0.253800 green:0.267900 blue:0.288600 alpha:1];
                color2 = [UIColor colorWithRed:0.182100 green:0.181500 blue:0.177700 alpha:1];
                break;
            case 23:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 24:
                color1 = [UIColor colorWithRed:0.071530 green:0.076640 blue:0.102200 alpha:1];
                color2 = [UIColor colorWithRed:0.226700 green:0.239400 blue:0.266700 alpha:1];
                break;
            case 25:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 26:
                color1 = [UIColor colorWithRed:0.211500 green:0.227300 blue:0.235800 alpha:1];
                color2 = [UIColor colorWithRed:0.100300 green:0.109800 blue:0.119100 alpha:1];
                break;
            case 27:
                color1 = [UIColor colorWithRed:0.087390 green:0.143200 blue:0.173400 alpha:1];
                color2 = [UIColor colorWithRed:0.252400 green:0.274000 blue:0.334700 alpha:1];
                break;
            case 28:
                color1 = [UIColor colorWithRed:0.087390 green:0.143200 blue:0.173400 alpha:1];
                color2 = [UIColor colorWithRed:0.252400 green:0.274000 blue:0.334700 alpha:1];
                break;
            case 29:
                color1 = [UIColor colorWithRed:0.013000 green:0.050050 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.188500 green:0.210200 blue:0.269300 alpha:1];
                break;
            case 30:
                color1 = [UIColor colorWithRed:0.013000 green:0.050050 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.188500 green:0.210200 blue:0.269300 alpha:1];
                break;
            case 31:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 32:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 33:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 34:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 35:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 36:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 37:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 38:
                color1 = [UIColor colorWithRed:0.071530 green:0.076640 blue:0.102200 alpha:1];
                color2 = [UIColor colorWithRed:0.226700 green:0.239400 blue:0.266700 alpha:1];
                break;
            case 39:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 40:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 41:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 42:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 43:
                color1 = [UIColor colorWithRed:0.023530 green:0.023530 blue:0.054900 alpha:1];
                color2 = [UIColor colorWithRed:0.192200 green:0.215700 blue:0.266700 alpha:1];
                break;
            case 44:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 45:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            case 46:
                color1 = [UIColor colorWithRed:0.000000 green:0.021670 blue:0.130000 alpha:1];
                color2 = [UIColor colorWithRed:0.192500 green:0.231900 blue:0.350000 alpha:1];
                break;
            default:
                break;
        }
    }
    
    if (!color1 || !color2) {
        // ABORT!
        layer.colors = @[(id)[UIColor blackColor].CGColor];
    } else {
        layer.colors = @[(id)color2.CGColor, (id)color1.CGColor];
    }
    
    return layer;
}
@end