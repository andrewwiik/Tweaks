@interface MPUNowPlayingController : NSObject
-(UIImage *)currentNowPlayingArtwork;
@end
@interface MPInfoProvider : NSObject
-(MPUNowPlayingController *)nowPlayingController;
@end

%hook MPInfoProvider
-(UIImage *)albumArtwork {
return [[self nowPlayingController] currentNowPlayingArtwork];
}
-(void)setAlbumArtwork:(UIImage *)arg1 {
%orig([[self nowPlayingController] currentNowPlayingArtwork]);
}
%end