#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

CGPoint previousPoint;

@interface KeyBoardGesture : UIPanGestureRecognizer
- (BOOL)didLongPress;
- (unsigned long long)recognizedFlickDirection;
- (BOOL)shouldIgnorePoint:(CGPoint)point;
@end

#define PREFS_BUNDLE_ID (@"com.creatix.motus")

NSDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creatix.motus.plist"];
//NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:PREFS_BUNDLE_ID];
static float keyboardPanSensitivity = [(__bridge NSNumber*)[prefs objectForKey:@"keyboardPanSensitivity"] floatValue];
static void reloadPrefs() {
	dispatch_async(dispatch_get_main_queue(), ^{
		prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creatix.motus.plist"];

		NSUserDefaults *prefs2 = [[NSUserDefaults alloc] initWithSuiteName:PREFS_BUNDLE_ID];
		if (![[prefs objectForKey:@"defaultsSet"] boolValue]) {
			[prefs2 setBool:YES forKey:@"Enabled"];
			[prefs2 setFloat:10.0f forKey:@"keyboardPanSensitivity"];
			[prefs2 setBool:YES forKey:@"defaultsSet"];
		}
		keyboardPanSensitivity = [(__bridge NSNumber*)[prefs objectForKey:@"keyboardPanSensitivity"] floatValue];
		// [prefs registerDefaults:prefsDict];
	});
}


@implementation KeyBoardGesture
- (id)initWithTarget:(id)target action:(SEL)action{
    if ((self = [super initWithTarget:target action:action])){
        // so simple there's no setup
    }
    return self;
}
- (BOOL)didLongPress {
	return NO;
}
-(unsigned long long)recognizedFlickDirection {
	return nil;
}
- (BOOL)_canPanVertically {
	return NO;
}
- (BOOL)shouldIgnorePoint:(CGPoint)point {
	if (CGPointEqualToPoint(point, CGPointMake(-1,-1))) {
		return YES;
	}
     else {
     	return NO;
     }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if ([[prefs objectForKey:@"Enabled"] boolValue])
	[super touchesBegan:touches withEvent:event];

}
 -(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
if ([[prefs objectForKey:@"Enabled"] boolValue]) {
	NSArray *touchesArray = [touches allObjects];
	for(int i=0; i<[touchesArray count]; i++)
		{
    	UITouch *touch = (UITouch *)[touchesArray objectAtIndex:i];
    	CGPoint point = [touch locationInView:nil];
    	if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
    		[super touchesMoved: touches withEvent:event];
    	}
    	else {
    		if ([self shouldIgnorePoint:previousPoint]) {
			previousPoint = point;
			return;
			}
			else {
					if ((previousPoint.y - point.y >= keyboardPanSensitivity || previousPoint.y - point.y <= -(keyboardPanSensitivity))) {
						self.state = UIGestureRecognizerStateBegan;
						[super touchesMoved: touches withEvent:event];
						// [super touchesMoved: touches withEvent:event];
						//return; 
					}
      				else if ((previousPoint.x - point.x >= keyboardPanSensitivity) || (previousPoint.x- point.x <= -(keyboardPanSensitivity))) {
						self.state = UIGestureRecognizerStateBegan;
						[super touchesMoved: touches withEvent:event];
						//%orig;
     				}

    			else {
    				if ((previousPoint.x - point.x >= keyboardPanSensitivity || previousPoint.x- point.x <= -(keyboardPanSensitivity)) || (previousPoint.y - point.y >= keyboardPanSensitivity || previousPoint.y - point.y <= -(keyboardPanSensitivity))) {
						self.state = UIGestureRecognizerStateBegan;
						[super touchesMoved: touches withEvent:event];
						//%orig;
					}
     			}
			}
     	}
     	previousPoint = point;
	}
}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// %orig;
	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
	previousPoint = CGPointMake(-1,-1);
	[super touchesEnded:touches withEvent:event];
}
}

@end

@interface UIKeyboardLayoutStar : UIView
- (void)willBeginIndirectSelectionGesture;
- (void)didEndIndirectSelectionGesture;
- (UIView *)currentKeyplaneView;
- (void)installGestureRecognizers;
@property (nonatomic, retain) KeyBoardGesture *pan;
@end

@interface UIKeyboardImpl : NSObject
- (UIKeyboardLayoutStar *)_layout;
@end

@interface _UIKeyboardTextSelectionGestureController : NSObject
- (id)oneFingerForcePressRecognizer;
+ (id)sharedInstance;
- (void)addOneFingerForcePressRecognizerToView:(id)arg1;
- (void)configureOneFingerForcePressRecognizer:(id)arg1;
- (void)_willBeginIndirectSelectionGesture:(id)arg1;
-(id)addTwoFingerTextSelectionGesturesToView:(id)arg1;
-(void)configureTwoFingerPanGestureRecognizer:(id)arg1;
-(void)_willBeginIndirectSelectionGesture:(id)arg1 ;
-(void)oneFingerForcePress:(id)arg1 ;
-(void)setPanGestureState:(long long)arg1 ;
-(id)addTwoFingerPanRecognizerToView:(id)arg1 ;
- (UIKeyboardImpl *)delegate;
@end

@interface _UITextSelectionForceGesture : UILongPressGestureRecognizer
@property (assign,nonatomic) BOOL shouldFailWithoutForce;
@end

@interface _UIPanOrFlickGestureRecognizer : UIPanGestureRecognizer
@property (assign,nonatomic) double minimumPressDuration;
- (BOOL)shouldIgnorePoint:(CGPoint)point;
@end


// static BOOL trackPadOn;
%hook UIKeyboardLayoutStar
%property (nonatomic, retain) KeyBoardGesture *pan;
- (void)showPopupVariantsForKey:(id)arg1 {
	%orig;
	if ([[prefs objectForKey:@"Enabled"] boolValue]) self.pan.enabled = NO;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	%orig;
	reloadPrefs();
	if (self.pan && ![[prefs objectForKey:@"Enabled"] boolValue]) {
		[self removeGestureRecognizer:self.pan];
		self.pan = nil;
	}
	if (![self pan] && [[prefs objectForKey:@"Enabled"] boolValue]) {
		[self installGestureRecognizers];
	}
}
 
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	%orig;
	if ([[prefs objectForKey:@"Enabled"] boolValue]) self.pan.enabled = YES;
}
- (void)installGestureRecognizers {
	if ([[prefs objectForKey:@"Enabled"] boolValue]) {
		KeyBoardGesture *pan = [[KeyBoardGesture alloc] initWithTarget:[%c(_UIKeyboardTextSelectionGestureController) sharedInstance] action:@selector(twoFingerPan:)];
		self.pan = pan;
		//pan.maximumNumberOfTouches = 1;
		//pan.minimumNumberOfTouches = 1;
		[self  addGestureRecognizer: pan];
	}
	else {
		%orig;
	}
}
%end

%ctor {
	reloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback)reloadPrefs,
        CFSTR("com.creatix.switchservice.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
