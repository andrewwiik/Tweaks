#import "headers.h"
#include <spawn.h>
#include <dispatch/dispatch.h>
#import <objc/runtime.h>

@interface NSString (Creatix)
- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end;
@end

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
        NSMutableDictionary* VibrationDictionary = [NSMutableDictionary dictionary];
        NSMutableArray* VibrationArray = [NSMutableArray array ];
        [VibrationArray addObject:[NSNumber numberWithBool:YES]];
        [VibrationArray addObject:[NSNumber numberWithInt:50]]; //vibrate for 50ms
        [VibrationDictionary setObject:VibrationArray forKey:@"VibePattern"];
        [VibrationDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
        AudioServicesPlaySystemSoundWithVibration(4095,nil,VibrationDictionary);
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

@interface UITouch (UIForceGestureRecognizer)
- (CGFloat)getQuality;
- (CGFloat)getRadius;
- (CGFloat)getDensity;
- (int)getX;
- (int)getY;
@end

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

@interface NSArray (compare)
+ (NSArray *)removeDuplicatesInArray:(NSArray*)arrayToFilter;
@end
@implementation NSArray (compare)
+ (NSArray *)removeDuplicatesInArray:(NSArray*)arrayToFilter{

    NSMutableSet *seenDates = [NSMutableSet set];
    NSPredicate *dupDatesPred = [NSPredicate predicateWithBlock: ^BOOL(id obj, NSDictionary *bind) {
        DMNetwork *e = (DMNetwork*)obj;
        BOOL seen = [seenDates containsObject:e.SSID];
        if (!seen) {
            [seenDates addObject:e.SSID];
        }
        return !seen;
    }];
    return [arrayToFilter filteredArrayUsingPredicate:dupDatesPred];
}
@end


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

@implementation UIForceGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action{
    if ((self = [super initWithTarget:target action:action])){
        // so simple there's no setup
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
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
	if (hasIncreasedByPercent(15, Density, lastDensity) && hasIncreasedByPercent(15, Radius, lastRadius)) {
		self.state = UIGestureRecognizerStateBegan;
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
		else if (hasIncreasedByPercent(15, Density, lastDensity) && hasIncreasedByPercent(15, Radius, lastRadius)) {
			self.state = UIGestureRecognizerStateBegan;
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
	[super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
    [self reset];
    //MenuOpen = NO;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
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

%hook SBApplicationShortcutMenu

- (void)_setupViews {
	%orig;
	if ([self.iconView.type isEqualToString: @"WiFi"]) {
	
	//[[iconView _folderIconImageView] setHidden:YES];
	//iconView.frame = self.frame;
	SBIconView *proxyIconView = MSHookIvar<id>(self,"_proxyIconView");
	[proxyIconView setHidden:YES];
	UIView *proxyView = MSHookIvar<id>(self,"_proxyIconViewWrapper");
	//proxyView.frame = CGRectMake(proxyView.frame.origin.x, proxyView.frame.origin.y, [%c(SBIconView) defaultIconImageSize].width, [%c(SBIconView) defaultIconImageSize].height);
	SBControlCenterButton *proxyButton = [%c(SBControlCenterButton) _buttonWithBGImage:nil glyphImage:[[[%c(SBCCWiFiSetting) alloc] init] glyphImageForState:1] naturalHeight:proxyView.frame.size.height];
		//SBControlCenterButton *proxyButton = [%c(SBControlCenterButton) _buttonWithBGImage:[self _backgroundImageWithGlyphImage:[self sourceGlyphImage] state:1] glyphImage:[self sourceGlyphImage] naturalHeight:self.frame.size.height];
		[proxyView addSubview:proxyButton];
		proxyButton.center = [proxyView convertPoint:proxyView.center fromView:proxyView.superview];
		[proxyView.layer setCornerRadius:proxyView.frame.size.width/2];
		proxyView.backgroundColor = [UIColor whiteColor];
	}
}

- (void)presentAnimated:(_Bool)arg1 {
	if ([[%c(SBControlCenterController) sharedInstance] isVisible]) {
		SBControlCenterController *sbcc = [%c(SBControlCenterController) sharedInstance];
		[self removeFromSuperview];
		[sbcc.view addSubview:self];
	}
	%orig;
}
%property (nonatomic, retain) NSString *type;
/*- (void)_setupViews {
	SBControlCenterController *sbcc = [%c(SBControlCenterController) sharedInstance];
	[self removeFromSuperview];
	[sbcc.view addSubview:self];
	%orig;
}*/
- (id)_shortcutItemsToDisplay {ls -arg5
	if ([self.iconView.type isEqualToString:@"WiFi"]) {
		[[%c(DMNetworksManager) sharedInstance] scan];
 		NSMutableArray *networks = [[%c(DMNetworksManager) sharedInstance] networks];
 		NSMutableArray *shortcuts = [[NSMutableArray alloc] init];
 		if (networks) {
 			if ([networks count] >= 4) {
 				for (int x = 0; x < 4; x++) {
 					DMNetwork *network = [networks objectAtIndex:x];
 					SBSApplicationShortcutCustomImageIcon *shortcutIcon = [[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:UIImagePNGRepresentation([[[%c(SBCCWiFiSetting) alloc] init] glyphImageForState:1])];
 					SBSApplicationShortcutItem *shortcut = [[%c(SBSApplicationShortcutItem) alloc] init];
 					[shortcut setLocalizedTitle:network.SSID];
 					[shortcut setIcon:shortcutIcon];
 					if (network.requiresPassword) {
 						[shortcut setLocalizedSubtitle:@"Secured"];
 					}
 					else {
 						[shortcut setLocalizedSubtitle:@"Open"];
 					}
 					[shortcuts addObject:shortcut];
 				}
 			}
 			else {
 				for (int x = 0; x < [networks count]; x++) {
 					DMNetwork *network = [networks objectAtIndex:x];
 					SBSApplicationShortcutCustomImageIcon *shortcutIcon = [[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:UIImagePNGRepresentation([[[%c(SBCCWiFiSetting) alloc] init] glyphImageForState:1])];
 					SBSApplicationShortcutItem *shortcut = [[%c(SBSApplicationShortcutItem) alloc] init];
 					[shortcut setLocalizedTitle:network.SSID];
 					[shortcut setIcon:shortcutIcon];
 					if (network.requiresPassword) {
 						[shortcut setLocalizedSubtitle:@"Secured"];
 					}
 					else {
 						[shortcut setLocalizedSubtitle:@"Open"];
 					}
 					[shortcuts addObject:shortcut];
 				}
 			}
 		}
 		return shortcuts;
	}
	else return %orig;
}
%end

static BOOL isShortcutOpen = NO;
%hook SBControlCenterButton
%property (nonatomic, retain) UIView *helpIconView;
%property (nonatomic, retain) SBApplicationShortcutMenu *shortcut;

- (void)setIdentifier:(id)arg1 {
	%orig;
	if ([arg1 isEqualToString: @"wifi"]) {
		SBFolderIconView *iconView = [[%c(SBFolderIconView) alloc] initWithFrame:self.frame];
		iconView.type = [NSString stringWithFormat:@"WiFi"];
		//[iconView setUpHoppinGestures];
		//[iconView changeGestures];
		[iconView setIcon:[[%c(SBFolderIcon) alloc] init]];
		self.helpIconView = iconView;
		[self addSubview:self.helpIconView];
		[[self.helpIconView _folderIconImageView] setHidden:YES];
		iconView.frame = self.frame;
		SBIconController *iconController = [objc_getClass("SBIconController") sharedInstance];
		UIForceGestureRecognizer *forcePress = [[UIForceGestureRecognizer alloc] initWithTarget:iconController action:@selector(_handleShortcutMenuPeek:)];
		forcePress.minimumPressDuration = 300;
		[iconView addGestureRecognizer:forcePress];
	}
}
%new
- (void)resetStuff {
	isShortcutOpen = NO;
}
//- (void)_dismissAnimated:(_Bool)arg1 finishPeeking:(_Bool)arg2 ignorePresentState:(_Bool)arg3 completionHandler:(id)arg4;
%new
-(void)_handleShortcutMenuPeek:(UILongPressGestureRecognizer*)sender {
	if (sender.state == UIGestureRecognizerStateBegan) {
		SBApplicationShortcutMenu *test = [[%c(SBApplicationShortcutMenu) alloc] initWithFrame:CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height) application:[[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:@"com.apple.Music"] iconView:self.helpIconView interactionProgress:nil orientation:1];
		test.type = [NSString stringWithFormat:@"WiFi"];
		SBControlCenterController *sbcc = [%c(SBControlCenterController) sharedInstance];
		[sbcc.view addSubview:test];
		self.shortcut = test;
		isShortcutOpen = YES;
		
		if ([[test _shortcutItemsToDisplay] count] > 0) {
				[test _peekWithContentFraction:0.5 smoothedBlurFraction:0.5];
		}
		else {
			[test _dismissAnimated:YES finishPeeking:NO ignorePresentState:YES];
		}
	}
	if (self.shortcut) [self.shortcut updateFromPressGestureRecognizer:sender];
	SBApplicationShortcutMenu *test = self.shortcut;
	SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(	test,"_contentView");
	if (contentView) {
		[contentView _presentForFraction:1];
	}
}
%end

%hook SBFolderIconView
%property (nonatomic, retain) NSString *type;
%new
-(void)_handleShortcutMenuPeek:(UILongPressGestureRecognizer*)sender {
	SBIconController *iconController = [objc_getClass("SBIconController") sharedInstance];
	[iconController _handleShortcutMenuPeek:sender];
}
%end

%hook SBIconView
%property (nonatomic, retain) NSString *type;
%end