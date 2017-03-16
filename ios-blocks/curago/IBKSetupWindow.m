//
//  IBKSetupWindow.m
//  curago
//
//  Created by Matt Clarke on 12/04/2015.
//
//

#import "IBKSetupWindow.h"

@implementation IBKSetupWindow

// Allow us to allows display over the lockscreen
- (bool)_shouldCreateContextAsSecure {
    return YES;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.windowLevel = 1075.0; // Drop us above Convergance too.
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}



@end
