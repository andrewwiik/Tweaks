//
//  MobileTimerWidgetViewController.h
//  MobileTimer
//
//  Created by Matt Clarke on 03/04/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IBKWidgetDelegate.h"
#import "MobileTimerContentView.h"
#import "MobileTimerIconView.h"

@interface MobileTimerWidgetViewController : NSObject <IBKWidgetDelegate>

@property (nonatomic, strong) MobileTimerContentView *contentView;
@property (nonatomic, strong) MobileTimerIconView *iconView;

-(void)updateIconWithPercentage:(CGFloat)percentage;

@end