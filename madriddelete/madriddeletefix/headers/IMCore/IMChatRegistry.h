#import <Foundation/NSObject.h>

@interface IMChatRegistry : NSObject
+ (instancetype)sharedInstance;
- (void)historicalMessageGUIDsDeleted:(id)arg1 chatGUIDs:(id)arg2 queryID:(id)arg3;
@end
