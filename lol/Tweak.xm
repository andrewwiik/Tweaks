#import <UIKit/UIKit.h>
static BOOL shown = NO;
static BOOL doStuff = YES;
id specialSwitch;
%group MyWi
%hook MyWiToggle
- (id)titleForSwitchIdentifier:(id)arg1 {
	return @"Night Shift";
}
- (void)applyState:(int)arg1 forSwitchIdentifier:(id)arg2 {
	%orig;
	// if (!shown)
	// [[%c(SBControlCenterController) sharedInstance] testPopup];
}
%new
- (void)resetStuff {
	shown = YES;
}
%end
static BOOL done = NO;
%hook SBControlCenterStatusUpdate
- (void)setStatusStrings:(id)arg1 {
	if (!done) {
		NSMutableArray *newArray = [NSMutableArray new];
		[newArray addObject:@"Night Shift: On Until 7:00 AM"];
		%orig(nil);
		done = YES;
	}
	else {
		%orig;
		done = NO;
	}
}
%end
@interface SBControlCenterController : UIViewController
+ (id)sharedInstance;
- (void)testPopup;
@end

%hook _FSSwitchButton
- (id)initWithSwitchIdentifier:(NSString*)arg1 template:(id)arg2 {
	if ([arg1 isEqualToString:[NSString stringWithFormat:@"com.mywi"]]) {
		specialSwitch = self;
	}
	return %orig;
}
- (void)_pressed {
	if ([[self valueForKey:@"switchIdentifier"] isEqualToString:[NSString stringWithFormat:@"com.mywi"]]) {
		if (doStuff) {
			doStuff = NO;
			specialSwitch = self;
			[[%c(SBControlCenterController) sharedInstance] testPopup];
		}
		else {
			%orig;
		}
	}
	else {
		%orig;
	}
}
%end
%hook SBControlCenterController
%new
- (void)testPopup {
UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Night Shift"
                               message:@"Night Shift can automatically adjust the\ncolors of your display at night to\nreduce eye strain"
                               preferredStyle:UIAlertControllerStyleAlert];
 
UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Turn On Until 7 AM" style:UIAlertActionStyleDefault
   handler:^(UIAlertAction * action) {
   			[[[[self valueForKey:@"_viewController"] valueForKey:@"_contentView"] valueForKey:@"_grabberView"] performSelector:@selector(testShit)];
   			[specialSwitch _pressed];


   	}];
   UIAlertAction* defaultAction1 = [UIAlertAction actionWithTitle:@"Schedule Settings..." style:UIAlertActionStyleDefault
   handler:^(UIAlertAction * action) {}];
 
[alert addAction:defaultAction];
[alert addAction:defaultAction1];
alert.preferredAction = defaultAction1;
[self presentViewController:alert animated:YES completion:nil];
}
%end

%hook SBControlCenterGrabberView
%new
- (void)testShit {
	NSLog(@"We did it Bitches");
}
%end

%hook SBLeafIcon
- (BOOL)isRecentlyUpdated {
	if ([[self applicationBundleID] isEqualToString:[NSString stringWithFormat:@"com.saurik.Cydia"]]) return YES;
	return %orig;
}
%end
%end

%ctor {
	%init(MyWi);
}