#import <UIKit/_UIBackdropViewSettings.h>

@interface _UIBackdropView : UIView
@property (nonatomic,copy) NSString *groupName; 
- (UIView *)grayscaleTintView;
- (id)initWithPrivateStyle:(int)arg1;
- (id)initWithSettings:(_UIBackdropViewSettings *)arg1;
- (id)initWithStyle:(int)arg1;
+ (instancetype)settingsForPrivateStyle:(NSInteger)arg1 graphicsQuality:(NSInteger)arg2;
- (void)transitionToSettings:(id)settings;
- (void)transitionIncrementallyToSettings:(id)arg1 weighting:(CGFloat)arg2;
- (void)computeAndApplySettingsForTransition;
-(void)updateMaskViewsForView:(id)arg1 ;
-(void)setFilterMaskImage:(UIImage *)arg1 ;
-(void)setGrayscaleTintMaskImage:(UIImage *)arg1 ;
-(void)setColorTintMaskImage:(UIImage *)arg1 ;
-(void)setFilterMaskImage:(UIImage *)arg1 ;
-(void)setColorBurnTintMaskImage:(UIImage *)arg1 ;
-(void)setDarkeningTintMaskImage:(UIImage *)arg1 ;
@end