#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMediaPropertyPredicate.h>

@interface MPMusicPlayerControllerServerInternal : NSObject
-(MPMediaItem *)nowPlayingItem;
- (void)setQueueWithQuery:(id)arg1;
- (void)setQueueWithQuery:(id)arg1 firstItem:(id)arg2;
@end
@interface MusicApplicationDelegate
-(id)currentAlbum;
@end
MPMusicPlayerControllerServerInternal* MPMusicPlayerControllerServerInternalShared;
%hook MPMusicPlayerControllerServerInternal
-(id)init {
	MPMusicPlayerControllerServerInternalShared = %orig;
	return MPMusicPlayerControllerServerInternalShared;
}
%end
%hook MusicApplicationDelegate
-(BOOL)application:(id)arg1 openURL:(NSURL *)arg2 sourceApplication:(id)arg3 annotation:(id)arg4 {
	%orig;
	[self currentAlbum];
	return %orig;
}
%new
-(id)currentAlbum {
MPMediaItem *currentlyPlayingSong = [MPMusicPlayerControllerServerInternalShared nowPlayingItem];
NSString *currentPlayingAlbum   = [currentlyPlayingSong valueForProperty:MPMediaItemPropertyAlbumTitle];
MPMediaPropertyPredicate *albumNamePredicate = [MPMediaPropertyPredicate predicateWithValue:currentPlayingAlbum forProperty:MPMediaItemPropertyAlbumTitle];
MPMediaQuery *currentAlbumQuery = [[MPMediaQuery alloc] init];
[currentAlbumQuery addFilterPredicate: albumNamePredicate];
MPMusicPlayerController *player = [MPMusicPlayerController iPodMusicPlayer];
[player setQueueWithQuery:currentAlbumQuery firstItem:currentlyPlayingSong];
[player play];
return currentAlbumQuery;
// return currentPlayingAlbum;
}
%end

