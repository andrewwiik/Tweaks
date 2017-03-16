#import "UIImage+StackBlur.h"

@class _UIBackdropView;
@class _UIBackdropViewSettings;
@class _UIBackdropViewSettingsCombiner;
@class SBLeafIcon, SBIcon, SBIconView, SBIconImageView, SBWDXPlaceholderIcon, SBWDXPlaceholderIconView, SBWDXPlaceholderIconImageView;
@class SBFolderView, MPUNowPlayingController;
typedef struct SBIconCoordinate {
	long long row;
	long long col;
} SBIconCoordinate;


@interface _UIBackdropView : UIView
@property (nonatomic, retain) UIView *contentView;
@property(retain) _UIBackdropViewSettings *outputSettings;
- (id)initWithStyle:(int)arg1;
- (id)initWithSettings:(_UIBackdropViewSettings *)arg1;
- (void)transitionIncrementallyToPrivateStyle:(int)arg1 weighting:(CGFloat)arg2;
- (void)transitionIncrementallyToStyle:(int)arg1 weighting:(CGFloat)arg2;
- (void)transitionIncrementallyToSettings:(_UIBackdropViewSettings *)arg1 weighting:(CGFloat)arg2;
- (void)setAppliesOutputSettingsAnimationDuration:(CGFloat)duation;
- (void)transitionToSettings:(id)arg1;

@end

@interface _UIBackdropViewSettings : NSObject
@property (nonatomic) BOOL appliesTintAndBlurSettings;
@property (nonatomic) int blurHardEdges;
@property (nonatomic, copy) NSString *blurQuality;
@property (nonatomic) CGFloat blurRadius;
@property (nonatomic) BOOL blursWithHardEdges;
@property (nonatomic) float colorBurnTintAlpha;
@property (nonatomic) float colorBurnTintLevel;
@property (nonatomic, retain) UIImage *colorBurnTintMaskImage;
@property (nonatomic) float colorOffsetAlpha;
@property (nonatomic, retain) NSValue *colorOffsetMatrix;
@property (nonatomic, retain) UIColor *colorTint;
@property (nonatomic) CGFloat colorTintAlpha;
@property (nonatomic) float colorTintMaskAlpha;
@property (nonatomic, retain) UIImage *colorTintMaskImage;
@property (nonatomic, readonly) UIColor *combinedTintColor;
@property (nonatomic) BOOL darkenWithSourceOver;
@property (nonatomic) float darkeningTintAlpha;
@property (nonatomic) float darkeningTintBrightness;
@property (nonatomic) float darkeningTintHue;
@property (nonatomic, retain) UIImage *darkeningTintMaskImage;
@property (nonatomic) float darkeningTintSaturation;
@property (nonatomic) BOOL explicitlySetGraphicsQuality;
@property (nonatomic) float extendedRangeClamp;
@property (nonatomic) float filterMaskAlpha;
@property (nonatomic, retain) UIImage *filterMaskImage;
@property (nonatomic) int graphicsQuality;
@property (nonatomic) CGFloat grayscaleTintAlpha;
@property (nonatomic) float grayscaleTintLevel;
@property (nonatomic) float grayscaleTintMaskAlpha;
@property (nonatomic, retain) UIImage *grayscaleTintMaskImage;
@property (nonatomic, retain) UIColor *legibleColor;
@property (nonatomic) BOOL lightenGrayscaleWithSourceOver;
@property (nonatomic) int renderingHint;
@property (nonatomic) BOOL requiresColorStatistics;
@property (nonatomic) float saturationDeltaFactor;
@property (nonatomic) float scale;
@property (nonatomic) int stackingLevel;
@property (nonatomic) double statisticsInterval;
@property (nonatomic, readonly) int style;
@property (nonatomic) int suppressSettingsDidChange;
@property (nonatomic) BOOL usesBackdropEffectView;
@property (nonatomic) BOOL usesColorBurnTintView;
@property (nonatomic) BOOL usesColorOffset;
@property (nonatomic) BOOL usesColorTintView;
@property (nonatomic) BOOL usesContentView;
@property (nonatomic) BOOL usesDarkeningTintView;
@property (nonatomic) BOOL usesGrayscaleTintView;
@property (nonatomic) unsigned int version;
@property (nonatomic) float zoom;
@property (nonatomic) BOOL zoomsBack;
+ (id)settingsForStyle:(int)arg1;
+ (instancetype)settingsForStyle:(int)style weighting:(CGFloat)weight previousSettings:(_UIBackdropViewSettings *)previous;
- (id)initWithDefaultValues;
+ (id)MPU_settingsForNowPlayingBackdrop;
+ (id)MPU_settingsForNowPlayingVibrantContent;
@end

