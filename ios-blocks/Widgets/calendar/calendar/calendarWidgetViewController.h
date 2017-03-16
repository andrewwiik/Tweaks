//
//  calendarWidgetViewController.h
//  calendar
//
//  Created by Matt Clarke on 28/02/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IBKWidgetDelegate.h"
#import "CWVIBKView.h"

@interface calendarWidgetViewController : UIViewController <IBKWidgetDelegate>

@property (nonatomic, strong) CWVIBKView *viw;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UILabel *day;

-(UIView*)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad;
-(BOOL)hasButtonArea;
-(BOOL)hasAlternativeIconView;

-(UIView*)alternativeIconViewWithFrame:(CGRect)frame;
-(UIView*)buttonAreaViewWithFrame:(CGRect)frame;

@end