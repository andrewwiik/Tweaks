@class SBAppSwitcherSnapshotView, SBDisplayItem;

@interface SBDeckSwitcherPageViewProvider : NSObject
- (id)initWithDelegate:(id)arg1;
- (SBAppSwitcherSnapshotView *)_snapshotViewForDisplayItem:(SBDisplayItem *)arg1 preferringDownscaledSnapshot:(BOOL)arg2 synchronously:(BOOL)arg3;
@end