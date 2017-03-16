@interface MPAVBatteryLevel : NSObject {

	NSNumber* _leftPercentage;
	NSNumber* _rightPercentage;
	NSNumber* _singlePercentage;
	NSNumber* _casePercentage;

}

@property (nonatomic,readonly) NSNumber * leftPercentage;                //@synthesize leftPercentage=_leftPercentage - In the implementation block
@property (nonatomic,readonly) NSNumber * rightPercentage;               //@synthesize rightPercentage=_rightPercentage - In the implementation block
@property (nonatomic,readonly) NSNumber * singlePercentage;              //@synthesize singlePercentage=_singlePercentage - In the implementation block
@property (nonatomic,readonly) NSNumber * casePercentage;                //@synthesize casePercentage=_casePercentage - In the implementation block
-(NSNumber *)leftPercentage;
-(NSNumber *)rightPercentage;
-(NSNumber *)singlePercentage;
-(NSNumber *)casePercentage;
-(id)initWithRouteDescription:(id)arg1 ;
@end
