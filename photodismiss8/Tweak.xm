#import <UIKit/UIKit.h> // We need to Import UJIKIt
#import <CoreGraphics/CoreGraphics.h> // We need to Also Import the CoreGraphics Framework
#import <QuartzCore/QuartzCore.h> // and the QuartzCore Framework

@interface PLPhotoTileViewController : UIViewController
@end

@interface PUPhotoBrowserController : UIViewController
- (void)_navigateToAllPhotos;
@end

@interface PLPhotoTileViewController (PhotoDismiss) <UIGestureRecognizerDelegate>
-(void)photoDismiss:(UISwipeGestureRecognizer *)sender;
@end

@interface PUTopLevelNavigationBar : UINavigationBar
-(void)_handlePopSwipe:(id)arg1;
@end

PUTopLevelNavigationBar* PhotoDismissSharedObject;

%hook PUTopLevelNavigationBar
-  (void)layoutSubviews {
	%orig;
	PhotoDismissSharedObject = self;
}
%end

%hook PLPhotoTileViewController
-(void)loadView {
	%orig;
	UISwipeGestureRecognizer * photoDismiss = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(photoDismissAction:)];
	photoDismiss.direction = UISwipeGestureRecognizerDirectionDown;
	[self.view addGestureRecognizer:photoDismiss];
	[photoDismiss release];

}
%new
-(void)photoDismissAction:(UILongPressGestureRecognizer*)gesture {
	if(gesture.state == UIGestureRecognizerStateEnded)
	{
		[PhotoDismissSharedObject _handlePopSwipe:nil];
	}
}
%end