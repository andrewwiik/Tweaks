//    ALEWeatherHourlyForecastViewCell.h
//    Weather Hourly Forecast View Cell Header
//    Created by Andrew Wiik <andrew.wiik@vtsd.com> 04/06/2016
//    © Creatix <ioscreatix@gmail.com>. All rights reserved.
//
//
//

#import <Weather/HourlyForecast.h>
#import "ALEWeatherUtility.h"

@class HourlyForecast;

@interface ALEWeatherHourlyForecastViewCell : UIView {
	HourlyForecast *_forecast;
	BOOL _celsius;
}

@property (nonatomic, strong) UIImageView *conditionIconView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;

- (id)initWithForecast:(HourlyForecast *)forecast celsius:(BOOL)celsius;

@end
