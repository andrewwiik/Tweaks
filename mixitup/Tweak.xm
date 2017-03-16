
@interface MPServerObject : NSObject
@end

@interface MPMusicPlayerControllerServerInternal : MPServerObject
- (void)_endPlayback;
- (void)play;
- (void)shuffleMusic;
@end
@interface MPUTransportControlMediaRemoteController : NSObject
- (int)handleTapOnControlType:(int)arg1;
@end

static id MusicSharedRemote;
MPMusicPlayerControllerServerInternal* SharedMusicPlayer;

%hook MPUTransportControlMediaRemoteController
- (id)initWithTransportControlsView:(id)arg1 transportControlsCount:(unsigned int)arg2 {
    MusicSharedRemote = %orig;
    return MusicSharedRemote;
}
%end

%hook MPMusicPlayerControllerServerInternal
-(id)init {
    SharedMusicPlayer = %orig;
    return SharedMusicPlayer;
}
%new
-(void)shuffleMusic {
    [self _endPlayback];
    [MusicSharedRemote handleTapOnControlType:3];
}
%end
%hook UINavigationItem
- (void)setLeftBarButtonItems:(id)arg1 {
           
   NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:1];

// create a standard save button
UIBarButtonItem* refreshButton =  [[UIBarButtonItem alloc] initWithTitle:@"Shuffle" style:UIBarButtonItemStyleBordered target:SharedMusicPlayer action:@selector(shuffleMusic)];
refreshButton.image = image;
//self.navigationItem.rightBarButtonItem = refreshButton;

[buttons addObject:refreshButton];
[refreshButton release];
%orig(buttons);
}

  %end
