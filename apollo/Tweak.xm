#import <UIKit/UIKit.h> // We need to Import UJIKIt
#import <CoreGraphics/CoreGraphics.h> // We need to Also Import the CoreGraphics Framework
#import <QuartzCore/QuartzCore.h> // and the QuartzCore Framework
#import <MediaPlayer/MediaPlayer.h> // and the QuartzCore Framework
#import "MediaRemote.h"



@interface SUNavigationBar : UINavigationBar
@end

@interface SKUIScrollingTabNavigationBar : SUNavigationBar
@end

@interface MusicNavigationBar : SKUIScrollingTabNavigationBar
- (UINavigationController *)_musicNavigationController;
@property (nonatomic, retain) UINavigationController *musicNavigationController;
- (id)musicNavigationController;

@end

@interface MusicSwitcherButtonContainerView : UIView
@end

@interface MusicLibrarySplitViewController : UIViewController
@end

@interface MusicLibraryBrowseCollectionViewController : UIViewController
@end

@interface MusicUpNextAggregateDataSource : NSObject
@end

@interface MusicUpNextViewController : UIViewController
@end

@interface MPUNowPlayingTitlesView : UIView // The Titles View for the Control Center and LockScreen
// -(void)slideFromRight; 
// -(void)slideFromLeft;
// -(void)slideOutToLeft;
- (id)initWithFrame:(CGRect)arg1;
@end

@interface MusicArtworkView : UIImageView // Artwork View in the Music App
@end

@interface MPUMediaControlsTitlesView : MPUNowPlayingTitlesView // Titles View for Control Conter and Lock Screen
@property (nonatomic, readonly) int mediaControlsStyle;
- (int)mediaControlsStyle;
@end

@interface MPUMediaControlsControlCenterTitlesView : MPUMediaControlsTitlesView
@end

@class MusicNowPlayingItemViewController;

@interface SKUICollectionViewCell : UICollectionViewCell
@end

@interface SKUIViewReuseCollectionViewCell : SKUICollectionViewCell
@end

@interface SKUICardViewElementCollectionViewCell : SKUIViewReuseCollectionViewCell
@end

@interface SKUIViewReuseView : UIView
@end

@interface SKUIHorizontalLockupView : SKUIViewReuseView
@property (nonatomic, retain) UIView *metadataBackgroundView;
- (id)metadataBackgroundView;
@end
@interface SKUIHorizontalLockupCollectionViewCell : SKUICollectionViewCell 
- (SKUIHorizontalLockupView *)_lockupView;
@end

@interface MPUTransportButton : UIButton
@end

@interface MusicRemoteController : NSObject 
- (int)_handleAddToLibraryCommand:(id)arg1; //Add to My Music on double tap
- (int)_handleLikeCommand:(id)arg1; // Like Track Music Remote Command
@end

@interface MusicNowPlayingTitlesView : UIView
@end

@interface MPUTransportControl : UIView
-(void)setEnabled:(BOOL)arg1;
@end

@interface MPUTransportControlsView : UIView
- (MPUTransportControl *)availableTransportControlWithType:(NSInteger)type; // Available Media Remote Commands
@end

@interface MPAVController : NSObject
@property (nonatomic, readwrite) NSTimeInterval currentTime; // Current Time in Song
- (void)togglePlayback; // Toggle Play/Pause
- (void)changePlaybackIndexBy:(CGFloat)index; // Change where you are in the Queue
@end
@interface MPUAVPlayer : MPAVController
@end

@interface RURadioAVPlayer : MPUAVPlayer
@end

@interface MusicAVPlayer : RURadioAVPlayer
@property (nonatomic, readwrite) NSTimeInterval currentTime; // Current time in song
- (BOOL)isSeekingOrScrubbing; // Is the user seekings in the song
- (void)beginSeek:(NSInteger)direction; // Start seeking in the song
- (void)endSeek; // Stop Seeking
- (void)togglePlayback; // Toggle Play/Pause
- (void)changePlaybackIndexBy:(CGFloat)index; // Change where you are in the Queue
@end

@interface MPUTransportControlMediaRemoteController : NSObject // Just needed
- (int)handleTapOnControlType:(int)arg1;
- (void)performAction:(int)arg1;
- (void)onView:(id)arg1 performAction:(int)arg1;
@end

@interface MusicMiniPlayerViewController : UIViewController // MiniPlayer
@property (nonatomic, readonly) MusicNowPlayingTitlesView *titlesView;
  - (MPAVController *)player; //Music Player
  - (MPUTransportControlMediaRemoteController *)transportControlMediaRemoteController; // Media Commands Controller
  - (MPUTransportControlsView *)transportControlsView; // View used for the selector "tapOnControlType"
  - (void)transportControlsView:(MPUTransportControlsView *)view tapOnControlType:(NSInteger)type; // method we use to call media commands in the Mini Player
  - (id)titlesView;

@end

@interface MusicNowPlayingViewController : UIViewController // Now Playing View
@property (nonatomic, readonly) MusicNowPlayingItemViewController *currentItemViewController;
@property (nonatomic, readonly) CAGradientLayer *statusBarLegibilityGradient;
- (MusicAVPlayer *)player; // Music Player
- (MusicNowPlayingItemViewController *)currentItemViewController; // Subview of the Now Playing View
- (MPUTransportControlsView *)transportControls; // Buttons for actions, We use this for the selector "tapOnControlType"
- (void)transportControlsView:(MPUTransportControlsView *)view tapOnControlType:(NSInteger)type; // method we call to send Media Commands
-(id)statusBarLegibilityGradient;
@end

@interface MusicNowPlayingItemViewController : UIViewController
@property (nonatomic, retain) UIImageView *artworkImage;
@property (nonatomic, retain) UIImage *image;
- (MusicArtworkView *) _imageView;
- (UIImage *) _artworkImage;
- (id)artworkImage;
@end

@interface MusicNowPlayingViewController (artworkcontrol) <UIGestureRecognizerDelegate> //Now Playing View Gesture Recognizers
- (void)artworkcontrol_leftSwipeRecognized:(UISwipeGestureRecognizer *)sender; // Swipe Left
- (void)artworkcontrol_rightSwipeRecognized:(UISwipeGestureRecognizer *)sender; // Swipe Right
- (void)artworkcontrol_leftDoubleSwipeRecognized:(UILongPressGestureRecognizer *)sender; // Swipe with two fingers to the Left
- (void)artworkcontrol_rightDoubleSwipeRecognized:(UILongPressGestureRecognizer *)sender; // Swipe with two fingers to the right 
- (void)artworkcontrol_doubleTapRecognized:(UITapGestureRecognizer *)sender; // Double Tap 
@end

@interface MusicMiniPlayerViewController (miniplayer) <UIGestureRecognizerDelegate> // MiniPlayer View Gesture Commands
- (void)miniplayer_PanGestureRecognized:(UIPanGestureRecognizer *)sender; //Universal Pan Gesture to determine Direction
- (void)handleUpwardsGesture:(UIPanGestureRecognizer *)sender;  // Pan Upwards
- (void)handleDownwardsGesture:(UIPanGestureRecognizer *)sender; // Pan Downwards
- (void)handleLeftGesture:(UIPanGestureRecognizer *)sender; //Pan Left
- (void)handleRightGesture:(UIPanGestureRecognizer *)sender; //Pan Right
@end

@class MPUSystemMediaControlsViewController;

@interface NowPlayingArtPluginController : NSObject
- (id)view;
- (id)artworkView;
@end

@interface MPUSystemMediaControlsViewController : UIViewController
@property (nonatomic, readonly) int style;
- (void)_launchFirstPartyMusicAppForShareCommand;
- (void)_launchCurrentNowPlayingApp;
@end

@interface _NowPlayingArtView : UIView
- (UIImageView *)artworkView;
@end

@interface SBUIController : NSObject
+ (instancetype)sharedInstance;
- (void)setLockscreenArtworkImage:(UIImage *)artworkImage;
- (void)updateLockscreenArtwork;
@end


@interface MPUMediaControlsControlCenterTitlesView (lsartworkcontrol) <UIGestureRecognizerDelegate>
- (void)lsartwork_PanGestureRecognized:(UIPanGestureRecognizer *)sender;
- (void)handleUpwardsGesture:(UIPanGestureRecognizer *)sender;  // Pan Upwards
- (void)handleDownwardsGesture:(UIPanGestureRecognizer *)sender; // Pan Downwards
- (void)handleLeftGesture:(UIPanGestureRecognizer *)sender; //Pan Left
- (void)handleRightGesture:(UIPanGestureRecognizer *)sender; //Pan Right
- (void)lsartworkcontrol_doubleTapRecognized:(UITapGestureRecognizer *)sender;
@end

@interface KHSwitcherMusicControlsView : UIView
- (UIView *)infoView;
@end

@interface MPServerObject : NSObject
@end

@interface infoView : UIView
@end

@interface KHSwitcherMusicControlsView (lsartworkcontrol) <UIGestureRecognizerDelegate>
- (void)lsartwork_PanGestureRecognized:(UIPanGestureRecognizer *)sender;
- (void)handleUpwardsGesture:(UIPanGestureRecognizer *)sender;  // Pan Upwards
- (void)handleDownwardsGesture:(UIPanGestureRecognizer *)sender; // Pan Downwards
- (void)handleLeftGesture:(UIPanGestureRecognizer *)sender; //Pan Left
- (void)handleRightGesture:(UIPanGestureRecognizer *)sender; //Pan Right
@end

@interface NowPlayingArtPluginController (lsartworkcontrol) <UIGestureRecognizerDelegate>
- (void)lsartworkcontrol_doubleTapRecognized:(UITapGestureRecognizer *)sender;
@end

@interface MPMusicPlayerControllerServerInternal : MPServerObject
- (void)_endPlayback;
- (void)play;
- (void)shuffleMusic;
@end

@interface MPUSystemMediaControlsView : UIView
@property (nonatomic, readonly) MPUMediaControlsTitlesView *trackInformationView;
@end

@interface SBControlCenterSectionViewController : UIViewController
-(id)view;
@end

@interface SBCCMediaControlsSectionController : SBControlCenterSectionViewController
-(void)showMediaPicker;
@end

@interface SBCCMediaControlsSectionController (ControlCenter) <UIGestureRecognizerDelegate>
- (void)ControlCenter_leftSwipeRecognized:(UISwipeGestureRecognizer *)sender;
- (void)ControlCenter_rightSwipeRecognized:(UISwipeGestureRecognizer *)sender;
- (void)ControlCenter_leftDoubleSwipeRecognized:(UILongPressGestureRecognizer *)sender;
- (void)ControlCenter_rightDoubleSwipeRecognized:(UILongPressGestureRecognizer *)sender;
- (void)ControlCenter_longPressRecognized:(UILongPressGestureRecognizer *)sender;
- (void)ControlCenter_shortPressRecognized:(UILongPressGestureRecognizer *)sender;
- (void)ControlCenter_doubleTapRecognized:(UILongPressGestureRecognizer *)sender;
@end

@interface MPUSystemMediaControlsViewController (LockScreen) <UIGestureRecognizerDelegate>
- (void)LockScreen_leftSwipeRecognized:(UISwipeGestureRecognizer *)sender;
- (void)LockScreen_rightSwipeRecognized:(UISwipeGestureRecognizer *)sender;
- (void)LockScreen_longPressRecognized:(UILongPressGestureRecognizer *)sender;
- (void)LockScreen_shortPressRecognized:(UILongPressGestureRecognizer *)sender;
- (void)LockScreen_doubleTapRecognized:(UILongPressGestureRecognizer *)sender;
@end

@interface SBMediaController
+ (instancetype)sharedInstance;
- (void)decreaseVolume;
- (void)increaseVolume;
- (UIImage *)artwork;
- (BOOL)isPlaying;
- (BOOL)Pause;
- (BOOL)hasTrack;
- (BOOL)_sendMediaCommand:(unsigned)command;
- (BOOL)skipFifteenSeconds:(int)seconds;
@end

@interface MusicNowPlayingAtmosphericStatusBar : UIView
@end

@interface MusicApplicationDelegate : UIResponder
-(void)_switchToTabWithIdentifier:(id)arg1 completion:(id)arg2;
-(void)_updateTabBarItemsAnimated:(BOOL)arg1;
@end

@interface MusicUserInterfaceStatusController : NSObject
-(id)tabArray;
@end

@interface SKUICrossFadingTabBar : UIView
@property (nonatomic, copy) NSArray *tabBarButtons;
- (id)tabBarButtons;
@end

