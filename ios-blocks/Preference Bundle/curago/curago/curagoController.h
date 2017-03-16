//
//  curagoController.h
//  curago
//
//  Created by Matt Clarke on 21/02/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import "IBKHeaderView.h"
#import <MessageUI/MessageUI.h>
#import "IBKPasscodeController.h"
#import "IBKPINModalController.h"

@interface curagoController : PSListController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, DevicePINControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) IBKHeaderView *headerview;
@property (nonatomic, strong) IBKPINModalController *pinController;
@property (nonatomic, strong) UIPopoverController *ipadPopover;
//@property (nonatomic, strong) IBKPasscodeController *passcodeController;

+(instancetype)sharedInstance;
-(void)loadInPrefsForIndex:(int)index animated:(BOOL)animated;
-(void)didAcceptEnteredPIN;

@end