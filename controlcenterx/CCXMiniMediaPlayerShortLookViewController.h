#import "headers.h"
#import "CCXMiniMediaPlayerShortLookView.h"

@interface CCXMiniMediaPlayerShortLookViewController : MPUControlCenterMediaControlsViewController
@property (nonatomic, retain) CCXMiniMediaPlayerShortLookView *view;
@property (nonatomic, assign) BOOL fakeContentSize;
@property (nonatomic, retain) SBUIIconForceTouchController *iconForceTouchController;
+ (Class)controlsViewClass;
@end