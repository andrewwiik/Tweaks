typedef unsigned int FZListenerCapability;

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

extern FZListenerCapability kFZListenerCapOnDemandChatRegistry;
extern NSString *IMChatItemsDidChangeNotification;
extern NSString *IMAttachmentCharacterString;
extern NSString *IMMessagePartAttributeName;
extern NSString *IMFileTransferGUIDAttributeName;
extern NSString *IMFilenameAttributeName;
extern NSString *IMInlineMediaWidthAttributeName;
extern NSString *IMInlineMediaHeightAttributeName;
extern NSString *IMBaseWritingDirectionAttributeName;
extern NSString *IMFileTransferAVTranscodeOptionAssetURI;
extern NSString *IMStripFormattingFromAddress(NSString *formattedAddress);

@interface IMService : NSObject
@end

@interface IMAccount : NSObject
- (NSArray *)__ck_handlesFromAddressStrings:(NSArray *)addresses;
@end

@interface IMHandle : NSObject
@property (retain, nonatomic, readonly) NSString *ID;
@property (retain, nonatomic, readonly) NSString *name;
@end

@class IMChatItem;

@interface IMItem : NSObject
@property (retain, nonatomic) NSDate *time;
@property (retain, nonatomic) id context;
+ (Class)contextClass;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (IMChatItem *)_newChatItems;
@end

@interface IMMessageItem : IMItem
@property (retain, nonatomic) NSString *subject;
@property (retain, nonatomic) NSAttributedString *body;
@property (retain, nonatomic) NSString *plainBody;
@property (retain, nonatomic) NSData *bodyData;
@property (retain, nonatomic) NSDate *timeDelivered;
@property (retain, nonatomic) NSDate *timeRead;
@property (assign, nonatomic) NSUInteger flags;
@end

@interface IMMessage : NSObject
+ (instancetype)messageFromIMMessageItem:(IMMessageItem *)item sender:(id)sender subject:(id)subject;
@end

@interface IMItemChatContext : NSObject {
    IMHandle *_otherHandle;
    IMHandle *_senderHandle;
}
@end

@interface IMMessageItemChatContext : IMItemChatContext {
    BOOL _invitation;
    IMMessage *_message;
}
@end

@interface IMChatItem : NSObject
- (IMItem *)_item;
@end

@interface IMTranscriptChatItem : IMChatItem
@end

@protocol IMMessageChatItem <NSObject>
@required
- (NSDate *)time;
- (IMHandle *)sender;
- (BOOL)isFromMe;
- (BOOL)failed;
@end

@interface IMMessageChatItem : IMTranscriptChatItem <IMMessageChatItem>
@end

@interface IMMessagePartChatItem : IMMessageChatItem
@end

@interface IMTextMessagePartChatItem : IMMessagePartChatItem
@end

@interface IMAttachmentMessagePartChatItem : IMMessagePartChatItem
- (instancetype)_initWithItem:(IMMessageItem *)item text:(NSAttributedString *)text index:(NSInteger)index transferGUID:(NSString *)transferGUID;
@end

@interface IMChat : NSObject
@property (nonatomic, readonly) NSString *chatIdentifier;
@property (retain, nonatomic) NSString *displayName;
@property (retain, nonatomic) IMHandle *recipient;
@property (nonatomic, readonly) NSArray *participants;
@property (nonatomic, readonly) NSArray *chatItems;
@property (assign, nonatomic) NSUInteger numberOfMessagesToKeepLoaded;
- (NSString *)loadMessagesBeforeDate:(NSDate *)date limit:(NSUInteger)limit loadImmediately:(BOOL)immediately;
@end

@interface IMPreferredServiceManager : NSObject
+ (instancetype)sharedPreferredServiceManager;
- (IMService *)preferredServiceForHandles:(NSArray *)handles newComposition:(BOOL)newComposition error:(NSError * __autoreleasing *)errpt serverCheckCompletionBlock:(id)completion;
@end

@interface IMAccountController : NSObject
+ (instancetype)sharedInstance;
- (IMAccount *)__ck_defaultAccountForService:(IMService *)service;
@end

@interface IMHandleRegistrar : NSObject
+ (instancetype)sharedInstance;
- (NSArray *)allIMHandles;
@end

@interface IMChatRegistry : NSObject
+ (instancetype)sharedInstance;
- (NSArray *)allExistingChats;
@end

@interface IMDaemonListener : NSObject
@property (nonatomic, readonly) NSArray *allServices;
@property (nonatomic, readonly) NSArray *handlers;
- (void)addHandler:(id)handler;
@end

@interface IMDaemonController : NSObject
@property (nonatomic, readonly) FZListenerCapability capabilities;
@property (nonatomic, readonly) IMDaemonListener *listener;
@property (nonatomic, readonly) BOOL isConnected;
@property (nonatomic, readonly) BOOL isConnecting;
+ (instancetype)sharedInstance;
- (BOOL)connectToDaemon;
- (BOOL)connectToDaemonWithLaunch:(BOOL)launch;
- (BOOL)connectToDaemonWithLaunch:(BOOL)launch capabilities:(FZListenerCapability)capabilities blockUntilConnected:(BOOL)block;
- (BOOL)addListenerID:(NSString *)listenerID capabilities:(FZListenerCapability)capabilities;
- (FZListenerCapability)capabilitiesForListenerID:(NSString *)listenerID;
- (BOOL)setCapabilities:(FZListenerCapability)capabilities forListenerID:(NSString *)listenerID;
@end

extern NSBundle *CKFrameworkBundle(void);
extern FZListenerCapability CKListenerCapabilities(void) __attribute__((weak_import));
extern FZListenerCapability CKListenerPaginatedChatRegistryCapabilities(void) __attribute__((weak_import));


%hook IMDaemon
-(BOOL)daemonInterface:(id)arg1 shouldGrantAccessForPID:(int)arg2 auditToken:(id)arg3 portName:(id)arg4 listenerConnection:(id)arg5 setupInfo:(id)arg6 setupResponse:(id*)arg7 {
	return TRUE;
}
-(BOOL)daemonInterface:(id)arg1 shouldGrantPlugInAccessForPID:(int)arg2 auditToken:(id)arg3 portName:(id)arg4 listenerConnection:(id)arg5 setupInfo:(id)arg6 setupResponse:(id*)arg7 {
	return TRUE;
}
%end

%hook IMDaemonController
- (BOOL)setCapabilities:(id)capabilities forListenerID:(NSString *)listenerID {
	NSLog(@"Cabailtie: %@, lsitenID: %@", capabilities,listenerID);
	%orig;
	//%orig(Chats, listenerID);
	return TRUE;

}
%end

#import <dlfcn.h>
#import <substrate.h>
#import <Foundation/Foundation.h>

%hook Broadcaster
-(void)sendXPCObject:(id)arg1 {
    %orig;
    NSLog(@"XPC Object: %@", arg1);
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
        dlopen("/System/Library/PrivateFrameworks/IMFoundation.framework/IMFoundation", RTLD_LAZY);
        void *xpcFunction = MSFindSymbol(NULL, "_IMDAuditTokenTaskHasEntitlement");
        MSHookFunction(xpcFunction, (void *)hax_IMDAuditTokenTaskHasEntitlement, (void **)&orig_IMDAuditTokenTaskHasEntitlement);
    }
}


