//
//  CornerHighlightView.m
//  test
//
//  Created by Brian Olencki on 11/28/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import "CornerHighlightView.h"

@implementation CornerHighlightView//view used to house the resize blue indicator
- (instancetype)initWithCorner:(CornerType)corner withTouchSize:(CGFloat)touchSize withFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        currentCorner = corner;
        currentTouchSize = touchSize;

        self.frame = frame;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];

        viewCorner = [[UIView alloc] init];//actual resize indicator
        viewCorner.backgroundColor = [UIColor blueColor];
        viewCorner.alpha = 0.5;
        viewCorner.layer.cornerRadius = touchSize/8;

        switch (currentCorner) { //set corner type
            case CornerTypeLL:
                [viewCorner setFrame:CGRectMake(0, frame.size.height-touchSize, touchSize, touchSize)];
                break;
            case CornerTypeLR:
                [viewCorner setFrame:CGRectMake(frame.size.width-touchSize, frame.size.height-touchSize, touchSize, touchSize)];
                break;
            case CornerTypeUR:
                [viewCorner setFrame:CGRectMake(frame.size.width-touchSize, 0, touchSize, touchSize)];
                break;
            case CornerTypeUL:
                [viewCorner setFrame:CGRectMake(0, 0, touchSize, touchSize)];
                break;

            default:
                break;
        }
        [self addSubview:viewCorner];
    }
    return self;
}
- (void)layoutSubviews { //resize view after movement
  switch (currentCorner) {
      case CornerTypeLL:
          [viewCorner setFrame:CGRectMake(0, self.frame.size.height-currentTouchSize, currentTouchSize, currentTouchSize)];
          break;
      case CornerTypeLR:
          [viewCorner setFrame:CGRectMake(self.frame.size.width-currentTouchSize, self.frame.size.height-currentTouchSize, currentTouchSize, currentTouchSize)];
          break;
      case CornerTypeUR:
          [viewCorner setFrame:CGRectMake(self.frame.size.width-currentTouchSize, 0, currentTouchSize, currentTouchSize)];
          break;
      case CornerTypeUL:
          [viewCorner setFrame:CGRectMake(0, 0, currentTouchSize, currentTouchSize)];
          break;

      default:
          break;
  }
}
@end
