#import "WFLocation.h"

@interface WFWeatherConditions : NSObject <NSCopying, NSSecureCoding> {

	WFLocation* _location;
	NSMutableDictionary* _components;

}

@property (nonatomic,retain) NSMutableDictionary * components;              //@synthesize components=_components - In the implementation block
@property (retain) WFLocation * location;                                   //@synthesize location=_location - In the implementation block
+(BOOL)supportsSecureCoding;
-(id)valueForComponent:(id)arg1 ;
-(void)setValue:(id)arg1 forComponent:(id)arg2 ;
-(id)init;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(id)description;
-(id)objectForKeyedSubscript:(id)arg1 ;
-(void)setObject:(id)arg1 forKeyedSubscript:(id)arg2 ;
-(id)copyWithZone:(NSZone*)arg1 ;
-(id)dictionaryRepresentation;
-(WFLocation *)location;
-(void)setLocation:(WFLocation *)arg1 ;
-(NSMutableDictionary *)components;
-(void)setComponents:(NSMutableDictionary *)arg1 ;
-(void)_retrieveSunrise:(id*)arg1 sunset:(id*)arg2 ;
-(BOOL)wf_isDayIfSunrise:(id)arg1 sunset:(id)arg2 ;
-(id)allComponents;
-(BOOL)wf_isDay;
@end
