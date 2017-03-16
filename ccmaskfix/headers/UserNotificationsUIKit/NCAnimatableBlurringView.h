#import "NCBlurring-Protocol.h"


@interface NCAnimatableBlurringView : UIView <NCBlurring> {

	BOOL _didConfigureBlurFilter;
	CGFloat _inputRadius;

}
@property (assign,nonatomic) CGFloat inputRadius;                    //@synthesize inputRadius=_inputRadius - In the implementation block
+(id)_inputRadiusKeyPath;
-(BOOL)_shouldAnimatePropertyWithKey:(id)arg1 ;
-(void)setInputRadius:(CGFloat)arg1 ;
-(CGFloat)inputRadius;
-(void)_configureBlurFilterIfNecessary;
@end