@protocol MPUTransportControlsViewLayoutDelegate
@optional
-(CGFloat)transportControlsView:(id)arg1 adjustedMaximumLayoutWidthOfTransportButtonWithControlType:(NSInteger)arg2;
-(void)transportControlsViewDidLayoutSubviews:(id)arg1;
-(CGRect*)transportControlsView:(id)arg1 adjustedFrameOfTransportButtonWithControlType:(NSInteger)arg2 proposedFrame:(CGRect)arg3;
-(CGSize*)transportControlsView:(id)arg1 defaultTransportButtonSizeWithProposedSize:(CGSize)arg2;

@end