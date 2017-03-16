#import <UIKit/UIKit.h>
@interface MailSplitViewController : UISplitViewController
-(NSArray *)mutableChildViewControllers;
-(id)masterViewController;
-(id)_preservedDetailController;
-(void)fixMeDammit;
@end
@interface MailNavigationController : UIViewController
@end
@interface MailDetailNavigationController : UIViewController
@end
%hook MailSplitViewController
-(id)init {
	%orig;
	[NSTimer scheduledTimerWithTimeInterval:0.2
    target:self
    selector:@selector(fixMeDammit)
    userInfo:nil
    repeats:YES];
    return %orig;
}
-(void)viewDidLayoutSubviews {
	%orig;
	if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
{     
	UIView* me = self.view;
	UIView* masterView = [[self masterViewController] view];
	UIView* detailView = [[self _preservedDetailController] view];
	masterView.frame = CGRectMake(me.frame.size.width - masterView.frame.size.width,0,masterView.frame.size.width,masterView.frame.size.height);
	detailView.frame = CGRectMake(0,0,detailView.frame.size.width,detailView.frame.size.height);
}
}
%new
-(void)fixMeDammit {
if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
{     
	UIView* me = self.view;
	UIView* masterView = [[self masterViewController] view];
	UIView* detailView = [[self _preservedDetailController] view];
	masterView.frame = CGRectMake(me.frame.size.width - masterView.frame.size.width,0,masterView.frame.size.width,masterView.frame.size.height);
	detailView.frame = CGRectMake(0,0,detailView.frame.size.width,detailView.frame.size.height);
}
if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
 {	

 	UIView* me = self.view;
	UIView* masterView = [[self masterViewController] view];
	masterView.frame = CGRectMake(me.frame.size.width - masterView.frame.size.width,0,masterView.frame.size.width,masterView.frame.size.height);

           
 }	
}
%end
%hook MailNavigationController
-(id)init {
	%orig;
		[NSTimer scheduledTimerWithTimeInterval:0.2
    target:self
    selector:@selector(fixMeDammit)
    userInfo:nil
    repeats:YES];
    return %orig;
}
%new
-(void)fixMeDammit {	
	UIView* upThere = [self.view superview];
	self.view.frame = CGRectMake(upThere.frame.size.width - self.view.frame.size.width,0,self.view.frame.size.width,self.view.frame.size.height);
}
-(void)viewWillLayoutSubviews {
		%orig;
	if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
{     
	UIView* upThere = [self.view superview];
	self.view.frame = CGRectMake(upThere.frame.size.width - self.view.frame.size.width,0,self.view.frame.size.width,self.view.frame.size.height);
}
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
{
	%orig;
	UIView* upThere = [self.view superview];
	self.view.frame = CGRectMake(upThere.frame.size.width - self.view.frame.size.width,0,self.view.frame.size.width,self.view.frame.size.height);
}
}
-(void)setFrame:(CGRect)arg1 {
	%orig;
	if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
{     
	UIView* upThere = [self.view superview];
	self.view.frame = CGRectMake(upThere.frame.size.width - self.view.frame.size.width,0,self.view.frame.size.width,self.view.frame.size.height);
}
}
-(void)viewDidLayoutSubviews {
	%orig;
if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
{     
	UIView* upThere = [self.view superview];
	self.view.frame = CGRectMake(upThere.frame.size.width - self.view.frame.size.width,0,self.view.frame.size.width,self.view.frame.size.height);
}
}
%end
%hook MailDetailNavigationController
-(void)viewDidLayoutSubviews {
	if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
{
	self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
}
}
%end