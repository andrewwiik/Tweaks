@interface BBContent : NSObject 

@property (nonatomic,copy) NSString *title;                 //@synthesize title=_title - In the implementation block
@property (nonatomic,copy) NSString *subtitle;              //@synthesize subtitle=_subtitle - In the implementation block
@property (nonatomic,copy) NSString *message;               //@synthesize message=_message - In the implementation block
+(id)contentWithTitle:(id)arg1 subtitle:(id)arg2 message:(id)arg3;
-(void)setTitle:(NSString *)arg1;
-(NSString *)title;
-(NSString *)subtitle;
-(NSString *)message;
-(void)setSubtitle:(NSString *)arg1;
-(void)setMessage:(NSString *)arg1;
-(BOOL)isEqualToContent:(id)arg1;
@end