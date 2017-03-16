#import "header/PSListController.h"
#import "header/PSSpecifier.h"
#import "header/PSViewController.h"
#import "header/PSTableCell.h"
#import "global.h"

#define TWEAK_NAME @"exsto"
#define TWEAK_BUNDLE_PATH [NSString stringWithFormat:@"/Library/PreferenceBundles/%@.bundle", TWEAK_NAME]

@interface FooterCell : PSTableCell {
    UIImageView *logoContainer;
}
@end

@implementation FooterCell

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (id)initWithSpecifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footerCell" specifier:specifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        int width = [[UIScreen mainScreen] bounds].size.width;
        CGRect frame = CGRectMake(0, 0, 80, 60);
        
        NSString *customImagePath = [NSString stringWithFormat:@"/Library/PreferenceBundles/%@.bundle/zalogo.png", TWEAK_NAME];
        log(customImagePath);
        if([[NSFileManager defaultManager] fileExistsAtPath:customImagePath])
        {
            log(@"file exists");
        }

        logoContainer = [[UIImageView alloc] initWithFrame:frame];
        logoContainer.image = [[UIImage alloc] initWithContentsOfFile:customImagePath];

        [logoContainer setCenter:CGPointMake(width / 2, logoContainer.center.y)];

        [self.contentView addSubview:logoContainer];
    }
    
    return self;
}

// - (CGFloat)preferredHeightForWidth:(double)arg1 inTableView:(id)arg2 {
//     return 90.0;
// }

@end
