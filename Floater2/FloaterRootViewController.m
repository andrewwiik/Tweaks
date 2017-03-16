//
//  FloaterRootViewController.m
//
//
//  Created by Brian Olencki on 12/25/15.
//
//

#import "FloaterRootViewController.h"
#import "Floater.h"

@interface FloaterRootViewController ()

@end

@implementation FloaterRootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if ([super respondsToSelector:@selector(motionEnded:withEvent:)]) {
        [super motionEnded:motion withEvent:event];
    }
    if (event.subtype == UIEventSubtypeMotionShake) {
      NSArray *aryTemp = [Floater getInstances];
      for (id item in aryTemp) {
        if ([item isMemberOfClass:[Floater class]]) {
         [UIView animateWithDuration:0.5 animations:^{
             [item setPosition:CGPointMake([item floaterClosedSize].width/2, ([item floaterClosedSize].height/3*2)*([aryTemp indexOfObject:item]+2))];
         }];
        }
      }
    }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
@end
