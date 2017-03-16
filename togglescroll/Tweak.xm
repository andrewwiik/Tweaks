static BOOL callingControlCenter;

%hook CCUIButtonStackPagingView
- (void)_organizeButtonsInPages {
	callingControlCenter = YES;
	%orig;
	callingControlCenter = NO;
}
-(void)setPagingAxis:(NSInteger)arg1 {
	%orig(0);
}
-(NSInteger)pagingAxis {
	return 0;
}
%end


extern "C" BOOL MGGetBoolAnswer(CFStringRef);
%hookf(BOOL, MGGetBoolAnswer, CFStringRef key)
{
	#define k(key_) CFEqual(key, CFSTR(key_))
	if (k("apple-internal-install")) {
		if (callingControlCenter) {
			return YES;
		}
	}
	return %orig;
}