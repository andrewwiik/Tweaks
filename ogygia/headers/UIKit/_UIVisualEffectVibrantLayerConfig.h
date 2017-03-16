#import <UIKit/_UIVisualEffectLayerConfig.h>

@interface _UIVisualEffectVibrantLayerConfig : _UIVisualEffectLayerConfig
@property (nonatomic,readonly) UIColor * vibrantColor;                            //@synthesize vibrantColor=_vibrantColor - In the implementation block
@property (nonatomic,readonly) UIColor * tintColor;                               //@synthesize tintColor=_tintColor - In the implementation block
@property (nonatomic,copy,readonly) NSDictionary * filterAttributes;              //@synthesize filterAttributes=_filterAttributes - In the implementation block
+(instancetype)layerWithVibrantColor:(UIColor *)arg1 tintColor:(UIColor *)arg2 filterType:(NSString *)arg3 filterAttributes:(id)arg4;
+(instancetype)layerWithVibrantColor:(UIColor *)arg1 tintColor:(UIColor *)arg2 filterType:(NSString *)arg3;
-(UIColor *)tintColor;
-(void)configureLayerView:(id)arg1;
-(void)deconfigureLayerView:(id)arg1;
-(NSDictionary *)filterAttributes;
-(UIColor *)vibrantColor;
@end