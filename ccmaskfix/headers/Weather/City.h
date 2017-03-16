#import <WeatherFoundation/WFTemperature.h>
#import <WeatherFoundation/WFLocation.h>

@interface City : NSObject {

	BOOL _isDay;
	BOOL _isLocalWeatherCity;
	BOOL _transient;
	BOOL _autoUpdate;
	BOOL _isUpdating;
	BOOL _isRequestedByFrameworkClient;
	BOOL _lockedForDemoMode;
	BOOL _updatingTimeZone;
	CGFloat _windChill;
	CGFloat _windDirection;
	CGFloat _windSpeed;
	CGFloat _humidity;
	CGFloat _visibility;
	CGFloat _pressure;
	CGFloat _dewPoint;
	CGFloat _heatIndex;
	NSInteger _conditionCode;
	NSArray* _dayForecasts;
	NSArray* _hourlyForecasts;
	NSString* _updateTimeString;
	NSString* _woeid;
	NSString* _name;
	NSString* _state;
	NSString* _ISO3166CountryAbbreviation;
	WFTemperature* _temperature;
	WFTemperature* _feelsLike;
	NSUInteger _observationTime;
	NSUInteger _sunsetTime;
	NSUInteger _sunriseTime;
	NSUInteger _moonPhase;
	NSUInteger _uvIndex;
	CGFloat _precipitationPast24Hours;
	NSURL* _link;
	NSURL* _deeplink;
	CLLocation* _location;
	NSTimeZone* _timeZone;
	NSDate* _timeZoneUpdateDate;
	NSError* _lastUpdateError;
	NSDate* _updateTime;
	NSUInteger _pressureRising;
	NSNumber* _airQualityIdx;
	NSNumber* _airQualityCategory;
	WFLocation* _wfLocation;
	NSUInteger _lastUpdateStatus;
	NSInteger _updateInterval;
	NSTimer* _autoUpdateTimer;
	NSHashTable* _cityUpdateObservers;
	NSString* _fullName;

}

