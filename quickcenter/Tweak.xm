#import "headers.h"
#include <spawn.h>
#include <dispatch/dispatch.h>
#import <objc/runtime.h>

#define SCREEN ([UIScreen mainScreen].bounds)
static id wifiController;
static BOOL loadBundleNeeded = YES;
static BOOL isForceNative = NO;

%group AirPortHooks
@interface WiFiNetwork : NSObject
- (NSNumber *)strength;
@end
%hook WiFiNetwork
%new
- (int)bars {
	CGFloat graded = [[self strength] floatValue];
	int bars = (int)ceilf((graded * -1.0f) * -3.0f);
	bars = MAX(1, MIN(bars, 3));
	return bars;
}
%end
%hook APNetworksController
- (void)powerChanged:(id)arg1 {
	return;
}
- (void)updateCurrentNetworkUI {

}
%end
%end

#define PREFS_BUNDLE_ID CFSTR("com.creatix.quickcenter")

static BOOL activateMenu;
static BOOL isEnabled = YES;
static int activationAction = 0;
static CGFloat longPressHoldDuration = 0.5f;
static CGFloat sensitivity = 1.0f;
static CGFloat maxShortcuts = 4.0f;
static BOOL accessInAppEnabled = YES;
static BOOL accessOnLockscreenEnabled = YES;
static BOOL wifiAccessOnLockscreen = YES;

NSUserDefaults *_prefs;
static void reloadPrefsQC() {
	NSLog(@"RELOADING PREFERENCES FOR QUICKCENTER");

	// Synchronize prefs
	//if (!_prefs) _prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.creatix.quickcenter"];
	CFPreferencesAppSynchronize(PREFS_BUNDLE_ID);
	// Get if enabled
	Boolean isEnabledExists = NO;
	Boolean isEnabledRef = CFPreferencesGetAppBooleanValue(CFSTR("Enabled"), PREFS_BUNDLE_ID, &isEnabledExists);
	isEnabled = (isEnabledExists ? isEnabledRef : YES);

	CFPropertyListRef activationActionsRef = CFPreferencesCopyAppValue(CFSTR("activationAction"), PREFS_BUNDLE_ID);
	activationAction = (activationActionsRef ? [(__bridge NSNumber*)activationActionsRef integerValue] : 0);

	CFPropertyListRef longPressHoldDurationRef = CFPreferencesCopyAppValue(CFSTR("longHoldTime"), PREFS_BUNDLE_ID);
	longPressHoldDuration = (longPressHoldDurationRef ? [(__bridge NSNumber*)longPressHoldDurationRef floatValue] : 0.5f);
	//longPressHoldDuration = [_prefs floatForKey:@"longHoldTime"];



	CFPropertyListRef forceSensitivityRef = CFPreferencesCopyAppValue(CFSTR("sensitivity"), PREFS_BUNDLE_ID);
	sensitivity = (forceSensitivityRef ? [(__bridge NSNumber*)forceSensitivityRef floatValue] : 1.0f);

	//forceSensitivity = [_prefs floatForKey:@"sensitivity"];

	CFPropertyListRef maxShortcutsRef = CFPreferencesCopyAppValue(CFSTR("maxShortcuts"), PREFS_BUNDLE_ID);
	maxShortcuts = (maxShortcutsRef ? [(__bridge NSNumber*)maxShortcutsRef floatValue] : 4.0f);

	//maxShortcuts = [_prefs floatForKey:@"maxShortcuts"];

	Boolean accessInAppEnabledExists = NO;
	Boolean accessInAppEnabledRef = CFPreferencesGetAppBooleanValue(CFSTR("inAppAccessEnabled"), PREFS_BUNDLE_ID, &accessInAppEnabledExists);
	accessInAppEnabled = (accessInAppEnabledExists ? accessInAppEnabledRef : YES); 

	//accessInAppEnabled = [_prefs boolForKey:@"inAppAccessEnabled"];

	Boolean accessOnLockscreenEnabledExists = NO;
	Boolean accessOnLockscreenEnabledRef = CFPreferencesGetAppBooleanValue(CFSTR("lockScreenAccessEnabled"), PREFS_BUNDLE_ID, &accessOnLockscreenEnabledExists);
	accessOnLockscreenEnabled = (accessOnLockscreenEnabledExists ? accessOnLockscreenEnabledRef : YES);

	//accessOnLockscreenEnabled = [_prefs boolForKey:@"lockScreenAccessEnabled"];

	//HBLogInfo([NSString stringWithFormat:@"%@", _prefs]);


	Boolean wifiAccessOnLockscreenExists = NO;
	Boolean wifiAccessOnLockscreenRef = CFPreferencesGetAppBooleanValue(CFSTR("wiFiLockAccessEnabled"), PREFS_BUNDLE_ID, &wifiAccessOnLockscreenExists);
	wifiAccessOnLockscreen = (wifiAccessOnLockscreenExists ? wifiAccessOnLockscreenRef : YES);

	//wifiAccessOnLockscreen = [_prefs boolForKey:@"wiFiLockAccessEnabled"];

	SBIconController *controller = [%c(SBIconController) sharedInstance];
	if (!controller.controlCenterFolders) controller.controlCenterFolders = [NSMutableArray new];
	if (controller.controlCenterFolders) {
		for (SBFolderIconView *iconView in controller.controlCenterFolders) {
			if (!isForceNative) [iconView removeAllGestureRecognizers];
			iconView.longPressQC = nil;
			iconView.forcePressQC = nil;
			UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:[iconView superview] action:@selector(handleTap:)];
			[iconView addGestureRecognizer:tapGestureRecognizer];
			UIForceGestureRecognizerQC *forcePress = [[UIForceGestureRecognizerQC alloc] initWithTarget:controller action:@selector(_handleShortcutMenuPeek:)];
			forcePress.minimumPressDuration = 300;
			if (!isForceNative) [iconView addGestureRecognizer:forcePress];
			UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:controller action:@selector(_handleShortcutMenuPeek:)];
			longPress.minimumPressDuration = longPressHoldDuration;
			if (!isForceNative) [iconView addGestureRecognizer:longPress];
			iconView.forcePressQC = forcePress;
			iconView.longPressQC = longPress;
			if (isEnabled == NO) iconView.hidden = YES;
			if (isEnabled == YES) iconView.hidden = NO;
			
			if (activationAction == 0) {
				longPress.enabled = NO;
				forcePress.enabled = YES;
			}
			else if (activationAction == 1) {
				longPress.enabled = YES;
				forcePress.enabled = NO;
			}
			if (isForceNative) [controller viewMap:nil configureIconView: iconView];

		}
	}


}

void setUpWiFiScanning () {
	if (loadBundleNeeded == YES) {
		NSString *fullPath = [NSString stringWithFormat:@"/System/Library/PreferenceBundles/AirPortSettings.bundle"];
		NSBundle *bundle;
		bundle = [NSBundle bundleWithPath:fullPath];
		if ([bundle load]) {
			%init(AirPortHooks);
			loadBundleNeeded = NO;
			wifiController = [%c(APNetworksController) new];
		}
	}
	if (!loadBundleNeeded) {
		if (!wifiController) {
			wifiController = [%c(APNetworksController) new];

		}
		if (wifiController) {
			[wifiController didWake];
			MSHookIvar<BOOL>(wifiController,"_visible") = YES;
			[[%c(WiFiManager) sharedInstance] setShouldScan:YES];
			[[%c(WiFiManager) sharedInstance] _load];
			[[%c(WiFiManager) sharedInstance] loadConfiguration];
			[[%c(WiFiManager) sharedInstance] _loadFavorites];
			[wifiController didWake];
			[wifiController scanForNetworks:nil];
		}
	}
}
void tearDownEverything() {
	if (![[%c(SBWiFiManager) sharedInstance] wiFiEnabled]) {
		[wifiController dealloc];
		wifiController = nil;
	}
}
void tearDownWiFiScanning() {
	if (wifiController) {
		[wifiController stopScanning];
	}
}

@interface NSString (Creatix)
- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end;
@end

@interface NSObject (BNAPrivate)
- (void)resetSettings;
@end

UIColor *semiTrans = [UIColor colorWithRed:255.0f/255.0f
		green:255.0f/255.0f
		 blue:255.0f/255.0f
		alpha:0.5f];
UIColor *selectBlue = [UIColor colorWithRed:0.0f/255.0f
		green:122.0f/255.0f
		 blue:255.0f/255.0f
		alpha:1.0f];
UIColor *redReset = [UIColor colorWithRed:255.0f/255.0f
		green:0.0f/255.0f
		 blue:0.0f/255.0f
		alpha:1.0f];


@implementation NSString (Creatix)
- (NSString*) stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
	NSRange targetRange;
	targetRange.location = startRange.location + startRange.length;
	targetRange.length = [self length] - targetRange.location;   
	NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
	if (endRange.location != NSNotFound) {
	   targetRange.length = endRange.location - targetRange.location;
	   return [self substringWithRange:targetRange];
	}
    }
    return nil;
}
@end

