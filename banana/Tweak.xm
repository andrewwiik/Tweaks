#import "headers.h"
#import "BNHourlyView.h"

%hook SBApplicationShortcutMenuContentView
%property (nonatomic, retain) UIView *hourlyWeatherView;
%property (nonatomic, retain) UIView *weatherDivider;
%property (nonatomic, retain) UILabel *cityLabel;
%property (nonatomic, retain) UILabel *conditionLabel;
%property (nonatomic, retain) UILabel *lowTempLabel;
%property (nonatomic, retain) UILabel *highTempLabel;
%property (nonatomic, retain) UILabel *bigTempLabel;
%property (nonatomic, retain) NSMutableArray *hourlyViews;
%new
- (void)clearMenuBN {
    UIView *rowContainer = MSHookIvar<UIView*>(self,"_rowContainer");
    UIView *dividerContainer = MSHookIvar<UIView*>(self,"_dividerContainer");
    rowContainer.hidden = YES;
    dividerContainer.hidden = YES;
}

%new
- (void)showWeather {
	[self clearMenuBN];
	[self highlightGesture].enabled = NO;
	self.hourlyWeatherView = [[UIView alloc] init];
	self.hourlyWeatherView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.hourlyWeatherView];

	self.hourlyWeatherView.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);

	//[self addConstraint:[NSLayoutConstraint constraintWithItem:hourlyWeatherView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
	 [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hourlyWeatherView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	// NSLog(@"Bottom Layout is Set");
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.hourlyWeatherView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	// NSLog(@"Left Layout is Set");
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.hourlyWeatherView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-10]];
	// NSLog(@"Right Layout is Set");
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.hourlyWeatherView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
	NSLog(@"Top Layout is Set");
	City *localCity = [[NSClassFromString(@"WeatherPreferences") sharedPreferences] localWeatherCity];
	NSLog(@"%@", localCity);
	[localCity update];
	self.hourlyViews = [NSMutableArray new];
	for (int x = 0; x < 4; x++) {
		HourlyForecast *forecast = [[localCity hourlyForecasts] objectAtIndex:x];
		BNHourlyView *hourlyView = [[BNHourlyView alloc] initWithTime:[forecast time] conditionCode:[forecast conditionCode] tempature:[forecast detail]];
		hourlyView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.hourlyWeatherView addSubview:hourlyView];
		NSLog(@"Hourly Forecast View %@", hourlyView);
		if (x == 0) {
		NSLog(@"Bottom");
		[self.hourlyWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.hourlyWeatherView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
		NSLog(@"Left");
		[self.hourlyWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.hourlyWeatherView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
		NSLog(@"Width");
		[self.hourlyWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.hourlyWeatherView attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0]];
		NSLog(@"Top");
		[self.hourlyWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hourlyWeatherView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
		}
		else {
			BNHourlyView *previousHourlyView = (BNHourlyView *)[self.hourlyViews objectAtIndex:x-1];
			[self.hourlyWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.hourlyWeatherView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
			[self.hourlyWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousHourlyView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
			[self.hourlyWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.hourlyWeatherView attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0]];
			[self.hourlyWeatherView addConstraint:[NSLayoutConstraint constraintWithItem:hourlyView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hourlyWeatherView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
		}
		[self.hourlyViews addObject:hourlyView];
	}

	/* Divider */
	self.weatherDivider = [[UIView alloc] init];
	self.weatherDivider.translatesAutoresizingMaskIntoConstraints = NO;
	//self.weatherDivider.frame = CGRectMake(0, self.frame.size.height/2, self.frame.size.width+100, 0.5);
	[self addSubview:self.weatherDivider];
	[self.weatherDivider setBackgroundColor:[UIColor blackColor]];
	[self.weatherDivider setAlpha:0.25];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.weatherDivider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-0.5]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.weatherDivider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.weatherDivider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.weatherDivider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];

	NSString *currentConditionName = [[[localCity naturalLanguageDescription] componentsSeparatedByString:@" "] objectAtIndex:0];

	self.cityLabel = [[UILabel alloc] init];
	self.cityLabel.font = [UIFont fontWithName:@".SFUIText-Regular" size:26];
	self.cityLabel.text = [localCity name];
	self.cityLabel.textColor = [UIColor blackColor];
	self.cityLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.cityLabel];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.cityLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:15]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.cityLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:15]];

	self.conditionLabel = [[UILabel alloc] init];
	self.conditionLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:13];
	self.conditionLabel.text = currentConditionName;
	self.conditionLabel.textColor = [UIColor blackColor];
	self.conditionLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.conditionLabel];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:15]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.conditionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cityLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

	DayForecast *currentForecast = [(DayForecast *)[[localCity dayForecasts] objectAtIndex:0] high];
	double lowTempValue = [[currentForecast low] intValue]*1.8+32;
	NSString *lowTempature = [NSString stringWithFormat:@"%d", (int)lowTempValue];
	double highTempValue = [[currentForecast high] intValue]*1.8+32;
	NSString *highTempature = [NSString stringWithFormat:@"%d", (int)highTempValue];

	self.highTempLabel = [[UILabel alloc] init];
	self.highTempLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:13];
	self.highTempLabel.text = highTempature;
	self.highTempLabel.textColor = [UIColor blackColor];
	self.highTempLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.highTempLabel];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.highTempLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:15]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.highTempLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-15]];

	self.lowTempLabel = [[UILabel alloc] init];
	self.lowTempLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:13];
	self.lowTempLabel.text = lowTempature;
	self.lowTempLabel.textColor = [UIColor blackColor];
	[self.lowTempLabel setAlpha:0.5];
	self.lowTempLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.lowTempLabel];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.lowTempLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.highTempLabel attribute:NSLayoutAttributeRight multiplier:1 constant:10]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.lowTempLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-15]];

	self.bigTempLabel = [[UILabel alloc] init];
	double bigTempValue = [[localCity temperature] intValue]*1.8+32;
	NSString *bigTemp =  [NSString stringWithFormat:@"%dO", (int)bigTempValue];

	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:bigTemp
                                                                                         attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 58 weight:UIFontWeightUltraLight]}];
    [attributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize: 13 weight:UIFontWeightUltraLight],NSBaselineOffsetAttributeName : @32} range:NSMakeRange([bigTemp length]-1, 1)];

    self.bigTempLabel.attributedText = attributedString;

	//self.bigTempLabel.font = [UIFont systemFontOfSize:54 weight:UIFontWeightThin];
	//self.bigTempLabel.text = lowTempature;
	self.bigTempLabel.textColor = [UIColor blackColor];
	[self.bigTempLabel setAlpha:1];
	self.bigTempLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.bigTempLabel];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.bigTempLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-15]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.bigTempLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-10]];
}
- (void)_populateRowsWithShortcutItems:(id)arg1 application:(SBApplication *)arg2 {
   if ([[arg2 bundleIdentifier] isEqualToString: @"com.apple.weather"]) {
   	%orig;
      [self showWeather];
   }
   else %orig;
}
%new
- (UILongPressGestureRecognizer *)highlightGesture {
	return MSHookIvar<id>(self,"_pressGestureRecognizer");//disables longpresgesture so our gesturs can be used
}
%end

%hook SBApplicationShortcutStoreManager
- (id)shortcutItemsForBundleIdentifier:(id)identifier {
   if ([identifier isEqualToString:@"com.apple.weather"]) {
      UIApplicationShortcutItem *respring = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple" localizedTitle:@" "];
      UIApplicationShortcutItem *reboot = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple" localizedTitle:@" "];
      UIApplicationShortcutItem *power = [[%c(UIApplicationShortcutItem) alloc]initWithType:@"com.apple" localizedTitle:@" "];
      return [NSMutableArray arrayWithObjects:respring, reboot, power, nil];
   }
   else return %orig;
}
%end
