#import "WFLocation.h"

@interface WFAirQualityConditions : NSObject <NSSecureCoding> {

	WFLocation* _location;
	NSLocale* _locale;
	NSDate* _date;
	NSString* _provider;
	NSInteger _localizedAirQualityIndex;
	NSString* _localizedAirQualityCategory;
	NSArray* _pollutants;
	NSDate* _expirationDate;
	NSUInteger _category;

}

@property (nonatomic,retain) WFLocation * location;                             //@synthesize location=_location - In the implementation block
@property (nonatomic,copy) NSLocale * locale;                                   //@synthesize locale=_locale - In the implementation block
@property (nonatomic,retain) NSDate * expirationDate;                           //@synthesize expirationDate=_expirationDate - In the implementation block
@property (nonatomic,copy) NSDate * date;                                       //@synthesize date=_date - In the implementation block
@property (nonatomic,copy) NSString * provider;                                 //@synthesize provider=_provider - In the implementation block
@property (nonatomic,readonly) BOOL isExpired; 
@property (assign,nonatomic) NSUInteger category;                       //@synthesize category=_category - In the implementation block
@property (assign,nonatomic) NSInteger localizedAirQualityIndex;                //@synthesize localizedAirQualityIndex=_localizedAirQualityIndex - In the implementation block
@property (nonatomic,copy) NSString * localizedAirQualityCategory;              //@synthesize localizedAirQualityCategory=_localizedAirQualityCategory - In the implementation block
@property (nonatomic,copy) NSArray * pollutants;                                //@synthesize pollutants=_pollutants - In the implementation block
+(BOOL)supportsSecureCoding;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(void)setCategory:(NSUInteger)arg1 ;
-(NSUInteger)category;
-(NSDate *)date;
-(void)setLocale:(NSLocale *)arg1 ;
-(void)setDate:(NSDate *)arg1 ;
-(WFLocation *)location;
-(NSLocale *)locale;
-(void)setLocation:(WFLocation *)arg1 ;
-(NSDate *)expirationDate;
-(void)setExpirationDate:(NSDate *)arg1 ;
-(NSString *)provider;
-(void)setProvider:(NSString *)arg1 ;
-(NSInteger)airQualityIndex;
-(NSArray *)pollutants;
-(void)setPollutants:(NSArray *)arg1 ;
-(void)setLocalizedAirQualityIndex:(NSInteger)arg1 ;
-(NSInteger)localizedAirQualityIndex;
-(BOOL)isExpired;
-(void)setLocalizedAirQualityCategory:(NSString *)arg1 ;
-(NSString *)localizedAirQualityCategory;
@end
