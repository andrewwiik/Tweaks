#import "headers.h"
@interface BNHourlyView : UIView {
	UIImageView * _conditionIconView;
	UILabel * _timeLabel;
	UILabel * _tempatureLabel;
	UIImage * _conditionImage;
	NSString * _time;
	NSString * _tempature;
}
- (id)initWithTime:(NSString *)time conditionCode:(int)condition tempature:(NSString *)tempature;
@end