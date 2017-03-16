static BOOL forceTouchEnabled = YES;

%hook NCNotificationListCellActionButtonsView
+(id)_actionButtonDescriptionsForNotificationRequest:(id)arg1 cell:(id)arg2  {
	forceTouchEnabled = NO;
	id orig = %orig;
	forceTouchEnabled = YES;
	return orig;
}
%end



extern "C" BOOL _NCForceTouchEnabled();
%hookf(BOOL, _NCForceTouchEnabled)
{
	return forceTouchEnabled;
}