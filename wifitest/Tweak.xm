// #include <netdb.h>
// #include <netinet/tcp.h>
// #include <unistd.h>
#include <substrate.h>
#import "substrate.h"
#import <CFNetwork/CFNetwork.h>
// #import <AppList/AppList.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>


#ifndef SPRINGBOARDSERVICES_H_
#define SPRINGBOARDSERVICES_H_

#include <CoreFoundation/CoreFoundation.h>

#if __cplusplus
extern "C" {
#endif
    
#pragma mark - API
    
    mach_port_t SBSSpringBoardServerPort();
    void SBSetSystemVolumeHUDEnabled(mach_port_t springBoardPort, const char *audioCategory, Boolean enabled);
    
    void SBSOpenNewsstand();
    void SBSSuspendFrontmostApplication();
    
    CFStringRef SBSCopyBundlePathForDisplayIdentifier(CFStringRef displayIdentifier);
    CFStringRef SBSCopyExecutablePathForDisplayIdentifier(CFStringRef displayIdentifier);
    NSString * SBSCopyLocalizedApplicationNameForDisplayIdentifier(NSString *identifier);
    CFDataRef SBSCopyIconImagePNGDataForDisplayIdentifier(CFStringRef displayIdentifier);
    
    CFSetRef SBSCopyDisplayIdentifiers();
    
    CFStringRef SBSCopyFrontmostApplicationDisplayIdentifier();
    CFStringRef SBSCopyDisplayIdentifierForProcessID(pid_t PID);
    CFArrayRef SBSCopyDisplayIdentifiersForProcessID(pid_t PID);
    BOOL SBSProcessIDForDisplayIdentifier(CFStringRef identifier, pid_t *pid);
    
    int SBSLaunchApplicationWithIdentifier(CFStringRef identifier, Boolean suspended);
    int SBSLaunchApplicationWithIdentifierAndLaunchOptions(CFStringRef identifier, CFDictionaryRef launchOptions, BOOL suspended);
    CFStringRef SBSApplicationLaunchingErrorString(int error);
    
#if __cplusplus
}
#endif

#endif /* SPRINGBOARDSERVICES_H_ */
// #import <libdispatch.dylib/OS_object.h>

// @interface OS_tcp_connection : NSObject
// -(void)_dispose;
// @end
// #import <CoreFoundation/CoreFoundation.h>
// #import <SystemConfiguration/SystemConfiguration.h>


// @interface NETClientConnection : NSObject
// - (BOOL)wifiInUse;
// - (NSString *)effectiveBundleID;
// - (void)destroy:(BOOL)arg1;
// @end

// %hook NETClientConnection
// - (void)evaluate {
// 	%orig;
// 	// if ([self wifiInUse]) {
// 	// 	if ([[self effectiveBundleID] isEqualToString:[NSString stringWithFormat:@"com.spotify.client"]]) {
// 			[self destroy:YES];
// 			[self dealloc];
// 	// 	}
// 	// }
// }
// %end

// %hook NETClient
// - (void)handleRequest:(id)arg1 {
// 	HBLogInfo(@" CONNECTION: %@", arg1);
// }
// %end


// @interface BlockAllRequestsProtocol : NSURLProtocol
// @end

// @implementation BlockAllRequestsProtocol
// + (BOOL)canInitWithRequest:(NSURLRequest *)request
// {
//     return YES; // Intercept all outgoing requests, whatever the URL scheme
//     // (you can adapt this at your convenience of course if you need to block only specific requests)
// }

// + (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request { return request; }
// - (NSCachedURLResponse *)cachedResponse { return nil; }

// - (void)startLoading
// {
//     // For every request, emit "didFailWithError:" with an NSError to reflect the network blocking state
//     id<NSURLProtocolClient> client = [self client];
//     NSError* error = [NSError errorWithDomain:NSURLErrorDomain
//                                          code:kCFURLErrorNotConnectedToInternet // = -1009 = error code when network is down
//                                      userInfo:@{ NSLocalizedDescriptionKey:@"All network requests are blocked by the application"}];
//     [client URLProtocol:self didFailWithError:error];
// }
// - (void)stopLoading { }

// @end

// %hook UIApplication
// %new
// - (void)blockInternet {
// [NSURLProtocol registerClass:[BlockAllRequestsProtocol class]];
// }
// %end


