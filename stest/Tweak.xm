static id model;

%hook SPTNowPlayingBarModel
- (id)initWithPlayer:(id)arg1 collection:(id)arg2 nowPlayingModel:(id)arg3 featureFlags:(id)arg4 localSettings:(id)arg5 productState:(id)arg6 runningTestManager:(id)arg7 {
	model = %orig;
	return model;
}
%end
%hook SpotifyAppDelegate
- (void)applicationDidEnterBackground:(id)arg1 {
	%orig;
	[model resume];
}
%end