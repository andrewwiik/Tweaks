//
//  IBKMTTimerView.h
//  MobileTimer
//
//  Created by Matt Clarke on 04/04/2015.
//
//

#import <UIKit/UIKit.h>

@interface IBKMTTimerView : UIView {
    NSTimer *timer;
}

@property (nonatomic, strong) UIDatePicker *picker;
@property (nonatomic, strong) UIView *pickerContainer;
@property (nonatomic, strong) UIButton *start;
@property (nonatomic, strong) UIButton *pause;
@property (nonatomic, strong) UIImageView *startImage;
@property (nonatomic, strong) UIImageView *pauseImage;
@property (nonatomic, strong) UIImageView *stopImage;
@property (nonatomic, strong) UILabel *counterUI;

@property (nonatomic, readwrite) BOOL isPaused;
@property (nonatomic, readwrite) BOOL isRunning;
@property (nonatomic, readwrite) int secondsRemaining;

@end
