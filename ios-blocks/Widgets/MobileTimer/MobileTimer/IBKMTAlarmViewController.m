//
//  IBKMTAlarmViewController.m
//  MobileTimer
//
//  Created by Matt Clarke on 06/04/2015.
//
//

#import "IBKMTAlarmViewController.h"
#import "IBKMTAlarmsCell.h"
#import <objc/runtime.h>

@interface IBKAPI
+(CGFloat)heightForContentView;
@end

@interface SpringBoard : UIApplication
-(void)launchApplicationWithIdentifier:(NSString*)ident suspended:(BOOL)arg2;
@end

@interface SBApplication : NSObject
- (void)deactivate;
- (void)resumeToQuit;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (SBApplication*)applicationWithBundleIdentifier:(id)arg1;
@end

@interface AlarmManager : NSObject
+ (id)sharedManager;
- (id)alarms;
- (void)loadAlarms;
- (void)updateAlarm:(id)arg1 active:(bool)arg2;
- (void)setAlarm:(id)arg1 active:(bool)arg2;
- (void)saveAlarms;
- (void)loadScheduledNotifications;
@end

@interface ClockManager : NSObject
+ (id)sharedManager;
- (void)setRunningInSpringBoard:(bool)arg1;
- (void)refreshScheduledLocalNotificationsCache;
@end

@interface IBKMTAlarmViewController ()

@end

@implementation IBKMTAlarmViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        // Initialization code
    }
    
    return self;
}

-(void)loadAlarmsFromManager {
    AlarmManager *manager = [objc_getClass("AlarmManager") sharedManager];
    [manager loadAlarms];
    [[objc_getClass("ClockManager") sharedManager] setRunningInSpringBoard:YES];
    [[objc_getClass("ClockManager") sharedManager] refreshScheduledLocalNotificationsCache];
    [manager loadScheduledNotifications];
    self.alarms = [manager alarms];
}

#pragma mark UICollectionView delegate

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IBKMTAlarmsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"alarmsCell" forIndexPath:indexPath];
    [cell setupForAlarm:self.alarms[indexPath.row]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.alarms count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.collectionView.frame.size.width/2)-10;
    return CGSizeMake(width, width);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    Alarm *alarm = self.alarms[indexPath.row];
    
    BOOL wasActive = alarm.isActive;
    
    //[[objc_getClass("AlarmManager") sharedManager] setAlarm:alarm active:!wasActive];
    [[objc_getClass("AlarmManager") sharedManager] updateAlarm:alarm active:!wasActive];
    [[objc_getClass("AlarmManager") sharedManager] saveAlarms];
    
    CFPreferencesAppSynchronize(CFSTR("com.apple.mobiletimer"));
    
    /*SBApplication *app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:@"com.apple.mobiletimer"];
    [app resumeToQuit];
    [app deactivate];
    
    app = nil;
    
    [(SpringBoard*)[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.mobiletimer" suspended:YES];*/
    
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 0, self.collectionView.frame.size.height - [objc_getClass("IBKAPI") heightForContentView] + 10, 0);
}

@end