static BOOL kEnabled; // Everything Enabled
static BOOL kGesturesEnabled; // Gestures Enabled
static BOOL kNowPlayingGestures; // Now Playing Gestures Enabled
static BOOL kMiniPlayerGestures; // Mini Player Gestures
static BOOL kScrubberTransport; // Hide the Scrubber Bar
static BOOL kVolumeSlider; // Hide the Volume Slider
static BOOL kMPSeparators; // Hide Separators in the Music App
static BOOL kIndexBar; // Always Show the Alphabet on the Right Side
static BOOL kNowPlayingBlur; // Disable the Blur under the Transport Controls
static BOOL kNowPlayingFloatingArrow; // Hide the Floating Arrow in the Now Playing View
static BOOL kMPSearchDefault; // Does Search default to Apple Music or just your Music Library
static BOOL kAppleMusicBackgroundColor; // Unknown
static BOOL kAutoMusicPause; // Should Music Pause when Volume goes to 0
static BOOL kAlwaysMiniPlayer; // Should the MiniPlayer always be shown in the Music App
static BOOL kBookmarkPosition; // Should the Music App Save the position of where you were in a song
static BOOL kArtistAlbumArt; // Should We Replace Artist Image with thier coressponding Album Artwork
static BOOL kCleanAppleMusic; // Should We Clean Up that Ugly Apple Music UI
static NSInteger kNowPlayingSwipeRightAction; // What does the Now Playing View Swipe Right Action Trigger
static NSInteger kNowPlayingSwipeLeftAction; // What does the Now Playing View Swipe Left Action Trigger
static NSInteger kNowPlayingSwipeRightTwoFingersAction; // What does the Now Playing View Swipe Right with Two Fingers Action Trigger
static NSInteger kNowPlayingSwipeLeftTwoFingersAction; // What does the Now Playing View Swipe Left with Two Fingers Action Trigger
static NSInteger kNowPlayingDoubleTapAction; // What does the Now Playing View Double Tap Action Trigger
static NSInteger kMiniPlayerSwipeRightAction; // What should happen when you swipe Right on the MiniPlayer
static NSInteger kMiniPlayerSwipeLeftAction; // What should happen when you swipe left onthe MiniPlayer
static BOOL kCCGesturesEnabled; // Should we Enable Gestures for the Control Center and Lock Screen
static NSInteger kCCSwipeRightAction; // What does the CC/LS Swipe Right Action Trigger
static NSInteger kCCSwipeLeftAction; // What does the CC/LS Swipe Left Action Trigger
static NSInteger kCCDoubleTapAction; // What does the CC/LS Swipe Left Action Trigger
static NSInteger kCCShortPressAction; // What does the CC/LS Swipe Left Action Trigger
static NSInteger kCCLongPressAction; // What does the CC/LS Swipe Left Action Trigger
static NSInteger kCCSwipeRightTwoFingersAction; // What does the CC/LS Swipe Right with Two Fingers Action Trigger
static NSInteger kCCSwipeLeftTwoFingersAction; // What does the CC/LS Swipe Left with Two Fingers Action Trigger
static BOOL kLSGesturesEnabled; // Should we Enable Gestures for the Control Center and Lock Screen
static NSInteger kLSSwipeRightAction; // What does the LS/LS Swipe Right Action Trigger
static NSInteger kLSSwipeLeftAction; // What does the LS/LS Swipe Left Action Trigger
static NSInteger kLSDoubleTapAction; // What does the LS/LS Swipe Left Action Trigger
static NSInteger kLSShortPressAction; // What does the LS/LS Swipe Left Action Trigger
static NSInteger kLSLongPressAction; // What does the LS/LS Swipe Left Action Trigger
static NSInteger kLSSwipeRightTwoFingersAction; // What does the LS/LS Swipe Right with Two Fingers Action Trigger
static NSInteger kLSSwipeLeftTwoFingersAction; // What does the LS/LS Swipe Left with Two Fingers Action Trigger
static NSInteger kSBDoubleTapArtworkAction; // What Happens When the Artwork on the Lock Screen is Double Tapped
static NSInteger kAuxoLegacySwipeRightAction; // What Happens When you Swipe Right on the Titles View in Auxo Legacy
static NSInteger kAuxoLegacySwipeLeftAction; // What Happens When you Swipe Left on the Titles View in Auxo Legacy
static NSInteger kCCDoubleTapTitleAction; // What Happens When you Double Tap in the Control Center's Media Controls Section
static BOOL kNowPlayingPreviousTransport;
static BOOL kNowPlayingIntervalBackwardTransport;
static BOOL kNowPlayingPlayPauseToggleTransport;
static BOOL kNowPlayingFowardTransport;
static BOOL kNowPlayingIntervalFowardTransport;
static BOOL kNowPlayingHeartTransport;
static BOOL kNowPlayingUpNextTransport;
static BOOL kNowPlayingShareTransport;
static BOOL kNowPlayingRepeatTransport;
static BOOL kNowPlayingShuffleTransport;
static BOOL kNowPlayingContextualTransport;
static BOOL kLockScreenPreviousTransport;
static BOOL kLockScreenIntervalBackwardTransport;
static BOOL kLockScreenPlayPauseToggleTransport;
static BOOL kLockScreenFowardTransport;
static BOOL kLockScreenIntervalFowardTransport;
static BOOL kLockScreenHeartTransport;
static BOOL kLockScreenUpNextTransport;
static BOOL kLockScreenShareTransport;
static BOOL kControlCenterPreviousTransport;
static BOOL kControlCenterIntervalBackwardTransport;
static BOOL kControlCenterPlayPauseToggleTransport;
static BOOL kControlCenterFowardTransport;
static BOOL kControlCenterIntervalFowardTransport;
static BOOL kControlCenterHeartTransport;
static BOOL kControlCenterUpNextTransport;
static BOOL kControlCenterShareTransport;
static BOOL kMiniPlayerContextualTransport;
static BOOL kMiniPlayerPlayPauseToggleTransport;
static NSInteger kArtworkBlurStyle;
static NSInteger kArtworkCornerRadius;
static NSInteger kArtworkSize;
static BOOL kNowPlayingHideStatusBar;
static BOOL kNowPlayingDarkGradient;
static BOOL kMyMusicTab;
static BOOL kPlaylistsTab;
static BOOL kForYouTab;
static BOOL kGeniusMixesTab;
static BOOL kConnectTab;
static BOOL kNewTab;
static BOOL kRadioTab;
static NSInteger kStartUpTab;
#import <UIKit/UIKit.h> // We need to Import UJIKIt
#import <CoreGraphics/CoreGraphics.h> // We need to Also Import the CoreGraphics Framework
#import <QuartzCore/QuartzCore.h> // and the QuartzCore Framework
#include <dlfcn.h> // We need this to Bust Open the LS View
#import <objc/runtime.h> // I need to mess with runtime stuff too
#import "ApolloHeaders.h"



%ctor {
    dlopen("/System/Library/SpringBoardPlugins/NowPlayingArtLockScreen.lockbundle/NowPlayingArtLockScreen", 2);
    }

static UISwipeGestureRecognizer *ControlCenterLeftSwipeGestureRecognizer, *ControlCenterRightSwipeGestureRecognizer, *ControlCenterLeftDoubleSwipeGestureRecognizer, *ControlCenterRightDoubleSwipeGestureRecognizer, *artworkcontrolLeftSwipeGestureRecognizer, *artworkcontrolRightSwipeGestureRecognizer, *artworkcontrolLeftDoubleSwipeGestureRecognizer, *artworkcontrolRightDoubleSwipeGestureRecognizer, *LockScreenLeftSwipeGestureRecognizer, *LockScreenRightSwipeGestureRecognizer; // Swipe Recognizers for Now Playing View
static UIPanGestureRecognizer *miniplayerPanGestureRecognizer, *lsartworkPanGestureRecognizer; // MiniPlayer Pan Universal Gesture
static UITapGestureRecognizer *artworkcontrolDoubleTapGestureRecognizer, *lsartworkcontrolDoubleTapGestureRecognizer, *ControlCenterDoubleTapGestureRecognizer, *LockScreenDoubleTapGestureRecognizer; // Now Playing Double Tap Gesture
static UILongPressGestureRecognizer *ControlCenterShortPressGestureRecognizer, *ControlCenterLongPressGestureRecognizer, *LockScreenShortPressGestureRecognizer, *LockScreenLongPressGestureRecognizer;

static id addLibrary; // Shared Object to add a song to "My Music"
static id MusicSharedRemote; // Shared Music Remote for Sending Media Commands
MusicNowPlayingTitlesView* SharedTitlesView; // Now Playing Titles View Shared Object
MusicNowPlayingViewController* artworknoblur; // Shared Object of the Now Playing View
MusicNowPlayingItemViewController* nowplayingitem; // Shared Object of the Now Playing Album Artwork
MusicMiniPlayerViewController* MiniPlayerController;
MPMusicPlayerControllerServerInternal* SharedMusicPlayer;
MPUMediaControlsControlCenterTitlesView* CCTitlesView;
MPUSystemMediaControlsViewController* MainSystemMediaControls;
MPUMediaControlsTitlesView* LockScreenTitlesView;
SBCCMediaControlsSectionController* ControlCenterMusic;
MPMusicPlayerController *musicPlayer;
MPMediaPickerController *mediaPicker;




NSArray *testInfoObject;

%hook MPUMediaControlsTitlesView 
    - (void)layoutSubviews{
        %orig;
        LockScreenTitlesView = self;
    }
