//
//  calendarWidgetViewController.m
//  calendar
//
//  Created by Matt Clarke on 28/02/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "calendarWidgetViewController.h"

static calendarWidgetViewController *contr;

@implementation calendarWidgetViewController

static void SignificantTimeChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [contr updateDayTime];
}

-(id)init {
    self = [super init];
    
    if (self) {
        contr = self;
    }
    
    return self;
}

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (!self.viw) {
		self.viw = [[UIView alloc] initWithFrame:frame];
        
        // Initialise content view!
    }
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, SignificantTimeChanged, CFSTR("SignificantTimeChangeNotification"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    
	return self.viw;
}

-(BOOL)hasButtonArea {
    return YES;
}

-(BOOL)hasAlternativeIconView {
    return YES;
}

-(UIView*)alternativeIconViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    
    self.day = [[UILabel alloc] initWithFrame:CGRectMake(4, frame.size.height-24, 200, 12)];
    self.day.text = @"Saturday";
    self.day.textAlignment = NSTextAlignmentLeft;
    self.day.textColor = [UIColor redColor];
    self.day.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    
    [self updateDayTime];
    
    [view addSubview:self.day];
    
    self.day.frame = CGRectMake(4, frame.size.height - self.day.frame.size.height - 7, self.day.frame.size.width, self.day.frame.size.height);
    
    return view;
}

-(UIView*)buttonAreaViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    
    self.date = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-50, 0, 50, frame.size.height)];
    self.date.text = @"88";
    self.date.textAlignment = NSTextAlignmentRight;
    self.date.textColor = [UIColor blackColor];
    self.date.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40];
    
    [self updateDayTime];
    
    [self.date sizeToFit];
    
    self.date.frame = CGRectMake(frame.size.width-self.date.frame.size.width-4, frame.size.height-self.date.frame.size.height, self.date.frame.size.width, self.date.frame.size.height);
    
    [view addSubview:self.date];
    
    return view;
}

-(void)updateDayTime {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"d";

    [self.date setText:[dateFormat stringFromDate:today]];
    
    dateFormat.dateFormat = @"EEEE";
    
    [self.day setText:[dateFormat stringFromDate:today]];
    
    [self.day sizeToFit];
}

-(BOOL)wantsGradientBackground {
    return YES;
}

-(NSArray*)gradientBackgroundColors {
    return [NSArray arrayWithObjects:@"E6E6E6", @"FFFFFF", nil];
}

@end