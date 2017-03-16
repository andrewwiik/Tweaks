//
//  IBKPINModalController.h
//  curago
//
//  Created by Matt Clarke on 15/04/2015.
//
//

#import <Preferences/Preferences.h>

@protocol DevicePINControllerDelegate <NSObject>
@optional
-(void)devicePINControllerDidDismissPINPane:(id)arg1;
-(void)devicePINController:(id)arg1 didAcceptSetPIN:(id)arg2;
-(void)didAcceptSetPIN;
-(void)devicePINController:(id)arg1 didAcceptChangedPIN:(id)arg2;
-(void)didAcceptChangedPIN;
-(void)didAcceptRemovePIN;
-(void)willAcceptEnteredPIN;
-(void)didAcceptEnteredPIN:(id)arg1;
-(void)didAcceptEnteredPIN;
-(void)willCancelEnteringPIN;
-(void)didCancelEnteringPIN;
-(void)didChangePasscode;
@end

#define IBKOpenPasscodePane  0
#define IBKTurnOnPasscode    1
#define IBKTurnOffPasscode   2
#define IBKChangePasscode    3

@interface IBKPINModalController : DevicePINController

@property (nonatomic, weak) NSObject<DevicePINControllerDelegate>* ibkDelegate;
@property (readwrite) int customMode;
@property (readwrite) int failedAttempts;

@end
