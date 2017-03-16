#import <Preferences/PSListController.h>
#import <UIKit/UIKit.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@class GADBannerView;
@interface BNARootListController : PSListController <GADBannerViewDelegate>
@property(nonatomic, strong) GADBannerView *bannerView;
@end
