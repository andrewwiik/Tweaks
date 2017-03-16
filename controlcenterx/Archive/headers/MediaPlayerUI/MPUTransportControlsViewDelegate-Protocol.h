@protocol MPUTransportControlsViewDelegate
@optional
-(void)transportControlsView:(id)arg1 tapOnControlType:(NSInteger)arg2;
-(void)transportControlsView:(id)arg1 longPressBeginOnControlType:(NSInteger)arg2;
-(void)transportControlsView:(id)arg1 longPressEndOnControlType:(NSInteger)arg2;
-(CGFloat)transportControlsView:(id)arg1 transportButtonUnhighlightAnimationDurationForControlType:(NSInteger)arg2;

@end