//
//  QCRPersonCell.m
//  test
//
//  Created by Brian Olencki on 3/9/16.
//  Copyright © 2016 bolencki13. All rights reserved.
//

#import "QCRPersonCell.h"

@implementation QCRPersonCell
@synthesize name = _name, detailText = _detailText, icon = _icon, information = _information, twitter = _twitter, facebook = _facebook, github = _github, website = _website, country = _country, email = _email;
+ (UIColor*)defaultDetailTextColor {
    int value = 0x7F7F7F;
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0];
}
+ (CGFloat)defaultCellHeight {
    return 55;
}
- (nonnull instancetype)initWithName:(nonnull NSString*)name reuseIdentifier:(nonnull NSString *)reuseIdentifier {
    if (self == [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        _name = name;
        _detailText = @"Detail Text";
        
        self.textLabel.text = _name;
        self.detailTextLabel.text = _detailText;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.textLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.textColor = [QCRPersonCell defaultDetailTextColor];
//        self.textLabel.font = [UIFont fontWithName:@"SFUI-Regular" size:17.0];
//        [self.detailTextLabel setFont:[UIFont fontWithName:@"SFUI-Regular" size:12.0]];
        
        self.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - Overrides
- (void)setName:(NSString *)name {
    _name = name;
    self.textLabel.text = _name;
}
- (void)setDetailText:(NSString *)detailText {
    _detailText = detailText;
    self.detailTextLabel.text = _detailText;
}
- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    self.imageView.image = _icon;
}
- (void)setIconLarge:(UIImage *)iconLarge {
    _iconLarge = iconLarge;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 55);
    NSInteger image_Height = 40;
    self.imageView.frame = CGRectMake(12, (self.frame.size.height-image_Height)/2, image_Height, image_Height);
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2;

    self.textLabel.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 12, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, 20.5);
    self.detailTextLabel.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 12, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, 14.5);
    self.separatorInset = UIEdgeInsetsMake(0,self.textLabel.frame.origin.x,0,0);
}
@end
