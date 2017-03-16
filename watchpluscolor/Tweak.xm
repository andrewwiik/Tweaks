extern NSString * const kCAFilterVibrantDark; // XXX: from QuartzCore

@interface WNContainerView : UIView
@end

@interface CBRGradientView : UIView
@end

@interface SBLockScreenBulletinCell : UIView
@end


@interface UIColor (Private)
+(UIColor *)_vibrantLightDividerDarkeningColor;
+(UIColor *)_vibrantLightFillBurnColor;
+(UIColor *)_vibrantLightFillDarkeningColor;
+(UIColor *)_vibrantDarkFillDodgeColor;
+(UIColor *)_vibrantLightSectionDelimiterDividerBurnColor;
+(UIColor *)_vibrantLightSectionDelimiterDividerDarkeningColor;
@end

@interface _UIVisualEffectConfig : NSObject
+(id)configWithContentConfig:(id)arg1 ;
+(id)configWithLayerConfigs:(id)arg1 ;
-(void)addLayerConfig:(id)arg1 ;
-(NSArray *)layerConfigs;
@end

@interface _UIVisualEffectLayerConfig : NSObject
@property (nonatomic,readonly) double opacity;			   //@synthesize opacity=_opacity - In the implementation block
@property (nonatomic,readonly) NSString * filterType;		   //@synthesize filterType=_filterType - In the implementation block
@property (nonatomic,readonly) UIColor * fillColor;		   //@synthesize fillColor=_fillColor - In the implementation block
+(id)layerWithFillColor:(id)arg1 opacity:(double)arg2 filterType:(id)arg3 ;
-(double)opacity;
-(UIColor *)fillColor;
-(NSString *)filterType;
-(void)configureLayerView:(id)arg1 ;
-(void)deconfigureLayerView:(id)arg1 ;
@end

@interface _UIVisualEffectVibrantLayerConfig : _UIVisualEffectLayerConfig 
@property (nonatomic,readonly) UIColor * vibrantColor;				  //@synthesize vibrantColor=_vibrantColor - In the implementation block
@property (nonatomic,readonly) UIColor * tintColor;				  //@synthesize tintColor=_tintColor - In the implementation block
@property (nonatomic,copy,readonly) NSDictionary * filterAttributes;		  //@synthesize filterAttributes=_filterAttributes - In the implementation block
+(id)layerWithVibrantColor:(id)arg1 tintColor:(id)arg2 filterType:(id)arg3 filterAttributes:(id)arg4 ;
+(id)layerWithVibrantColor:(id)arg1 tintColor:(id)arg2 filterType:(id)arg3 ;
-(UIColor *)tintColor;
-(void)configureLayerView:(id)arg1 ;
-(void)deconfigureLayerView:(id)arg1 ;
-(NSDictionary *)filterAttributes;
-(UIColor *)vibrantColor;
@end

@interface _UIDimmingKnockoutBackdropView : UIView {

  UIVisualEffectView* backdropView;
  UIView* dimmingKnockoutView;
  long long _style;

}
@property (assign) double cornerRadius; 
@property (assign,nonatomic) long long style;			    //@synthesize style=_style - In the implementation block
-(void)setAlpha:(double)arg1 ;
-(void)layoutSubviews;
-(long long)style;
-(void)setStyle:(long long)arg1 ;
-(id)initWithStyle:(long long)arg1 ;
-(void)setCornerRadius:(double)arg1 ;
-(double)cornerRadius;
-(void)setHighlighted:(BOOL)arg1 animated:(BOOL)arg2 ;
-(void)setPressed:(BOOL)arg1 animated:(BOOL)arg2 ;
-(id)_visualEffectForStyle:(long long)arg1 ;
-(void)_configureViewsWithStyle:(long long)arg1 ;
-(id)_filterForBackdropStyle:(long long)arg1 ;
-(id)_dimmingKnockoutBackgroundColorForBackdropStyle:(long long)arg1 ;
@end

// @interface SBDashBoardModalVisualEffect : UIVisualEffect
// -(id)effectConfig;
// -(id)copyWithZone:(NSZone*)arg1;
// @end

// @implementation SBDashBoardModalVisualEffect
// - (id)effectConfig {

//   UIColor *vibrantColor = [UIColor _vibrantDarkFillDodgeColor];
//   UIColor *tintColor = [UIColor colorWithWhite:1065353216 alpha:1050253722];
//   _UIVisualEffectVibrantLayerConfig *layerConfig;
//   layerConfig = [NSClassFromString(@"_UIVisualEffectVibrantLayerConfig") layerWithVibrantColor:vibrantColor
// 										     tintColor:tintColor
// 										    filterType:kCAFilterVibrantDark
// 										    filterAttributes:nil];

//   return [NSClassFromString(@"_UIVisualEffectConfig") configWithContentConfig:layerConfig];
// }
// -(id)copyWithZone:(NSZone*)arg1 {
//   return [[self class] new];
// }
// @end

