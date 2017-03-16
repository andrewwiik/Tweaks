#import <dlfcn.h>
#import <substrate.h>
#import <Foundation/Foundation.h>

enum FZListenerCapabilities {
    Status = 1 << 0,
    Notifications = 1 << 1,
    Chats = 1 << 2,
    VC = 1 << 3,
    AVChatInfo = 1 << 4,
    AuxInput = 1 << 5,
    VCInvitations = 1 << 6,
    Lega = 1 << 7,
    Transfers = 1 << 8,
    Accounts = 1 << 9,
    BuddyList = 1 << 10,
    ChatObserver = 1 << 11,
    SendMessages = 1 << 12,
    MessageHistory = 1 << 13,
    IDQueries = 1 << 14,
    ChatCounts = 1 << 15
};

%hook Broadcaster
-(void)sendXPCObject:(id)arg1 {
    %orig;
    NSLog(@"XPC Object: %@", arg1);
}
%end

%hook IMDaemonController // grant SpringBoard permission to send messages :P
- (BOOL)addListenerID:(NSString *)arg1 capabilities:(unsigned)arg2
{
    if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"] && [arg1 isEqualToString:@"com.apple.MobileSMS"]) return %orig(arg1, MessageHistory);
    return %orig;
}
- (unsigned int)capabilities
{
    if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"]) return 17159 | %orig;
    return %orig;
}
%end

extern const char *__progname;

static int (*orig_IMDAuditTokenTaskHasEntitlement)(id connection, NSString *entitlement);
static int hax_IMDAuditTokenTaskHasEntitlement(__unsafe_unretained id connection, __unsafe_unretained NSString *entitlement) 
{
    if (![entitlement isEqualToString:@"com.apple.multitasking.unlimitedassertions"])
    {
        // We could check if the connection's pid matches SpringBoard's pid, but at this point I don't think it really matters
        // I mean, what could be the worst thing a process can do by making BKSProcessAssertions? slaughtering battery? suspending/keeping apps running?
        return true;
    }

    return orig_IMDAuditTokenTaskHasEntitlement(connection, entitlement);
}

%ctor
{
    // We can never be too sure
	if (strcmp(__progname, "SpringBoard") == 0) 
	{
        dlopen("/System/Library/PrivateFrameworks/IMCore.framework/imagent.app/imagent", RTLD_LAZY);
        void *xpcFunction = MSFindSymbol(NULL, "_IMDAuditTokenTaskHasEntitlement");
        MSHookFunction(xpcFunction, (void *)hax_IMDAuditTokenTaskHasEntitlement, (void **)&orig_IMDAuditTokenTaskHasEntitlement);
    }
}