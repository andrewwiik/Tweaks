@interface WFTemperature : NSObject <NSCopying, NSSecureCoding>

@property (assign,nonatomic) CGFloat celsius; 
@property (assign,nonatomic) CGFloat fahrenheit; 
@property (assign,nonatomic) CGFloat kelvin; 
+(BOOL)supportsSecureCoding;
-(CGFloat)celsius;
-(CGFloat)fahrenheit;
-(CGFloat)kelvin;
-(id)init;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(BOOL)isEqual:(id)arg1 ;
-(id)copyWithZone:(NSZone*)arg1 ;
-(CGFloat)temperatureForUnit:(int)arg1 ;
-(id)initWithTemperatureUnit:(int)arg1 value:(CGFloat)arg2 ;
-(void)setCelsius:(CGFloat)arg1 ;
-(void)setKelvin:(CGFloat)arg1 ;
-(void)setFahrenheit:(CGFloat)arg1 ;
-(BOOL)isEqualToTemperature:(id)arg1 ;
-(void)_setValue:(CGFloat)arg1 forUnit:(int)arg2 ;
-(void)_resetTemperatureValues;
-(BOOL)_unitIsHydrated:(int)arg1 outputValue:(out CGFloat*)arg2 ;
@end