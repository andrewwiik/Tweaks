#import "SBLockScreenNotificationListController.h"
#import "BulletinBoard/BBBulletin.h"

@class NTXModernNotificationView;

@interface SBLockScreenNotificationListView : UIView
@property (nonatomic, retain) SBLockScreenNotificationListController *model;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BBBulletin *)_activeBulletinForIndexPath:(NSIndexPath *)indexPath;
- (void)updateForAdditionOfItemAtIndex:(unsigned long long)arg1 allowHighlightOnInsert:(BOOL)arg2;
- (void)updateForModificationOfItemWithOldIndex:(unsigned long long)arg1 andNewIndex:(unsigned long long)arg2;
- (void)updateForRemovalOfItemAtIndex:(unsigned long long)arg1 removedItem:(id)arg2;
- (void)updateForRemovalOfItems;
- (void)_updateTotalContentHeight;
- (void)_handleAction:(id)arg1 forBulletin:(id)arg2;
- (NSArray *)tableView:(id)tableView editActionsForRowAtIndexPath:(id)path;
- (BOOL)_disableIdleTimer:(BOOL)arg1;

// NotificationsX

@property (nonatomic, retain) NTXModernNotificationView *draggedCell;

- (void)updateListItem:(SBAwayBulletinListItem *)item withHeight:(CGFloat)height;
@end