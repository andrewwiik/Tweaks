#import <UIKit/_UIVisualEffectConfig.h>

@interface CCUIControlCenterVisualEffect : UIVisualEffect {
    NSInteger  _style;
}

+ (instancetype)_blackEffect;
+ (instancetype)_glyphOrTextOnPlatterOrBackgroundEffect;
+ (instancetype)_grayEffect;
+ (instancetype)_primaryHighlightedTextOnPlatterEffect;
+ (instancetype)_primaryRegularTextOnPlatterEffect;
+ (instancetype)_secondaryHighlightedTextOnPlatterEffect;
+ (instancetype)_secondaryRegularTextOnPlatterEffect;
+ (instancetype)_whiteEffect;
+ (instancetype)effectWithControlState:(NSUInteger)arg1 inContext:(NSInteger)arg2;
+ (instancetype)effectWithStyle:(long long)arg1;

- (NSInteger)_style;
- (_UIVisualEffectConfig *)effectConfig;
- (instancetype)initWithPrivateStyle:(NSInteger)arg1;
- (BOOL)isEqual:(id)arg1;

@end