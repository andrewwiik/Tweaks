//
//  MobileTimerContentView.h
//  MobileTimer
//
//  Created by Matt Clarke on 03/04/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BEMAnalogClockView.h"
#import "IBKMTTimerView.h"
#import "IBKMTAlarmViewController.h"

@interface MobileTimerContentView : UIView <BEMAnalogClockDelegate, UIScrollViewDelegate> {
    NSTimer *clockUpdater;
}

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) IBKBEMAnalogClockView *clockFace;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) IBKMTTimerView *timerView;
@property (nonatomic, strong) IBKMTAlarmViewController *alarmsController;
@property (nonatomic, strong) UIView *alarmsContainer;

@end