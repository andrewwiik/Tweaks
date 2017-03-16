//
//  WeatherContentView.m
//  Weather
//
//  Created by Matt Clarke on 23/03/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import "IBKWeatherLayerFactory.h"
#import "WeatherContentView.h"
#import "IBKWeatherFiveView.h"
#import "IBKWeatherResources.h"
#import <objc/runtime.h>

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))

@interface City (iOS7)
@property (assign,nonatomic) unsigned conditionCode;
@property (assign,nonatomic) BOOL isRequestedByFrameworkClient;

+(id)descriptionForWeatherUpdateDetail:(unsigned)arg1;
- (id)naturalLanguageDescription;

@end

@interface IBKAPI
+(CGFloat)heightForContentView;
@end

@implementation WeatherContentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Custom initialisation
        self.gradientLayer = [[IBKWeatherLayerFactory sharedInstance] colourBackingLayerForCondition:0 isDay:YES];
        self.gradientLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.gradientLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        [self.layer addSublayer:self.gradientLayer];
        
        self.conditionLayer = [[IBKWeatherLayerFactory sharedInstance] layerForCondition:0 isDay:YES withLargestSizePossible:NO];
        self.conditionLayer.opacity = 1.0;
        self.conditionLayer.hidden = NO;
        self.conditionLayer.geometryFlipped = YES;
        
        self.animatedView = [[UIView alloc] initWithFrame:self.conditionLayer.frame];
        self.animatedView.backgroundColor = [UIColor clearColor];
        
        [self.animatedView.layer addSublayer:self.conditionLayer];
        
        self.animatedView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.animatedView.frame = CGRectMake(0, 0, self.animatedView.frame.size.width, self.animatedView.frame.size.height);
        
        [self addSubview:self.animatedView];
        
        self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if ([IBKWeatherResources showFiveDayForecast])
            self.scroll.contentSize = CGSizeMake(frame.size.width*2, frame.size.height);
        self.scroll.backgroundColor = [UIColor clearColor];
        self.scroll.contentOffset = CGPointZero;
        self.scroll.delaysContentTouches = NO;
        self.scroll.showsHorizontalScrollIndicator = NO;
        self.scroll.showsVerticalScrollIndicator = NO;
        self.scroll.pagingEnabled = YES;
        self.scroll.alwaysBounceHorizontal = YES;
        self.scroll.clipsToBounds = NO;
        self.scroll.scrollsToTop = NO;
        self.scroll.delegate = self;
        self.scroll.canCancelContentTouches = YES;
        
        [self addSubview:self.scroll];
        
        self.currentWeatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.currentWeatherView.backgroundColor = [UIColor clearColor];
        [self.scroll addSubview:self.currentWeatherView];
        
        // Data display
        
        self.cityName = [[IBKMarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 40, 20) duration:4 andFadeLength:10 alsoIBKSizing:kIBKLabelSizingLarge];
        self.cityName.text = @"Location";
        if ([IBKWeatherResources centeredMainUI])
            self.cityName.textAlignment = NSTextAlignmentCenter;
        else
            self.cityName.textAlignment = NSTextAlignmentLeft;
        self.cityName.textColor = [UIColor whiteColor];
        self.cityName.backgroundColor = [UIColor clearColor];
        self.cityName.marqueeType = MLContinuous;
        self.cityName.trailingBuffer = 30;
        //self.cityName.layer.masksToBounds = NO;
        
        //[self.cityName setLabelSize:kIBKLabelSizingLarge];
        
        [self.currentWeatherView addSubview:self.cityName];
        
        self.weatherDetail = [[IBKMarqueeLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-40, 16) duration:4 andFadeLength:10 alsoIBKSizing:kIBKLabelSizingSmall];
        self.weatherDetail.text = @"Condition";
        if ([IBKWeatherResources centeredMainUI])
            self.weatherDetail.textAlignment = NSTextAlignmentCenter;
        else
            self.weatherDetail.textAlignment = NSTextAlignmentLeft;
        self.weatherDetail.textColor = [UIColor whiteColor];
        self.weatherDetail.backgroundColor = [UIColor clearColor];
        
        //[self.weatherDetail setLabelSize:kIBKLabelSizingSmall];
        
        [self.currentWeatherView addSubview:self.weatherDetail];
        
        self.temperature = [[IBKLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-40, 30)];
        self.temperature.text = @"--";
        self.temperature.textAlignment = NSTextAlignmentLeft;
        self.temperature.textColor = [UIColor whiteColor];
        self.temperature.backgroundColor = [UIColor clearColor];
        
        [self.temperature setLabelSize:kIBKLabelSizingGiant];
        //self.temperature.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:75];
        
        [self.currentWeatherView addSubview:self.temperature];
        
        degreeSymbol = [[IBKLabel alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
        degreeSymbol.text = @"°";
        degreeSymbol.textAlignment = NSTextAlignmentLeft;
        degreeSymbol.textColor = [UIColor whiteColor];
        degreeSymbol.backgroundColor = [UIColor clearColor];
        [degreeSymbol setLabelSize:kIBKLabelSizingLarge];
        
        degreeSymbol.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
        
        [self.currentWeatherView addSubview:degreeSymbol];
        
        // Five day forecast
        
        self.fiveDayView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
        self.fiveDayView.backgroundColor = [UIColor clearColor];
        
        [self.scroll addSubview:self.fiveDayView];
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    /*
     * This method will be called every time your widget rotates.
     * Therefore, it is highly recommended to set your frames here
     * in relation to the size of this content view.
    */
    
    self.superview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    // Relayout colour area.
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.gradientLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer insertSublayer:self.gradientLayer below:self.animatedView.layer];
    
    [self addSubview:self.scroll];
    
    /*[self addSubview:self.animatedView];
    [self addSubview:self.cityName];
    [self addSubview:self.weatherDetail];
    [self addSubview:self.temperature];
    [self addSubview:degreeSymbol];*/
    
    self.scroll.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if ([IBKWeatherResources showFiveDayForecast])
        self.scroll.contentSize = CGSizeMake(self.frame.size.width*2, self.frame.size.height);
    
    if (self.scroll.contentOffset.x != 0) {
        self.scroll.contentOffset = CGPointMake(self.frame.size.width, 0);
    }
    
    self.currentWeatherView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    //[self.cityName sizeToFit];
    if ([IBKWeatherResources centeredMainUI]) {
        self.cityName.frame = CGRectMake((self.frame.size.width/2) - (self.cityName.frame.size.width/2), self.frame.size.height*0.125, self.cityName.frame.size.width, self.cityName.frame.size.height);
    } else {
        self.cityName.frame = CGRectMake(10, self.frame.size.height*0.125, self.cityName.frame.size.width, self.cityName.frame.size.height);
    }
    
    //[self.weatherDetail sizeToFit];
    if ([IBKWeatherResources centeredMainUI]) {
        self.weatherDetail.frame = CGRectMake((self.frame.size.width/2) - (self.weatherDetail.frame.size.width/2), self.cityName.frame.origin.y + self.cityName.frame.size.height + 2, self.weatherDetail.frame.size.width, self.weatherDetail.frame.size.height);
    } else {
        self.weatherDetail.frame = CGRectMake(10, self.cityName.frame.origin.y + self.cityName.frame.size.height + 2, self.weatherDetail.frame.size.width, self.weatherDetail.frame.size.height);
    }
    
    [degreeSymbol sizeToFit];
    [self.temperature sizeToFit];
    if ([IBKWeatherResources centeredMainUI]) {
        CGFloat widthPlusDegree = self.temperature.frame.size.width;
        self.temperature.frame = CGRectMake((self.frame.size.width/2) - (widthPlusDegree/2), self.weatherDetail.frame.origin.y + self.weatherDetail.frame.size.height + 3, self.temperature.frame.size.width, self.temperature.frame.size.height);
    } else {
        self.temperature.frame = CGRectMake(10, self.weatherDetail.frame.origin.y + self.weatherDetail.frame.size.height + 3, self.temperature.frame.size.width, self.temperature.frame.size.height);
    }
    
    degreeSymbol.frame = CGRectMake(self.temperature.frame.origin.x + self.temperature.frame.size.width + 2, self.temperature.frame.origin.y + 5, degreeSymbol.frame.size.width, degreeSymbol.frame.size.height);
    
    // Forecasts.
    
    self.fiveDayView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    
    int current = 0;
    CGFloat height = [objc_getClass("IBKAPI") heightForContentView] / 5;
    
    for (UIView *subview in self.fiveDayView.subviews) {
        subview.frame = CGRectMake(0, (current * height) + 2, self.frame.size.width, height);
        current++;
    }
}

