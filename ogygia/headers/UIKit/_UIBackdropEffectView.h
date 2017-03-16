#import <QuartzCore/CABackdropLayer.h>

@interface _UIBackdropEffectView : UIView {

	CABackdropLayer* _backdropLayer;
	CGFloat _zoom;

}

@property (nonatomic,retain) CABackdropLayer * backdropLayer;              //@synthesize backdropLayer=_backdropLayer - In the implementation block
+(Class)layerClass;
-(id)init;
-(void)dealloc;
-(BOOL)_shouldAnimatePropertyWithKey:(id)arg1 ;
-(void)willMoveToWindow:(id)arg1 ;
-(id)valueForUndefinedKey:(id)arg1 ;
-(CGFloat)zoom;
-(void)setZoom:(CGFloat)arg1 ;
-(CABackdropLayer *)backdropLayer;
-(void)backdropLayerStatisticsDidChange:(id)arg1 ;
-(void)setBackdropLayer:(CABackdropLayer *)arg1 ;
@end