//
//  BTAVRCP_ActivatorEvents.m
//
//
//  Created by Brian Olencki on 12/25/15.
//
//

#import "BTAVRCP_ActivatorEvents.h"

@implementation BTAVRCP_ActivatorEvents
 + (id)sharedInstance {
 	static BTAVRCP_ActivatorEvents *shared = nil;
 	if (!shared) {
 		shared = [[BTAVRCP_ActivatorEvents alloc] init];
 	}
 	return shared;
 }
 - (id)init {
 	if ((self = [super init])) {
 		[[objc_getClass("LAActivator") sharedInstance] registerEventDataSource:self forEventName:BTAVRCP_PotatoNext];
 		[[objc_getClass("LAActivator") sharedInstance] registerEventDataSource:self forEventName:BTAVRCP_PotatoPrevious];
 		[[objc_getClass("LAActivator") sharedInstance] registerEventDataSource:self forEventName:BTAVRCP_PotatoPlayPause];
 	}
 	return self;
 }
 - (void)dealloc {
 	if ([[objc_getClass("LAActivator") sharedInstance] isRunningInsideSpringBoard]) {
 		[[objc_getClass("LAActivator") sharedInstance] unregisterEventDataSourceWithEventName:BTAVRCP_PotatoNext];
 		[[objc_getClass("LAActivator") sharedInstance] unregisterEventDataSourceWithEventName:BTAVRCP_PotatoPrevious];
 		[[objc_getClass("LAActivator") sharedInstance] unregisterEventDataSourceWithEventName:BTAVRCP_PotatoPlayPause];
 	}
 	[super dealloc];
 }
 - (NSString *)localizedTitleForEventName:(NSString *)eventName {
 	NSString *title = @"";

 	if ([eventName isEqualToString:BTAVRCP_PotatoNext]) {
 		title = @"Next";
 	} else if ([eventName isEqualToString:BTAVRCP_PotatoPrevious]) {
 		title = @"Previous";
 	} else if ([eventName isEqualToString:BTAVRCP_PotatoPlayPause]) {
 		title = @"Play/Pause";
 	}

 	return title;
 }
 - (NSString *)localizedGroupForEventName:(NSString *)eventName {
 	return @"Potato";
 }
 - (NSString *)localizedDescriptionForEventName:(NSString *)eventName {
 	NSString *description = @"";

 	if ([eventName isEqualToString:BTAVRCP_PotatoNext]) {
 		description = @"Bluetooth Next Button";
 	} else if ([eventName isEqualToString:BTAVRCP_PotatoPrevious]) {
 		description = @"Bluetooth Previous Button";
 	} else if ([eventName isEqualToString:BTAVRCP_PotatoPlayPause]) {
 		description = @"Bluetooth Play/Pause Button";
 	}

 	return description;
 }
 - (BOOL)eventWithNameIsHidden:(NSString *)eventName {
 	return NO;
 }
 - (BOOL)eventWithNameRequiresAssignment:(NSString *)eventName {
 	return NO;
 }
 - (BOOL)eventWithName:(NSString *)eventName isCompatibleWithMode:(NSString *)eventMode {
   return YES;
 }
 - (BOOL)eventWithNameSupportsUnlockingDeviceToSend:(NSString *)eventName {
 	return NO;
 }
@end
