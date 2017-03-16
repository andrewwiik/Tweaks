/*
 * iolate <iolate@me.com>
 * 2013. Oct. 5
 *
 * New classes, methods and enums on iOS7
 *
 * I have extracted only what I need.
 * So there are more undocumented classes in IOKit.
 *
 * IOHIDEventSystemConnection is new class on iOS7
 *
 */

#ifndef IOHID_EVENT_SYSTEM_CONNECTION_H
#define IOHID_EVENT_SYSTEM_CONNECTION_H

#ifndef IOKIT_HID_IOHIDEVENT_H
#include <IOKit/hid/IOHIDEvent.h>
#endif

#if __cplusplus
extern "C" {
#endif

    typedef struct __IOHIDEventSystemConnection
    * IOHIDEventSystemConnectionRef;
    
    void IOHIDEventSystemConnectionDispatchEvent(IOHIDEventSystemConnectionRef systemConnection, IOHIDEventRef event);
    int IOHIDEventSystemConnectionGetType(IOHIDEventSystemConnectionRef systemConnection);
    
#if __cplusplus
}
#endif

#endif