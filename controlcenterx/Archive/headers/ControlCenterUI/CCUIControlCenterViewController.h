#import "CCUIControlCenterPageContentProviding-Protocol.h"

@interface CCUIControlCenterViewController : UIViewController {
	UIPanGestureRecognizer* _panGesture;
}
-(void)_addContentViewController:(id)arg1;
-(void)_addOrRemovePagesBasedOnVisibility;
-(void)_removePageViewController:(id)arg1;
-(void)_addPageViewController:(id)arg1;
-(void)_loadPages;
-(void)_removeContentViewController:(id)arg1;
-(id<CCUIControlCenterPageContentProviding>)_selectedContentViewController;
@end