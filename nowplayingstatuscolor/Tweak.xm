#import <UIKit/UIKit.h>
static BOOL kredandwhite;
static BOOL kwhiteandblack;
static BOOL kblackandwhite;
@interface MPUNowPlayingController : NSObject
@property (nonatomic, readonly) double currentElapsed;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly) NSString *nowPlayingAppDisplayID;
-(void)amIPlaying;
@end
@interface UIStatusBar : UIView
@property (nonatomic, retain) UIColor *foregroundColor;
@end
@interface AVAudioSession
-(BOOL)isOtherAudioPlaying;
@end
static BOOL AudioPlaying;
UIStatusBarWindow* StatusBarView;
%hook UIStatusBarWindow
- (id)initWithFrame:(CGRect)arg1 {
	StatusBarView = %orig;
	return StatusBarView;
}
%new
-(BOOL)iAmHidden {
	return AudioPlaying;
}
%end
%hook UIApplication
- (id)init {
	[self performSelector:@selector(hideBar)];
	return %orig;

}
%new
-(void)hideBar {
	dlopen("/System/Library/Frameworks/AVFoundation.framework/libAVFAudio.dylib", RTLD_NOW);
	id AudioSession = [[NSClassFromString(@"AVAudioSession") new] init];
	if ([AudioSession isOtherAudioPlaying]) {
		if (kredandwhite) {
		[[self statusBar] setBackgroundColor:[UIColor redColor]];
		UIStatusBar * myColor = [self statusBar];
		  		myColor.foregroundColor = [UIColor whiteColor];
		  	}
		  	if (kwhiteandblack) {
		  		[[self statusBar] setBackgroundColor:[UIColor whiteColor]];
		UIStatusBar * myColor = [self statusBar];
		  		myColor.foregroundColor = [UIColor blackColor];
		  	}
		  			  	if (kblackandwhite) {
		  		[[self statusBar] setBackgroundColor:[UIColor blackColor]];
		UIStatusBar * myColor = [self statusBar];
		  		myColor.foregroundColor = [UIColor whiteColor];
		  	}
	}
	else {
		[[self statusBar] setBackgroundColor:[UIColor clearColor]];
		UIStatusBar * myColor = [self statusBar];
		  		myColor.foregroundColor = [UIColor whiteColor];
	}
}
%end
static void loadPrefs() {

       NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.atwiiks.nowplayingstatuscolor.plist"];
    if(prefs)
    {
    	kredandwhite = ([prefs objectForKey:@"redandwhite"] ? [[prefs objectForKey:@"redandwhite"] boolValue] : kredandwhite);
    	kwhiteandblack = ([prefs objectForKey:@"whiteandblack"] ? [[prefs objectForKey:@"whiteandblack"] boolValue] : kwhiteandblack);
    	kblackandwhite = ([prefs objectForKey:@"blackandwhite"] ? [[prefs objectForKey:@"blackandwhite"] boolValue] : kblackandwhite);
    	}
    [prefs release];
}

static void settingschanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    loadPrefs();
}
%ctor{

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingschanged, CFSTR("com.atwiiks.nowplayingstatuscolor/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}
%ctor {
	%init;
}