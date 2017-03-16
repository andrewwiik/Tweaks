#import <UIKit/UIKit.h> // We need to Import UJIKIt
#import <CoreGraphics/CoreGraphics.h> // We need to Also Import the CoreGraphics Framework
#import <QuartzCore/QuartzCore.h> // and the QuartzCore Framework
#import <MediaPlayer/MediaPlayer.h> // and the QuartzCore Framework
#import <Foundation/Foundation.h>
#import "UIView+Toast.h"
@interface TMVideoContentViewModel : NSObject
-(NSURL *)mediaURL;
@end
@interface TMPostContentViewModel : NSObject
-(TMVideoContentViewModel *)videoContentViewModel;
@end
@interface TMPhotoPostContentView : UIView
-(TMPostContentViewModel *)postContentViewModel;
@end
@interface TMPostViewModel : NSObject
-(TMPostContentViewModel *)contentViewModel;
@end
@interface TMPostCell : UITableViewCell
-(TMPostViewModel *)postViewModel;
@end
@interface TMTumblrNativeVideoPostContentView : UIView
-(TMPostCell *)postCell;
@end
@interface TMMediaTransitionController : NSObject
-(BOOL)downloading;
-(TMTumblrNativeVideoPostContentView *)delegate;
-(void)longPressed:(id)arg1;

- (void)setDownloading:(BOOL)arg1;
@end
@interface UIStatusBarWindow : UIView
@end
@interface TMStatusBarBackground : UINavigationBar
@end


static BOOL downloadingVideo;
TMStatusBarBackground* TMStatusBarBackgroundShared;
UIStatusBarWindow* UIStatusBarWindowShared;
static CGPoint pointNow;
%hook TMMediaTransitionController
%new
-(BOOL)downloading {
	if (downloadingVideo == YES)
	return YES;
	else return NO;
}
-(void)longPressed:(id)arg1 {
	if (![self downloading]) {
	NSURL * videoDownloadURL = [[[[[[self delegate] postCell] postViewModel] contentViewModel] videoContentViewModel] mediaURL];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
downloadingVideo = YES;
[self downloading];
NSData *urlData = [NSData dataWithContentsOfURL:videoDownloadURL];
if ( urlData )
    {
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];

    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"thefile.mp4"];

    //saving is done on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [urlData writeToFile:filePath atomically:YES];
        UISaveVideoAtPathToSavedPhotosAlbum(filePath,nil,nil,nil);
        downloadingVideo = NO;
        [self downloading];
    });
    }

});
	return;
}
else %orig;
}
%end
%hook UIStatusBarWindow
-(id)init {
	UIStatusBarWindowShared = %orig;
	return UIStatusBarWindowShared;

}
%end
%hook TMStatusBarBackground
-(id)initWithFrame:(CGRect)arg1 {
	TMStatusBarBackgroundShared = %orig;
	return TMStatusBarBackgroundShared;

}
%end
%hook TMDashboardViewController
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pointNow = scrollView.contentOffset;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
		UIWindow *statusBarWindow = (UIWindow *)[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
		CGRect frame = statusBarWindow.frame;
		CGRect frames = TMStatusBarBackgroundShared.frame;
	    if (scrollView.contentOffset.y<pointNow.y) {
	    	if (statusBarWindow.frame.origin.y<0) {

	    	[TMStatusBarBackgroundShared setHidden:FALSE];
[UIView animateWithDuration:.5
                     animations:^{
                     	statusBarWindow.frame = CGRectMake(frame.origin.x,0,frame.size.width,frames.size.height);
                     	TMStatusBarBackgroundShared.frame = CGRectMake(frames.origin.x,0.001,frames.size.width,frames.size.height);
                     }];
        NSLog(@"Up");
        %orig;
    }
    else {
    	%orig;
    }
    } else if (scrollView.contentOffset.y>pointNow.y) {
    	if (frame.origin.y == 0) {
    		[UIView animateWithDuration:.5
                     animations:^{
					statusBarWindow.frame = CGRectMake(frame.origin.x,frames.origin.y - frames.size.height,frame.size.width,frames.size.height);
    	            TMStatusBarBackgroundShared.frame = CGRectMake(frames.origin.x,frames.origin.y - frames.size.height,frames.size.width,frames.size.height);
                     }];
            // statusBarWindow.frame = frame;
            NSLog(@"Down");
            %orig;
    }
    else {
    	%orig;
    }
}
}
%end
