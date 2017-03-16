@interface _UIBackdropViewSettings : NSObject
                              //@synthesize backdrop=_backdrop - In the implementation block
@property (nonatomic,readonly) NSInteger style;                                          //@synthesize style=_style - In the implementation block
@property (assign,nonatomic) NSInteger graphicsQuality;                                  //@synthesize graphicsQuality=_graphicsQuality - In the implementation block
@property (assign,nonatomic) BOOL explicitlySetGraphicsQuality;                          //@synthesize explicitlySetGraphicsQuality=_explicitlySetGraphicsQuality - In the implementation block
@property (assign,nonatomic) BOOL requiresColorStatistics;                               //@synthesize requiresColorStatistics=_requiresColorStatistics - In the implementation block                 //@synthesize colorSettings=_colorSettings - In the implementation block
@property (assign,nonatomic) NSInteger renderingHint;                                    //@synthesize renderingHint=_renderingHint - In the implementation block
@property (assign,nonatomic) NSInteger stackingLevel;                                    //@synthesize stackingLevel=_stackingLevel - In the implementation block
@property (assign,getter=isHighlighted,nonatomic) BOOL highlighted;                      //@synthesize highlighted=_highlighted - In the implementation block
@property (assign,getter=isSelected,nonatomic) BOOL selected;                            //@synthesize selected=_selected - In the implementation block
@property (assign,getter=isEnabled,nonatomic) BOOL enabled;                              //@synthesize enabled=_enabled - In the implementation block
@property (assign,getter=isBackdropVisible,nonatomic) BOOL backdropVisible;              //@synthesize backdropVisible=_backdropVisible - In the implementation block
@property (assign,nonatomic) BOOL zoomsBack;                                             //@synthesize zoomsBack=_zoomsBack - In the implementation block
@property (assign,nonatomic) CGFloat grayscaleTintLevel;                                  //@synthesize grayscaleTintLevel=_grayscaleTintLevel - In the implementation block
@property (assign,nonatomic) CGFloat grayscaleTintAlpha;                                  //@synthesize grayscaleTintAlpha=_grayscaleTintAlpha - In the implementation block
@property (assign,nonatomic) CGFloat grayscaleTintMaskAlpha;                              //@synthesize grayscaleTintMaskAlpha=_grayscaleTintMaskAlpha - In the implementation block
@property (nonatomic,retain) UIImage * grayscaleTintMaskImage;                           //@synthesize grayscaleTintMaskImage=_grayscaleTintMaskImage - In the implementation block
@property (assign,nonatomic) BOOL lightenGrayscaleWithSourceOver;                        //@synthesize lightenGrayscaleWithSourceOver=_lightenGrayscaleWithSourceOver - In the implementation block
@property (nonatomic,retain) UIColor * colorTint;                                        //@synthesize colorTint=_colorTint - In the implementation block
@property (assign,nonatomic) CGFloat colorTintAlpha;                                      //@synthesize colorTintAlpha=_colorTintAlpha - In the implementation block
@property (assign,nonatomic) CGFloat colorTintMaskAlpha;                                  //@synthesize colorTintMaskAlpha=_colorTintMaskAlpha - In the implementation block
@property (nonatomic,retain) UIImage * colorTintMaskImage;                               //@synthesize colorTintMaskImage=_colorTintMaskImage - In the implementation block
@property (assign,nonatomic) CGFloat colorBurnTintLevel;                                  //@synthesize colorBurnTintLevel=_colorBurnTintLevel - In the implementation block
@property (assign,nonatomic) CGFloat colorBurnTintAlpha;                                  //@synthesize colorBurnTintAlpha=_colorBurnTintAlpha - In the implementation block
@property (nonatomic,retain) UIImage * colorBurnTintMaskImage;                           //@synthesize colorBurnTintMaskImage=_colorBurnTintMaskImage - In the implementation block
@property (assign,nonatomic) CGFloat darkeningTintAlpha;                                  //@synthesize darkeningTintAlpha=_darkeningTintAlpha - In the implementation block
@property (assign,nonatomic) CGFloat darkeningTintHue;                                    //@synthesize darkeningTintHue=_darkeningTintHue - In the implementation block
@property (assign,nonatomic) CGFloat darkeningTintSaturation;                             //@synthesize darkeningTintSaturation=_darkeningTintSaturation - In the implementation block
@property (assign,nonatomic) CGFloat darkeningTintBrightness;                             //@synthesize darkeningTintBrightness=_darkeningTintBrightness - In the implementation block
@property (nonatomic,retain) UIImage * darkeningTintMaskImage;                           //@synthesize darkeningTintMaskImage=_darkeningTintMaskImage - In the implementation block
@property (assign,nonatomic) BOOL darkenWithSourceOver;                                  //@synthesize darkenWithSourceOver=_darkenWithSourceOver - In the implementation block
@property (assign,nonatomic) CGFloat blurRadius;                                          //@synthesize blurRadius=_blurRadius - In the implementation block
@property (nonatomic,copy) NSString * blurQuality;                                       //@synthesize blurQuality=_blurQuality - In the implementation block
@property (assign,nonatomic) NSInteger blurHardEdges;                                    //@synthesize blurHardEdges=_blurHardEdges - In the implementation block
@property (assign,nonatomic) BOOL blursWithHardEdges; 
@property (assign,nonatomic) CGFloat saturationDeltaFactor;                               //@synthesize saturationDeltaFactor=_saturationDeltaFactor - In the implementation block
@property (assign,nonatomic) CGFloat filterMaskAlpha;                                     //@synthesize filterMaskAlpha=_filterMaskAlpha - In the implementation block
@property (nonatomic,retain) UIImage * filterMaskImage;                                  //@synthesize filterMaskImage=_filterMaskImage - In the implementation block
@property (assign,nonatomic) CGFloat extendedRangeClamp;                                  //@synthesize extendedRangeClamp=_extendedRangeClamp - In the implementation block
@property (nonatomic,retain) UIColor * legibleColor;                                     //@synthesize legibleColor=_legibleColor - In the implementation block
@property (nonatomic,readonly) UIColor * combinedTintColor; 
@property (assign,nonatomic) CGFloat scale;                                               //@synthesize scale=_scale - In the implementation block
@property (assign,nonatomic) CGFloat statisticsInterval;                                  //@synthesize statisticsInterval=_statisticsInterval - In the implementation block
@property (assign,nonatomic) NSUInteger version;                                 //@synthesize version=_version - In the implementation block
@property (assign,setter=setDesignMode:,nonatomic) BOOL designMode;                      //@synthesize designMode=_designMode - In the implementation block
@property (assign,nonatomic) BOOL usesBackdropEffectView;                                //@synthesize usesBackdropEffectView=_usesBackdropEffectView - In the implementation block
@property (assign,nonatomic) BOOL usesGrayscaleTintView;                                 //@synthesize usesGrayscaleTintView=_usesGrayscaleTintView - In the implementation block
@property (assign,nonatomic) BOOL usesColorTintView;                                     //@synthesize usesColorTintView=_usesColorTintView - In the implementation block
@property (assign,nonatomic) BOOL usesColorBurnTintView;                                 //@synthesize usesColorBurnTintView=_usesColorBurnTintView - In the implementation block
@property (assign,nonatomic) BOOL usesContentView;                                       //@synthesize usesContentView=_usesContentView - In the implementation block
@property (assign,nonatomic) BOOL usesDarkeningTintView;                                 //@synthesize usesDarkeningTintView=_usesDarkeningTintView - In the implementation block
@property (assign,nonatomic) BOOL usesColorOffset;                                       //@synthesize usesColorOffset=_usesColorOffset - In the implementation block
@property (assign,nonatomic) CGFloat colorOffsetAlpha;                                    //@synthesize colorOffsetAlpha=_colorOffsetAlpha - In the implementation block
@property (nonatomic,retain) NSValue * colorOffsetMatrix;                                //@synthesize colorOffsetMatrix=_colorOffsetMatrix - In the implementation block
@property (assign,nonatomic) BOOL appliesTintAndBlurSettings;                            //@synthesize appliesTintAndBlurSettings=_appliesTintAndBlurSettings - In the implementation block
@property (assign,nonatomic) CGFloat zoom;                                                //@synthesize zoom=_zoom - In the implementation block
@property (assign,nonatomic) NSInteger suppressSettingsDidChange;                        //@synthesize suppressSettingsDidChange=_suppressSettingsDidChange - In the implementation block
+(id)settingsForStyle:(NSInteger)arg1;
+(id)settingsForPrivateStyle:(NSInteger)arg1 graphicsQuality:(NSInteger)arg2;
+(id)settingsForPrivateStyle:(NSInteger)arg1;
+(id)darkeningTintColor;
+(id)settingsForStyle:(NSInteger)arg1 graphicsQuality:(NSInteger)arg2;
+(id)settingsPreservingHintsFromSettings:(id)arg1 graphicsQuality:(NSInteger)arg2;
-(id)initWithDefaultValues;
-(id)init;
// -(id)description;
-(void)setScale:(CGFloat)arg1;
-(CGFloat)scale;
-(void)setEnabled:(BOOL)arg1;
-(BOOL)isEnabled;
-(NSInteger)style;
-(void)setStyle:(NSInteger)arg1;
-(void)setDefaultValues;
-(NSInteger)graphicsQuality;
-(void)setRequiresColorStatistics:(BOOL)arg1;
-(void)setBackdropVisible:(BOOL)arg1;
-(void)setUsesBackdropEffectView:(BOOL)arg1;
-(void)setUsesColorTintView:(BOOL)arg1;
-(void)setGrayscaleTintLevel:(CGFloat)arg1;
-(void)setGrayscaleTintAlpha:(CGFloat)arg1;
-(void)setGrayscaleTintMaskAlpha:(CGFloat)arg1;
-(void)setGrayscaleTintMaskImage:(UIImage *)arg1;
-(void)setColorTint:(UIColor *)arg1;
-(void)setColorTintAlpha:(CGFloat)arg1;
-(void)setColorTintMaskAlpha:(CGFloat)arg1;
-(void)setColorTintMaskImage:(UIImage *)arg1;
-(void)setBlurRadius:(CGFloat)arg1;
-(void)setSaturationDeltaFactor:(CGFloat)arg1;
-(void)setFilterMaskAlpha:(CGFloat)arg1;
-(void)setFilterMaskImage:(UIImage *)arg1;
-(void)setLegibleColor:(UIColor *)arg1;
-(UIImage *)grayscaleTintMaskImage;
-(UIImage *)colorTintMaskImage;
-(UIImage *)filterMaskImage;
-(CGFloat)blurRadius;
-(CGFloat)saturationDeltaFactor;
-(BOOL)usesBackdropEffectView;
-(void)setValuesFromModel:(id)arg1;
-(BOOL)requiresColorStatistics;
-(void)computeOutputSettingsUsingModel:(id)arg1;
-(BOOL)usesGrayscaleTintView;
-(CGFloat)grayscaleTintAlpha;
-(CGFloat)grayscaleTintLevel;
-(BOOL)usesColorTintView;
-(UIColor *)colorTint;
-(CGFloat)colorTintAlpha;
-(void)setUsesGrayscaleTintView:(BOOL)arg1;
-(void)setHighlighted:(BOOL)arg1;
-(BOOL)isHighlighted;
-(BOOL)isSelected;
-(void)setSelected:(BOOL)arg1;
-(void)setRenderingHint:(NSInteger)arg1;
-(CGFloat)darkeningTintAlpha;
-(void)setDarkeningTintAlpha:(CGFloat)arg1;
-(void)addKeyPathObserver:(id)arg1;
-(void)removeKeyPathObserver:(id)arg1;
-(void)restoreDefaultValues;
-(void)setUsesColorOffset:(BOOL)arg1;
-(void)setColorOffsetAlpha:(CGFloat)arg1;
-(BOOL)lightenGrayscaleWithSourceOver;
-(void)setLightenGrayscaleWithSourceOver:(BOOL)arg1;
-(CGFloat)colorBurnTintLevel;
-(void)setColorBurnTintLevel:(CGFloat)arg1;
-(CGFloat)colorBurnTintAlpha;
-(void)setColorBurnTintAlpha:(CGFloat)arg1;
-(CGFloat)darkeningTintHue;
-(void)setDarkeningTintHue:(CGFloat)arg1;
-(CGFloat)darkeningTintSaturation;
-(void)setDarkeningTintSaturation:(CGFloat)arg1;
-(BOOL)darkenWithSourceOver;
-(void)setDarkenWithSourceOver:(BOOL)arg1;
-(CGFloat)zoom;
-(void)setZoom:(CGFloat)arg1;
-(void)setZoomsBack:(BOOL)arg1;
-(void)setGraphicsQuality:(NSInteger)arg1;
-(void)setUsesDarkeningTintView:(BOOL)arg1;
-(CGFloat)statisticsInterval;
-(void)setStatisticsInterval:(CGFloat)arg1;
-(NSString *)blurQuality;
-(void)setExtendedRangeClamp:(CGFloat)arg1;
-(NSValue *)colorOffsetMatrix;
-(CGFloat)colorOffsetAlpha;
-(NSInteger)blurHardEdges;
-(void)setBlurHardEdges:(NSInteger)arg1;
-(CGFloat)darkeningTintBrightness;
-(BOOL)usesColorBurnTintView;
-(BOOL)usesDarkeningTintView;
-(NSInteger)renderingHint;
-(NSInteger)stackingLevel;
-(void)setStackingLevel:(NSInteger)arg1;
-(void)copyAdditionalSettingsFromSettings:(id)arg1;
-(id)initWithDefaultValuesForGraphicsQuality:(NSInteger)arg1;
-(void)scheduleSettingsDidChangeIfNeeded;
-(void)clearRunLoopObserver;
-(void)setAppliesTintAndBlurSettings:(BOOL)arg1;
-(void)setBlurQuality:(NSString *)arg1;
-(void)setBlursWithHardEdges:(BOOL)arg1;
-(void)setColorBurnTintMaskImage:(UIImage *)arg1;
-(void)setDarkeningTintBrightness:(CGFloat)arg1;
-(void)setDarkeningTintMaskImage:(UIImage *)arg1;
-(void)setStackinglevel:(NSInteger)arg1;
-(void)setUsesColorBurnTintView:(BOOL)arg1;
-(void)setUsesContentView:(BOOL)arg1;
-(void)setVersion:(NSUInteger)arg1;
-(BOOL)requiresBackdropLayer;
-(BOOL)blursWithHardEdges;
-(UIColor *)combinedTintColor;
-(BOOL)explicitlySetGraphicsQuality;
-(void)setExplicitlySetGraphicsQuality:(BOOL)arg1;
-(BOOL)isBackdropVisible;
-(BOOL)zoomsBack;
-(CGFloat)grayscaleTintMaskAlpha;
-(CGFloat)colorTintMaskAlpha;
-(UIImage *)colorBurnTintMaskImage;
-(UIImage *)darkeningTintMaskImage;
-(CGFloat)filterMaskAlpha;
-(CGFloat)extendedRangeClamp;
-(UIColor *)legibleColor;
-(NSUInteger)version;
-(BOOL)designMode;
-(void)setDesignMode:(BOOL)arg1;
-(BOOL)usesContentView;
-(BOOL)usesColorOffset;
-(void)setColorOffsetMatrix:(NSValue *)arg1;
-(BOOL)appliesTintAndBlurSettings;
-(NSInteger)suppressSettingsDidChange;
-(void)setSuppressSettingsDidChange:(NSInteger)arg1;
@end