#import <Foundation/NSObject.h>

#import "IMRemoteDaemonProtocol-Protocol.h"

@interface IMDaemonController : NSObject
@property (setter=_setListenerID:, nonatomic, retain) NSString *_listenerID;
- (BOOL)isConnected;
+ (instancetype)sharedInstance;
+ (id)sharedController;
- (void)_connectToDaemonWithLaunch:(BOOL)arg1 capabilities:(unsigned)arg2;
- (id<IMRemoteDaemonProtocol>)_remoteObject;
- (BOOL)connectToDaemonWithLaunch:(BOOL)arg1;
- (BOOL)isConnecting;
- (unsigned int)_capabilities;
- (void)_setCapabilities:(unsigned int)arg1;
@end