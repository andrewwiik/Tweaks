//
//  IBKWeatherLayerFactory.h
//  Weather
//
//  Created by Matt Clarke on 24/03/2015.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface IBKWeatherLayerFactory : NSObject

@property(strong, nonatomic) NSBundle *weatherFrameworkBundle;

+(instancetype)sharedInstance;
-(id)layerForCondition:(int)arg1 isDay:(_Bool)arg2 withLargestSizePossible:(BOOL)largest;
-(CALayer*)colourBackingLayerForCondition:(int)condition isDay:(BOOL)isDay;
-(NSString*)nameForCondition:(int)condition;
-(UIImage*)iconForCondition:(int)condition isDay:(BOOL)isDay wantsLargerIcons:(BOOL)larger;

@end
