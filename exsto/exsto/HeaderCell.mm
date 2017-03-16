#import "header/PSListController.h"
#import "header/PSSpecifier.h"
#import "header/PSViewController.h"
#import "header/PSTableCell.h"

@interface HeaderCell : PSTableCell {
    UILabel *heading;
    UILabel *subtitle;
}
@end

@implementation HeaderCell

- (void)layoutSubviews {
    [super layoutSubviews];
    heading.frame = CGRectMake(0, 0, self.frame.size.width, 60);
    subtitle.frame = CGRectMake(0, 40, self.frame.size.width, 60);
}

- (id)initWithSpecifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell" specifier:specifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        int width = [[UIScreen mainScreen] bounds].size.width;
        
        CGRect frame = CGRectMake(0, 0, width, 60);
        CGRect subFrame = CGRectMake(0, 35, width, 60);
        
        heading = [[UILabel alloc] initWithFrame:frame];
        [heading setNumberOfLines:1];
        heading.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:48];
        [heading setText:@"Exsto"];
        [heading setBackgroundColor:[UIColor clearColor]];
        heading.textColor = [UIColor blackColor];
        heading.textAlignment = NSTextAlignmentCenter;
        
        subtitle = [[UILabel alloc] initWithFrame:subFrame];
        [subtitle setNumberOfLines:1];
        subtitle.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18];
        [subtitle setText:@"Unleash your folders."];
        [subtitle setBackgroundColor:[UIColor clearColor]];
        subtitle.textColor = [UIColor blackColor];
        subtitle.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:heading];
        [self.contentView addSubview:subtitle];
    }
    
    return self;
}

- (CGFloat)preferredHeightForWidth:(double)arg1 inTableView:(id)arg2 {
    return 90.0;
}

@end