@interface _UIBackdropViewSettingsCombiner : _UIBackdropViewSettings
@property (nonatomic, retain) _UIBackdropViewSettings *inputSettingsA;
@property (nonatomic, retain) _UIBackdropViewSettings *inputSettingsB;
@property CGFloat weighting;
@end




@interface MPUEffectView : UIView



+ (void)coordinateAsyncEffectViewPropertyChanges:(id)arg1 withAnimationBlock:(id)arg2;

- (id)effectCache;
- (id)effectImage;
- (id)effectSettings;
- (id)referenceView;
- (void)setEffectCache:(id)arg1;
- (void)setEffectImage:(id)arg1;
- (void)setEffectSettings:(id)arg1;
- (void)setReferenceView:(id)arg1;
- (void)updateEffect;

@end

@interface MPUBlurEffectView : MPUEffectView


- (id)blurImageView;
- (id)blurView;
- (id)initWithFrame:(CGRect)arg1;
- (void)layoutSubviews;
- (void)setBlurImageView:(id)arg1;
- (void)setBlurView:(id)arg1;
- (void)setReferenceView:(id)arg1;
- (void)updateEffect;

@end


@interface MPUVibrantContentEffectView : MPUEffectView 

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, retain) UIView *vibrantContainer;
@property (nonatomic, retain) UIView *maskedView;

- (id)_layersNotWantingVibrancyForSubviewsOfView:(id)arg1;
- (id)blurImageView;
- (UIView*)contentView;
- (void)disableVibrancyForLayer:(id)arg1;
- (id)hitTest:(CGPoint)arg1 withEvent:(id)arg2;
- (id)initWithFrame:(CGRect)arg1;
- (id)layerPinningViewMap;
- (void)layoutSubviews;
- (id)plusDView;
- (void)reenableVibrancyForLayer:(id)arg1;
- (void)setBlurImageView:(id)arg1;
- (void)setLayerPinningViewMap:(id)arg1;
- (void)setPlusDView:(id)arg1;
- (void)setReferenceView:(id)arg1;
- (void)setTintingView:(id)arg1;
- (void)setVibrancyEnabled:(BOOL)arg1;
- (void)setVibrantContainer:(UIView*)arg1;
- (void)tintColorDidChange;
- (id)tintingView;
- (void)updateEffect;
- (void)updateVibrancyForContentView;
- (BOOL)vibrancyEnabled;
- (UIView*)vibrantContainer;

@end
@class MusicAVPlayer;
@interface MusicAVPlayer : NSObject
+(instancetype)sharedAVPlayer;
-(id)init;
@end


@class MusicMiniPlayerViewController;

@interface MusicMiniPlayerViewController : UIViewController

- (id)initWithPlayer:(MusicAVPlayer *)arg1;

@end

@class MusicRemoteController;

@interface MusicRemoteController : NSObject

-(void)_playbackStateDidChangeNotification:(id)arg1;
-(id)initWithPlayer:(MusicAVPlayer *)arg1;
-(MusicAVPlayer *)player;
-(id)init;
@end

@class MPUMediaControlsTitlesView;
@interface MPUMediaControlsTitlesView : UIView
- (id)initWithMediaControlsStyle:(int)arg1;
- (void)updateTrackInformationWithNowPlayingInfo:(id)arg1;

@end

@interface SBIconListModel : NSObject
- (BOOL)containsLeafIconWithIdentifier:(id)arg1;
- (unsigned long long)indexForLeafIconWithIdentifier:(id)arg1;
- (id)iconAtIndex:(unsigned long long)arg1 ;
- (void)removeIcon:(id)icon;
- (id)placeIcon:(id)arg1 atIndex:(unsigned long long *)arg2;
@end