// // getaddrinfo(const char *restrict nodename, const char *restrict servname,
// //          const struct addrinfo *restrict hints,
// //          struct addrinfo **restrict res);
         
         
// // MSHook(int, getaddrinfo, const char *restrict nodename, const char *restrict servname,
// //          const struct addrinfo *restrict hints,
// //          struct addrinfo **restrict res) {           // our replacement of CFShow().
// //   return 3;
// // }

// // (void *) MSHookFunction((void *)getaddrinfo, MSHook(getaddrinfo));



// // int (*orig_sysctlbyname)(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen);
// int my_sysctlbyname(const char *nodename, const char *servname,
//          const struct addrinfo *hints,
//          struct addrinfo **res){

//     return 3;
// }

// CFSocketRef CFSocketCreateLOL ( CFAllocatorRef allocator, SInt32 protocolFamily, SInt32 socketType, SInt32 protocol, CFOptionFlags callBackTypes, CFSocketCallBack callout, const CFSocketContext *context ) {
// return nil;
// }

// CFSocketRef CFSocketCreateConnectedToSocketSignatureLOL ( CFAllocatorRef allocator, const CFSocketSignature *signature, CFOptionFlags callBackTypes, CFSocketCallBack callout, const CFSocketContext *context, CFTimeInterval timeout ) {
// return nil;
// }

// CFSocketRef CFSocketCreateWithNativeLOL ( CFAllocatorRef allocator, CFSocketNativeHandle sock, CFOptionFlags callBackTypes, CFSocketCallBack callout, const CFSocketContext *context ) {
// return nil;
// }

// CFSocketRef CFSocketCreateWithSocketSignatureLOL ( CFAllocatorRef allocator, const CFSocketSignature *signature, CFOptionFlags callBackTypes, CFSocketCallBack callout, const CFSocketContext *context ) {
// return nil;
// }

// // SCNetworkReachabilityRef SCNetworkReachabilityCreateWithAddressLOL ( CFAllocatorRef allocator, const struct sockaddr *address ) {
// // return nil;
// // }

// // SCNetworkReachabilityRef SCNetworkReachabilityCreateWithAddressPairLOL ( CFAllocatorRef allocator, const struct sockaddr *localAddress, const struct sockaddr *remoteAddress ) {
// // return nil;
// // }

// // SCNetworkReachabilityRef SCNetworkReachabilityCreateWithNameLOL ( CFAllocatorRef allocator, const char *nodename ) {
// // return nil;
// // }

// Boolean SCNetworkReachabilityGetFlagsLOL ( SCNetworkReachabilityRef target, SCNetworkReachabilityFlags *flags ) {
// return false;
// }

// %hook NSURLConnection
// - (void)start {
// }
// %end

// void *(*tcp_connection_cancel)(OS_tcp_connection *stuff);
// void *tcp_connection_cancel MSFindSymbol(NULL,"_tcp_connection_start");
// void tcp_connection_startLOL (id *connection) {
//     // (MSFindSymbol(NULL,"_tcp_connection_start")connection);
//     tcp_connection_cancel(connection);
// }
static BOOL internet = NO;
void (*orig_start)(id *self);
void end_tcp_now (id *self) {
    if (internet) orig_start(self);
}


%hook UIApplication
%new
- (void)unblockInternet {
internet = YES;
   // MSHookFunction((void *)MSFindSymbol(NULL,"_tcp_connection_start"), (void *)MSFindSymbol(NULL,"_tcp_connection_start"), nil);
// [NSURLProtocol registerClass:[BlockAllRequestsProtocol class]];
}
%end

%group WiFiSettings
@interface APNetworksController : PSListController
@property (nonatomic, retain) NSMutableDictionary *wifiUsage;
-(void)addDammit;
@end

