@interface _SBFakeBlurView : UIView 

@property (assign,nonatomic) BOOL fullscreen;
-(id)initWithVariant:(long long)arg1 ;
-(void)reconfigureWithSource:(id)arg1 ;
-(void)updateImageWithSource:(id)arg1 ;
-(void)rotateToInterfaceOrientation:(long long)arg1 ;
-(void)_updateImageWithSource:(id)arg1 notifyObserver:(BOOL)arg2 ;
-(void)_setImage:(id)arg1 style:(long long)arg2 notify:(BOOL)arg3 ;
-(long long)effectiveStyle;
-(BOOL)fullscreen;
-(void)didMoveToWindow;
-(void)layoutSubviews;
-(void)willMoveToWindow:(id)arg1 ;
-(void)requestStyle:(long long)arg1 ;
-(void)setFullscreen:(BOOL)arg1 ;
@end