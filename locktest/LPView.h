//
//  LockLyrics7.xm
//  LockLyrics7
//
//  Created by Pigi Galdi on 13.10.2014.
//  Copyright (c) 2014 Pigi Galdi. All rights reserved.
//
//	Imports.
#import "Imports.h"

@class UIView;

// LPPage protocol.
// You can take this from David Ashman website: http://blog.dba-technologies.com/post/76284090466/extending-the-lockscreen-with-lockpages
@protocol LPPage <NSObject>
- (UIView *)view;
- (NSInteger)priority;
@optional
- (double)backgroundAlpha;
- (_Bool)isTimeEnabled;
- (double)idleTimerInterval;
- (void)pageDidDismiss;
- (void)pageWillDismiss;
- (void)pageDidPresent;
- (void)pageWillPresent;
@end

@interface LPView : UIView {
	// LockPages.
	id <LPPage> _page;
}
// Set LPPage delegate.
- (void)setDelegate:(id<LPPage>)_delegate;
@end
