#import "NTXLookHeaderContentView.h"

@implementation NTXLookHeaderContentView
+ (id)_xImage {

}

+ (CGFloat)titleInset {

}


- (void)_configureDateLabelForShortLook {

}

- (void)_configureDateLabelIfNecessary {

}

- (void)_configureIconButtonForLongLook {

}

- (void)_configureIconButtonIfNecessary {

}

- (void)_configureTitleLabelForLongLook {

}

- (void)_configureTitleLabelForShortLook {

}

- (void)_configureTitleLabelForStyle:(long long)arg1 {

}

- (void)_configureTitleLabelIfNecessary {

}

- (void)_configureUtilityButtonIfNecessary {

}

- (id)_dateLabel {

}

- (void)_fixTitleOverlapIfNecessary {

}

- (id)_fontProvider {

}

- (CGFloat)_headerHeight {

}

- (CGFloat)_headerHeightForStyle:(long long)arg1 {

}

- (void)_layoutDateLabelForLongLookWithScale:(CGFloat)arg1 {

}

- (void)_layoutDateLabelForShortLookWithScale:(CGFloat)arg1 {

}

- (void)_layoutDateLabelForStyle:(long long)arg1 withScale:(CGFloat)arg2 {

}

- (void)_layoutIconButtonForLongLookWithScale:(CGFloat)arg1 {

}

- (void)_layoutIconButtonForShortLookWithScale:(CGFloat)arg1 {

}

- (void)_layoutIconButtonForStyle:(long long)arg1 withScale:(CGFloat)arg2 {

}

- (void)_layoutTitleLabelForLongLookWithScale:(CGFloat)arg1 {

}

- (void)_layoutTitleLabelForShortLookWithScale:(CGFloat)arg1 {

}

- (void)_layoutTitleLabelForStyle:(long long)arg1 withScale:(CGFloat)arg2 {

}

- (void)_layoutUtilityButtonForStyle:(long long)arg1 withScale:(CGFloat)arg2 {

}

- (void)_recycleDateLabel {

}

- (void)_setFontProvider:(id)arg1 {

}

- (id)_titleLabel {

}

- (CGFloat)_titleLabelBaselineOffset {

}

- (void)_updateDateLabel {

}

- (void)_updateDateLabelFontForShortLook {

}

- (void)_updateTitleLabelFontForStyle:(long long)arg1 {

}

- (void)_updateUtilityButtonFont {

}

- (BOOL)adjustForContentSizeCategoryChange {

}

- (BOOL)adjustsFontForContentSizeCategory {

}

- (id)date {

}

- (long long)dateFormatStyle {

}

- (void)dateLabelDidChange:(id)arg1 {

}

- (void)dealloc {

}

- (BOOL)heedsHorizontalLayoutMargins {

}

- (id)icon {

}

- (id)iconButton {

}

- (id)initWithStyle:(long long)arg1 {

}

- (BOOL)isDateAllDay {

}

- (void)layoutMarginsDidChange {

}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIScreen *screen = [[UIScreen mainScreen] retain];
    CGFloat scale = [screen scale];
    [self _layoutIconButtonForStyle:_lookStyle withScale:scale];
    [self _layoutTitleLabelForStyle:_lookStyle withScale:scale];
    [self _layoutDateLabelForStyle:_lookStyle withScale:scale];
    if (_utilityButton) {
            [self _layoutUtilityButtonForStyle:_lookStyle withScale:scale];
    }
    [self _fixTitleOverlapIfNecessary];
}

- (long long)lookStyle {

}
// NCLookHeaderContentView - (int)lookStyle
int __cdecl -[NCLookHeaderContentView lookStyle](struct NCLookHeaderContentView *self, SEL a2)
{
  return *(_DWORD *)&self->UIView_opaque[OBJC_IVAR___NCLookHeaderContentView__lookStyle];
}

- (id)preferredContentSizeCategory {

}
// NCLookHeaderContentView - (id)preferredContentSizeCategory
id __cdecl -[NCLookHeaderContentView preferredContentSizeCategory](struct NCLookHeaderContentView *self, SEL a2)
{
  int v2; // esi@1

  v2 = *(_DWORD *)&self->UIView_opaque[OBJC_IVAR___NCLookHeaderContentView__preferredContentSizeCategory];
  if ( !v2 )
  {
    *(_DWORD *)&self->UIView_opaque[OBJC_IVAR___NCLookHeaderContentView__preferredContentSizeCategory] = objc_retain(*(_DWORD *)UIContentSizeCategoryUnspecified_ptr);
    objc_release(0);
    v2 = *(_DWORD *)&self->UIView_opaque[OBJC_IVAR___NCLookHeaderContentView__preferredContentSizeCategory];
  }
  return (id)objc_retainAutoreleaseReturnValue(v2);
}

- (void)setAdjustsFontForContentSizeCategory:(BOOL)arg1 {

}
\// NCLookHeaderContentView - (void)setAdjustsFontForContentSizeCategory:(char) 
void __cdecl -[NCLookHeaderContentView setAdjustsFontForContentSizeCategory:](struct NCLookHeaderContentView *self, SEL a2, char a3)
{
  void *v3; // eax@3
  void *v4; // eax@3
  void *v5; // ST1C_4@3
  void *v6; // eax@3
  int v7; // edi@3

  if ( self->UIView_opaque[OBJC_IVAR___NCLookHeaderContentView__adjustsFontForContentSizeCategory] != (unsigned __int8)a3 )
  {
    self->UIView_opaque[OBJC_IVAR___NCLookHeaderContentView__adjustsFontForContentSizeCategory] = a3;
    if ( a3 )
    {
      v3 = objc_msgSend(classRef_UIApplication, selRef_sharedApplication);
      v4 = (void *)objc_retainAutoreleasedReturnValue(v3);
      v5 = v4;
      v6 = objc_msgSend(v4, selRef_preferredContentSizeCategory);
      v7 = objc_retainAutoreleasedReturnValue(v6);
      objc_msgSend(self, selRef_setPreferredContentSizeCategory_, v7);
      objc_release(v7);
      objc_release(v5);
    }
    objc_msgSend(self, selRef_adjustForContentSizeCategoryChange);
  }
}

