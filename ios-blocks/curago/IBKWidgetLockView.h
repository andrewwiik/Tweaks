//
//  IBKWidgetLockView.h
//  curago
//
//  Created by Matt Clarke on 13/04/2015.
//
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@protocol SBUIPasscodeLockViewDelegate <NSObject>
@optional
-(void)passcodeLockViewEmergencyCallButtonPressed:(id)pressed;
-(void)passcodeLockViewCancelButtonPressed:(id)pressed;
-(void)passcodeLockViewPasscodeEntered:(id)entered;
-(void)passcodeLockViewPasscodeDidChange:(id)passcodeLockViewPasscode;
@end

@interface SBUIPasscodeLockViewBase : UIView
@property id<SBUIPasscodeLockViewDelegate> delegate;
@property bool shouldResetForFailedPasscodeAttempt;
@property bool showsEmergencyCallButton;
@property(readonly) NSString * passcode;
@property(retain, nonatomic) UIColor *customBackgroundColor;
@property double backgroundAlpha;
- (void)resetForFailedPasscode;
- (void)setBiometricMatchMode:(unsigned long long)arg1;
- (void)_resetForFailedMesaAttempt;
- (void)autofillForSuccessfulMesaAttemptWithCompletion:(id)arg1;
@end

@interface SBUIPasscodeLockViewFactory : NSObject
+(SBUIPasscodeLockViewBase*)_passcodeLockViewForStyle:(int)arg1 withLightStyle:(bool)arg2;
+(SBUIPasscodeLockViewBase*)passcodeLockViewForStyle:(int)arg1;
@end

@protocol SBUIBiometricEventMonitorDelegate
@required
-(void)biometricEventMonitor:(id)monitor handleBiometricEvent:(unsigned)event;
@end

@interface SBUIBiometricEventMonitor : NSObject
- (void)addObserver:(id)arg1;
- (void)removeObserver:(id)arg1;
- (void)_startMatching;
- (void)_setMatchingEnabled:(BOOL)arg1;
- (BOOL)isMatchingEnabled;
@end

@interface BiometricKit : NSObject
+ (id)manager;
@end

#define TouchIDFingerDown  1
#define TouchIDFingerUp    0
#define TouchIDFingerHeld  2
#define TouchIDMatched     3
#define TouchIDMaybeMatched 4
#define TouchIDNotMatched  9
#define TouchIDNotMatched2 10

@interface IBKWidgetLockView : UIView <SBUIPasscodeLockViewDelegate, SBUIBiometricEventMonitorDelegate>

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) MarqueeLabel *buttonLabel;
@property (nonatomic, strong) UIImageView *padlock;
@property (nonatomic, strong) NSString *passcodeHash;
@property (nonatomic, strong) UIView *backdropView;
@property (nonatomic, strong) SBUIPasscodeLockViewBase *passcodeView;
@property (nonatomic, strong) UIWindow *ipadWindow;

- (id)initWithFrame:(CGRect)frame passcodeHash:(NSString*)hash isLight:(BOOL)isLight;

@end
