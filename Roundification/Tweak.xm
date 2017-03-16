#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <substrate.h>
#include <mach/mach_time.h>

#define log(z) NSLog(@"[Roundification] %@", z)
//preferences
#define ENABLEDNC ([preferences objectForKey: @"ENABLE_NC"] ? [[preferences objectForKey: @"ENABLE_NC"] boolValue] : YES)
#define SHRINKNC ([preferences objectForKey: @"SHRINKNC"] ? [[preferences objectForKey: @"SHRINKNC"] boolValue] : NO)
#define ENABLEDCC ([preferences objectForKey: @"ENABLE_CC"] ? [[preferences objectForKey: @"ENABLE_CC"] boolValue] : YES)
#define ENABLEDBANNERS ([preferences objectForKey: @"ENABLE_BANNERS"] ? [[preferences objectForKey: @"ENABLE_BANNERS"] boolValue] : YES)
#define ENABLEDDOCK ([preferences objectForKey: @"ENABLE_DOCK"] ? [[preferences objectForKey: @"ENABLE_DOCK"] boolValue] : YES)
#define ENABLE_APP_CARDS ([preferences objectForKey: @"ENABLE_APP_CARDS"] ? [[preferences objectForKey: @"ENABLE_APP_CARDS"] boolValue] : YES)
#define SHOWSTATUS ([preferences objectForKey: @"SHOWSTATUS"] ? [[preferences objectForKey: @"SHOWSTATUS"] boolValue] : NO)
#define ENABLE_UI_ALERT_MENU ([preferences objectForKey: @"ENABLE_UI_ALERT_MENU"] ? [[preferences objectForKey: @"ENABLE_UI_ALERT_MENU"] boolValue] : YES)
#define BANNER_PADDING_SIDE (CGFloat)([preferences objectForKey: @"BANNER_PADDING_SIDE"] ? [[preferences objectForKey: @"BANNER_PADDING_SIDE"] doubleValue] : 20)
#define BANNER_PADDING_TOP (CGFloat)([preferences objectForKey: @"BANNER_PADDING_TOP"] ? [[preferences objectForKey: @"BANNER_PADDING_TOP"] doubleValue] : 25)
#define BANNER_PADDING_BOTTOM (CGFloat)([preferences objectForKey: @"BANNER_PADDING_BOTTOM"] ? [[preferences objectForKey: @"BANNER_PADDING_BOTTOM"] doubleValue] : 40)
#define ENABLE_UI_TEXT_FIELD ([preferences objectForKey: @"ENABLE_UI_TEXT_FIELD"] ? [[preferences objectForKey: @"ENABLE_UI_TEXT_FIELD"] boolValue] : YES)
//#define ENABLE_KB_CELL ([preferences objectForKey: @"ENABLE_KB_CELL"] ? [[preferences objectForKey: @"ENABLE_KB_CELL"] boolValue] : YES)
#define NC_CORNER_RADIUS (CGFloat)([preferences objectForKey: @"NC_CORNER_RADIUS"] ? [[preferences objectForKey: @"NC_CORNER_RADIUS"] doubleValue] : 20)
#define DOCK_CORNER_RADIUS (CGFloat)([preferences objectForKey: @"DOCK_CORNER_RADIUS"] ? [[preferences objectForKey: @"DOCK_CORNER_RADIUS"] doubleValue] : 20)
#define CC_CORNER_RADIUS (CGFloat)([preferences objectForKey: @"CC_CORNER_RADIUS"] ? [[preferences objectForKey: @"CC_CORNER_RADIUS"] doubleValue] : 20)
#define APP_CARD_RADIUS (CGFloat)([preferences objectForKey: @"APP_CARD_RADIUS"] ? [[preferences objectForKey: @"APP_CARD_RADIUS"] doubleValue] : 20)
#define ALERT_MENU_RADIUS (CGFloat)([preferences objectForKey: @"ALERT_MENU_RADIUS"] ? [[preferences objectForKey: @"ALERT_MENU_RADIUS"] doubleValue] : 20)
#define TEXT_CORNER_RADIUS (CGFloat)([preferences objectForKey: @"TEXT_CORNER_RADIUS"] ? [[preferences objectForKey: @"TEXT_CORNER_RADIUS"] doubleValue] : 15)
//#define KBCELL_CORNER_RADIUS (CGFloat)([preferences objectForKey: @"KBCELL_CORNER_RADIUS"] ? [[preferences objectForKey: @"KBCELL_CORNER_RADIUS"] doubleValue] : 15)
#define BANNER_CORNER_RADIUS (CGFloat)([preferences objectForKey: @"BANNER_CORNER_RADIUS"] ? [[preferences objectForKey: @"BANNER_CORNER_RADIUS"] doubleValue] : 15)
#define NC_SHRINK_MULTIPLIER (CGFloat)([preferences objectForKey: @"NC_SHRINK_MULTIPLIER"] ? [[preferences objectForKey: @"NC_SHRINK_MULTIPLIER"] doubleValue] : 5)


