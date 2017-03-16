//
//  IBKWidgetLockView.m
//  curago
//
//  Created by Matt Clarke on 13/04/2015.
//
//

#import "IBKWidgetLockView.h"
#import "IBKWidgetViewController.h"
#import "IBKResources.h"
#import "AGWindowView.h"
#import <objc/runtime.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Hashes)

- (NSString *)sha1 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end

@interface _UIBackdropView : UIView
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end

@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(int)arg1;
@end

BOOL isMonitoring;
BOOL previousMatchingSetting;

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation UIImage (NegativeImage)

- (UIImage *)negativeImage {
    // get width and height as integers, since we'll be using them as
    // array subscripts, etc, and this'll save a whole lot of casting
    CGSize size = self.size;
    int width = size.width;
    int height = size.height;
    
    // Create a suitable RGB+alpha bitmap context in BGRA colour space
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *memoryPool = (unsigned char *)calloc(width*height*4, 1);
    CGContextRef context = CGBitmapContextCreate(memoryPool, width, height, 8, width * 4, colourSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    // draw the current image to the newly created context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    // run through every pixel, a scan line at a time...
    for(int y = 0; y < height; y++)
    {
        // get a pointer to the start of this scan line
        unsigned char *linePointer = &memoryPool[y * width * 4];
        
        // step through the pixels one by one...
        for(int x = 0; x < width; x++)
        {
            // get RGB values. We're dealing with premultiplied alpha
            // here, so we need to divide by the alpha channel (if it
            // isn't zero, of course) to get uninflected RGB. We
            // multiply by 255 to keep precision while still using
            // integers
            int r, g, b;
            if(linePointer[3])
            {
                r = linePointer[0] * 255 / linePointer[3];
                g = linePointer[1] * 255 / linePointer[3];
                b = linePointer[2] * 255 / linePointer[3];
            }
            else
                r = g = b = 0;
            
            // perform the colour inversion
            r = 255 - r;
            g = 255 - g;
            b = 255 - b;
            
            // multiply by alpha again, divide by 255 to undo the
            // scaling before, store the new values and advance
            // the pointer we're reading pixel data from
            linePointer[0] = r * linePointer[3] / 255;
            linePointer[1] = g * linePointer[3] / 255;
            linePointer[2] = b * linePointer[3] / 255;
            linePointer += 4;
        }
    }
    
    // get a CG image from the context, wrap that into a
    // UIImage
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    
    // clean up
    CGImageRelease(cgImage);
    CGContextRelease(context);
    free(memoryPool);
    
    // and return
    return returnImage;
}

@end

@implementation IBKWidgetLockView

- (id)initWithFrame:(CGRect)frame passcodeHash:(NSString*)hash isLight:(BOOL)isLight {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.passcodeHash = hash;
        self.backgroundColor = [UIColor clearColor];
        
        // Load up padlock
        NSString *padlockPath = [NSString stringWithFormat:@"/Library/Application Support/Curago/Images/LockedPadlock%@", [IBKResources suffix]];
        UIImage *padlock = [UIImage imageWithContentsOfFile:padlockPath];
        
        if (isLight) {
            padlock = [padlock negativeImage];
        }
        
        self.padlock = [[UIImageView alloc] initWithImage:padlock];
        self.padlock.backgroundColor = [UIColor clearColor];
        self.padlock.alpha = 0.2;
        
        [self addSubview:self.padlock];
        
        // Load up button
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.backgroundColor = [UIColor colorWithWhite:(isLight ? 0.0 : 1.0) alpha:0.2];
        self.button.layer.cornerRadius = 5.0;
        [self.button addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.button];
        
        self.buttonLabel = [[MarqueeLabel alloc] initWithFrame:CGRectZero duration:0.4 andFadeLength:5];
        self.buttonLabel.marqueeType = MLContinuous;
        self.buttonLabel.backgroundColor = [UIColor clearColor];
        self.buttonLabel.textAlignment = NSTextAlignmentCenter;
        self.buttonLabel.textColor = (isLight ? [UIColor darkGrayColor] : [UIColor whiteColor]);
        self.buttonLabel.text = @"Unlock";
        self.buttonLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(isPad ? 16 : 13)];
        
        [self.button addSubview:self.buttonLabel];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Layout subviews.
    self.button.frame = CGRectMake(self.frame.size.width*0.1, self.frame.size.height - (isPad ? 40 : 40), self.frame.size.width*0.8, (isPad ? 30 : 30));
    self.buttonLabel.frame = self.button.bounds;
    
    self.padlock.center = CGPointMake(self.frame.size.width/2, self.button.frame.origin.y/2);
}