@interface SBIcon : NSObject
- (id)applicationBundleID;
- (BOOL)isFolderIcon;
- (id)icon;
- (BOOL)isEmptyPlaceholder;
- (BOOL)isPlaceholder;
- (id)referencedIcon;
@end

@interface SBApplicationIcon : SBIcon
- (id)leafIdentifier;
@end

@interface SBFolderIcon : SBIcon
- (id)nodeDescriptionWithPrefix:(id)arg1;
@end

@interface SBFolder : NSObject
@end

@interface SBIconImageView : UIView
@end

@interface SBIconView : UIView
@property (nonatomic, retain) MPUNowPlayingController *playController;
@property (nonatomic) BOOL isBlockForm;
@property (nonatomic, retain) UILabel *songLabel;
@property (nonatomic, retain) UILabel *artistLabel;
@property (nonatomic, retain) UIWebView *webView;
+ (CGSize)defaultIconImageSize;
+ (CGSize)defaultIconSize;
- (SBIcon*)icon;
- (SBIconImageView *)_iconImageView;
- (void)reloadViews;
- (UIImage *)updateArtwork;
- (UIImage *)imageFromView;
@end

@interface SBLeafIcon : SBIcon
- (id)initWithLeafIdentifier:(id)arg1 applicationBundleID:(id)arg2;
- (id)initWithLeafIdentifier:(id)arg1;
- (id)leafIdentifier;

@end

@interface SBIconListView : UIView
@property (nonatomic, retain) NSMutableArray *fullWidgetCoordinates;
@property (nonatomic, retain) NSMutableDictionary *primaryWidgetCoordinates;
@property (nonatomic, retain) NSMutableDictionary *takenIconCoordinates;
+ (unsigned long long)maxIcons;
+ (unsigned long long)iconColumnsForInterfaceOrientation:(long long)arg1;
+ (unsigned long long)iconRowsForInterfaceOrientation:(long long)arg1;
- (id)icons;
-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;
- (void)reloadWidgetLocations;
- (void)reloadWidgetLocationForBundleIdentifier:(NSString *)arg1;
- (SBIconListModel *)model;
- (BOOL)isFull;
- (SBIconCoordinate)iconCoordinateForIndex:(unsigned long long)arg1 forOrientation:(long long)arg2;
- (SBIcon*)modifiedIconForIcon:(SBIcon*)icon;
- (BOOL)containsIcon:(id)arg1;
- (void)setIconsNeedLayout;
- (void)layoutIconsIfNeeded:(double)arg1 domino:(BOOL)arg2;
- (id)insertIcon:(id)arg1 atIndex:(unsigned long long)arg2 moveNow:(_Bool)arg3;
- (unsigned long long)indexForCoordinate:(SBIconCoordinate)arg1 forOrientation:(long long)arg2;
- (NSMutableArray*)testLayout;
- (NSMutableArray*)testLayout1;
- (struct CGPoint)centerForIconCoordinate:(struct SBIconCoordinate)arg1;
- (id)iconAtPoint:(struct CGPoint)arg1 index:(unsigned long long *)arg2;
- (NSMutableArray*)testIndex;
- (id)placeIcon:(id)arg1 atIndex:(unsigned long long)arg2 moveNow:(_Bool)arg3 pop:(_Bool)arg4;
- (NSMutableArray *)takenPlaces;
- (id)insertIcon:(id)arg1 atIndex:(unsigned long long)arg2 moveNow:(_Bool)arg3 pop:(_Bool)arg4;
- (void)setCoordinate:(SBIconCoordinate)coord forBundleIdentifier:(NSString*)bundleIdentifier;
- (SBIconView*)viewForIcon:(id)arg1;
- (CGFloat)verticalIconPadding;
- (CGFloat)horizontalIconPadding;
- (void)reloadCustomWidgetCoordinates;
- (id)iconAtPoint:(struct CGPoint)arg1 index:(NSUInteger *)arg2 proposedOrder:(int *)arg3 grabbedIcon:(id)arg4;
- (void)layoutIconsNow;
- (NSUInteger)indexOfIcon:(id)arg1;
- (CGPoint)originForIconAtCoordinate:(SBIconCoordinate)arg1;
- (NSMutableArray *)visibleIcons;