%hook APNetworksController
%property (nonatomic, retain) NSMutableDictionary *wifiUsage;
- (NSMutableArray *)specifiers {
    NSMutableArray *specifiers = %orig;
    // ALApplicationList *list = [%c(ALApplicationList) sharedApplicationList];
    // NSDictionary *applications = [list applications];
    NSArray *keys = (NSArray *)SBSCopyDisplayIdentifiers();
    // NSLog(@"IDENTIFIERS: %@", bundleIdentifiers);
    
    NSMutableArray *applicationSpecifiers = [NSMutableArray new];
    // NSMutableArray *keys = [[applications allKeys] mutableCopy];
    // NSArray *removeApplications = [list _hiddenDisplayIdentifiers];
    // for (NSString *key in removeApplications) {
    // [keys removeObject:key];
    // }
    
    PSSpecifier *wifiLabel = [%c(PSSpecifier) preferenceSpecifierNamed:@"Use Wi-Fi For:"
					target:self
						 set:NULL
						 get:NULL
					detail:Nil
						cell:PSGroupCell
						edit:Nil];
//	[shortcutMenuLabel setProperty:[NSString stringWithFormat:@"The maximum number of shortcuts to display in a shortcut menu activated through Control Center."] forKey:@"footerText"];
  [wifiLabel setProperty:@"Use Wi-Fi For:" forKey:@"label"];
//	[shortcutMenuLabel setProperty:[NSNumber numberWithInt:0] forKey:@"footerAlignment"];
  [wifiLabel setProperty:@"wifi_label" forKey:@"id"];
  [specifiers addObject:wifiLabel];
  
  
    for (NSString *key in keys) {
        PSSpecifier *specifier = [%c(PSSpecifier) preferenceSpecifierNamed:SBSCopyLocalizedApplicationNameForDisplayIdentifier(key) target:self set:@selector(setWifiUsageValue:forSpecifier:) get:@selector(wifiUsageValueForSpecifier:) detail:nil cell:PSSwitchCell edit:nil];
        [specifier setProperty:key forKey:@"appIDForLazyIcon"];
        [specifier setProperty:@YES forKey:@"useLazyIcons"];
        [applicationSpecifiers addObject:specifier];
    }
    
    // NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" 
    ascending:YES selector:@selector(caseInsensitiveCompare:)];
    [applicationSpecifiers sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [specifiers addObjectsFromArray:applicationSpecifiers];
    return specifiers;
}

%new
- (void)setWifiUsageValue:(id)value forSpecifier:(PSSpecifier *)specifier {
    if (self.wifiUsage) {
    // if(value) [self.wifiUsage setObject:@"YES" forKey:[specifier propertyForKey:@"appIDForLazyIcon"]];
    [self.wifiUsage setObject:value forKey:[specifier propertyForKey:@"appIDForLazyIcon"]];
    if ([self.wifiUsage writeToFile:@"/var/mobile/Library/Preferences/com.atwiiks.conditionalwifi.plist" atomically:NO])
    NSLog (@"Written");
    else
    NSLog (@"Not Written");
    // [self.wifiUsage writeToFile:@"/var/mobile/Library/Preferences/com.atwiiks.conditionalwifi.plist" atomically:YES];
     }
    else {
    self.wifiUsage = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.atwiiks.conditionalwifi.plist"];
    if (self.wifiUsage) {
    // if (value) [self.wifiUsage setObject:@"YES" forKey:[specifier propertyForKey:@"appIDForLazyIcon"]];
    [self.wifiUsage setObject:value forKey:[specifier propertyForKey:@"appIDForLazyIcon"]];
    [self.wifiUsage writeToFile:@"/var/mobile/Library/Preferences/com.atwiiks.conditionalwifi.plist" atomically:NO];
    }
    else {
    self.wifiUsage = [NSMutableDictionary new];
    [self.wifiUsage setObject:value forKey:[specifier propertyForKey:@"appIDForLazyIcon"]];
    [self.wifiUsage writeToFile:@"/var/mobile/Library/Preferences/com.atwiiks.conditionalwifi.plist" atomically:NO];
    }
    
    }
}
%new
- (id)wifiUsageValueForSpecifier:(PSSpecifier *)specifier {
    if (self.wifiUsage) {
        if ([[self.wifiUsage objectForKey:[specifier propertyForKey:@"appIDForLazyIcon"]] isEqual: @NO]) return @NO;
    }
    else {
        self.wifiUsage = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.atwiiks.conditionalwifi.plist"];
    }
    return @YES;
}
%end
%end




static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	if ([((NSDictionary *)userInfo)[NSLoadedClasses] containsObject:@"APNetworksController"]) {
		%init(WiFiSettings);
		// Target class has been loaded
	}
}