- (void)setDate:(id)arg1 {

}
// NCLookHeaderContentView - (void)setDate:(id) 
void __cdecl -[NCLookHeaderContentView setDate:](struct NCLookHeaderContentView *self, SEL a2, id a3)
{
  void *v3; // esi@1
  void *v4; // eax@2
  int v5; // ecx@2

  v3 = (void *)objc_retain(a3);
  if ( !(unsigned __int8)objc_msgSend(
                           v3,
                           selRef_isEqual_,
                           *(_DWORD *)&self->UIView_opaque[OBJC_IVAR___NCLookHeaderContentView__date]) )
  {
    v4 = objc_msgSend(v3, selRef_copy);
    v5 = *(_DWORD *)&self->UIView_opaque[OBJC_IVAR___NCLookHeaderContentView__date];
    *(_DWORD *)&self->UIView_opaque[OBJC_IVAR___NCLookHeaderContentView__date] = v4;
    objc_release(v5);
    objc_msgSend(self, selRef__updateDateLabel);
  }
  objc_release(v3);
}

- (void)setDateAllDay:(BOOL)value {
  if (_dateAllDay != value) {
  	_dateAllDay = value;
  	[self _updateDateLabel];
  }
}

- (void)setDateFormatStyle:(long long)style {
  if (_dateFormatStyle != style) {
    _dateFormatStyle = style;
    [self _updateDateLabel];
  }
}

- (void)setHeedsHorizontalLayoutMargins:(BOOL)arg1 {
  _heedsHorizontalLayoutMargins = arg1;
}

- (void)setIcon:(UIImage *)icon {
  if (icon) {
    if (icon != [self icon]) {
      [self _configureIconButtonIfNecessary];
      [_iconButton setImage:icon forState:0];
    }
  }
}

- (void)setPreferredContentSizeCategory:(NSString *)category {
  _preferredContentSizeCategory = category;
}

- (void)setTimeZone:(NSTimeZone *)zone {
  if (![zone isEqual:_timeZone]) {
    _timeZone = zone;
    [self _updateDateLabel];
  }
}

- (void)setTitle:(id)arg1 {

}
// NCLookHeaderContentView - (void)setTitle:(id) 
void __cdecl -[NCLookHeaderContentView setTitle:](struct NCLookHeaderContentView *self, SEL a2, id a3)
{
  void *v3; // eax@1
  void *v4; // ebx@1
  void *v5; // eax@1
  int v6; // edi@1
  void *v7; // esi@1
  void *v8; // [sp+20h] [bp-28h]@2
  int v9; // [sp+24h] [bp-24h]@2
  int v10; // [sp+28h] [bp-20h]@2
  int (__cdecl *v11)(int); // [sp+2Ch] [bp-1Ch]@2
  int v12; // [sp+30h] [bp-18h]@2
  int v13; // [sp+34h] [bp-14h]@2
  int v14; // [sp+38h] [bp-10h]@2

  v3 = objc_msgSend(a3, selRef_localizedUppercaseString);
  v4 = (void *)objc_retainAutoreleasedReturnValue(v3);
  v5 = objc_msgSend(self, selRef_title);
  v6 = objc_retainAutoreleasedReturnValue(v5);
  v7 = v4;
  LOBYTE(v4) = (unsigned int)objc_msgSend(v4, selRef_isEqual_, v6);
  objc_release(v6);
  if ( !(_BYTE)v4 )
  {
    objc_msgSend(self, selRef__configureTitleLabelIfNecessary);
    v8 = _NSConcreteStackBlock_ptr;
    v9 = -1040187392;
    v10 = 0;
    v11 = __36__NCLookHeaderContentView_setTitle___block_invoke;
    v12 = (int)&__block_descriptor_tmp_40;
    v13 = objc_retain(self);
    v14 = objc_retain(v7);
    objc_msgSend(classRef_UIView, selRef_performWithoutAnimation_, &v8);
    objc_release(v14);
    objc_release(v13);
  }
  objc_release(v7);
}

void *__cdecl __36__NCLookHeaderContentView_setTitle___block_invoke(int a1)
{
  objc_msgSend(
    *(void **)(*(_DWORD *)(a1 + 20) + OBJC_IVAR___NCLookHeaderContentView__titleLabel),
    selRef_setText_,
    *(_DWORD *)(a1 + 24));
  return objc_msgSend(*(void **)(a1 + 20), selRef_setNeedsLayout);
}

- (void)setUtilityView:(id)view {
	if (_utilityView != view) {
		[_utilityView removeFromSuperview];
		_utilityView = view;
		[self addSubview:_utilityView];
		[self needsLayout];
	}
}

- (CGSize)sizeThatFits:(CGSize)arg1 {

}

- (NSTimeZone *)timeZone {
	return _timeZone;
}

- (NSString *)title {
	return [_titleLabel text];
}

- (void)traitCollectionDidChange:(id)collection {
	[super traitCollectionDidChange:collection];
	if ([self adjustsFontForContentSizeCategory]) {
		[self adjustForContentSizeCategoryChange];
	}
}

- (UIButton *)utilityButton {
	[self _configureUtilityButtonIfNecessary];
	return _utilityButton;
}

- (UIView *)utilityView {
	return _utilityView;
}
@end


