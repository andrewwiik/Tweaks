#import "AWApolloCustomHeaderView.h"
#import "AWApolloPreferences.h"

@implementation AWApolloCustomHeaderView
@synthesize headerLabel,subHeaderLabel,randomLabel;

- (id)init {

	   self = [super initWithFrame:CGRectZero];
	   
       if (self) {
 
            self.headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.headerLabel setNumberOfLines:1];
            [self.headerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:iPad ? 44 : 36]];
            [self.headerLabel setText:@"Apollo"];
            [self.headerLabel setBackgroundColor:[UIColor clearColor]];
            [self.headerLabel setTextColor:[UIColor grayColor]];
            [self.headerLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.headerLabel];
            [self.headerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.2 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
            self.subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.subHeaderLabel setNumberOfLines:1];
            [self.subHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:iPad ? 22 : 17]];
            [self.subHeaderLabel setText:@"Enhance your Music Experience"];
            [self.subHeaderLabel setBackgroundColor:[UIColor clearColor]];
            [self.subHeaderLabel setTextColor:[UIColor grayColor]];
            [self.subHeaderLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.subHeaderLabel];
            [self.subHeaderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subHeaderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headerLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.subHeaderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

            self.randomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [self.randomLabel setNumberOfLines:1];
            [self.randomLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
            [self.randomLabel setText:self.randomTexts[arc4random_uniform(self.randomTexts.count)]];
            [self.randomLabel setBackgroundColor:[UIColor clearColor]];
            [self.randomLabel setTextColor:[UIColor grayColor]];
            [self.randomLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:self.randomLabel];
            [self.randomLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.randomLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.subHeaderLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.randomLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

    }

    return self;
}

-(NSArray *)randomTexts {
    return @[@"Thank you for the support.",@"Enjoy!",@"Made by Andrew Wiik",@"Follow me on Twitter, @andywiik"];
}

@end