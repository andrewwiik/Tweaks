//
//  LockLyrics7.xm
//  LockLyrics7
//
//  Created by Pigi Galdi on 13.10.2014.
//  Copyright (c) 2014 Pigi Galdi. All rights reserved.
//
//	Imports.
#import "Imports.h"

@implementation LPView
// Init methods.
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}
// Setting delegate.
// This method is called by LPViewController.
- (void)setDelegate:(id<LPPage>)_delegate {
	self->_page = _delegate;
}
// From here on, you can do whatever you want! :D
// Remember, LPView is a subclass of UIView!
@end
