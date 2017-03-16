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

@interface MusicNowPlayingViewController : UIViewController
@property (nonatomic, readonly) MPUTransportControlsView *secondaryTransportControls;
@property (nonatomic, readonly) MPUTransportControlsView *transportControls;
@property (nonatomic, readonly) UIView *currentItemViewControllerContainerView;
@property (nonatomic, retain) MPUBlurEffectView *backgroundView;
@property (nonatomic, readonly) MusicPlaybackProgressSliderView *playbackProgressSliderView;
@property (nonatomic, readonly) MusicNowPlayingTitlesView *titlesView;
@property (nonatomic, retain) MPUVibrantContentEffectView *vibrantEffectView;
@end