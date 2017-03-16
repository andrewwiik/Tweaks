// Test notifications (see PriorityHub and TinyBar).
@class CBRReadabilityManager;

@interface SBLockScreenViewController : UIViewController
@end

@interface SBLockScreenManager : NSObject
@property(readonly, assign, nonatomic) SBLockScreenViewController *lockScreenViewController;

+ (id)sharedInstance;
- (void)lockUIFromSource:(int)arg1 withOptions:(id)arg2;
@end

@interface BBAction : NSObject
+ (id)action;
+ (id)actionWithLaunchURL:(id)url;
@end

@interface BBBulletin
@property(copy, nonatomic) NSString *sectionID;
@property(copy, nonatomic) NSString *title;
@property(copy, nonatomic) NSString *subtitle;
@property(copy, nonatomic) NSString *message;
@property(copy, nonatomic) BBAction *defaultAction;
@property(retain, nonatomic) NSDate *date;
@property(retain, nonatomic) NSDate *publicationDate;
@property(retain, nonatomic) NSDate *lastInterruptDate;
@property(copy, nonatomic) NSString *bulletinID;
@property(assign, nonatomic) BOOL clearable;
@property(assign, nonatomic) BOOL showsMessagePreview;
@end

@interface BBBulletinRequest : BBBulletin
@end

@interface BBServer : NSObject
- (id)_sectionInfoForSectionID:(NSString *)sectionID effective:(BOOL)effective;
- (void)publishBulletin:(BBBulletin *)bulletin destinations:(NSUInteger)dests alwaysToLockScreen:(BOOL)lock;
@end


@interface SBLockScreenNotificationListController : NSObject
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(NSUInteger)arg3 playLightsAndSirens:(BOOL)arg4 withReply:(id)arg5;
@end

@interface SBBulletinBannerController : NSObject
+ (id)sharedInstance;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(NSUInteger)arg3;
- (void)observer:(id)arg1 addBulletin:(id)arg2 forFeed:(NSUInteger)arg3 playLightsAndSirens:(BOOL)arg4 withReply:(id)arg5;
@end

@interface SBBannerController : NSObject
+ (id)sharedInstance;

- (id)_bannerContext;
- (void)_replaceIntervalElapsed;
- (void)_dismissIntervalElapsed;
@end

// Respringing.

@interface SpringBoard : UIApplication
- (void)_relaunchSpringBoardNow;
@end
@interface FBSystemService : NSObject
+ (id)sharedInstance;

- (void)exitAndRelaunch:(BOOL)unknown;
@end

// Lockscreen Notifications.

@interface SBAwayBulletinListItem : NSObject
@property(retain) BBBulletin *activeBulletin;

- (id)iconImage;
@end

@interface UITableViewCellDeleteConfirmationView : UIView
@end

@interface SBTableViewCellDismissActionButton : UIView
@property(assign, nonatomic) BOOL drawsBottomSeparator;
@property(assign, nonatomic) BOOL drawsTopSeparator;
@end
@interface SBTableViewCellDismissActionButton(ColorBanners)
- (void)colorize:(int)color;
@end

@interface SBLockScreenBulletinCell : UIView
@property(retain, nonatomic) UIColor *eventDateColor;
@property(retain, nonatomic) UIColor *relevanceDateColor;
@property(retain, nonatomic) UIColor *secondaryTextColor;
@property(retain, nonatomic) UIColor *subtitleTextColor;
@property(retain, nonatomic) UIColor *primaryTextColor;

@property(retain, nonatomic) UILabel *eventDateLabel;
@property(retain, nonatomic) UILabel *relevanceDateLabel;
@property(readonly, nonatomic) UIView *realContentView;

+ (id)defaultColorForEventDate;
+ (id)defaultColorForRelevanceDate;
+ (id)defaultColorForSecondaryText;
+ (id)defaultColorForSubtitleText;
+ (id)defaultColorForPrimaryText;

- (id)_vibrantTextColor;
- (UITableViewCellDeleteConfirmationView *)_swipeToDeleteConfirmationView;
@end
@interface SBLockScreenBulletinCell(ColorBanners)
- (void)revertIfNeeded;
- (void)refreshAlphaAndVibrancy;
- (void)colorize:(int)color;
- (void)colorizeBackground:(int)color;
- (void)colorizeText:(int)color;

