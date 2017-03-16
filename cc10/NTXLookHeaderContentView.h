@interface NTXLookHeaderContentView : UIView {
    BOOL  _adjustsFontForContentSizeCategory;
    NSDate * _date;
    BOOL  _dateAllDay;
    long long  _dateFormatStyle;
    UILabel * _dateLabel;
    NCLookViewFontProvider * _fontProvider;
    BOOL  _heedsHorizontalLayoutMargins;
    UIButton * _iconButton;
    long long  _lookStyle;
    NSString * _preferredContentSizeCategory;
    NSTimeZone * _timeZone;
    UILabel * _titleLabel;
    UIButton * _utilityButton;
    UIView * _utilityView;
}

@property (nonatomic) BOOL adjustsFontForContentSizeCategory;
@property (nonatomic, copy) NSDate *date;
@property (getter=isDateAllDay, nonatomic) BOOL dateAllDay;
@property (nonatomic) long long dateFormatStyle;
@property (readonly, copy) NSString *debugDescription;
@property (readonly, copy) NSString *description;
@property (readonly) unsigned long long hash;
@property (nonatomic) BOOL heedsHorizontalLayoutMargins;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, readonly) UIButton *iconButton;
@property (nonatomic, readonly) long long lookStyle;
@property (nonatomic, copy) NSString *preferredContentSizeCategory;
@property (readonly) Class superclass;
@property (nonatomic, copy) NSTimeZone *timeZone;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) UIButton *utilityButton;
@property (nonatomic, retain) UIView *utilityView;

+ (id)_xImage;
+ (CGFloat)titleInset;

- (void)_configureDateLabelForShortLook;
- (void)_configureDateLabelIfNecessary;
- (void)_configureIconButtonForLongLook;
- (void)_configureIconButtonIfNecessary;
- (void)_configureTitleLabelForLongLook;
- (void)_configureTitleLabelForShortLook;
- (void)_configureTitleLabelForStyle:(long long)arg1;
- (void)_configureTitleLabelIfNecessary;
- (void)_configureUtilityButtonIfNecessary;
- (UILabel *)_dateLabel;
- (void)_fixTitleOverlapIfNecessary;
- (id)_fontProvider;
- (CGFloat)_headerHeight;
- (CGFloat)_headerHeightForStyle:(long long)arg1;
- (void)_layoutDateLabelForLongLookWithScale:(CGFloat)arg1;
- (void)_layoutDateLabelForShortLookWithScale:(CGFloat)arg1;
- (void)_layoutDateLabelForStyle:(long long)arg1 withScale:(CGFloat)arg2;
- (void)_layoutIconButtonForLongLookWithScale:(CGFloat)arg1;
- (void)_layoutIconButtonForShortLookWithScale:(CGFloat)arg1;
- (void)_layoutIconButtonForStyle:(long long)arg1 withScale:(CGFloat)arg2;
- (void)_layoutTitleLabelForLongLookWithScale:(CGFloat)arg1;
- (void)_layoutTitleLabelForShortLookWithScale:(CGFloat)arg1;
- (void)_layoutTitleLabelForStyle:(long long)arg1 withScale:(CGFloat)arg2;
- (void)_layoutUtilityButtonForStyle:(long long)arg1 withScale:(CGFloat)arg2;
- (void)_recycleDateLabel;
- (void)_setFontProvider:(id)arg1;
- (UILabel *)_titleLabel;
- (CGFloat)_titleLabelBaselineOffset;
- (void)_updateDateLabel;
- (void)_updateDateLabelFontForShortLook;
- (void)_updateTitleLabelFontForStyle:(long long)arg1;
- (void)_updateUtilityButtonFont;
- (BOOL)adjustForContentSizeCategoryChange;
- (BOOL)adjustsFontForContentSizeCategory;
- (NSDate *)date;
- (long long)dateFormatStyle;
- (void)dateLabelDidChange:(id)arg1;
- (void)dealloc;
- (BOOL)heedsHorizontalLayoutMargins;
- (UIImage *)icon;
- (UIButton *)iconButton;
- (instancetype)initWithStyle:(long long)arg1;
- (BOOL)isDateAllDay;
- (void)layoutMarginsDidChange;
- (void)layoutSubviews;
- (long long)lookStyle;
- (NSString *)preferredContentSizeCategory;
- (void)setAdjustsFontForContentSizeCategory:(BOOL)arg1;
- (void)setDate:(NSDate *)arg1;
- (void)setDateAllDay:(BOOL)arg1;
- (void)setDateFormatStyle:(long long)arg1;
- (void)setHeedsHorizontalLayoutMargins:(BOOL)arg1;
- (void)setIcon:(UIImage *)arg1;
- (void)setPreferredContentSizeCategory:(NSString *)arg1;
- (void)setTimeZone:(NSTimeZone *)arg1;
- (void)setTitle:(NSString *)arg1;
- (void)setUtilityView:(UIView *)arg1;
- (CGSize)sizeThatFits:(CGSize)arg1;
- (NSTimeZone *)timeZone;
- (NSString *)title;
- (void)traitCollectionDidChange:(id)arg1;
- (UIButton *)utilityButton;
- (UIView *)utilityView;

@end