extern "C" void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id unknown, NSDictionary *options);

void hapticVibe(){
	// NSMutableDictionary* VibrationDictionary = [NSMutableDictionary dictionary];
	// NSMutableArray* VibrationArray = [NSMutableArray array ];
	// [VibrationArray addObject:[NSNumber numberWithBool:YES]];
	// [VibrationArray addObject:[NSNumber numberWithInt:50]]; //vibrate for 50ms
	// [VibrationDictionary setObject:VibrationArray forKey:@"VibePattern"];
	// [VibrationDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
	// if (!isForceNative)
	// AudioServicesPlaySystemSoundWithVibration(4095,nil,VibrationDictionary);
}

/* Special Force Touch Gesture Recognizer :) */
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface NSString (UIForceGestureRecognizer)
- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end;
@end

@implementation NSString (UIForceGestureRecognizer)
- (NSString*) stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
	NSRange targetRange;
	targetRange.location = startRange.location + startRange.length;
	targetRange.length = [self length] - targetRange.location;   
	NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
	if (endRange.location != NSNotFound) {
	   targetRange.length = endRange.location - targetRange.location;
	   return [self substringWithRange:targetRange];
	}
    }
    return nil;
}
@end
@interface UIImage (Resize)
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage *)drawImage:(UIImage *)inputImage inRect:(CGRect)frame;
@end
@implementation UIImage (Resize)
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();	
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)drawImage:(UIImage *)inputImage inRect:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    [self drawInRect:CGRectMake(0.0, 0.0, self.size.width, self.size.height)];
    [inputImage drawInRect:frame];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
static BOOL strobing = NO;
@interface UITouch (UIForceGestureRecognizer)
- (CGFloat)getQuality;
- (CGFloat)getRadius;
- (CGFloat)getDensity;
- (int)getX;
- (int)getY;
@end
CGSize defaultCCButtonSize;
@implementation UITouch (UIForceGestureRecognizer)

- (CGFloat)getQuality {
	return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Quality:" andString:@"Density:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}

- (CGFloat)getDensity {
	return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Density:" andString:@"Irregularity:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];	
}

