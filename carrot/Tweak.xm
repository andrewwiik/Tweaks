#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#define SCREEN ([UIScreen mainScreen].bounds)

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
@interface MPUNowPlayingController : NSObject
@property (nonatomic, readonly) double currentDuration;
@property (nonatomic, readonly) double currentElapsed;
@end

@interface MPUSystemMediaControlsViewController : UIViewController {
	MPUNowPlayingController *_nowPlayingController;
}
- (BOOL)_mediaRemoteCommandIsSupportedAndEnabled:(unsigned int)arg1;
@end

@interface MPUTransportControlMediaRemoteController : NSObject
@property (nonatomic, readonly) unsigned int shuffleType;
@property (nonatomic, readonly) unsigned int repeatType;
@end

@interface MusicNowPlayingViewController : UIViewController
- (id)_imageForTransportButtonWithControlType:(int)arg1 usingTransportControlMediaRemoteController:(id)arg2;
@end


@interface MPUTransportControl : NSObject
@property(readonly, nonatomic) int type;
+ (instancetype)transportControlWithType:(NSInteger)type group:(int)position;
@end

@interface MPUTransportControlsView : UIView
@property (nonatomic, copy) NSArray *availableTransportControls;
- (void)setMinimumNumberOfTransportButtonsForLayout:(unsigned int)arg1;
- (void)addShuffle;
+ (NSArray *)defaultTransportControls;
- (MPUSystemMediaControlsViewController *)delegate;
- (void)resetButtons;
- (void)_willRemoveTransportButton:(id)arg1;
- (void)test123;
- (BOOL)isPlaying;
- (id)_transportButtonForControlType:(int)arg1;
- (BOOL)isShuffled;
- (BOOL)isRepeating;
@end

@interface MPUTransportButton : UIView
- (void)setSelected:(BOOL)arg1;
- (void)setSelectedColor:(id)arg1;
- (MPUTransportControlsView *)superview;
@end

@interface NSMutableArray (Convenience)

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end

@implementation NSMutableArray (Convenience)

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    // Optional toIndex adjustment if you think toIndex refers to the position in the array before the move (as per Richard's comment)
    if (fromIndex < toIndex) {
        toIndex--; // Optional 
    }

    id object = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    [self insertObject:object atIndex:toIndex];
}

@end

static BOOL isShuffled;
static BOOL isRepeating;
static BOOL enabled;
static BOOL white;
static BOOL shouldInset;
static CGFloat insetValue;
static BOOL replace;
static BOOL highContrast;
static BOOL intervalInstead;


static void loadPrefs() {
	dispatch_async(dispatch_get_main_queue(), ^{
    	NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.creatix.carrot.plist"];
    	enabled = [prefs objectForKey:@"isEnabled"] ? [[prefs objectForKey:@"isEnabled"] boolValue] : YES;
    	white = [prefs objectForKey:@"isWhite"] ? [[prefs objectForKey:@"isWhite"] boolValue] : NO;
    	replace = [prefs objectForKey:@"isSwitched"] ? [[prefs objectForKey:@"isSwitched"] boolValue] : NO;
    	highContrast = [prefs objectForKey:@"isHighContrast"] ? [[prefs objectForKey:@"isHighContrast"] boolValue] : NO;
    	intervalInstead = [prefs objectForKey:@"useIntervalInstead"] ? [[prefs objectForKey:@"useIntervalInstead"] boolValue] : NO;
    	insetValue = [prefs objectForKey:@"customInsetValue"] ? [[prefs objectForKey:@"customInsetValue"] floatValue] : 0.0f;
    });
}


%hook MPUTransportControlsView // Hook for the MPUTransportControlsView Clas