@end

@interface SBFolderController : NSObject
// ivar SBIcon *_grabbedIcon;
- (SBIconListView *)iconListViewForTouch:(UITouch *)arg1;
- (SBFolderController *)contentView;
- (SBIconListView *)iconListViewContainingIcon:(id)arg1;

- (void)_resetDragPauseTimerForPoint:(struct CGPoint)arg1 inIconListView:(id)arg2;
@end

@interface SBFolderView : UIView
@property(retain, nonatomic) SBFolder *folder; // @synthesize folder=_folder;
@end
@class SBIconModel;
@interface SBIconModel : NSObject
- (SBIcon *)leafIconForIdentifier:(id)arg1;
@end


@interface SBIconController : UIViewController
+ (id)sharedInstance;
- (SBIconModel *)model;
- (SBIcon *)grabbedIcon;
- (SBIconListView *)currentRootIconList;
- (void)removeIcon:(id)arg1 compactFolder:(_Bool)arg2;
- (void)getListView:(id*)arg1 folder:(id*)arg2 relativePath:(id*)arg3 forIndexPath:(id)arg4 createIfNecessary:(BOOL)arg5;
- (id)insertIcon:(id)icon intoListView:(id)view iconIndex:(int)index moveNow:(BOOL)now pop:(BOOL)pop;
- (id)insertIcon:(id)arg1 intoListView:(id)arg2 iconIndex:(long long)arg3 moveNow:(_Bool)arg4;
- (void)compactIconsInIconListsInFolder:(id)arg1 moveNow:(_Bool)arg2 limitToIconList:(id)arg3;
- (id)_currentFolderController;
- (SBFolderController *)_rootFolderController;
- (NSString *)_debugStringForIconOrder:(int)arg1;
@end


@interface SBApplication : NSObject
@property(copy, nonatomic) NSArray *staticShortcutItems;
- (NSString*)bundleIdentifier;
- (id)urlScheme;
@end

@interface SBApplicationShortcutMenu : UIView
@property(retain, nonatomic) SBApplication *application;
- (id)initWithFrame:(CGRect)arg1 application:(id)arg2 iconView:(id)arg3 interactionProgress:(id)arg4 orientation:(long long)arg5;
- (void)_setupViews;
- (void)_peekWithContentFraction:(double)arg1 smoothedBlurFraction:(double)arg2;
- (void)dismissAnimated:(_Bool)arg1 completionHandler:(id)arg2;
- (id)_shortcutItemsToDisplay;
@end

@interface SBSApplicationShortcutIcon : NSObject
@end

@interface SBSApplicationShortcutItem : NSObject
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
@end

@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
- (id)initWithType:(UIApplicationShortcutIconType)arg1;
@end

@interface SBIconViewMap : NSObject
+ (id)homescreenMap;
- (id)mappedIconViewForIcon:(id)arg1;
@end

@interface SBRootFolder : NSObject
- (id)indexPathForIcon:(id)arg1;
- (id)listAtIndex:(unsigned long long)arg1;
- (unsigned long long)indexOfList:(id)arg1;
@end

@interface SBPlaceholderIcon : SBIcon
+ (id)emptyPlaceholder;
+ (id)grabbedIconPlaceholder;
@end

@interface SBWDXPlaceholderIcon : SBLeafIcon
- (id)initWithIdentifier:(NSString *)identifier;
- (BOOL)isWDXPlaceholderIcon;
- (NSString *)WDXidentifier;
@end

@interface SBWDXPlaceholderIconView : SBIconView
@end

@interface SBWDXPlaceholderIconImageView : SBIconImageView
@end

@interface SBWDXWidgetIcon : SBLeafIcon
- (id)initWithIdentifier:(NSString *)identifier;
- (BOOL)isWDXPlaceholderIcon;
- (NSString *)WDXidentifier;
@end

@interface SBWDXWidgetIconView : SBIconView
@end

@interface SBWDXWidgetIconImageView : SBIconImageView
@end


@interface SBIconIndexMutableList : NSObject
- (void)insertNode:(id)arg1 atIndex:(unsigned long long)arg2;
- (void)removeNode:(id)arg1;
- (NSArray *)nodes;
@end