// %hook UIView
// %new
// - (void)addDimmingViewTest3 {
//   _UIDimmingKnockoutBackdropView *knockoutView = [(_UIDimmingKnockoutBackdropView *)[NSClassFromString(@"_UIDimmingKnockoutBackdropView") alloc] initWithStyle:1];
//   knockoutView.frame = CGRectMake(7,0,400,160);
//   knockoutView.layer.cornerRadius = 15.0f;
//   knockoutView.layer.masksToBounds = YES;
//   [self addSubview:knockoutView];
//   ((UIVisualEffectView *)[knockoutView valueForKey:@"backdropView"]).contentView.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:0.55f];
//   UIVisualEffectView *headerView = [[UIVisualEffectView alloc] initWithEffect:[SBDashBoardModalVisualEffect new]];
//   headerView.frame = CGRectMake(0,0,400,40);
//   [((UIVisualEffectView *)[knockoutView valueForKey:@"backdropView"]).contentView addSubview:headerView];
//   UIView *content = [[UIView alloc] initWithFrame:headerView.frame];
//   content.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.35f];
//   [headerView.contentView addSubview:content];

// }
// %end

%group WatchPlusColor
%hook WNContainerView
- (void)layoutContentView {
  %orig;
  if ([self superview]) {
    for (UIView *view in [[self superview] subviews]) {
      if ([view isKindOfClass:NSClassFromString(@"CBRGradientView")]) {
	UIView *container = (UIView *)[self valueForKey:@"notificationContainerView"];
	container.backgroundColor = [view.backgroundColor colorWithAlphaComponent:view.alpha];
	CAGradientLayer *gradientLayer = nil;
	BOOL isNewGradientLayer = NO;
	for (CALayer *layerObject in container.layer.sublayers) {
	  if ([layerObject isKindOfClass:[CAGradientLayer class]]) {
	    gradientLayer = (CAGradientLayer *)layerObject;
	    break;
	  }
	}
	if (!gradientLayer) {
	  gradientLayer = [CAGradientLayer new];
	  isNewGradientLayer = YES;
	}
	gradientLayer.frame = CGRectMake(0,0,container.frame.size.width,container.frame.size.height);
	gradientLayer.colors = ((CAGradientLayer *)view.layer).colors;
	gradientLayer.startPoint = CGPointMake(0.0, 0.5);
	gradientLayer.endPoint = CGPointMake(1.0, 0.5);
	if (isNewGradientLayer)
	  [container.layer insertSublayer:gradientLayer atIndex:0];
	view.hidden = YES;
      }
    }
  }
}
- (void)updateViews {
  %orig;
  if ([self superview]) {
    for (UIView *view in [[self superview] subviews]) {
      if ([view isKindOfClass:NSClassFromString(@"CBRGradientView")]) {
	UIView *container = (UIView *)[self valueForKey:@"notificationContainerView"];
	container.backgroundColor = [view.backgroundColor colorWithAlphaComponent:view.alpha];
	CAGradientLayer *gradientLayer = nil;
	BOOL isNewGradientLayer = NO;
	for (CALayer *layerObject in container.layer.sublayers) {
	  if ([layerObject isKindOfClass:[CAGradientLayer class]]) {
	    gradientLayer = (CAGradientLayer *)layerObject;
	    break;
	  }
	}
	if (!gradientLayer) {
	  gradientLayer = [CAGradientLayer new];
	  isNewGradientLayer = YES;
	}
	gradientLayer.frame = CGRectMake(0,0,container.frame.size.width,container.frame.size.height);
	gradientLayer.colors = ((CAGradientLayer *)view.layer).colors;
	gradientLayer.startPoint = CGPointMake(0.0, 0.5);
	gradientLayer.endPoint = CGPointMake(1.0, 0.5);
	// gradientLayer.mask = container.layer.mask;

	if (isNewGradientLayer)
	  [container.layer insertSublayer:gradientLayer atIndex:0];
	view.hidden = YES;
      }
    }
  }
}
%end
%end

%group WatchNotifictions
%hook SBLockScreenNotificationListController
- (void)_sortItemList:(NSMutableArray *)items {
  NSSortDescriptor* sortDate = [NSSortDescriptor sortDescriptorWithKey: @"sortDate" 
							    ascending: NO];
  NSSortDescriptor* isCritical = [NSSortDescriptor sortDescriptorWithKey: @"isCritical" 
							    ascending: NO];
  [items sortUsingDescriptors:[NSArray arrayWithObjects:isCritical,sortDate,nil]];
  NSLog(@"%@", items);
  return;
}
%end
%end




%ctor {
  dlopen("/Library/MobileSubstrate/DynamicLibraries/WatchNotifictions.dylib", RTLD_NOW);
  dlopen("/Library/MobileSubstrate/DynamicLibraries/ColorBanners.dylib", RTLD_NOW);
	%init;
  if (NSClassFromString(@"WNContainerView")) {
    %init(WatchNotifictions);
    if (NSClassFromString(@"CBRGradientView")) {
      %init(WatchPlusColor);
    }
  }
}