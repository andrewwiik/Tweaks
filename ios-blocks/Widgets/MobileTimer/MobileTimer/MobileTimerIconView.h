//
//  MobileTimerIconView.h
//  MobileTimer
//
//  Created by Matt Clarke on 19/04/2015.
//
//

#import <UIKit/UIKit.h>

@interface MobileTimerIconView : UIView

@property (nonatomic, strong) CAShapeLayer *circle;
@property (nonatomic, strong) UIImageView *outerAlarmsArea;
@property (nonatomic, strong) UIImageView *innerClockHands;
@property (nonatomic, strong) UIView *circleBase;

-(void)changeToPercentage:(CGFloat)percentage;

@end
