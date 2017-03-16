#import <UIKit/_UIBackdropViewSettings.h>

@interface _UIBackdropView : UIView
@property (nonatomic,copy) NSString *groupName; 
- (UIView *)grayscaleTintView;
- (id)initWithPrivateStyle:(int)arg1;
- (id)initWithSettings:(_UIBackdropViewSettings *)arg1;
- (id)initWithStyle:(int)arg1;
+ (instancetype)settingsForPrivateStyle:(NSInteger)arg1 graphicsQuality:(NSInteger)arg2;
- (void)transitionToSettings:(id)arg1;
- (void)computeAndApplySettings:(id)settings;
@end