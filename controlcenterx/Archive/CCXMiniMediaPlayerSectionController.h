#import "headers.h"
#import "CCXMiniMediaPlayerSectionView.h"
#import "CCXMiniMediaPlayerViewController.h"

@interface CCXMiniMediaPlayerSectionController : CCUIControlCenterSectionViewController
@property (nonatomic, retain) CCXMiniMediaPlayerSectionView *view;
@property (nonatomic, retain) CCXMiniMediaPlayerViewController *mediaControlsViewController;
- (BOOL)dismissModalFullScreenIfNeeded;
+ (NSString *)sectionIdentifier;
+ (NSString *)sectionName;
+ (UIImage *)sectionImage;
@end