#define IS_IOS_8_PLUS() [%c(SBBannerController) instancesRespondToSelector: @selector(_cancelBannerDismissTimers)]

@interface SBWindow : UIView
@end

@interface UIWindowLayer : CALayer
@end

@interface SBDefaultBannerTextView : NSObject
-(void)setSecondaryTextAlpha:(float)alpha;
@end

@interface SBBannerContextView : UIView
-(BOOL)isPulledDown;
@end

@interface SBBannerContainerView : UIView
@end

@interface SBControlCenterRootView : UIView
@end

@interface SBNotificationCenterViewController : UIViewController
@end

@interface UIKeyboardPredictionCell : UIView
@end

@interface SBDockView : UIView
@end

@interface SBControlCenterContentView : NSObject
@property(nonatomic, assign, readwrite) CGRect frame;
-(void)_iPhone_layoutSubviewsInBounds:(CGRect)bounds orientation:(int)orientation;
@end

static NSDictionary *preferences = nil;
//static BOOL _pulledDown = NO;

static void reloadPreferences() {
	if (preferences) {
		[preferences release];
		preferences = nil;
	}
	
	// Use CFPreferences since sometimes the prefs dont synchronize to the disk immediately
	NSArray *keyList = [(NSArray *)CFPreferencesCopyKeyList((CFStringRef)@"com.atrocity.roundification", kCFPreferencesCurrentUser, kCFPreferencesAnyHost) autorelease];
	preferences = (NSDictionary *)CFPreferencesCopyMultiple((CFArrayRef)keyList, (CFStringRef)@"com.atrocity.roundification", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
}

//
//	BANNERS
//
%hook SBBannerContainerView
-(void)layoutSubviews
{
	%orig;
	if(ENABLEDBANNERS){
		SBBannerContextView *banView = MSHookIvar<SBBannerContextView *>(self, "_bannerView");
		banView.layer.cornerRadius = BANNER_CORNER_RADIUS;
		banView.layer.masksToBounds = YES;
		CGFloat BannerWidth = [UIScreen mainScreen].bounds.size.width;
		CGFloat height = self.frame.size.height;

		if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
		{
			BannerWidth = [UIScreen mainScreen].bounds.size.height;
		}	

		[self setFrame:(CGRect){{BANNER_PADDING_SIDE/2,BANNER_PADDING_TOP},{BannerWidth - BANNER_PADDING_SIDE, height}}];

		NSFileManager * fileManager = [NSFileManager defaultManager];
		if([fileManager fileExistsAtPath:@"/var/mobile/Library/Preferences/me.qusic.couria.plist"])
		{
			NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/me.qusic.couria.plist"];
			if([banView isPulledDown] && [[dict objectForKey:@"com.apple.MobileSMS.enabled"] boolValue])
			{
				banView.frame = (CGRect){{banView.frame.origin.x, banView.frame.origin.y},{self.frame.size.width, banView.frame.size.height - BANNER_PADDING_BOTTOM}};
			}
			else
			{
				banView.frame = (CGRect){{banView.frame.origin.x, banView.frame.origin.y},{self.frame.size.width, banView.frame.size.height}};	
			}
		}
		else
		{
			banView.frame = (CGRect){{banView.frame.origin.x, banView.frame.origin.y},{self.frame.size.width, banView.frame.size.height}};	
		}
	

		UIView *backdropView = MSHookIvar<UIView *>(self, "_backgroundView");
		backdropView.alpha = 0.0;
	}
}
%end


//
// Notification Center
//
%hook SBNotificationCenterViewController

-(void)hostWillPresent 
{

	if (ENABLEDNC) {
	  @try {
	  		log(self.view);
	  		self.view.layer.cornerRadius = NC_CORNER_RADIUS;
		    self.view.layer.masksToBounds = YES;


		    CGFloat width = [UIScreen mainScreen].bounds.size.width;
		    CGFloat height = [UIScreen mainScreen].bounds.size.height;
		    self.view.transform = CGAffineTransformIdentity;
			self.view.frame = (CGRect){{0,0},{width, height}};
			    
			if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
			{
			    //Landscape mode	
			    self.view.frame = (CGRect){{0,0},{height, width}};
			}
			
			if(SHRINKNC){
				for (int i = 0; i < NC_SHRINK_MULTIPLIER; ++i)
				{
					if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
					{
					    //Landscape mode	
					    self.view.frame = (CGRect){{0,0},{height, width}};
					}
					else{
						self.view.frame = (CGRect){{0,0},{width, height}};
					}
					self.view.transform = CGAffineTransformScale(self.view.transform, 0.94,0.94);
				}
			}
			else{
				self.view.transform = CGAffineTransformScale(self.view.transform, 0.94,0.94);
			}


		    if (!SHOWSTATUS)
		    {
	    		UIView *statusbar = MSHookIvar<UIView *>(self, "_statusBar");
	    		statusbar.alpha = 0.0;
	    	}

		}
		@catch (NSException *e) {
			NSLog(@"[Roundification] Exception %@",e);
		}
		@finally {}

	}

	%orig;
}
%end

%hook SBNotificationCenterController
-(void)beginPresentationWithTouchLocation:(CGPoint)arg1 {

	%orig(arg1);

    if (ENABLEDNC){
	    UIViewController *ncViewController = MSHookIvar<UIViewController *>(self, "_viewController");
	   	ncViewController.view.layer.cornerRadius = NC_CORNER_RADIUS;
	    ncViewController.view.layer.masksToBounds = YES;


	    CGFloat width = [UIScreen mainScreen].bounds.size.width;
	    CGFloat height = [UIScreen mainScreen].bounds.size.height;
	    ncViewController.view.transform = CGAffineTransformIdentity;
		ncViewController.view.frame = (CGRect){{0,0},{width, height}};
		    
		if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
		{
		    //Landscape mode	
		    ncViewController.view.frame = (CGRect){{0,0},{height, width}};
		}
		
		if(SHRINKNC){
			for (int i = 0; i < NC_SHRINK_MULTIPLIER; ++i)
			{
				if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
				{
				    //Landscape mode	
				    ncViewController.view.frame = (CGRect){{0,0},{height, width}};
				}
				else{
					ncViewController.view.frame = (CGRect){{0,0},{width, height}};
				}
				ncViewController.view.transform = CGAffineTransformScale(ncViewController.view.transform, 0.94,0.94);
			}
		}
		else{
			ncViewController.view.transform = CGAffineTransformScale(ncViewController.view.transform, 0.94,0.94);
		}
		
		


	    if (!SHOWSTATUS)
	    {
    		UIView *statusbar = MSHookIvar<UIView *>(ncViewController, "_statusBar");
    		statusbar.alpha = 0.0;
    	}

	}
}
%end

//
// Control Center
//
%hook SBControlCenterController
-(void)_beginPresentation
{
	%orig;
	if(ENABLEDCC)
	{
		UIViewController *ccViewController = MSHookIvar<UIViewController *>(self, "_viewController");
	    UIView * ccContainerView = MSHookIvar<UIView *>(ccViewController,"_containerView");

	    UIView * ccContentContainerView = MSHookIvar<UIView *>(ccContainerView, "_contentContainerView");
	    ccContentContainerView.layer.cornerRadius = CC_CORNER_RADIUS;
	    ccContentContainerView.layer.masksToBounds = YES;

		UIView * darkView = MSHookIvar<UIView *>(ccContainerView, "_darkeningView");
		darkView.alpha = 0.01;
	}
}
%end

%hook SBControlCenterRootView
-(void)layoutSubviews
{
	%orig;
	
	if (ENABLEDCC)
	{
		CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
		CGFloat CCWidth = screenWidth - 20;
		CGRect fr = self.frame;
		CGFloat xmargin = 10.0;
		CGFloat ymargin = 0.0;
		if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
		{
			ymargin = (screenWidth - CCWidth);
		}	

	    self.frame = (CGRect){{xmargin, ymargin}, {CCWidth, fr.size.height - 10}};
	}
}
%end


//
// App Switcher Cards
//
%hook SBAppSwitcherPageView
-(void)layoutSubviews
{
	%orig;
	if (ENABLE_APP_CARDS)
	{
		UIView * contentView = MSHookIvar<UIView *>(self, "_view");
		contentView.layer.cornerRadius = APP_CARD_RADIUS;
		contentView.layer.masksToBounds = YES;
		UIView * shadow = MSHookIvar<UIView *>(self, "_shadowView");
		shadow.alpha = 0.0;
	}
}
%end

//
// Dock
//
%hook SBDockView
-(void)layoutSubviews
{
	%orig;
	UIView * backgroundView = MSHookIvar<UIView *>(self, "_backgroundView");
	UIView * highLightView = MSHookIvar<UIView *>(self, "_highlightView");
	if(ENABLEDDOCK)
	{
		highLightView.alpha = 0;
		backgroundView.layer.cornerRadius = DOCK_CORNER_RADIUS;
		backgroundView.layer.masksToBounds = YES;
		CGRect frame = backgroundView.frame;
		backgroundView.frame = (CGRect){{10, frame.origin.y},{frame.size.width - 20, frame.size.height}};
	}
}
%end

//
//UIAlerts
//
%hook UIAlertControllerVisualStyleActionSheet
-(CGFloat)backgroundCornerRadius
{
	if(ENABLE_UI_ALERT_MENU)
	{	
		return ALERT_MENU_RADIUS;
	}
	else
	{
		return %orig;
	}
}
%end


//
//UITextField
//
%hook UITextField
-(void)layoutSubviews
{
	%orig;
	if(ENABLE_UI_TEXT_FIELD)
	{
		self.layer.cornerRadius = TEXT_CORNER_RADIUS;
		self.layer.masksToBounds = YES;
	}
}
%end

//
//UIKeyboardPredictionCell
//
// %hook UIKeyboardPredictionCell
// -(id)initWithFrame:(CGRect)frame
// {
// 	id result = %orig(frame);
// 	if(ENABLE_KB_CELL)
// 	{
// 		self.layer.masksToBounds = YES;
// 		self.layer.cornerRadius = KBCELL_CORNER_RADIUS;
// 	}
// 	return result;
// }
// %end


//
// Round Screen Corners
//
// %hook SBWindow
// -(id)_initWithScreen:(id)screen layoutStrategy:(id)strategy debugName:(id)name scene:(id)scene
// {
// 	id result = %orig(screen,strategy,name,scene);
// 	self.layer.cornerRadius = 15;
// 	self.layer.masksToBounds = YES;
// 	return result;
// }
// -(id)initWithFrame:(CGRect)frame
// {
// 	id result = %orig(frame);
// 	self.layer.cornerRadius = 15;
// 	self.layer.masksToBounds = YES;
// 	return result;
// }
// -(id)initWithScreen:(id)screen layoutStrategy:(id)strategy debugName:(id)name scene:(id)scene
// {
// 	id result = %orig(screen,strategy,name,scene);
// 	self.layer.cornerRadius = 15;
// 	self.layer.masksToBounds = YES;
// 	return result;
// }
// -(id)initWithScreen:(id)screen layoutStrategy:(id)strategy debugName:(id)name
// {
// 	id result = %orig(screen,strategy,name);
// 	self.layer.cornerRadius = 15;
// 	self.layer.masksToBounds = YES;
// 	return result;
// }
// -(id)initWithScreen:(id)screen debugName:(id)name scene:(id)scene
// {
// 	id result = %orig(screen,name,scene);
// 	self.layer.cornerRadius = 15;
// 	self.layer.masksToBounds = YES;
// 	return result;
// }
// -(id)initWithScreen:(id)screen debugName:(id)name
// {
// 	id result = %orig(screen,name);
// 	self.layer.cornerRadius = 15;
// 	self.layer.masksToBounds = YES;
// 	return result;
// }
// %end

// %hook UIWindowLayer
// -(void)setFrame:(CGRect)frame
// {
// 	%orig(frame);
// 	self.cornerRadius = 15;
// 	self.masksToBounds = YES;
// }
// %end

static void showTestBanner()
{
	id request = [[[%c(BBBulletinRequest) alloc] init] autorelease];
	[request setTitle: @"Roundification"];

	[request setMessage: @"Preferences saved! You're a superstar."];
	[request setSectionID: @"com.apple.Preferences"];
	[request setDefaultAction: [%c(BBAction) action]];

	id ctrl = [%c(SBBulletinBannerController) sharedInstance];
	if ([ctrl respondsToSelector:@selector(observer:addBulletin:forFeed:)]) {
		[ctrl observer:nil addBulletin:request forFeed:2];
	} else if ([ctrl respondsToSelector:@selector(observer:addBulletin:forFeed:playLightsAndSirens:withReply:)]) {
		[ctrl observer:nil addBulletin:request forFeed:2 playLightsAndSirens:YES withReply:nil];
	}
}

static inline void prefsChanged(CFNotificationCenterRef center,
									void *observer,
									CFStringRef name,
									const void *object,
									CFDictionaryRef userInfo) {

	reloadPreferences();

	//Thanks Alex - https://github.com/alexzielenski/TinyBar/blob/master/tweak/Tweak.xm

	id bctrl = [%c(SBBannerController) sharedInstance];
	// id ctrl = [%c(SBBulletinBannerController) sharedInstance];

	[NSObject cancelPreviousPerformRequestsWithTarget:bctrl selector:@selector(_replaceIntervalElapsed) object:nil];
	[NSObject cancelPreviousPerformRequestsWithTarget:bctrl selector:@selector(_dismissIntervalElapsed) object:nil];

    // Hide previous banner
 	if (IS_IOS_8_PLUS()) {
 		if (![bctrl _bannerContext]) {
 			[bctrl _replaceIntervalElapsed];
 			[bctrl _dismissIntervalElapsed];
	 		showTestBanner();
 		} else {
 			[bctrl _replaceIntervalElapsed];
 			[bctrl _dismissIntervalElapsed];
 			//! This is the hackiest thing i've seen in my life
 			// We need to wait for the bannerContext to go away
 			// before we add another banner. I tried messing with
 			// completion blocks of the banner controller which
 			// resulted in crashes after rapidly showing test banners
 			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
 				// time out after 2 seconds
 				uint64_t start = mach_absolute_time();
 				mach_timebase_info_data_t info;
 				mach_timebase_info(&info);
				while([bctrl _bannerContext] && (CGFloat)(mach_absolute_time() - start) * info.numer / info.denom / pow(10, 9) < 2.0) {
					[[NSRunLoop currentRunLoop] runUntilDate: [NSDate date]];
				}
				dispatch_async(dispatch_get_main_queue(), ^() {
					[bctrl _replaceIntervalElapsed];
					showTestBanner();
				});
			});
 		}

 	} else {
	 	[bctrl _replaceIntervalElapsed];
	 	[bctrl _dismissIntervalElapsed];
	 	showTestBanner();
 	}
}

%ctor {

	
	
	reloadPreferences();

	CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
	CFNotificationCenterAddObserver(center, NULL, &prefsChanged, (CFStringRef)@"com.atrocity.roundification/prefsChanged", NULL, 0);
}