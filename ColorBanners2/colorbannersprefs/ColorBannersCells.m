#import "ColorBannersPrefs.h"

@implementation ColorBannersHeaderCell

- (instancetype)initWithStyle:(int)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

  if (self) {
    self.backgroundColor = [UIColor clearColor];

    CGFloat width = self.contentView.bounds.size.width;
    CGRect titleFrame = CGRectMake(0, 20, width, 55);
    CGRect subtitleFrame = CGRectMake(0, 75, width, 19);

    _titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:48];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.text = @"ColorBanners";
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _titleLabel.contentMode = UIViewContentModeScaleToFill;

    _subtitleLabel = [[UILabel alloc] initWithFrame:subtitleFrame];
    _subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    _subtitleLabel.text = @"By David Goldman";
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    _subtitleLabel.textColor = [UIColor grayColor];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _subtitleLabel.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_subtitleLabel];
  }
  return self;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
  return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CBRHeaderCell" specifier:specifier];
}

- (void)setFrame:(CGRect)frame {
  // Fix for iPad.
  frame.origin.x = 0;
  [super setFrame:frame];
}

- (void)dealloc {
  [_titleLabel release];
  [_subtitleLabel release];
  [super dealloc];
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
  return 120.0;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width inTableView:(id)tableView {
  return [self preferredHeightForWidth:width];
}

@end
