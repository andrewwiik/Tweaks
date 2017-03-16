@protocol MPUTransportControlMediaRemoteControllerDelegate <NSObject>
@optional
-(id)transportControlMediaRemoteController:(id)arg1 alternateKeyForMediaRemoteNowPlayingInfoKey:(id)arg2;

@required
-(id)presentingViewControllerForLikeBanActionSheetForTransportControlMediaRemoteController:(id)arg1;
-(void)transportControlMediaRemoteController:(id)arg1 requestsPushingMediaRemoteCommand:(NSInteger)arg2 withOptions:(id)arg3 shouldLaunchApplication:(BOOL)arg4;

@end