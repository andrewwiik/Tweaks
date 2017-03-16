#import <UIKit/_UIBackdropViewSettings.h>

@interface _UIBackdropViewSettingsCombiner : _UIBackdropViewSettings
@property (nonatomic, retain) _UIBackdropViewSettings *inputSettingsA;
@property (nonatomic, retain) _UIBackdropViewSettings *inputSettingsB;
@property CGFloat weighting;
@end