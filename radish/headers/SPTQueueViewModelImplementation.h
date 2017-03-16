#import "SPTQueueViewModelDataSource.h"

@interface SPTQueueViewModelImplementation : NSObject
- (id)initWithPlayer:(id)arg1 productState:(id)arg2 playbackDelegateRegistry:(id)arg3 entityDecorationController:(id)arg4 logCenter:(id)arg5;
- (id)removeTracks:(NSArray *)tracks;
- (void)enableUpdates;
- (SPTQueueViewModelDataSource *)dataSource;
@end