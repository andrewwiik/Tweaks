#import <UIKit/UIView.h>

@class SBDeckSwitcherPageView, SBDisplayItem;

@interface SBDeckSwitcherItemContainer : UIView
@property(retain, nonatomic) SBDeckSwitcherPageView *pageView;
@property(nonatomic) double contentBlurRadiusProgress;
- (id)initWithFrame:(CGRect)frame displayItem:(id)displayItem delegate:(id)delegate;
- (void)_addIconSubview;
@end