- (NSNumber *)cbr_color;
- (void)cbr_setColor:(NSNumber *)color;
@end

// Banners.

@interface SBBulletinBannerItem : NSObject
- (id)iconImage;
- (BBBulletin *)seedBulletin;
@end

@interface SBLockScreenNotificationBannerItem
@property(readonly, assign, nonatomic) SBAwayBulletinListItem *listItem;

- (id)iconImage;
@end

@interface SBDefaultBannerView : UIView
- (void)setColor:(id)color forElement:(int)element;
- (void)_setRelevanceDateColor:(id)color;
@end

@interface SBDefaultBannerTextView : UIView
@property(readonly, assign, nonatomic) UILabel *relevanceDateLabel;
@end
@interface SBDefaultBannerTextView(TinyBar)
- (UILabel *)tb_titleLabel;
- (UILabel *)tb_secondaryLabel;
@end
@interface SBDefaultBannerTextView(ColorBanners)
- (void)setPrimaryTextColor:(UIColor *)color;
- (void)setSecondaryTextColor:(UIColor *)color;
- (UIColor *)secondaryTextColor;
@end

@interface SBUIBannerContext : NSObject
- (id)item;
@end

@interface SBBannerContextView : UIView
@property(retain, nonatomic) UIView *pullDownView;
- (void)_setGrabberColor:(id)color;
@end
@interface SBBannerContextView(ColorBanners)
- (void)colorizeBackgroundForColor:(int)color alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack;
- (void)colorizeTextForColor:(int)color alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack;
- (void)colorizeGrabberForColor:(int)color alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack;
- (void)colorizePullDown:(UIView *)v forColor:(int)color alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack;
- (void)recolorizePullDown:(UIView *)pullDownView;
- (void)colorize:(int)color withBackground:(int)bg force:(BOOL)force;
- (void)colorize:(int)color;

- (NSNumber *)cbr_color;
- (void)cbr_setColor:(NSNumber *)color;
- (NSNumber *)cbr_prefersBlack;
- (void)cbr_setPrefersBlack:(NSNumber *)prefersBlack;
@end

#pragma mark - Banner Buttons

@interface SBBannerButtonView : UIView
@property(retain, nonatomic) NSArray *buttons;
@end
@interface SBBannerButtonView(ColorBanners)
- (void)colorizeWithColor:(int)color alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack;
@end

@interface SBNotificationVibrantButton : UIView
- (id)_buttonImageForColor:(id)color selected:(BOOL)selected;
@end
@interface SBNotificationVibrantButton(ColorBanners)
- (void)colorizeWithColor:(int)color alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack;
- (void)configureButton:(UIButton *)button
          withTintColor:(UIColor *)tintColor
      selectedTintColor:(UIColor *)selectedTintColor
              textColor:(UIColor *)textColor
      selectedTextColor:(UIColor *)selectedtextColor;
@end

#pragma mark - Backdrop

@interface _UIBackdropViewSettings : NSObject
@property double statisticsInterval;
@property BOOL requiresColorStatistics;

@property(retain) UIColor * colorTint;
@property(retain) UIColor * combinedTintColor;

+ (id)settingsForStyle:(int)style;
@end

@interface _UIBackdropEffectView : UIView
@end

@interface _UIBackdropView : UIView
@property(retain) id colorSaturateFilter;
@property(retain) id tintFilter;
- (void)_updateFilters;
- (void)transitionToSettings:(id)arg1;
- (void)setComputesColorSettings:(BOOL)computes;
- (id)inputSettings;

@property(retain) UIColor * colorMatrixColorTint;
@property(retain) _UIBackdropViewSettings * outputSettings;
@property(retain) _UIBackdropEffectView * backdropEffectView;
@end
@interface _UIBackdropView(ColorBanners)
- (void)setIsForBannerContextView:(BOOL)flag;
- (BOOL)isForBannerContextView;
@end

@interface CABackdropLayer : CALayer
- (id)statisticsValues;
@end

// Notification Center - headers.

@interface SBBulletinListSection : NSObject
@property(retain, nonatomic) UIImage *iconImage;
@end

