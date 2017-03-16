#import <UIKit/UIKit.h>

@class MusicNowPlayingItemViewController;
@interface MusicRemoteController : NSObject 
- (int)_handleAddToLibraryCommand:(id)arg1; //Add to My Music on double tap
- (int)_handleLikeCommand:(id)arg1; // Like Track Music Remote Command
@end
@interface MPUTransportControl : UIView
@end

@interface MPUTransportControlsView : UIView
- (MPUTransportControl *)availableTransportControlWithType:(NSInteger)type; // Available Media Remote Commands
@end

@interface MPAVController : NSObject
@property (nonatomic, readwrite) NSTimeInterval currentTime; // Current Time in Song
- (void)togglePlayback; // Toggle Play/Pause
- (void)changePlaybackIndexBy:(CGFloat)index; // Change where you are in the Queue
@end
@interface MusicAVPlayer : NSObject
@property (nonatomic, readwrite) NSTimeInterval currentTime; // Current time in song
- (BOOL)isSeekingOrScrubbing; // Is the user seekings in the song
- (void)beginSeek:(NSInteger)direction; // Start seeking in the song
- (void)endSeek; // Stop Seeking
- (void)togglePlayback; // Toggle Play/Pause
- (void)changePlaybackIndexBy:(CGFloat)index; // Change where you are in the Queue
@end

@interface MPUTransportControlMediaRemoteController : NSObject // Just needed
@end

@interface MusicMiniPlayerViewController : UIViewController // MiniPlayer
  - (MPAVController *)player; //Music Player
  - (MPUTransportControlMediaRemoteController *)transportControlMediaRemoteController; // Media Commands Controller
  - (MPUTransportControlsView *)transportControlsView; // View used for the selector "tapOnControlType"
  - (void)transportControlsView:(MPUTransportControlsView *)view tapOnControlType:(NSInteger)type; // method we use to call media commands in the Mini Player
@end

@interface MusicNowPlayingViewController : UIViewController // Now Playing View
- (MusicAVPlayer *)player; // Music Player
- (MusicNowPlayingItemViewController *)currentItemViewController; // Subview of the Now Playing View
- (MPUTransportControlsView *)transportControls; // Buttons for actions, We use this for the selector "tapOnControlType"
- (void)transportControlsView:(MPUTransportControlsView *)view tapOnControlType:(NSInteger)type; // method we call to send Media Commands
@end

@interface MusicNowPlayingItemViewController : MusicNowPlayingViewController
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

static UISwipeGestureRecognizer *artworkcontrolLeftSwipeGestureRecognizer, *artworkcontrolRightSwipeGestureRecognizer, *artworkcontrolLeftDoubleSwipeGestureRecognizer, *artworkcontrolRightDoubleSwipeGestureRecognizer; // Swipe Recognizers for Now Playing View
static UIPanGestureRecognizer *miniplayerPanGestureRecognizer; // MiniPlayer Pan Universal Gesture
static UITapGestureRecognizer *artworkcontrolDoubleTapGestureRecognizer; // Now Playing Double Tap Gesture

static id addLibrary; // Shared Object to add a song to "My Music"

%hook MusicRemoteController // Remote for the Music Player
- (id)initWithPlayer:(id)arg1 {  
	addLibrary = %orig; // Defining the Shared Object
	return addLibrary; // Calling it back to create the Shared Object
}
- (int)_handleLikeCommand:(id)arg1 { // Handles Liking a Track
	return 0; // What workjs apparently
	[self _handleAddToLibraryCommand:0]; // Calling Add to Library after Like Command  
}
%end
%hook MusicNowPlayingViewController // Now Playing View
- (void)_handleTransitionPanGestureRecognizerAction:(id)arg1 {
	return;
}


