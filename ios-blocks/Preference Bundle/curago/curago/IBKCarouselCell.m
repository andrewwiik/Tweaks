//
//  IBKCarouselCell.m
//  curago
//
//  Created by Matt Clarke on 25/02/2015.
//
//

#import "IBKCarouselCell.h"

@implementation IBKCarouselCell

- (id)initWithSpecifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carouselCell" specifier:specifier];
    if (self) {
        // Initialization code
        self.contr = [[IBKCarouselController alloc] initWithNibName:nil bundle:nil];
        
        [self addSubview:self.contr.view];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contr.view.frame = CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height-30);
    self.contr.carousel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-30);
    
    UIView *triangle = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20)];
    triangle.backgroundColor = [UIColor whiteColor];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:(CGPoint){0, 0}];
    [path addLineToPoint:(CGPoint){triangle.frame.size.width, 0}];
    [path addLineToPoint:(CGPoint){triangle.frame.size.width, 20}];
    [path addLineToPoint:(CGPoint){(triangle.frame.size.width/2) + 15, 20}];
    [path addLineToPoint:(CGPoint){(triangle.frame.size.width/2), 5}];
    [path addLineToPoint:(CGPoint){(triangle.frame.size.width/2) - 15, 20}];
    [path addLineToPoint:(CGPoint){0, 20}];
    [path addLineToPoint:(CGPoint){0, 0}];
    
    // Create a CAShapeLayer with this triangular path
    // Same size as the original imageView
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.frame = triangle.bounds;
    mask.path = path.CGPath;
    
    // Mask the imageView's layer with this shape
    triangle.layer.mask = mask;
    
    [self addSubview:triangle];
}

-(CGFloat)preferredHeightForWidth:(CGFloat)arg1{
    return 190;
}

-(void)dealloc {
    [self.contr.view removeFromSuperview];
    [self.contr removeFromParentViewController];
    
    self.contr = nil;
}

@end
