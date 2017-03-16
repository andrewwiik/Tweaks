#import "headers.h"
#import "CCXMiniMediaPlayerMediaControlsView.h"

@interface CCXMiniMediaPlayerSectionView : CCUIControlCenterSectionView
@property (nonatomic, retain) CCXMiniMediaPlayerMediaControlsView *mediaControlsView;
- (id)init;
- (void)layoutSubviews;
@end