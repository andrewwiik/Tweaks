@protocol CCUIControlCenterPagePlatterViewDelegate
@property (nonatomic,readonly) BOOL shouldSuppressPunchOutMaskCaching; 
@required
-(BOOL)shouldSuppressPunchOutMaskCaching;
-(id)controlCenterSystemAgent;

@end