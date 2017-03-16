//
//  CameraWidgetButton.m
//  Camera
//
//  Created by Matt Clarke on 20/04/2015.
//
//

#import "CameraWidgetButton.h"

@implementation CameraWidgetButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setupForIsVideo:(BOOL)video {
    self.isVideo = video;
    
    // Setup CALayers - we're definitely 50x50 points
    self.outerRing = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    self.outerRing.backgroundColor = [UIColor clearColor];
    self.outerRing.userInteractionEnabled = NO;
    
    [self addSubview:self.outerRing];
    
    CALayer *outerShape = [CALayer layer];
    outerShape.bounds = self.outerRing.bounds;
    outerShape.anchorPoint = CGPointMake(0, 0);
    outerShape.borderColor = [UIColor whiteColor].CGColor;
    outerShape.borderWidth = 3.5;
    outerShape.cornerRadius = self.outerRing.bounds.size.width/2;
    outerShape.contentsScale = [UIScreen mainScreen].scale;
    outerShape.shouldRasterize = NO;
    
    [self.outerRing.layer insertSublayer:outerShape atIndex:0];
    
    self.innerRing = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    self.innerRing.backgroundColor = [UIColor clearColor];
    self.innerRing.userInteractionEnabled = NO;
    
    [self addSubview:self.innerRing];
    
    CAShapeLayer *innerShape = [CAShapeLayer layer];
    innerShape.bounds = self.innerRing.bounds;
    innerShape.fillColor = (video ? [UIColor redColor].CGColor : [UIColor whiteColor].CGColor);
    innerShape.anchorPoint = CGPointMake(0, 0);
    innerShape.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(5, 5, self.outerRing.bounds.size.width-10, self.outerRing.bounds.size.height-10)].CGPath;
    innerShape.strokeColor = [UIColor clearColor].CGColor;
    innerShape.contentsScale = [UIScreen mainScreen].scale;
    innerShape.shouldRasterize = NO;
    
    [self.innerRing.layer insertSublayer:innerShape atIndex:0];
}

-(void)setIsExpanding:(BOOL)expanding {
    self.innerRing.hidden = (expanding ? YES : NO);
    self.outerRing.hidden = (expanding ? YES : NO);
}

-(void)layoutSubviews {
    self.innerRing.frame = self.bounds;
    self.outerRing.frame = self.bounds;
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    self.innerRing.alpha = (highlighted ? 0.3 : 1.0);
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.innerRing.alpha = (selected ? 0.3 : 1.0);
}

@end
