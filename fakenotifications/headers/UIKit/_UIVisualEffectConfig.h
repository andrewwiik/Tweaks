#import <UIKit/_UIVisualEffectLayerConfig.h>

@interface _UIVisualEffectConfig : NSObject {

	NSMutableArray * _layerConfigs;
	_UIVisualEffectLayerConfig* _contentConfig;

}

@property (nonatomic,readonly) NSArray * layerConfigs;                                  
@property (nonatomic,readonly) _UIVisualEffectLayerConfig * contentConfig;              
+(id)configWithContentConfig:(id)arg1 ;
+(id)configWithLayerConfigs:(id)arg1 ;
-(void)addLayerConfig:(id)arg1 ;
-(void)enumerateLayerConfigs:(id)arg1 ;
-(NSArray *)layerConfigs;
-(_UIVisualEffectLayerConfig *)contentConfig;
@end