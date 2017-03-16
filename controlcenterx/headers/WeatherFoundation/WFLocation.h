@interface WFLocation : NSObject <NSSecureCoding, NSCopying> {

	NSString* _city;
	NSString* _county;
	NSString* _state;
	NSString* _stateAbbreviation;
	NSString* _country;
	NSString* _countryAbbreviation;
	CLLocation* _geoLocation;
	NSString* _locationID;
	NSTimeZone* _timeZone;
	NSInteger _archiveVersion;
	NSString* _weatherDisplayName;
	NSString* _displayName;
	NSDate* _creationDate;

}

@property (assign) NSInteger archiveVersion;                                   //@synthesize archiveVersion=_archiveVersion - In the implementation block
@property (nonatomic,copy) NSString * city;                                    //@synthesize city=_city - In the implementation block
@property (nonatomic,copy) NSString * county;                                  //@synthesize county=_county - In the implementation block
@property (nonatomic,copy) NSString * state;                                   //@synthesize state=_state - In the implementation block
@property (nonatomic,copy) NSString * stateAbbreviation;                       //@synthesize stateAbbreviation=_stateAbbreviation - In the implementation block
@property (nonatomic,copy) NSString * country;                                 //@synthesize country=_country - In the implementation block
@property (nonatomic,copy) NSString * countryAbbreviation;                     //@synthesize countryAbbreviation=_countryAbbreviation - In the implementation block
@property (nonatomic,copy) NSString * weatherDisplayName;                      //@synthesize weatherDisplayName=_weatherDisplayName - In the implementation block
@property (nonatomic,copy) CLLocation * geoLocation;                           //@synthesize geoLocation=_geoLocation - In the implementation block
@property (nonatomic,copy) NSString * locationID;                              //@synthesize locationID=_locationID - In the implementation block
@property (nonatomic,copy) NSTimeZone * timeZone;                              //@synthesize timeZone=_timeZone - In the implementation block
@property (nonatomic,copy) NSString * displayName;                             //@synthesize displayName=_displayName - In the implementation block
@property (nonatomic,copy) NSDate * creationDate;                              //@synthesize creationDate=_creationDate - In the implementation block
@property (nonatomic,readonly) BOOL shouldQueryForAirQualityData; 
+(BOOL)supportsSecureCoding;
+(NSInteger)currentArchiveVersion;
+(id)knownKeys;
+(id)locationsByConsolidatingDuplicates:(id)arg1 originalOrder:(id)arg2 ;
+(id)locationsByConsolidatingDuplicatesInBucket:(id)arg1 ;
+(id)locationsByFilteringDuplicates:(id)arg1 ;
-(id)init;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(BOOL)isEqual:(id)arg1 ;
-(NSUInteger)hash;
-(id)description;
-(NSString *)state;
-(void)setState:(NSString *)arg1 ;
-(void)setTimeZone:(NSTimeZone *)arg1 ;
-(id)copyWithZone:(NSZone*)arg1 ;
-(NSTimeZone *)timeZone;
-(NSString *)displayName;
-(void)setDisplayName:(NSString *)arg1 ;
-(NSString *)weatherDisplayName;
-(NSString *)country;
-(void)setCountry:(NSString *)arg1 ;
-(id)summary;
-(id)initWithMapItem:(id)arg1 ;
-(void)setGeoLocation:(CLLocation *)arg1 ;
-(CLLocation *)geoLocation;
-(void)setCity:(NSString *)arg1 ;
-(NSDate *)creationDate;
-(void)setCreationDate:(NSDate *)arg1 ;
-(id)initWithPlacemark:(id)arg1 ;
-(void)setCountryAbbreviation:(NSString *)arg1 ;
-(id)sunriseForDate:(id)arg1 ;
-(id)sunsetForDate:(id)arg1 ;
-(NSString *)locationID;
-(NSString *)countryAbbreviation;
-(BOOL)isDay;
-(BOOL)shouldQueryForAirQualityData;
-(NSString *)city;
-(void)setWeatherDisplayName:(NSString *)arg1 ;
-(void)setCounty:(NSString *)arg1 ;
-(id)summaryThatIsCompact:(BOOL)arg1 ;
-(NSString *)county;
-(NSString *)stateAbbreviation;
-(NSInteger)archiveVersion;
-(void)setStateAbbreviation:(NSString *)arg1 ;
-(void)setLocationID:(NSString *)arg1 ;
-(void)setArchiveVersion:(NSInteger)arg1 ;
-(BOOL)isDayForDate:(id)arg1 ;
-(id)initWithSearchResponse:(id)arg1 ;
-(id)localDataRepresentation;
-(id)initWithLocalDataRepresentation:(id)arg1 ;
-(id)cloudDictionaryRepresentation;
-(id)initWithCloudDictionaryRepresentation:(id)arg1 ;
@end

