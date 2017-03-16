@protocol MPUChronologicalProgressViewDelegate
@optional
-(void)progressViewDidBeginScrubbing:(id)arg1;
-(void)progressViewDidEndScrubbing:(id)arg1;
-(void)progressView:(id)arg1 didScrubToCurrentTime:(CGFloat)arg2;

@end