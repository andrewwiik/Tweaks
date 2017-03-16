#import <UIKit/UIKit.h>

#define SCREEN ([UIScreen mainScreen].bounds)

@interface SBMainSwitcherViewController : UIViewController
@end
@interface SBSwitcherContainerView : UIView
@end
@interface SBDeckSwitcherItemContainer : UIView
@end
@interface SBDeckSwitcherPageView : UIView
@end
@interface SBAppSwitcherSnapshotView : UIView
@end
@interface SBSwitcherSnapshotImageView : UIView
@end
@interface SBCornerAnimatingImageView : UIImageView
@end
@interface SBNotificationsViewController : UIViewController
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
- (id)initWithObserverFeed:(unsigned long long)arg1;
@end

// CGSize cardSize = {196.88, 350};
SBNotificationsViewController *notifs;

%hook SBNotificationsViewController
- (id)initWithNibName:(id)arg1 bundle:(id)arg2 {
	%orig;
	notifs = self;
	return %orig;
}
- (id)initWithObserverFeed:(unsigned long long)arg1 {
	%orig;
	notifs = self;
	return %orig;
}
%end
 %hook SBMainSwitcherViewController
- (void)loadView {
	%orig;
}
- (void)viewDidLoad {
	%orig;
	// self.view.frame = CGRectMake(0,0,375,350);
 }
 - (void)viewWillAppear:(_Bool)arg1 {
 	%orig;
 	   [self addChildViewController:notifs];
   notifs.view.frame = CGRectMake(0,SCREEN.size.height/2,SCREEN.size.width,SCREEN.size.height/2);
   [self.view addSubview:notifs.view];
   [notifs didMoveToParentViewController:self];
 }
%end 
%hook SBSwitcherContainerView
- (CGRect)frame {
	return CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height/2);
}
-(void)layoutSubviews {
	%orig;
	self.frame = CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height/2);

}
%end
 //%hook SBDeckSwitcherViewController
/* - (struct CGSize)sizeForDisplayItem:(id)arg1 fromProvider:(id)arg2 {
	return cardSize;
}
- (struct CGSize)contentSizeForDisplayItem:(id)arg1 fromProvider:(id)arg2 {
	return cardSize;
} */
/* - (double)_scaleForPresentedProgress:(double)arg1 {
	return 0.3;
} */
//%end
 /* %hook SBDeckSwitcherItemContainer
/* -(void)layoutSubviews {
	%orig;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 188, 350);
}
/- (void)setContentPageViewScale:(double)arg1 {
	%orig(1);
}
%end
/* %hook SBDeckSwitcherPageViewProvider
- (long long)resizingPolicyForPageView:(id)arg1 {
	return 0;
}
%end */

/* %hook SBSwitcherSnapshotImageView
- (double)_transformScale {
	return  1;
}
%end */
/* %hook SBAppSwitcherSnapshotView
-(void)layoutSubviews {
	%orig;
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 188, 350);
}
%end */
/* %hook SBSwitcherSnapshotImageView
- (void)layoutSubviews {
	%orig;
	// self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 188, 350);
	self.autoresizesSubviews = YES;
	for (UIView *subview in self.subviews)
    {
        subview.frame = CGRectMake(0, 0, 188, 350);
    }

}
%end
%hook SBCornerAnimatingImageView
- (void)layoutSubviews {
	%orig;
    self.frame = CGRectMake(0, 0, 188, 350);
}
%end */
