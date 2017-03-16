//
//  IBKMTAlarmViewController.h
//  MobileTimer
//
//  Created by Matt Clarke on 06/04/2015.
//
//

#import <UIKit/UIKit.h>

@interface IBKMTAlarmViewController : UICollectionViewController

@property (nonatomic, strong) NSArray *alarms;

-(void)loadAlarmsFromManager;

@end
