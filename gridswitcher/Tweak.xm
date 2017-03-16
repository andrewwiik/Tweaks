%hook SBDeckSwitcherViewController
- (struct CGRect)_frameForIndex:(unsigned long long)arg1 displayItemsCount:(unsigned long long)arg2 transitionParameters:(id)arg3 scrollProgress:(double)arg4 ignoringScrollOffsetAndKillingAdjustments:(_Bool)arg5 {
	//CGRect originalFrame = %orig;
	//CGRect newFrame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y + (((originalFrame.size.height + 20) * arg1) * arg4),originalFrame.size.width,originalFrame.size.height);
	return %orig;
}
- (struct CGAffineTransform)_transformForIndex:(unsigned long long)arg1 progressPresented:(double)arg2 scrollProgress:(double)arg3 {
	return CGAffineTransformMakeScale(0.5, 0.5);

}
%end