%end
%hook MPUSystemMediaControlsViewController
- (void)loadView {
    MainSystemMediaControls = self;
    %orig;
    if (self.style == 2) {
        if (kGesturesEnabled && kLSGesturesEnabled) {    
            LockScreenLeftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(LockScreen_leftSwipeRecognized:)];
            LockScreenRightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(LockScreen_rightSwipeRecognized:)];
            LockScreenLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LockScreen_longPressRecognized:)];
            LockScreenShortPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LockScreen_shortPressRecognized:)];
            LockScreenDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LockScreen_doubleTapRecognized:)];
    
            LockScreenRightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
            LockScreenLeftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
            LockScreenLongPressGestureRecognizer.minimumPressDuration = 1;
            [LockScreenShortPressGestureRecognizer requireGestureRecognizerToFail:LockScreenLongPressGestureRecognizer];
    
            LockScreenDoubleTapGestureRecognizer.numberOfTapsRequired = 2; 
    
            [self.view addGestureRecognizer:LockScreenLeftSwipeGestureRecognizer];
            [self.view addGestureRecognizer:LockScreenRightSwipeGestureRecognizer];
            [self.view addGestureRecognizer:LockScreenLongPressGestureRecognizer];
            [self.view addGestureRecognizer:LockScreenShortPressGestureRecognizer];
            [self.view addGestureRecognizer:LockScreenDoubleTapGestureRecognizer];
    
    
            [LockScreenLeftSwipeGestureRecognizer release];
            [LockScreenRightSwipeGestureRecognizer release];
            [LockScreenShortPressGestureRecognizer release];
            [LockScreenLongPressGestureRecognizer release];
            [LockScreenDoubleTapGestureRecognizer release];
        }
    }
}
- (id)transportControlsView:(id)arg1 buttonForControlType:(int)arg2 {
    if (self.style == 1) {
        switch (arg2) {
            case 1: { // Set Shuffling : Universal
                if (kControlCenterPreviousTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 2: { // Set Shuffling : Universal
                if (kControlCenterIntervalBackwardTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 3: { // Set Shuffling : Universal
                if (kControlCenterPlayPauseToggleTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 4: { // Set Shuffling : Universal
                if (kControlCenterFowardTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 5: { // Set Shuffling : Universal
                if (kControlCenterIntervalFowardTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 6: { // Set Shuffling : Universal
                if (kControlCenterHeartTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 7: { // Set Shuffling : Universal
                if (kControlCenterUpNextTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 8: { // Set Shuffling : Universal
                if (kControlCenterShareTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
        }
    }
    else if (self.style == 2) {
        switch (arg2) {
            case 1: { // Set Shuffling : Universal
                if (kLockScreenPreviousTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 2: { // Set Shuffling : Universal
                if (kLockScreenIntervalBackwardTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 3: { // Set Shuffling : Universal
                if (kLockScreenPlayPauseToggleTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 4: { // Set Shuffling : Universal
                if (kLockScreenFowardTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 5: { // Set Shuffling : Universal
                if (kLockScreenIntervalFowardTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 6: { // Set Shuffling : Universal
                if (kLockScreenHeartTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 7: { // Set Shuffling : Universal
                if (kLockScreenUpNextTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
    
            case 8: { // Set Shuffling : Universal
                if (kLockScreenShareTransport) {
                    return NULL;
                }
                else {
                    return %orig;
                }
                break;
            }
        }
    }
    return %orig;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
        return ![touch.view isKindOfClass:[UIButton class]];
    }
%new
- (void)LockScreen_leftSwipeRecognized:(UISwipeGestureRecognizer *)sender { 
    if (sender.state == UIGestureRecognizerStateEnded) {
        [MusicSharedRemote  onView:@"LockScreenSpringBoard" performAction:kLSSwipeLeftAction];
    }
}

%new
- (void)LockScreen_rightSwipeRecognized:(UISwipeGestureRecognizer *)sender { 
    if (sender.state == UIGestureRecognizerStateEnded) {
        [MusicSharedRemote  onView:@"LockScreenSpringBoard" performAction:kLSSwipeRightAction];

    }
}

%new
- (void)LockScreen_leftDoubleSwipeRecognized:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [MusicSharedRemote  onView:@"LockScreenSpringBoard" performAction:kLSSwipeLeftTwoFingersAction];
    }
}

%new
- (void)LockScreen_rightDoubleSwipeRecognized:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [MusicSharedRemote  onView:@"LockScreenSpringBoard" performAction:kLSSwipeRightTwoFingersAction];
    }
}
%new
- (void)LockScreen_longPressRecognized:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [MusicSharedRemote  onView:@"LockScreenSpringBoard" performAction:kLSLongPressAction];
        NSLog(@"Long Press LS");
    }
}
%new
- (void)LockScreen_shortPressRecognized:(UISwipeGestureRecognizer *)sender {
    [MusicSharedRemote  onView:@"LockScreenSpringBoard" performAction:kLSShortPressAction];
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Short Press LS");
    }
}
%new
- (void)LockScreen_doubleTapRecognized:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [MusicSharedRemote  onView:@"LockScreenSpringBoard" performAction:kLSDoubleTapAction];
        NSLog(@"Double Tap LS");
    }
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
%hook MPUTransportControlMediaRemoteController
- (id)initWithTransportControlsView:(id)arg1 transportControlsCount:(unsigned int)arg2 {
    MusicSharedRemote = %orig;
    return MusicSharedRemote;
}
%new
-(void)performAction:(int)arg1 {
    return;
}
- (int)handleTapOnControlType:(int)arg1 {
	NSLog(@"We are Checking for Errors");
	return %orig;
}
%new
-(void)onView:(id)arg1 performAction:(int)arg2 {
    if ([arg1 isEqual: @"NowPlayingMusicApp"]) {
        switch (arg2) { // Next Song ~ Now Playing : Music App
                case 2: {
                    CGRect frame = SharedTitlesView.frame;
                    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * -1, SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height); } completion:^(BOOL finished){
                        [MusicSharedRemote handleTapOnControlType:1];
                        SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * 1 ,SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height);
                        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = frame; } completion:^(BOOL finished){}];}];
                    break;
                }

                case 1: { // Previous Song ~ Now Playing : Music App
                    CGRect frame = SharedTitlesView.frame;
                    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * 1,SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height); } completion:^(BOOL finished){
                        MRMediaRemoteSendCommand(kMRNextTrack, nil);
                        NSLog(@"Double Skip");
                        SharedTitlesView.frame = CGRectMake(SharedTitlesView.frame.size.width * -1 ,SharedTitlesView.frame.origin.y, SharedTitlesView.frame.size.width, SharedTitlesView.frame.size.height);
                        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ SharedTitlesView.frame = frame; } completion:^(BOOL finished){}];}];  
                    break;
                }

                case 3: { // 15 seconds forward : Universal
                    [MusicSharedRemote handleTapOnControlType:5];
                        break;
                }

                case 4: { // 15 seconds rewind : Universal
                    [MusicSharedRemote handleTapOnControlType:2];
                        break;
                }

                case 5: { // like/Heart Song : Universal
                    [MusicSharedRemote handleTapOnControlType:6];
                        break;
                }

                case 6: { // Present Up Next ~ Now Playing : Music App
                    [MusicSharedRemote handleTapOnControlType:7];
                        break;
                }

                case 7: { // Set Shuffling : Universal
                    [MusicSharedRemote handleTapOnControlType:10];
                        break;
                }

                case 8: { // Set Repeating : Universal
                    [MusicSharedRemote handleTapOnControlType:9];
                        break;
                }

                case 9: { // Show Context Menu ~ Now Playing : Music App
                    [MusicSharedRemote handleTapOnControlType:8];
                        break;
                }

                case 10: { // Play/Pause Toggle : Universal
                    [MusicSharedRemote handleTapOnControlType:3];
                        break;
                }

                case 14: { // Decrease Volume
                     [[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] - 0.1];
                        break;
                }

                case 15: { // Increase Volume
                     [[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] + 0.1];
                        break; 
                }
            }
        }
    else if ([arg1 isEqual: @"MiniPlayerMusicApp"]) {
        switch (arg2) { // Next Song ~ Now Playing : Music App
                case 1: {
                    CGRect frame = MiniPlayerController.titlesView.frame;
                    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ MiniPlayerController.titlesView.frame = CGRectMake(MiniPlayerController.titlesView.frame.size.width * -1, MiniPlayerController.titlesView.frame.origin.y, MiniPlayerController.titlesView.frame.size.width, MiniPlayerController.titlesView.frame.size.height); } completion:^(BOOL finished){
                        MRMediaRemoteSendCommand(kMRNextTrack, nil);
                        NSLog(@"Double Skip");
                        MiniPlayerController.titlesView.frame = CGRectMake(MiniPlayerController.titlesView.frame.size.width * 1 ,MiniPlayerController.titlesView.frame.origin.y, MiniPlayerController.titlesView.frame.size.width, MiniPlayerController.titlesView.frame.size.height);
                        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ MiniPlayerController.titlesView.frame = frame; } completion:^(BOOL finished){}];}];
                    break;
                }

                case 2: { // Previous Song ~ Now Playing : Music App
                    CGRect frame = MiniPlayerController.titlesView.frame;
                    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ MiniPlayerController.titlesView.frame = CGRectMake(MiniPlayerController.titlesView.frame.size.width * 1,MiniPlayerController.titlesView.frame.origin.y, MiniPlayerController.titlesView.frame.size.width, MiniPlayerController.titlesView.frame.size.height); } completion:^(BOOL finished){
                        [MusicSharedRemote handleTapOnControlType:1];
                        MiniPlayerController.titlesView.frame = CGRectMake(MiniPlayerController.titlesView.frame.size.width * -1 ,MiniPlayerController.titlesView.frame.origin.y, MiniPlayerController.titlesView.frame.size.width, MiniPlayerController.titlesView.frame.size.height);
                        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ MiniPlayerController.titlesView.frame = frame; } completion:^(BOOL finished){}];}];  
                    break;
                }

                case 3: { // 15 seconds forward : Universal
                    [MusicSharedRemote handleTapOnControlType:5];
                        break;
                }

                case 4: { // 15 seconds rewind : Universal
                    [MusicSharedRemote handleTapOnControlType:2];
                        break;
                }

                case 5: { // like/Heart Song : Universal
                    [MusicSharedRemote handleTapOnControlType:6];
                        break;
                }

                case 6: { // Present Up Next ~ Now Playing : Music App
                    [MusicSharedRemote handleTapOnControlType:7];
                        break;
                }

                case 7: { // Set Shuffling : Universal
                    [MusicSharedRemote handleTapOnControlType:10];
                        break;
                }

                case 8: { // Set Repeating : Universal
                    [MusicSharedRemote handleTapOnControlType:9];
                        break;
                }

                case 9: { // Show Context Menu ~ Now Playing : Music App
                    [MusicSharedRemote handleTapOnControlType:8];
                        break;
                }

                case 10: { // Play/Pause Toggle : Universal
                    [MusicSharedRemote handleTapOnControlType:3];
                        break;
                }

                case 14: { // Decrease Volume
                     [[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] - 0.1];
                        break;
                }

                case 15: { // Increase Volume
                     [[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] + 0.1];
                        break; 
                }
            }
        }
    else if ([arg1 isEqual: @"ControlCenterSpringBoard"]) {
        switch (arg2) { // Next Song ~ Now Playing : Music App
                case 2: {
                    CGRect frame = CCTitlesView.frame;
                    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ CCTitlesView.frame = CGRectMake(CCTitlesView.frame.size.width * -1, CCTitlesView.frame.origin.y, CCTitlesView.frame.size.width, CCTitlesView.frame.size.height); } completion:^(BOOL finished){
                        [MusicSharedRemote handleTapOnControlType:1];
                        CCTitlesView.frame = CGRectMake(CCTitlesView.frame.size.width * 1 ,CCTitlesView.frame.origin.y, CCTitlesView.frame.size.width, CCTitlesView.frame.size.height);
                        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ CCTitlesView.frame = frame; } completion:^(BOOL finished){}];}];
                        NSLog(@"Control Center Skip");
                    break;
                }

                case 1: { // Previous Song ~ Now Playing : Music App
                    CGRect frame = CCTitlesView.frame;
                    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ CCTitlesView.frame = CGRectMake(CCTitlesView.frame.size.width * 1,CCTitlesView.frame.origin.y, CCTitlesView.frame.size.width, CCTitlesView.frame.size.height); } completion:^(BOOL finished){
                        MRMediaRemoteSendCommand(kMRNextTrack, nil);
                        NSLog(@"Double Skip");
                        CCTitlesView.frame = CGRectMake(CCTitlesView.frame.size.width * -1 ,CCTitlesView.frame.origin.y, CCTitlesView.frame.size.width, CCTitlesView.frame.size.height);
                        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ CCTitlesView.frame = frame; } completion:^(BOOL finished){}];}];  
                    break;
                }

                case 3: { // 15 seconds forward : Universal
                    [MusicSharedRemote handleTapOnControlType:5];
                        break;
                }

                case 4: { // 15 seconds rewind : Universal
                    [MusicSharedRemote handleTapOnControlType:2];
                        break;
                }

                case 5: { // like/Heart Song : Universal
                    [MusicSharedRemote handleTapOnControlType:6];
                        break;
                }

                case 6: { // Present Up Next ~ Now Playing : Music App
                    [MusicSharedRemote handleTapOnControlType:7];
                        break;
                }

                case 7: { // Set Shuffling : Universal
                    [MusicSharedRemote handleTapOnControlType:10];
                        break;
                }

                case 8: { // Set Repeating : Universal
                    [MusicSharedRemote handleTapOnControlType:9];
                        break;
                }

                case 9: { // Show Context Menu ~ Now Playing : Music App
                    [MusicSharedRemote handleTapOnControlType:8];
                        break;
                }

                case 10: { // Play/Pause Toggle : Universal
                    [MusicSharedRemote handleTapOnControlType:3];
                        break;
                }

                case 11: { // Share : Control Center
                    [MainSystemMediaControls _launchFirstPartyMusicAppForShareCommand];
                        break;
                }

                case 12: { // Show Song Picker
                    [ControlCenterMusic showMediaPicker];
                        break;
                }

                case 13: { // Launch Now Playing App
                    [MainSystemMediaControls _launchCurrentNowPlayingApp];
                        break;
                }

                case 14: { // Decrease Volume
                     [[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] - 0.1];
                        break;
                }

                case 15: { // Increase Volume
                     [[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] + 0.1];
                        break; 
                }

            }
        }
        else if ([arg1 isEqual: @"LockScreenSpringBoard"]) {
        switch (arg2) { // Next Song ~ Now Playing : Music App
                case 2: {
                    CGRect frame = LockScreenTitlesView.frame;
                    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ LockScreenTitlesView.frame = CGRectMake(LockScreenTitlesView.frame.size.width * -1, LockScreenTitlesView.frame.origin.y, LockScreenTitlesView.frame.size.width, LockScreenTitlesView.frame.size.height); } completion:^(BOOL finished){
                        [MusicSharedRemote handleTapOnControlType:1];
                        NSLog(@"Double Skip");
                        LockScreenTitlesView.frame = CGRectMake(LockScreenTitlesView.frame.size.width * 1 ,LockScreenTitlesView.frame.origin.y, LockScreenTitlesView.frame.size.width, LockScreenTitlesView.frame.size.height);
                        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ LockScreenTitlesView.frame = frame; } completion:^(BOOL finished){}];}];
                    break;
                }

                case 1: { // Previous Song ~ Now Playing : Music App
                    CGRect frame = LockScreenTitlesView.frame;
                    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ LockScreenTitlesView.frame = CGRectMake(LockScreenTitlesView.frame.size.width * 1,LockScreenTitlesView.frame.origin.y, LockScreenTitlesView.frame.size.width, LockScreenTitlesView.frame.size.height); } completion:^(BOOL finished){
                        [MusicSharedRemote handleTapOnControlType:4];
                        LockScreenTitlesView.frame = CGRectMake(LockScreenTitlesView.frame.size.width * -1 ,LockScreenTitlesView.frame.origin.y, LockScreenTitlesView.frame.size.width, LockScreenTitlesView.frame.size.height);
                        [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{ LockScreenTitlesView.frame = frame; } completion:^(BOOL finished){}];}];  
                    break;
                }

                case 3: { // 15 seconds forward : Universal
                    [MusicSharedRemote handleTapOnControlType:5];
                        break;
                }

                case 4: { // 15 seconds rewind : Universal
                    [MusicSharedRemote handleTapOnControlType:2];
                        break;
                }

                case 5: { // like/Heart Song : Universal
                    [MusicSharedRemote handleTapOnControlType:6];
                        break;
                }

                case 6: { // Present Up Next ~ Now Playing : Music App
                    [MusicSharedRemote handleTapOnControlType:7];
                        break;
                }

                case 7: { // Set Shuffling : Universal
                    [MusicSharedRemote handleTapOnControlType:10];
                        break;
                }

                case 8: { // Set Repeating : Universal
                    [MusicSharedRemote handleTapOnControlType:9];
                        break;
                }

                case 9: { // Show Context Menu ~ Now Playing : Music App
                    [MusicSharedRemote handleTapOnControlType:8];
                        break;
                }

                case 10: { // Play/Pause Toggle : Universal
                    [MusicSharedRemote handleTapOnControlType:3];
                        break;
                }

                case 11: { // Share : Control Center
                    [MainSystemMediaControls _launchFirstPartyMusicAppForShareCommand];
                        break;
                }

                case 14: { // Decrease Volume
                     [[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] - 0.1];
                        break;
                }

                case 15: { // Increase Volume
                    [[%c(SBMediaController) sharedInstance] setVolume:[[%c(SBMediaController) sharedInstance] volume] + 0.1];
                        break; 
                }
            }
        }
}
%end
%hook MPMediaPickerController
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    MPMusicPlayerController *player = [MPMusicPlayerController iPodMusicPlayer];
    [player setQueueWithItemCollection:mediaItemCollection];
    [player play];
}
%end