-(void)buttonWasPressed:(id)sender {
    if ([[sender class] isEqual:[UIButton class]]) {
        // Display passcode UI!
        _UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];
        self.backdropView = (UIView*)[[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
        self.backdropView.userInteractionEnabled = YES;
        self.backdropView.alpha = 0.0;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
            self.passcodeView = [objc_getClass("SBUIPasscodeLockViewFactory") passcodeLockViewForStyle:0];
            self.passcodeView.customBackgroundColor = [UIColor blackColor];
        } else
            self.passcodeView = [objc_getClass("SBUIPasscodeLockViewFactory") _passcodeLockViewForStyle:0 withLightStyle:NO];
        self.passcodeView.showsEmergencyCallButton = NO;
        self.passcodeView.shouldResetForFailedPasscodeAttempt = YES;
        self.passcodeView.delegate = self;
        self.passcodeView.backgroundAlpha = 0.5;
        [self.passcodeView setBiometricMatchMode:1];
        
        [self.backdropView addSubview:self.passcodeView];
        
        if (isPad) {
            self.ipadWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.ipadWindow.backgroundColor = [UIColor clearColor];
            self.ipadWindow.windowLevel = UIWindowLevelStatusBar - 1;
            [self.ipadWindow makeKeyAndVisible];
            
            // AGWindowView now.
            UIView *eh = [[UIView alloc] initWithFrame:CGRectMake(-5, -5, 5, 5)];
            eh.backgroundColor = [UIColor clearColor];
            eh.tag = 133337;
            
            [self.ipadWindow addSubview:eh];
            
            AGWindowView *rotate = [[AGWindowView alloc] initAndAddToWindow:self.ipadWindow];
            rotate.backgroundColor = [UIColor clearColor];
            rotate.supportedInterfaceOrientations = AGInterfaceOrientationMaskAll;
            rotate.clipsToBounds = YES;
            
            [self.ipadWindow addSubview:rotate];
            
            [rotate addSubview:self.backdropView];
            
            self.backdropView.frame = rotate.bounds;
            
            //[rotate rotateManuallyToOrientation:orient];
        } else {
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.backdropView];
        }
    
        [UIView animateWithDuration:0.3 animations:^{
            self.backdropView.alpha = 1.0;
        }];
        
        [self startMonitoring];
    }
}

-(void)passcodeLockViewCancelButtonPressed:(id)pressed {
    [UIView animateWithDuration:0.3 animations:^{
        self.backdropView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.passcodeView removeFromSuperview];
        self.passcodeView = nil;
        
        [self.backdropView removeFromSuperview];
        self.backdropView = nil;
        
        if (isPad) {
            for (UIView *subview in self.ipadWindow.subviews) {
                [subview removeFromSuperview];
            }
            
            self.ipadWindow.hidden = YES;
            self.ipadWindow = nil;
        }
        
        [self stopMonitoring];
    }];
}

-(void)passcodeLockViewPasscodeEntered:(SBUIPasscodeLockViewBase*)entered {
    // Verify passcode.
    //NSString *passcode = entered.passcode;
    
    //[entered resetForFailedPasscode];
    
    [self performSelector:@selector(checkPasscode:) withObject:entered afterDelay:0.2];
}

-(void)biometricEventMonitor:(id)monitor handleBiometricEvent:(unsigned)event {
	switch(event) {
		case TouchIDFingerDown:
			break;
		case TouchIDFingerUp:
			break;
		case TouchIDFingerHeld:
            
			break;
        case TouchIDNotMatched:
            [self.passcodeView resetForFailedPasscode];
			//AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
			break;
		case TouchIDNotMatched2:
            [self.passcodeView resetForFailedPasscode];
			AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
			break;
        case TouchIDMaybeMatched:
        case TouchIDMatched: {
            [(IBKWidgetViewController*)self.delegate unlockWidget];
            
            [self.passcodeView autofillForSuccessfulMesaAttemptWithCompletion:nil];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.backdropView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.passcodeView removeFromSuperview];
                self.passcodeView = nil;
                
                [self.backdropView removeFromSuperview];
                self.backdropView = nil;
                
                if (isPad) {
                    for (UIView *subview in self.ipadWindow.subviews) {
                        [subview removeFromSuperview];
                    }
                    
                    self.ipadWindow.hidden = YES;
                    self.ipadWindow = nil;
                }
            }];
            
			[self stopMonitoring];
			break;
		} default:
			break;
	}
}

-(void)startMonitoring {
	// If already monitoring, don't start again
	if (isMonitoring) {
		return;
	}
	
    isMonitoring = YES;
    
	// Get current monitor instance so observer can be added
	SBUIBiometricEventMonitor* monitor = [[objc_getClass("BiometricKit") manager] delegate];
	// Save current device matching state
	previousMatchingSetting = [monitor isMatchingEnabled];
    
	// Begin listening
	[monitor addObserver:self];
	[monitor _setMatchingEnabled:YES];
	[monitor _startMatching];
}

-(void)stopMonitoring {
	// If already stopped, don't stop again
	if (!isMonitoring) {
		return;
	}
    
	isMonitoring = NO;
    
	// Get current monitor instance so observer can be removed
	SBUIBiometricEventMonitor* monitor = [[objc_getClass("BiometricKit") manager] delegate];
	
	// Stop listening
	[monitor removeObserver:self];
	[monitor _setMatchingEnabled:previousMatchingSetting];
}

-(void)checkPasscode:(SBUIPasscodeLockViewBase*)passcode {
    NSString *pass = [passcode.passcode sha1];
    
    // Compare hashes
    if ([pass isEqualToString:[IBKResources passcodeHash]]) {
        [(IBKWidgetViewController*)self.delegate unlockWidget];
    
        [UIView animateWithDuration:0.3 animations:^{
            self.backdropView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [passcode removeFromSuperview];
            self.passcodeView = nil;
        
            [self.backdropView removeFromSuperview];
            self.backdropView = nil;
        
            if (isPad) {
                for (UIView *subview in self.ipadWindow.subviews) {
                    [subview removeFromSuperview];
                }
                
                self.ipadWindow.hidden = YES;
                self.ipadWindow = nil;
            }
            
            [self stopMonitoring];
        }];
    } else {
        [passcode resetForFailedPasscode];
    }
}

@end
