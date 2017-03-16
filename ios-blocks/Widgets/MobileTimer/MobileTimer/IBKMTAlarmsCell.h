//
//  IBKMTAlarmsCell.h
//  MobileTimer
//
//  Created by Matt Clarke on 06/04/2015.
//
//

#import <UIKit/UIKit.h>

@interface Alarm : NSObject
@property(getter=isActive, readonly) bool active;
@property(readonly) NSString * alarmId;
@property bool allowsSnooze;
@property unsigned int daySetting;
@property unsigned int hour;
@property unsigned int minute;
@property(readonly) NSString * rawTitle;
@property(readonly) NSArray * repeatDays;
@property(readonly) bool repeats;
@property(getter=isSnoozed,readonly) bool snoozed;
- (id)uiTitle;
@end

@interface IBKMTAlarmsCell : UICollectionViewCell

@property (nonatomic, strong) UIView *backgroundCircle;
@property (nonatomic, strong) UILabel *time;

-(void)setupForAlarm:(Alarm*)alarm;

@end
