//
//  FlashLight.m
//  watchJB
//
//  Created by Brian Olencki on 3/13/16.
//  Copyright © 2016 bolencki13. All rights reserved.
//

#import "FlashLight.h"
#import <AVFoundation/AVFoundation.h>

@implementation FlashLight
+ (FlashLight*)sharedInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}
- (void)strobeOn {
    self.flashlight = [self.flashlight retain];
    [self.flashlight warmup];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    [self.timer fire];
    _strobing = YES;
}
- (void)strobeOff {
    [self.timer invalidate];
    _strobing = NO;
    self.timer = nil;
    if (self.flashlight) {
       // [self.flashlight _enableTorch:NO];
        [self.flashlight cooldown];
    }
}
- (BOOL)strobing {
    return _strobing;
}

- (void)handleTimer:(NSTimer*)timer {
        NSLog(@"Atleast it was called");
       BOOL maybe = [self.flashlight _toggleState];
       NSLog(@"FalshLightToggled");
}

- (void)toggleFlashlight {
    [self.flashlight _toggleState];
}
@end
