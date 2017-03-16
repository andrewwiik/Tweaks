#import <Foundation/NSObject.h>

@interface IMDMessageStore : NSObject
+ (instancetype)sharedInstance;
- (id)deleteMessageGUIDs:(NSArray *)arg1;
@end