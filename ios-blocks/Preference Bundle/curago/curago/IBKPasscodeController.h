//
//  IBKPasscodeController.h
//  curago
//
//  Created by Matt Clarke on 14/04/2015.
//
//

#import <Preferences/Preferences.h>
#import "IBKPINModalController.h"

@interface IBKPasscodeController : PSListController <DevicePINControllerDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) IBKPINModalController *pinController;
@property (nonatomic, strong) UIPopoverController *ipadPopover;

@end
