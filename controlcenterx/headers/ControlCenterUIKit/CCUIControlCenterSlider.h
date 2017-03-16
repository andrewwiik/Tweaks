@interface CCUIControlCenterSlider : UISlider {

	UIImageView* _minValueHighlightedImageView;
	UIImageView* _maxValueHighlightedImageView;
	BOOL _adjusting;

}

@property (assign,getter=isAdjusting,nonatomic) BOOL adjusting;              //@synthesize adjusting=_adjusting - In the implementation block
+(id)_trackImage;
+(id)_knobImage;
+(UIEdgeInsets)_edgeInsetsForSliderKnob;
+(id)_resizableTrackImage;
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(void)cancelTrackingWithEvent:(id)arg1 ;
-(BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2 ;
-(void)endTrackingWithTouch:(id)arg1 withEvent:(id)arg2 ;
-(CGRect)trackRectForBounds:(CGRect)arg1 ;
-(CGRect)thumbRectForBounds:(CGRect)arg1 trackRect:(CGRect)arg2 value:(float)arg3 ;
-(CGRect)minimumValueImageRectForBounds:(CGRect)arg1 ;
-(CGRect)maximumValueImageRectForBounds:(CGRect)arg1 ;
-(void)setMinimumValueImage:(id)arg1 ;
-(void)setMaximumValueImage:(id)arg1 ;
-(void)_updateEffects;
-(BOOL)ccuiSupportsDelayedTouchesByContainingScrollViewForGesture:(id)arg1 ;
-(void)_setTrackImage:(id)arg1 ;
-(void)setAdjusting:(BOOL)arg1 ;
-(void)setMinimumValueImage:(id)arg1 cacheKey:(id)arg2 ;
-(void)setMaximumValueImage:(id)arg1 cacheKey:(id)arg2 ;
-(double)leftValueImageOriginForBounds:(CGRect)arg1 andSize:(CGSize)arg2 ;
-(double)rightValueImageOriginForBounds:(CGRect)arg1 andSize:(CGSize)arg2 ;
-(void)_configureHighlightedValueImagesLikeRegularValueImages;
-(BOOL)isAdjusting;
-(void)setTracking:(BOOL)arg1;
-(void)_setValue:(float)arg1 andSendAction:(BOOL)arg2;
@end