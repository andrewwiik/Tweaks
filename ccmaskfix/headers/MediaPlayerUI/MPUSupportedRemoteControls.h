@interface MPUSupportedRemoteControls : NSObject {

	NSArray* _commandInfoObjects;

}

@property (nonatomic,readonly) NSArray * commandInfoObjects;                    //@synthesize commandInfoObjects=_commandInfoObjects - In the implementation block
@property (nonatomic,readonly) BOOL interactiveScrubbingSupported; 
-(id)init;
-(BOOL)commandIsActivated:(unsigned)arg1 ;
-(BOOL)commandIsSupportedAndEnabled:(unsigned)arg1 ;
-(BOOL)interactiveScrubbingSupported;
-(id)initWithMediaRemoteCommands:(id)arg1 ;
-(BOOL)_commandIsSupported:(unsigned)arg1 andEnabled:(BOOL*)arg2 activated:(BOOL*)arg3 ;
-(NSArray *)commandInfoObjects;
@end
