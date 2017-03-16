//
//  CornerHighlightView.h
//  test
//
//  Created by Brian Olencki on 11/28/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CornerTypeLL,
    CornerTypeLR,
    CornerTypeUR,
    CornerTypeUL
} CornerType;

@interface CornerHighlightView : UIView {
  CornerType currentCorner;
  CGFloat currentTouchSize;

  UIView *viewCorner;
}
- (instancetype)initWithCorner:(CornerType)corner withTouchSize:(CGFloat)touchSize withFrame:(CGRect)frame;
@end