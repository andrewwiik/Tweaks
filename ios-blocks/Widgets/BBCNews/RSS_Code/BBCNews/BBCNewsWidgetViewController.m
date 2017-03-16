//
//  BBCNewsWidgetViewController.m
//  BBCNews
//
//  Created by Matt Clarke on 12/03/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "BBCNewsWidgetViewController.h"
#import "IBKLabel.h"

@implementation BBCNewsWidgetViewController

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (!self.contentView) {
		self.contentView = [[BBCNewsContentView alloc] initWithFrame:frame];
	}

	return self.contentView;
}

-(BOOL)hasButtonArea {
    return YES;
}

-(BOOL)hasAlternativeIconView {
    return NO;
}

-(BOOL)wantsNoContentViewFadeWithButtons {
    return YES;
}

-(UIView*)buttonAreaViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    
    IBKLabel *label = [[IBKLabel alloc] initWithFrame:view.bounds];
    label.text = @"Top Stories";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.alpha = 0.5;
    
    [label setLabelSize:kIBKLabelSizingMedium];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    
    [view addSubview:label];
    
    return view;
}

-(BOOL)wantsGradientBackground {
    return YES;
}

-(NSArray*)gradientBackgroundColors {
    return [NSArray arrayWithObjects:@"990000", @"CD0302", nil];
}

@end