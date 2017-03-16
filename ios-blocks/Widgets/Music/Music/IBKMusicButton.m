//
//  IBKMusicButton.m
//  Music
//
//  Created by Matt Clarke on 05/02/2015.
//
//

#import "IBKMusicButton.h"

@implementation IBKMusicButton

UIImage* applyMask(UIImage* image) {
    const CGSize  size = image.size;
    const CGRect  bnds = CGRectMake(0.0, 0.0, size.width, size.height);
    UIColor*      colr = nil;
    UIImage*      copy = nil;
    CGContextRef  ctxt = NULL;
    
    // this is the mask color
    colr = [[UIColor alloc] initWithWhite:0 alpha:0.46];
    
    // begin image context
    if (&UIGraphicsBeginImageContextWithOptions == NULL) {
        UIGraphicsBeginImageContext(bnds.size);
    }
    else
    {
        UIGraphicsBeginImageContextWithOptions(bnds.size, FALSE, 0.0);
    }
    ctxt = UIGraphicsGetCurrentContext();
    
    // transform CG* coords to UI* coords
    CGContextTranslateCTM(ctxt, 0.0, bnds.size.height);
    CGContextScaleCTM(ctxt, 1.0, -1.0);
    
    // draw original image
    CGContextDrawImage(ctxt, bnds, image.CGImage);
    
    // draw highlight overlay
    CGContextClipToMask(ctxt, bnds, image.CGImage);
    CGContextSetFillColorWithColor(ctxt, colr.CGColor);
    CGContextFillRect(ctxt, bnds);
    
    // finish image context
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.display = [[UIImageView alloc] initWithImage:nil];
        self.display.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.display];
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.display.frame = self.bounds;
}

-(void)setHighlighted:(BOOL)highlighted {
    // Grab image!
    if (highlighted) {
        for (UIImageView *view in self.subviews) {
            if ([[view class] isEqual:[UIImageView class]] && !self.prevImage) {
                self.prevImage = [view.image copy];
                
                view.image = applyMask(view.image);
            }
        }
    } else {
        for (UIImageView *view in self.subviews) {
            if ([[view class] isEqual:[UIImageView class]]) {
                view.image = self.prevImage;
                
                self.prevImage = nil;
            }
        }
    }
}

@end
