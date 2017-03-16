#import <UIKit/UIKit.h> // We need to Import UJIKIt

@interface MusicHUDViewController : UIViewController
- (void)dismiss;
@end

%hook MusicHUDViewController
- (double)dismissalDelay {
	return 0;
}
- (void)viewDidLoad {
	%orig;
	[self dismiss];
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];

}
- (void)presentFromRootViewController {
	return;
}
%end