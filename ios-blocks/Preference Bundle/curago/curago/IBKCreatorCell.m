//
//  IBKCreatorCell.m
//  curago
//
//  Created by Matt Clarke on 18/03/2015.
//
//

#import "IBKCreatorCell.h"

@implementation IBKCreatorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, 75, 75);
    self.imageView.center = CGPointMake(self.textLabel.frame.origin.x / 2, self.frame.size.height / 2);
}

@end
