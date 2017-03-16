@class NTXModernNotificationView;
@interface NCRelativeDateLabel : UILabel
-(void)prepareForReuse;
-(void)timerFiredWithValue:(unsigned long long)arg1 forResolution:(int)arg2 comparedToNow:(long long)arg3 ;
-(void)setTimeZoneRelativeStartDate:(id)arg1 absoluteStartDate:(id)arg2 ;
-(id)constructLabelString;

// CC10

@property (nonatomic, retain) NTXModernNotificationView *syncTextDelegate;
@end