%new
- (BOOL)isShuffled {
	MPUTransportControlMediaRemoteController *dataHelper = MSHookIvar<id>([self delegate],"_transportControlMediaRemoteController");
	if (dataHelper.shuffleType == 1) {
		isShuffled = YES;
		return YES;
	}
	else {
		isShuffled = NO;
		return NO;
	}
}
%new
- (BOOL)isRepeating {
	MPUTransportControlMediaRemoteController *dataHelper = MSHookIvar<id>([self delegate],"_transportControlMediaRemoteController");
	if (dataHelper.repeatType == 1 || dataHelper.repeatType == 2) {
		isRepeating = YES;
		return YES;
	}
	else {
		isRepeating = NO;
		return NO;
	}
}
%new
- (BOOL)isPlaying {
	MPUSystemMediaControlsViewController *controller = [self delegate];
	MPUNowPlayingController *nowPlayingInfo = MSHookIvar<id>(controller,"_nowPlayingController");
	if (nowPlayingInfo.currentDuration == 0) {
		return NO;
	}
	else {
		return YES;
	}
}
- (void)setAvailableTransportControls:(NSArray *)array {
	dispatch_async(dispatch_get_main_queue(), ^{
		loadPrefs();
		if (enabled) {
			if (![[self delegate] _mediaRemoteCommandIsSupportedAndEnabled: 6]) {
				NSMutableArray *controls = [[NSMutableArray alloc] init];
					MPUTransportControl *playpause = [%c(MPUTransportControl) transportControlWithType:3 group:2];
					MPUTransportControl *next = [%c(MPUTransportControl) transportControlWithType:4 group:3];
					MPUTransportControl *back = [%c(MPUTransportControl) transportControlWithType:1 group:1];
					MPUTransportControl *shuffle = [%c(MPUTransportControl) transportControlWithType:10 group:1];
					MPUTransportControl *repeat = [%c(MPUTransportControl) transportControlWithType:9 group:3];
					[controls addObject:shuffle];
					[controls addObject:back];
					[controls addObject:playpause];
					[controls addObject:next];
					[controls addObject:repeat];
					shouldInset = NO;
					[self setMinimumNumberOfTransportButtonsForLayout:[controls count]];
					%orig([controls copy]);
			}
			else if (![self isPlaying]) {
				if (intervalInstead) {
					NSMutableArray *controls = [[NSMutableArray alloc] init];
					MPUTransportControl *playpause = [%c(MPUTransportControl) transportControlWithType:3 group:2];
					MPUTransportControl *next = [%c(MPUTransportControl) transportControlWithType:4 group:3];
					MPUTransportControl *back = [%c(MPUTransportControl) transportControlWithType:1 group:1];
					MPUTransportControl *backInterval = [%c(MPUTransportControl) transportControlWithType:2 group:1];
					MPUTransportControl *nextInterval = [%c(MPUTransportControl) transportControlWithType:5 group:3];
					[controls addObject:backInterval];
					[controls addObject:back];
					[controls addObject:playpause];
					[controls addObject:next];
					[controls addObject:nextInterval];
					shouldInset = NO;
					[self setMinimumNumberOfTransportButtonsForLayout:[controls count]];
					%orig([controls copy]);
				}
				else {
					NSMutableArray *controls = [[NSMutableArray alloc] init];
					MPUTransportControl *playpause = [%c(MPUTransportControl) transportControlWithType:3 group:2];
					MPUTransportControl *next = [%c(MPUTransportControl) transportControlWithType:4 group:3];
					MPUTransportControl *back = [%c(MPUTransportControl) transportControlWithType:1 group:1];
					MPUTransportControl *shuffle = [%c(MPUTransportControl) transportControlWithType:10 group:1];
					MPUTransportControl *repeat = [%c(MPUTransportControl) transportControlWithType:9 group:3];
					[controls addObject:shuffle];
					[controls addObject:back];
					[controls addObject:playpause];
					[controls addObject:next];
					[controls addObject:repeat];
					shouldInset = NO;
					[self setMinimumNumberOfTransportButtonsForLayout:[controls count]];
					%orig([controls copy]);
				}
			}
			else {
				if (replace) {
					if (intervalInstead) {
						NSMutableArray *controls = [[NSMutableArray alloc] init];
						MPUTransportControl *playpause = [%c(MPUTransportControl) transportControlWithType:3 group:2];
						MPUTransportControl *next = [%c(MPUTransportControl) transportControlWithType:4 group:3];
						MPUTransportControl *back = [%c(MPUTransportControl) transportControlWithType:1 group:1];
						MPUTransportControl *backInterval = [%c(MPUTransportControl) transportControlWithType:2 group:1];
						MPUTransportControl *nextInterval = [%c(MPUTransportControl) transportControlWithType:5 group:3];
						[controls addObject:backInterval];
						[controls addObject:back];
						[controls addObject:playpause];
						[controls addObject:next];
						[controls addObject:nextInterval];
						[self setMinimumNumberOfTransportButtonsForLayout:[controls count]];
						shouldInset = YES;
						%orig([controls copy]);
					}
					else {
						NSMutableArray *controls = [[NSMutableArray alloc] init];
						MPUTransportControl *playpause = [%c(MPUTransportControl) transportControlWithType:3 group:2];
						MPUTransportControl *next = [%c(MPUTransportControl) transportControlWithType:4 group:3];
						MPUTransportControl *back = [%c(MPUTransportControl) transportControlWithType:1 group:1];
						MPUTransportControl *shuffle = [%c(MPUTransportControl) transportControlWithType:10 group:1];
						MPUTransportControl *repeat = [%c(MPUTransportControl) transportControlWithType:9 group:3];
						[controls addObject:shuffle];
						[controls addObject:back];
						[controls addObject:playpause];
						[controls addObject:next];
						[controls addObject:repeat];
						[self setMinimumNumberOfTransportButtonsForLayout:[controls count]];
						shouldInset = YES;
						%orig([controls copy]);
					}
				}
				else {
					if (intervalInstead) {
						NSMutableArray *controls = [[NSMutableArray alloc] init];
						MPUTransportControl *playpause = [%c(MPUTransportControl) transportControlWithType:3 group:2];
						MPUTransportControl *next = [%c(MPUTransportControl) transportControlWithType:4 group:3];
						MPUTransportControl *back = [%c(MPUTransportControl) transportControlWithType:1 group:1];
						MPUTransportControl *backInterval = [%c(MPUTransportControl) transportControlWithType:2 group:1];
						MPUTransportControl *nextInterval = [%c(MPUTransportControl) transportControlWithType:5 group:3];
						MPUTransportControl *like = [%c(MPUTransportControl) transportControlWithType:6 group:1];
						MPUTransportControl *share = [%c(MPUTransportControl) transportControlWithType:8 group:3];
						[controls addObject:backInterval];
						[controls addObject:like];
						[controls addObject:back];
						[controls addObject:playpause];
						[controls addObject:next];
						[controls addObject:share];
						[controls addObject:nextInterval];
						[self setMinimumNumberOfTransportButtonsForLayout:[controls count]];
						shouldInset = YES;
						%orig([controls copy]);
					}
					else {
						NSMutableArray *controls = [[NSMutableArray alloc] init];
						MPUTransportControl *playpause = [%c(MPUTransportControl) transportControlWithType:3 group:2];
						MPUTransportControl *next = [%c(MPUTransportControl) transportControlWithType:4 group:3];
						MPUTransportControl *back = [%c(MPUTransportControl) transportControlWithType:1 group:1];
						MPUTransportControl *shuffle = [%c(MPUTransportControl) transportControlWithType:10 group:1];
						MPUTransportControl *repeat = [%c(MPUTransportControl) transportControlWithType:9 group:3];
						MPUTransportControl *like = [%c(MPUTransportControl) transportControlWithType:6 group:1];
						MPUTransportControl *share = [%c(MPUTransportControl) transportControlWithType:8 group:3];
						[controls addObject:shuffle];
						[controls addObject:like];
						[controls addObject:back];
						[controls addObject:playpause];
						[controls addObject:next];
						[controls addObject:share];
						[controls addObject:repeat];
						[self setMinimumNumberOfTransportButtonsForLayout:[controls count]];
						shouldInset = YES;
						%orig([controls copy]);
					}
				}
			}
		}
		else {
			%orig(array);
			shouldInset = NO;
			[self setMinimumNumberOfTransportButtonsForLayout:[array count]];
		}
	});
}

