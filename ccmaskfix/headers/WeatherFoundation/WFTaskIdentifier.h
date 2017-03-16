@interface WFTaskIdentifier : NSObject <NSCopying, NSSecureCoding> {

	int _pid;
	NSUUID* _UUID;
	NSString* _processName;

}

@property (nonatomic,readonly) NSUUID * UUID;                       //@synthesize UUID=_UUID - In the implementation block
@property (nonatomic,readonly) NSString * processName;              //@synthesize processName=_processName - In the implementation block
@property (nonatomic,readonly) int pid;                             //@synthesize pid=_pid - In the implementation block
+(BOOL)supportsSecureCoding;
+(id)defaultIdentifier;
-(id)init;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(BOOL)isEqual:(id)arg1 ;
-(id)copyWithZone:(NSZone*)arg1 ;
-(NSUUID *)UUID;
-(NSString *)processName;
-(int)pid;
@end