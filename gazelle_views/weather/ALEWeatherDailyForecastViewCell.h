//    ALEWeatherHourlyForecastViewCell.h
//    Weather Hourly Forecast View Cell Header
//    Created by Andrew Wiik <andrew.wiik@vtsd.com> 04/06/2016
//    © Creatix <ioscreatix@gmail.com>. All rights reserved.
//
//
//

#import <Weather/DayForecast.h>
#import "ALEWeatherUtility.h"

@class DayForecast;

@interface ALEWeatherDailyForecastViewCell : UIView {
	DayForecast *_forecast;
	BOOL _celsius;
}

@property (nonatomic, strong) UIImageView *conditionIconView;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;

- (id)initWithForecast:(DayForecast *)forecast celsius:(BOOL)celsius;

@end
