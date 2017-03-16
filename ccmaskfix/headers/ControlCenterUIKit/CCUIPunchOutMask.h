@interface CCUIPunchOutMask : NSObject {

	NSInteger _style;
	CGFloat _cornerRadius;
	NSUInteger _roundedCorners;
	CGRect _frame;

}

@property (nonatomic,readonly) CGRect frame;                                   //@synthesize frame=_frame - In the implementation block
@property (nonatomic,readonly) NSInteger style;                                //@synthesize style=_style - In the implementation block
@property (nonatomic,readonly) CGFloat cornerRadius;                            //@synthesize cornerRadius=_cornerRadius - In the implementation block
@property (nonatomic,readonly) NSUInteger roundedCorners;              //@synthesize roundedCorners=_roundedCorners - In the implementation block
-(CGFloat)cornerRadius;
-(CGRect)frame;
-(BOOL)isEqual:(id)arg1 ;
-(NSUInteger)hash;
-(id)description;
-(NSInteger)style;
-(NSUInteger)roundedCorners;
-(id)textualRepresentation;
-(id)initWithFrame:(CGRect)arg1 style:(NSInteger)arg2 radius:(CGFloat)arg3 roundedCorners:(NSUInteger)arg4 ;
@end
