#import <MediaPlayerUI/MPWeakTimer.h>
#import <MediaPlayerUI/MPAVRoutingControllerDelegate-Protocol.h>
#import <MediaPlayerUI/MPAVRoutingTableHeaderView.h>
#import <MediaPlayerUI/MPAVRoutingViewControllerDelegate-Protocol.h>
#import <MediaPlayerUI/MPAVRoute.h>
#import <MediaPlayerUI/MPAVRoutingEmptyStateView.h>
#import <MediaPlayerUI/MPAVRoutingTableViewCellDelegate-Protocol.h>

@interface MPAVRoutingViewController : UIViewController <MPAVRoutingControllerDelegate, MPAVRoutingTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate> {

	UITableView* _tableView;
	MPAVRoutingTableHeaderView* _tableHeaderView;
	MPAVRoutingEmptyStateView* _emptyStateView;
	NSArray* _cachedRoutes;
	BOOL _cachedRoutesHasRoutePickedOnPairedDevice;
	MPAVRoute* _lastPendingPickedRoute;
	MPWeakTimer* _updateTimer;
	MPAVRoutingController* _routingController;
	NSInteger _routeDiscoveryMode;
	UIColor* _tableCellsBackgroundColor;
	UIColor* _tableCellsContentColor;
	int _airPlayPasswordAlertDidAppearToken;
	int _airPlayPasswordAlertDidCancelToken;
	BOOL _airPlayPasswordAlertDidAppearTokenIsValid;
	BOOL _cachedShowAirPlayDebugButton;
	BOOL _hasCachedAirPlayDebugButtonStatus;
	BOOL _needsDisplayedRoutesUpdate;
	BOOL _suspendedDiscoveryModeDueToApplicationState;
	NSUInteger _updatesSincePresentation;
	NSInteger _discoveryModeBeforeEnteringBackground;
	NSUInteger _style;
	id<MPAVRoutingViewControllerDelegate> _delegate;
	NSInteger _avItemType;
	NSUInteger _mirroringStyle;
	NSUInteger _iconStyle;
	NSNumber* _discoveryModeOverride;

}

@property (nonatomic,readonly) NSUInteger style;                                         //@synthesize style=_style - In the implementation block
@property (assign,nonatomic) id<MPAVRoutingViewControllerDelegate> delegate;              //@synthesize delegate=_delegate - In the implementation block
@property (assign,setter=setAVItemType:,nonatomic) NSInteger avItemType;                         //@synthesize avItemType=_avItemType - In the implementation block
@property (assign,nonatomic) NSUInteger mirroringStyle;                                  //@synthesize mirroringStyle=_mirroringStyle - In the implementation block
@property (assign,nonatomic) NSUInteger iconStyle;                                       //@synthesize iconStyle=_iconStyle - In the implementation block
@property (assign,nonatomic) BOOL allowMirroring; 
@property (assign,nonatomic) NSNumber * discoveryModeOverride;                                   //@synthesize discoveryModeOverride=_discoveryModeOverride - In the implementation block
@property (readonly) NSUInteger hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(void)setDelegate:(id<MPAVRoutingViewControllerDelegate>)arg1 ;
-(void)dealloc;
-(CGFloat)tableView:(id)arg1 heightForRowAtIndexPath:(id)arg2 ;
-(CGFloat)tableView:(id)arg1 heightForHeaderInSection:(NSInteger)arg2 ;
-(id)tableView:(id)arg1 viewForHeaderInSection:(NSInteger)arg2 ;
-(void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2 ;
-(NSInteger)tableView:(id)arg1 numberOfRowsInSection:(NSInteger)arg2 ;
-(id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 ;
-(NSInteger)numberOfSectionsInTableView:(id)arg1 ;
-(id)tableView:(id)arg1 titleForFooterInSection:(NSInteger)arg2 ;
-(id<MPAVRoutingViewControllerDelegate>)delegate;
-(NSUInteger)style;
-(id)initWithNibName:(id)arg1 bundle:(id)arg2 ;
-(void)viewDidAppear:(BOOL)arg1 ;
-(void)viewDidDisappear:(BOOL)arg1 ;
-(void)viewWillLayoutSubviews;
-(id)_tableView;
-(id)_tableHeaderView;
-(CGSize)preferredContentSize;
-(void)viewDidLoad;
-(id)initWithStyle:(NSUInteger)arg1 ;
-(void)routingCell:(id)arg1 mirroringSwitchValueDidChange:(BOOL)arg2 ;
-(void)setMirroringStyle:(NSUInteger)arg1 ;
-(NSUInteger)mirroringStyle;
-(NSUInteger)iconStyle;
-(void)setIconStyle:(NSUInteger)arg1 ;
-(void)routingControllerAvailableRoutesDidChange:(id)arg1 ;
-(void)routingController:(id)arg1 pickedRouteDidChange:(id)arg2 ;
-(id)_routingController;
-(void)_registerNotifications;
-(void)_unregisterNotifications;
-(id)_routesWhereMirroringIsPreferred;
-(void)_setNeedsDisplayedRoutesUpdate;
-(void)_setNeedsRouteDiscoveryModeUpdate;
-(void)_reloadEmptyStateVisibility;
-(void)_beginRouteDiscovery;
-(void)_updateDisplayedRoutes;
-(void)_endRouteDiscovery;
-(NSUInteger)_tableViewNumberOfRows;
-(CGFloat)_tableViewHeightAccordingToDataSource;
-(BOOL)_shouldShowAirPlayDebugButton;
-(id)_displayedRoutes;
-(BOOL)_shouldShowMirroringCellForRoute:(id)arg1 ;
-(void)_showAirPlayDebug;
-(void)_pickRoute:(id)arg1 ;
-(BOOL)_shouldShowAirPlayMirroringCompactDescriptionHeader;
-(CGFloat)_normalCellHeight;
-(CGFloat)_expandedCellHeight;
-(CGFloat)_tableViewHeaderViewHeight;
-(CGFloat)_tableViewFooterViewHeight;
-(void)_serviceWillPresentAuthenticationPromptNotification:(id)arg1 ;
-(void)_setRouteDiscoveryMode:(NSInteger)arg1 ;
-(void)_setupUpdateTimerIfNecessary;
-(id)_displayableRoutesInRoutes:(id)arg1 ;
-(void)setAVItemType:(NSInteger)arg1 ;
-(BOOL)allowMirroring;
-(void)setAllowMirroring:(BOOL)arg1 ;
-(void)setDiscoveryModeOverride:(NSNumber *)arg1 ;
-(id)_tableCellsBackgroundColor;
-(id)_tableCellsContentColor;
-(void)_setTableCellsBackgroundColor:(id)arg1 ;
-(void)_setTableCellsContentColor:(id)arg1 ;
-(NSInteger)avItemType;
-(NSNumber *)discoveryModeOverride;
-(void)_applicationDidEnterBackgroundNotification:(id)arg1 ;
-(void)_applicationWillEnterForegroundNotification:(id)arg1 ;
@end