- (void)_setInsetsForExpandingButtons:(UIEdgeInsets)arg1 {
	if (enabled && shouldInset) {
		%orig(UIEdgeInsetsMake(0.0, insetValue * -1, 0.0, insetValue * -1));
	}
	else {
		%orig;
	}

}
- (void)_transportControlTapped:(MPUTransportButton *)button {
	%orig;
	if (enabled) {
		if (button.tag == 10) {
			if ([self isShuffled]) {
				[button setSelected:YES];
			}
			else {
				[button setSelected:NO];
			}
		}
		else if (button.tag == 9) {
			if ([self isRepeating]) {
				[button setSelected:YES];
			}
			else {
				[button setSelected:NO];
			}
		}
	}
}
%end

%hook MPUSystemMediaControlsViewController
- (UIImage *)_imageForTransportButtonWithControlType:(NSInteger)type {
	if (enabled) {
		if (type == 10 || type == 9) {
			MusicNowPlayingViewController *imageHelper = [[%c(MusicNowPlayingViewController) alloc] init];
			MPUTransportControlMediaRemoteController *dataHelper = MSHookIvar<id>(self,"_transportControlMediaRemoteController");
			if (type == 10) {
				if (dataHelper) {
					return [imageHelper _imageForTransportButtonWithControlType:10 usingTransportControlMediaRemoteController:dataHelper];
				}
				else {
					return nil;
				}
			}
			else {
				if (dataHelper) {
					return [imageHelper _imageForTransportButtonWithControlType:9 usingTransportControlMediaRemoteController:dataHelper];
				}
				else {
					return nil;
				}
			}
		}
		else {
			return %orig;
		}
	}
	else {
		return %orig;
	}
 }
