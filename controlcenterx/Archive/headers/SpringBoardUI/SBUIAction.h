@interface SBUIAction : NSObject {

	NSString* _title;
	NSString* _subtitle;
	UIImage* _image;
	UIView* _badgeView;
	/*^block*/id _handler;

}

@property (nonatomic,copy,readonly) NSString * title;                 //@synthesize title=_title - In the implementation block
@property (nonatomic,copy,readonly) NSString * subtitle;              //@synthesize subtitle=_subtitle - In the implementation block
@property (nonatomic,readonly) UIImage * image;                       //@synthesize image=_image - In the implementation block
@property (nonatomic,readonly) UIView * badgeView;                    //@synthesize badgeView=_badgeView - In the implementation block
@property (nonatomic,copy,readonly) id handler;                       //@synthesize handler=_handler - In the implementation block
-(id)init;
-(NSString *)title;
-(UIImage *)image;
-(UIView *)badgeView;
-(NSString *)subtitle;
-(id)handler;
-(id)initWithTitle:(id)arg1 subtitle:(id)arg2 image:(id)arg3 badgeView:(id)arg4 handler:(/*^block*/id)arg5 ;
-(id)initWithTitle:(id)arg1 subtitle:(id)arg2 image:(id)arg3 handler:(/*^block*/id)arg4 ;
-(id)initWithTitle:(id)arg1 subtitle:(id)arg2 handler:(/*^block*/id)arg3 ;
-(id)initWithTitle:(id)arg1 handler:(/*^block*/id)arg2 ;
@end