- (CGFloat)getRadius {
	return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"MajorRadius:" andString:@"MinorRadius:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}

- (int)getX {
return [[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"X:" andString:@"Y:"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
}

- (int)getY {
	return [[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Y:" andString:@"Z:"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
}

@end
%hook SBIconView
%new
- (id)testingWiFi {
	return [[%c(WiFiScanner) alloc] init];
}
// %property (nonatomic, retain) NSString *type;
%new
- (NSString*)type {
return nil;
}
%end


static CGFloat Density;
static CGFloat Radius;
static CGFloat Quality;
static int X;
static int Y;

static CGFloat lastDensity;
static CGFloat lastRadius;
static CGFloat lastQuality;
static int lastX;
static int lastY;

BOOL hasIncreasedByPercent(float percent, float value1, float value2) {

    if (value1 <= 0 || value2 <= 0)
	return NO;
    if (value1 >= value2 + (value2 / percent))
	return YES;
    return NO;
}

@implementation UIForceGestureRecognizerQC

- (id)initWithTarget:(id)target action:(SEL)action{
    if ((self = [super initWithTarget:target action:action])){
	// so simple there's no setup
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if (isForceNative) return;
	[super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    Radius = [touch getRadius];
	X = [touch getX];
	Y = [touch getY];
	Density = [touch getDensity];
	Quality = [touch getQuality];
	//touchPoint = CGPointMake( X, Y);
	/* if ([touch _pathMajorRadius] > 40) {
		self.state = UIGestureRecognizerStateBegan;
		MenuOpen = YES;
	} */
	if (hasIncreasedByPercent(15 * sensitivity, Density, lastDensity) && hasIncreasedByPercent(15 *sensitivity, Radius, lastRadius)) {
		self.state = UIGestureRecognizerStateBegan;
		hapticVibe();
    //self.cancelsTouchesInView = YES;
		NSLog(@"Begin Complete");
		//MenuOpen = YES;
	}
	lastRadius = Radius;
	lastX = X;
	lastY = Y;
	lastDensity = Density;
	lastQuality = Quality;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if (isForceNative) return;
	[super touchesMoved:touches withEvent:event];
	UITouch *touch = [touches anyObject];
	Radius = [touch getRadius];
	X = [touch getX];
	Y = [touch getY];
	Density = [touch getDensity];
	Quality = [touch getQuality];
	//touchPoint = CGPointMake( X, Y);
	if (self.state == UIGestureRecognizerStatePossible) { 
		if ((lastX - [touch getX] >= 10 || lastX - [touch getX] <= -10) || (lastY - [touch getY] >= 10 || lastY - [touch getY] <= -10)) {
			self.state = UIGestureRecognizerStateFailed;
			NSLog(@"Too Much Movement");
	}
		else if (hasIncreasedByPercent(15 * sensitivity, Density, lastDensity) && hasIncreasedByPercent(15 * sensitivity, Radius, lastRadius)) {
			self.state = UIGestureRecognizerStateBegan;
			hapticVibe();
      // self.cancelsTouchesInView = YES;
			//MenuOpen = YES;
		}
	}
	if (self.state == UIGestureRecognizerStateChanged) {
		self.state = UIGestureRecognizerStateChanged;
	}
	lastRadius = Radius;
	lastX = X;
	lastY = Y;
	lastDensity = Density;
	lastQuality = Quality;
	//touchPoint = CGPointMake( X, Y);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if (isForceNative) return;
	[super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
    [self reset];
    //MenuOpen = NO;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	if (isForceNative) return;
	[super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
    [self reset];
}

-(void)reset{
	[super reset];
  lastRadius = 0;
  lastX = 0;
  lastY = 0;
  lastDensity = 0;
  lastQuality = 0;
  //touchPoint = CGPointMake( 0, 0);
}
@end

static CameraView *camera;

%hook SBApplicationShortcutMenuContentView
%new
- (UIView *)iconViewHelp {
	return MSHookIvar<UIView *>([[self superview] superview],"_proxyIconViewWrapper");
}
%property (nonatomic, assign) BOOL cameraOnScreen;

%new
- (CGRect)contentViewIconFrame {
	UIView *viewFrame = MSHookIvar<id>([self delegate],"_proxyIconViewWrapper");
	return viewFrame.frame;
}
- (id)initWithInitialFrame:(CGRect)arg1 containerBounds:(CGRect)arg2 orientation:(long long)arg3 shortcutItems:(id)arg4 application:(id)arg5 {
		if (!arg5) {
			CGSize defaultIconSize = [%c(SBIconView) defaultIconImageSize];
			CGRect newFrame = CGRectMake(arg1.origin.x, arg1.origin.y - (defaultIconSize.width - defaultCCButtonSize.width), arg1.size.width, arg1.size.height);
			arg1 = newFrame;
		}

		return %orig(arg1,arg2,arg3,arg4,arg5);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if (self.cameraOnScreen == YES)
	[camera touchesBegan:touches withEvent:event];//movement for camera resizing
	else %orig;
 }

 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if (self.cameraOnScreen == YES) [camera touchesMoved:touches withEvent:event];//movement for camera resizing
	else %orig;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if (self.cameraOnScreen == YES)
	[camera touchesEnded:touches withEvent:event];//movement for camera resizing
	else %orig;
}
%new
- (UILongPressGestureRecognizer *)highlightGesture {
	return MSHookIvar<id>(self,"_pressGestureRecognizer");//disables longpresgesture so our gesturs can be used
}
%end
%hook SBApplicationShortcutMenu
%property (nonatomic, retain) AVCaptureSession *capture;
- (void)_dismissWithDuration:(double)arg1 additionalAnimations:(id)arg2 completion:(id)arg3 {
	%orig;
	if (camera) {
		NSLog(@"Camera View Shutting Down :)");
        [camera.captureSessionHelp stopRunning];// if there is flash set it as auto
	}
}
- (void)_dismissAnimated:(_Bool)arg1 finishPeeking:(_Bool)arg2 ignorePresentState:(_Bool)arg3 completionHandler:(id)arg4 {
	%orig;
	if (camera) {
		NSLog(@"Camera View Shutting Down :)");
        [camera.captureSessionHelp stopRunning];// if there is flash set it as auto
	}
}

- (void)dismissAnimated:(_Bool)arg1 completionHandler:(id)arg2 {
	%orig;
	if (camera) {
		NSLog(@"Camera View Shutting Down :)");
        [camera.captureSessionHelp stopRunning];// if there is flash set it as auto
	}
}
%new
- (CGSize)correctSize {
	float width = SCREEN.size.width * 0.056;
	float height = SCREEN.size.height * 0.02548;
	return CGSizeMake(width, height);
}

- (void)_setupViews {
	%orig;
	if (self.iconView.type) {
		SBIconView *proxyIconView = MSHookIvar<id>(self,"_proxyIconView");
		[proxyIconView setHidden:YES];
		UIView *proxyView = MSHookIvar<id>(self,"_proxyIconViewWrapper");
		if ([[self.iconView superview] isKindOfClass:[%c(SBControlCenterButton) class]] || [[self.iconView superview] isKindOfClass:[%c(PLQuickLaunchButton) class]] || [[self.iconView superview] isKindOfClass:[%c(_FSSwitchButton) class]]) {
			UIImageView *glyphImageView = nil;
			if ([[self.iconView superview] isKindOfClass:[%c(_FSSwitchButton) class]]) {
				glyphImageView = [[UIImageView alloc] initWithImage:[[self.iconView superview] currentImage]];
			}
			else {
				glyphImageView = [[UIImageView alloc] initWithImage:[[self.iconView superview] _glyphImageForState:[[self.iconView superview] state]]];
			}
			glyphImageView.center = [proxyView convertPoint:proxyView.center fromView:proxyView.superview];
			UIImageView *glyphBackgroundView = nil;

			if ([[self.iconView superview] isCircleButton]) {
				glyphBackgroundView = [[UIImageView alloc] initWithImage:[%c(SBUIControlCenterButton) _circleBackgroundImage]];
				glyphBackgroundView.frame = proxyView.bounds;
			}
			if ([[self.iconView superview] isRectButton]) {
				glyphBackgroundView = [[UIImageView alloc] initWithImage:[%c(SBUIControlCenterButton) _roundRectBackgroundImage]];
				glyphBackgroundView.frame = proxyView.bounds;
			}
			if ([[self.iconView superview] _currentState] == 0) {
				UIVisualEffectView *visualEffectView;
				visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
				visualEffectView.frame = proxyView.bounds;
				visualEffectView.clipsToBounds = YES;
				if ([[self.iconView superview] isRectButton]) {
					[visualEffectView.layer setCornerRadius:14];
					[proxyView.layer setCornerRadius:14];
				}
				else {
					[visualEffectView.layer setCornerRadius:visualEffectView.frame.size.width/2];
					[proxyView.layer setCornerRadius:visualEffectView.frame.size.width/2];
				}
				[proxyView addSubview:visualEffectView];
				proxyView.backgroundColor = semiTrans;
			}
			else {
				[proxyView addSubview:glyphBackgroundView];
			}
			[proxyView addSubview:glyphImageView];
		}
	}
}
%new
- (void)cameraViewDidFinishLoading:(CameraView *)camera {//camera delegate
    [UIView animateWithDuration:0.25 animations:^{//calls transition to fade view in
	[camera doneLoading];
	camera.alpha = 1.0;
	if (camera) {
		if (camera.captureSessionHelp) {
			self.capture = camera.captureSessionHelp;
            	//[camera.captureSessionHelp stopRunning];// if there is flash set it as auto
		}
	}
    }];
}
%new
- (void)cameraViewDidTakePhoto:(CameraView*)camera {
}
- (void)presentAnimated:(_Bool)arg1 {
	//if ([[%c(SBControlCenterController) sharedInstance] isVisible]) {
		[self removeFromSuperview];
		UIWindow *window = [self.iconView _window];
		[window addSubview:self];
		//[sbcc.view addSubview:self];
	//}
	%orig;
	if ([self.iconView.type isEqualToString: @"Camera"]) {
			SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(self,"_contentView");
			[contentView highlightGesture].enabled = NO;
			CGRect maxMenuFrame = MSHookIvar<CGRect>(contentView,"_maxMenuFrame");
			camera = [[[CameraView alloc] initWithFrame:CGRectMake(0,0,maxMenuFrame.size.width,maxMenuFrame.size.height)] retain];//adds camera
			camera.delegate = self;
			UIView *proxyView = MSHookIvar<id>(self,"_proxyIconViewWrapper");
			MSHookIvar<CGRect>(camera,"_iconFrame") = proxyView.frame;
			camera.alpha = 0.0;
			[contentView addSubview:camera];
			[camera presentCamera:1];
			contentView.cameraOnScreen = YES;
	}
}
%property (nonatomic, retain) NSString *type;

%new
- (int)maxNumberOfShortcuts {
    NSInteger shortcutHeight = [[%c(SBIconView) defaultIconSize] width];
    //[self.iconView.superview convertPoint:self.iconView.frame.origin toView:nil] - [%c(SBIconView) defaultIconSize].height/2;
    NSInteger currentY = [[self.iconView _iconImageView] convertPoint:CGPointMake(0,0) toView:nil].y;
    int width = [[%c(SBIconView) defaultIconSize] width];
    BOOL isUp = YES;
    if (currentY < SCREEN.size.height/2+20) {
	isUp = NO;
    }
    
    if (isUp == YES) {
	CGFloat sizeToTop = [[self.iconView _iconImageView] convertPoint:CGPointMake(0,0) toView:nil].y - width/4 - width/4;
	int yx = sizeToTop;
	return floor(yx/shortcutHeight);
    } else {

	CGFloat sizeToBottom = SCREEN.size.height - currentY - width/4 - width - width/5;
	int finalNumber = floor(sizeToBottom/shortcutHeight);
	if (finalNumber < 4) finalNumber = 4;
	return finalNumber;
    }
}

- (id)_shortcutItemsToDisplay {
	UIView *proxyView = MSHookIvar<id>(self,"_proxyIconViewWrapper");
	defaultCCButtonSize = proxyView.frame.size;
	int max = [self maxNumberOfShortcuts];

	if (![[UIApplication sharedApplication] _accessibilityFrontMostApplication]) {
		if ([[UIApplication sharedApplication] isLocked]) {
			if ([self.iconView.type isEqualToString:@"WiFi"]) {
				if (!wifiAccessOnLockscreen) return nil;
			}
			else {
				if (!accessOnLockscreenEnabled) return nil;
			}
		}
	}
	else {
		if ([[UIApplication sharedApplication] _accessibilityFrontMostApplication]) {
			if (!accessInAppEnabled) return nil;
		}
	}

	//if (!([[UIApplication sharedApplication] _accessibilityFrontMostApplication]) && (!accessOnLockscreenEnabled) && ([[UIApplication sharedApplication] isLocked]) && (!wifiAccessOnLockscreen)) return nil;
	if ([self.iconView.type isEqualToString:@"WiFi"]) {

		NSMutableArray *networks = [[%c(WiFiManager) sharedInstance] availableNetworks];
		NSMutableArray *shortcuts = [[NSMutableArray alloc] init];
		if (networks) {
			if ([networks count] == 0) {
				setUpWiFiScanning();
				SBSApplicationShortcutItem *nope = [[%c(SBSApplicationShortcutItem) alloc] init];
				[nope setLocalizedTitle:@"No Networks"];
				[nope setType:@"WiFi-Not-Here"];
				[nope setLocalizedTitle:@"Couldn't find any networks"];
				[shortcuts addObject:nope];
				return shortcuts;
			}
			for (id network in networks) {
				if ([shortcuts count] == maxShortcuts) return shortcuts;
				if ([network hidden]) {
					continue;
				}
				UIImage *wifiBars = [[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/System/Library/PreferenceBundles/AirPortSettings.bundle/wifi%d@2x.png", [network bars]]] sbf_resizeImageToSize:[self correctSize]];
				UIImage *lockTemp = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/System/Library/PreferenceBundles/AirPortSettings.bundle/Lock@2x.png"]];
				UIImage *lock = [lockTemp sbf_resizeImageToSize:CGRectMake(0,0, lockTemp.size.width/1.5, lockTemp.size.height/1.5).size];
				UIImage *finalImage = [wifiBars drawImage:lock inRect:CGRectMake(wifiBars.size.width - lock.size.width, wifiBars.size.height - lock.size.height, lock.size.width, lock.size.height)];
				if ([network isSecure] == NO) finalImage = wifiBars;
				SBSApplicationShortcutCustomImageIcon *shortcutIcon = [[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:UIImagePNGRepresentation(finalImage)];
				SBSApplicationShortcutItem *shortcut = [[%c(SBSApplicationShortcutItem) alloc] init];
				[shortcut setLocalizedTitle:[network name]];
				[shortcut setIcon:shortcutIcon];
				[shortcut setType:@"Wifi-Network"];
				NSMutableDictionary *userInfoDict = [NSMutableDictionary new];
				[userInfoDict setObject:[network name] forKey:@"Network"];
				[shortcut setUserInfo:userInfoDict];
				if ([[%c(WiFiManager) sharedInstance] _currentNetwork]) {
					if ([[network name] isEqualToString: [[[%c(WiFiManager) sharedInstance] _currentNetwork] name]]) {
						[shortcut setLocalizedSubtitle:@"Connected"];
					}
					else {
						[shortcut setLocalizedSubtitle:@"Disconnected"];
					}
				}
				[shortcuts addObject:shortcut];
				//[wifiBars release];
			}
		}
		return shortcuts;
	}
	if ([self.iconView.type isEqualToString:@"Bluetooth"]) {
		NSMutableArray *bluetoothDevices = [[%c(BluetoothManager) sharedInstance] pairedDevices];
		NSMutableArray *shortcuts = [[NSMutableArray alloc] init];
		if (bluetoothDevices) {
			if ([bluetoothDevices count] == 0) {
				SBSApplicationShortcutItem *nope = [[%c(SBSApplicationShortcutItem) alloc] init];
				[nope setLocalizedTitle:@"No Devices"];
				[nope setType:@"Bluetooth-Not-Here"];
				[nope setLocalizedTitle:@"Couldn't find any devices"];
				[shortcuts addObject:nope];
				return shortcuts;
			}
			for (id device in bluetoothDevices) {
				if ([shortcuts count] == maxShortcuts) return shortcuts;
				SBSApplicationShortcutCustomImageIcon *shortcutIcon = [[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:UIImagePNGRepresentation([[self.iconView superview] _glyphImageForState:[[self.iconView superview] state]])];
				SBSApplicationShortcutItem *shortcut = [[%c(SBSApplicationShortcutItem) alloc] init];
				[shortcut setLocalizedTitle:[device name]];
				[shortcut setIcon:shortcutIcon];
				[shortcut setType:@"Bluetooth-Device"];
				if ([device connected]) [shortcut setLocalizedSubtitle:@"Connected"];
				else [shortcut setLocalizedSubtitle:@"Disconnected"];
				[shortcuts addObject:shortcut];
			}
		}
		return shortcuts;
	}
	if ([self.iconView.type isEqualToString:@"DnD"]) {
		NSMutableArray *shortcuts = [NSMutableArray new];

		SBSApplicationShortcutItem *alwaysShortcut = [[%c(SBSApplicationShortcutItem) alloc] init];
		[alwaysShortcut setLocalizedTitle:@"Always"];
		[alwaysShortcut setType:@"DnD"];
		NSMutableDictionary *userInfoDict = [NSMutableDictionary new];
		[userInfoDict setObject:[NSString stringWithFormat:@"Always"] forKey:@"Option"];
		[alwaysShortcut setUserInfo:userInfoDict];
		[shortcuts addObject:alwaysShortcut];

		SBSApplicationShortcutItem *whenLockedShortcut = [[%c(SBSApplicationShortcutItem) alloc] init];

		NSMutableDictionary *userInfoDict2 = [NSMutableDictionary new];
		[userInfoDict2 setObject:[NSString stringWithFormat:@"WhenLocked"] forKey:@"Option"];
		[whenLockedShortcut setUserInfo:userInfoDict2];
		[whenLockedShortcut setLocalizedTitle:@"Only When Locked"];
		[whenLockedShortcut setType:@"DnD"];
		[shortcuts addObject:whenLockedShortcut];

		return shortcuts;
	}
	if ([self.iconView.type isEqualToString:@"Camera"]) {
		NSMutableArray *shortcuts = [NSMutableArray new];
		SBSApplicationShortcutItem *shortcut = [[%c(SBSApplicationShortcutItem) alloc] init];
		[shortcut setLocalizedTitle:@"Always"];
		[shortcut setType:@"com.apple.camera.shortcuts.selfie"];
		[shortcuts addObject:shortcut];
		SBSApplicationShortcutItem *shortcut2 = [[%c(SBSApplicationShortcutItem) alloc] init];
		[shortcut2 setLocalizedTitle:@"Only When Locked"];
		[shortcut2 setType:@"Dn"];
		[shortcuts addObject:shortcut2];
		SBSApplicationShortcutItem *shortcut3 = [[%c(SBSApplicationShortcutItem) alloc] init];
		[shortcut3 setLocalizedTitle:@"Only When Locked"];
		[shortcut3 setType:@"Dn"];
		[shortcuts addObject:shortcut3];
		SBSApplicationShortcutItem *shortcut4 = [[%c(SBSApplicationShortcutItem) alloc] init];
		[shortcut4 setLocalizedTitle:@"Only When Locked"];
		[shortcut4 setType:@"Dn"];
		[shortcuts addObject:shortcut4];
		return shortcuts;
	}
	if ([self.iconView.type isEqualToString:@"Alarm"]) {
		NSMutableArray *shortcuts = [NSMutableArray new];
		AlarmManager *manager = [%c(AlarmManager) sharedManager];
		[[%c(NotificationRelay) sharedRelay] refreshManagersForPreferences:YES localNotifications:YES];
		[manager loadAlarms];
		[manager loadScheduledNotifications];
		NSMutableArray *alarms = [manager alarms];
		
		for (Alarm *alarm in alarms) {
			if ([shortcuts count] == maxShortcuts) return shortcuts;
			NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
			[comps setHour:alarm.hour];
			[comps setMinute:alarm.minute];
			NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comps];
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat:@"hh:mm a"];
			NSString* dateString = [formatter stringFromDate:date];
			
			NSString *alarmTitle = alarm.title;
			NSString *alarmID = alarm.alarmID;
			NSMutableDictionary *userInfoDict = [NSMutableDictionary new];
			[userInfoDict setObject: alarmID forKey:@"alarmID"];
			if (alarm.isActive) {
				[userInfoDict setObject:@"On" forKey:@"alarmState"];
			}
			else {
				[userInfoDict setObject:@"Off" forKey:@"alarmState"];
			}
			SBSApplicationShortcutItem *alarmShortcut = [[%c(SBSApplicationShortcutItem) alloc] init];
			[alarmShortcut setLocalizedTitle:alarmTitle];
			[alarmShortcut setLocalizedSubtitle:dateString];
			[alarmShortcut setUserInfo:userInfoDict];
			[alarmShortcut setType:@"com.apple.mobiletimer.alarmCC"];
			[shortcuts addObject:alarmShortcut];
		}
		return shortcuts;
	}
	if ([self.iconView.type isEqualToString:@"Flashlight"]) {
		NSMutableArray *shortcuts = [NSMutableArray new];
		SBSApplicationShortcutItem *flashlight = [[%c(SBSApplicationShortcutItem) alloc] init];
		//[flashlight setLocalizedTitle:@"Find Bob"];
		[flashlight setLocalizedTitle:@"Flashlight"];
		[flashlight setType:@"flashlight-regular"];
		[flashlight setIcon:[[NSClassFromString(@"SBSApplicationShortcutCustomImageIcon") alloc] initWithImagePNGData:UIImagePNGRepresentation([%c(UIImage) imageNamed:@"/Library/Application Support/QuickCenter/Resources.bundle/flashlight"])]];
		[shortcuts addObject:flashlight];
		SBSApplicationShortcutItem *strobe = [[%c(SBSApplicationShortcutItem) alloc] init];
		[strobe setLocalizedTitle:@"Strobe Flashlight"];
		//[strobe setLocalizedSubtitle:@"Blind Stuart :)"];
		[strobe setType:@"flashlight-strobe"];
		[strobe setIcon:[[NSClassFromString(@"SBSApplicationShortcutCustomImageIcon") alloc] initWithImagePNGData:UIImagePNGRepresentation([%c(UIImage) imageNamed:@"/Library/Application Support/QuickCenter/Resources.bundle/strobe"])]];
		[shortcuts addObject:strobe];
		return shortcuts;
	}
	else if ([self.iconView.type isEqualToString:@"CCApp"]) {
		NSMutableArray *shortcuts = [NSMutableArray new];
		SBApplication *app = [[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:self.iconView.CCAppBundleIdentifier];
		if (app) {
			[self setApplication:app];
			[shortcuts addObjectsFromArray:app.staticShortcutItems];
			[shortcuts addObjectsFromArray:app.dynamicShortcutItems];
			return shortcuts;
		}
	}
	else return %orig;
}

- (void)menuContentView:(id)arg1 activateShortcutItem:(SBSApplicationShortcutItem*)arg2 index:(long long)arg3 {
	if ([arg2.type isEqualToString: @"Wifi-Network"]) {
		for (id network in [[%c(WiFiManager) sharedInstance] availableNetworks]) {
			if ([[network name] isEqualToString: [arg2.userInfo objectForKey:@"Network"]]) {
				[[%c(WiFiManager) sharedInstance] joinNetwork:network];
				%orig;
				return;
			}
		}
		%orig;
	}
	if ([arg2.type isEqualToString: @"Bluetooth-Device"]) {
		id selectedDevice = nil;
		NSMutableArray *devices = [[%c(BluetoothManager) sharedInstance] pairedDevices];
		for (id device in devices) {
			if ([arg2.localizedTitle isEqualToString: [device name]]) {
				selectedDevice = device;
				if ([[[%c(BluetoothManager) sharedInstance] connectedDevices] containsObject:selectedDevice]) {
					[selectedDevice disconnect];
					HBLogInfo([NSString stringWithFormat:@"Device Disconnected: %@", [selectedDevice name]]);
				}
				else {
						[[%c(BluetoothManager) sharedInstance] connectDevice:selectedDevice];
						HBLogInfo([NSString stringWithFormat:@"Device Connected: %@", [selectedDevice name]]);
				}
				break;
			}
		}
		%orig;
	}
	if ([arg2.type isEqualToString: @"com.apple.mobiletimer.alarmCC"]) {
		SBApplicationShortcutMenuItemView *itemView = [MSHookIvar<NSMutableArray*>(arg1,"_itemViews") objectAtIndex:arg3];
		if (itemView.alarmSwitchCC) {
			if (itemView.alarmSwitchCC.on) [itemView.alarmSwitchCC setOn:NO animated:YES];
			else [itemView.alarmSwitchCC setOn:YES animated:YES];
			[itemView flipAlarm:itemView.alarmSwitchCC];
			itemView.highlighted = NO;
		}
		return;
	}
	if ([arg2.type isEqualToString: @"DnD"]) {
		SBApplicationShortcutMenuItemView *itemView = [MSHookIvar<NSMutableArray*>(arg1,"_itemViews") objectAtIndex:arg3];
		if (itemView.DnDSwitch.on) [itemView.DnDSwitch setOn:NO animated:YES];
		else [itemView.DnDSwitch setOn:YES animated:YES];
		[itemView flipDnD:itemView.DnDSwitch];
		itemView.highlighted = NO;
		return;
	}
	if ([arg2.type isEqualToString: @"flashlight-strobe"]) {
		if ([[FlashLight sharedInstance] strobing] == NO) {
		[[[FlashLight sharedInstance] retain] strobeOn];
		}
		else if ([[FlashLight sharedInstance] strobing] == YES) [[[FlashLight sharedInstance] retain] strobeOff];
		%orig;
	}
	if ([arg2.type isEqualToString: @"flashlight-regular"]) {
		[[FlashLight sharedInstance] toggleFlashlight];
		%orig;
	}
	else %orig;
}
%end
%hook SBApplicationShortcutMenuItemView
%property (nonatomic, retain) UISwitch *alarmSwitchCC;
%property (nonatomic, retain) UISwitch *DnDSwitch;
///Icon courtesy of Icons8.com
- (void)_setupViewsWithIcon:(UIImage*)icon title:(NSString*)title subtitle:(NSString*)subtitle
{
	%orig;
	if ([self.shortcutItem.type isEqualToString: @"DnD"]) {
		BOOL effectiveWhileUnlocked = [[[NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/BulletinBoard/BehaviorOverrides.plist"] objectForKey:@"effectiveWhileUnlocked"] boolValue];
		UISwitch *onoff = nil;
		if ([[[self superview] superview] superview].frame.origin.x + ([[[self superview] superview] superview].frame.size.width/2) < SCREEN.size.width/2) {
			onoff = [[UISwitch alloc] initWithFrame: CGRectMake(self.frame.size.width + 10,13,52,26)];
		}
		else {
			onoff = [[UISwitch alloc] initWithFrame: CGRectMake(10,13,52,26)];
		}

		onoff.transform = CGAffineTransformMakeScale(0.75, 0.75);
		onoff.tintColor = semiTrans;
		if ([[self.shortcutItem.userInfo objectForKey:@"Option"] isEqualToString: @"Always"]) {
			if (effectiveWhileUnlocked == YES) [onoff setOn:YES animated:NO];
			else [onoff setOn:NO animated:NO];
		}
		else {
			if (effectiveWhileUnlocked == YES) [onoff setOn:NO animated:NO];
			else [onoff setOn:YES animated:NO];
		}
		[onoff addTarget: self action: @selector(flipDnD:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:onoff];
		self.DnDSwitch = onoff;

	}
	if ([self.shortcutItem.type isEqualToString: @"com.apple.mobiletimer.alarmCC"]) {

		UISwitch *onoff = [[UISwitch alloc] initWithFrame: CGRectMake(self.frame.size.width + 10,13,52,26)];
		onoff.transform = CGAffineTransformMakeScale(0.75, 0.75);
		onoff.tintColor = semiTrans;
		if ([[self.shortcutItem.userInfo valueForKey:@"alarmState"] isEqualToString: @"On"]) {
			[onoff setOn:YES animated:NO];
		}
		else {
			[onoff setOn:NO animated:NO];
		}
		[onoff addTarget: self action: @selector(flipAlarm:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:onoff];
		onoff.tintColor = semiTrans;
		self.alarmSwitchCC = onoff;
	}
}
%new
- (void)flipAlarm:(UISwitch *)sender {
	AlarmManager *manager = [%c(AlarmManager) sharedManager];
	if (sender.on) {
		[manager setAlarm:[manager alarmWithId:[self.shortcutItem.userInfo valueForKey:@"alarmID"]] active:YES];
		[manager updateAlarm:[manager alarmWithId:[self.shortcutItem.userInfo valueForKey:@"alarmID"]] active:YES];
		//Switched on

	}
	else  {
		// Switched Off
		[[manager alarmWithId:[self.shortcutItem.userInfo valueForKey:@"alarmID"]] cancelNotifications];
	}  
	[[%c(NotificationRelay) sharedRelay] refreshManagersForPreferences:YES localNotifications:YES];
}
%new
- (void)flipDnD:(UISwitch *)sender {
	SBIconController *iconController = [objc_getClass("SBIconController") sharedInstance];
	SBApplicationShortcutMenu *menu = MSHookIvar<SBApplicationShortcutMenu *>(iconController,"_presentedShortcutMenu");
	SBApplicationShortcutMenuContentView *contentView = MSHookIvar<SBApplicationShortcutMenuContentView *>(menu,"_contentView");
	if (contentView) {
		NSMutableArray *itemViews = MSHookIvar<NSMutableArray*>(contentView,"_itemViews");
		BOOL effectiveWhileUnlocked = [[[NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/BulletinBoard/BehaviorOverrides.plist"] objectForKey:@"effectiveWhileUnlocked"] boolValue];
		for (SBApplicationShortcutMenuItemView *itemView in itemViews) {
			if (itemView == self) {
					id doNotDisturbManager = [%c(PBBGatewayManager) sharedManager];
					id doNotDisturbHelper = MSHookIvar<id>( doNotDisturbManager,"_settingsGateway");
					if (effectiveWhileUnlocked == YES) {
						[doNotDisturbHelper setBehaviorOverridesEffectiveWhileUnlocked:NO];
					}
					else {
						[doNotDisturbHelper setBehaviorOverridesEffectiveWhileUnlocked:YES];
					}
			}
			else {
				if ([sender isOn] == YES) {
					if (itemView.DnDSwitch) {
						[itemView.DnDSwitch setOn:NO animated:YES];
					}
				}
				else {
					if (itemView.DnDSwitch) {
						[itemView.DnDSwitch setOn:YES animated:YES];
					}
				}
			}
		}
	}
}
- (void)layoutSubviews {
	%orig;
	//if ([[[[self superview] superview] superview] isKindOfClass:NSClassFromString(@"SBApplicationShortcutMenuContentView")]) {
		UIView *iconViewSuperview = [self superview];
		while (![iconViewSuperview respondsToSelector:@selector(iconViewHelp)]) {
			iconViewSuperview = [iconViewSuperview superview];
		}

	UIView *iconView = [iconViewSuperview iconViewHelp];
	if ([self.shortcutItem.type isEqualToString: @"com.apple.mobiletimer.alarmCC"]) {
		if (self.alarmSwitchCC) {
			if (iconView.center.x < SCREEN.size.width/2) {
				self.alarmSwitchCC.frame =  CGRectMake(self.frame.size.width - self.alarmSwitchCC.frame.size.width,16,52,26);
			}
			else {
				self.alarmSwitchCC.frame = CGRectMake(10,16,52,26);
			}
			//self.alarmSwitchCC.frame = CGRectMake(self.frame.size.width - self.alarmSwitchCC.frame.size.width,((self.frame.size.height - self.alarmSwitchCC.frame.size.height)/2) *1.25 ,self.alarmSwitchCC.frame.size.width,self.alarmSwitchCC.frame.size.height);
		}
	}
	if ([self.shortcutItem.type isEqualToString: @"DnD"]) {
		if (self.DnDSwitch) {
			if (iconView.center.x < SCREEN.size.width/2) {
				self.DnDSwitch.frame =  CGRectMake(self.frame.size.width - self.DnDSwitch.frame.size.width,16,52,26);
			}
			else {
				self.DnDSwitch.frame = CGRectMake(10,16,52,26);
			}
			//self.DnDSwitch.frame = CGRectMake(self.frame.size.width - self.alarmSwitchCC.frame.size.width,((self.frame.size.height - self.alarmSwitchCC.frame.size.height)/2) *1.25 ,self.alarmSwitchCC.frame.size.width,self.alarmSwitchCC.frame.size.height);
		}
	}
//}
}
%end

%hook SBControlCenterButton
%property (nonatomic, retain) SBFolderIconView *helpIconView;
%property (nonatomic, retain) SBApplicationShortcutMenu *shortcut;

- (void)setFrame:(CGRect)agr1 {
	%orig;
	if (self.helpIconView) {
		self.helpIconView.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
	}
}
%new
- (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

%new
- (BOOL)is6S {
	isForceNative = ([[[self platform] substringToIndex: 7] isEqualToString:@"iPhone8"]);
    return ([[[self platform] substringToIndex: 7] isEqualToString:@"iPhone8"]);
}
%new
- (void)add3DTouchHelpers {
	SBFolderIconView *iconView = [[%c(SBFolderIconView) alloc] initWithFrame:self.frame];
	[iconView setIcon:[[%c(SBFolderIcon) alloc] init]];
	self.helpIconView = iconView;
	[self addSubview:self.helpIconView];
	[[self.helpIconView _folderIconImageView] setHidden:YES];
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[iconView addGestureRecognizer:tapGestureRecognizer];
	iconView.frame = self.frame;
	SBIconController *iconController = [objc_getClass("SBIconController") sharedInstance];
	if (!iconController.controlCenterFolders) iconController.controlCenterFolders = [NSMutableArray new];
	[iconController viewMap:nil configureIconView: self.helpIconView];
	if ([self is6S] == NO) {
		//UIForceGestureRecognizer *forcePress = [[UIForceGestureRecognizer alloc] initWithTarget:iconController action:@selector(_handleShortcutMenuPeek:)];
		//forcePress.minimumPressDuration = 300;
		///[iconView addGestureRecognizer:forcePress];
		///UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:iconController action:@selector(_handleShortcutMenuPeek:)];
		//forcePress.minimumPressDuration = longPressHoldDuration;
		//[iconView addGestureRecognizer:longPress];
		//self.helpIconView.forcePressQC = forcePress;
		//self.helpIconView.longPressQC = longPress;
		/*if (activationAction == 0) {
			self.helpIconView.longPressQC.enabled = NO;
			self.helpIconView.forcePressQC.enabled = YES;
		}
		else if (activationAction == 1) {
			self.helpIconView.longPressQC.enabled = YES;
			self.helpIconView.forcePressQC.enabled = NO;
		} */
	}
	if (!isEnabled) {
		self.helpIconView.hidden = YES;
	}
	[iconController.controlCenterFolders addObject:self.helpIconView];
	[tapGestureRecognizer release];
}
- (void)setIdentifier:(id)arg1 {
	%orig;
	if ([arg1 isEqualToString: @"wifi"]) {
		[self add3DTouchHelpers];
		if ([[%c(SBWiFiManager) sharedInstance] wiFiEnabled]) {
		setUpWiFiScanning();
		tearDownWiFiScanning();
		}
		self.helpIconView.type = [NSString stringWithFormat:@"WiFi"];
	}
	if ([arg1 isEqualToString: @"bluetooth"]) {
		[self add3DTouchHelpers];
		self.helpIconView.type = [NSString stringWithFormat:@"Bluetooth"];
	}
	if ([arg1 isEqualToString: @"doNotDisturb"]) {
		[self add3DTouchHelpers];
		self.helpIconView.type = [NSString stringWithFormat:@"DnD"];
	}
	if ([arg1 isEqualToString: @"com.apple.camera"]) {
		[self add3DTouchHelpers];
		[self.helpIconView setType:[NSString stringWithFormat:@"Camera"]];
	}
	if ([arg1 isEqualToString: @"com.apple.mobiletimer"]) {
		[self add3DTouchHelpers];
		[self.helpIconView setType:[NSString stringWithFormat:@"Alarm"]];
	}
	if ([arg1 isEqualToString: @"flashlight"]) {
		[self add3DTouchHelpers];
		[self.helpIconView setType:[NSString stringWithFormat:@"Flashlight"]];
	}
	//id obj = [self.helpIconView testingWiFi];
	//HBLogInfo([NSString stringWithFormat:@"%@", obj]);
}
%new
- (void)handleTap:(UITapGestureRecognizer*)sender {
	if (sender.state == UIGestureRecognizerStateEnded) {
		[self _pressAction];
	}
}
%end

/* Polus Support for Adding Gesture and types to toggles */

@interface PLQuickLaunchButton : UIView
@property (nonatomic, retain) SBFolderIconView *helpIconView;
@end

%hook PLQuickLaunchButton
%property (nonatomic, retain) SBFolderIconView *helpIconView;

- (void)setFrame:(CGRect)agr1 {
	%orig;
	if (self.helpIconView) {
		self.helpIconView.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
	}
}

%new
- (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
%new
- (BOOL)is6S {
	isForceNative = ([[[self platform] substringToIndex: 7] isEqualToString:@"iPhone8"]);
    return ([[[self platform] substringToIndex: 7] isEqualToString:@"iPhone8"]);
}
%new
- (void)add3DTouchHelpers {
	SBFolderIconView *iconView = [[%c(SBFolderIconView) alloc] initWithFrame:self.frame];
	[iconView setIcon:[[%c(SBFolderIcon) alloc] init]];
	self.helpIconView = iconView;
	[self addSubview:self.helpIconView];
	[[self.helpIconView _folderIconImageView] setHidden:YES];
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[iconView addGestureRecognizer:tapGestureRecognizer];
	iconView.frame = self.frame;
	SBIconController *iconController = [objc_getClass("SBIconController") sharedInstance];
	if (!iconController.controlCenterFolders) iconController.controlCenterFolders = [NSMutableArray new];
	[iconController viewMap:nil configureIconView: self.helpIconView];
	if ([self is6S] == NO) {
		/*UIForceGestureRecognizer *forcePress = [[UIForceGestureRecognizer alloc] initWithTarget:iconController action:@selector(_handleShortcutMenuPeek:)];
		forcePress.minimumPressDuration = 300;
		[iconView addGestureRecognizer:forcePress];
		UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:iconController action:@selector(_handleShortcutMenuPeek:)];
		forcePress.minimumPressDuration = longPressHoldDuration;
		[iconView addGestureRecognizer:longPress];
		self.helpIconView.forcePressQC = forcePress;
		self.helpIconView.longPressQC = longPress;
		if (activationAction == 0) {
			self.helpIconView.longPressQC.enabled = NO;
			self.helpIconView.forcePressQC.enabled = YES;
		}
		else if (activationAction == 1) {
			self.helpIconView.longPressQC.enabled = YES;
			self.helpIconView.forcePressQC.enabled = NO;
		} */
	}
	if (!isEnabled) {
		self.helpIconView.hidden = YES;
	}
	[iconController.controlCenterFolders addObject:self.helpIconView];
	[tapGestureRecognizer release];
}
- (BOOL)setBundleIdentifier:(NSString*)arg1 {
	if ([arg1 isEqualToString: @"fs-com.a3tweaks.switch.wifi"]) {
		[self add3DTouchHelpers];
		if ([[%c(SBWiFiManager) sharedInstance] wiFiEnabled]) {
		setUpWiFiScanning();
		tearDownWiFiScanning();
		}
		self.helpIconView.type = [NSString stringWithFormat:@"WiFi"];
	}
	if ([arg1 isEqualToString: @"fs-com.a3tweaks.switch.do-not-disturb"]) {
		[self add3DTouchHelpers];
		self.helpIconView.type = [NSString stringWithFormat:@"DnD"];
	}
	if ([arg1 isEqualToString: @"fs-com.a3tweaks.switch.flashlight"]) {
		[self add3DTouchHelpers];
		[self.helpIconView setType:[NSString stringWithFormat:@"Flashlight"]];
	}
	if ([arg1 isEqualToString: @"com.apple.camera"]) {
		[self add3DTouchHelpers];
		[self.helpIconView setType:[NSString stringWithFormat:@"Camera"]];
	}
	if ([arg1 isEqualToString: @"com.apple.mobiletimer"]) {
		[self add3DTouchHelpers];
		[self.helpIconView setType:[NSString stringWithFormat:@"Alarm"]];
	}
	if ([arg1 isEqualToString: @"fs-com.a3tweaks.switch.bluetooth"]) {
		[self add3DTouchHelpers];
		self.helpIconView.type = [NSString stringWithFormat:@"Bluetooth"];
	}
	if (!self.helpIconView) {
		SBApplication *app = [[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:arg1];
		if (app) {
			if ([app.dynamicShortcutItems count] > 0 || [app.staticShortcutItems count] > 0) {
				[self add3DTouchHelpers];
				[self.helpIconView setType:[NSString stringWithFormat:@"CCApp"]];
				[self.helpIconView setCCAppBundleIdentifier:arg1];
			}
		}
	}
	return %orig;
}

%new
- (void)handleTap:(UITapGestureRecognizer*)sender {
	/* Purposeful Crashing */
	/* End Purposeful Crashing */
	if (sender.state == UIGestureRecognizerStateEnded) {
		if ([self isKindOfClass:[%c(PLFlipswitchButton) class]]) {
			[self toggleSwitch];
		}
		else {
			[self tapped];
		}
	}
}
%end

/* End Polus Support */

/* Being FlipControlCenterSupport */
@interface _FSSwitchButton : UIButton
@property (nonatomic, retain) SBFolderIconView *helpIconView;
@end
%hook _FSSwitchButton
%property (nonatomic, retain) SBFolderIconView *helpIconView;
%new
- (id)_glyphImageForState:(int)arg1 {
	return [self currentImage];
}
- (void)setFrame:(CGRect)agr1 {
	%orig;
	if (self.helpIconView) {
		self.helpIconView.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
	}
}
%new
- (BOOL)isCircleButton {
	if ([[[[[self superview] superview] _viewDelegate] sectionIdentifier] isEqualToString: @"com.apple.controlcenter.settings"]) {
		return TRUE;
	}
	else return FALSE;
}
%new
- (BOOL)isRectButton {
	if ([[[[[self superview] superview] _viewDelegate] sectionIdentifier] isEqualToString: @"com.apple.controlcenter.quick-launch"]) {
		return TRUE;
	}
	else return FALSE;
}
%new
- (int)_currentState {
	if ([[self accessibilityValue] isEqualToString: @"On"]) {
		return 1;
	}
	else return 0;
}
%new
- (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
%new
- (BOOL)is6S {
	isForceNative = ([[[self platform] substringToIndex: 7] isEqualToString:@"iPhone8"]);
    return ([[[self platform] substringToIndex: 7] isEqualToString:@"iPhone8"]);
}
%new
- (void)add3DTouchHelpers {
	SBFolderIconView *iconView = [[%c(SBFolderIconView) alloc] initWithFrame:self.frame];
	[iconView setIcon:[[%c(SBFolderIcon) alloc] init]];
	self.helpIconView = iconView;
	[self addSubview:self.helpIconView];
	[[self.helpIconView _folderIconImageView] setHidden:YES];
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[iconView addGestureRecognizer:tapGestureRecognizer];
	iconView.frame = self.frame;
	SBIconController *iconController = [objc_getClass("SBIconController") sharedInstance];
	if (!iconController.controlCenterFolders) iconController.controlCenterFolders = [NSMutableArray new];
	[iconController viewMap:nil configureIconView: self.helpIconView];
	if ([self is6S] == NO) {
		/*UIForceGestureRecognizer *forcePress = [[UIForceGestureRecognizer alloc] initWithTarget:iconController action:@selector(_handleShortcutMenuPeek:)];
		forcePress.minimumPressDuration = 300;
		[iconView addGestureRecognizer:forcePress];
		UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:iconController action:@selector(_handleShortcutMenuPeek:)];
		forcePress.minimumPressDuration = longPressHoldDuration;
		[iconView addGestureRecognizer:longPress];
		self.helpIconView.forcePressQC = forcePress;
		self.helpIconView.longPressQC = longPress;
		if (activationAction == 0) {
			self.helpIconView.longPressQC.enabled = NO;
			self.helpIconView.forcePressQC.enabled = YES;
		}
		else if (activationAction == 1) {
			self.helpIconView.longPressQC.enabled = YES;
			self.helpIconView.forcePressQC.enabled = NO;
		} */
	}
	if (!isEnabled) {
		self.helpIconView.hidden = YES;
	}
	[iconController.controlCenterFolders addObject:self.helpIconView];
	[tapGestureRecognizer release];
}

- (id)initWithSwitchIdentifier:(NSString *)arg1 template:(id)arg2 {
	self = %orig;
	if ([arg1 isEqualToString: @"com.a3tweaks.switch.wifi"]) {
		[self add3DTouchHelpers];
		if ([[%c(SBWiFiManager) sharedInstance] wiFiEnabled]) {
		setUpWiFiScanning();
		tearDownWiFiScanning();
		}
		self.helpIconView.type = [NSString stringWithFormat:@"WiFi"];
	}
	if ([arg1 isEqualToString: @"com.a3tweaks.switch.do-not-disturb"]) {
		[self add3DTouchHelpers];
		self.helpIconView.type = [NSString stringWithFormat:@"DnD"];
	}
	if ([arg1 isEqualToString: @"com.a3tweaks.switch.flashlight"]) {
		[self add3DTouchHelpers];
		[self.helpIconView setType:[NSString stringWithFormat:@"Flashlight"]];
	}
	if ([arg1 isEqualToString: @"com.rpetrich.flipcontrolcenter.camera"]) {
		[self add3DTouchHelpers];
		[self.helpIconView setType:[NSString stringWithFormat:@"Camera"]];
	}
	if ([arg1 isEqualToString: @"com.rpetrich.flipcontrolcenter.clock"]) {
		[self add3DTouchHelpers];
		[self.helpIconView setType:[NSString stringWithFormat:@"Alarm"]];
	}
	if ([arg1 isEqualToString: @"com.a3tweaks.switch.bluetooth"]) {
		[self add3DTouchHelpers];
		self.helpIconView.type = [NSString stringWithFormat:@"Bluetooth"];
	}
	if (!self.helpIconView) {
		SBApplication *app = [[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:arg1];
		if (app) {
			if ([app.dynamicShortcutItems count] > 0 || [app.staticShortcutItems count] > 0) {
				[self add3DTouchHelpers];
				[self.helpIconView setType:[NSString stringWithFormat:@"CCApp"]];
				[self.helpIconView setCCAppBundleIdentifier:arg1];
			}
		}
	}
	return self;
}

%new
- (void)handleTap:(UITapGestureRecognizer*)sender {
	/* Purposeful Crashing */
	/* End Purposeful Crashing */
	if (sender.state == UIGestureRecognizerStateEnded) {
		[self _pressed];
	}
}
%end

%hook SBCCFlashlightSetting
- (id)init {
	self = %orig;
	[[[FlashLight sharedInstance] retain] setFlashlight:self];
	return self;
}
%end
%hook SBApplicationIcon
%new
- (id)webClip {
	return nil;
}
%end
%hook SBFolderIcon
- (_Bool)isBookmarkIcon {
	return YES;
}
%new
- (id)matchedWebApplication {
	return [[%c(SBWebApplication) alloc] init];
}
%end
%hook _SBAnimatableCorneredView
%new
- (void)updateReflection {

}
%end
%hook STKEmptyIcon
%new
- (id)matchedWebApplication {
	return nil;
}
%end
%hook SBControlCenterController
- (void)_endPresentation {
	%orig;
	//reloadPrefsQC();
	if ([[%c(SBWiFiManager) sharedInstance] wiFiEnabled])
	tearDownWiFiScanning();
}
- (void)beginPresentationWithTouchLocation:(CGPoint)arg1 presentationBegunHandler:(id)arg2 {
	%orig;
	if ([[%c(SBWiFiManager) sharedInstance] wiFiEnabled])
	setUpWiFiScanning();
}
- (void)setWiFiEnabled:(BOOL)arg1 {
	%orig;
	if (!arg1) {
		tearDownEverything();
	}
}

%end
%hook SBControlCenterViewController
- (void)setPresented:(BOOL)arg1 {
	reloadPrefsQC();
	%orig;
}
%end
%hook SBIconController
%property (nonatomic, retain) NSMutableArray *controlCenterFolders;
- (BOOL)canRevealShortcutMenu {
	return YES;
}
- (BOOL)_canRevealShortcutMenu {
	return YES;
}
- (void)_revealMenuForIconView:(id)arg1 presentImmediately:(_Bool)arg2 {
		if (!isForceNative)
		%orig(arg1, YES);
		else %orig;
}
- (void)_revealMenuForIconView:(id)arg1 {
		if (!isForceNative) {
			%orig;
			[[self presentedShortcutMenu] presentAnimated:YES];
		}
		else %orig;
}
%end

%hook SBFolderIconView
%property (nonatomic, retain) UIForceGestureRecognizerQC *forcePressQC;
%property (nonatomic, retain) UILongPressGestureRecognizer *longPressQC;
%property (nonatomic, retain) NSString *type;
%property (nonatomic, retain) NSString *CCAppBundleIdentifier;

%new
- (void)reloadPreferences {
	reloadPrefsQC();
}
/* - (void)addGestureRecognizer:(UIGestureRecognizer *)gesture {
	BOOL here = NO;
	for (id gesture2 in [self _gestureRecognizers]) {
		if ([gesture2 isKindOfClass:[gesture class]]) {
			here = YES;
		}
	}
	if (!here) {
		%orig;
	}
	else return;
} */
%new
- (void)testingUgh {
		self.type = @"YAY";
}
%new
- (BOOL)loadBundleNeeded {
NSString *fullPath = [NSString stringWithFormat:@"/System/Library/PreferenceBundles/AirPortSettings.bundle"];
NSBundle *bundle;
bundle = [NSBundle bundleWithPath:fullPath];
return [bundle load];
}

%end

%hook BBSettingsGateway
%new
- (void)testing {
	[self getBehaviorOverridesEffectiveWhileUnlockedWithCompletion:nil];
}

- (void)getBehaviorOverridesEffectiveWhileUnlockedWithCompletion:(id)arg1 {
	%orig;
	HBLogInfo([NSString stringWithFormat:@"%@", arg1]);
}

%end

#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
/* Settings Hooks */
%group Settings

%hook PSTableCell
%new
-(id)tableValue {
	return [self value];
}
%end
@interface ACUIAppInstallCell : PSTableCell
@end
%hook ACUIAppInstallCell
/*- (id)_createInstallButton {
	if ([[self.specifier objectForKey:@"Custom"] boolValue] == YES) {
		UIView *test = %orig;
		[test setTitle:@"PURCHASED"];
		return test;
	}
	else {
		%orig;
	}
}*/
- (void)_updateInstallButtonWithState:(int)arg1 {
	if ([[self.specifier propertyForKey:@"Custom"] boolValue] == YES) {
		%orig;
	}
	else {
		%orig;
	}
}
- (void)_updateSubviewsWithInstallState:(int)arg1 {
	if ([[self.specifier propertyForKey:@"Custom"] boolValue] == YES) {
		%orig;
		UIView *test = MSHookIvar<UIView*>(self,"_installButton");
		[[test retain] setTitle:[self.specifier propertyForKey:@"CustomTitle"]];
		//[test setTitleStyle:1];
		if ([[self.specifier propertyForKey:@"ResetButton"] boolValue] == YES) {
			[test addTarget:self action:@selector(_buttonAction:) forControlEvents:131072];
			[test addTarget:self action:@selector(_cancelConfirmationAction:) forControlEvents:65536];
			[test addTarget:self action:@selector(_showConfirmationAction:) forControlEvents:262144];
			[test setConfirmationTitle:[self.specifier propertyForKey:@"CustomConfirmation"]];
			[test setShowsConfirmationState:YES];
			[test setEnabled:YES];
			[test layoutSubviews];
			//UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] retain];
			//if (![[test gestureRecognizers] count] == 1) {
				//[test addGestureRecognizer:tap];
			//}
			[test setInteractionTintColor:selectBlue];
			MSHookIvar<UIColor*>(test,"_confirmationColor") = redReset;
		}
	}
	else {
		%orig;
	}
}
%new
- (void)_buttonAction:(id)arg1 {
  ///NSLog(@"Confirm Test SUCCEDED TWICE YAYA");
  // if ([[self cellTarget] resetSettings])
  [arg1 setShowingConfirmation:NO animated:YES];

}
%new
- (void)_cancelConfirmationAction:(id)arg1 {
  [arg1 setShowingConfirmation:NO animated:YES];
}
%new
- (void)_showConfirmationAction:(id)arg1 {
  [arg1 setShowingConfirmation:YES animated:YES];
}
%new
- (void)testing123:(id)button {
	[button setShowingConfirmation:YES animated:YES];
}

%new
- (void)handleTap:(UITapGestureRecognizer *)sender {
	if (sender) {
		if (sender.state == UIGestureRecognizerStateEnded) {
			if (sender.view) {
				if ([[sender.view isShowingConfirmation] boolValue] == NO) {
					[sender.view setShowingConfirmation:YES animated:YES];
					//UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] retain];
					//[sender.view addGestureRecognizer:tap];
					//[sender setEnabled:NO];

				}
			}
		}
	}
}
%end
@interface AXForceTouchSensitivitySliderCell : PSTableCell
@end
%hook AXForceTouchSensitivitySliderCell
%new
- (CGFloat)preferredHeightForWidth:(CGFloat)width {
	// Return a custom cell height.
	return 71.5f;
}
%end

%hook AXEditableTableCellWithStepper
- (void)_updateSecondsLabel {
	if ([[[self specifier] propertyForKey:@"custom"] boolValue] == YES) {
		[[self secondsLabel] _setText:[[self specifier] propertyForKey:@"customLabel"]];
		[[self secondsLabel] sizeToFit];
	}
	else %orig;
}
- (void)_updateValue:(CGFloat)arg1 andText:(BOOL)arg2 {
	if ([[[self specifier] propertyForKey:@"custom"] boolValue] == YES) {
		[[self secondsLabel] _setText:[[self specifier] propertyForKey:@"customLabel"]];
		[[self secondsLabel] sizeToFit];
		int rounded = (arg1 + 0.5);
		arg1 = (float)rounded;
	}
	%orig(arg1, arg2);
}
%new
- (void)testing123 {
	if ([[[self specifier] propertyForKey:@"custom"] boolValue] == YES) {
		[[self secondsLabel] _setText:[[self specifier] propertyForKey:@"customLabel"]];
	}
}
- (void)setSecondsLabel:(UILabel *)label {
	if ([[[self specifier] propertyForKey:@"custom"] boolValue] == YES) {
		[label _setText:[[self specifier] propertyForKey:@"customLabel"]];
		[[self secondsLabel] sizeToFit];
	}
	%orig;
}
- (UILabel*)secondsLabel {
	if ([[[self specifier] propertyForKey:@"custom"] boolValue] == YES) {
		[%orig _setText:[[self specifier] propertyForKey:@"customLabel"]];
	}
	return %orig;
}
- (void)layoutSubviews {
	%orig;
	if ([[[self specifier] propertyForKey:@"custom"] boolValue] == YES) {
		[[self secondsLabel] _setText:[[self specifier] propertyForKey:@"customLabel"]];
		[[self secondsLabel] sizeToFit];
	}
}
%new
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([[[self specifier] propertyForKey:@"custom"] boolValue] == YES) {
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""];
	}
	else return YES;
}
%end
%hook PSViewController
%new
-(void)heart {
	if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
	SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
	
	[composeController setInitialText:@"I love #QuickCenter by Creatix"];
	
	[self presentViewController:composeController animated:YES completion:nil];
	
	SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
	    [composeController dismissViewControllerAnimated:YES completion:nil];
	};
	composeController.completionHandler = myBlock;
    }
}
%end
%end

%hook NSMutableArray
- (void)insertObject:(id)arg1 atIndex:(long long)arg2 {
	if (arg1 == nil) return;
	else %orig;
}
%end
%hook MNAFakeApplication
%new
-(void)setFlag:(id)arg1 forActivationSetting:(unsigned int)arg2 {

}
%new
-(void)setObject:(id)arg1 forActivationSetting:(unsigned int)arg2 {

}
+ (id)initWithFolder:(id*)arg1 {

    self = %orig;

    object_setClass(self, [%c(SBApplication) class]);
    return self;
}
%new
- (id)copyActivationSettings {
	return nil;
}
%new
- (long long)flagForActivationSetting:(unsigned int)arg1 {
	return 1;
}
%new
- (id)copyDeactivationSettings {
	return [NSMutableArray new];
}
%new
- (BOOL)shouldLaunchPNGless {
	return NO;
}
%new
- (BOOL)shouldLaunchSuspendedAlways {
	return YES;
}
%new
- (BOOL)isWebApplication {
	return YES;
}
%new
- (id)launchURL {
	return nil;
}
%new
-(id)copyProcessSettings {
	return nil;
}
%new
- (id)sceneIdentifierForDisplay:(id)arg1 {
	return nil;
}
%end

%hook UIStepper
- (void)setStepValue:(double)arg1 {
	if (arg1 == 0)
	arg1 = 0.01;
	return %orig(arg1);
} 
%end

%hook BSPlatform
%new
- (CGFloat)width {
    return 150.0;
}
%end




static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	if ([((NSDictionary *)userInfo)[NSLoadedClasses] containsObject:@"AXEditableTableCellWithStepper"]) {
		%init(Settings);
	}
}



%ctor {
	%init;
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
	(CFNotificationCallback)reloadPrefsQC,
	CFSTR("com.creatix.quickcenter/settingschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	CFNotificationCenterAddObserver(
		CFNotificationCenterGetLocalCenter(), NULL,
		notificationCallback,
		(CFStringRef)NSBundleDidLoadNotification,
		NULL, CFNotificationSuspensionBehaviorCoalesce);
}

