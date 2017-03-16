//
//  UIImage+UIImageAverageColorAddition.h
//  AvgColor
//
//  Created by nikolai on 28.08.12.
//  Copyright (c) 2012 Savoy Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageAverageColorAddition)

- (UIColor *)averageColor;
- (UIColor *)mergedColor;
- (UIColor *)dominantColor;

@end