%end

%hook SpringBoard
%new
- (id)remoteController {
	return nil;
}
%end

%hook MPUTransportButton

/*- (id)initWithFrame:(CGRect)arg1 {
	%orig;
	if (enabled) {
		if (customInsets) {
			if (self.tag == 10) {
				self.frame = CGRectMake(insetValue, arg1.origin.y, arg1.size.width, arg1.size.height);
			}
			if (self.tag == 9) {
				self.frame = CGRectMake(SCREEN.size.width - arg1.size.width - insetValue, arg1.origin.y, arg1.size.width, arg1.size.height);
			}
		}
	}
	return %orig;
} */

- (void)layoutSubviews {
	%orig;
	if (self.tag == 9 || self.tag == 10) {
		if (highContrast) {
			CALayer *highLayer = MSHookIvar<CALayer *>(self,"_selectionIndicatorLayer");
			if (highLayer) {
				if (white) {
					highLayer.backgroundColor = [[UIColor blackColor] CGColor];
				}
				else {
					highLayer.backgroundColor = [[UIColor whiteColor] CGColor];
				}
			}
		}
	}
	else {
		CALayer *highLayer = MSHookIvar<CALayer *>(self,"_selectionIndicatorLayer");
		if (highLayer) {
			[highLayer setHidden:YES];
		}
	}
}

/*+ (id)defaultSelectedColor {
	if (self.tag == 9 || self.tag == 10) {
		return [UIColor blackColor];
	}
	else {
		return %orig;
	}
} */

- (BOOL)shouldShowBackgroundForSelectedState {
	if (enabled) {
		if (self.tag == 9 || self.tag == 10) {
			return YES;
		}
		else {
			return NO;
		}
	}
	else {
		return NO;
	}
}

- (void)setSelected:(BOOL)arg1 {
	if (enabled) {
		if (self.tag == 10) {
			[[self superview] isShuffled];
			[self setSelectedColor:[UIColor blackColor]];
			if (isShuffled) {
				%orig(YES);
			}
			else {
				%orig(NO);
			}
		}
		else if (self.tag == 9) {
			[[self superview] isRepeating];
			[self setSelectedColor:[UIColor blackColor]];
			if (isRepeating) {
				%orig(YES);
			}
			else {
				%orig(NO);
			}
		}
		else {
			%orig;
		}
	}
	else {
		%orig;
	}
}
- (void)setSelectedColor:(id)arg1 {
	if (enabled) {
		if (self.tag == 9 || self.tag == 10) {
			if (white) {
				%orig([UIColor whiteColor]);
			}
			else {
				%orig([UIColor blackColor]);
			}
		}
		else {
			%orig;
		}
	}
	else {
		%orig;
	}
}
- (id)selectedColor {
	if (enabled) {
		if (self.tag == 9 || self.tag == 10) {
			if (white) {
				return [UIColor whiteColor];
			}
			else {
				return [UIColor blackColor];
			}
		}
		else {
			return %orig;
		}
	}
	else {
		return %orig;
	}
}
%end

%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.creatix.carrot/saved"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}