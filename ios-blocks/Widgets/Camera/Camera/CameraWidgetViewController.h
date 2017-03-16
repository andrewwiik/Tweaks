//
//  CameraWidgetViewController.h
//  Camera
//
//  Created by Matt Clarke on 20/04/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IBKWidgetDelegate.h"
#import "CameraContentView.h"

@interface CameraWidgetViewController : NSObject <IBKWidgetDelegate>

@property (nonatomic, strong) CameraContentView *contentView;

@end