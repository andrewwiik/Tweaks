@interface MRNowPlayingArtwork : NSObject
@end
@interface MRNowPlayingArtworkImage : MRNowPlayingArtwork
@property (nonatomic, readonly, copy) NSData *imageData;
@end
static id ArtworkImageShare;
%group Music
%hook MRNowPlayingArtworkImage
- (id)imageData {
	ArtworkImageShare = %orig;
	return ArtworkImageShare;
}
%end
%hook SKUIShareSheetActivityViewElement
-(id)image {
	return [UIImage imageWithData: ArtworkImageShare];
}

%end



%end

%ctor
{
  %init;
  if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.Music"]) {
        %init(Music);
    }
}