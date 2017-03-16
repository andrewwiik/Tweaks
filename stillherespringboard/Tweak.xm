@interface FBDisplayManager : NSObject
+(id)mainDisplay;
@end
@interface FBSceneManager : NSObject
+(id)sharedInstance;
-(UIView*)_rootWindowForDisplay:(FBDisplayManager*)display;
@end
@interface PHCallViewController : UIViewController
@end
@interface PHVideoCallViewController : PHCallViewController
+ (PHVideoCallViewController *)sharedInstance;
@end

%hook SBMediaController
%new
-(void)showFaceTime {
	UIView* frontView = [[%c(FBSceneManager) sharedInstance] _rootWindowForDisplay:[%c(FBDisplayManager) mainDisplay]];
	dlopen("/Applications/InCallService.app/InCallService", RTLD_NOW);
	UIView* FaceTimeRemote = [[%c(PHVideoCallViewController) sharedInstance] view];
	[frontView addSubview:FaceTimeRemote];
}
%end