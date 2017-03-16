#import "SBLockScreenViewController.h"
#import "SBLockScreenNotificationListView.h"

@interface SBLockScreenView : UIView
@property (nonatomic,retain) SBLockScreenNotificationListView *notificationView;  
- (BOOL)notificationsViewHidden;
- (long long)currentPage;
- (CGFloat)_percentScrolledForOffset:(CGFloat)arg1;
- (CGFloat)horizontalOffsetForLockScreenPage:(long long)arg1;
- (BOOL)_isScrollOffsetOnPage;
- (CGFloat)_percentScrolled;
- (SBLockScreenViewController *)delegate;
-(void)setScrollingDisabled:(BOOL)arg1 forRequester:(id)arg2 ;
-(NSSet *)gestures;
@end