- (void)viewDidLayoutSubviews { // Method I'm Hijacking to create all my UIGestureRecognizers
	%orig(); // call the original implimentation first to prevent Broken UI
// Now Playing View Gestures
	if (![self.view.gestureRecognizers containsObject:artworkcontrolRightSwipeGestureRecognizer]) {	// Making sure it's what I want
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
}

%new // Creating a New Method
- (void)artworkcontrol_leftSwipeRecognized:(UISwipeGestureRecognizer *)sender { // One Finger Swipe Left Recognized
	if (sender.state == UIGestureRecognizerStateEnded) { // We Stopped Swiping
		[self transportControlsView:self.transportControls tapOnControlType:1]; // tapping on the Transport Control button that has the type "1", This will call the "Go to Previous Song" Command
	 	// [self transportControlsView:self.transportControls tapOnControlType:4]; (Inverse Swiping Option Enabled)
	}
}

%new // Creating a New Method
- (void)artworkcontrol_rightSwipeRecognized:(UISwipeGestureRecognizer *)sender { // One Finger Swipe Right Recognized
	if (sender.state == UIGestureRecognizerStateEnded) { // We Stopped Swiping
		[self transportControlsView:self.transportControls tapOnControlType:4]; // tapping on the Transport Control button that has the type "4", This will call the "Skip to Next Song" Command
	 	// [self transportControlsView:self.transportControls tapOnControlType:1]; (Inverse Swiping Option Enabled)
	}
}

%new // Creating a New Method
- (void)artworkcontrol_leftDoubleSwipeRecognized:(UISwipeGestureRecognizer *)sender { // Two Finger Swipe Left Recognized
	if (sender.state == UIGestureRecognizerStateEnded) { // We Stopped Swiping
		self.player.currentTime = self.player.currentTime - 15; // Take the Now Playing Time and take away 15 seconds
		// self.player.currentTime = self.player.currentTime + 15; (Inverse Swiping Option Enabled)
	}
}

%new
- (void)artworkcontrol_rightDoubleSwipeRecognized:(UISwipeGestureRecognizer *)sender {  // Two Finger Swipe Right Recognized
	if (sender.state == UIGestureRecognizerStateEnded) { // We Stopped Swiping
		self.player.currentTime = self.player.currentTime + 15; // Take the Now Playing Time and add 15 seconds
		// self.player.currentTime = self.player.currentTime - 15; (Inverse Swiping Enabled)
	}
}
%new // Creating a New Method
- (void)artworkcontrol_doubleTapRecognized:(UITapGestureRecognizer *)sender { // Double Tap Recognized
	if (sender.state == UIGestureRecognizerStateEnded) { // We tapped for the Second Time in a row which ends our Gesture
		[addLibrary _handleAddToLibraryCommand:0]; // Add the Currently Playing Song to the Music Library
	}
}
%end // Bye Bye Now Playing View Gestures and Hello Mini Player Panning Gestures
%hook MusicMiniPlayerViewController // The MiniPlayer's View Controller
- (void)_panRecognized:(id)arg1 {
	return;
}
- (id)nowPlayingPresentationPanRecognizer {
	return NULL;
}
- (void)setNowPlayingPresentationPanRecognizer:(id)arg1 {
	return;
}
- (void)viewDidLoad { // The MiniPlayer View Did Load
	%orig(); // Call the Original Implimentation so we We don't mess up the UI
		miniplayerPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(miniplayer_PanGestureRecognized:)]; // Defining Our Main Pan Gesture recognizer

		[self.view addGestureRecognizer:miniplayerPanGestureRecognizer]; // Adding our Main Pan Gesture recognizer to the MiniPlayer View
		[miniplayerPanGestureRecognizer release]; // Releasing the Main Pan Gesture recognizer to prevent Memory Leaks
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
	[addLibrary _handleAddToLibraryCommand:0]; // Add the currently playing Song to "My Music"
}
%new // Create a New Method for a Pan to the Left
- (void)handleLeftGesture:(UIPanGestureRecognizer *)sender  // Handle Left Pan Action
{
    [self transportControlsView:self.transportControlsView tapOnControlType:1]; // Send a Command to the TransportControlView that we *tapped* the "Previous Song" Button
    // [self transportControlsView:self.transportControlsView tapOnControlType:3]; (Inverse Swiping Option Enabled)
}
%new // Create a New Method for a Pan to the Left
- (void)handleRightGesture:(UIPanGestureRecognizer *)sender // Handle Right Pan Action
{
    [self transportControlsView:self.transportControlsView tapOnControlType:4]; // Send a Command to the TransportControlView that we *tapped* the "Skip to Next Song" Button
    // [self transportControlsView:self.transportControlsView tapOnControlType:1]; (Inverse Swiping Option Enabled)
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
%hook ML3Container
+(void)_insertNewSmartPlaylist:(id)arg1 criteriaBlob:(id)arg2 evaluationOrder:(unsigned long)arg3 limited:(char)arg4 trackOrder:(unsigned long)arg5 distinguishedKind:(int)arg6 inLibrary:(id)arg7 cachedNameOrders:(id)arg8  { %log; %orig; }
%end