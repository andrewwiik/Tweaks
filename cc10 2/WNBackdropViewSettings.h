#import "headers/_UIBackdropViewSettings.h"

@interface WNBackdropViewSettings : _UIBackdropViewSettings
@property (getter=_isBlurred, nonatomic, readonly) BOOL blurred;
@property (getter=_isDarkened, nonatomic, readonly) BOOL darkened;

+ (id)watchNotificationsBackdropViewSettingsWithBlur:(BOOL)arg1;
+ (id)watchNotificationsBackdropViewSettingsWithBlur:(BOOL)arg1 darken:(BOOL)arg2;
- (BOOL)_isBlurred;
- (BOOL)_isDarkened;
- (void)setDefaultValues;
@end

@interface WNDarkenedBlurBackdropViewSettings : WNBackdropViewSettings
- (BOOL)_isBlurred;
- (BOOL)_isDarkened;
@end

@interface WNUnblurredBackdropViewSettings : WNBackdropViewSettings
- (BOOL)_isBlurred;
- (BOOL)_isDarkened;
@end