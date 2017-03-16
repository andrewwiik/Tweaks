//
//  IBKWeatherResources.h
//  Weather
//
//  Created by Matt Clarke on 31/03/2015.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IBKWeatherResources : NSObject

+(BOOL)centeredMainUI;
+(BOOL)showFiveDayForecast;

+(UIImage*)iconForCondition:(int)condition isDay:(BOOL)isDay;

+(void)reloadSettings;

@end
