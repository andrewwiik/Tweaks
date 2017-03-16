#import "headers.h"
#import "CCXNonTransparentView.h"

@interface CCXSettingsTableViewCell : UITableViewCell {
	UIColor *_iconColor;
	Class _settingsControllerClass;
	Class _controllerClass;
}
@property (nonatomic, retain) UIColor *iconColor;   //@synthesize sectionColor=_sectionColor - In the implementation block
@property (nonatomic, retain) CCXNonTransparentView *backgroundGlyphView;
@property (nonatomic, retain) _UIVisualEffectLayerConfig *primaryEffectConfig;
@property (nonatomic, assign) Class settingsControllerClass;
@property (nonatomic, assign) Class controllerClass;
- (void)layoutGlyphBackgroundView;
- (UIView *)findReorderView:(UIView *)view;
@end