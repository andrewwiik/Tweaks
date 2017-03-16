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