#import <UIKit/UIKit.h> // We need to Import UJIKIt
#import <CoreGraphics/CoreGraphics.h> // We need to Also Import the CoreGraphics Framework
#import <QuartzCore/QuartzCore.h> // and the QuartzCore Framework

@interface SBFButton : UIButton
@end

@interface SBUIControlCenterButton : SBFButton
@end

@interface SBControlCenterButton : SBUIControlCenterButton
@property(copy, nonatomic) NSString *identifier;
-(void)quickPorn;
@end
@interface MusicContextualUpNextAlertAction : UIAlertAction
@end

%hook SBControlCenterButton
-(void)layoutSubviews {
	if ([self.identifier isEqualToString:@"com.apple.calculator"]) {
	self.tag = 1337;
    %orig;
}
else %orig;
}
- (void)_pressAction {
	if ([self.identifier isEqualToString:@"com.apple.calculator"]) {
		[self quickPorn];
}
else %orig;
}
%new // Creating a New Method
- (void)quickPorn {
        NSLog(@"Quick Porn, Watch Porn fast and easy"); 
}
%end