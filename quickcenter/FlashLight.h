//
//  FlashLight.h
//  watchJB
//
//  Created by Brian Olencki on 3/13/16.
//  Copyright © 2016 bolencki13. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBCCFlashlightSetting : NSObject
- (BOOL)toggle;
- (BOOL)_enableTorch:(BOOL)arg1;
@end

@interface FlashLight : NSObject {
    BOOL _strobing;
}
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSObject *flashlight;
+ (FlashLight*)sharedInstance;
- (void)strobeOn;
- (void)strobeOff;
- (BOOL)strobing;
- (void)toggleFlashlight;
@end