%hook MPUTransportControl
-(BOOL)acceptsTapsWhenDisabled {
    return YES;
}
%end

%hook MusicRemoteController // Remote for the Music Player
- (id)initWithPlayer:(id)arg1 {  
    addLibrary = %orig; // Defining the Shared Object
    return addLibrary; // Calling it back to create the Shared Object
}
%end
%hook MusicNowPlayingViewController // Now Playing View
- (void)viewDidLayoutSubviews { // Method I'm Hijacking to create all my UIGestureRecognizers
    %orig(); // call the original implimentation first to prevent Broken UI
// Now Playing View Gestures
    if (kGesturesEnabled && kNowPlayingGestures) { // Making sure it's what I want
        artworkcontrolLeftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(artworkcontrol_leftSwipeRecognized:)]; // Defining the Left Swipe Gesture
        artworkcontrolRightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(artworkcontrol_rightSwipeRecognized:)]; // Defining the Right Swipe Gesture
        artworkcontrolLeftDoubleSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(artworkcontrol_leftDoubleSwipeRecognized:)]; // Defining the Two Finger Swipe to the Right Gesture
        artworkcontrolRightDoubleSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(artworkcontrol_rightDoubleSwipeRecognized:)]; // Defining the Two Finger Swipe to the Left Gesture
        artworkcontrolDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(artworkcontrol_doubleTapRecognized:)]; // Defining the Double Tap Gesture

        artworkcontrolLeftDoubleSwipeGestureRecognizer.direction =
        artworkcontrolLeftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft; // Giving Swipe Left a direction

        artworkcontrolRightDoubleSwipeGestureRecognizer.direction =
        artworkcontrolRightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight; // Giving Swipe Left a direction

        // Giving the Gestures thier requirements to be called

        artworkcontrolDoubleTapGestureRecognizer.numberOfTapsRequired = 2; // Telling Double Tap Gesture it needs to be tapped 2 times
        artworkcontrolLeftDoubleSwipeGestureRecognizer.numberOfTouchesRequired = 2; // Teling Two Finger Swipe Left it needs to recognize 2 Fingers on the Screen
        artworkcontrolRightDoubleSwipeGestureRecognizer.numberOfTouchesRequired = 2; // Teling Two Finger Swipe Right it needs to recognize 2 Fingers on the Screen

        // Attaching Gestures to the Now Playing View

        [self.view addGestureRecognizer:artworkcontrolLeftDoubleSwipeGestureRecognizer]; // Attaching 2 Finger Swipe Left Gesture to the View
        [self.view addGestureRecognizer:artworkcontrolLeftSwipeGestureRecognizer]; // Attaching Single Finger Swipe Left Gesture to the View
        [self.view addGestureRecognizer:artworkcontrolRightDoubleSwipeGestureRecognizer]; // Attaching 2 Finger Swipe Right Gesture to the View
        [self.view addGestureRecognizer:artworkcontrolRightSwipeGestureRecognizer]; // Attaching Single Finger Swipe Right Gesture to the View
        [self.view addGestureRecognizer:artworkcontrolDoubleTapGestureRecognizer]; // Attaching Double Tap Gesture to the View

        // Releasing My Objects so I don't have Memory Leaks


        [artworkcontrolLeftSwipeGestureRecognizer release]; // Releasing the Single Finger Swipe Left Gesture
        [artworkcontrolRightSwipeGestureRecognizer release]; // Releasing the Single Finger Swipe Right Gesture
        [artworkcontrolLeftDoubleSwipeGestureRecognizer release]; // Releasing the 2 Finger Swipe Left Gesture
        [artworkcontrolRightDoubleSwipeGestureRecognizer release]; // Releasing the 2 Finger Swipe Right Gesture
        [artworkcontrolDoubleTapGestureRecognizer release]; // Releasing the Double Tap Gesture Recognizer
    }
    if (kNowPlayingDarkGradient) {
    [self.statusBarLegibilityGradient removeFromSuperlayer];
    }

}

%new // Creating a New Method
- (void)artworkcontrol_leftSwipeRecognized:(UISwipeGestureRecognizer *)sender { // One Finger Swipe Left Recognized
    if (sender.state == UIGestureRecognizerStateEnded) { // We Stopped Swiping
        [MusicSharedRemote onView:@"NowPlayingMusicApp" performAction:kNowPlayingSwipeLeftAction]; // tapping on the Transport Control button that has the type "1", This will call the "Go to Previous Song" Command
    }
}

%new // Creating a New Method
- (void)artworkcontrol_rightSwipeRecognized:(UISwipeGestureRecognizer *)sender { // One Finger Swipe Right Recognized
    if (sender.state == UIGestureRecognizerStateEnded) { // We Stopped Swiping
        [MusicSharedRemote  onView:@"NowPlayingMusicApp" performAction:kNowPlayingSwipeRightAction]; // tapping on the Transport Control button that has the type "4", This will call the "Skip to Next Song" Command
    }
}

%new // Creating a New Method
- (void)artworkcontrol_leftDoubleSwipeRecognized:(UISwipeGestureRecognizer *)sender { // Two Finger Swipe Left Recognized
    if (sender.state == UIGestureRecognizerStateEnded) { // We Stopped Swiping
        [MusicSharedRemote  onView:@"NowPlayingMusicApp" performAction: kNowPlayingSwipeLeftTwoFingersAction]; // Take the Now Playing Time and take away 15 seconds
        
    }
}

%new
- (void)artworkcontrol_rightDoubleSwipeRecognized:(UISwipeGestureRecognizer *)sender {  // Two Finger Swipe Right Recognized
    if (sender.state == UIGestureRecognizerStateEnded) {
    [MusicSharedRemote  onView:@"NowPlayingMusicApp" performAction:kNowPlayingSwipeRightTwoFingersAction]; // Take the Now Playing Time and add 15 seconds
    }
}
%new // Creating a New Method
- (void)artworkcontrol_doubleTapRecognized:(UITapGestureRecognizer *)sender { // Double Tap Recognized
    if (sender.state == UIGestureRecognizerStateEnded) { // We tapped for the Second Time in a row which ends our Gesture
        [MusicSharedRemote  onView:@"NowPlayingMusicApp" performAction:kNowPlayingDoubleTapAction]; // Add the Currently Playing Song to the Music Library
    }
}
- (id)transportControlsView:(id)arg1 buttonForControlType:(int)arg2 {
    switch (arg2) {
        case 1: { // Set Shuffling : Universal
            if (kNowPlayingPreviousTransport) {
                return NULL;
            }
            else {
                return %orig;
            }
            break;
        }

        case 2: { // Set Shuffling : Universal
            if (kNowPlayingIntervalBackwardTransport) {
                return NULL;
            }
            else {
                return %orig;
            }
            break;
        }

        case 3: { // Set Shuffling : Universal
            if (kNowPlayingPlayPauseToggleTransport) {
                return NULL;
            }
            else {
                return %orig;
            }
            break;
        }

        case 4: { // Set Shuffling : Universal
            if (kNowPlayingFowardTransport) {
               return NULL;
            }
            else {
                return %orig;
            }
            break;
        }

        case 5: { // Set Shuffling : Universal
            if (kNowPlayingIntervalFowardTransport) {
                return NULL;
            }
            else {
                return %orig;
            }
            break;
        }

        case 6: { // Set Shuffling : Universal
            if (kNowPlayingHeartTransport) {
                return NULL;
            }
            else {
                return %orig;
            }
            break;
        }

        case 7: { // Set Shuffling : Universal
            if (kNowPlayingUpNextTransport) {
                return NULL;
            }
            else {
                return %orig;
            }
            break;
        }

        case 8: { // Set Shuffling : Universal
            if (kNowPlayingShareTransport) {
                return NULL;
            }
            else {
                return %orig;
            }
            break;
        }

        case 9: { // Set Shuffling : Universal
            if (kNowPlayingRepeatTransport) {
                return NULL;
            }
            else {
                return %orig;
            }
            break;
        }

        case 10: { // Set Shuffling : Universal
            if (kNowPlayingShuffleTransport) {
                return NULL;
            }
            else {
                return %orig;
            }
            break;
        }

        case 11: { // Set Shuffling : Universal
            if (kNowPlayingContextualTransport) {
                return NULL;
            }
            else {
                return %orig;
            }
            break;
        }
    }
    return %orig;
}
%end // Bye Bye Now Playing View Gestures and Hello Mini Player Panning Gestures
%hook MusicMiniPlayerViewController // The MiniPlayer's View Controller
- (id)initWithPlayer:(id)arg1 {
    MiniPlayerController = %orig;
    return MiniPlayerController;
}
- (void)_panRecognized:(id)arg1 {
    %orig;
    if (kGesturesEnabled && kMiniPlayerGestures)
    return;
}
- (void)viewDidLoad { // The MiniPlayer View Did Load
    %orig(); // Call the Original Implimentation so we We don't mess up the UI
    if (kGesturesEnabled && kMiniPlayerGestures) {
        miniplayerPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(miniplayer_PanGestureRecognized:)]; // Defining Our Main Pan Gesture recognizer

        [self.view addGestureRecognizer:miniplayerPanGestureRecognizer]; // Adding our Main Pan Gesture recognizer to the MiniPlayer View
        [miniplayerPanGestureRecognizer release]; // Releasin g the Main Pan Gesture recognizer to prevent Memory Leaks
    }
}
%new // Creating a Method that will tell the Pan Gesture which Direction We are panning in
- (void)miniplayer_PanGestureRecognized:(UIPanGestureRecognizer *)sender // The Main Pan Gesture was recognized 
{

    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) { // Defining our Directions
        UIPanGestureRecognizerDirectionUndefined, // It doesn't know what Direction yet
        UIPanGestureRecognizerDirectionUp, // We panned UP
        UIPanGestureRecognizerDirectionDown, // We panned Down
        UIPanGestureRecognizerDirectionLeft, // We panned Left
        UIPanGestureRecognizerDirectionRight // We panned Right
    };

    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined; //  Telling it that it doesn't know what Direction we panned yet

    switch (sender.state) { // Function for telling the sender.state which Direction we Panned in

        case UIGestureRecognizerStateBegan: { // We started Panning, Lets find out in waht Direction

            if (direction == UIPanGestureRecognizerDirectionUndefined) {

                CGPoint velocity = [sender velocityInView:self.view]; // Lets get the Velocity of our Pan

                BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x); // if y is greater than x it must be a Vertical Pan

                if (isVerticalGesture) {
                    if (velocity.y > 0) {
                        direction = UIPanGestureRecognizerDirectionDown; // We must of Swiped down because Y is less than 0
                    } else {
                        direction = UIPanGestureRecognizerDirectionUp; // Y turned out to be more than 0 so we must of Panned Up
                    }
                }

                else {
                    if (velocity.x > 0) {
                        direction = UIPanGestureRecognizerDirectionRight; // We must of SPanned Right because x is greater than 0
                    } else {
                        direction = UIPanGestureRecognizerDirectionLeft; // x wasn't greater than 0 so it must be less so we must of Panned Left
                    }
                }
            }

            break;
        }

        case UIGestureRecognizerStateChanged: {
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: { // We panned in the Upward Direction
                    [self handleUpwardsGesture:sender]; // call the Upward Pan Action
                    break;
                }
                case UIPanGestureRecognizerDirectionDown: { // We panned in the Downward Direction
                    [self handleDownwardsGesture:sender]; // call the Downward Pan Action
                    break;
                }
                case UIPanGestureRecognizerDirectionLeft: { // We panned to the Left
                    [self handleLeftGesture:sender]; // call the Left Pan Action
                    break;
                }
                case UIPanGestureRecognizerDirectionRight: { // We panned to the Right
                    [self handleRightGesture:sender]; // call the Pan Right Action 
                    break;
                }
                default: { // Just the Default :)
                    break;
                }
            }
        }

        case UIGestureRecognizerStateEnded: { //  We stoped Panning
            direction = UIPanGestureRecognizerDirectionUndefined;  // Oops we must of Panned in place somehow 
            break;
        }

        default:
            break;
    }

}
%new // Creat New Method For a Upward Pan
- (void)handleUpwardsGesture:(UIPanGestureRecognizer *)sender // Handle the Upward Pan Action
{
    NSLog(@"Up"); // Just logging for Now
}

