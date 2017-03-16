//
//  MobileTimerIconView.m
//  MobileTimer
//
//  Created by Matt Clarke on 19/04/2015.
//
//

#import "MobileTimerIconView.h"
#import <objc/runtime.h>

@interface IBKResources : NSObject
+(NSString*)suffix;
@end

@implementation MobileTimerIconView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *base = [[UIView alloc] initWithFrame:self.bounds];
        base.backgroundColor = [UIColor clearColor];
        base.transform = CGAffineTransformMakeScale(0.75, 0.75);
        
        [self addSubview:base];
        
        NSString *clockHandsPath = [NSString stringWithFormat:@"/var/mobile/Library/Curago/Widgets/com.apple.mobiletimer/ClockHands%@", [objc_getClass("IBKResources") suffix]];
        
        self.innerClockHands = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:clockHandsPath]];
        self.innerClockHands.backgroundColor = [UIColor clearColor];
        
        self.circleBase = [[UIView alloc] initWithFrame:self.innerClockHands.frame];
        self.circleBase.backgroundColor = [UIColor clearColor];
        
        self.circle = [CAShapeLayer layer];
        self.circle.bounds = self.innerClockHands.bounds;
        self.circle.anchorPoint = CGPointMake(0, 0);
        self.circle.fillColor = [UIColor clearColor].CGColor;
        self.circle.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(1, 2.5, 28, 27.5)].CGPath;
        self.circle.strokeColor = [UIColor clearColor].CGColor;
        self.circle.contentsScale = [UIScreen mainScreen].scale;
        self.circle.shouldRasterize = NO;
        
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.frame = CGRectMake(1, 2.5, 28, 27.5);
        mask.fillColor = [[UIColor blackColor] CGColor];
        mask.fillRule = kCAFillRuleEvenOdd;
        mask.opacity = 0.0;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        /*CGPathMoveToPoint(path, nil, 14, 8);
        CGPathAddLineToPoint(path, nil, 14, 15);
        CGPathAddLineToPoint(path, nil, 9, 15);
        CGPathAddLineToPoint(path, nil, 9, 16);
        CGPathAddLineToPoint(path, nil, 15, 16);
        CGPathAddLineToPoint(path, nil, 15, 8);
        CGPathAddLineToPoint(path, nil, 14, 8);
        CGPathCloseSubpath(path);*/
        
        CGPathMoveToPoint(path, nil, 0, 0);
        CGPathAddLineToPoint(path, nil, 13.5, 0);
        CGPathAddLineToPoint(path, nil, 13.5, 4.5);
        CGPathAddLineToPoint(path, nil, 13.5, 13.5);
        CGPathAddLineToPoint(path, nil, 7.5, 13.5);
        CGPathAddLineToPoint(path, nil, 7.5, 14.5);
        CGPathAddLineToPoint(path, nil, 14.5, 14.5);
        CGPathAddLineToPoint(path, nil, 14.5, 4.5);
        CGPathAddLineToPoint(path, nil, 13.5, 4.5);
        CGPathAddLineToPoint(path, nil, 13.5, 0);
        CGPathAddLineToPoint(path, nil, mask.bounds.size.width, 0);
        CGPathAddLineToPoint(path, nil, mask.bounds.size.width, mask.bounds.size.height);
        CGPathAddLineToPoint(path, nil, 0, mask.bounds.size.height);
        CGPathAddLineToPoint(path, nil, 0, 0);
        CGPathCloseSubpath(path);
        
        mask.path = path;
        CGPathRelease(path);
        
        self.circle.mask = mask;
        
        [self.circleBase.layer insertSublayer:self.circle atIndex:0];
        
        NSString *alarmPath = [NSString stringWithFormat:@"/var/mobile/Library/Curago/Widgets/com.apple.mobiletimer/OuterAlarm%@", [objc_getClass("IBKResources") suffix]];
        
        self.outerAlarmsArea = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:alarmPath]];
        self.outerAlarmsArea.backgroundColor = [UIColor clearColor];
        self.outerAlarmsArea.alpha = 0.0;
        self.outerAlarmsArea.transform = CGAffineTransformMakeScale(0.0, 0.0);
        
        [base addSubview:self.outerAlarmsArea];
        [base addSubview:self.innerClockHands];
        
        [base addSubview:self.circleBase];
    }
    return self;
}

-(void)changeToPercentage:(CGFloat)percentage { // 0.0 to 1.0
    [UIView animateWithDuration:0.1 animations:^{
        self.circle.fillColor = [UIColor colorWithWhite:1.0 alpha:(percentage > 0 ? percentage : 0.0)*3].CGColor;
        self.outerAlarmsArea.transform = CGAffineTransformMakeScale((percentage > 0 ? percentage : 0.0), (percentage > 0 ? percentage : 0.0));
        
        if (percentage >= 1.0) {
            self.circleBase.transform = CGAffineTransformMakeScale(percentage, percentage);
        }
        
        [(CAShapeLayer*)self.circle.mask setOpacity:1.0];
        
        self.innerClockHands.alpha = (percentage > 0.5 ? 0.0 : 1.0);
        self.outerAlarmsArea.alpha = (percentage > 0.5 ? 1.0 : 0.0);
    }];
}

@end
