#import "PreferenceHeaders.h"

@interface ColorBannersPrefsListController : PSListController
@end

@interface ColorBannersBannerPrefsController : PSListController {
  NSMutableArray *_constantColorSpecifiers;
  NSArray *_liveAnalysisSpecifiers;
}
@end

@interface ColorBannersLSPrefsController : PSListController {
  NSMutableArray *_constantColorSpecifiers;
}
@end

@interface ColorBannersNCPrefsController : PSListController {
  NSMutableArray *_constantColorSpecifiers;
}
@end

@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(id)specifier;
@optional
- (CGFloat)preferredHeightForWidth:(CGFloat)width;
- (CGFloat)preferredHeightForWidth:(CGFloat)width inTableView:(id)tableView;
@end

@interface ColorBannersHeaderCell : PSTableCell <PreferencesTableCustomView> {
  UILabel *_titleLabel;
  UILabel *_subtitleLabel;
}
@end
