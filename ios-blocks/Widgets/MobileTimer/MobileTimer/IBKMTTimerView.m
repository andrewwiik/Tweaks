//
//  IBKMTTimerView.m
//  MobileTimer
//
//  Created by Matt Clarke on 04/04/2015.
//
//

#import "IBKMTTimerView.h"
#import <objc/runtime.h>

@interface IBKResources : NSObject
+(NSString*)suffix;
@end

@interface TimerManager : NSObject

@property double defaultDuration;
@property(readonly) NSString * defaultSound;
@property(readonly) double fireTime;
@property(readonly) double remainingTime;
@property(readonly) int state;

+ (id)sharedManager;
+ (bool)upgrade;

- (bool)cancel;
- (void)changeSound:(NSString*)arg1;
- (double)defaultDuration;
- (NSString*)defaultSound;
- (double)fireTime;
- (bool)pause;
- (void)reloadState;
- (double)remainingTime;
- (bool)resume;
- (void)scheduleAt:(double)arg1 withSound:(NSString*)arg2;
- (void)setDefaultDuration:(double)arg1;
- (void)setDefaultSound:(NSString*)arg1;
- (int)state;

@end

@implementation IBKMTTimerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Buttons.
        
        self.start = [UIButton buttonWithType:UIButtonTypeCustom];
        self.start.backgroundColor = [UIColor whiteColor];
        [self.start addTarget:self action:@selector(startPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.start.frame = CGRectZero;
        
        [self addSubview:self.start];
        
        self.pause = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pause.backgroundColor = [UIColor whiteColor];
        self.pause.frame = CGRectZero;
        [self.pause addTarget:self action:@selector(pausePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.pause];
        
        // Button images
        
        NSString *mainPath = @"/var/mobile/Library/Curago/com.apple.mobiletimer/";
        NSString *stopPath = [NSString stringWithFormat:@"%@Stop%@", mainPath, [objc_getClass("IBKResources") suffix]];
        NSString *startPath = [NSString stringWithFormat:@"%@Start%@", mainPath, [objc_getClass("IBKResources") suffix]];
        NSString *pausePath= [NSString stringWithFormat:@"%@Pause%@", mainPath, [objc_getClass("IBKResources") suffix]];
        
        self.startImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:startPath]];
        self.startImage.frame = CGRectMake(0, 0, 15, 15);
        self.startImage.backgroundColor = [UIColor greenColor];
        self.startImage.userInteractionEnabled = NO;
        [self.start addSubview:self.startImage];
        
        self.stopImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:stopPath]];
        self.stopImage.frame = CGRectMake(0, 0, 15, 15);
        self.stopImage.backgroundColor = [UIColor redColor];
        self.stopImage.alpha = 0.0;
        self.stopImage.userInteractionEnabled = NO;
        [self.start addSubview:self.stopImage];
        
        self.pauseImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:pausePath]];
        self.pauseImage.frame = CGRectMake(0, 0, 15, 15);
        self.pauseImage.backgroundColor = [UIColor grayColor];
        self.pauseImage.userInteractionEnabled = NO;
        [self.pause addSubview:self.pauseImage];
        
        // Time picker
        self.picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.picker.datePickerMode = UIDatePickerModeCountDownTimer;
        self.picker.backgroundColor = [UIColor clearColor];
        
        [self.picker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
        
        SEL selector = NSSelectorFromString(@"setHighlightsToday:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
        BOOL no = NO;
        [invocation setSelector:selector];
        [invocation setArgument:&no atIndex:2];
        [invocation invokeWithTarget:self.picker];
        
        self.pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.pickerContainer.backgroundColor = [UIColor clearColor];
        
        [self.pickerContainer addSubview:self.picker];
        
        self.counterUI = [[UILabel alloc] initWithFrame:self.pickerContainer.frame];
        self.counterUI.text = @"00:00";
        self.counterUI.textAlignment = NSTextAlignmentCenter;
        self.counterUI.textColor = [UIColor whiteColor];
        self.counterUI.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
        self.counterUI.backgroundColor = [UIColor clearColor];
        self.counterUI.alpha = 0.0;
        
        [self.pickerContainer addSubview:self.counterUI];
        
        [self addSubview:self.pickerContainer];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Layout buttons.
    
    self.start.frame = CGRectMake((self.frame.size.width/2) - (self.frame.size.width*0.1) - (self.frame.size.width*0.25), (self.frame.size.height/2) - (self.frame.size.height*0.05), self.frame.size.width*0.25, self.frame.size.width*0.25);
    self.pause.frame = CGRectMake((self.frame.size.width/2) + (self.frame.size.width*0.1), (self.frame.size.height/2) - (self.frame.size.height*0.05), self.frame.size.width*0.25, self.frame.size.width*0.25);
    self.pause.layer.cornerRadius = (self.frame.size.width*0.25)/2;
    self.start.layer.cornerRadius = (self.frame.size.width*0.25)/2;
    
    self.startImage.center = CGPointMake(self.start.frame.size.width/2, self.start.frame.size.height/2);
    self.stopImage.center = self.startImage.center;
    self.pauseImage.center = self.startImage.center;
    
    // Layout picker.
    self.pickerContainer.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.pickerContainer.frame = CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height/2) - (self.frame.size.height*0.1));
    self.picker.frame = CGRectMake(0, 0, self.frame.size.width + (self.frame.size.width*0.25), self.pickerContainer.frame.size.height);
    self.picker.center = CGPointMake(self.frame.size.width/2, self.pickerContainer.frame.size.height/2);
    
    self.counterUI.frame = self.pickerContainer.frame;
    
    if (!self.isRunning)
        self.pickerContainer.transform = CGAffineTransformMakeScale(0.75, 0.75);
}

