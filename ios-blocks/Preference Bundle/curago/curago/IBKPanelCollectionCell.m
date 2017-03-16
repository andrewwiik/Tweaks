//
//  IBKPanelCollectionCell.m
//  curago
//
//  Created by Matt Clarke on 22/02/2015.
//
//

#import "IBKPanelCollectionCell.h"

#define bundlePath @"/Library/PreferenceBundles/curago.bundle/"

@implementation IBKPanelCollectionCell

- (CAGradientLayer*)gradientFrom:(UIColor*)from to:(UIColor*)to {
    
    UIColor *colorOne = from;
    UIColor *colorTwo = to;
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)initialiseWithImageName:(NSString*)imgName andTitle:(NSString*)title andIndex:(int)index {
    self.layer.cornerRadius = 12.5;
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowOffset = CGSizeZero;
    
    // Modify sublayers.
    
    UIColor *from;
    UIColor *to;
    
    switch (index) {
        case 0:
            from = [UIColor colorWithRed:(232.0/255.0) green:(5.0/255.0) blue:(5.0/255.0) alpha:0.35];
            to = [UIColor colorWithRed:(232.0/255.0) green:(144.0/255.0) blue:(5.0/255.0) alpha:0.35];
            break;
            
        case 1:
            from = [UIColor colorWithRed:(232.0/255.0) green:(101.0/255.0) blue:(5.0/255.0) alpha:0.35];
            to = [UIColor colorWithRed:(232.0/255.0) green:(213.0/255.0) blue:(5.0/255.0) alpha:0.35];
            break;
            
        case 2:
            from = [UIColor colorWithRed:(33.0/255.0) green:(200.0/255.0) blue:(16.0/255.0) alpha:0.35];
            to = [UIColor colorWithRed:(169.0/255.0) green:(219.0/255.0) blue:(89.0/255.0) alpha:0.35];
            break;
            
        case 3:
            from = [UIColor colorWithRed:(16.0/255.0) green:(120.0/255.0) blue:(200.0/255.0) alpha:0.35];
            to = [UIColor colorWithRed:(33.0/255.0) green:(200.0/255.0) blue:(16.0/255.0) alpha:0.35];
            break;
        default:
            break;
     }
    
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = CGColorCreateCopyWithAlpha(from.CGColor, 0.35);
    
    CAGradientLayer *bgLayer = [self gradientFrom:from to:to];
    bgLayer.frame = self.bounds;
    
    if (!self.bgView) {
        self.bgView = [[UIView alloc] initWithFrame:self.bounds];
        self.bgView.backgroundColor = [UIColor clearColor];
        
        self.bgView.layer.cornerRadius = 12.5;
        self.bgView.layer.masksToBounds = YES;
        
        [self addSubview:self.bgView];
    }
    
    [self.bgView.layer insertSublayer:bgLayer atIndex:0];
    
    if (!self.highlight) {
        self.highlight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.highlight.backgroundColor = [UIColor grayColor];
        self.highlight.alpha = 0.0;
        
        self.highlight.layer.cornerRadius = 12.5;
        
        [self addSubview:self.highlight];
    }
    
    if (!self.img) {
        // get suffix.
        self.img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        self.img.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.img];
    }
    
    NSString *suffix = @"";
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (scale >= 2.0 && scale < 3.0) {
        suffix = [suffix stringByAppendingString:@"@2x.png"];
    } else if (scale >= 3.0) {
        suffix = [suffix stringByAppendingString:@"@3x.png"];
    } else if (scale < 2.0) {
        suffix = [suffix stringByAppendingString:@".png"];
    }
    
    UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@%@", bundlePath, imgName, suffix]];
    self.img.image = img;
    
    if (!self.title) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.textColor = [UIColor darkTextColor];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.numberOfLines = 0;
        self.title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        
        [self addSubview:self.title];
    }
    
    self.title.text = title;
    [self.title sizeToFit];
}

-(void)setHighlighted:(BOOL)highlighted {
    [UIView animateWithDuration:0.15 animations:^{
        self.highlight.alpha = (highlighted ? 0.25 : 0.0);
    }];
}

-(void)dealloc {
    [self.title removeFromSuperview];
    self.title = nil;
    
    [self.img removeFromSuperview];
    self.img = nil;
    
    [self.highlight removeFromSuperview];
    self.highlight = nil;
    
    [self.bgView removeFromSuperview];
    self.bgView = nil;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.img.center = CGPointMake(self.bounds.size.width/2, 50);
    self.title.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height - 40);
    
    self.highlight.frame = self.bounds;
    
    self.bgView.frame = self.bounds;
}

@end
