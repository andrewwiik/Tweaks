@interface NCNotificationListCellActionButton : UIControl
@property (nonatomic,retain) UILabel * titleLabel;                                                                             //@synthesize titleLabel=_titleLabel - In the implementation block
@property (nonatomic,retain) UIView * backgroundView;                                                                          //@synthesize backgroundView=_backgroundView - In the implementation block
@property (nonatomic,retain) UIView * backgroundOverlayView; 
-(void)_configureTitleLabelIfNecessary;
@end