%new // Create a New Method For a Downward Pan
- (void)handleDownwardsGesture:(UIPanGestureRecognizer *)sender // Handle the Downward Pan Action
{
}
%new // Create a New Method for a Pan to the Left
- (void)handleLeftGesture:(UIPanGestureRecognizer *)sender  // Handle Left Pan Action
{
    [MusicSharedRemote  onView:@"MiniPlayerMusicApp" performAction:kMiniPlayerSwipeRightAction];
    // [self transportControlsView:self.transportControlsView tapOnControlType:3]; (Inverse Swiping Option Enabled)
}
%new // Create a New Method for a Pan to the Left
- (void)handleRightGesture:(UIPanGestureRecognizer *)sender // Handle Right Pan Action
{
    [MusicSharedRemote  onView:@"MiniPlayerMusicApp" performAction:kMiniPlayerSwipeLeftAction];
    // [self transportControlsView:self.transportControlsView tapOnControlType:1]; (Inverse Swiping Option Enabled)
}

- (id)transportControlsView:(id)arg1 buttonForControlType:(int)arg2 {
    switch (arg2) {
        case 3: { // Set Shuffling : Universal
            if (kMiniPlayerPlayPauseToggleTransport) {
                return NULL;
            }
            else {
                return %orig;
            }
            break;
        }
        case 11: { // Set Shuffling : Universal
            if (kMiniPlayerContextualTransport) {
                return NULL;
            }
            else {
                return %orig;
            }
            break;
        }
    }
    return %orig;
}
%end // We are Finally Done with the Gestures for inside the Music App
%hook MusicContextualActionsConfiguration 
-(BOOL)allowsLibraryKeepLocalActions {
    return YES;
}
-(void)setAllowsLibraryKeepLocalActions:(BOOL)arg1 {
    %orig(YES);
}
%end

%hook MPUMediaControlsControlCenterTitlesView
-(void)layoutSubviews {
    [self setUserInteractionEnabled:NO];
    CCTitlesView = self;
    %orig();
    if (kGesturesEnabled && kNowPlayingGestures) {
        lsartworkPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:CCTitlesView action:@selector(lsartwork_PanGestureRecognized:)]; // Defining Our Main Pan Gesture recognizer

        [self addGestureRecognizer:lsartworkPanGestureRecognizer]; // Adding our Main Pan Gesture recognizer to the MiniPlayer View
        [lsartworkPanGestureRecognizer release];
}
}
%new // Creating a Method that will tell the Pan Gesture which Direction We are panning in
- (void)lsartwork_PanGestureRecognized:(UIPanGestureRecognizer *)sender // The Main Pan Gesture was recognized 
{

    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) { // Defining our Directions
        UIPanGestureRecognizerDirectionUndefined, // It doesn't know what Direction yet
        UIPanGestureRecognizerDirectionUp, // We panned UP
        UIPanGestureRecognizerDirectionDown, // We panned Down
        UIPanGestureRecognizerDirectionLeft, // We panned Left
        UIPanGestureRecognizerDirectionRight // We panned Right
    };

    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined; //  Telling it that it doesn't know what Direction we panned yet

    switch (sender.state) { // Function for telling the sender.state which Direction we Panned in

        case UIGestureRecognizerStateBegan: { // We started Panning, Lets find out in waht Direction

            if (direction == UIPanGestureRecognizerDirectionUndefined) {

                CGPoint velocity = [sender velocityInView:self]; // Lets get the Velocity of our Pan

                BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x); // if y is greater than x it must be a Vertical Pan

                if (isVerticalGesture) {
                    if (velocity.y > 0) {
                        direction = UIPanGestureRecognizerDirectionDown; // We must of Swiped down because Y is less than 0
                    } else {
                        direction = UIPanGestureRecognizerDirectionUp; // Y turned out to be more than 0 so we must of Panned Up
                    }
                }

                else {
                    if (velocity.x > 0) {
                        direction = UIPanGestureRecognizerDirectionRight; // We must of SPanned Right because x is greater than 0
                    } else {
                        direction = UIPanGestureRecognizerDirectionLeft; // x wasn't greater than 0 so it must be less so we must of Panned Left
                    }
                }
            }

            break;
        }

        case UIGestureRecognizerStateChanged: {
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: { // We panned in the Upward Direction
                    [self handleUpwardsGesture:sender]; // call the Upward Pan Action
                    break;
                }
                case UIPanGestureRecognizerDirectionDown: { // We panned in the Downward Direction
                    [self handleDownwardsGesture:sender]; // call the Downward Pan Action
                    break;
                }
                case UIPanGestureRecognizerDirectionLeft: { // We panned to the Left
                    [self handleLeftGesture:sender]; // call the Left Pan Action
                    break;
                }
                case UIPanGestureRecognizerDirectionRight: { // We panned to the Right
                    [self handleRightGesture:sender]; // call the Pan Right Action 
                    break;
                }
                default: { // Just the Default :)
                    break;
                }
            }
        }

        case UIGestureRecognizerStateEnded: { //  We stoped Panning
            direction = UIPanGestureRecognizerDirectionUndefined;  // Oops we must of Panned in place somehow 
            break;
        }

        default:
            break;
    }

}
%new // Creat New Method For a Upward Pan
- (void)handleUpwardsGesture:(UIPanGestureRecognizer *)sender // Handle the Upward Pan Action
{
    NSLog(@"Up Pan"); // Just logging for Now
}

%new // Create a New Method For a Downward Pan
- (void)handleDownwardsGesture:(UIPanGestureRecognizer *)sender // Handle the Downward Pan Action
{
     NSLog(@"Down Pan"); // Add the currently playing Song to "My Music"
}
%new // Create a New Method for a Pan to the Left
- (void)handleLeftGesture:(UIPanGestureRecognizer *)sender  // Handle Left Pan Action
{
     [MusicSharedRemote performAction:kAuxoLegacySwipeLeftAction]; // Send a Command to the TransportControlView that we *tapped* the "Previous Song" Button
    // [self transportControlsView:self.transportControlsView tapOnControlType:3]; (Inverse Swiping Option Enabled)
}
%new // Create a New Method for a Pan to the Left
- (void)handleRightGesture:(UIPanGestureRecognizer *)sender // Handle Right Pan Action
{
     [MusicSharedRemote performAction:kAuxoLegacySwipeRightAction]; // Send a Command to the TransportControlView that we *tapped* the "Skip to Next Song" Button
    // [self transportControlsView:self.transportControlsView tapOnControlType:1]; (Inverse Swiping Option Enabled)
}
%end // We are Finally Done with the Gestures for inside the Music App
%hook NowPlayingArtPluginController
-(void)loadView {
    %orig();    
        lsartworkcontrolDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lsartworkcontrol_doubleTapRecognized:)];

        lsartworkcontrolDoubleTapGestureRecognizer.numberOfTapsRequired = 2; 

        [self.view addGestureRecognizer:lsartworkcontrolDoubleTapGestureRecognizer];

        [lsartworkcontrolDoubleTapGestureRecognizer release];
}
%new
- (void)lsartworkcontrol_doubleTapRecognized:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [MusicSharedRemote handleTapOnControlType:kSBDoubleTapArtworkAction];
    }
}
%end
%hook KHSwitcherMusicControlsView
-(void)layoutSubviews {
    %orig;
    if (kGesturesEnabled && kNowPlayingGestures) {
        lsartworkPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(lsartwork_PanGestureRecognized:)]; // Defining Our Main Pan Gesture recognizer

        [self addGestureRecognizer:lsartworkPanGestureRecognizer]; // Adding our Main Pan Gesture recognizer to the MiniPlayer View
        [lsartworkPanGestureRecognizer release];
}
}
%new // Creating a Method that will tell the Pan Gesture which Direction We are panning in
- (void)lsartwork_PanGestureRecognized:(UIPanGestureRecognizer *)sender // The Main Pan Gesture was recognized 
{

    typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) { // Defining our Directions
        UIPanGestureRecognizerDirectionUndefined, // It doesn't know what Direction yet
        UIPanGestureRecognizerDirectionUp, // We panned UP
        UIPanGestureRecognizerDirectionDown, // We panned Down
        UIPanGestureRecognizerDirectionLeft, // We panned Left
        UIPanGestureRecognizerDirectionRight // We panned Right
    };

    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined; //  Telling it that it doesn't know what Direction we panned yet

    switch (sender.state) { // Function for telling the sender.state which Direction we Panned in

        case UIGestureRecognizerStateBegan: { // We started Panning, Lets find out in waht Direction

            if (direction == UIPanGestureRecognizerDirectionUndefined) {

                CGPoint velocity = [sender velocityInView:self]; // Lets get the Velocity of our Pan

                BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x); // if y is greater than x it must be a Vertical Pan

                if (isVerticalGesture) {
                    if (velocity.y > 0) {
                        direction = UIPanGestureRecognizerDirectionDown; // We must of Swiped down because Y is less than 0
                    } else {
                        direction = UIPanGestureRecognizerDirectionUp; // Y turned out to be more than 0 so we must of Panned Up
                    }
                }

                else {
                    if (velocity.x > 0) {
                        direction = UIPanGestureRecognizerDirectionRight; // We must of SPanned Right because x is greater than 0
                    } else {
                        direction = UIPanGestureRecognizerDirectionLeft; // x wasn't greater than 0 so it must be less so we must of Panned Left
                    }
                }
            }

            break;
        }

        case UIGestureRecognizerStateChanged: {
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: { // We panned in the Upward Direction
                    [self handleUpwardsGesture:sender]; // call the Upward Pan Action
                    break;
                }
                case UIPanGestureRecognizerDirectionDown: { // We panned in the Downward Direction
                    [self handleDownwardsGesture:sender]; // call the Downward Pan Action
                    break;
                }
                case UIPanGestureRecognizerDirectionLeft: { // We panned to the Left
                    [self handleLeftGesture:sender]; // call the Left Pan Action
                    break;
                }
                case UIPanGestureRecognizerDirectionRight: { // We panned to the Right
                    [self handleRightGesture:sender]; // call the Pan Right Action 
                    break;
                }
                default: { // Just the Default :)
                    break;
                }
            }
        }

        case UIGestureRecognizerStateEnded: { //  We stoped Panning
            direction = UIPanGestureRecognizerDirectionUndefined;  // Oops we must of Panned in place somehow 
            break;
        }

        default:
            break;
    }

}
%new // Creat New Method For a Upward Pan
- (void)handleUpwardsGesture:(UIPanGestureRecognizer *)sender // Handle the Upward Pan Action
{
    NSLog(@"Up Pan"); // Just logging for Now
}

