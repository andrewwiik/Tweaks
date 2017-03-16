//
//  LockLyrics7.xm
//  LockLyrics7
//
//  Created by Pigi Galdi on 13.10.2014.
//  Copyright (c) 2014 Pigi Galdi. All rights reserved.
//
//	Imports.
#import "Imports.h"
#import "dopeLockObject.h"
#include "Headers.h"
static DopeLock *lockView;
static UIScrollView *dopeScroll;

@implementation LPViewController
- (id)init{
	self = [super init];
	if (self) {
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		CGFloat screenWidth = screenRect.size.width;
		CGFloat screenHeight = screenRect.size.height;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && screenWidth > screenHeight)
			lockView = [[DopeLock alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1800)];
		else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			lockView = [[DopeLock alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1800)];
		else
			lockView = [[DopeLock alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1500)];
		lockView.user = @"Friend";
		[lockView addBasicsToView];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && screenWidth > screenHeight)
			dopeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, screenHeight, screenWidth)];
		else
			dopeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, screenHeight)];
		[dopeScroll addSubview:lockView];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			[dopeScroll setContentSize: CGSizeMake(screenWidth, 1800)];
		else
			[dopeScroll setContentSize: CGSizeMake(screenWidth, 1500)];

		// Init __mainView.
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && screenWidth > screenHeight)
			__mainView = [[LPView alloc] initWithFrame:CGRectMake((screenWidth-screenHeight)/2, 0, screenHeight, screenHeight)];
		else
			__mainView = [[LPView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		// Calling methods declared in LPView.h to set LPViewController as delegate of LPPage protocol.
		[__mainView setDelegate:self];
		// Remeber: LPView is a subclass of UIView! ;)
		[__mainView setBackgroundColor:[UIColor clearColor]];
		[__mainView addSubview:dopeScroll];
		//__mainView.userInteractionEnabled=NO; //hey hey :)
		// Setting LPView as LPViewController's view.
		[self setView:__mainView];

	}
	return self;
}

-(void)addArray:(NSMutableArray *)arg1{
	[lockView removeFromSuperview];
	[dopeScroll removeFromSuperview];
	[lockView updateTodayTomorrow:arg1];
	[lockView updateView];
	[dopeScroll addSubview:lockView];
	[__mainView addSubview:dopeScroll];
	[self setView:__mainView];
}

-(void)addUser:(NSString *)arg1
{
	lockView.user = arg1;
}

-(void)setColor:(BOOL)arg1
{
	lockView.textColor = arg1;
}
// 	Delegate methods.
// 	See LPView.h for more methods.
- (NSInteger)priority {
	return 10; // Pages are rendered in descending priority order, so use an high value to put your view as first or a lower to put your page as last page.
}

- (double)idleTimerInterval {
	return 120.0; //Autolock is disabled during 2 minutes when you are on the DopeView
}
@end
