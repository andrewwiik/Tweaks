@interface _UIVisualEffectLayerConfig : NSObject
@property (nonatomic,readonly) CGFloat opacity;                     //@synthesize opacity=_opacity - In the implementation block
@property (nonatomic,readonly) NSString * filterType;              //@synthesize filterType=_filterType - In the implementation block
@property (nonatomic,readonly) UIColor * fillColor;                //@synthesize fillColor=_fillColor - In the implementation block
+(instancetype)layerWithFillColor:(id)arg1 opacity:(CGFloat)arg2 filterType:(NSString *)arg3;
-(CGFloat)opacity;
-(UIColor *)fillColor;
-(NSString *)filterType;
-(void)configureLayerView:(id)arg1;
-(void)deconfigureLayerView:(id)arg1;
@end