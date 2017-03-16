//
//  IBKPINModalController.m
//  curago
//
//  Created by Matt Clarke on 15/04/2015.
//
//

#import <CommonCrypto/CommonDigest.h>
#import "IBKPINModalController.h"

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

@interface DevicePINController (IOS7)
- (void)setSuccess:(bool)arg1;
@end

@implementation IBKPINModalController

- (bool)attemptValidationWithPIN:(NSString*)pin {
    // Get hash of string, and compare against stored.
    
    NSDictionary *currentSettings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
    
    if ([[currentSettings objectForKey:@"passcodeHash"] isEqualToString:[pin sha1]]) {
        if (self.customMode == IBKOpenPasscodePane)
            [self.ibkDelegate didAcceptEnteredPIN];
        
        return YES;
    } else {
        
        
        return NO;
    }
}

-(bool)isBlocked {
    return NO;
}

-(bool)isNumericPIN {
    return YES;
}
-(BOOL)requiresKeyboard {
    return NO;
}
-(BOOL)simplePIN {
    return YES;
}

-(BOOL)useProgressiveDelays {
    return NO;
}

-(BOOL)validatePIN:(NSString*)arg1 {
    NSDictionary *currentSettings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
    
    if ([[currentSettings objectForKey:@"passcodeHash"] isEqualToString:@""] || ![currentSettings objectForKey:@"passcodeHash"]) {
        return NO;
    } else if ([[currentSettings objectForKey:@"passcodeHash"] isEqualToString:[arg1 sha1]]) {
        return YES;
    } else {
        return NO;
    }
}

-(int)pinLength {
    return 4;
}

-(void)cancelButtonTapped {
    [self.ibkDelegate didCancelEnteringPIN];
}

-(long long)numberOfFailedAttempts {
    return self.failedAttempts;
}

- (void)setPIN:(NSString*)arg1 completion:(id)arg2 {
    NSMutableDictionary *currentSettings = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
    if (!currentSettings) {
        currentSettings = [NSMutableDictionary dictionary];
    }
    
    [currentSettings setObject:(arg1 ? [arg1 sha1] : @"") forKey:@"passcodeHash"];
    [currentSettings writeToFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist" atomically:YES];

	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.matchstic.ibk/changedlockall"), NULL, NULL, YES);
    
    [self.ibkDelegate didChangePasscode];
}

- (void)setPIN:(id)arg1 {
    [self setPIN:arg1 completion:nil];
}

- (id)stringsBundle {
    return [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Preferences.framework"];
}

- (id)stringsTable {
    return @"PIN Entry";
}

@end
