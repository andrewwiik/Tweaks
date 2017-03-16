@protocol MPUNowPlayingDelegate
@optional
-(void)nowPlayingController:(id)arg1 nowPlayingInfoDidChange:(id)arg2;
-(void)nowPlayingController:(id)arg1 playbackStateDidChange:(BOOL)arg2;
-(void)nowPlayingController:(id)arg1 nowPlayingApplicationDidChange:(id)arg2;
-(void)nowPlayingControllerDidBeginListeningForNotifications:(id)arg1;
-(void)nowPlayingControllerDidStopListeningForNotifications:(id)arg1;
-(void)nowPlayingController:(id)arg1 elapsedTimeDidChange:(CGFloat)arg2;

@end