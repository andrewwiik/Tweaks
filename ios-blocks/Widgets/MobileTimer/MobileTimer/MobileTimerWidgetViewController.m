//
//  MobileTimerWidgetViewController.m
//  MobileTimer
//
//  Created by Matt Clarke on 03/04/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "MobileTimerWidgetViewController.h"

@implementation MobileTimerWidgetViewController

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (!self.contentView) {
		self.contentView = [[MobileTimerContentView alloc] initWithFrame:frame];
        self.contentView.delegate = self;
	}

	return self.contentView;
}

-(BOOL)hasButtonArea {
    return NO;
}

-(BOOL)hasAlternativeIconView {
    return YES;
}

-(UIView*)alternativeIconViewWithFrame:(CGRect)frame {
    self.iconView = [[MobileTimerIconView alloc] initWithFrame:frame];
    return self.iconView;
}

-(BOOL)wantsGradientBackground {
    return YES;
}

-(void)updateIconWithPercentage:(CGFloat)percentage {
    [self.iconView changeToPercentage:percentage];
}

-(NSArray*)gradientBackgroundColors {
    return [NSArray arrayWithObjects:@"1E1E1E", @"484848", nil];
}

@end