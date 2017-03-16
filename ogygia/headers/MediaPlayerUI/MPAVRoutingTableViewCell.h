#import <MediaPlayerUI/MPAVRoute.h>
#import <MediaPlayerUI/MPAVRoutingTableViewCellDelegate-Protocol.h>

@interface MPAVRoutingTableViewCell : UITableViewCell {

	UIImageView* _iconImageView;
	UILabel* _routeNameLabel;
	UILabel* _subtitleTextLabel;
	UIActivityIndicatorView* _spinnerView;
	UILabel* _mirroringLabel;
	UISwitch* _mirroringSwitch;
	UIView* _mirroringSeparatorView;
	BOOL _mirroringSwitchVisible;
	BOOL _debugCell;
	BOOL _pendingSelection;
	id<MPAVRoutingTableViewCellDelegate> _delegate;
	MPAVRoute* _route;
	NSUInteger _mirroringStyle;
	NSUInteger _iconStyle;

}

@property (assign,nonatomic) id<MPAVRoutingTableViewCellDelegate> delegate;              //@synthesize delegate=_delegate - In the implementation block
@property (nonatomic,retain) MPAVRoute * route;                                                 //@synthesize route=_route - In the implementation block
@property (assign,nonatomic) BOOL mirroringSwitchVisible;                                       //@synthesize mirroringSwitchVisible=_mirroringSwitchVisible - In the implementation block
@property (assign,nonatomic) NSUInteger mirroringStyle;                                 //@synthesize mirroringStyle=_mirroringStyle - In the implementation block
@property (assign,nonatomic) NSUInteger iconStyle;                                      //@synthesize iconStyle=_iconStyle - In the implementation block
@property (assign,getter=isDebugCell,nonatomic) BOOL debugCell;                                 //@synthesize debugCell=_debugCell - In the implementation block
@property (assign,getter=isPendingSelection,nonatomic) BOOL pendingSelection;                   //@synthesize pendingSelection=_pendingSelection - In the implementation block
-(void)layoutSubviews;
-(void)setDelegate:(id<MPAVRoutingTableViewCellDelegate>)arg1 ;
-(id)initWithStyle:(NSInteger)arg1 reuseIdentifier:(id)arg2 ;
-(id<MPAVRoutingTableViewCellDelegate>)delegate;
-(void)setTintColor:(id)arg1 ;
-(MPAVRoute *)route;
-(void)setRoute:(MPAVRoute *)arg1 ;
-(id)_detailTextForRoute:(id)arg1 ;
-(id)_iconImageForRoute:(id)arg1 ;
-(BOOL)_shouldShowMirroringAsEnabledForRoute:(id)arg1 ;
-(void)setMirroringSwitchVisible:(BOOL)arg1 animated:(BOOL)arg2 ;
-(void)_configureLabel:(id)arg1 ;
-(void)_mirroringSwitchValueDidChange:(id)arg1 ;
-(BOOL)_shouldShowSeparateBatteryPercentagesForBatteryLevel:(id)arg1 ;
-(id)_routingImageStyleName;
-(id)_airpodsIconImageName;
-(id)_currentDeviceRoutingIconImageName;
-(void)setMirroringSwitchVisible:(BOOL)arg1 ;
-(void)setMirroringStyle:(NSUInteger)arg1 ;
-(void)setDebugCell:(BOOL)arg1 ;
-(void)setPendingSelection:(BOOL)arg1 ;
-(void)_configureDetailLabel:(id)arg1 ;
-(BOOL)mirroringSwitchVisible;
-(NSUInteger)mirroringStyle;
-(NSUInteger)iconStyle;
-(void)setIconStyle:(NSUInteger)arg1 ;
-(BOOL)isDebugCell;
-(BOOL)isPendingSelection;
@end