#import <UIKit/UIKit.h>

#import "headers/BulletinBoard/BulletinBoard.h"
#import "headers/UIColor+Private.h"
#import "headers/UITableViewRowAction+Private.h"
#import "headers/SBWallpaperEffectView.h"
#import "NTXMaterialView.h"
#import "NTXVibrantStyling.h"
#import "NTXBackdropViewSettings.h"


@interface NTXNotificationListCellActionButton : UIControl {
    BOOL  _adjustsFontForContentSizeCategory;
    BOOL  _backgroundBlurred;
    UIView *_backgroundOverlayView;
    SBWallpaperEffectView *_backgroundView;
    UIView *_customBackgroundView;
    UITableViewRowAction *_notificationAction;
    NSString *_preferredContentSizeCategory;
    NSString *_title;
    UILabel *_titleLabel;
}

@property (nonatomic) BOOL adjustsFontForContentSizeCategory;
@property (getter=isBackgroundBlurred, nonatomic) BOOL backgroundBlurred;
@property (nonatomic, retain) UIView *backgroundOverlayView;
@property (nonatomic, retain) SBWallpaperEffectView *backgroundView;
@property (nonatomic, retain) UIView *customBackgroundView;
@property (nonatomic, retain) UITableViewRowAction *notificationAction;
@property (nonatomic, copy) NSString *preferredContentSizeCategory;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) UILabel *titleLabel;

- (void)_configureBackgroundOverlayViewIfNecessary;
- (void)_configureBackgroundViewIfNecessary;
- (void)_configureTitleLabelIfNecessary;
- (void)_highlightButton:(id)arg1;
- (void)_layoutBackgroundOverlayView;
- (void)_layoutBackgroundView;
- (void)_layoutTitleLabel;
- (void)_unHighlightButton:(id)arg1;
- (void)_updateTitleLabelFont;
- (long long)_wordCountForText:(NSString *)arg1;
- (BOOL)adjustForContentSizeCategoryChange;
- (BOOL)adjustsFontForContentSizeCategory;
- (UIView *)backgroundOverlayView;
- (SBWallpaperEffectView *)backgroundView;
- (UIView *)customBackgroundView;
- (instancetype)initWithFrame:(CGRect)arg1;
- (BOOL)isBackgroundBlurred;
- (void)layoutSubviews;
- (UITableViewRowAction *)notificationAction;
- (NSString *)preferredContentSizeCategory;
- (void)setAdjustsFontForContentSizeCategory:(BOOL)arg1;
- (void)setBackgroundBlurred:(BOOL)arg1;
- (void)setBackgroundOverlayView:(UIView *)arg1;
- (void)setBackgroundView:(SBWallpaperEffectView *)arg1;
- (void)setCustomBackgroundView:(UIView *)arg1;
- (void)setHighlighted:(BOOL)arg1;
- (void)setNotificationAction:(UITableViewRowAction *)arg1;
- (void)setTitle:(NSString *)arg1;
- (void)setTitleLabel:(UILabel *)arg1;
- (UILabel *)titleLabel;
- (void)traitCollectionDidChange:(id)arg1;
- (void)willMoveToSuperview:(id)arg1;

@end