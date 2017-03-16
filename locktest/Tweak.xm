
//
//  LockLyrics7.xm
//  LockLyrics7
//
//  Created by Pigi Galdi on 13.10.2014.
//  Copyright (c) 2014 Pigi Galdi. All rights reserved.
//
//	Imports.

static BOOL favoritesDone;
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

@interface LPViewController : UIViewController <LPPage>	
@property (nonatomic, retain) LPView *mainView; 		 // Create and istance of LPView.
@end
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

static LPViewController *mainPage;

@interface ExtremityIconController : NSObject <SBIconViewDelegate>
+ (id)sharedInstance;
@end


@implementation ExtremityIconController

+ (id)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

- (void)iconTouchBegan:(id)arg1 {
	[arg1 setHighlighted:YES];
}

- (BOOL)iconShouldAllowTap:(id)arg1 {
	return YES;
}

- (double)iconLabelWidth {
	return [[%c(SBIconController) sharedInstance] iconLabelWidth];
}

- (BOOL)iconViewDisplaysCloseBox:(id)arg1 {
	return NO;
}

- (BOOL)iconViewDisplaysBadges:(id)arg1 {
	return YES;
}

- (void)iconTapped:(SBIconView *)arg1 {
	SBIcon *icon = [arg1 icon];
	// Asos and probably other app locker apps compatibility
	if([icon respondsToSelector:@selector(launchFromLocation:context:)])
		[icon launchFromLocation:0 context:nil];
	else
		[icon launchFromLocation:0];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[arg1 setHighlighted:NO];
	});
	//[[%c(SBIconController) sharedInstance] iconTapped:arg1];
}

@end






static SBIconView *newIconViewForID(NSString *identifier) {
	SBApplication* app;
	if([[%c(SBApplicationController) sharedInstance] respondsToSelector:@selector(applicationWithBundleIdentifier:)])
		app = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:identifier];
	else
		app = [[%c(SBApplicationController) sharedInstance] applicationWithDisplayIdentifier:identifier];
	SBApplicationIcon* icon = [[%c(SBApplicationIcon) alloc] initWithApplication:app];
	SBIconView *iconView = [%c(SBIconView) alloc];
	if([iconView respondsToSelector:@selector(initWithContentType:)])
		iconView = [iconView initWithContentType:0]; // iOS 9
	else
		iconView = [iconView initWithDefaultSize]; // iOS 8-
		iconView.delegate = [%c(ExtremityIconController) sharedInstance];
	[iconView _setIcon:icon animated:YES];
	return iconView;
}


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
	if (favoritesDone == NO) {
	NSArray *appIDs = @[@"com.apple.Music", @"com.apple.MobileSMS", @"com.atebits.Tweetie2", @"com.apple.Maps"];
		int iconsPerPage = 4;
		CGSize iconSize = [%c(SBIconView) defaultIconSize];
		CGFloat appSpacing = ((screenWidth - (iconsPerPage * iconSize.width)) / (iconsPerPage + 1)) * 5;
		CGFloat lastX = 0.f;
		BOOL iconLabelsHidden = NO;


	UIScrollView *appScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, (self.mainView.frame.size.height / 2) - 7.5f, self.view.frame.size.width, iconSize.height + (iconLabelsHidden ? 25.f : 30.f))];

	appScrollView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:appScrollView];

		for(NSString *appID in appIDs) {
		// Add spacing in beginning of loop so it isn't added to the end of the content size
		lastX += 35;
		// Create and add iconalpinealpine

		// Create and add icon
		SBIconView *appIconView = newIconViewForID(appID);
		[appIconView setLabelHidden:iconLabelsHidden];
		appIconView.alpha = 0.f;
		appIconView.frame = CGRectMake(lastX, 0.f, appIconView.frame.size.width, appIconView.frame.size.height);
		appIconView.center = CGPointMake(appIconView.center.x, (appScrollView.frame.size.height / 2) - 7.5f);
		lastX += iconSize.width + iconSize.width / 2;
		[appScrollView addSubview:appIconView];
		appIconView.alpha = 1.0f;
		lastX = lastX - 30;
	}
	appScrollView.contentSize = CGSizeMake(lastX, appScrollView.frame.size.height);
	favoritesDone = YES;

	}
}
@end


%ctor
{
            @autoreleasepool {
             mainPage = [[LPViewController alloc] init];
            [[LPPageController sharedInstance] addPage:mainPage];
    }
   
}