-(void)generateNewFiveDayForecast:(City*)city {
    NSArray *forecasts = [city dayForecasts];
    
    int current = 0;
    CGFloat height = [objc_getClass("IBKAPI") heightForContentView] / 5;
    
    if (forecasts.count == 0) {
        // No forecasts! :(
        return;
    }
    
    for (UIView *subview in self.fiveDayView.subviews) {
        [subview removeFromSuperview];
    }
    
    BOOL missFirst = YES;
    
    for (DayForecast *forecast in forecasts) {
        if (current >= 5) {
            break;
        }
        
        if (missFirst) {
            missFirst = NO;
            continue;
        }
        
        // Get day name, condition, high and low.
        int hightemp;
        if ([[WeatherPreferences sharedPreferences] isCelsius])
            hightemp = [forecast.high intValue];
        else
            hightemp = (([forecast.high intValue]*9)/5) + 32;
        
        int lowtemp;
        if ([[WeatherPreferences sharedPreferences] isCelsius])
            lowtemp = [forecast.low intValue];
        else
            lowtemp = (([forecast.low intValue]*9)/5) + 32;
        
        NSBundle *strings = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Weather.framework"];
        NSString *dayString;
        switch (forecast.dayOfWeek) {
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
        
        IBKWeatherFiveView *view = [[IBKWeatherFiveView alloc] initWithFrame:CGRectMake(0, (current * height) + 2, self.frame.size.width, height) day:dayString condition:forecast.icon high:[NSString stringWithFormat:@"%d", hightemp] low:[NSString stringWithFormat:@"%d", lowtemp]];
        [self.fiveDayView addSubview:view];
        
        current++;
    }
}

-(void)updateForCity:(City *)city {
    [self.gradientLayer removeFromSuperlayer];
    [self.conditionLayer removeFromSuperlayer];
    
    self.gradientLayer = nil;
    self.conditionLayer = nil;
    
    self.gradientLayer = [[IBKWeatherLayerFactory sharedInstance] colourBackingLayerForCondition:(int)city.conditionCode isDay:city.isDay];
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.gradientLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self.layer insertSublayer:self.gradientLayer below:self.animatedView.layer];
    
    self.conditionLayer = [[IBKWeatherLayerFactory sharedInstance] layerForCondition:(int)city.conditionCode isDay:city.isDay withLargestSizePossible:NO];
    self.conditionLayer.opacity = 1.0;
    self.conditionLayer.hidden = NO;
    self.conditionLayer.geometryFlipped = YES;
    
    self.animatedView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [self.animatedView.layer addSublayer:self.conditionLayer];
    
    self.animatedView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.animatedView.frame = CGRectMake(0, 0, self.animatedView.frame.size.width, self.animatedView.frame.size.height);
    
    /*[self addSubview:self.animatedView];
    [self addSubview:self.cityName];
    [self addSubview:self.weatherDetail];
    [self addSubview:self.temperature];
    [self addSubview:degreeSymbol];*/
    
    [self addSubview:self.scroll];
    
    int temp;
    if ([[WeatherPreferences sharedPreferences] isCelsius])
        temp = [city.temperature intValue];
    else
        temp = (([city.temperature intValue]*9)/5) + 32;
    
    // Now handle displayed data.
    self.cityName.text = city.name;
    self.weatherDetail.text = [[IBKWeatherLayerFactory sharedInstance] nameForCondition:(int)city.conditionCode];
    self.temperature.text = [NSString stringWithFormat:@"%d", temp];
    
    [self generateNewFiveDayForecast:city];
}

// UIScrollView delegate.

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpha = 1.0 - (scrollView.contentOffset.x / scrollView.contentSize.width);
    self.animatedView.alpha = alpha;
}

-(void)dealloc {
    [self.conditionLayer removeFromSuperlayer];
    self.conditionLayer = nil;
    
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = nil;
    
    [self.animatedView removeFromSuperview];
    self.animatedView = nil;
    
    [self.cityName removeFromSuperview];
    self.cityName = nil;
    
    [self.weatherDetail removeFromSuperview];
    self.weatherDetail = nil;
    
    [self.temperature removeFromSuperview];
    self.temperature = nil;
    
    [degreeSymbol removeFromSuperview];
    degreeSymbol = nil;
    
    [self.currentWeatherView removeFromSuperview];
    self.currentWeatherView = nil;
    
    [self.scroll removeFromSuperview];
    self.scroll = nil;
}

@end