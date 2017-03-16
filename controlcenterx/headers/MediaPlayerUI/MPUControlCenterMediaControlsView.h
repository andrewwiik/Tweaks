#import <MediaPlayerUI/MPUMediaRemoteControlsView.h>
#import <MediaPlayerUI/MPUControlCenterMediaControlsViewDelegate-Protocol.h>
#import <MediaPlayerUI/MPUControlCenterMediaControlsViewController.h>
#import <MediaPlayerUI/MPUEmptyNowPlayingViewDelegate-Protocol.h>
#import <MPUFoundation/MPULayoutInterpolator.h>
#import <MediaPlayerUI/MPUMediaControlsVolumeView.h>
#import <MediaPlayerUI/MPUTransportControlsView.h>
#import <MediaPlayerUI/MPUControlCenterTimeView.h>
#import <MediaPlayerUI/MPUControlCenterMetadataView.h>
#import <MediaPlayerUI/MPAVRoute.h>
#import <MediaPlayerUI/MPUNowPlayingArtworkView.h>
#import <MediaPlayerUI/MPUAVRouteHeaderView.h>
#import <MediaPlayerUI/MPUEmptyNowPlayingView.h>

@interface MPUControlCenterMediaControlsView : MPUMediaRemoteControlsView <MPUEmptyNowPlayingViewDelegate> {

	MPULayoutInterpolator* _contentSizeInterpolator;
	MPULayoutInterpolator* _marginLayoutInterpolator;
	MPULayoutInterpolator* _landscapeMarginLayoutInterpolator;
	MPULayoutInterpolator* _artworkNormalContentSizeLayoutInterpolator;
	MPULayoutInterpolator* _artworkLargeContentSizeLayoutInterpolator;
	MPULayoutInterpolator* _artworkLandscapePhoneLayoutInterpolator;
	MPULayoutInterpolator* _labelsLeadingHeightPhoneLayoutInterpolator;
	MPULayoutInterpolator* _transportControlsWidthStandardLayoutInterpolator;
	MPULayoutInterpolator* _transportControlsWidthCompactLayoutInterpolator;
	UIView* _routingContainerView;
	MPUControlCenterMetadataView* _titleLabel;
	MPUControlCenterMetadataView* _artistLabel;
	MPUControlCenterMetadataView* _albumLabel;
	MPUControlCenterMetadataView* _artistAlbumConcatenatedLabel;
	BOOL _unknownApplication;
	BOOL _useCompactStyle;
	BOOL _animating;
	id<MPUControlCenterMediaControlsViewDelegate> _delegate;
	NSUInteger _layoutStyle;
	MPAVRoute* _pickedRoute;
	UIView* _routingView;
	MPUNowPlayingArtworkView* _artworkView;
	MPUAVRouteHeaderView* _pickedRouteHeaderView;
	MPUEmptyNowPlayingView* _emptyNowPlayingView;
	NSUInteger _displayMode;

}

@property (assign,nonatomic) NSUInteger displayMode;                                             //@synthesize displayMode=_displayMode - In the implementation block
@property (assign,nonatomic) MPUControlCenterMediaControlsViewController *delegate;              //@synthesize delegate=_delegate - In the implementation block
@property (assign,nonatomic) NSUInteger layoutStyle;                                             //@synthesize layoutStyle=_layoutStyle - In the implementation block
@property (assign,nonatomic) BOOL useCompactStyle;                                                       //@synthesize useCompactStyle=_useCompactStyle - In the implementation block
@property (nonatomic,retain) MPAVRoute * pickedRoute;                                                    //@synthesize pickedRoute=_pickedRoute - In the implementation block
@property (nonatomic,retain) UIView * routingView;                                                       //@synthesize routingView=_routingView - In the implementation block
@property (nonatomic,readonly) MPUNowPlayingArtworkView * artworkView;                                   //@synthesize artworkView=_artworkView - In the implementation block
@property (nonatomic,readonly) MPUAVRouteHeaderView * pickedRouteHeaderView;                             //@synthesize pickedRouteHeaderView=_pickedRouteHeaderView - In the implementation block
@property (nonatomic,readonly) MPUEmptyNowPlayingView * emptyNowPlayingView;                             //@synthesize emptyNowPlayingView=_emptyNowPlayingView - In the implementation block
@property (nonatomic,readonly) BOOL animating;                                                           //@synthesize animating=_animating - In the implementation block
@property (readonly) NSUInteger hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(id)initWithCoder:(id)arg1 ;
-(void)setDelegate:(MPUControlCenterMediaControlsViewController *)arg1 ;
-(MPUControlCenterMediaControlsViewController *)delegate;
-(void)_init;
-(CGSize)intrinsicContentSize;
-(BOOL)animating;
-(NSUInteger)displayMode;
-(NSUInteger)layoutStyle;
-(void)setLayoutStyle:(NSUInteger)arg1 ;
-(MPAVRoute *)pickedRoute;
-(id)volumeView;
-(id)timeView;
-(MPUNowPlayingArtworkView *)artworkView;
-(void)emptyNowPlayingView:(id)arg1 couldNotLoadApplication:(id)arg2 ;
-(id)transportControls;
-(void)setNowPlayingMetadata:(id)arg1 ;
-(void)setTimeViewVisible:(BOOL)arg1 ;
-(void)setNowPlayingAppDisplayID:(id)arg1 ;
-(void)setRoutingView:(UIView *)arg1 ;
-(MPUAVRouteHeaderView *)pickedRouteHeaderView;
-(void)setPickedRoute:(MPAVRoute *)arg1 ;
-(BOOL)useCompactStyle;
-(void)setUseCompactStyle:(BOOL)arg1 animated:(BOOL)arg2 ;
-(void)_primaryActionTapped:(id)arg1 ;
-(id)_createTappableNowPlayingMetadataView;
-(void)_reloadDisplayModeOrCompactStyleVisibility;
-(void)_layoutPhoneCompactStyle;
-(void)_layoutPhoneRegularStyle;
-(BOOL)_nowPlayingMetadataHasDisplayableProperties:(id)arg1 ;
-(void)_reloadNowPlayingInfoLabels;
-(void)_layoutPad;
-(void)_layoutPhoneLandscape;
-(void)_layoutPhoneRegularStyleMediaControlsUsingBounds:(CGRect)arg1 ;
-(CGSize)_artworkViewSize;
-(CGFloat)_standardLabelBoundingBoxPaddingFromMetadataView:(id)arg1 toMetadataView:(id)arg2 ;
-(void)_layoutExpandedRoutingViewUsingBounds:(CGRect)arg1 ;
-(id)_nowPlayingMetadataTextWithString:(id)arg1 bold:(BOOL)arg2 centered:(BOOL)arg3 ;
-(BOOL)_routingViewShouldBeVisible;
-(void)setUseCompactStyle:(BOOL)arg1 ;
-(UIView *)routingView;
-(MPUEmptyNowPlayingView *)emptyNowPlayingView;
-(void)setDisplayMode:(NSUInteger)arg1 ;
-(void)setArtworkImage:(id)arg1 ;
@end
