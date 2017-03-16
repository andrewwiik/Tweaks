#import <ControlCenterUI/CCUIControlCenterSettings.h>

@protocol CCUIControlCenterSystemAgent
- (NSString *)frontmostApplicationDisplayID;
- (NSArray *)getFGSceneIdentifiers;
- (BOOL)wifiIsPowered;
- (BOOL)wifiDevicePresent;
- (void)setWifiPowered:(BOOL)arg1;
- (void)updateWifiDevicePresence;
- (BOOL)isInAirplaneMode;
- (BOOL)isOrientationLocked;
- (void)unlockOrientation;
- (void)lockOrientation;
- (BOOL)wirelessDisplayRouteIsPicked;
- (NSString *)nameOfPickedRoute;
- (BOOL)handsetRouteIsSelected;
- (void)setRingerMuted:(BOOL)arg1;
- (BOOL)isRingerMuted;
- (void)activateAppWithDisplayID:(NSString *)arg1 url:(NSURL *)arg2;
- (void)dismissAnimated:(BOOL)arg1 completion:(void (^)(void))arg2;
- (CCUIControlCenterSettings *)prototypeSettings;

@optional
- (BOOL)isUILocked;
- (UIView *)materialBackgroundView;
@end