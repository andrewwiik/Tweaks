%group TWCTV
%hook TWCAppSettings
- (BOOL)forceLogin {
	return NO;
}
- (BOOL)rememberPassword {
	return YES;
}
- (BOOL)disable_proxy_detect {
	return YES;
}
- (BOOL)disable_vpn_detect {
	return YES;
}
- (BOOL)disable_jailbreak_detect {
	return YES;
}
%end
%hook TWCTVApplicationNetworkStateMonitor
- (BOOL)isInHome {
	return YES;
}
-(BOOL)shouldMonitorForOutOfHome {
	return NO;
}
%end
%hook Feature
-(BOOL)isOutOfHomeFeature {
	return NO;
}
%end
%end
%group WatchESPN
%hook CSComScore
+(BOOL)isJailbroken {
	return NO;
}
%end
%hook UIStatusBarLayoutManager
- (id)_itemViews {
	return %orig;
}
%end
%hook CSCore
-(BOOL)isJailBroken {
	return NO;
}
%end
%end
%ctor
{
  %init;
  if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.timewarnercable.simulcast"]) {
	%init(TWCTV);
    }
  if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.espn.WatchESPN"]) {
	%init(WatchESPN);
    }
}