//
//  BBCNewsWidgetViewController.h
//  BBCNews
//
//  Created by Matt Clarke on 12/03/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IBKWidgetDelegate.h"
#import "BBCNewsContentView.h"

@interface BBCNewsWidgetViewController : NSObject <IBKWidgetDelegate>

@property (nonatomic, strong) BBCNewsContentView *contentView;

@end