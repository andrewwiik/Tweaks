#import <UIKit/_UIVisualEffectLayerConfig.h>

@interface _UIVisualEffectTintLayerConfig : _UIVisualEffectLayerConfig
@property (nonatomic,readonly) UIColor *tintColor;            //@synthesize tintColor=_tintColor - In the implementation block

+(instancetype)layerWithTintColor:(UIColor *)arg1 filterType:(NSString *)arg2;
+(instancetype)layerWithTintColor:(UIColor *)arg1;
-(UIColor *)tintColor;
-(void)configureLayerView:(id)arg1;
-(void)deconfigureLayerView:(id)arg1;
@end