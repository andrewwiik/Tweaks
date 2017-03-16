#import "WFTaskIdentifier.h"

@interface WFTask : NSObject {

	BOOL _requiresResponse;
	WFTaskIdentifier* _identifier;
	NSProgress* _progress;

}

@property (nonatomic,readonly) WFTaskIdentifier * identifier;              //@synthesize identifier=_identifier - In the implementation block
@property (nonatomic,readonly) BOOL requiresResponse;                      //@synthesize requiresResponse=_requiresResponse - In the implementation block
@property (nonatomic,retain) NSProgress * progress;                        //@synthesize progress=_progress - In the implementation block
@property (nonatomic,readonly) BOOL isCancelled; 
+(id)sharedServiceConnection;
-(id)init;
-(void)cancel;
-(WFTaskIdentifier *)identifier;
-(void)setProgress:(NSProgress *)arg1 ;
-(void)start;
-(BOOL)isCancelled;
-(NSProgress *)progress;
-(void)cleanup;
-(BOOL)requiresResponse;
-(void)handleResponse:(id)arg1 ;
-(void)executeSynchronously;
-(id)initWithResponseRequired:(BOOL)arg1 ;
-(void)startWithService:(id)arg1 ;
-(void)handleCancellation;
@end
