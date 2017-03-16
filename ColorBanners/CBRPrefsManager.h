
@interface CBRPrefsManager : NSObject {

}

@property(nonatomic, assign, getter=areBannersEnabled) BOOL bannersEnabled;
@property(nonatomic, assign, getter=isLSEnabled) BOOL lsEnabled;
@property(nonatomic, assign, getter=isNCEnabled) BOOL ncEnabled;

@property(nonatomic, assign, getter=shouldUseBannerGradient) BOOL useBannerGradient;
@property(nonatomic, assign, getter=shouldUseLSGradient) BOOL useLSGradient;
@property(nonatomic, assign, getter=shouldUseNCGradient) BOOL useNCGradient;

@property(nonatomic, assign, getter=shouldBannersUseConstantColor) BOOL bannersUseConstantColor;
@property(nonatomic, assign, getter=shouldLSUseConstantColor) BOOL lsUseConstantColor;
@property(nonatomic, assign, getter=shouldNCUseConstantColor) BOOL ncUseConstantColor;

@property(nonatomic, assign) int bannerBackgroundColor;
@property(nonatomic, assign) int lsBackgroundColor;
@property(nonatomic, assign) int ncBackgroundColor;

@property(nonatomic, assign) CGFloat bannerAlpha;
@property(nonatomic, assign) CGFloat lsAlpha;
@property(nonatomic, assign) CGFloat ncAlpha;

@property(nonatomic, assign, getter=shouldRemoveLSBlur) BOOL removeLSBlur;
@property(nonatomic, assign, getter=shouldShowSeparators) BOOL showSeparators;
@property(nonatomic, assign, getter=shouldDisableDimming) BOOL disableDimming;
@property(nonatomic, assign, getter=shouldColorDismissButton) BOOL colorDismissButton;

@property(nonatomic, assign) BOOL prefersWhiteText;

@property(nonatomic, assign) BOOL wantsDeepBannerAnalyzing;
@property(nonatomic, assign) BOOL wantsLiveAnalysis;

@property(nonatomic, assign, getter=shouldRoundCorners) BOOL roundCorners;
@property(nonatomic, assign, getter=shouldRemoveBannersBlur) BOOL removeBannersBlur;
@property(nonatomic, assign, getter=shouldHideQRRect) BOOL hideQRRect;
@property(nonatomic, assign, getter=shouldHideGrabber) BOOL hideGrabber;

+ (instancetype)sharedInstance;

- (void)reload;

@end
