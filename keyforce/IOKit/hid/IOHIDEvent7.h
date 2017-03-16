/*
 * iolate <iolate@me.com>
 * 2013. Oct. 5
 *
 * New classes, methods and enums on iOS7
 *
 * I have extracted only what I need.
 * So there are more undocumented classes in IOKit.
 *
 */

#ifndef IOKIT_HID_IOHIDEVENT_H_7
#define IOKIT_HID_IOHIDEVENT_H_7

#ifndef IOKIT_HID_IOHIDEVENT_H
#include <IOKit/hid/IOHIDEvent.h>
#endif

#if __cplusplus
extern "C" {
#endif
    
    uint64_t IOHIDEventGetSenderID(IOHIDEventRef event);
    void IOHIDEventSetSenderID(IOHIDEventRef event, uint64_t senderID);
    
    //Wrong
    //uint64_t IOHIDEventGetAttributeData(IOHIDEventRef event);
    //uint32_t IOHIDEventGetAttributeDataLength(IOHIDEventRef event);
    //void IOHIDEventSetAttributeData(IOHIDEventRef event, uint64_t attributeData);
    
#if __cplusplus
}
#endif

#endif