#pragma mark Button callbacks

-(void)startPressed:(id)sender {
    if (!self.isRunning) {
        self.isRunning = YES;
        self.stopImage.alpha = 1.0;
        self.startImage.alpha = 0.0;
        
        // Set running.
        self.picker.alpha = 0.0;
        self.pickerContainer.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.counterUI.alpha = 1.0;
        
        self.secondsRemaining = (int)self.picker.countDownDuration;
        
        [[objc_getClass("TimerManager") sharedManager] scheduleAt:self.secondsRemaining withSound:[[objc_getClass("TimerManager") sharedManager] defaultSound]];
        [(TimerManager*)[objc_getClass("TimerManager") sharedManager] resume];
        
        unsigned int secs = self.secondsRemaining;
        
        NSLog(@"WE HAVE %d seconds", secs);
        
        int hours = 0;
        int minutes = 0;
        minutes = (secs % 3600) / 60;
        hours = (secs / 3600);
        secs = secs - (3600*hours) - (60*minutes);
        
        if (hours > 0) {
            self.counterUI.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, secs];
        } else {
            self.counterUI.text = [NSString stringWithFormat:@"%02d:%02d", minutes, secs];
        }
        
        self.secondsRemaining--;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown:) userInfo:nil repeats:YES];
    } else {
        self.isRunning = NO;
        self.isPaused = NO;
        self.stopImage.alpha = 0.0;
        self.startImage.alpha = 1.0;
        
        // Stop running regardless of is paused or not.
        self.picker.alpha = 1.0;
        self.pickerContainer.transform = CGAffineTransformMakeScale(0.75, 0.75);
        self.counterUI.alpha = 0.0;
        
        [timer invalidate];
        
        [(TimerManager*)[objc_getClass("TimerManager") sharedManager] cancel];
    }
}

-(void)pausePressed:(id)sender {
    if (!self.isRunning)
        return;
    
    if (!self.isPaused) {
        self.isPaused = YES;
        
        // Pause
        [(TimerManager*)[objc_getClass("TimerManager") sharedManager] pause];
    } else {
        self.isPaused = NO;
        
        // Continue
        [(TimerManager*)[objc_getClass("TimerManager") sharedManager] resume];
    }
}

#pragma mark Update countdown label

-(void)updateCountdown:(id)sender {
    if (self.secondsRemaining < 0) {
        // Well, bugger. Timer has fired.
        self.isRunning = NO;
        self.isPaused = NO;
        self.stopImage.alpha = 0.0;
        self.startImage.alpha = 1.0;
        
        // Stop running regardless of is paused or not.
        self.picker.alpha = 1.0;
        self.pickerContainer.transform = CGAffineTransformMakeScale(0.75, 0.75);
        self.counterUI.alpha = 0.0;
        
        [timer invalidate];
        
        return;
    }
    
    int secs = self.secondsRemaining;
    int hours = 0;
    int minutes = 0;
    minutes = (secs % 3600) / 60;
    hours = (secs / 3600);
    secs = secs - (3600*hours) - (60*minutes);
    
    if (hours > 0) {
        self.counterUI.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, secs];
    } else {
        self.counterUI.text = [NSString stringWithFormat:@"%02d:%02d", minutes, secs];
    }
    
    self.secondsRemaining--;
}

#pragma mark deallocations

-(void)dealloc {
    [timer invalidate];
    timer = nil;
    
    
}
    
@end
