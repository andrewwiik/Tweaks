//    ALEWeatherUtility.h
//    The Weather Utility Header
//    Created by Andrew Wiik <andrew.wiik@vtsd.com> 04/06/2016
//    © Creatix <ioscreatix@gmail.com>. All rights reserved.
//
//
//

#import <Weather/WeatherIconsUtility.h>
#import <Weather/WeatherImageLoader.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ImageUtils.h"

@interface ALEWeatherUtility : NSObject
+ (NSString *)celsiusToFahrenheit:(NSString *)celsius withDegree:(BOOL)withDegree;
+ (UIImage *)imageForConditionCode:(int)conditionCode;
+ (NSString *)localizedDayOfWeekShort:(int)dayNumber;
+ (NSString *)localizedConditionDescriptionForConditionCode:(int)conditionCode;
+ (NSString *)localizedShortTime:(NSString *)time;
+ (NSString *)temperatureForHigh:(NSString *)high andLow:(NSString *)low celsius:(BOOL)celsius withDegree:(BOOL)withDegree;
+ (NSBundle *)weatherBundle;
+(CALayer*)colourBackingLayerForCondition:(int)condition isDay:(BOOL)isDay;
@end