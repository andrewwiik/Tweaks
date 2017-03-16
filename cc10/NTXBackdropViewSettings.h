#import "headers/_UIBackdropViewSettings.h"

@interface NTXBackdropViewSettings : _UIBackdropViewSettings
@property (getter=_isBlurred, nonatomic, readonly) BOOL blurred;
@property (getter=_isDarkened, nonatomic, readonly) BOOL darkened;

+ (id)watchNotificationsBackdropViewSettingsWithBlur:(BOOL)arg1;
+ (id)watchNotificationsBackdropViewSettingsWithBlur:(BOOL)arg1 darken:(BOOL)arg2;
- (BOOL)_isBlurred;
- (BOOL)_isDarkened;
- (void)setDefaultValues;
@end

@interface NTXDarkenedBlurBackdropViewSettings : NTXBackdropViewSettings
- (BOOL)_isBlurred;
- (BOOL)_isDarkened;
@end

@interface NTXUnblurredBackdropViewSettings : NTXBackdropViewSettings
- (BOOL)_isBlurred;
- (BOOL)_isDarkened;
@end