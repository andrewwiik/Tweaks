#import <UIKit/UIKit.h>
#import "CameraView.h"

#define NSLog(FORMAT, ...) NSLog(@"[%@]: %@",@"Point and Shoot" , [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#define SCREEN ([UIScreen mainScreen].bounds)
#define PREFS_BUNDLE_ID (@"com.bolencki13.pointandshoot")


static NSDictionary *prefs = [[NSUserDefaults alloc] initWithSuiteName:PREFS_BUNDLE_ID];


@interface SBApplication : NSObject
- (NSString*)bundleIdentifier;
- (NSString*)displayName;
@end


@interface SBApplicationShortcutMenuContentView : UIView
- (id)initWithInitialFrame:(struct CGRect)arg1 containerBounds:(struct CGRect)arg2 orientation:(long long)arg3 shortcutItems:(id)arg4 application:(id)arg5;
- (void)_handlePress:(id)arg1;
- (UILongPressGestureRecognizer *)highlightGesture;
@end
@interface SBApplicationShortcutMenu : UIView <CameraViewDelegate>
@property(retain, nonatomic) SBApplication *application; // @synthesize application=_application;
- (void)dismissAnimated:(_Bool)arg1 completionHandler:(id)arg2;
- (void)presentAnimated:(_Bool)arg1;
@end


@interface SBIconController : UIViewController
@property(retain, nonatomic) SBApplicationShortcutMenu *presentedShortcutMenu; // @synthesize presentedShortcutMenu=_presentedShortcutMenu;
- (void)_handleShortcutMenuPeek:(UILongPressGestureRecognizer*)arg1;
@end


@interface UIApplication (Private)
-(BOOL)launchApplicationWithIdentifier:(NSString*)identifier suspended:(BOOL)suspended;
@end

@interface SBSApplicationShortcutItem : NSObject
- (id)type;
- (void)setType:(id)arg1;
@end


static CameraView *camera;
static BOOL onScreen;
%hook SBIconController
- (void)_handleShortcutMenuPeek:(UILongPressGestureRecognizer*)arg1 {
	if ([prefs boolForKey:@"presentnow"] == YES) {//preferences for present immediately & not on action
			if ([self.presentedShortcutMenu.application.bundleIdentifier isEqualToString:@"com.apple.camera"]) {//checks that is the camera app
				switch (arg1.state) {
				       case UIGestureRecognizerStateBegan: {
								 }break;
				       case UIGestureRecognizerStateChanged: {
								 if ([arg1 locationInView:camera].y < camera.bounds.size.height/2) {//sets camera view mode on initial gesture
                     				[camera setCameraViewMode:BackView];
                 				} else {
                     				[camera setCameraViewMode:FrontView];
                 				}
								 SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(self.presentedShortcutMenu,"_contentView");
								 [contentView highlightGesture].enabled = NO;
								 //pressGestureRecognizer = nil;
								 UIView *proxyIconView = MSHookIvar<id>(self.presentedShortcutMenu,"_proxyIconViewWrapper");//used for corner gesture expansion later
								 camera.iconFrame = proxyIconView.frame;

								 }break;
				       case UIGestureRecognizerStateEnded: {
							 			SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(self.presentedShortcutMenu,"_contentView");
							 			if (CGRectContainsPoint(contentView.frame, [arg1 locationInView:self.presentedShortcutMenu])) {//checks if touch is inside the camera view
											[camera dismissCameraAndTakePhoto:YES];//used to take the photo
							 			}
									 onScreen = NO;
								 }break;
				       default:
				           break;
				   }
			} else {
				%orig;
			}
	}
	else {
		%orig;
	}
}
%end

%hook SBApplicationShortcutMenu
- (void)menuContentView:(id)arg1 activateShortcutItem:(SBSApplicationShortcutItem *)shortcutItem index:(long long)arg3 {
	if ([prefs boolForKey:@"presentnow"] == NO) {//preferences for present on action & not immediately
		if ([shortcutItem.type isEqualToString:@"com.apple.camera.shortcuts.selfie"]) {
			SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(self,"_contentView");
			CGRect helpFrame = CGRectMake(0,0,contentView.frame.size.width, contentView.frame.size.height);
			camera = [[CameraView alloc] initWithFrame:helpFrame];//adds camera view
			 		 [contentView addSubview:camera];
			 		 [camera presentCamera:2];

	    	[contentView highlightGesture].enabled = NO;
	    	UIView *proxyIconView = MSHookIvar<id>(self,"_proxyIconViewWrapper");//again used for corner gesture expansion later
			camera.iconFrame = proxyIconView.frame;
			onScreen = YES;
    	} else if ([shortcutItem.type isEqualToString:@"com.apple.camera.shortcuts.photo"]) {
			SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(self,"_contentView");
			CGRect helpFrame = CGRectMake(0,0,contentView.frame.size.width, contentView.frame.size.height);
			camera = [[CameraView alloc] initWithFrame:helpFrame];//adds camera
				 	 [contentView addSubview:camera];
				 	 [camera presentCamera:1];
					 [contentView highlightGesture].enabled = NO;
					 UIView *proxyIconView = MSHookIvar<id>(self,"_proxyIconViewWrapper");//again used for corner gesture expansion later
					 camera.iconFrame = proxyIconView.frame;
					 onScreen = YES;
  		}
  		else {
  			%orig;
  		}
	} else {
		%orig;
	}
}
- (void)presentAnimated:(_Bool)arg1 {
	%orig;
	if ([prefs boolForKey:@"presentnow"] == YES) {//preferences for present immediately & not on action
		if ([self.application.bundleIdentifier isEqualToString:@"com.apple.camera"]) {
			if (onScreen == NO) {
				 SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(self,"_contentView");
				 CGRect maxMenuFrame = MSHookIvar<CGRect>(contentView,"_maxMenuFrame");
				 camera = [[CameraView alloc] initWithFrame:CGRectMake(0,0,maxMenuFrame.size.width,maxMenuFrame.size.height)];//adds camera
				 camera.delegate = self;
				 camera.alpha = 0.0;
				 [contentView addSubview:camera];
				 [camera presentCamera:[prefs integerForKey:@"presentnowcamera"]];
				 onScreen = YES;

			}
		}
	}
}
%new
- (void)cameraViewDidFinishLoading:(CameraView *)camera {//camera delegate
    [UIView animateWithDuration:0.25 animations:^{//calls transition to fade view in
    	[camera doneLoading];
        camera.alpha = 1.0;
    }];
}
%new
- (void)cameraViewDidTakePhoto:(CameraView*)camera {
	if ([prefs boolForKey:@"multiphoto"] == NO) {//preferences check to determine multiphoto
		[self dismissAnimated:YES completionHandler:nil];// dismisses view
	}
}
%end
#define kResizeThumbSize (35)
BOOL isResizingLR, isResizingUL, isResizingUR, isResizingLL;
CGPoint touchStart;
CGPoint previousPoint;
%hook SBApplicationShortcutMenuContentView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if (onScreen == YES)
 	[camera touchesBegan:touches withEvent:event];//movement for camera resizing
 	else %orig;
 }

 - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
 	if (onScreen == YES) [camera touchesMoved:touches withEvent:event];//movement for camera resizing
 	else %orig;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if (onScreen == YES)
	[camera touchesEnded:touches withEvent:event];//movement for camera resizing
	else %orig;
}
%new
- (UILongPressGestureRecognizer *)highlightGesture {
	return MSHookIvar<id>(self,"_pressGestureRecognizer");//disables longpresgesture so our gesturs can be used
}
%end