@property (readonly) NSDictionary * urlComponents; 
@property (nonatomic,retain) WFLocation * wfLocation;                                      //@synthesize wfLocation=_wfLocation - In the implementation block
@property (nonatomic,retain) NSTimeZone * timeZone;                                        //@synthesize timeZone=_timeZone - In the implementation block
@property (nonatomic,retain) NSError * lastUpdateError;                                    //@synthesize lastUpdateError=_lastUpdateError - In the implementation block
@property (assign,nonatomic) NSUInteger lastUpdateStatus;                          //@synthesize lastUpdateStatus=_lastUpdateStatus - In the implementation block
@property (assign,nonatomic) BOOL isUpdating;                                              //@synthesize isUpdating=_isUpdating - In the implementation block
@property (assign,nonatomic) BOOL isRequestedByFrameworkClient;                            //@synthesize isRequestedByFrameworkClient=_isRequestedByFrameworkClient - In the implementation block
@property (assign,nonatomic) BOOL lockedForDemoMode;                                       //@synthesize lockedForDemoMode=_lockedForDemoMode - In the implementation block
@property (assign,nonatomic) NSInteger updateInterval;                                     //@synthesize updateInterval=_updateInterval - In the implementation block
@property (nonatomic,retain) NSTimer * autoUpdateTimer;                                    //@synthesize autoUpdateTimer=_autoUpdateTimer - In the implementation block
@property (assign,getter=isUpdatingTimeZone,nonatomic) BOOL updatingTimeZone;              //@synthesize updatingTimeZone=_updatingTimeZone - In the implementation block
@property (nonatomic,copy) NSString * updateTimeString;                                    //@synthesize updateTimeString=_updateTimeString - In the implementation block
@property (nonatomic,retain) NSHashTable * cityUpdateObservers;                            //@synthesize cityUpdateObservers=_cityUpdateObservers - In the implementation block
@property (nonatomic,readonly) BOOL timeZoneIsFresh; 
@property (nonatomic,copy) NSString * fullName;                                            //@synthesize fullName=_fullName - In the implementation block
@property (assign,nonatomic) BOOL isLocalWeatherCity;                                      //@synthesize isLocalWeatherCity=_isLocalWeatherCity - In the implementation block
@property (assign,getter=isTransient,nonatomic) BOOL transient;                            //@synthesize transient=_transient - In the implementation block
@property (nonatomic,copy) NSString * woeid;                                               //@synthesize woeid=_woeid - In the implementation block
@property (nonatomic,copy) NSString * name;                                                //@synthesize name=_name - In the implementation block
@property (nonatomic,readonly) NSString * locationID; 
@property (nonatomic,copy) NSString * state;                                               //@synthesize state=_state - In the implementation block
@property (nonatomic,copy) NSString * ISO3166CountryAbbreviation;                          //@synthesize ISO3166CountryAbbreviation=_ISO3166CountryAbbreviation - In the implementation block
@property (nonatomic,retain) WFTemperature * temperature;                                  //@synthesize temperature=_temperature - In the implementation block
@property (nonatomic,retain) WFTemperature * feelsLike;                                    //@synthesize feelsLike=_feelsLike - In the implementation block
@property (assign,nonatomic) NSInteger conditionCode;                                      //@synthesize conditionCode=_conditionCode - In the implementation block
@property (assign,nonatomic) NSUInteger observationTime;                           //@synthesize observationTime=_observationTime - In the implementation block
@property (assign,nonatomic) NSUInteger sunsetTime;                                //@synthesize sunsetTime=_sunsetTime - In the implementation block
@property (assign,nonatomic) NSUInteger sunriseTime;                               //@synthesize sunriseTime=_sunriseTime - In the implementation block
@property (assign,nonatomic) NSUInteger moonPhase;                                 //@synthesize moonPhase=_moonPhase - In the implementation block
@property (assign,setter=setUVIndex:,nonatomic) NSUInteger uvIndex;                //@synthesize uvIndex=_uvIndex - In the implementation block
@property (assign,nonatomic) CGFloat precipitationPast24Hours;                              //@synthesize precipitationPast24Hours=_precipitationPast24Hours - In the implementation block
@property (nonatomic,copy) NSURL * link;                                                   //@synthesize link=_link - In the implementation block
@property (nonatomic,copy) NSURL * deeplink;                                               //@synthesize deeplink=_deeplink - In the implementation block
@property (nonatomic,copy) CLLocation * location;                                          //@synthesize location=_location - In the implementation block
@property (assign,nonatomic) CGFloat longitude; 
@property (assign,nonatomic) CGFloat latitude; 
@property (nonatomic,retain) NSDate * timeZoneUpdateDate;                                  //@synthesize timeZoneUpdateDate=_timeZoneUpdateDate - In the implementation block
@property (nonatomic,retain) NSDate * updateTime;                                          //@synthesize updateTime=_updateTime - In the implementation block
@property (assign,nonatomic) CGFloat windChill;                                              //@synthesize windChill=_windChill - In the implementation block
@property (assign,nonatomic) CGFloat windDirection;                                          //@synthesize windDirection=_windDirection - In the implementation block
@property (assign,nonatomic) CGFloat windSpeed;                                              //@synthesize windSpeed=_windSpeed - In the implementation block
@property (assign,nonatomic) CGFloat humidity;                                               //@synthesize humidity=_humidity - In the implementation block
@property (assign,nonatomic) CGFloat visibility;                                             //@synthesize visibility=_visibility - In the implementation block
@property (assign,nonatomic) CGFloat pressure;                                               //@synthesize pressure=_pressure - In the implementation block
@property (assign,nonatomic) NSUInteger pressureRising;                            //@synthesize pressureRising=_pressureRising - In the implementation block
@property (assign,nonatomic) CGFloat dewPoint;                                               //@synthesize dewPoint=_dewPoint - In the implementation block
@property (assign,nonatomic) CGFloat heatIndex;                                              //@synthesize heatIndex=_heatIndex - In the implementation block
@property (nonatomic,retain) NSNumber * airQualityIdx;                                     //@synthesize airQualityIdx=_airQualityIdx - In the implementation block
@property (nonatomic,retain) NSNumber * airQualityCategory;                                //@synthesize airQualityCategory=_airQualityCategory - In the implementation block
@property (assign,nonatomic) BOOL isDay;                                                   //@synthesize isDay=_isDay - In the implementation block
@property (assign,nonatomic) BOOL autoUpdate;                                              //@synthesize autoUpdate=_autoUpdate - In the implementation block
@property (nonatomic,copy) NSArray * hourlyForecasts;                                      //@synthesize hourlyForecasts=_hourlyForecasts - In the implementation block
@property (nonatomic,copy) NSArray * dayForecasts;                                         //@synthesize dayForecasts=_dayForecasts - In the implementation block
+(id)cityContainingLocation:(id)arg1 expectedName:(id)arg2 fromCities:(id)arg3 ;
+(id)_ISO8601Calendar;
-(id)init;
-(void)dealloc;
-(BOOL)isEqual:(id)arg1 ;
-(NSUInteger)hash;
-(id)description;
-(NSString *)state;
-(void)setState:(NSString *)arg1 ;
-(void)setName:(NSString *)arg1 ;
-(NSString *)name;
-(void)setTimeZone:(NSTimeZone *)arg1 ;
-(NSInteger)updateInterval;
-(void)setUpdateInterval:(NSInteger)arg1 ;
-(BOOL)update;
-(id)dictionaryRepresentation;
-(CLLocation *)location;
-(NSTimeZone *)timeZone;
-(BOOL)isTransient;
-(void)setLocation:(CLLocation *)arg1 ;
-(id)displayName;
-(id)initWithDictionaryRepresentation:(id)arg1 ;
-(NSURL *)link;
-(void)setLink:(NSURL *)arg1 ;
-(id)detailedDescription;
-(void)setUpdateTime:(NSDate *)arg1 ;
-(NSDate *)updateTime;
-(void)setLatitude:(CGFloat)arg1 ;
-(void)setLongitude:(CGFloat)arg1 ;
-(void)setVisibility:(CGFloat)arg1 ;
-(NSInteger)conditionCode;
-(void)setConditionCode:(NSInteger)arg1 ;
-(CGFloat)dewPoint;
-(void)setDewPoint:(CGFloat)arg1 ;
-(CGFloat)heatIndex;
-(void)setHeatIndex:(CGFloat)arg1 ;
-(NSUInteger)moonPhase;
-(void)setMoonPhase:(NSUInteger)arg1 ;
-(WFTemperature *)temperature;
-(void)setTemperature:(WFTemperature *)arg1 ;
-(NSUInteger)uvIndex;
-(CGFloat)windChill;
-(void)setWindChill:(CGFloat)arg1 ;
-(CGFloat)windSpeed;
-(void)setWindSpeed:(CGFloat)arg1 ;
-(CGFloat)windDirection;
-(void)setWindDirection:(CGFloat)arg1 ;
-(NSArray *)hourlyForecasts;
-(void)setHourlyForecasts:(NSArray *)arg1 ;
-(void)setTransient:(BOOL)arg1 ;
-(BOOL)isUpdating;
-(CGFloat)visibility;
-(BOOL)_isUpdating;
-(void)setCoordinate:(CLLocationCoordinate2D)arg1 ;
-(CLLocationCoordinate2D)coordinate;
-(CGFloat)latitude;
-(CGFloat)longitude;
-(CGFloat)pressure;
-(NSString *)updateTimeString;
-(NSString *)ISO3166CountryAbbreviation;
-(WFTemperature *)feelsLike;
-(void)setFeelsLike:(WFTemperature *)arg1 ;
-(CGFloat)humidity;
-(void)setHumidity:(CGFloat)arg1 ;
-(void)setPressure:(CGFloat)arg1 ;
-(NSUInteger)pressureRising;
-(void)setPressureRising:(NSUInteger)arg1 ;
-(void)setUVIndex:(NSUInteger)arg1 ;
-(CGFloat)precipitationPast24Hours;
-(void)setPrecipitationPast24Hours:(CGFloat)arg1 ;
-(NSUInteger)observationTime;
-(void)setObservationTime:(NSUInteger)arg1 ;
-(NSNumber *)airQualityIdx;
-(NSNumber *)airQualityCategory;
-(NSArray *)dayForecasts;
-(BOOL)isLocalWeatherCity;
-(void)updateCityForModel:(id)arg1 ;
-(void)setIsLocalWeatherCity:(BOOL)arg1 ;
-(NSUInteger)precipitationForecast;
-(NSURL *)deeplink;
-(NSUInteger)weatherDataAge;
-(void)_clearAutoUpdateTimer;
-(NSString *)locationID;
-(NSUInteger)sunriseTime;
-(NSHashTable *)cityUpdateObservers;
-(void)setCityUpdateObservers:(NSHashTable *)arg1 ;
-(void)setAutoUpdateTimer:(NSTimer *)arg1 ;
-(BOOL)lockedForDemoMode;
-(NSInteger)timeDigit;
-(BOOL)_dataIsValid;
-(void)setIsUpdating:(BOOL)arg1 ;
-(void)_notifyDidStartWeatherUpdate;
-(NSDate *)timeZoneUpdateDate;
-(BOOL)timeZoneIsFresh;
-(void)updateTimeZoneWithCompletionBlock:(/*^block*/id)arg1 ;
-(BOOL)isUpdatingTimeZone;
-(void)setUpdatingTimeZone:(BOOL)arg1 ;
-(void)setTimeZoneUpdateDate:(NSDate *)arg1 ;
-(void)setDayForecasts:(NSArray *)arg1 ;
-(void)setAirQualityCategory:(NSNumber *)arg1 ;
-(void)setAirQualityIdx:(NSNumber *)arg1 ;
-(void)setLastUpdateStatus:(NSUInteger)arg1 ;
-(void)setLastUpdateError:(NSError *)arg1 ;
-(void)discardDataIfNeeded;
-(void)setISO3166CountryAbbreviation:(NSString *)arg1 ;
-(void)setDeeplink:(NSURL *)arg1 ;
-(void)setSunriseTime:(NSUInteger)arg1 ;
-(NSUInteger)lastUpdateStatus;
-(CGFloat)distanceToLatitude:(CGFloat)arg1 longitude:(CGFloat)arg2 ;
-(CGFloat)distanceToLocation:(id)arg1 ;
-(id)naturalLanguageDescriptionWithDescribedCondition:(out NSInteger*)arg1 ;
-(BOOL)isDay;
-(id)windDirectionAsString:(CGFloat)arg1 ;
-(NSInteger)primaryConditionForRange:(NSRange)arg1 ;
-(NSInteger)locationOfTime:(NSInteger)arg1 ;
-(void)clearForecasts;
-(void)setWfLocation:(WFLocation *)arg1 ;
-(void)setAutoUpdate:(BOOL)arg1 ;
-(void)setIsDay:(BOOL)arg1 ;
-(void)localWeatherDidBeginUpdate;
-(void)cityDidFinishUpdatingWithError:(id)arg1 ;
-(BOOL)isUpdatingOrNoData;
-(id)cityAndState;
-(BOOL)populateWithDataFromCity:(id)arg1 ;
-(BOOL)containsLatitude:(CGFloat)arg1 longitude:(CGFloat)arg2 ;
-(BOOL)isDuplicateOfCity:(id)arg1 ;
-(id)naturalLanguageDescription;
-(void)_generateLocalizableStrings;
-(void)setUpdateTimeString:(NSString *)arg1 ;
-(NSString *)woeid;
-(void)setWoeid:(NSString *)arg1 ;
-(NSError *)lastUpdateError;
-(BOOL)autoUpdate;
-(WFLocation *)wfLocation;
-(BOOL)isRequestedByFrameworkClient;
-(void)setIsRequestedByFrameworkClient:(BOOL)arg1 ;
-(void)setLockedForDemoMode:(BOOL)arg1 ;
-(NSTimer *)autoUpdateTimer;
-(NSDictionary *)urlComponents;
-(void)addUpdateObserver:(id)arg1 ;
-(void)removeUpdateObserver:(id)arg1 ;
-(void)setFullName:(NSString *)arg1 ;
-(void)setSunsetTime:(NSUInteger)arg1 ;
-(NSUInteger)sunsetTime;
-(NSString *)fullName;
-(void)_updateTimeZone;
@end