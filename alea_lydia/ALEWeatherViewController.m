//
//
//    ALEWeatherViewController.m
//    The Weather Shortcut View
//    Created by Andrew Wiik <andrew.wiik@vtsd.com> 04/06/2016
//    © Creatix <ioscreatix@gmail.com>. All rights reserved.
//
//
//

#import "ALEWeatherViewController.h"
#import "ALEWeatherUtility.h"
#import "ALEWeatherHourlyForecastViewCell.h"
#import "ALEWeatherDailyForecastViewCell.h"

@implementation ALEWeatherViewController

- (id)initWithCity:(City *)city viewType:(ALEWeatherViewType)viewType celsius:(BOOL)celsius {

	if(self = [super init]) {
		_city = city;
		_viewType = viewType;
		_celsius = celsius;
	}
	return self;
}

- (void)viewDidLoad {

	[super viewDidLoad];

	[self setupBaseViews];
	[self setupCurrentWeatherView];
	[self setupForecastView];

}
- (void)loadView {
	UIView *view = [[UIView alloc] init];
   	self.view = view;
}
- (void)setupBaseViews {

	_forecastViewCells = [NSMutableArray new];

	/* Start Container View Setup */

	_containerView = [[UIView alloc] init];
	_containerView.backgroundColor = [UIColor clearColor];
	_containerView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_containerView];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:15]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-15]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:15]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-15]];

	/* End Container View Setup */

	/* Start Vibrancy View Setup */

	UIBlurEffect *vibrancyBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
	_vibrancyView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:vibrancyBlurEffect]];
	_vibrancyView.translatesAutoresizingMaskIntoConstraints = NO;
	_vibrancyView.contentView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:_vibrancyView];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

	[_vibrancyView addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_vibrancyView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[_vibrancyView addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_vibrancyView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[_vibrancyView addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_vibrancyView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[_vibrancyView addConstraint:[NSLayoutConstraint constraintWithItem:_vibrancyView.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_vibrancyView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

	/* End Vibrancy View Setup */

	/* Start Divider View Setup */

	_dividerView = [[UIView alloc] init];
	_dividerView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.080];
	_dividerView.translatesAutoresizingMaskIntoConstraints = NO;
	[_vibrancyView.contentView addSubview:_dividerView];

	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_dividerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:0.6 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_dividerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_dividerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_dividerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

	/* End Divider View Setup */

	/* Start Current Weather Information View Base Setup */

	_currentWeatherView = [[UIView alloc] init];
	_currentWeatherView.backgroundColor = [UIColor clearColor];
	_currentWeatherView.translatesAutoresizingMaskIntoConstraints = NO;
	[_containerView addSubview:_currentWeatherView];

	[_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_currentWeatherView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_currentWeatherView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeHeight multiplier:0.6 constant:-0.5]];
	[_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_currentWeatherView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_currentWeatherView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

	/* End Current Weather Information View Base Setup */

	/* Start Forecast View Setup Setup */

	_forecastView = [[UIView alloc] init];
	_forecastView.backgroundColor = [UIColor clearColor];
	_forecastView.translatesAutoresizingMaskIntoConstraints = NO;
	[_containerView addSubview:_forecastView];

	[_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_forecastView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_currentWeatherView attribute:NSLayoutAttributeBottom multiplier:1 constant:15]];
	[_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_forecastView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_forecastView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[_containerView addConstraint:[NSLayoutConstraint constraintWithItem:_forecastView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];

	/* End Forecast View Setup */
	

}

- (void)setupCurrentWeatherView {

	/* Start City Label Setup */

	_cityLabel = [[UILabel alloc] init];
	_cityLabel.font = [UIFont fontWithName:@".SFUIText-Regular" size:26];
	_cityLabel.text = [_city name];
	_cityLabel.textColor = [UIColor blackColor];
	_cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_currentWeatherView addSubview:_cityLabel];

	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_cityLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_currentWeatherView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_cityLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_currentWeatherView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

	/* End City Label Setup */

	/* Start Current Condition Label Setup */

	_currentConditionLabel = [[UILabel alloc] init];
	_currentConditionLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:13];
	_currentConditionLabel.text = [ALEWeatherUtility localizedConditionDescriptionForConditionCode:_city.conditionCode];
	_currentConditionLabel.textColor = [UIColor blackColor];
	_currentConditionLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_currentWeatherView addSubview:_currentConditionLabel];

	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_currentConditionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_currentWeatherView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_currentConditionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_cityLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

	/* End Current Condition Label Setup */

	/* Start High Temperature Label Setup */

	_highTemperatureLabel = [[UILabel alloc] init];
	_highTemperatureLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:13];
	_highTemperatureLabel.text = _celsius ? [(DayForecast *)[[_city dayForecasts] objectAtIndex:0] high] : [ALEWeatherUtility celsiusToFahrenheit:[(DayForecast *)[[_city dayForecasts] objectAtIndex:0] high] withDegree:NO];
	_highTemperatureLabel.textColor = [UIColor blackColor];
	_highTemperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_currentWeatherView addSubview:_highTemperatureLabel];

	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_highTemperatureLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_currentWeatherView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_highTemperatureLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_currentConditionLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

	/* End High Temperature Label Setup */

	/* Start Low Temperature Label Setup */

	_lowTemperatureLabel = [[UILabel alloc] init];
	_lowTemperatureLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:13];
	_lowTemperatureLabel.text = _celsius ? [(DayForecast *)[[_city dayForecasts] objectAtIndex:0] low] : [ALEWeatherUtility celsiusToFahrenheit:[(DayForecast *)[[_city dayForecasts] objectAtIndex:0] low] withDegree:NO];
	_lowTemperatureLabel.textColor = [UIColor blackColor];
	_lowTemperatureLabel.alpha = 0.5;
	_lowTemperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_currentWeatherView addSubview:_lowTemperatureLabel];

	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_lowTemperatureLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_highTemperatureLabel attribute:NSLayoutAttributeRight multiplier:1 constant:10]];
	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_lowTemperatureLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_highTemperatureLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

	/* End Low Temperature Label Setup */

	/* Start Big Temperature Label Setup */

	_bigTemperatureLabel = [[UILabel alloc] init];
	NSString *bigTemperatureLabelText = _celsius ? [NSString stringWithFormat:@"%@O",[_city temperature]] : [ALEWeatherUtility celsiusToFahrenheit:[_city temperature] withDegree:YES];
	NSMutableAttributedString *bigTemperatureLabelTextString = [[NSMutableAttributedString alloc] initWithString:bigTemperatureLabelText
                                                                                         attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 58 weight:UIFontWeightUltraLight]}];
    [bigTemperatureLabelTextString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize: 13 weight:UIFontWeightUltraLight],NSBaselineOffsetAttributeName : @32} range:NSMakeRange([bigTemperatureLabelText length]-1, 1)];
    _bigTemperatureLabel.attributedText = bigTemperatureLabelTextString;
	_bigTemperatureLabel.textColor = [UIColor blackColor];
	_bigTemperatureLabel.alpha = 1;
	_bigTemperatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_currentWeatherView addSubview:_bigTemperatureLabel];
	[_bigTemperatureLabel sizeToFit];

	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_bigTemperatureLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_currentWeatherView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_bigTemperatureLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_currentWeatherView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

	/* End Big Temperature Label Setup */
	
	/* Start Current Codition Description Label Setup */
	
	_currentConditionDescriptionLabel = [[UILabel alloc] init];
	_currentConditionDescriptionLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:13];
	_currentConditionDescriptionLabel.text = [NSString stringWithFormat:@"Today: %@",[_city naturalLanguageDescription]];
	_currentConditionDescriptionLabel.textColor = [UIColor blackColor];
	_currentConditionDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
	_currentConditionDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
	_currentConditionDescriptionLabel.numberOfLines = 0;
	[_currentWeatherView addSubview:_currentConditionDescriptionLabel];

	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_currentConditionDescriptionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_currentWeatherView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_currentConditionDescriptionLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_currentWeatherView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	//[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_currentConditionDescriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_highTemperatureLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[_currentWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:_currentConditionDescriptionLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_currentWeatherView attribute:NSLayoutAttributeBottom multiplier:1 constant:-13]];
	/* End Current Condition Description Label Setup */

}

