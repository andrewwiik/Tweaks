#import <UIKit/UIKit.h>
 
//static UIAlertView *alert;
NSString *type = nil;
NSString *subtype = nil;
 
%hook UIResponder
-(void)remoteControlReceivedWithEvent:(UIEvent *)remoteevent {
 
switch(remoteevent.subtype) {
        case UIEventSubtypeNone:
             subtype = @"UIEventSubtypeNone";
             break;
        case UIEventSubtypeMotionShake:
             subtype = @"UIEventSubtypeMotionShake";
             break;
        case UIEventSubtypeRemoteControlPlay:
             subtype = @"UIEventSubtypeRemoteControlPlay";
             break;
        case UIEventSubtypeRemoteControlPause:
             subtype = @"UIEventSubtypeRemoteControlPause";
             break;
        case UIEventSubtypeRemoteControlStop:
             subtype = @"UIEventSubtypeRemoteControlStop";
             break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
             subtype = @"UIEventSubtypeRemoteControlTogglePlayPause";
             break;
        case UIEventSubtypeRemoteControlNextTrack:
             subtype = @"UIEventSubtypeRemoteControlNextTrack";
             break;
        case UIEventSubtypeRemoteControlPreviousTrack:
             subtype = @"UIEventSubtypeRemoteControlPreviousTrack";
             break;
        case UIEventSubtypeRemoteControlBeginSeekingBackward:
             subtype = @"UIEventSubtypeRemoteControlBeginSeekingBackward";
             break;
        case UIEventSubtypeRemoteControlEndSeekingBackward:
             subtype = @"UIEventSubtypeRemoteControlEndSeekingBackward";
             break;
        case UIEventSubtypeRemoteControlBeginSeekingForward:
             subtype = @"UIEventSubtypeRemoteControlBeginSeekingForward";
             break;
        case UIEventSubtypeRemoteControlEndSeekingForward:
             subtype = @"UIEventSubtypeRemoteControlEndSeekingForward";
             break;
        default:
             subtype = @"unknown";
    }
 
 
switch(remoteevent.type) {
        case UIEventTypeTouches:
             type = @"UIEventTypeTouches";
             break;
        case UIEventTypeMotion:
             type = @"UIEventTypeMotion";
             break;
        case UIEventTypeRemoteControl:
             type = @"UIEventTypeRemoteControl";
             break;
        default:
             type = @"unknown";
    }
if([type isEqualToString:@"UIEventTypeRemoteControl"] && [subtype isEqualToString:@"UIEventSubtypeRemoteControlTogglePlayPause"]) {
}
else {
}
 
}
%end
%hook SBMediaController

-(BOOL)togglePlayPause {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ActivatorPopup" message:@"You activated this popup!" delegate:nil cancelButtonTitle:@"Cool" otherButtonTitles:nil];
    [alert show];
    [alert release];
    return %orig;
}
%end
%hook BluetoothManager
- (void)_postNotification:(id)arg1 {
}
%end