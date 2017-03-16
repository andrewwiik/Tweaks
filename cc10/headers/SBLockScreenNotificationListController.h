#import "SBAwayBulletinListItem.h"

@interface SBLockScreenNotificationListController : NSObject
- (SBAwayBulletinListItem *)listItemAtIndexPath:(id)indexPath;
- (void)handleLockScreenActionWithContext:(id)arg1;
@end