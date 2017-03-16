//
//  BTAVRCP_ActivatorEvents.h
//
//
//  Created by Brian Olencki on 12/25/15.
//
//

#import <Foundation/Foundation.h>
#import "libactivator/libactivator.h"
#include <objc/runtime.h>

 static NSString *BTAVRCP_PotatoNext = @"com.creatix.potato.button.next";
 static NSString *BTAVRCP_PotatoPrevious = @"com.creatix.potato.button.previous";
 static NSString *BTAVRCP_PotatoPlayPause = @"com.creatix.potato.button.play";

@interface BTAVRCP_ActivatorEvents : NSObject <LAEventDataSource> {

}
+ (id)sharedInstance;
@end

// [[objc_getClass("LAActivator") sharedInstance] sendEventToListener:[LAEvent eventWithName:eventName mode:[[objc_getClass("LAActivator") sharedInstance] currentEventMode]]]

/*
 Used to call the event
*/
