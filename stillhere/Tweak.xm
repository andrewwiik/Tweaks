#import <UIKit/UIKit.h>
@interface PHCallViewController : UIViewController
@end
@interface PHVideoCallViewController : PHCallViewController
@end

%hook PHVideoCallViewController
-(void)viewDidDisappear:(BOOL)arg1 {
}
-(void)setUseLargePIP:(BOOL)arg1 {
	%orig(TRUE);
}
-(BOOL)useLargePIP {
	return TRUE;
}
%end
%hook TUFaceTimeVideoCall
- (void)setIsSendingVideo:(BOOL)arg1 {
	%orig(TRUE);
}
- (BOOL)isSendingVideo {
	return TRUE;
}
%end
%hook TUFaceTimeCall
- (BOOL)isUplinkMuted {
	return FALSE;
}
- (BOOL)setUplinkMuted:(BOOL)arg1 {
	arg1 = FALSE;
	return FALSE;
}
%end
%hook TUCall
- (BOOL)isSendingVideo {
	return TRUE;
}
- (BOOL)setUplinkMuted:(BOOL)arg1 {
	arg1 = FALSE;
	return FALSE;
}
- (BOOL)isUplinkMuted {
	return FALSE;
}
%end
%hook CMVideoCapture
-(int)stop:(bool)arg1 {
return %orig(NO);
}
%end
%hook CannedVideoCapture
-(void)stopThreads {
}
-(int)stop:(bool)arg1 {
return %orig(NO);
}
%end
%hook VideoConferenceManager
-(void)stopSIP {
}
%end
%hook SDPMini
-(id)videoPayloads {
	return nil;
}
%end
%hook VCVideoRule
-(int)iPayload {
	NSLog(@"%d", %orig);
	return %orig;
}
%end