%new // Create a New Method For a Downward Pan
- (void)handleDownwardsGesture:(UIPanGestureRecognizer *)sender // Handle the Downward Pan Action
{
     NSLog(@"Down Pan"); // Add the currently playing Song to "My Music"
}
%new // Create a New Method for a Pan to the Left
- (void)handleLeftGesture:(UIPanGestureRecognizer *)sender  // Handle Left Pan Action
{
     NSLog(@"Left Pan"); // Send a Command to the TransportControlView that we *tapped* the "Previous Song" Button
    // [self transportControlsView:self.transportControlsView tapOnControlType:3]; (Inverse Swiping Option Enabled)
}
%new // Create a New Method for a Pan to the Left
- (void)handleRightGesture:(UIPanGestureRecognizer *)sender // Handle Right Pan Action
{
     NSLog(@"Right Pan"); // Send a Command to the TransportControlView that we *tapped* the "Skip to Next Song" Button
    // [self transportControlsView:self.transportControlsView tapOnControlType:1]; (Inverse Swiping Option Enabled)
}
%end // We are Finally Done with the Gestures for inside the Music App
%hook MusicVerticalScrollingContainerCollectionView
-(BOOL)isPerformingLayout {
if (kIndexBar) return YES;
else return NO;
}
%end
%hook MPMediaItem
-(BOOL)rememberBookmarkTime {
    if (kBookmarkPosition) return YES;
    else return NO;
}
%end
%hook SBCCMediaControlsSectionController
-(void)viewDidLoad {
    ControlCenterMusic = self;
    %orig();
    if (kGesturesEnabled && kCCGesturesEnabled) {    
        ControlCenterLeftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ControlCenter_leftSwipeRecognized:)];
        ControlCenterRightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ControlCenter_rightSwipeRecognized:)];
        ControlCenterLeftDoubleSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ControlCenter_leftDoubleSwipeRecognized:)];
        ControlCenterRightDoubleSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(ControlCenter_rightDoubleSwipeRecognized:)];
        ControlCenterLongPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(ControlCenter_longPressRecognized:)];
        ControlCenterShortPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(ControlCenter_shortPressRecognized:)];
        ControlCenterDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ControlCenter_doubleTapRecognized:)];

        ControlCenterLeftDoubleSwipeGestureRecognizer.direction =
        ControlCenterLeftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;

        ControlCenterLongPressGestureRecognizer.minimumPressDuration = 1;
        [ControlCenterShortPressGestureRecognizer requireGestureRecognizerToFail:ControlCenterLongPressGestureRecognizer];


        ControlCenterRightDoubleSwipeGestureRecognizer.direction =
        ControlCenterRightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        ControlCenterLeftDoubleSwipeGestureRecognizer.numberOfTouchesRequired = 2;
        ControlCenterRightDoubleSwipeGestureRecognizer.numberOfTouchesRequired = 2;
        ControlCenterDoubleTapGestureRecognizer.numberOfTapsRequired = 2; 

        [self.view addGestureRecognizer:ControlCenterLeftDoubleSwipeGestureRecognizer];
        [self.view addGestureRecognizer:ControlCenterLeftSwipeGestureRecognizer];
        [self.view addGestureRecognizer:ControlCenterRightDoubleSwipeGestureRecognizer];
        [self.view addGestureRecognizer:ControlCenterRightSwipeGestureRecognizer];
        [self.view addGestureRecognizer:ControlCenterLongPressGestureRecognizer];
        [self.view addGestureRecognizer:ControlCenterShortPressGestureRecognizer];
        [self.view addGestureRecognizer:ControlCenterDoubleTapGestureRecognizer];


        [ControlCenterLeftSwipeGestureRecognizer release];
        [ControlCenterRightSwipeGestureRecognizer release];
        [ControlCenterLeftDoubleSwipeGestureRecognizer release];
        [ControlCenterRightDoubleSwipeGestureRecognizer release];
        [ControlCenterDoubleTapGestureRecognizer release];
}
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
        return ![touch.view isKindOfClass:[UIButton class]];
    }
%new
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
        [musicPlayer setQueueWithItemCollection: mediaItemCollection];
        [mediaPicker dismissViewControllerAnimated:YES completion:nil];
        [musicPlayer play];
    }
%new
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    }
%new
- (void)ControlCenter_leftSwipeRecognized:(UISwipeGestureRecognizer *)sender { 
    if (sender.state == UIGestureRecognizerStateEnded) {
        [MusicSharedRemote  onView:@"ControlCenterSpringBoard" performAction:kCCSwipeLeftAction];
    }
}

%new
- (void)ControlCenter_rightSwipeRecognized:(UISwipeGestureRecognizer *)sender { 
    if (sender.state == UIGestureRecognizerStateEnded) {
        [MusicSharedRemote  onView:@"ControlCenterSpringBoard" performAction:kCCSwipeRightAction];

    }
}

%new
- (void)ControlCenter_leftDoubleSwipeRecognized:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [MusicSharedRemote  onView:@"ControlCenterSpringBoard" performAction:kCCSwipeLeftTwoFingersAction];
    }
}

