#import "NTXVibrantStyling.h"
#import "NTXMaterialView.h"
#import "NTXBackdropViewSettings.h"
#import "NTXNotificationListCellActionButton.h"
#import "UIImage+Extra.h"
#import "headers/_UIBackdropView.h"
#import "headers/SBWallpaperEffectView.h"
#import "headers/UIFont+Private.h"
#import "headers/SBAwayBulletinListItem.h"
#import "headers/SBLockScreenNotificationCell.h"
#import "headers/NCRelativeDateLabel.h"
#import "headers/SBLockScreenNotificationListView.h"
#import "headers/UITableViewRowAction+Private.h"
#import "headers/NSBlock.h"


#if __cplusplus
extern "C" {
#endif

	CFSetRef SBSCopyDisplayIdentifiers();
	NSString * SBSCopyLocalizedApplicationNameForDisplayIdentifier(NSString *identifier);

#if __cplusplus
}
#endif

@interface NTXModernNotificationView : UIView <UIGestureRecognizerDelegate, UIScrollViewDelegate> {
	UILabel *_dateLabel;
	UILabel *_appLabel;
	UILabel *_primaryLabel;
	UILabel *_primarySubtitleLabel;
	UILabel *_secondaryLabel;
	UILabel *_hintLabel;
	UIImageView *_iconView;
	UIImageView *_thumbnailView;
	UIView *_notificationView;
	NTXMaterialView *_headerView;
	UIView *_contentView;
	NTXBackdropViewSettings *_backdropSettings;
	SBWallpaperEffectView *_backdropView;
	SBWallpaperEffectView *_actionsClippingBackgroundView;
	BOOL _addedConstraints;
	BOOL _updateHeight;
	CGFloat _calculatedHeight;
	unsigned long long _maxMessageLines;
	NSLayoutConstraint *_contentViewHeightConstraint;
	NSLayoutConstraint *_contentViewPaddingConstraint;
	NSLayoutConstraint *_hintLabelTopConstraint;
	NSLayoutConstraint *_notificationViewLeftConstraint;
	NSLayoutConstraint *_actionViewWidthConstraint;
	NSMutableArray *_rightSideConstraints;
	SBAwayBulletinListItem *_listItem;
	NSString *_hintLabelText;
	BOOL _hintIsShowing;
	CGFloat _panningX;
	CGFloat _startingPoint;
	UIView *_actionsView;
	UIView *_actionsClippingView;
	UIScrollView *_contentScrollView;
	NSArray *_actions;
	BOOL _isPanning;
	CGFloat _lastChange;
	CGPoint _initialContentOffset;
}

@property (nonatomic, retain) NCRelativeDateLabel *syncDateLabel;
@property (nonatomic, retain) UIPanGestureRecognizer *revealGesture;
@property (nonatomic) UIEdgeInsets insetMargins;
@property (nonatomic, retain) UIView *clippingRevealView;
@property (nonatomic, retain) UIScrollView *cellScrollView;
- (id)init;
- (void)setAppName:(NSString *)name;
- (void)setIconImage:(UIImage *)icon;
- (void)setPrimaryText:(NSString *)text;
- (void)setPrimarySubtitleText:(NSString *)text;
- (void)setSecondaryText:(NSString *)text;
- (void)setHintText:(NSString *)text;
- (void)setThumbnailImage:(UIImage *)image;
- (void)setListItem:(SBAwayBulletinListItem *)item withActions:(NSArray *)actions;
- (BOOL)hasAddedConstraints;
- (void)addConstraintsNow;
- (void)showHintLabel:(BOOL)shouldShow;
- (void)updateHeight;
- (CGFloat)alphaForPercentRevealed:(CGFloat)percent;
- (void)closeActionsView;

// Scroll View
// - (void)setInitialContentOffset:(CGPoint)offset;
// - (void)_configureInitialContentOffset;

// - (void)scrollViewDidScroll:(UIScrollView *)scrollView;
// - (CGFloat)_defaultActionExecuteThreshold;
// - (BOOL)supportsSwipeToDefaultAction;
// - (CGFloat)_defaultActionOvershootContentOffset;
// - (CGFloat)_logicalContentOffsetForAbsoluteOffset:(CGPoint)offset;
// - (CGFloat)_defaultActionTriggerThreshold;
// - (CGPoint)_absoluteContentOffsetForLogicalOffset:(CGFloat)offset;

- (void)updateDate:(NCRelativeDateLabel *)label;
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

- (SBAwayBulletinListItem *)listItem;

+ (UIFont *)primaryLabelFont;
+ (UIFont *)secondaryLabelFont;
+ (UIFont *)hintLabelFont;
+ (UIFont *)appLabelFont;
+ (UIFont *)dateLabelFont;
+ (UIFont *)primarySubtitleLabelFont;


@end