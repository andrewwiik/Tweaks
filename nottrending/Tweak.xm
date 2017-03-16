#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface YTTabsRendererViewController : UIViewController
- (void)noTrending;
@end
@interface YTTabTitlesView : UIView
- (YTTabsRendererViewController *)delegate;
- (void)nope;
@end



/* Notes 

NSMutableArray, _contentViewControllers

index is 1

YTTabsTitleView

NSMutableArray, _buttons

index is 1
*/

%hook YTTabsRendererViewController

%new
- (void)noTrending {
	NSMutableArray *viewControllers = MSHookIvar<NSMutableArray *>(self,"_contentViewControllers");
	if (viewControllers.count == 4) {
		[viewControllers removeObjectAtIndex:1];
		// NSLog(@"REMoved the Fuckin Bitc hHoe dfgadfg");
	}
	MSHookIvar<NSMutableArray *>(self,"_contentViewControllers") = viewControllers;
}

- (void)viewDidAppear:(BOOL)arg1 {
	%orig;
	[self noTrending];
}
%end

%hook YTTabTitlesView
- (NSMutableArray *)buttons {
	NSMutableArray *helpy = %orig;
	if (helpy.count == 4) {
		[helpy removeObjectAtIndex: 1];
	}
	return helpy;
}
- (NSMutableArray *)allButtons {
	NSMutableArray *helpy = %orig;
	if (helpy.count == 4) {
		[helpy removeObjectAtIndex: 1];
	}
	return helpy;
}
- (void)layoutButtons {
	NSMutableArray *helpy = MSHookIvar<NSMutableArray *>(self,"_buttons");
	if (helpy.count == 4) {
		[helpy removeObjectAtIndex: 1];
	}
	MSHookIvar<NSMutableArray *>(self,"_buttons") = helpy;
	%orig;
}
%end


