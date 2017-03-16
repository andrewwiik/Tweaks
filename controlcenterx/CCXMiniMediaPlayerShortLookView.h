#import "headers.h"
@class CCXMiniMediaPlayerShortLookViewController;

@interface CCXMiniMediaPlayerShortLookView : MPUControlCenterMediaControlsView
- (CCXMiniMediaPlayerShortLookViewController *)delegate;
- (CGSize)intrinsicContentSize;
- (void)_layoutPhoneRegularStyle;
- (void)layoutSubviews;
- (void)_reloadNowPlayingInfoLabels;
- (void)setLayoutStyle:(NSUInteger)style;
@end