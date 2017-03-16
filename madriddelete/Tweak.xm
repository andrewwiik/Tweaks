#include <substrate.h>

#import "./headers/BulletinBoard/BBAction.h"
#import "./headers/BulletinBoard/BBActionResponse.h"
#import "./headers/BulletinBoard/BBAppearance.h"
#import "./headers/BulletinBoard/BBBulletin.h"

#import "./headers/IMCore/IMDaemonController.h"

#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFString.h>

typedef unsigned int FZListenerCapabilities;

extern FZListenerCapabilities kFZListenerCapChats;
extern FZListenerCapabilities kFZListenerCapMessageHistory;

%group SMSBBPlugin
%hook SMSBBPlugin
-(BBBulletin *)_bulletinFromMessage:(void *)arg1 serviceName:(id)arg2 mediaObject:(id*)arg3 error:(unsigned long long*)arg4 {
	BBBulletin *bulletin = %orig;
	if (bulletin.supplementaryActionsByLayout) {
		NSMutableDictionary *actionsDictionary = bulletin.supplementaryActionsByLayout;
		if ([actionsDictionary count] == 1) {
			if ([actionsDictionary objectForKey:@0]) {
				NSMutableArray *actionsArray = [(NSArray *)[actionsDictionary objectForKey:@0] mutableCopy];
				if ([actionsArray count] > 0) {
					if ([bulletin.actions objectForKey:@"dismiss"]) {
						BBAction *deleteAction = [[bulletin.actions objectForKey:@"dismiss"] copy];
						deleteAction.identifier = @"CKBBActionIdentifierDeleteMessage";
						deleteAction.appearance.title = @"Delete";
						deleteAction.appearance.style = 1;
						[actionsArray insertObject:deleteAction atIndex:0];
						[actionsDictionary setObject:[actionsArray copy] forKey:@0];
					}
				}
			}
		}
	}
	return bulletin;
}

-(void)handleBulletinActionResponse:(BBActionResponse *)response {
	%orig;
	if (response) {
		if ([response.actionID isEqualToString:@"CKBBActionIdentifierDeleteMessage"]) {
			NSString* messageGUID = (NSString *)[response.bulletinContext objectForKey:@"CKBBContextKeyMessageGUID"];
			NSMutableArray* messageGUIDs = [NSMutableArray new];
			[messageGUIDs addObject:messageGUID];
			IMDaemonController *daemonController = [NSClassFromString(@"IMDaemonController") sharedInstance];
			if ([daemonController isConnected]) {
				[[daemonController _remoteObject] deleteMessageWithGUIDs:[messageGUIDs copy] queryID:nil];
			}
		}
	}
}

%end
%end

FZListenerCapabilities addAllCapabilities(FZListenerCapabilities currentCapabilities) {
	if (!(currentCapabilities & kFZListenerCapChats)) {
		currentCapabilities = currentCapabilities | kFZListenerCapChats;
	}
	if (!(currentCapabilities & kFZListenerCapMessageHistory)) {
		currentCapabilities = currentCapabilities | kFZListenerCapMessageHistory;
	}
	return currentCapabilities;
}

%hook IMDaemonController
- (FZListenerCapabilities)_capabilities {
	if ([self._listenerID isEqualToString:[NSString stringWithFormat:@"com.apple.springboard"]]) {
		return addAllCapabilities(%orig);
	}
	else return %orig;
}
- (void)_setCapabilities:(FZListenerCapabilities)arg1 {
	if ([self._listenerID isEqualToString:[NSString stringWithFormat:@"com.apple.springboard"]]) {
		%orig(addAllCapabilities(arg1));
	}
	else %orig;
}
- (FZListenerCapabilities)capabilities {
	if ([self._listenerID isEqualToString:[NSString stringWithFormat:@"com.apple.springboard"]]) {
		return addAllCapabilities(%orig);
	}
	else return %orig;
}
- (FZListenerCapabilities)capabilitiesForListenerID:(NSString *)arg1 {
	if ([arg1 isEqualToString:[NSString stringWithFormat:@"com.apple.springboard"]]) {
		return addAllCapabilities(%orig);
	}
	else return %orig;
}
%end


static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if ([((__bridge NSDictionary *)userInfo)[NSLoadedClasses] containsObject:@"SMSBBPlugin"]) {
        %init(SMSBBPlugin);
    }
}

%ctor {
    %init;
    MSHookFunction((void *)MSFindSymbol(NULL,"_CKIsRunningInMessages"), (void *)hooked_CKIsRunningInMessages, nil);

    CFNotificationCenterAddObserver(
        CFNotificationCenterGetLocalCenter(), NULL,
        notificationCallback,
        (CFStringRef)NSBundleDidLoadNotification,
        NULL, CFNotificationSuspensionBehaviorCoalesce);
}