@interface SBNotificationCenterSectionInfo : NSObject
@property(readonly, assign, nonatomic) NSString *identifier;
@property(readonly, retain, nonatomic) id representedObject;
@property(retain, nonatomic) UIImage *icon;
// iOS 8.
@property(readonly, assign, nonatomic) NSString *listSectionIdentifier;
@property(readonly, assign, nonatomic) SBBulletinListSection *representedListSection;
@end

@interface SBNotificationCenterHeaderView : UIView
@property(readonly, assign, nonatomic) UILabel *titleLabel;
@property(nonatomic,retain,readonly) UIView *contentView;
- (NSNumber *)cbr_color;
- (void)cbr_setColor:(NSNumber *)color;
- (NSNumber *)cbr_activeColor;
- (void)cbr_setActiveColor:(NSNumber *)color;

- (void)cbr_colorizeIfNeeded;
- (void)cbr_colorize:(int)color;
- (void)cbr_revert;
@end

// Notification center - cells.

@interface SBNotificationsBulletinInfo : NSObject
@property (nonatomic,retain) SBNotificationCenterSectionInfo *sectionInfo;
@property (nonatomic,retain) UIImage *icon;

@property (nonatomic,readonly) NSString *originalSectionIdentifier; 
@property (nonatomic,readonly) BBBulletin *representedBulletin;
@end

@interface SBNotificationsAllModeBulletinInfo : SBNotificationsBulletinInfo
@end

@interface SBNotificationsBulletinCell : UIView
@end

#pragma mark - iOS 9 Notification Center

@interface SBWidgetRowInfo : NSObject
- (id)icon;
- (id)identifier;
@end

@interface SBWidgetSectionInfo : NSObject
@property(copy, nonatomic) NSString *identifier;
@property(retain, nonatomic) SBWidgetRowInfo *widgetRowInfo;
@end

#pragma mark - QuickReply

@interface _UITextFieldRoundedRectBackgroundViewNeue : UIImageView
@property(nonatomic, retain) UIColor * strokeColor;
@property(nonatomic, retain) UIColor * fillColor;
- (void)updateView;
@end

@interface CKInlineAudioReplyButtonController : NSObject
@property (nonatomic, retain) UIButton *startButton;
@property (nonatomic, retain) UIButton *stopButton;
@end

@interface CKMessageEntryRichTextView : UITextView
@property(nonatomic, retain) UILabel *placeholderLabel;
@end

@interface CKMessageEntryContentView : UIView
@property (nonatomic, retain) CKMessageEntryRichTextView *textView;
@end

@interface CKMessageEntryView : UIView
@property(nonatomic, retain) UIView *dividerLine;
@property(nonatomic, retain) UIButton *audioButton;
@property(nonatomic, retain) CKMessageEntryContentView *contentView;
@property(nonatomic, retain) UIButton *sendButton;
@property(nonatomic, retain) CKInlineAudioReplyButtonController *audioReplyButton;
@property(nonatomic, retain) UIButton *deleteAudioRecordingButton;

// Added by ColorBanners.
- (void)cbr_setModal:(BOOL)modal;
- (BOOL)cbr_isModal;
@end

@interface CKInlineReplyViewController : UIViewController
@property(nonatomic, getter=isModal) BOOL modal;
@property(nonatomic, retain) CKMessageEntryView * entryView;

// Added by ColorBanners.
- (void)cbr_updateReadability:(BOOL)useDarkText;
- (void)managersReadabilityStateDidChange:(CBRReadabilityManager *)manager;
@end

#pragma mark - iOS 9 QuickReply

@interface NCNotificationActionTextInputViewController : UIViewController
@property (nonatomic, retain) _UITextFieldRoundedRectBackgroundViewNeue *coverView;
@property (nonatomic, retain) UIButton *sendButton;
@property (nonatomic, retain) UITextView *textEntryView;
@property (getter=isModal, nonatomic) BOOL modal;
- (void)cbr_colorize:(int)color alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack;
@end

#pragma mark - Private

@interface UIView(UIViewController_Internals)
- (id)_viewDelegate;
@end

#pragma mark - Auki 2 support
@interface KJUARRTextViewScrollContainerView : NSObject
- (void)setRelevanceDateColor:(UIColor *)color;
- (void)setRelevanceDateLabelLayerCompositingFilter:(NSString *)compositingFilter;
@end
