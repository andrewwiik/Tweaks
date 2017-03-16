#import "headers/headers.h"

NSString *currentlyPlayingURI;
NSMutableSet *explicitSongCatalog = [NSMutableSet new];

%hook SPTCoreCreateOptions
- (void)setIsTablet:(char)isTablet {
	%orig(true);
}
- (void)setEnableMftRulesForPlayer:(char)enable {
	%orig(false);
}
%end

%hook SPTAlbumTrackData
- (char)isPlayable {
	if ([self isRatedExplicit]) {
		[explicitSongCatalog addObject:[[[self trackURL].absoluteString componentsSeparatedByString:@":"] lastObject]];
		return NO;
	} else return %orig;
}
%end

%hook SPTrack
- (char)isAvailable {
	if ([self isExplicit]) {
		[explicitSongCatalog addObject:[[[self link].absoluteString componentsSeparatedByString:@":"] lastObject]];
		return NO;
	}
	else return %orig;
}
- (id)playableTrack {
	if ([self isExplicit]) {
		[explicitSongCatalog addObject:[[[self link].absoluteString componentsSeparatedByString:@":"] lastObject]];
		return nil;
	}
	else return %orig;
}
%end

%hook SPTGaiaPopupController
- (void)player:(id)arg1 stateDidChange:(id)arg2 {
	SPTPlayerImpl *player = arg1;
	SPTPlayerState *state = arg2;
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"prevent_explicit_songs"]) {
		if (state.track) {
			if (![state.track.URI.absoluteString isEqualToString:currentlyPlayingURI]) {
				NSString *songID;
				songID = [[state.track.URI.absoluteString componentsSeparatedByString:@":"] lastObject];
				if ([explicitSongCatalog containsObject:songID]) {
					currentlyPlayingURI = state.track.URI.absoluteString;	
					[player skipToNextTrackWithOptions:nil];
					%orig;
					return;
				}
				if (songID) {
					NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.spotify.com/v1/tracks/%@",songID]]];
					NSError *error = nil;
					if (data) {
						NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&error]; 
						if (response) {
							if ([response objectForKey:@"explicit"]) {
								if ([[response objectForKey:@"explicit"] boolValue] == TRUE) {
									currentlyPlayingURI = state.track.URI.absoluteString;
									[explicitSongCatalog addObject:[[state.track.URI.absoluteString componentsSeparatedByString:@":"] lastObject]];
									[player skipToNextTrackWithOptions:nil];
									%orig;
									return;
								}
							}
						}
					}
				}
			}
			currentlyPlayingURI = state.track.URI.absoluteString;
		}
	}
	%orig;
}
%end
%hook SPTNowPlayingManagerImplementation
- (void)player:(id)arg1 stateDidChange:(id)arg2 {
	SPTPlayerImpl *player = arg1;
	SPTPlayerState *state = arg2;
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"prevent_explicit_songs"]) {
		if (state.track) {
			if (![state.track.URI.absoluteString isEqualToString:currentlyPlayingURI]) {
				NSString *songID;
				songID = [[state.track.URI.absoluteString componentsSeparatedByString:@":"] lastObject];
				if (songID) {
					NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.spotify.com/v1/tracks/%@",songID]]];
					NSError *error = nil;
					if (data) {
						NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&error]; 
						if (response) {
							if ([response objectForKey:@"explicit"]) {
								if ([[response objectForKey:@"explicit"] boolValue] == TRUE) {
									currentlyPlayingURI = state.track.URI.absoluteString;
									[player skipToNextTrackWithOptions:nil];
									%orig;
									return;
								}
							}
						}
					}
				}
			}
			currentlyPlayingURI = state.track.URI.absoluteString;
		}
	}
	%orig;
}
%end

%hook UnplayableTracksSettingsSection
%property (nonatomic, retain) SettingsSwitchTableViewCell *playExplicitCell;
- (id)initWithSettingsViewController:(id)settingsController {
	UnplayableTracksSettingsSection *orig = %orig;
	orig.playExplicitCell = [[NSClassFromString(@"SettingsSwitchTableViewCell") alloc] initWithTitle:@"Prevent Explicit Songs"
																						 switchValue:[[NSUserDefaults standardUserDefaults] boolForKey:@"prevent_explicit_songs"]
																						 target:orig
																						 action:@selector(playExplicitSongsChanged:)
																						 reuseIdentifier:@"SwitchTableViewCell"];
	return orig;
}

-(NSInteger)numberOfRows {
	return 2;
}
-(id)cellForRow:(NSInteger)row {
	if (row == 0) return %orig;
	else return self.playExplicitCell;
}
%new
- (void)playExplicitSongsChanged:(UISwitch *)toggle {
	[[NSUserDefaults standardUserDefaults] setBool:[toggle isOn] forKey:@"prevent_explicit_songs"];
}
%end

NSString *previousQueryString = nil;


%hook SPTQueueViewModelImplementation
- (id)initWithPlayer:(id)arg1 productState:(id)arg2 playbackDelegateRegistry:(id)arg3 entityDecorationController:(id)arg4 logCenter:(id)arg5 {
	SPTQueueViewModelImplementation *orig = %orig;
	[orig enableUpdates];
	return orig;
}

- (void)player:(id)arg1 stateDidChange:(id)arg2 fromState:(id)arg3 {
	%orig;
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"prevent_explicit_songs"]) {
		NSMutableArray *trackObjects = [NSMutableArray new];
		NSMutableArray *trackObjectsCopy = [NSMutableArray new];
		NSMutableSet *tracks = [NSMutableSet new];
		NSMutableSet *explicitTrackIDs = [NSMutableSet new];
		NSMutableArray *explicitTracks = [NSMutableArray new];
		[trackObjects addObjectsFromArray:[[self dataSource] futureTracks]];
		[trackObjects addObjectsFromArray:[[self dataSource] upNextTracks]];
		for (SPTQueueTrackImplementation *track in trackObjects) {
			if ([explicitSongCatalog containsObject:[[[track trackURI].absoluteString componentsSeparatedByString:@":"] lastObject]]) {
				[explicitTracks addObject:track];
			} else {
				[tracks addObject:[[[track trackURI].absoluteString componentsSeparatedByString:@":"] lastObject]];
				[trackObjectsCopy addObject:track];
			}
		}
		if ([tracks count] > 0) {
			NSString *queryString = [[tracks allObjects] componentsJoinedByString:@","];
			if (![queryString isEqualToString:previousQueryString]) {
				NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.spotify.com/v1/tracks?ids=%@",queryString]]];
				NSError *error = nil;
				if (data) {
					NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&error]; 
					if (response) {
						NSMutableArray *songs = (NSMutableArray *)[response objectForKey:@"tracks"];
						for (NSMutableDictionary *song in songs) {
							if ([[song objectForKey:@"explicit"] boolValue] == TRUE) {
								[explicitTrackIDs addObject:[song objectForKey:@"id"]];
								[explicitSongCatalog addObject:[song objectForKey:@"id"]];
							}
						}
						for (SPTQueueTrackImplementation *track in trackObjectsCopy) {
							if ([explicitTrackIDs containsObject:[[[track trackURI].absoluteString componentsSeparatedByString:@":"] lastObject]]) {
								[explicitTracks addObject:track];
							}
						}
						if ([explicitTracks count] > 0) {
							[self removeTracks:[explicitTracks copy]];
						}
					}
				}
				previousQueryString = queryString;
			}
		}
	}
}
%end


