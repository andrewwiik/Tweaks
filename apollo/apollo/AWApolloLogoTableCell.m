#import "AWApolloLogoTableCell.h"

@implementation AWApolloLogoTableCell
@synthesize logoImageView;

- (id)init {

       self = [super initWithFrame:CGRectZero];
       
       if (self) {
            UIImage *logoImage = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/Apollo.bundle/images/footerLogo.png"];
            self.logoImageView = [[UIImageView alloc] initWithImage:logoImage];
            self.logoImageView.frame = CGRectMake(0,0,80,80);
            self.logoImageView.layer.shadowColor = [UIColor blackColor].CGColor;
            self.logoImageView.layer.shadowOffset = CGSizeMake(0, 1);
            self.logoImageView.layer.shadowOpacity = 0.2;
            self.logoImageView.layer.shadowRadius = 1.0;
            self.logoImageView.clipsToBounds = NO;
            [self addSubview:self.logoImageView];
            [self.logoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.logoImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    }

    return self;
}

@end