//
//  CameraWidgetViewController.m
//  Camera
//
//  Created by Matt Clarke on 20/04/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "CameraWidgetViewController.h"

@implementation CameraWidgetViewController

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (!self.contentView) {
		self.contentView = [[CameraContentView alloc] initWithFrame:frame];
	}

	return self.contentView;
}

-(BOOL)hasButtonArea {
    return NO;
}

-(BOOL)hasAlternativeIconView {
    return NO;
}

@end