- (void)setupForecastView {

	switch (_viewType) {
		case ALEWeatherViewTypeHourly:
			for (int x = 0; x < 5; x++) {

				HourlyForecast *forecast = [[_city hourlyForecasts] objectAtIndex:x];
				ALEWeatherHourlyForecastViewCell *hourlyView = [[ALEWeatherHourlyForecastViewCell alloc] initWithForecast:forecast celsius:_celsius];
				hourlyView.translatesAutoresizingMaskIntoConstraints = NO;
				[_forecastView addSubview:hourlyView];

				if (x == 0) {

				[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
				[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
				[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
				[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
				}

				else {

					ALEWeatherHourlyForecastViewCell *previousHourlyCell = (ALEWeatherHourlyForecastViewCell *)[_forecastViewCells objectAtIndex:x-1];
					[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
					[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousHourlyCell attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
					[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
					[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
				}

				[_forecastViewCells addObject:hourlyView];
			}

			break;
		case ALEWeatherViewTypeDaily:
			for (int x = 1; x < 6;  x++) {

				DayForecast *forecast = [[_city dayForecasts] objectAtIndex:x];
				ALEWeatherDailyForecastViewCell *dailyView = [[ALEWeatherDailyForecastViewCell alloc] initWithForecast:forecast celsius:_celsius];
				dailyView.translatesAutoresizingMaskIntoConstraints = NO;
				[_forecastView addSubview:dailyView];

				if (x == 1) {

				[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:dailyView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
				[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:dailyView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
				[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:dailyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
				[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:dailyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
				}

				else {

					ALEWeatherDailyForecastViewCell *previousDailyCell = (ALEWeatherDailyForecastViewCell *)[_forecastViewCells objectAtIndex:x-2];
					[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:dailyView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
					[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:dailyView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousDailyCell attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
					[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:dailyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
					[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:dailyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
				}

				[_forecastViewCells addObject:dailyView];
			}

			break;
		case ALEWeatherViewTypeDefault:
			for (int x = 0; x < 5; x++) {

				HourlyForecast *forecast = [[_city hourlyForecasts] objectAtIndex:x];
				ALEWeatherHourlyForecastViewCell *hourlyView = [[ALEWeatherHourlyForecastViewCell alloc] initWithForecast:forecast celsius:_celsius];
				hourlyView.translatesAutoresizingMaskIntoConstraints = NO;
				[_forecastView addSubview:hourlyView];

				if (x == 0) {

				[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
				[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
				[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
				[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
				}

				else {

					ALEWeatherHourlyForecastViewCell *previousHourlyCell = (ALEWeatherHourlyForecastViewCell *)[_forecastViewCells objectAtIndex:x-1];
					[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
					[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousHourlyCell attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
					[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
					[_forecastView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_forecastView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
				}

				[_forecastViewCells addObject:hourlyView];
			}

			break;
	}
}

@end