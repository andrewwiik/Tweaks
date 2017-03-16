@interface CABackdropLayer : CALayer

@property (getter=isEnabled) BOOL enabled; 
@property (copy) NSString * groupName; 
@property (assign) CGFloat scale; 
@property (assign) CGRect backdropRect; 
@property (assign) CGFloat marginWidth; 
@property (assign) BOOL disablesOccludedBackdropBlurs; 
@property (assign) BOOL captureOnly; 
@property (copy) NSString * statisticsType; 
@property (assign) CGFloat statisticsInterval; 
+(id)defaultValueForKey:(id)arg1 ;
+(BOOL)CA_automaticallyNotifiesObservers:(Class)arg1 ;
+(BOOL)_hasRenderLayerSubclass;
-(BOOL)_renderLayerDefinesProperty:(unsigned)arg1 ;
-(unsigned)_renderLayerPropertyAnimationFlags:(unsigned)arg1 ;
-(CGRect)backdropRect;
-(BOOL)captureOnly;
-(void)setBackdropRect:(CGRect)arg1 ;
-(void)setScale:(CGFloat)arg1 ;
-(void)setEnabled:(BOOL)arg1 ;
-(BOOL)isEnabled;
-(CGFloat)scale;
-(NSString *)groupName;
-(void)setGroupName:(NSString *)arg1 ;
-(void)didChangeValueForKey:(id)arg1 ;
-(void)setDisablesOccludedBackdropBlurs:(BOOL)arg1 ;
-(void)setCaptureOnly:(BOOL)arg1 ;
-(void)setStatisticsInterval:(CGFloat)arg1 ;
-(CGFloat)statisticsInterval;
-(void)setStatisticsType:(NSString *)arg1 ;
-(id)statisticsValues;
-(BOOL)disablesOccludedBackdropBlurs;
-(NSString *)statisticsType;
-(void)layerDidBecomeVisible:(BOOL)arg1 ;
-(CGFloat)marginWidth;
-(void)setMarginWidth:(CGFloat)arg1 ;
@end