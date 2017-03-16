@interface BBColor : NSObject <NSSecureCoding, NSCopying> {

	CGFloat _red;
	CGFloat _green;
	CGFloat _blue;
	CGFloat _alpha;

}

@property (nonatomic,readonly) CGFloat red;                //@synthesize red=_red - In the implementation block
@property (nonatomic,readonly) CGFloat green;              //@synthesize green=_green - In the implementation block
@property (nonatomic,readonly) CGFloat blue;               //@synthesize blue=_blue - In the implementation block
@property (nonatomic,readonly) CGFloat alpha;              //@synthesize alpha=_alpha - In the implementation block
+(id)colorWithRed:(CGFloat)arg1 green:(CGFloat)arg2 blue:(CGFloat)arg3 alpha:(CGFloat)arg4 ;
+(BOOL)supportsSecureCoding;
-(id)replacementObjectForCoder:(id)arg1 ;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(BOOL)isEqual:(id)arg1 ;
-(id)copyWithZone:(NSZone*)arg1 ;
-(CGFloat)alpha;
-(CGFloat)red;
-(CGFloat)green;
-(CGFloat)blue;
-(id)awakeAfterUsingCoder:(id)arg1 ;
-(id)_initWithRed:(CGFloat)arg1 green:(CGFloat)arg2 blue:(CGFloat)arg3 alpha:(CGFloat)arg4 ;
@end