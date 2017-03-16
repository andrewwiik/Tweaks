#import <UserNotificationsUI/NCVibrantStyling.h>

@interface _NCVibrantStylingVibrancyEffect : UIVibrancyEffect {

	NCVibrantStyling* _vibrantStyling;

}
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(BOOL)isEqual:(id)arg1 ;
-(id)copyWithZone:(NSZone*)arg1 ;
-(id)effectConfigForQuality:(long long)arg1 ;
-(id)effectForUserInterfaceStyle:(long long)arg1 ;
-(id)effectConfig;
-(id)initWithVibrantStyling:(id)arg1 ;
-(NSInteger)_vibrantStyle;
@end