//
//  IBKHeaderCell.m
//  curago
//
//  Created by Matt Clarke on 21/02/2015.
//
//

#import "IBKHeaderCell.h"

#define bundlePath @"/Library/PreferenceBundles/curago.bundle/"

static IBKHeaderCell *cell;

@implementation IBKHeaderCell

+(instancetype)sharedInstance {
    return cell;
}

- (id)initWithSpecifier:(PSSpecifier *)specifier {
    if (cell)
        return cell;
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell" specifier:specifier];
    if (self) {
        // Create the three icon portions, CKBlurView and also the ShimmerLabel
        
        self.backmostWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@HeaderImages/Blue.png", bundlePath]]];
        self.backmostWidget.frame = CGRectMake(0, 0, 100, 100);
        self.backmostWidget.backgroundColor = [UIColor clearColor];
        self.backmostWidget.alpha = 0.0;
        
        [self addSubview:self.backmostWidget];
        
        self.middleWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@HeaderImages/Green.png", bundlePath]]];
        self.middleWidget.frame = CGRectMake(0, 0, 100, 100);
        self.middleWidget.backgroundColor = [UIColor clearColor];
        self.middleWidget.alpha = 0.0;
        
        [self addSubview:self.middleWidget];
        
        self.foremostWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@HeaderImages/Red.png", bundlePath]]];
        self.foremostWidget.frame = CGRectMake(0, 0, 100, 100);
        self.foremostWidget.backgroundColor = [UIColor clearColor];
        self.foremostWidget.alpha = 0.0;
        
        [self addSubview:self.foremostWidget];
        
        self.blur = [[CKBlurView alloc] initWithFrame:self.bounds];
        self.blur.blurCroppingRect = self.bounds;
        self.blur.alpha = 0.0;
        
        [self addSubview:self.blur];
        
        self.shimmer = [[FBShimmeringView alloc] initWithFrame:self.bounds];
        self.shimmer.alpha = 0.0;
        self.shimmer.shimmeringBeginFadeDuration = 0.3;
        self.shimmer.shimmeringOpacity = 0.9;
        self.shimmer.shimmeringSpeed = 150;
        self.shimmer.shimmeringHighlightLength = 0.75;
        self.shimmer.shimmeringAnimationOpacity = 0.3;
        [self addSubview:self.shimmer];
        
        blocksLabel = [[UILabel alloc] initWithFrame:self.shimmer.bounds];
        blocksLabel.textAlignment = NSTextAlignmentCenter;
        blocksLabel.text = @"iOS Blocks";
        blocksLabel.textColor = [UIColor blackColor];
        blocksLabel.backgroundColor = [UIColor clearColor];
        blocksLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:45];
        blocksLabel.numberOfLines = 0;
        self.shimmer.contentView = blocksLabel;
        
        self.backgroundColor = [UIColor whiteColor];
        
        cell = self;
    }
    
    return self;
}

-(void)viewDidLoad {
    self.foremostWidget.alpha = 0.0;
    self.middleWidget.alpha = 0.0;
    self.middleWidget.transform = CGAffineTransformMakeRotation(0.0);
    self.backmostWidget.alpha = 0.0;
    self.backmostWidget.transform = CGAffineTransformMakeRotation(0.0);
    self.blur.alpha = 0.0;
    self.shimmer.alpha = 0.0;
    
    [UIView animateWithDuration:0.35 animations:^{
        self.foremostWidget.alpha = 1.0;
    }];
    
    [UIView animateWithDuration:0.35 delay:0.15 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.middleWidget.alpha = 1.0;
        self.middleWidget.transform = CGAffineTransformMakeRotation(0.261799388);
    } completion:nil];
    
    [UIView animateWithDuration:0.35 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backmostWidget.alpha = 1.0;
        self.backmostWidget.transform = CGAffineTransformMakeRotation(0.523598776);
    } completion:nil];
    
    [UIView animateWithDuration:0.45 delay:0.55 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.blur.alpha = 1.0;
        self.shimmer.alpha = 1.0;
    } completion:nil];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.foremostWidget.center = CGPointMake(self.bounds.size.width/2, (self.bounds.size.height/2) + 20);
    self.middleWidget.center = self.foremostWidget.center;
    self.backmostWidget.center = self.foremostWidget.center;
    
    self.blur.frame = CGRectMake(0, 10, self.bounds.size.width, self.bounds.size.height + 20);
    self.blur.blurCroppingRect = self.blur.bounds;
    
    self.blur.center = self.foremostWidget.center;
    
    self.shimmer.frame = CGRectMake(0, 15, self.bounds.size.width, self.bounds.size.height);
    blocksLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    self.shimmer.center = self.foremostWidget.center;
    
    self.shimmer.shimmering = YES;
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, -[UIScreen mainScreen].bounds.size.height, self.bounds.size.width, self.bounds.size.height + 40 + [UIScreen mainScreen].bounds.size.height)];
    bg.backgroundColor = [UIColor whiteColor];
    
    [self insertSubview:bg atIndex:0];
}

-(CGFloat)preferredHeightForWidth:(CGFloat)arg1{
    return 130.f;
}

@end
