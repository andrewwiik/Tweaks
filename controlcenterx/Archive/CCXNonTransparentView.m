#import "CCXNonTransparentView.h"

@implementation CCXNonTransparentView

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    CGFloat alpha = CGColorGetAlpha(backgroundColor.CGColor);
    if (alpha != 0) {
        [super setBackgroundColor:backgroundColor];
    }
}

@end