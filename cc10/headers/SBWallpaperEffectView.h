@interface SBWallpaperEffectView : UIView
@property(nonatomic) BOOL forcesOpaque; // @synthesize forcesOpaque=_forcesOpaque;
@property(nonatomic) int wallpaperStyle;
- (void)setStyle:(int)arg1;
- (instancetype)initWithWallpaperVariant:(int)arg1;
- (void)_setFrame:(CGRect)arg1 forceUpdateBackgroundImage:(BOOL)arg2 ;
@end