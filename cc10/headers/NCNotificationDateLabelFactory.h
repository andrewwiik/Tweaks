@interface NCNotificationDateLabelFactory : NSObject {

	NSMutableDictionary* _recycledLabelsByStyle;

}
+(id)sharedInstance;
-(void)dealloc;
-(id)init;
-(void)_purgeRecycledLabels;
-(UILabel *)_labelWithStartDate:(id)arg1 endDate:(id)arg2 timeZone:(id)arg3 allDay:(BOOL)arg4 forStyle:(long long)arg5 forType:(int)arg6 ;
-(long long)styleForLabel:(id)arg1 ;
-(UILabel *)startLabelWithStartDate:(id)arg1 endDate:(id)arg2 timeZone:(id)arg3 allDay:(BOOL)arg4 forStyle:(long long)arg5 ;
-(UILabel *)endLabelWithStartDate:(id)arg1 endDate:(id)arg2 timeZone:(id)arg3 allDay:(BOOL)arg4 forStyle:(long long)arg5 ;
-(id)combinedDateLabelWithStartDate:(id)arg1 endDate:(id)arg2 timeZone:(id)arg3 allDay:(BOOL)arg4 forStyle:(long long)arg5 ;
-(void)recycleLabel:(id)arg1 ;
@end
