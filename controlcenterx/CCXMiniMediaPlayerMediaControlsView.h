#import "headers.h"
#import "CCXVolumeAndBrightnessSectionController.h"
#import "idiom.h"
@class CCXMiniMediaPlayerViewController;

@interface CCXMiniMediaPlayerMediaControlsView : MPUControlCenterMediaControlsView
@property (nonatomic, retain) CCXVolumeAndBrightnessSectionController *volumeController;
@property (nonatomic, assign) BOOL fakeCompactStyle;
- (CCXMiniMediaPlayerViewController *)delegate;
- (BOOL)useCompactStyle;
- (void)setUseCompactStyle:(BOOL)arg1;
- (void)setUseCompactStyle:(BOOL)arg1 animated:(BOOL)arg2;
- (void)_layoutPhoneCompactStyle;
- (void)_layoutPhoneLandscape;
- (void)_layoutPhoneRegularStyle;
- (BOOL)_routingViewShouldBeVisible;
- (void)setRoutingView:(id)routingView;
- (id)routingView;
- (void)_layoutExpandedRoutingViewUsingBounds:(CGRect)arg1;
@end