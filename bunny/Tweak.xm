#import <substrate.h>
#import "interface.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MobileGestalt/MobileGestalt.h>
#include <spawn.h>

%hook EKFeatureSet
+ (BOOL)areQuickActionsSupported {
   return YES;
}
- (BOOL)areQuickActionsSupported {
   return YES;
}
%end

%hook SBSApplicationShortcutSystemIcon
%new
- (NSString*)sb_imageName {
    NSString* subType = nil;
    switch ([self type])
    {
        case 0:
            subType = @"ComposeNew";
            break;
        case 1:
            subType = @"Play";
            break;
        case 2:
            subType = @"Pause";
            break;
        case 3:
            subType = @"Add";
            break;
        case 4:
            subType = @"Location";
            break;
        case 5:
            subType = @"Search";
            break;
        case 6:
            subType = @"Share";
            break;
        default:
            return nil;
            break;
   }
   return [NSString stringWithFormat:@"SBSApplicationShortcutSystemIcon_%@-OrbHW", subType];
}
%end

%ctor {
  %init;
}





