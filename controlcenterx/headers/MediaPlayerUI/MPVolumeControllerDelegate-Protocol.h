@protocol MPVolumeControllerDelegate
@optional
-(void)volumeController:(id)arg1 volumeValueDidChange:(CGFloat)arg2;
-(void)volumeController:(id)arg1 volumeWarningStateDidChange:(NSInteger)arg2;
-(void)volumeController:(id)arg1 mutedStateDidChange:(BOOL)arg2;
-(void)volumeController:(id)arg1 EUVolumeLimitDidChange:(CGFloat)arg2;
-(void)volumeController:(id)arg1 EUVolumeLimitEnforcedDidChange:(BOOL)arg2;

@end