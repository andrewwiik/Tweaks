#import "CCXNoEffectsButton.h"
#import "CCXPunchOutView.h"
#import "headers.h"

@interface CCXSettingsNavigationBar : UIView
@property (nonatomic, retain) UILabel *headerLabel;
@property (nonatomic, retain) CCXNoEffectsButton *rightButton;
@property (nonatomic, retain) CCXPunchOutView *separatorView;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) _UIVisualEffectLayerConfig *primaryEffectConfig;
- (id)initWithFrame:(CGRect)frame;
- (void)layoutSubviews;
- (void)setHeaderText:(NSString *)text;
- (void)setIconImage:(UIImage *)image;
- (void)setShowingBackButton:(BOOL)showingButton;
- (void)setIconColor:(UIColor *)color;

+ (UIFont *)buttonFont;
+ (UIFont *)headerFont;
@end