%ctor {
   if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.spotify.client"]) { // Viber App
    //MSHookFunction((void *)MSFindSymbol(NULL,"_tcp_connection_start"), (void *)MSFindSymbol(NULL,"_tcp_connection_close"), &orig_start);
    MSHookFunction((void *)MSFindSymbol(NULL,"_tcp_connection_start"), (void *)end_tcp_now, (void **)&orig_start);
   }
   %init;
   CFNotificationCenterAddObserver(
		CFNotificationCenterGetLocalCenter(), NULL,
		notificationCallback,
		(CFStringRef)NSBundleDidLoadNotification,
		NULL, CFNotificationSuspensionBehaviorCoalesce);
}

// %ctor {
//     MSHookFunction((void *)MSFindSymbol(NULL,"_tcp_connection_start"), (void *)MSFindSymbol(NULL,"_tcp_connection_cancel"), nil);
// }
// %ctor {

//     MSHookFunction((int *)getaddrinfo, (void *)my_sysctlbyname, nil);
    
//     MSHookFunction((void *)MSFindSymbol(NULL,"_CFSocketCreate"), (void *)CFSocketCreateLOL, nil);
//     MSHookFunction((void *)MSFindSymbol(NULL,"_CFSocketCreateConnectedToSocketSignature"), (void *)CFSocketCreateConnectedToSocketSignatureLOL, nil);
//     MSHookFunction((void *)MSFindSymbol(NULL,"_CFSocketCreateWithNative"), (void *)CFSocketCreateWithNativeLOL, nil);
//     MSHookFunction((void *)MSFindSymbol(NULL,"_CFSocketCreateWithSocketSignature"), (void *)CFSocketCreateWithSocketSignatureLOL, nil);
//     MSHookFunction((void *)MSFindSymbol(NULL,"_SCNetworkReachabilityGetFlags"), (void *)SCNetworkReachabilityGetFlagsLOL, nil);
    
//     MSHookFunction((CFSocketRef)CFSocketCreate, (void *)CFSocketCreateLOL, nil);
//     MSHookFunction((CFSocketRef)CFSocketCreateConnectedToSocketSignature, (void *)CFSocketCreateConnectedToSocketSignatureLOL, nil);
//     MSHookFunction((CFSocketRef)CFSocketCreateWithNative, (void *)CFSocketCreateWithNativeLOL, nil);
//     MSHookFunction((CFSocketRef)CFSocketCreateWithSocketSignature, (void *)CFSocketCreateWithSocketSignatureLOL, nil);
    
//     // MSHookFunction((void *)MSFindSymbol(NULL,"_SCNetworkReachabilityCreateWithAddress"), (void *)SCNetworkReachabilityCreateWithAddressLOL, nil);
//     // MSHookFunction((void *)MSFindSymbol(NULL,"_SCNetworkReachabilityCreateWithAddressPair"), (void *)SCNetworkReachabilityCreateWithAddressPairLOL, nil);
//     // MSHookFunction((void *)MSFindSymbol(NULL,"_SCNetworkReachabilityCreateWithName"), (void *)SCNetworkReachabilityCreateWithNameLOL, nil);
    
//     // MSHookFunction((void *)SCNetworkReachabilityCreateWithAddress, (void *)SCNetworkReachabilityCreateWithAddressLOL, nil);
//     // MSHookFunction((void *)SCNetworkReachabilityCreateWithAddressPair, (void *)SCNetworkReachabilityCreateWithAddressPairLOL, nil);
//     // MSHookFunction((void *)SCNetworkReachabilityCreateWithName, (void *)SCNetworkReachabilityCreateWithNameLOL, nil);
    
//     struct addrinfo hints, *serverinfo;
//     int error = getaddrinfo([[NSString stringWithFormat:@"8.8.8.8"] UTF8String], [[NSString stringWithFormat:@"22"] UTF8String], &hints, &serverinfo);
//     if (error == 3) {
//     NSLog(@"TEST SUCCESS");
//     }
//     [NSURLProtocol registerClass:[BlockAllRequestsProtocol class]];
// }


// %hook NETLedBelly
// - (_Bool)addClient:(id)arg1 {

//     [self cancel];
// }
// %end
