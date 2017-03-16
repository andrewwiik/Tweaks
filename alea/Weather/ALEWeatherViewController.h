//
//
//    ALEWeatherViewController.h
//    The Weather Shortcut View
//    Created by Andrew Wiik <andrew.wiik@vtsd.com> 04/06/2016
//    © Creatix <ioscreatix@gmail.com>. All rights reserved.
//
//
//

#import <UIKit/UIKit.h>
#import <Weather/City.h>
#import <Weather/DayForecast.h>
#import <UIKit/UIViewController.h>

@class City;

typedef enum {
    ALEWeatherViewTypeDefault,
    ALEWeatherViewTypeHourly,
    ALEWeatherViewTypeDaily
} ALEWeatherViewType;

@interface ALEWeatherViewController : UIViewController {
	ALEWeatherViewType _viewType;
	City *_city;
	BOOL _celsius;

}
@property (nonatomic, strong) UILabel *bigTemperatureLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *currentConditionLabel;
@property (nonatomic, strong) UIView *currentWeatherView;
@property (nonatomic, strong) UIView *dividerView;
@property (nonatomic, strong) UIView *forecastView;
@property (nonatomic, strong) NSMutableArray *forecastViewCells;
@property (nonatomic, strong) UILabel *highTemperatureLabel;
@property (nonatomic, strong) UILabel *lowTemperatureLabel;
@property (nonatomic, strong) UIVisualEffectView *vibrancyView;

- (id)initWithCity:(City *)city viewType:(ALEWeatherViewType)type celsius:(BOOL)celsius;
- (void)setupBaseViews;
- (void)setupCurrentWeatherView;
- (void)setupForecastView;

@end
