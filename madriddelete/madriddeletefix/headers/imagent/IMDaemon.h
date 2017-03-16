#import <Foundation/NSObject.h>
#import "../IMCore/IMChatRegistry.h"

@interface IMDaemon : NSObject
-(IMChatRegistry *)broadcasterForChatListenersWithMessageContext:(id)arg1;
@end