%new
- (void)ControlCenter_rightDoubleSwipeRecognized:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [MusicSharedRemote  onView:@"ControlCenterSpringBoard" performAction:kCCSwipeRightTwoFingersAction];
    }
}
%new
- (void)ControlCenter_longPressRecognized:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [MusicSharedRemote  onView:@"ControlCenterSpringBoard" performAction:kCCLongPressAction];
        NSLog(@"Long Press");
    }
}
%new
- (void)ControlCenter_shortPressRecognized:(UISwipeGestureRecognizer *)sender {
    [MusicSharedRemote  onView:@"ControlCenterSpringBoard" performAction:kCCShortPressAction];
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Short Press");
    }
}
%new
- (void)ControlCenter_doubleTapRecognized:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [MusicSharedRemote  onView:@"ControlCenterSpringBoard" performAction:kCCDoubleTapAction];
        NSLog(@"Double Tap");
    }
}
%new
-(void)showMediaPicker {
        musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
        mediaPicker.allowsPickingMultipleItems = NO;
        mediaPicker.prompt = @"Select songs to play";
        mediaPicker.delegate = (id)self;
        [self presentViewController:mediaPicker animated:YES completion:nil];
        [mediaPicker release];
}
%new
-(id)testinfo {
    return testInfoObject;
}                                                                                                             
%end
%group Music
%hook MPAVQueueCoordinator
- (id)items {
    testInfoObject = %orig;
    return testInfoObject;
}
%end
%hook MPUBlurEffectView
- (id)initWithFrame:(CGRect)arg1 {
    if (kNowPlayingBlur)  return NULL;
    return %orig;
}
%end
%hook MusicNowPlayingFloatingButton
- (void)layoutSubviews {
    %orig;
    if (kNowPlayingFloatingArrow) {[self setHidden: YES]; [self setAlpha:0];}
}
%end
%hook MusicUserInterfaceStatusController
- (void)_updateAllowedUserInterfaceComponents {
    NSLog(@"I updated Bitch");
    NSMutableArray *tabList = [NSMutableArray arrayWithObjects:nil];
    if (kForYouTab) [tabList addObject:@"for_you"];
    if (kNewTab) [tabList addObject:@"new"];
    if (kRadioTab) [tabList addObject:@"radio"];
    if (kConnectTab) [tabList addObject:@"connect"];
    if (kPlaylistsTab) [tabList addObject:@"playlists"];
    if (kMyMusicTab)[tabList addObject:@"my_music"];
    if (kGeniusMixesTab)[tabList addObject:@"genius_mixes"];
    %orig;
}
%new
-(id)tabArray {
    NSMutableArray *tabList = [NSMutableArray arrayWithObjects:nil];
    if (kForYouTab) [tabList addObject:@"for_you"];
    if (kNewTab) [tabList addObject:@"new"];
    if (kRadioTab) [tabList addObject:@"radio"];
    if (kConnectTab) [tabList addObject:@"connect"];
    if (kPlaylistsTab) [tabList addObject:@"playlists"];
    if (kMyMusicTab)[tabList addObject:@"my_music"];
    if (kGeniusMixesTab)[tabList addObject:@"genius_mixes"];
    NSArray *tabFinishedArray = [NSArray arrayWithArray:tabList];
    return tabFinishedArray;
}
- (id)supportedTabIdentifiersForTraitCollection:(id)arg1 {
    return [self tabArray];
}
%end
%hook SKUICardViewElementCollectionViewCell
- (void)layoutSubviews {
    %orig;
    if(kCleanAppleMusic) [self.layer setBackgroundColor:[[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor]];
}
%end
%hook IKViewElementStyle
-(id)ikColor {
    if (kCleanAppleMusic) return NULL; // Fix Stupid Title Colors
    return %orig;
}
%end
%hook SKUIHorizontalLockupCollectionViewCell
- (void)layoutSubviews {
    %orig;
    if (kCleanAppleMusic) [self.layer setBackgroundColor:[[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] CGColor]];
}
%end
%hook SKUIHorizontalLockupView 
    - (void)layoutSubviews {
    %orig;
    if (kCleanAppleMusic) { 
    [self.metadataBackgroundView setHidden: TRUE];
    [self.metadataBackgroundView setAlpha: 0]; }
    }
%end
%hook MPMutableArtworkColorAnalysis
- (void)setBackgroundColor:(id)arg1 {
    if (kCleanAppleMusic) {
    arg1 = [UIColor whiteColor];
    %orig(arg1);
    }
    else return %orig;
}
- (void)setBackgroundColorLight:(BOOL)arg1 {
    if (kCleanAppleMusic) return %orig(TRUE);
    return %orig;
}
- (void)setPrimaryTextColor:(id)arg1 {
    if (kCleanAppleMusic) {
    arg1 = [UIColor blackColor];
    %orig(arg1);
    }
    return %orig;
}
- (void)setPrimaryTextColorLight:(BOOL)arg1 {
    if (kCleanAppleMusic) %orig(FALSE);
    return %orig;
}
- (void)setSecondaryTextColor:(id)arg1 {
    if (kCleanAppleMusic) %orig(NULL);
    else return %orig;
}
- (void)setSecondaryTextColorLight:(BOOL)arg1 {
    if (kCleanAppleMusic) return %orig(FALSE);
    return %orig;
}
%end
%hook MusicUpNextViewController
- (void)setHidesNowPlaying:(BOOL)arg1 {
    %orig(TRUE);
}
-(BOOL)hidesNowPlaying {
    return TRUE;
}
%end
%hook MusicNowPlayingTitlesView
- (id)initWithFrame:(CGRect)arg1 {
    SharedTitlesView = %orig;
    return  SharedTitlesView;
}
%end
%hook MusicNowPlayingItemViewController
- (id)initWithItem:(id)arg1 {
    nowplayingitem = %orig;
    return nowplayingitem;
}

- (void)_setWantsVideoLayer:(BOOL)arg1 {
    if (kArtworkBlurStyle == 3) {

UIVisualEffect *blurEffect;
blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
UIVisualEffectView *visualEffectView;
visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

visualEffectView.frame = self.view.bounds;

UIView *removeView;
while((removeView = [self.view viewWithTag:11]) != nil) {
    [removeView removeFromSuperview];

}
self.view.tag = 7;
UIImageView *imgView = [[UIImageView alloc] initWithImage:[self artworkImage]];
UIImageView *imgBlur = [[UIImageView alloc] initWithImage:[self artworkImage]];
imgBlur.frame = self.view.frame;
imgBlur.tag = 11;
imgView.tag = 11;
imgView.frame = CGRectMake(self.view.frame.size.height /2,self.view.frame.size.height /2,2,2);
[self.view addSubview:imgBlur];
[imgBlur addSubview:visualEffectView];
[visualEffectView addSubview:imgView];
double ArtworkWidth = self.view.frame.size.width * .01 * kArtworkSize;
double ArtworkHeight = self.view.frame.size.height * .01 * kArtworkSize;
[UIView animateWithDuration:.5
                     animations:^{
                         imgView.frame = CGRectMake((self.view.frame.size.width/2) - (ArtworkWidth / 2),
                             (self.view.frame.size.height / 2) - (ArtworkHeight / 2),
                             ArtworkWidth, 
                             ArtworkHeight);
                     }];
imgView.layer.masksToBounds = YES;
imgView.layer.cornerRadius = imgView.frame.size.height * 0.5 * 0.01 * kArtworkCornerRadius;
NSLog(@"I did it again");
}
else if (kArtworkBlurStyle == 2) {
    UIVisualEffect *blurEffect;
blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
UIVisualEffectView *visualEffectView;
visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

visualEffectView.frame = self.view.bounds;

UIView *removeView;
while((removeView = [self.view viewWithTag:11]) != nil) {
    [removeView removeFromSuperview];

}
self.view.tag = 7;
UIImageView *imgView = [[UIImageView alloc] initWithImage:[self artworkImage]];
UIImageView *imgBlur = [[UIImageView alloc] initWithImage:[self artworkImage]];
imgBlur.frame = self.view.frame;
imgBlur.tag = 11;
imgView.tag = 11;
imgView.frame = CGRectMake(self.view.frame.size.height /2,self.view.frame.size.height /2,2,2);
[self.view addSubview:imgBlur];
double ArtworkWidth = self.view.frame.size.width * .01 * kArtworkSize;
double ArtworkHeight = self.view.frame.size.height * .01 * kArtworkSize;
[imgBlur addSubview:visualEffectView];
[visualEffectView addSubview:imgView];
[UIView animateWithDuration:.5
                     animations:^{
                         imgView.frame = CGRectMake((self.view.frame.size.width/2) - (ArtworkWidth / 2),
                             (self.view.frame.size.height / 2) - (ArtworkHeight / 2),
                             ArtworkWidth, 
                             ArtworkHeight);
                     }];
imgView.layer.masksToBounds = YES;
imgView.layer.cornerRadius = imgView.frame.size.height * 0.5 * 0.01 * kArtworkCornerRadius;
NSLog(@"I did it again");
}
else if (kArtworkBlurStyle == 1) {
    UIVisualEffect *blurEffect;
blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
UIVisualEffectView *visualEffectView;
visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

visualEffectView.frame = self.view.bounds;

UIView *removeView;
while((removeView = [self.view viewWithTag:11]) != nil) {
    [removeView removeFromSuperview];

}
self.view.tag = 7;
UIImageView *imgView = [[UIImageView alloc] initWithImage:[self artworkImage]];
UIImageView *imgBlur = [[UIImageView alloc] initWithImage:[self artworkImage]];
imgBlur.frame = self.view.frame;
imgBlur.tag = 11;
imgView.tag = 11;
imgView.frame = CGRectMake(self.view.frame.size.height /2,self.view.frame.size.height /2,2,2);
[self.view addSubview:imgBlur];
[imgBlur addSubview:visualEffectView];
double ArtworkWidth = self.view.frame.size.width * .01 * kArtworkSize;
double ArtworkHeight = self.view.frame.size.height * .01 * kArtworkSize;
[visualEffectView addSubview:imgView];
[UIView animateWithDuration:.5
                     animations:^{
                         imgView.frame = CGRectMake((self.view.frame.size.width/2) - (ArtworkWidth / 2),
                             (self.view.frame.size.height / 2) - (ArtworkHeight / 2),
                             ArtworkWidth, 
                             ArtworkHeight);
                     }];
imgView.layer.masksToBounds = YES;
imgView.layer.cornerRadius = imgView.frame.size.height * 0.5 * 0.01 * kArtworkCornerRadius;
NSLog(@"I did it again");
}
return %orig;
}


%end

%hook MusicNowPlayingViewController
- (id)initWithPlayer:(id)arg1 {
    artworknoblur = %orig;
    return  artworknoblur;
}
%end
%hook UINavigationItem
- (void)setLeftBarButtonItems:(id)arg1 {
            #define kBundlePath @"/Library/MobileSubstrate/DynamicLibraries/Apollo.bundle"

        //Get the Bundle
        NSBundle *bundle = [[NSBundle alloc] initWithPath:kBundlePath];
        
        //Get Path to Image
        NSString *imagePath = [bundle pathForResource:@"shuffle" ofType:@"png"];

        //UIImage From File
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
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
%hook UITableView
-(void)setSeparatorStyle:(int)arg1 {
    if (kMPSeparators) %orig(0);
    else %orig;
}
%end
%hook MusicTabBarController
-(BOOL)isMiniPlayerVisible {
    if (kAlwaysMiniPlayer) return YES;
    return %orig;
}
-(void)setMiniPlayerVisible:(BOOL)arg1 {
    if (kAlwaysMiniPlayer) return %orig(YES);
    else %orig;
}
%end
%end
%hook MPMediaItemCollection
-(id)albumArtistArtworkCatalog {
    if (kArtistAlbumArt) return nil;
    return %orig;
}
-(id)artistArtworkCatalog {
    if (kArtistAlbumArt) return nil;
    return %orig;

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
    if (![[%c(SBMediaController) sharedInstance] isPlaying] )
        return;
    if ([self volume] <= 0.5 && kAutoMusicPause)
        [[%c(SBMediaController) sharedInstance] pause];
}
- (void)increaseVolume {
    %orig;
    if (![[%c(SBMediaController) sharedInstance] hasTrack])
    return;
    if ([[%c(SBMediaController) sharedInstance] hasTrack] && kAutoMusicPause)
    [[%c(SBMediaController) sharedInstance] play];
    if ([self volume] > [self volumeStepUp])
        return; 
}
%end
%hook MusicNowPlayingAtmosphericStatusBar
-(void)layoutSubviews {
    %orig;
    if (kNowPlayingHideStatusBar) {
        [self setHidden: TRUE];
    }
}
%end
@interface SKUICrossFadingTabBarButton : UIControl
@end
@interface SKUITabBarItem : NSObject
@property (nonatomic, retain) Class rootViewControllerClass;
@property (nonatomic, readonly) NSString *tabIdentifier;
@property (nonatomic, retain) UITabBarItem *underlyingTabBarItem;
- (id)initWithTabIdentifier:(id)arg1;
@end
static void loadPrefs() {

       NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.atwiiks.apollo.plist"];
    if(prefs)
    {
        kEnabled = ([prefs objectForKey:@"isEnabled"] ? [[prefs objectForKey:@"isEnabled"] boolValue] : kEnabled);
        kGesturesEnabled = ([prefs objectForKey:@"GesturesEnabled"] ? [[prefs objectForKey:@"GesturesEnabled"] boolValue] : kGesturesEnabled);
        kNowPlayingGestures = ([prefs objectForKey:@"NowPlayingGestures"] ? [[prefs objectForKey:@"NowPlayingGestures"] boolValue] : kNowPlayingGestures);
        kMiniPlayerGestures = ([prefs objectForKey:@"MiniPlayerGestures"] ? [[prefs objectForKey:@"MiniPlayerGestures"] boolValue] : kMiniPlayerGestures);
        kNowPlayingFowardTransport = ([prefs objectForKey:@"NowPlayingFowardTransport"] ? [[prefs objectForKey:@"NowPlayingFowardTransport"] boolValue] : kNowPlayingFowardTransport);
        kNowPlayingPreviousTransport = ([prefs objectForKey:@"NowPlayingPreviousTransport"] ? [[prefs objectForKey:@"NowPlayingPreviousTransport"] boolValue] : kNowPlayingPreviousTransport);
        kNowPlayingPlayPauseToggleTransport = ([prefs objectForKey:@"NowPlayingPlayPauseToggleTransport"] ? [[prefs objectForKey:@"NowPlayingPlayPauseToggleTransport"] boolValue] : kNowPlayingPlayPauseToggleTransport);
        kNowPlayingIntervalFowardTransport = ([prefs objectForKey:@"NowPlayingIntervalFowardTransport"] ? [[prefs objectForKey:@"NowPlayingIntervalFowardTransport"] boolValue] : kNowPlayingIntervalFowardTransport);
        kNowPlayingIntervalBackwardTransport = ([prefs objectForKey:@"NowPlayingIntervalBackwardTransport"] ? [[prefs objectForKey:@"NowPlayingIntervalBackwardTransport"] boolValue] : kNowPlayingIntervalBackwardTransport);
        kNowPlayingShuffleTransport = ([prefs objectForKey:@"NowPlayingShuffleTransport"] ? [[prefs objectForKey:@"NowPlayingShuffleTransport"] boolValue] : kNowPlayingShuffleTransport);
        kNowPlayingRepeatTransport = ([prefs objectForKey:@"NowPlayingRepeatTransport"] ? [[prefs objectForKey:@"NowPlayingRepeatTransport"] boolValue] : kNowPlayingRepeatTransport);
        kNowPlayingUpNextTransport = ([prefs objectForKey:@"NowPlayingUpNextTransport"] ? [[prefs objectForKey:@"NowPlayingUpNextTransport"] boolValue] : kNowPlayingUpNextTransport);
        kNowPlayingShareTransport = ([prefs objectForKey:@"NowPlayingShareTransport"] ? [[prefs objectForKey:@"NowPlayingShareTransport"] boolValue] : kNowPlayingShareTransport);
        kNowPlayingHeartTransport = ([prefs objectForKey:@"NowPlayingHeartTransport"] ? [[prefs objectForKey:@"NowPlayingHeartTransport"] boolValue] : kNowPlayingHeartTransport);
        kNowPlayingContextualTransport = ([prefs objectForKey:@"NowPlayingContextualTransport"] ? [[prefs objectForKey:@"NowPlayingContextualTransport"] boolValue] : kNowPlayingContextualTransport);
        kScrubberTransport = ([prefs objectForKey:@"ScrubberTransport"] ? [[prefs objectForKey:@"ScrubberTransport"] boolValue] : kScrubberTransport);
        kVolumeSlider = ([prefs objectForKey:@"VolumeSlider"] ? [[prefs objectForKey:@"VolumeSlider"] boolValue] : kVolumeSlider);
        kMPSeparators = ([prefs objectForKey:@"MPSeparators"] ? [[prefs objectForKey:@"MPSeparators"] boolValue] : kMPSeparators);
        kIndexBar = ([prefs objectForKey:@"IndexBar"] ? [[prefs objectForKey:@"IndexBar"] boolValue] : kIndexBar);
        kNowPlayingBlur = ([prefs objectForKey:@"NowPlayingBlur"] ? [[prefs objectForKey:@"NowPlayingBlur"] boolValue] : kNowPlayingBlur);
        kNowPlayingFloatingArrow = ([prefs objectForKey:@"NowPlayingFloatingArrow"] ? [[prefs objectForKey:@"NowPlayingFloatingArrow"] boolValue] : kNowPlayingFloatingArrow);
        kRadioTab = ([prefs objectForKey:@"RadioTab"] ? [[prefs objectForKey:@"RadioTab"] boolValue] : kRadioTab);
        kConnectTab = ([prefs objectForKey:@"ConnectTab"] ? [[prefs objectForKey:@"ConnectTab"] boolValue] : kConnectTab);
        kNewTab  = ([prefs objectForKey:@"NewTab "] ? [[prefs objectForKey:@"NewTab "] boolValue] : kNewTab );
        kMPSearchDefault = ([prefs objectForKey:@"MPSearchDefault"] ? [[prefs objectForKey:@"MPSearchDefault"] boolValue] : kMPSearchDefault);
        kAppleMusicBackgroundColor = ([prefs objectForKey:@"AppleMusicBackgroundColor"] ? [[prefs objectForKey:@"AppleMusicBackgroundColor"] boolValue] : kAppleMusicBackgroundColor);
        kAutoMusicPause = ([prefs objectForKey:@"AutoMusicPause"] ? [[prefs objectForKey:@"AutoMusicPause"] boolValue] : kAutoMusicPause);
        kAlwaysMiniPlayer = ([prefs objectForKey:@"AlwaysMiniPlayer"] ? [[prefs objectForKey:@"AlwaysMiniPlayer"] boolValue] : kAlwaysMiniPlayer);
        kBookmarkPosition = ([prefs objectForKey:@"BookmarkPosition"] ? [[prefs objectForKey:@"BookmarkPosition"] boolValue] : kBookmarkPosition);
        kArtistAlbumArt = ([prefs objectForKey:@"ArtistAlbumArt"] ? [[prefs objectForKey:@"ArtistAlbumArt"] boolValue] : kArtistAlbumArt);
        kNowPlayingSwipeRightAction = ([prefs objectForKey:@"NowPlayingSwipeRightAction"] ? [[prefs objectForKey:@"NowPlayingSwipeRightAction"] integerValue] : kNowPlayingSwipeRightAction);
        kNowPlayingSwipeLeftAction = ([prefs objectForKey:@"NowPlayingSwipeLeftAction"] ? [[prefs objectForKey:@"NowPlayingSwipeLeftAction"] integerValue] : kNowPlayingSwipeLeftAction);
        kNowPlayingSwipeRightTwoFingersAction = ([prefs objectForKey:@"NowPlayingSwipeRightTwoFingersAction"] ? [[prefs objectForKey:@"NowPlayingSwipeRightTwoFingersAction"] integerValue] : kNowPlayingSwipeRightTwoFingersAction);
        kNowPlayingSwipeLeftTwoFingersAction = ([prefs objectForKey:@"NowPlayingSwipeLeftTwoFingersAction"] ? [[prefs objectForKey:@"NowPlayingSwipeLeftTwoFingersAction"] integerValue] : kNowPlayingSwipeLeftTwoFingersAction);
        kNowPlayingDoubleTapAction = ([prefs objectForKey:@"NowPlayingDoubleTapAction"] ? [[prefs objectForKey:@"NowPlayingDoubleTapAction"] integerValue] : kNowPlayingDoubleTapAction);
        kMiniPlayerSwipeRightAction = ([prefs objectForKey:@"MiniPlayerSwipeRightAction"] ? [[prefs objectForKey:@"MiniPlayerSwipeRightAction"] integerValue] : kMiniPlayerSwipeRightAction);
        kMiniPlayerSwipeLeftAction = ([prefs objectForKey:@"MiniPlayerSwipeLeftAction"] ? [[prefs objectForKey:@"MiniPlayerSwipeLeftAction"] integerValue] : kMiniPlayerSwipeLeftAction);
        kCCGesturesEnabled = ([prefs objectForKey:@"CCGesturesEnabled"] ? [[prefs objectForKey:@"CCGesturesEnabled"] boolValue] : kCCGesturesEnabled);
        kCCSwipeRightAction = ([prefs objectForKey:@"CCSwipeRightAction"] ? [[prefs objectForKey:@"CCSwipeRightAction"] integerValue] : kCCSwipeRightAction);
        kCCSwipeLeftAction = ([prefs objectForKey:@"CCSwipeLeftAction"] ? [[prefs objectForKey:@"CCSwipeLeftAction"] integerValue] : kCCSwipeLeftAction);
        kCCSwipeRightTwoFingersAction = ([prefs objectForKey:@"CCSwipeRightTwoFingersAction"] ? [[prefs objectForKey:@"CCSwipeRightTwoFingersAction"] integerValue] : kCCSwipeRightTwoFingersAction);
        kCCSwipeLeftTwoFingersAction = ([prefs objectForKey:@"CCSwipeLeftTwoFingersAction"] ? [[prefs objectForKey:@"CCSwipeLeftTwoFingersAction"] integerValue] : kCCSwipeLeftTwoFingersAction);
        kCCDoubleTapAction = ([prefs objectForKey:@"CCDoubleTapAction"] ? [[prefs objectForKey:@"CCDoubleTapAction"] integerValue] : kCCDoubleTapAction);
        kCCShortPressAction = ([prefs objectForKey:@"CCShortPressAction"] ? [[prefs objectForKey:@"CCShortPressAction"] integerValue] : kCCShortPressAction);
        kCCLongPressAction = ([prefs objectForKey:@"CCLongPressAction"] ? [[prefs objectForKey:@"CCLongPressAction"] integerValue] : kCCLongPressAction);
        kLSGesturesEnabled = ([prefs objectForKey:@"LSGesturesEnabled"] ? [[prefs objectForKey:@"LSGesturesEnabled"] boolValue] : kLSGesturesEnabled);
        kLSSwipeRightAction = ([prefs objectForKey:@"LSSwipeRightAction"] ? [[prefs objectForKey:@"LSSwipeRightAction"] integerValue] : kLSSwipeRightAction);
        kLSSwipeLeftAction = ([prefs objectForKey:@"LSSwipeLeftAction"] ? [[prefs objectForKey:@"LSSwipeLeftAction"] integerValue] : kLSSwipeLeftAction);
        kLSDoubleTapAction = ([prefs objectForKey:@"LSDoubleTapAction"] ? [[prefs objectForKey:@"LSDoubleTapAction"] integerValue] : kLSDoubleTapAction);
        kLSShortPressAction = ([prefs objectForKey:@"LSShortPressAction"] ? [[prefs objectForKey:@"LSShortPressAction"] integerValue] : kLSShortPressAction);
        kLSLongPressAction = ([prefs objectForKey:@"LSLongPressAction"] ? [[prefs objectForKey:@"LSLongPressAction"] integerValue] : kLSLongPressAction);
        kSBDoubleTapArtworkAction = ([prefs objectForKey:@"SBDoubleTapArtworkAction"] ? [[prefs objectForKey:@"SBDoubleTapArtworkAction"] integerValue] : kSBDoubleTapArtworkAction);
        kCleanAppleMusic = ([prefs objectForKey:@"CleanAppleMusic"] ? [[prefs objectForKey:@"CleanAppleMusic"] boolValue] : kCleanAppleMusic);
        kAuxoLegacySwipeRightAction = ([prefs objectForKey:@"AuxoLegacySwipeRightAction"] ? [[prefs objectForKey:@"AuxoLegacySwipeRightAction"] integerValue] : kAuxoLegacySwipeRightAction);
        kAuxoLegacySwipeLeftAction = ([prefs objectForKey:@"AuxoLegacySwipeLeftAction"] ? [[prefs objectForKey:@"AuxoLegacySwipeLeftAction"] integerValue] : kAuxoLegacySwipeLeftAction);
        kCCDoubleTapTitleAction = ([prefs objectForKey:@"CCDoubleTapTitleAction"] ? [[prefs objectForKey:@"CCDoubleTapTitleAction"] integerValue] : kCCDoubleTapTitleAction);
        kLockScreenFowardTransport = ([prefs objectForKey:@"LockScreenFowardTransport"] ? [[prefs objectForKey:@"LockScreenFowardTransport"] boolValue] : kLockScreenFowardTransport);
        kLockScreenPreviousTransport = ([prefs objectForKey:@"LockScreenPreviousTransport"] ? [[prefs objectForKey:@"LockScreenPreviousTransport"] boolValue] : kLockScreenPreviousTransport);
        kLockScreenPlayPauseToggleTransport = ([prefs objectForKey:@"LockScreenPlayPauseToggleTransport"] ? [[prefs objectForKey:@"LockScreenPlayPauseToggleTransport"] boolValue] : kLockScreenPlayPauseToggleTransport);
        kLockScreenIntervalFowardTransport = ([prefs objectForKey:@"LockScreenIntervalFowardTransport"] ? [[prefs objectForKey:@"LockScreenIntervalFowardTransport"] boolValue] : kLockScreenIntervalFowardTransport);
        kLockScreenIntervalBackwardTransport = ([prefs objectForKey:@"LockScreenIntervalBackwardTransport"] ? [[prefs objectForKey:@"LockScreenIntervalBackwardTransport"] boolValue] : kLockScreenIntervalBackwardTransport);
        kLockScreenUpNextTransport = ([prefs objectForKey:@"LockScreenUpNextTransport"] ? [[prefs objectForKey:@"LockScreenUpNextTransport"] boolValue] : kLockScreenUpNextTransport);
        kLockScreenShareTransport = ([prefs objectForKey:@"LockScreenShareTransport"] ? [[prefs objectForKey:@"LockScreenShareTransport"] boolValue] : kLockScreenShareTransport);
        kLockScreenHeartTransport = ([prefs objectForKey:@"LockScreenHeartTransport"] ? [[prefs objectForKey:@"LockScreenHeartTransport"] boolValue] : kLockScreenHeartTransport);
        kControlCenterFowardTransport = ([prefs objectForKey:@"ControlCenterFowardTransport"] ? [[prefs objectForKey:@"ControlCenterFowardTransport"] boolValue] : kControlCenterFowardTransport);
        kControlCenterPreviousTransport = ([prefs objectForKey:@"ControlCenterPreviousTransport"] ? [[prefs objectForKey:@"ControlCenterPreviousTransport"] boolValue] : kControlCenterPreviousTransport);
        kControlCenterPlayPauseToggleTransport = ([prefs objectForKey:@"ControlCenterPlayPauseToggleTransport"] ? [[prefs objectForKey:@"ControlCenterPlayPauseToggleTransport"] boolValue] : kControlCenterPlayPauseToggleTransport);
        kControlCenterIntervalFowardTransport = ([prefs objectForKey:@"ControlCenterIntervalFowardTransport"] ? [[prefs objectForKey:@"ControlCenterIntervalFowardTransport"] boolValue] : kControlCenterIntervalFowardTransport);
        kControlCenterIntervalBackwardTransport = ([prefs objectForKey:@"ControlCenterIntervalBackwardTransport"] ? [[prefs objectForKey:@"ControlCenterIntervalBackwardTransport"] boolValue] : kControlCenterIntervalBackwardTransport);
        kControlCenterUpNextTransport = ([prefs objectForKey:@"ControlCenterUpNextTransport"] ? [[prefs objectForKey:@"ControlCenterUpNextTransport"] boolValue] : kControlCenterUpNextTransport);
        kControlCenterShareTransport = ([prefs objectForKey:@"ControlCenterShareTransport"] ? [[prefs objectForKey:@"ControlCenterShareTransport"] boolValue] : kControlCenterShareTransport);
        kControlCenterHeartTransport = ([prefs objectForKey:@"ControlCenterHeartTransport"] ? [[prefs objectForKey:@"ControlCenterHeartTransport"] boolValue] : kControlCenterHeartTransport);
        kArtworkBlurStyle = ([prefs objectForKey:@"ArtworkBlurStyle"] ? [[prefs objectForKey:@"ArtworkBlurStyle"] integerValue] : kArtworkBlurStyle);
        kArtworkCornerRadius = ([prefs objectForKey:@"ArtworkCornerRadius"] ? [[prefs objectForKey:@"ArtworkCornerRadius"] integerValue] : kArtworkCornerRadius);
        kArtworkSize = ([prefs objectForKey:@"ArtworkSize"] ? [[prefs objectForKey:@"ArtworkSize"] integerValue] : kArtworkSize);
        kMiniPlayerPlayPauseToggleTransport = ([prefs objectForKey:@"MiniPlayerPlayPauseToggleTransport"] ? [[prefs objectForKey:@"MiniPlayerPlayPauseToggleTransport"] boolValue] : kMiniPlayerPlayPauseToggleTransport);
        kMiniPlayerContextualTransport = ([prefs objectForKey:@"MiniPlayerContextualTransport"] ? [[prefs objectForKey:@"MiniPlayerContextualTransport"] boolValue] : kMiniPlayerContextualTransport);
        kNowPlayingHideStatusBar = ([prefs objectForKey:@"NowPlayingHideStatusBar"] ? [[prefs objectForKey:@"NowPlayingHideStatusBar"] boolValue] : kNowPlayingHideStatusBar);
        kNowPlayingDarkGradient = ([prefs objectForKey:@"NowPlayingDarkGradient"] ? [[prefs objectForKey:@"NowPlayingDarkGradient"] boolValue] : YES);
        kForYouTab = ([prefs objectForKey:@"ForYouTab"] ? [[prefs objectForKey:@"ForYouTab"] boolValue] : YES);
        kNewTab = ([prefs objectForKey:@"NewTab"] ? [[prefs objectForKey:@"NewTab"] boolValue] : YES);
        kRadioTab = ([prefs objectForKey:@"RadioTab"] ? [[prefs objectForKey:@"RadioTab"] boolValue] : YES);
        kConnectTab = ([prefs objectForKey:@"ConnectTab"] ? [[prefs objectForKey:@"ConnectTab"] boolValue] : YES);
        kMyMusicTab = ([prefs objectForKey:@"MyMusicTab"] ? [[prefs objectForKey:@"MyMusicTab"] boolValue] : YES);
        kGeniusMixesTab = ([prefs objectForKey:@"GeniusMixesTab"] ? [[prefs objectForKey:@"GeniusMixesTab"] boolValue] : NO);
        kPlaylistsTab = ([prefs objectForKey:@"PlaylistsTab"] ? [[prefs objectForKey:@"PlaylistsTab"] boolValue] : NO);
        kStartUpTab = ([prefs objectForKey:@"StartUpTab"] ? [[prefs objectForKey:@"StartUpTab"] integerValue] : kStartUpTab);
    }
    [prefs release];
}

static void settingschanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    loadPrefs();
}

%ctor{

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingschanged, CFSTR("com.atwiiks.apollo/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}
%ctor
{
  %init;
  if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.Music"]) {
        %init(Music);
    }
}

