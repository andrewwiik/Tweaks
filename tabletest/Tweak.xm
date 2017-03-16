#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
@interface MPUContentItemIdentifierCollection : NSObject
@end
@interface MusicRemoteController : NSObject
-(int)_handleAddToLibraryCommand:(id)arg1 ;
-(int)_handleLikeCommand:(id)arg1 ;

@end
@interface MusicLibraryActionKeepLocalOperation : NSOperation
-(MPUContentItemIdentifierCollection *)_contentItemIdentifierCollection;
- (id)contentItemIdentifierCollection;
- (void)main;
-(void)download;
@end

@interface MusicContextualActionsAlertController : UIAlertController
@end
@interface MusicEntityPlaybackStatusController : NSObject
- (MPUContentItemIdentifierCollection *)_currentItemIdentifierCollection;
@end
MusicEntityPlaybackStatusController* playbackStatusController;
id object = [[NSClassFromString(@"MusicLibraryActionKeepLocalOperation") new] init];
%hook MusicEntityPlaybackStatusController

- (id)initWithPlayer:(id)arg1 {
	playbackStatusController = %orig;
	return playbackStatusController;
}
%end
%hook MusicLibraryActionKeepLocalOperation
%new
-(void)download {
MSHookIvar<id>(self, "_contentItemIdentifierCollection") = MSHookIvar<id>(playbackStatusController, "_currentItemIdentifierCollection");
MSHookIvar<NSInteger>(self, "_keepLocalValue") = 1;
}
%end
%hook MusicRemoteController
- (int)_handleLikeCommand:(id)arg1
{
	id object = [[NSClassFromString(@"MusicLibraryActionKeepLocalOperation") new] init];
	[object download];
	[object main];
	[self _handleAddToLibraryCommand:0];
	return %orig;
}
%end



