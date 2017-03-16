//
//  IBKGameCenterTableCell.m
//  curago
//
//  Created by Matt Clarke on 10/02/2015.
//
//

#import "IBKGameCenterTableCell.h"
#import "IBKNotificationsTableCell.h"
#import <GameCenterFoundation/GKAchievementInternal.h>

@implementation IBKGameCenterTableCell

-(UIImage*)circularImage:(UIImage*)img inRect:(CGRect)rect {
    // This function returns a newImage, based on image, that has been:
    // - scaled to fit in (CGRect) rect
    // - and cropped within a circle of radius: rectWidth/2
    
    //Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = img.size.width;
    CGFloat imageHeight = img.size.height;
    CGFloat rectWidth = rect.size.width;
    CGFloat rectHeight = rect.size.height;
    
    //Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    //Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = (rectWidth/2)-2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    //Set the SCALE factor for the graphics context
    //All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [img drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)setupForDescriptionWithColor:(UIColor*)color {
    self.backgroundColor = [UIColor clearColor];
    
    if (!self.imgView) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 1, 23, 23)];
        self.imgView.backgroundColor = [UIColor clearColor];
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.imgView.center = CGPointMake(self.imgView.center.x, 15);
        
        [self addSubview:self.imgView];
    }
    
    if (!self.title) {
        self.title = [[MarqueeLabel alloc] initWithFrame:CGRectMake(34, 0, self.frame.size.width-62, 30) duration:5.0 andFadeLength:5.0f];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.textColor = ([IBKNotificationsTableCell isSuperviewColourationBright:color] ? [UIColor darkTextColor] : [UIColor whiteColor]);
        self.title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.5];
        self.title.numberOfLines = 1;
        self.title.alpha = 0.85;
        self.title.marqueeType = MLContinuous;
        self.title.trailingBuffer = 30;
        
        [self addSubview:self.title];
    }
    
    if (!self.pointCount) {
        self.pointCount = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-27, 0, 20, 30)];
        self.pointCount.backgroundColor = [UIColor clearColor];
        self.pointCount.textAlignment = NSTextAlignmentCenter;
        self.pointCount.textColor = ([IBKNotificationsTableCell isSuperviewColourationBright:color] ? [UIColor darkTextColor] : [UIColor whiteColor]);
        self.pointCount.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.5];
        self.pointCount.numberOfLines = 1;
        
        [self addSubview:self.pointCount];
    }
    
    // Begin setup.
    
    [self.desc loadImageWithCompletionHandler:^(UIImage *image, NSError *error) {
        if (!error) {
            self.imgView.image = [self circularImage:image inRect:CGRectMake(0, 0, 23, 23)];
        }
    }];
    
    self.title.text = self.desc.title;
    self.pointCount.text = [NSString stringWithFormat:@"%llu", self.desc.maximumPoints];
}

@end
