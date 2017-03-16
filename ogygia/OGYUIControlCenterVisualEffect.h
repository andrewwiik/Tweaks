#import <UIKit/UIKit+Private.h>

@interface OGYUIControlCenterVisualEffect : UIVisualEffect {
	NSInteger _style;
}
- (id)initWithStyle:(NSInteger)style;
- (_UIVisualEffectConfig *)effectConfig;
+ (instancetype)effectWithStyle:(NSInteger)style;
@end