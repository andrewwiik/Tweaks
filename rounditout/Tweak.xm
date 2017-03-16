#import <UIKit/UIKit.h>

#define SCREEN ([UIScreen mainScreen].bounds)

@interface SBControlCenterRootView : UIView
@end

%hook SBControlCenterRootView
- (void)setFrame:(CGRect)frame {
    		frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, SCREEN.size.height, self.frame.size.height);
	%orig(frame);
}
%end