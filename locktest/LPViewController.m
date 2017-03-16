//
//  LockLyrics7.xm
//  LockLyrics7
//
//  Created by Pigi Galdi on 13.10.2014.
//  Copyright (c) 2014 Pigi Galdi. All rights reserved.
//
//	Imports.
#import "Imports.h"

#import <QuartzCore/CAFilter.h>
#import "SBIconViewDelegate-Protocol.h"

// Preferences
#define prefsID CFSTR("com.sassoty.extremity")

#define log(z) NSLog(@"[Extremity] %@", z)
#define str(z, ...) [NSString stringWithFormat:z, ##__VA_ARGS__]

#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]

// float used to check if should keep container where it was before gesture began
#define PAN_TOLERANCE_STAY_SAME_POSITION 100.f
// float used to specify y position of container
#define CONTAINER_X_SHOWING_POSITION 10.f
#define CONTAINER_Y_SHOWING_POSITION 25.f
// float used to cap the velocity of the uiview animation
#define MAX_VELOCITY_DURATION_ALLOWED 0.8f

// Root Folder i.e. the home screen
@interface SBRootFolderView : UIView
- (UIScrollView *)scrollView;
@end

@interface SBRootFolderController : NSObject
@property(readonly, retain, nonatomic) SBRootFolderView *contentView;
@property(readonly, nonatomic, getter=isEditing) BOOL editing;
@end

// Dock stuff
@interface SBDockView : UIView <UIGestureRecognizerDelegate, UIScrollViewDelegate>
- (id)dockListView;
@end

@interface SBDockIconListView : UIView
- (id)icons;
@end

@interface SBIcon : NSObject
- (void)launchFromLocation:(int)arg1; // iOS 7 & 8
- (void)launchFromLocation:(int)arg1 context:(id)arg2; // iOS 8.3
- (id)applicationBundleID;
@end

// Blur
@interface CABackdropLayer : CALayer
- (void)setBackdropRect:(CGRect)arg1;
@end

//Stuff for getting all the icons for the drawer
@interface SBIconView : UIView
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) SBIcon *icon;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) CGRect iconImageFrame;
+ (CGSize)defaultIconSize;
- (BOOL)isInDock;
- (id)initWithDefaultSize;
- (id)initWithContentType:(unsigned long long)arg1;
- (void)setLabelHidden:(BOOL)hidden;
- (void)_setIcon:(SBIcon*)icon animated:(BOOL)animated;
- (void)setHighlighted:(BOOL)highlighted;
@end

@interface SBIconViewMap : NSObject
+ (id)homescreenMap;
- (SBIconView*)mappedIconViewForIcon:(SBIcon*)icon;
@end

@interface SBApplication : NSObject
@end

@interface SBApplicationIcon : SBIcon
- (id)initWithApplication:(id)arg1;
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithDisplayIdentifier:(id)arg1;
- (id)applicationWithBundleIdentifier:(id)arg1;
@end

@interface SBIconModel : NSObject
- (SBIcon*)expectedIconForDisplayIdentifier:(NSString*)identifier;
@end

@interface SBIconController : NSObject
+ (id)sharedInstance;
- (SBIconModel *)model;
- (id)_currentFolderController;
@end


@implementation LPViewController
- (id)init{
	self = [super init];
	if (self) {
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		CGFloat screenWidth = screenRect.size.width;
		CGFloat screenHeight = screenRect.size.height;
		self.view.frame = CGRectMake(0,0,screenWidth, screenHeight + 20);

		self.mainView = [[LPView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		// Calling methods declared in LPView.h to set LPViewController as delegate of LPPage protocol.
		[self.mainView setDelegate:self];
		UIVisualEffect *blurEffect;
		blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		[blurEffect setValue:@300 forKeyPath:@"effectSettings.blurRadius"]; 

		UIVisualEffectView *visualEffectView;
		visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

		visualEffectView.frame = [[UIScreen mainScreen] bounds];
		[self.mainView setBackgroundColor:[UIColor clearColor]];
		[self.mainView addSubview:visualEffectView];
		// Remeber: LPView is a subclass of UIView! ;)
		// [mainView setBackgroundColor:[UIColor clearColor]];

		//__mainView.userInteractionEnabled=NO; //hey hey :)
		// Setting LPView as LPViewController's view.
		[self setView:self.mainView];
		self.mainView.frame = CGRectMake(0,0,screenWidth, screenHeight + 20);

		/* Favorite Apps */
		NSArray *appIDs = @[@"com.apple.Music", @"com.apple.MobileSMS", @"com.atebits.Tweetie2", @"com.apple.Maps"];
		int iconsPerPage = 4;
		CGSize iconSize = [SBIconView defaultIconSize];
		CGFloat appSpacing = (self.view.frame.size.width - (iconsPerPage * iconSize.width)) / (iconsPerPage + 1);
		CGFloat lastX = 0.f;
		for(NSString *appID in appIDs) {
		// Add spacing in beginning of loop so it isn't added to the end of the content size
		lastX += appSpacing;
		// Create and add icon
		SBIconView *appIconView = newIconViewForID(appID);
		[appIconView setLabelHidden:NO];
		appIconView.alpha = 0.f;
		appIconView.frame = CGRectMake(lastX, 0.f, appIconView.frame.size.width, appIconView.frame.size.height);
		appIconView.center = CGPointMake(appIconView.center.x, (self.mainView.frame.size.height / 2) - 7.5f);
		[visualEffectView.contentView addSubview:appIconView];
		}







	}
	return self;
}


// 	Delegate methods.
// 	See LPView.h for more methods.
- (NSInteger)priority {
	return 10; // Pages are rendered in descending priority order, so use an high value to put your view as first or a lower to put your page as last page.
}

- (double)idleTimerInterval {
	return 120.0; //Autolock is disabled during 2 minutes when you are on the DopeView
}

- (void)pageWillPresent {
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat screenWidth = screenRect.size.width;
	CGFloat screenHeight = screenRect.size.height;
	self.mainView.frame = CGRectMake(self.mainView.frame.origin.x,0,screenWidth, screenHeight + 20);
}
- (void)setUpFavorites {
	
}
@end
