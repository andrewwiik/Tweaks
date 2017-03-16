#import <MediaPlayerUI/MPUMediaRemoteViewController.h>
#import <ControlCenterUI/CCUIControlCenterPageContentViewControllerDelegate-Protocol.h>
#import <MediaPlayerUI/MPAVRoutingControllerDelegate-Protocol.h>
#import <MediaPlayerUI/MPAVRoutingController.h>
#import <MediaPlayerUI/MPAVRoutingViewController.h>
#import <MediaPlayerUI/MPAVRoutingViewControllerDelegate-Protocol.h>
#import <MediaPlayerUI/MPUControlCenterMediaControlsViewDelegate-Protocol.h>
#import <ControlCenterUI/CCUIControlCenterPageContentProviding-Protocol.h>
#import <MediaPlayerUI/MPAVRoutingController.h>
#import <MediaPlayerUI/MPWeakTimer.h>

@interface MPUControlCenterMediaControlsViewController : MPUMediaRemoteViewController <MPAVRoutingControllerDelegate, MPAVRoutingViewControllerDelegate, MPUControlCenterMediaControlsViewDelegate, CCUIControlCenterPageContentProviding> {

	id<CCUIControlCenterPageContentViewControllerDelegate> _delegate;
	MPAVRoutingViewController* _routingViewController;
	BOOL _routingViewVisible;
	BOOL _viewHasAppeared;
	BOOL _controlCenterPageIsVisible;
	MPWeakTimer* _controlCenterPageVisibilityUpdateTimer;

}

@property (readonly) NSUInteger hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
@property (nonatomic, retain) id<CCUIControlCenterPageContentViewControllerDelegate> delegate; 
@property (nonatomic,readonly) UIEdgeInsets contentInsets; 
@property (nonatomic,readonly) BOOL wantsVisible; 
+(Class)controlsViewClass;
+(Class)transportControlButtonClass;
-(id)initWithCoder:(id)arg1 ;
-(void)setDelegate:(id<CCUIControlCenterPageContentViewControllerDelegate>)arg1 ;
// -(void)dealloc;
-(id<CCUIControlCenterPageContentViewControllerDelegate>)delegate;
-(id)initWithNibName:(id)arg1 bundle:(id)arg2 ;
-(void)viewWillAppear:(BOOL)arg1 ;
-(void)viewDidAppear:(BOOL)arg1 ;
-(void)viewDidDisappear:(BOOL)arg1 ;
-(void)viewDidLoad;
-(void)routingControllerAvailableRoutesDidChange:(id)arg1 ;
-(void)routingViewController:(id)arg1 didPickRoute:(id)arg2 ;
-(id)_mediaControlsView;
-(void)nowPlayingController:(id)arg1 playbackStateDidChange:(BOOL)arg2 ;
-(id)remoteControlInterfaceIdentifier;
-(id)transportControlsView:(id)arg1 buttonForControlType:(NSInteger)arg2 ;
-(CGSize)transportControlsView:(id)arg1 defaultTransportButtonSizeWithProposedSize:(CGSize)arg2 ;
-(id)allowedTransportControlTypes;
-(void)_initControlCenterMediaControlsViewController;
-(void)_setRoutingViewControllerVisible:(BOOL)arg1 animated:(BOOL)arg2 ;
-(void)_pickedRouteHeaderViewTapped:(id)arg1 ;
-(void)_setupControlCenterPageVisibilityUpdateTimer;
-(void)_reloadRoutingControllerDiscoveryMode;
-(void)_reloadCurrentLayoutStyle;
-(NSUInteger)_currentLayoutStyle;
-(void)mediaControlsView:(id)arg1 willTransitionToCompactView:(BOOL)arg2 ;
-(void)mediaControlsViewPrimaryActionTriggered:(id)arg1 ;
-(void)controlCenterWillPresent;
-(void)controlCenterDidDismiss;
-(void)controlCenterWillBeginTransition;
-(void)controlCenterDidFinishTransition;
@end
