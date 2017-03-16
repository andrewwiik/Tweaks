#import <UIKit/_UIVisualEffectConfig.h>

@interface CCUIControlCenterVisualEffect : UIVisualEffect {

	NSInteger _style;

}
+(instancetype)effectWithStyle:(NSInteger)arg1 ;
+(instancetype)_glyphOrTextOnPlatterOrBackgroundEffect;
+(instancetype)_primaryHighlightedTextOnPlatterEffect;
+(instancetype)_grayEffect;
+(instancetype)_primaryRegularTextOnPlatterEffect;
+(instancetype)_secondaryHighlightedTextOnPlatterEffect;
+(instancetype)_secondaryRegularTextOnPlatterEffect;
+(instancetype)_blackEffect;
+(instancetype)_whiteEffect;
+(instancetype)effectWithControlState:(NSUInteger)arg1 inContext:(NSInteger)arg2 ;
-(NSInteger)_style;
-(instancetype)initWithPrivateStyle:(NSInteger)arg1 ;
-(id)contentsMultiplyColor;
-(_UIVisualEffectConfig *)effectConfig;
@end