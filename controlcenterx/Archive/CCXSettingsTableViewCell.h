#import "headers.h"
#import "CCXNonTransparentView.h"

@interface CCXSettingsTableViewCell : UITableViewCell {
	UIColor *_iconColor;
}
@property (nonatomic, retain) UIColor *iconColor;   //@synthesize sectionColor=_sectionColor - In the implementation block
@property (nonatomic, retain) CCXNonTransparentView *backgroundGlyphView;
@property (nonatomic, retain) _UIVisualEffectLayerConfig *primaryEffectConfig;
- (void)layoutGlyphBackgroundView;
- (UIView *)findReorderView:(UIView *)view;
@end