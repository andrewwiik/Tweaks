#import "ThirdParty/AsyncDisplayKit/AsyncDisplayKit.h"

@interface IBKSharedStuff : NSObject
+ (id)sharedObject;
@end

@implementation IBKSharedStuff
+ (id)sharedObject {
    return [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
}
@end