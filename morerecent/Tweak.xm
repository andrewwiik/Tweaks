#define PREFS_BUNDLE_ID (@"com.creatix.morerecentsettings")
NSString *maxRecentString = [[[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creatix.morerecentsettings.plist"] objectForKey:@"maxRecent"];
// id maxRecent = [[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.creatix.morerecentsettings"] objectForKey:@"maxRecent"];

// static NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:sharingd];

%hook MusicCollectionView
-(BOOL)_canScrollY {
	return NO;
}
-(BOOL)_canScrollX {
	return YES;
}
-(BOOL)isScrollEnabled {
	return YES;
}
-(void)setScrollEnabled:(BOOL)arg1 {
	%orig(YES);
}
-(BOOL)alwaysBounceVertical {
	return NO;
}
-(void)setAlwaysBounceVertical:(BOOL)arg1 {
	%orig(NO);
}
-(BOOL)bouncesVertically {
	return NO;
}
-(void)setBouncesVertically:(BOOL)arg1 {
	%orig(NO);
}
-(NSInteger)maximumGlobalItemIndex {
	return  2;//[[prefs stringForKey:@"maxRecent"] integerValue];
}
%end
%hook MusicLibraryRecentlyAddedAlbumsCollectionViewConfiguration
- (id)initWithEntityLimit:(unsigned long long)arg1 {
	//BOOL flag = [prefs boolForKey:@"AwesomeSwitch1"];
	NSLog(@"MAX COMING UP: %@", maxRecentString);
	//NSString *maxRecent = [prefs objectForKey:@"maxRecent"];
	//unsigned long long *maxRecent = [prefs objectForKey]
	// NSLog(flag ? @"Yes" : @"No");
	return %orig([maxRecentString longLongValue]);
}
- (unsigned long long)entityLimit {
	return [maxRecentString longLongValue];
}
%end