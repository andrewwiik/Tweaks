@interface WACurrentForecast : NSObject <NSCopying> {

	float _windSpeed;
	float _windDirection;
	float _humidity;
	float _dewPoint;
	float _visibility;
	float _pressure;
	float _precipitationPast24Hours;
	WFTemperature* _temperature;
	WFTemperature* _feelsLike;
	unsigned long long _pressureRising;
	unsigned long long _UVIndex;
	long long _conditionCode;
	unsigned long long _observationTime;

}

@property (nonatomic,retain) WFTemperature * temperature;                     //@synthesize temperature=_temperature - In the implementation block
@property (nonatomic,retain) WFTemperature * feelsLike;                       //@synthesize feelsLike=_feelsLike - In the implementation block
@property (assign,nonatomic) float windSpeed;                                 //@synthesize windSpeed=_windSpeed - In the implementation block
@property (assign,nonatomic) float windDirection;                             //@synthesize windDirection=_windDirection - In the implementation block
@property (assign,nonatomic) float humidity;                                  //@synthesize humidity=_humidity - In the implementation block
@property (assign,nonatomic) float dewPoint;                                  //@synthesize dewPoint=_dewPoint - In the implementation block
@property (assign,nonatomic) float visibility;                                //@synthesize visibility=_visibility - In the implementation block
@property (assign,nonatomic) float pressure;                                  //@synthesize pressure=_pressure - In the implementation block
@property (assign,nonatomic) unsigned long long pressureRising;               //@synthesize pressureRising=_pressureRising - In the implementation block
@property (assign,nonatomic) unsigned long long UVIndex;                      //@synthesize UVIndex=_UVIndex - In the implementation block
@property (assign,nonatomic) float precipitationPast24Hours;                  //@synthesize precipitationPast24Hours=_precipitationPast24Hours - In the implementation block
@property (assign,nonatomic) long long conditionCode;                         //@synthesize conditionCode=_conditionCode - In the implementation block
@property (assign,nonatomic) unsigned long long observationTime;              //@synthesize observationTime=_observationTime - In the implementation block
+(id)currentForecastForLocation:(id)arg1 conditions:(id)arg2 ;
-(BOOL)isEqual:(id)arg1 ;
-(unsigned long long)hash;
-(id)description;
-(id)copyWithZone:(NSZone*)arg1 ;
-(void)setVisibility:(float)arg1 ;
-(long long)conditionCode;
-(void)setConditionCode:(long long)arg1 ;
-(float)dewPoint;
-(void)setDewPoint:(float)arg1 ;
-(WFTemperature *)temperature;
-(void)setTemperature:(WFTemperature *)arg1 ;
-(float)windSpeed;
-(void)setWindSpeed:(float)arg1 ;
-(float)windDirection;
-(void)setWindDirection:(float)arg1 ;
-(float)visibility;
-(float)pressure;
-(WFTemperature *)feelsLike;
-(void)setFeelsLike:(WFTemperature *)arg1 ;
-(float)humidity;
-(void)setHumidity:(float)arg1 ;
-(void)setPressure:(float)arg1 ;
-(unsigned long long)pressureRising;
-(void)setPressureRising:(unsigned long long)arg1 ;
-(void)setUVIndex:(unsigned long long)arg1 ;
-(float)precipitationPast24Hours;
-(void)setPrecipitationPast24Hours:(float)arg1 ;
-(unsigned long long)observationTime;
-(void)setObservationTime:(unsigned long long)arg1 ;
-(unsigned long long)UVIndex;
@end
