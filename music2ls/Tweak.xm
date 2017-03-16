#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#include <dlfcn.h>

@class MPUSystemMediaControlsViewController;
@interface NowPlayingArtPluginController : NSObject
- (id)view;
- (id)artworkView;
@end
@interface MPUSystemMediaControlsViewController : NSObject
- (id)view;
@end
@interface MPUTransportControlMediaRemoteController : NSObject
- (int)handleTapOnControlType:(int)arg1;
@end

@interface _NowPlayingArtView : UIView
- (UIImageView *)artworkView;
@end
@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (UIImage *)artwork;
- (BOOL)isPlaying;
- (BOOL)play;
- (BOOL)Pause;
- (BOOL)hasTrack;
- (BOOL)_sendMediaCommand:(unsigned)command;
- (BOOL)skipFifteenSeconds:(int)seconds;
@end
@interface SBUIController : NSObject
+ (instancetype)sharedInstance;
- (void)setLockscreenArtworkImage:(UIImage *)artworkImage;
- (void)updateLockscreenArtwork;
@end
@interface MPUSystemMediaControlsViewController (lsartworkcontrol) <UIGestureRecognizerDelegate>
- (void)lsartworkcontrol_leftSwipeRecognized:(UISwipeGestureRecognizer *)sender;
- (void)lsartworkcontrol_rightSwipeRecognized:(UISwipeGestureRecognizer *)sender;
- (void)lsartworkcontrol_leftDoubleSwipeRecognized:(UILongPressGestureRecognizer *)sender;
- (void)lsartworkcontrol_rightDoubleSwipeRecognized:(UILongPressGestureRecognizer *)sender;
@end
@interface MPUTransportControl : UIView
@end
@interface MPUTransportControlsView : UIView
- (MPUTransportControl *)availableTransportControlWithType:(NSInteger)type; // Available Media Remote Commands
@end
@interface NowPlayingArtPluginController (lsartworkcontrol) <UIGestureRecognizerDelegate>
- (void)lsartworkcontrol_doubleTapRecognized:(UITapGestureRecognizer *)sender;
@end
%ctor {
    dlopen("/System/Library/SpringBoardPlugins/NowPlayingArtLockScreen.lockbundle/NowPlayingArtLockScreen", 2);
    }

static UISwipeGestureRecognizer *lsartworkcontrolLeftSwipeGestureRecognizer, *lsartworkcontrolRightSwipeGestureRecognizer, *lsartworkcontrolLeftDoubleSwipeGestureRecognizer, *lsartworkcontrolRightDoubleSwipeGestureRecognizer;
static UITapGestureRecognizer *lsartworkcontrolDoubleTapGestureRecognizer;
static id MusicSharedRemote;
%hook MPUTransportControlMediaRemoteController
- (id)initWithTransportControlsView:(id)arg1 transportControlsCount:(unsigned int)arg2 {
	MusicSharedRemote = %orig;
	return MusicSharedRemote;
}
%end
%hook MPUSystemMediaControlsViewController
-(void)loadView {
	%orig();	
		lsartworkcontrolLeftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lsartworkcontrol_leftSwipeRecognized:)];
		lsartworkcontrolRightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lsartworkcontrol_rightSwipeRecognized:)];
		lsartworkcontrolLeftDoubleSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lsartworkcontrol_leftDoubleSwipeRecognized:)];
		lsartworkcontrolRightDoubleSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lsartworkcontrol_rightDoubleSwipeRecognized:)];

		lsartworkcontrolLeftDoubleSwipeGestureRecognizer.direction =
		lsartworkcontrolLeftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

		lsartworkcontrolRightDoubleSwipeGestureRecognizer.direction =
		lsartworkcontrolRightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
		lsartworkcontrolLeftDoubleSwipeGestureRecognizer.numberOfTouchesRequired = 2;
		lsartworkcontrolRightDoubleSwipeGestureRecognizer.numberOfTouchesRequired = 2;

		[self.view addGestureRecognizer:lsartworkcontrolLeftDoubleSwipeGestureRecognizer];
		[self.view addGestureRecognizer:lsartworkcontrolLeftSwipeGestureRecognizer];
		[self.view addGestureRecognizer:lsartworkcontrolRightDoubleSwipeGestureRecognizer];
		[self.view addGestureRecognizer:lsartworkcontrolRightSwipeGestureRecognizer];


		[lsartworkcontrolLeftSwipeGestureRecognizer release];
		[lsartworkcontrolRightSwipeGestureRecognizer release];
		[lsartworkcontrolLeftDoubleSwipeGestureRecognizer release];
		[lsartworkcontrolRightDoubleSwipeGestureRecognizer release];
		NSLog(@"[lsartworkcontrol] Added gesture recognizers in %@ (%@) for swipe recognition", self, self.view);
}

%new
- (void)lsartworkcontrol_leftSwipeRecognized:(UISwipeGestureRecognizer *)sender { 
	if (sender.state == UIGestureRecognizerStateEnded) {
		[MusicSharedRemote handleTapOnControlType:1];
		// [MusicSharedRemote handleTapOnControlType:4];
		NSLog(@"Skip, number 1");
	}
}

%new
- (void)lsartworkcontrol_rightSwipeRecognized:(UISwipeGestureRecognizer *)sender { 
	if (sender.state == UIGestureRecognizerStateEnded) {
		[MusicSharedRemote handleTapOnControlType:4];
		// [MusicSharedRemote handleTapOnControlType:1];
		NSLog(@"Skip, number 2");

	}
}

%new
- (void)lsartworkcontrol_leftDoubleSwipeRecognized:(UISwipeGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateEnded) {
		[[%c(SBMediaController) sharedInstance] skipFifteenSeconds:-15];
		NSLog(@"15 seconds back");
	}
}

%new
- (void)lsartworkcontrol_rightDoubleSwipeRecognized:(UISwipeGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateEnded) {
		[[%c(SBMediaController) sharedInstance] skipFifteenSeconds:+15];
		NSLog(@"15 seconds forward");
	}
}
%end
%hook NowPlayingArtPluginController
-(void)loadView {
	%orig();	
		lsartworkcontrolDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lsartworkcontrol_doubleTapRecognized:)];

		lsartworkcontrolDoubleTapGestureRecognizer.numberOfTapsRequired = 2; 

		[self.view addGestureRecognizer:lsartworkcontrolDoubleTapGestureRecognizer];

		[lsartworkcontrolDoubleTapGestureRecognizer release];
		NSLog(@"[lsartworkcontrol] Added gesture recognizers in %@ (%@) for swipe recognition", self, self.view);
}
%new
- (void)lsartworkcontrol_doubleTapRecognized:(UITapGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateEnded) {
		[MusicSharedRemote handleTapOnControlType:6];
	}
}
%end
@interface VolumeControl : NSObject
- (float)getMediaVolume;
- (float)volumeStepUp;
- (float)volume;
-(void)setMediaVolume:(float)arg1;
@end
%hook VolumeControl
- (void)decreaseVolume {
	%orig;
	if (![[%c(SBMediaController) sharedInstance] isPlaying])
		return;
	if ([self volume] <= 0.0)
		[[%c(SBMediaController) sharedInstance] pause];
}
- (void)increaseVolume {
	%orig;
	if (![[%c(SBMediaController) sharedInstance] hasTrack])
	return;
	if ([[%c(SBMediaController) sharedInstance] hasTrack])
	[[%c(SBMediaController) sharedInstance] play];
	if ([self volume] > [self volumeStepUp])
		return; 
}
%end



