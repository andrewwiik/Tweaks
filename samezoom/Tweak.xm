%hook BKPageScrollerViewController
- (void)loadView {
	%orig;
	MSHookIvar<BOOL>(self, "_maintainZoomScale") = TRUE;
}

- (BOOL)maintainZoomScale {
	return TRUE;
}

- (void)setMaintainZoomScale:(BOOL)arg1 {
	%orig(TRUE);
}
%end