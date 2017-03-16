#import <UIKit/UIKit.h> // We need to Import UJIKIt
#import <CoreGraphics/CoreGraphics.h> // We need to Also Import the CoreGraphics Framework
#import <QuartzCore/QuartzCore.h> // and the QuartzCore Framework
#import <MediaPlayer/MediaPlayer.h> // and the QuartzCore Framework

@interface MPUEffectView : UIView
@end

@interface MPUTransportControlsView : UIView
@end

@interface MusicPlaybackProgressSliderView : UIView
@end

@interface MusicNowPlayingTitlesView : UIView
@end

@interface MPUBlurEffectView : MPUEffectView
@end

@interface MPUVibrantContentEffectView : MPUEffectView
@end

@interface MusicNowPlayingItemViewController : UIViewController
-(void)layoutLandscape;
-(id)artworkView;
- (id)artworkImage;
@end

@interface MusicArtworkView : UIImageView
@end

@interface MusicNowPlayingViewController : UIViewController
@property (nonatomic, readonly) MusicNowPlayingItemViewController *currentItemViewController;
@property (nonatomic, readonly) MPUTransportControlsView *secondaryTransportControls;
@property (nonatomic, readonly) MPUTransportControlsView *transportControls;
@property (nonatomic, readonly) UIView *currentItemViewControllerContainerView;
@property (nonatomic, retain) MPUBlurEffectView *backgroundView;
@property (nonatomic, readonly) MusicPlaybackProgressSliderView *playbackProgressSliderView;
@property (nonatomic, readonly) MusicNowPlayingTitlesView *titlesView;
@property (nonatomic, retain) MPUVibrantContentEffectView *vibrantEffectView;
-(void)layoutLandscape;
@end

MusicNowPlayingViewController* BigView;

%hook MusicNowPlayingItemViewController
%new
-(id)artworkView {
	return MSHookIvar<id>(self, "_imageView");
}
- (void)viewWillAppear:(BOOL)arg1 {
   UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(orientation)){
        [self layoutLandscape];
    }
    else if (UIDeviceOrientationIsPortrait(orientation)){
       %orig;
    }
}
%new
-(void)layoutLandscape {
	self.view.frame = CGRectMake(BigView.view.frame.size.height /2,BigView.view.frame.size.height /2,BigView.view.frame.size.height,BigView.view.frame.size.height);
}
%end
%hook MusicNowPlayingViewController
- (void)ViewDidLayoutSubviews {
	BigView = self;
   UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(orientation)){
    	%orig;
        [self layoutLandscape];
    }
    else if (UIDeviceOrientationIsPortrait(orientation)){
       %orig;
    }
}
%new
-(void)layoutLandscape {
	UIImageView *imgView = [[UIImageView alloc] initWithImage:[self.currentItemViewController artworkImage]];
	imgView.frame = CGRectMake(0,0,self.view.frame.size.height, self.view.frame.size.height);
	[self.view addSubview:imgView];

}
%end
