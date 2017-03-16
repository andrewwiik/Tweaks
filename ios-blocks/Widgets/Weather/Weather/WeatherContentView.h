//
//  WeatherContentView.h
//  Weather
//
//  Created by Matt Clarke on 23/03/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Weather/Weather.h>
#import "IBKLabel.h"
#import "IBKMarqueeLabel.h"

@interface WeatherContentView : UIView <UIScrollViewDelegate> {
    IBKLabel *degreeSymbol;
}

@property (nonatomic, strong) UIView *animatedView;
@property (nonatomic, strong) CALayer *conditionLayer;
@property (nonatomic, strong) CALayer *gradientLayer;
@property (nonatomic, strong) IBKMarqueeLabel *cityName;
@property (nonatomic, strong) IBKMarqueeLabel *weatherDetail;
@property (nonatomic, strong) IBKLabel *temperature;
@property (nonatomic, strong) UIImageView *conditionImage;

@property (nonatomic, strong) UIView *currentWeatherView;
@property (nonatomic, strong) UIView *fiveDayView;
@property (nonatomic, strong) UIScrollView *scroll;

-(void)updateForCity:(City*)city;

@end