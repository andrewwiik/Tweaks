#import <MediaPlayerUI/MPUTransportControlMediaRemoteControllerDelegate-Protocol.h>
#import <MediaPlayerUI/MPUTransportControlsView.h>

@interface MPUTransportControlMediaRemoteController : NSObject {

	unsigned _runningLongPressCommand;
	BOOL _playing;
	BOOL _nowPlayingAppIsRunning;
	BOOL _advertisement;
	BOOL _alwaysLive;
	BOOL _sharingEnabled;
	id<MPUTransportControlMediaRemoteControllerDelegate> _delegate;
	NSDictionary* _nowPlayingInfo;
	NSArray* _supportedCommands;
	CGFloat _displayedSkipBackwardInterval;
	CGFloat _displayedSkipForwardInterval;
	NSInteger _likeControlPresentationStyle;
	NSInteger _likedState;
	NSInteger _repeatType;
	NSInteger _shuffleType;
	NSArray* _allowedTransportControlTypes;
	NSUInteger _transportControlsCount;
	MPUTransportControlsView* _transportControlsView;

}

@property (assign,nonatomic) id<MPUTransportControlMediaRemoteControllerDelegate> delegate;              //@synthesize delegate=_delegate - In the implementation block
@property (nonatomic,copy) NSDictionary * nowPlayingInfo;                                                       //@synthesize nowPlayingInfo=_nowPlayingInfo - In the implementation block
@property (assign,getter=isPlaying,nonatomic) BOOL playing;                                                     //@synthesize playing=_playing - In the implementation block
@property (assign,nonatomic) BOOL nowPlayingAppIsRunning;                                                       //@synthesize nowPlayingAppIsRunning=_nowPlayingAppIsRunning - In the implementation block
@property (nonatomic,copy) NSArray * supportedCommands;                                                         //@synthesize supportedCommands=_supportedCommands - In the implementation block
@property (getter=isAdvertisement,nonatomic,readonly) BOOL advertisement;                                       //@synthesize advertisement=_advertisement - In the implementation block
@property (getter=isAlwaysLive,nonatomic,readonly) BOOL alwaysLive;                                             //@synthesize alwaysLive=_alwaysLive - In the implementation block
@property (nonatomic,readonly) CGFloat displayedSkipBackwardInterval;                                            //@synthesize displayedSkipBackwardInterval=_displayedSkipBackwardInterval - In the implementation block
@property (nonatomic,readonly) CGFloat displayedSkipForwardInterval;                                             //@synthesize displayedSkipForwardInterval=_displayedSkipForwardInterval - In the implementation block
@property (nonatomic,readonly) NSInteger likeControlPresentationStyle;                                          //@synthesize likeControlPresentationStyle=_likeControlPresentationStyle - In the implementation block
@property (nonatomic,readonly) NSInteger likedState;                                                            //@synthesize likedState=_likedState - In the implementation block
@property (nonatomic,readonly) NSInteger repeatType;                                                            //@synthesize repeatType=_repeatType - In the implementation block
@property (nonatomic,readonly) NSInteger shuffleType;                                                           //@synthesize shuffleType=_shuffleType - In the implementation block
@property (getter=isSharingEnabled,nonatomic,readonly) BOOL sharingEnabled;                                     //@synthesize sharingEnabled=_sharingEnabled - In the implementation block
@property (nonatomic,readonly) BOOL supportsStopButNotPause; 
@property (nonatomic,copy) NSArray * allowedTransportControlTypes;                                              //@synthesize allowedTransportControlTypes=_allowedTransportControlTypes - In the implementation block
@property (assign,nonatomic) NSUInteger transportControlsCount;                                         //@synthesize transportControlsCount=_transportControlsCount - In the implementation block
@property (nonatomic,readonly) MPUTransportControlsView * transportControlsView;                                //@synthesize transportControlsView=_transportControlsView - In the implementation block
-(id)init;
-(void)setDelegate:(id<MPUTransportControlMediaRemoteControllerDelegate>)arg1 ;
-(id<MPUTransportControlMediaRemoteControllerDelegate>)delegate;
-(BOOL)isPlaying;
-(NSArray *)supportedCommands;
-(void)setSupportedCommands:(NSArray *)arg1 ;
-(NSInteger)likedState;
-(NSInteger)repeatType;
-(NSInteger)shuffleType;
-(void)setNowPlayingInfo:(NSDictionary *)arg1 ;
-(NSDictionary *)nowPlayingInfo;
-(BOOL)isAlwaysLive;
-(void)setPlaying:(BOOL)arg1 ;
-(id)initWithTransportControlsView:(id)arg1 transportControlsCount:(NSUInteger)arg2 ;
-(void)cancelRunningLongPressCommand;
-(void)setNowPlayingAppIsRunning:(BOOL)arg1 ;
-(NSInteger)handleTapOnControlType:(NSInteger)arg1 ;
-(NSInteger)handleLongPressBeginOnControlType:(NSInteger)arg1 ;
-(NSInteger)handleLongPressEndOnControlType:(NSInteger)arg1 ;
-(NSArray *)allowedTransportControlTypes;
-(void)setAllowedTransportControlTypes:(NSArray *)arg1 ;
-(BOOL)supportsStopButNotPause;
-(CGFloat)displayedSkipBackwardInterval;
-(CGFloat)displayedSkipForwardInterval;
-(MPUTransportControlsView *)transportControlsView;
-(NSInteger)likeControlPresentationStyle;
-(void)handlePushingMediaRemoteCommand:(unsigned)arg1 ;
-(NSUInteger)transportControlsCount;
-(void)setTransportControlsCount:(NSUInteger)arg1 ;
-(void)_completeInitializationWithTransportControlsView:(id)arg1 ;
-(void)_updateForSupportedCommandsChange;
-(void)_updateForNowPlayingInfoChange;
-(void)_presentFirstLoveAlertIfNeeded;
-(void)_presentLikeBanActionSheetForCommand:(unsigned)arg1 ;
-(id)_commandOptionsForFeedbackOrPurchase;
-(id)_nowPlayingInfoValueForMediaRemoteNowPlayingInfoKey:(CFStringRef)arg1 ;
-(void)_updateLikedState;
-(BOOL)_isSupportedCommandActiveForMediaRemoteCommand:(unsigned)arg1 ;
-(id)initWithTransportControlsView:(id)arg1 allowedTransportControlTypes:(id)arg2 ;
-(BOOL)nowPlayingAppIsRunning;
-(BOOL)isAdvertisement;
-(BOOL)isSharingEnabled;
@end
