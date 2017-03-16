@interface SBUIIconForceTouchController : NSObject
+ (void)_addIconForceTouchController:(id)arg1;
- (id)init;
- (void)setDataSource:(id)arg1;
- (void)setDelegate:(id)arg1;
- (void)startHandlingGestureRecognizer:(id)arg1;
+ (void)_dismissAnimated:(BOOL)arg1 withCompletionHandler:(/*^block*/id)arg2 ;
+ (BOOL)_isPeekingOrShowing;
@property (nonatomic,readonly) NSInteger state;
- (void)_setupWithGestureRecognizer:(id)arg1 ;
- (void)_peekAnimated:(BOOL)arg1 withRelativeTouchForce:(CGFloat)arg2 allowSmoothing:(BOOL)arg3 ;
- (void)_presentAnimated:(BOOL)arg1 withCompletionHandler:(/*^block*/id)arg2 ;
-(void)_dismissAnimated:(BOOL)arg1 withCompletionHandler:(/*^block*/id)arg2 ;
@end