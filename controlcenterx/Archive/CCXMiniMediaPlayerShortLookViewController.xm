#import "CCXMiniMediaPlayerShortLookViewController.h"

%subclass CCXMiniMediaPlayerShortLookViewController : MPUControlCenterMediaControlsViewController
%property (nonatomic, assign) BOOL fakeContentSize;

+ (Class)controlsViewClass {
	return NSClassFromString(@"CCXMiniMediaPlayerShortLookView");
}

// -(void)viewDidDisappear:(BOOL)arg1 {
//   if(arg1) {
//     if ([NSClassFromString(@"SBUIIconForceTouchController") _isPeekingOrShowing]) {
//       [NSClassFromString(@"SBUIIconForceTouchController") _dismissAnimated:YES withCompletionHandler:^{
//         %orig;
//       }];
//     } else {
//       %orig;
//     }
//   } else {
//     %orig;
//   }
// }
// -(void)controlCenterDidDismiss {
//   if ([NSClassFromString(@"SBUIIconForceTouchController") _isPeekingOrShowing]) {
//     [NSClassFromString(@"SBUIIconForceTouchController") _dismissAnimated:YES withCompletionHandler:^{
//        %orig;
//     }];
//   } else {
//     %orig;
//   }
// }
-(void)mediaControlsViewPrimaryActionTriggered:(id)arg1 {
  if ([NSClassFromString(@"SBUIIconForceTouchController") _isPeekingOrShowing]) {
     [NSClassFromString(@"SBUIIconForceTouchController") _dismissAnimated:YES withCompletionHandler:^{
       %orig;
    }];
  } else {
    %orig;
  }
}
// -(void)transportControlMediaRemoteController:(id)arg1 requestsPushingMediaRemoteCommand:(unsigned)arg2 withOptions:(id)arg3 shouldLaunchApplication:(BOOL)arg4 {
//   if (arg4) {
//     if ([NSClassFromString(@"SBUIIconForceTouchController") _isPeekingOrShowing]) {
//       [NSClassFromString(@"SBUIIconForceTouchController") _dismissAnimated:YES withCompletionHandler:^{
//         %orig;
//       }];
//     } else {
//       %orig;
//     }
//   } else {
//     %orig;
//   }
// }
%end