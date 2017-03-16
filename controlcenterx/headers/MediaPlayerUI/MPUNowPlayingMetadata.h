@interface MPUNowPlayingMetadata : NSObject {

	NSDictionary* _nowPlayingInfo;

}

@property (nonatomic,readonly) NSDictionary * nowPlayingInfo;                              //@synthesize nowPlayingInfo=_nowPlayingInfo - In the implementation block
@property (nonatomic,readonly) NSString * title; 
@property (nonatomic,readonly) NSString * artist; 
@property (nonatomic,readonly) NSString * album; 
@property (nonatomic,readonly) CGFloat elapsedTime; 
@property (nonatomic,readonly) CGFloat duration; 
@property (nonatomic,readonly) CGFloat playbackRate; 
@property (nonatomic,readonly) NSUInteger persistentID; 
@property (nonatomic,readonly) NSString * radioStationIdentifier; 
@property (getter=isMusicApp,nonatomic,readonly) BOOL musicApp; 
@property (getter=isAlwaysLive,nonatomic,readonly) BOOL alwaysLive; 
@property (getter=isExplicitContent,nonatomic,readonly) BOOL explicitContent; 
-(CGFloat)duration;
-(NSString *)title;
-(CGFloat)elapsedTime;
-(CGFloat)playbackRate;
-(NSString *)artist;
-(BOOL)isExplicitContent;
-(NSDictionary *)nowPlayingInfo;
-(BOOL)isAlwaysLive;
-(NSString *)album;
-(NSUInteger)persistentID;
-(id)initWithMediaRemoteNowPlayingInfo:(id)arg1 ;
-(NSString *)radioStationIdentifier;
-(BOOL)isMusicApp;
@end