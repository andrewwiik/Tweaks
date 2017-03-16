#import "WATodayModel.h"
#import "SynchronizedDefaultsDelegate-Protocol.h"
#import "WeatherPreferences.h"
#import <WeatherFoundation/WFGeocodeRequest.h>


@interface WATodayAutoupdatingLocationModel : WATodayModel <CLLocationManagerDelegate, SynchronizedDefaultsDelegate> {

	BOOL _isLocationTrackingEnabled;
	BOOL _locationServicesActive;
	WFGeocodeRequest* _geocodeRequest;
	NSUInteger _citySource;
	WeatherPreferences* _preferences;
	/*^block*/id _WeatherLocationManagerGenerator;

}

@property (nonatomic,retain) WFGeocodeRequest * geocodeRequest;                     //@synthesize geocodeRequest=_geocodeRequest - In the implementation block
@property (assign,nonatomic) BOOL isLocationTrackingEnabled;                        //@synthesize isLocationTrackingEnabled=_isLocationTrackingEnabled - In the implementation block
@property (assign,nonatomic) NSUInteger citySource;                         //@synthesize citySource=_citySource - In the implementation block             //@synthesize locationManager=_locationManager - In the implementation block
@property (nonatomic,retain) WeatherPreferences * preferences;                      //@synthesize preferences=_preferences - In the implementation block
@property (nonatomic,copy) id WeatherLocationManagerGenerator;                      //@synthesize WeatherLocationManagerGenerator=_WeatherLocationManagerGenerator - In the implementation block
@property (assign,nonatomic) BOOL locationServicesActive;                           //@synthesize locationServicesActive=_locationServicesActive - In the implementation block
-(id)init;
-(void)dealloc;
-(void)setPreferences:(WeatherPreferences *)arg1 ;
-(WeatherPreferences *)preferences;
-(void)locationManager:(id)arg1 didChangeAuthorizationStatus:(int)arg2 ;
-(void)locationManager:(id)arg1 didUpdateLocations:(id)arg2 ;
-(id)initWithPreferences:(id)arg1 effectiveBundleIdentifier:(id)arg2 ;
-(void)setLocationServicesActive:(BOOL)arg1 ;
-(void)_executeLocationUpdateWithCompletion:(/*^block*/id)arg1 ;
-(id)forecastModel;
-(void)_willDeliverForecastModel:(id)arg1 ;
-(void)_persistStateWithModel:(id)arg1 ;
-(void)setWeatherLocationManagerGenerator:(id)arg1 ;
-(void)setCitySource:(NSUInteger)arg1 fireNotification:(BOOL)arg2 ;
-(void)_weatherPreferencesWereSynchronized:(id)arg1 ;
-(void)_teardownLocationManager;
-(BOOL)_reloadForecastData:(BOOL)arg1 ;
-(void)_kickstartLocationManager;
-(void)setIsLocationTrackingEnabled:(BOOL)arg1 ;
-(void)setCitySource:(NSUInteger)arg1 ;
-(id)WeatherLocationManagerGenerator;
-(NSUInteger)citySource;
-(void)_executeLocationUpdateForLocalWeatherCityWithCompletion:(/*^block*/id)arg1 ;
-(void)_executeLocationUpdateForFirstWeatherCityWithCompletion:(/*^block*/id)arg1 ;
-(WFGeocodeRequest *)geocodeRequest;
-(void)setGeocodeRequest:(WFGeocodeRequest *)arg1 ;
-(void)ubiquitousDefaultsDidChange:(id)arg1 ;
-(BOOL)isLocationTrackingEnabled;
-(BOOL)locationServicesActive;
@end
