#import "headers.h"
#import <objc/runtime.h>
#import <objc/message.h>

static BOOL darkModeEnabled = YES;
#ifdef __cplusplus
extern "C" {
#endif

CFNotificationCenterRef CFNotificationCenterGetDistributedCenter(void);

#ifdef __cplusplus
}
#endif

static void postDarkModeEnabledNotification();
static void postDarkModeDisabledNotification();
void callSuper(Class classPassed, id object, SEL selector, BOOL value) {
	objc_super $super = {object, classPassed};
	objc_msgSendSuper(&$super, selector, value);
}

void applyInvertFilter(UIView *view) {
	NSMutableArray *currentFilters = [NSMutableArray new];
	for (CAFilter *filter in view.layer.filters) {
		if ([filter.name isEqualToString:@"invertFilter"]) {
			return;
		} else {
			[filter setValue:[NSNumber numberWithBool:NO] forKey:@"inputReversed"];
			[currentFilters addObject:filter];

		}
	}
	// CAFilter *invertFilter = [CAFilter filterWithType:@"colorMatrix"];
 //  	[invertFilter setValue:[NSValue valueWithCAColorMatrix:(CAColorMatrix){-1,0,0,0,1,0,-1,0,0,1,0,0,-1,0,1,0,0,0,1,0}] forKey:@"inputColorMatrix"];
 //  	invertFilter.isDarkModeFilter = YES;
 //  	[currentFilters addObject:invertFilter];
  	[view.layer setFilters:currentFilters];

}

%group Widget
%hook UILabel
- (void)nc_applyVibrantStyling:(id)styling {
	%orig;
	if (!self.hasChangeListener) {
		[self setSubstitutedTextColor:[UIColor colorWithWhite:1 alpha:[self.correctTextColor alphaComponent]]];
		[self setDarkModeEnabled:darkModeEnabled];
	}
	if (!self.layer.hasChangeListener) {
		[self.layer setDarkModeEnabled:darkModeEnabled];
	}
}
- (void)setTextColor:(UIColor *)textColor {
	if (!self.hasChangeListener) {
		[self setSubstitutedTextColor:[UIColor whiteColor]];
		[self setDarkModeEnabled:darkModeEnabled];
	}
	if (!self.layer.hasChangeListener) {
		[self.layer setDarkModeEnabled:darkModeEnabled];
	}
	if (![textColor isEqual:self.substitutedTextColor]) {
		self.correctTextColor = textColor;
	}
	if (darkModeEnabled && self.hasChangeListener) {
		if (![textColor isEqual:self.substitutedTextColor]) {
			if (self.substitutedTextColor) {
				%orig([UIColor colorWithWhite:1 alpha:[self.correctTextColor alphaComponent]]);
			} else {
				%orig;
			}
		} else {
			%orig;
		}
	} else {
		%orig;
	}
	%orig;
}
- (UIColor *)textColor {
	if (!self.hasChangeListener) {
		[self setSubstitutedTextColor:[UIColor whiteColor]];
		[self setDarkModeEnabled:darkModeEnabled];
	}
	if (!self.layer.hasChangeListener) {
		[self.layer setDarkModeEnabled:darkModeEnabled];
	}
	return %orig;
}
- (void)setColor:(UIColor *)color {
	if (!self.hasChangeListener) {
		[self setSubstitutedTextColor:[UIColor whiteColor]];
		[self setDarkModeEnabled:darkModeEnabled];
	}
	if (!self.layer.hasChangeListener) {
		[self.layer setDarkModeEnabled:darkModeEnabled];
	}
}

- (void)layoutSubviews {
	%orig;
	if (!self.hasChangeListener) {
		[self setSubstitutedTextColor:[UIColor whiteColor]];
		[self setDarkModeEnabled:darkModeEnabled];
	}
	if (!self.layer.hasChangeListener) {
		[self.layer setDarkModeEnabled:darkModeEnabled];
	}
}
// %new
// - (void)attemptOldColorReload {
// 	if (!darkModeEnabled) {
// 		self.textColor = self.previousColor;
// 	}
// }
%end
%end

%group Simulator
%hook CCUINightShiftSectionController
- (BOOL)enabled {
	return YES;
}
%end

%hook CCUICellularDataSetting
+ (BOOL)isSupported:(int)arg1 {
	return YES;
}
+(BOOL)isInternalButton {
	return YES;
}
%end

%hook CCUIMuteSetting
+ (BOOL)isSupported:(int)arg1 {
	return YES;
}
+(BOOL)isInternalButton {
	return YES;
}
%end

%hook CCUILowPowerModeSetting
+ (BOOL)isSupported:(int)arg1 {
	return YES;
}
+(BOOL)isInternalButton {
	return YES;
}
%end

%hook CCUIPersonalHotspotSetting
+ (BOOL)isSupported:(int)arg1 {
	return YES;
}
+(BOOL)isInternalButton {
	return YES;
}
%end

%hook CCUIBrightnessSectionController
- (BOOL)enabled {
	return YES;
}
%end

%hook CCUICameraShortcut
- (BOOL)isRestricted {
	return NO;
}
%end
%end

%group SpringBoard
%subclass OYGBackdropViewSettingsBlurred : _UIBackdropViewSettingsATVAdaptiveLighten
- (void)setDefaultValues {
	%orig;
	CGFloat amount = 0.7;
 	CGFloat intercept = -0.5 * amount + 0.5;
        CAColorMatrix colorMatrix = {
            amount, 0, 0, 0, intercept,
            0, amount, 0, 0, intercept,
            0, 0, amount, 0, intercept,
            0, 0, 0, 1, 0
        };
    self.colorOffsetMatrix = [NSValue valueWithCAColorMatrix:colorMatrix];
	self.colorBurnTintAlpha = 0.3;
	self.colorBurnTintLevel = 0;
	self.colorOffsetAlpha = 1;
	self.colorTint = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.359];
	self.colorTintAlpha = 0.0;
	self.colorTintMaskAlpha = 1;
	self.usesColorBurnTintView = YES;
	self.usesColorOffset = YES;
	self.usesColorTintView = YES;
	self.darkeningTintAlpha = 0.5;
	self.darkeningTintBrightness = 0.35;
	self.darkeningTintHue = 0.8;
	self.darkeningTintSaturation = 0;
	self.usesDarkeningTintView = YES;
	self.grayscaleTintAlpha = 0.5;
	self.grayscaleTintLevel = 0.2;
	self.lightenGrayscaleWithSourceOver = YES;
	self.usesGrayscaleTintView = YES;
	self.saturationDeltaFactor = 1.8;
	self.lightenGrayscaleWithSourceOver = YES;
	self.blurRadius = 30;
}
%end

%subclass OYGBackdropViewSettings : _UIBackdropViewSettingsATVAdaptiveLighten
- (void)setDefaultValues {
	%orig;
    self.colorOffsetMatrix = [NSValue valueWithCAColorMatrix:(CAColorMatrix){-1,0,0,0,1,0,-1,0,0,1,0,0,-1,0,1,0,0,0,1,0}];
	self.colorBurnTintAlpha = 0.3;
	self.colorBurnTintLevel = 0;
	self.colorOffsetAlpha = 1;
	self.colorTint = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.359];
	self.colorTintAlpha = 0.0;
	self.colorTintMaskAlpha = 1;
	self.usesColorBurnTintView = YES;
	self.usesColorOffset = YES;
	self.usesColorTintView = YES;
	self.darkeningTintAlpha = 0.5;
	self.darkeningTintBrightness = 0.35;
	self.darkeningTintHue = 0.8;
	self.darkeningTintSaturation = 0;
	self.usesDarkeningTintView = YES;
	self.grayscaleTintAlpha = 0.5;
	self.grayscaleTintLevel = 0.2;
	self.lightenGrayscaleWithSourceOver = YES;
	self.usesGrayscaleTintView = YES;
	self.saturationDeltaFactor = 1.8;
	self.lightenGrayscaleWithSourceOver = YES;
	self.blurRadius = 30;
}
%end


%hook NCNotificationContentView
- (void)layoutSubviews {
	%orig;
	NSMutableArray *labels = [NSMutableArray new];
	[labels addObject:[NSString stringWithFormat:@"_outgoingSecondaryLabel"]];
	[labels addObject:[NSString stringWithFormat:@"_outgoingPrimaryLabel"]];
	[labels addObject:[NSString stringWithFormat:@"_outgoingPrimarySubtitleLabel"]];
	[labels addObject:[NSString stringWithFormat:@"_secondaryLabel"]];
	[labels addObject:[NSString stringWithFormat:@"_primarySubtitleLabel"]];
	[labels addObject:[NSString stringWithFormat:@"_hintTextLabel"]];
	[labels addObject:[NSString stringWithFormat:@"_primaryLabel"]];
		
	for (NSString *labelString in labels) {
		UILabel *label = (UILabel *)[self valueForKey:[NSString stringWithFormat:@"%@", labelString]];
		if (label) {
			[label.layer setDarkModeEnabled:darkModeEnabled];
			[label setSubstitutedTextColor:[UIColor whiteColor]];
			[label setDarkModeEnabled:darkModeEnabled];
		}
	}
}
%end

%hook NCLookHeaderContentView
-(void)_configureTitleLabelForShortLook {
	%orig;
	// apply
//	[((UILabel *)[self valueForKey:@"_titleLabel"]).layer setDarkModeEnabled:darkModeEnabled];
//	[(UILabel *)[self valueForKey:@"_titleLabel"] setSubstitutedTextColor:[UIColor whiteColor]];
	//[(UILabel *)[self valueForKey:@"_titleLabel"] setDarkModeEnabled:darkModeEnabled];
}
-(void)_configureDateLabelForShortLook {
	%orig;
	[((UILabel *)[self valueForKey:@"_dateLabel"]).layer setDarkModeEnabled:darkModeEnabled];
	[(UILabel *)[self valueForKey:@"_dateLabel"] setSubstitutedTextColor:[UIColor whiteColor]];
	[(UILabel *)[self valueForKey:@"_dateLabel"] setDarkModeEnabled:darkModeEnabled];
}
-(void)_configureUtilityButtonIfNecessary {
	%orig;
	[((UILabel *)[(UIButton *)[self valueForKey:@"_utilityButton"] titleLabel]).layer setDarkModeEnabled:darkModeEnabled];
	[(UILabel *)[(UIButton *)[self valueForKey:@"_utilityButton"] titleLabel] setSubstitutedTextColor:[UIColor whiteColor]];
	[(UILabel *)[(UIButton *)[self valueForKey:@"_utilityButton"] titleLabel] setDarkModeEnabled:darkModeEnabled];
}
-(void)_configureTitleLabelForShortLook:(UILabel *)label {
	%orig;
	[label.layer setDarkModeEnabled:darkModeEnabled];
	[label setSubstitutedTextColor:[UIColor whiteColor]];
	[label setDarkModeEnabled:darkModeEnabled];
}
-(void)_configureDateLabelForShortLook:(UILabel *)label {
	%orig;
	[label.layer setDarkModeEnabled:darkModeEnabled];
	[label setSubstitutedTextColor:[UIColor whiteColor]];
	[label setDarkModeEnabled:darkModeEnabled];
}
-(void)_configureUtilityButtonIfNecessary:(UIButton *)button {
	%orig;
	[((UILabel *)[button titleLabel]).layer setDarkModeEnabled:darkModeEnabled];
	[(UILabel *)[button titleLabel] setSubstitutedTextColor:[UIColor whiteColor]];
	[(UILabel *)[button titleLabel] setDarkModeEnabled:darkModeEnabled];
}
%end

%hook NCNotificationShortLookView
- (void)layoutSubviews {
	%orig;

		// if ([[self valueForKey:@"_backgroundView"] isKindOfClass:NSClassFromString(@"NCMaterialView")]) {
		// 	if ([[self valueForKey:@"_backgroundView"] valueForKey:@"_backdropView"]) {
		// 		if ([[[[self valueForKey:@"_backgroundView"] valueForKey:@"_backdropView"] valueForKey:@"_inputSettings"] isKindOfClass:NSClassFromString(@"NCLookViewBackdropViewSettings")]) {
		// 			NCLookViewBackdropViewSettings *old = (NCLookViewBackdropViewSettings *)[[[self valueForKey:@"_backgroundView"] valueForKey:@"_backdropView"] valueForKey:@"_inputSettings"];
		// 			if (![old _isDarkened] && ![old _isBlurred]) {
		// 				[(_UIBackdropView *)[[self valueForKey:@"_backgroundView"] valueForKey:@"_backdropView"] transitionToSettings:[NSClassFromString(@"OYGBackdropViewSettings") new]];
		// 			} else if ([old _isBlurred] && ![old _isDarkened]) {
		// 				[(_UIBackdropView *)[[self valueForKey:@"_backgroundView"] valueForKey:@"_backdropView"] transitionToSettings:[NSClassFromString(@"OYGBackdropViewSettingsBlurred") new]];
		// 			}
		// 		}
		// 	}
		// }
	if ([self valueForKey:@"_headerOverlayView"]) {
		((UIView *)[self valueForKey:@"_headerOverlayView"]).substitutedBackgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.125];
		[(UIView *)[self valueForKey:@"_headerOverlayView"] setDarkModeEnabled:darkModeEnabled];
	}

}
%end

%hook NCShortLookView
- (void)_configureMainOverlayViewIfNecessary {
	%orig;
	if ([self valueForKey:@"_mainOverlayView"]) {
		// 10.2 _mainOverlayView BG is 0.95 white and 0.45 alpha by default
		((UIView *)[self valueForKey:@"_mainOverlayView"]).substitutedBackgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.2];
		[(UIView *)[self valueForKey:@"_mainOverlayView"] setDarkModeEnabled:darkModeEnabled];
	}
}
- (void)_configureHeaderOverlayViewIfNecessary {
	%orig;
	if ([self valueForKey:@"_headerOverlayView"]) {
		// 10.2 _mainOverlayView BG is 0.95 white and 0.45 alpha by default
		((UIView *)[self valueForKey:@"_headerOverlayView"]).substitutedBackgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.125];
		[(UIView *)[self valueForKey:@"_headerOverlayView"] setDarkModeEnabled:darkModeEnabled];
	}
}
%end

%hook NCNotificationListClearButton
-(void)layoutSubviews {
	%orig;
	if ([self valueForKey:@"_glyphImageViews"]) {
		for (UIImageView *view in (NSMutableArray *)[self valueForKey:@"_glyphImageViews"]) {
			[view.layer setDarkModeEnabled:darkModeEnabled];
		}
	}
	if ([self valueForKey:@"_xImageView"]) {
		[((UIImageView *)[self valueForKey:@"_xImageView"]).layer setDarkModeEnabled:darkModeEnabled];
	}
}
%end

%hook NCNotificationListCellActionButton
-(void)_configureTitleLabelIfNecessary {
	%orig;
	if (self.titleLabel) {
		self.titleLabel.substitutedTextColor = [UIColor whiteColor];
		[self.titleLabel setDarkModeEnabled:darkModeEnabled];
	}
}
%end

%hook _UIInterfaceActionLabelsPropertyView
-(UILabel *)_newLabel {
	UILabel *label = %orig;
	if (label) {
		[label.layer setDarkModeEnabled:darkModeEnabled];
		label.substitutedTextColor = [UIColor whiteColor];
		label.layer.substitutedContentsMultiplyColor = [UIColor whiteColor];
		[label.layer setDarkModeEnabled:darkModeEnabled];
		[label setDarkModeEnabled:darkModeEnabled];
	}
	return label;
}
%end
%hook _UIInterfaceActionBlendingSeparatorView
- (id)init {
	_UIInterfaceActionBlendingSeparatorView *view = %orig;
	[view.layer setDarkModeEnabled:darkModeEnabled];
	view.substitutedBackgroundColor = [UIColor colorWithWhite:0.95 alpha:0.25];
	[view setDarkModeEnabled:darkModeEnabled];
	return view;
}
-(id)initWithTopLevelFilters:(id)arg1 compositingColors:(id)arg2 compositingFilterModes:(id)arg3 {
	_UIInterfaceActionBlendingSeparatorView *view = %orig;
	[view.layer setDarkModeEnabled:darkModeEnabled];
	view.substitutedBackgroundColor = [UIColor colorWithWhite:0.95 alpha:0.25];
	[view setDarkModeEnabled:darkModeEnabled];
	return view;
}
%end

%hook _UIInterfaceActionSystemRepresentationView
-(void)_reloadBackgroundHighlightView {
	%orig;
	if (self.backgroundHighlightView) {
		self.backgroundHighlightView.substitutedBackgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
		[self.backgroundHighlightView setDarkModeEnabled:darkModeEnabled];
	}
}
- (UIView *)backgroundHighlightView {
	UIView *view = %orig;
	if (view) {
		view.substitutedBackgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
		[view setDarkModeEnabled:darkModeEnabled];
	}
	return view;
}
%end

%hook MPUControlCenterTransportButton
- (void)_updateEffectForStateChange:(NSUInteger)state {
	if (darkModeEnabled) {
		%orig(1);
	} else %orig;
}
- (void)layoutSubviews {
	%orig;
	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(darkModeChanged:)
	                                             	 name:@"com.sadie.ogygia.darkmodechanged"
	                                           	   object:nil];
	}
}
%new
- (void)darkModeChanged:(NSNotification *)notification {
	[self setDarkModeEnabled:darkModeEnabled];
}
%new
- (void)setDarkModeEnabled:(BOOL)enabled {
	if (self.isDarkModeEnabled != enabled) {
		if (enabled) {
			[self _updateEffectForStateChange:1];
		} else {
			[self _updateEffectForStateChange:0];
		}
	}

	callSuper(objc_getClass("UIView"),self,@selector(setDarkModeEnabled:),enabled);
}
%end

%hook CCUIControlCenterSlider
- (void)_updateEffects {
	%orig;
	if ([self valueForKey:@"_maxValueImageView"]) {
		[((UIView *)[self valueForKey:@"_maxValueImageView"]).layer setDarkModeEnabled:darkModeEnabled];
	}
	if ([self valueForKey:@"_minValueImageView"]) {
		[((UIView *)[self valueForKey:@"_minValueImageView"]).layer setDarkModeEnabled:darkModeEnabled];
	}

}
%end

%hook CCUIControlCenterPagePlatterView
- (void)setContentView:(UIView *)contentView {
	%orig;
	if ([self valueForKey:@"_whiteLayerView"]) {
		[[(UIView *)[self valueForKey:@"_whiteLayerView"] layer] setSubstitutedContentsMultiplyColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]];
		[[(UIView *)[self valueForKey:@"_whiteLayerView"] layer] setDarkModeEnabled:darkModeEnabled];
		[(UIImageView *)[self valueForKey:@"_whiteLayerView"] behaveAsWhiteLayerView];
	}
}
- (void)layoutSubviews {
	%orig;
	if ([self valueForKey:@"_whiteLayerView"]) {
		[[(UIView *)[self valueForKey:@"_whiteLayerView"] layer] setSubstitutedContentsMultiplyColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]];
		[[(UIImageView *)[self valueForKey:@"_whiteLayerView"] layer] setDarkModeEnabled:darkModeEnabled];
		[(UIImageView *)[self valueForKey:@"_whiteLayerView"] behaveAsWhiteLayerView];
	}
}
- (void)_rerenderPunchThroughMaskIfNecessary {
	%orig;
	if ([self valueForKey:@"_whiteLayerView"]) {
		[[(UIView *)[self valueForKey:@"_whiteLayerView"] layer] setSubstitutedContentsMultiplyColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]];
		[[(UIView *)[self valueForKey:@"_whiteLayerView"] layer] setDarkModeEnabled:darkModeEnabled];
		[(UIImageView *)[self valueForKey:@"_whiteLayerView"] behaveAsWhiteLayerView];
	}
}
%end

%hook CCUIControlCenterButton
-(void)_updateEffects {
	%orig;

	if ([self valueForKey:@"_glyphImageView"]) {
		if (!((UIView *)[self valueForKey:@"_glyphImageView"]).layer.hasChangeListener) {
			[((UIView *)[self valueForKey:@"_glyphImageView"]).layer setDarkModeEnabled:darkModeEnabled];
		}
	}
	if ([self valueForKey:@"_alteredStateGlyphImageView"]) {
		if (!((UIView *)[self valueForKey:@"_alteredStateGlyphImageView"]).layer.hasChangeListener) {
			[((UIView *)[self valueForKey:@"_alteredStateGlyphImageView"]).layer setDarkModeEnabled:darkModeEnabled];
		}
	}
	if ([self valueForKey:@"_label"]) {
		[((UILabel *)[self valueForKey:@"_label"]).layer setDarkModeEnabled:darkModeEnabled];
		[(UILabel *)[self valueForKey:@"_label"] setDarkModeEnabled:darkModeEnabled];
	}
	if ([self valueForKey:@"_alteredStateLabel"]) {
		[((UILabel *)[self valueForKey:@"_alteredStateLabel"]).layer setDarkModeEnabled:darkModeEnabled];
		[(UILabel *)[self valueForKey:@"_alteredStateLabel"] setDarkModeEnabled:darkModeEnabled];
	}
}
%end

%hook WGShortLookStyleButton
- (void)_layoutTitleLabel {
	%orig;
	if ([self valueForKey:@"_titleLabel"]) {
		[((UILabel *)[self valueForKey:@"_titleLabel"]).layer setDarkModeEnabled:darkModeEnabled];
		[(UILabel *)[self valueForKey:@"_titleLabel"] setDarkModeEnabled:darkModeEnabled];
	}
}
%end

%hook NCVibrantRuleStyling
- (UIColor *)color {
		return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
}
%end

%hook SBSearchEtceteraIsolatedViewController
- (id)widgetGroupViewController:(id)arg1 newCustomBackgroundViewForItem:(id)arg2 inScrollView:(id)arg3 {
	return [NSClassFromString(@"NCMaterialView") materialViewWithStyleOptions:4];
}
%end

%hook CCUIControlCenterLabel
- (void)_updateEffects {
	%orig;
	[self.layer setDarkModeEnabled:darkModeEnabled];
	[self setSubstitutedTextColor:[UIColor colorWithWhite:1 alpha:[self.correctTextColor alphaComponent]]];
	[self setDarkModeEnabled:darkModeEnabled];
}
%end

%hook SBUIActionView
// - (id)initWithFrame:(CGRect)frame {
// 	SBUIActionView *actionView = %orig;
// 	actionView.substitutedBackgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.2];
// 	[actionView setDarkModeEnabled:darkModeEnabled];
// 	return actionView;
// }
-(void)_setupSubviews {
	%orig;
	self.substitutedBackgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.2];
	[self setDarkModeEnabled:darkModeEnabled];
	if ([self valueForKey:@"_imageView"]) {
		[((UIImageView *)[self valueForKey:@"_imageView"]).layer setDarkModeEnabled:darkModeEnabled];
	}
}
%end

%hook SBUIActionKeylineView
-(void)didMoveToSuperview {
	%orig;
	self.substitutedBackgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
	[self.layer setDarkModeEnabled:darkModeEnabled];
	[self setDarkModeEnabled:darkModeEnabled];
}
%end

%hook SBUIActionViewLabel
- (void)nc_applyVibrantStyling:(id)styling {
	%orig;
	if ([self valueForKey:@"_label"]) {
		[((UILabel *)[self valueForKey:@"_label"]).layer setDarkModeEnabled:darkModeEnabled];
	}
}
%end

%hook MPUControlCenterMediaControlsView
- (void)layoutSubviews {
	%orig;
	if (self.pickedRouteHeaderView) {
		if (self.pickedRouteHeaderView.textLabel) {
			if (self.pickedRouteHeaderView.textLabel.primaryLabel) {
				//[self.pickedRouteHeaderView.textLabel.primaryLabel.layer setSubstitutedContentsMultiplyColor:[UIColor clearColor]];
				[self.pickedRouteHeaderView.textLabel.primaryLabel.layer setDarkModeEnabled:darkModeEnabled];
			}
			if (self.pickedRouteHeaderView.textLabel.secondaryLabel) {
				//[self.pickedRouteHeaderView.textLabel.secondaryLabel.layer setSubstitutedContentsMultiplyColor:[UIColor clearColor]];
				[self.pickedRouteHeaderView.textLabel.secondaryLabel.layer setDarkModeEnabled:darkModeEnabled];
			} 
		}
		if ([self.pickedRouteHeaderView valueForKey:@"_iconImageView"]) {
			//((UIImageView *)[self.pickedRouteHeaderView valueForKey:@"_iconImageView"]).layer.substitutedContentsMultiplyColor = [UIColor blackColor];
			[((UIImageView *)[self.pickedRouteHeaderView valueForKey:@"_iconImageView"]).layer setDarkModeEnabled:darkModeEnabled];
		}
		if ([self.pickedRouteHeaderView valueForKey:@"_disclosureIndicatorImageView"]) {
			[((UIImageView *)[self.pickedRouteHeaderView valueForKey:@"_disclosureIndicatorImageView"]).layer setDarkModeEnabled:darkModeEnabled];
		}
		if ([self.pickedRouteHeaderView valueForKey:@"_disclosureIndicatorImageView"]) {
			[((UIImageView *)[self.pickedRouteHeaderView valueForKey:@"_disclosureIndicatorImageView"]).layer setDarkModeEnabled:darkModeEnabled];
		}
		if ([self.pickedRouteHeaderView valueForKey:@"_bottomSeparatorLayer"]) {
			((CAShapeLayer *)[self.pickedRouteHeaderView valueForKey:@"_bottomSeparatorLayer"]).substitutedFillColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.225];
			[(CAShapeLayer *)[self.pickedRouteHeaderView valueForKey:@"_bottomSeparatorLayer"] setDarkModeEnabled:darkModeEnabled];
		}
		if ([self.pickedRouteHeaderView valueForKey:@"_topSeparatorLayer"]) {
			((CAShapeLayer *)[self.pickedRouteHeaderView valueForKey:@"_topSeparatorLayer"]).substitutedFillColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.225];
			[(CAShapeLayer *)[self.pickedRouteHeaderView valueForKey:@"_topSeparatorLayer"] setDarkModeEnabled:darkModeEnabled];
		}
	}
	if ([(UIViewController *)self.delegate valueForKey:@"_routingViewController"]) {
		if ([[(UIViewController *)self.delegate valueForKey:@"_routingViewController"] valueForKey:@"_emptyStateView"]) {
			if ([[[(UIViewController *)self.delegate valueForKey:@"_routingViewController"] valueForKey:@"_emptyStateView"] valueForKey:@"_label"]) {
				[((UILabel *)[[[(UIViewController *)self.delegate valueForKey:@"_routingViewController"] valueForKey:@"_emptyStateView"] valueForKey:@"_label"]).layer setSubstitutedContentsMultiplyColor:[UIColor whiteColor]];
				[((UILabel *)[[[(UIViewController *)self.delegate valueForKey:@"_routingViewController"] valueForKey:@"_emptyStateView"] valueForKey:@"_label"]).layer setDarkModeEnabled:darkModeEnabled];
			}
			if ([[[(UIViewController *)self.delegate valueForKey:@"_routingViewController"] valueForKey:@"_emptyStateView"] valueForKey:@"_activityIndicator"]) {
				((UIActivityIndicatorView *)[[[(UIViewController *)self.delegate valueForKey:@"_routingViewController"] valueForKey:@"_emptyStateView"] valueForKey:@"_activityIndicator"]).substitutedSpinnerColor = [UIColor whiteColor];
				[(UIView *)[[[(UIViewController *)self.delegate valueForKey:@"_routingViewController"] valueForKey:@"_emptyStateView"] valueForKey:@"_activityIndicator"] setDarkModeEnabled:darkModeEnabled];
			}
		}
	}
}
%end

%hook MPAVRoutingTableViewCell
- (void)layoutSubviews {
	%orig;
	if ([self valueForKey:@"_iconImageView"]) {
		((UIImageView *)[self valueForKey:@"_iconImageView"]).shouldForceTemplateImage = YES;
		((UIImageView *)[self valueForKey:@"_iconImageView"]).image = [((UIImageView *)[self valueForKey:@"_iconImageView"]).image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		((UIImageView *)[self valueForKey:@"_iconImageView"]).substitutedTintColor = [UIColor whiteColor];
		((UIImageView *)[self valueForKey:@"_iconImageView"]).correctTintColor = [UIColor blackColor];
		[(UIImageView *)[self valueForKey:@"_iconImageView"] setDarkModeEnabled:darkModeEnabled];
		//((UIImageView *)[self valueForKey:@"_iconImageView"]).layer.substitutedContentsMultiplyColor = [UIColor clearColor];
		// CAFilter *multiplyFilter = [[CAFilter alloc] initWithName:@"multiplyColor"];
		// [multiplyFilter setValue:(id) [[UIColor colorWithWhite:1 alpha:1] CGColor] forKey:@"inputColor"];
		// multiplyFilter.isDarkModeFilter = YES;
		// [((UIImageView *)[self valueForKey:@"_iconImageView"]).layer setFilters:[NSArray arrayWithObjects:multiplyFilter, nil]];
		// [((UIImageView *)[self valueForKey:@"_iconImageView"]).layer setDarkModeEnabled:darkModeEnabled];
		//[((UIImageView *)[self valueForKey:@"_iconImageView"]).layer setDarkModeEnabled:darkModeEnabled];

	}
	if ([self valueForKey:@"_routeNameLabel"]) {
		[(UILabel *)[self valueForKey:@"_routeNameLabel"] setSubstitutedTextColor:[UIColor whiteColor]];
		[(UILabel *)[self valueForKey:@"_routeNameLabel"] setDarkModeEnabled:darkModeEnabled];
	}
	if ([self valueForKey:@"_subtitleTextLabel"]) {
		[(UILabel *)[self valueForKey:@"_subtitleTextLabel"] setSubstitutedTextColor:[UIColor whiteColor]];
		[(UILabel *)[self valueForKey:@"_subtitleTextLabel"] setDarkModeEnabled:darkModeEnabled];
	}
	if ([self valueForKey:@"_spinnerView"]) {
		((UIActivityIndicatorView *)[self valueForKey:@"_spinnerView"]).substitutedSpinnerColor = [UIColor whiteColor];
		[(UIActivityIndicatorView *)[self valueForKey:@"_spinnerView"] setDarkModeEnabled:darkModeEnabled];
	}
	if ([self valueForKey:@"_mirroringLabel"]) {
		[(UILabel *)[self valueForKey:@"_mirroringLabel"] setSubstitutedTextColor:[UIColor whiteColor]];
		[(UILabel *)[self valueForKey:@"_mirroringLabel"] setDarkModeEnabled:darkModeEnabled];
	}
	if ([self valueForKey:@"_accessoryView"]) {
		if ([[self valueForKey:@"_accessoryView"] isKindOfClass:NSClassFromString(@"UIButton")]) {
			UIButton *button = (UIButton *)[self valueForKey:@"_accessoryView"];
			button.substitutedTintColor = [UIColor whiteColor];
			[button setDarkModeEnabled:darkModeEnabled];
		}
	}
	if ([self valueForKey:@"_mirroringSwitch"]) {

	}
	if ([self valueForKey:@"_mirroringSeparatorView"]) {

	}
	[self setDarkModeEnabled:darkModeEnabled];
}
%new
- (void)darkModeChanged:(NSNotification *)notification {
	[self setDarkModeEnabled:darkModeEnabled];
}
%new
- (void)setDarkModeEnabled:(BOOL)enabled {

	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(darkModeChanged:)
	                                             	 name:@"com.sadie.ogygia.darkmodechanged"
	                                           	   object:nil];
	}
	if (self.isDarkModeEnabled != enabled) {
		if (enabled) {
			//self.iconStyle = 1;
		} else self.iconStyle = 0;
		self.route = self.route;
	}

	callSuper(objc_getClass("UIView"),self,@selector(setDarkModeEnabled:),enabled);
}
%end

%hook MPUEmptyNowPlayingView
- (void)layoutSubviews {
	%orig;
	if ([self valueForKey:@"_continueListeningLabel"]) {
		[(UILabel *)[self valueForKey:@"_continueListeningLabel"] setSubstitutedTextColor:[UIColor whiteColor]];
		[(UILabel *)[self valueForKey:@"_continueListeningLabel"] setDarkModeEnabled:darkModeEnabled];
		[((UILabel *)[self valueForKey:@"_continueListeningLabel"]).layer setSubstitutedContentsMultiplyColor:[UIColor whiteColor]];
		[((UILabel *)[self valueForKey:@"_continueListeningLabel"]).layer setDarkModeEnabled:darkModeEnabled];
	}
	[self setSubstitutedBackgroundColor:[UIColor colorWithWhite:1 alpha:0.15]];
	[self setDarkModeEnabled:darkModeEnabled];

}
%end

// Begin Confero2 Support

%hook PopoverView
- (void)layoutSubviews {
	%orig;
	if (self.contentView) {
		for (UIView *view in [self.contentView subviews]) {
			if ([view isKindOfClass:[UILabel class]]) {
				UILabel *label = (UILabel *)view;
				label.substitutedTextColor = [UIColor colorWithWhite:1 alpha:0.9];
				[label setDarkModeEnabled:CFPreferencesGetAppBooleanValue((CFStringRef)@"OGYDarkModeEnabled", CFSTR("com.sadie.ogygie"), NULL)];
			}
		}
	}
}
%end

%hook ConferoExtraCollectionViewCell
- (void)setSubEffectView:(NCMaterialView *)effectView {
	%orig;
	if (effectView) {
		effectView.backgroundColor = nil;
	}
}
%end

%hook ConferoIconView
%property (nonatomic, retain) UIVisualEffectView *vibrancyView;
- (void)setLabel:(UILabel *)label {
	%orig;
	label.substitutedTextColor = [UIColor colorWithWhite:1 alpha:0.9];
	[label setDarkModeEnabled:CFPreferencesGetAppBooleanValue((CFStringRef)@"OGYDarkModeEnabled", CFSTR("com.sadie.ogygie"), NULL)];
}
%end

// End Confero2 Support




// Begin iOS 9.3 support

%hook SBControlCenterContentContainerView
%property (nonatomic, retain) _UIBackdropView *substitutedBackdropView;
%property (nonatomic, retain) UIView *fakeWhiteLayerView;
-(void)_updateBackground {
	%orig;
	if ([self valueForKey:@"_backdropView"]) {
		[self setDarkModeEnabled:darkModeEnabled];
		[self.substitutedBackdropView _setContinuousCornerRadius:((_UIBackdropView *)[self valueForKey:@"_backdropView"])._continuousCornerRadius];
	}
	//[self _setSubviewsContinuousCornerRadius:((_UIBackdropView *)[self valueForKey:@"_backdropView"])._continuousCornerRadius];
}
- (void)layoutSubviews {
	%orig;
	if ([self valueForKey:@"_backdropView"]) {
		[self setDarkModeEnabled:darkModeEnabled];
		[self.substitutedBackdropView _setContinuousCornerRadius:((_UIBackdropView *)[self valueForKey:@"_backdropView"])._continuousCornerRadius];
	}
	if (self.fakeWhiteLayerView) {
		self.fakeWhiteLayerView.frame = self.frame;
		for (UIView *view in [self.fakeWhiteLayerView subviews]) {
			view.frame = self.frame;
		}
	}
}


%new
- (void)setDarkModeEnabled:(BOOL)enabled {
	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(darkModeChanged:)
	                                             	 name:@"com.sadie.ogygia.darkmodechanged"
	                                           	   object:nil];
	}

	if (!self.substitutedBackdropView) {
		// if ([[[self valueForKey:@"_backdropView"] valueForKey:@"_inputSettings"] respondsToSelector:@selector(_isBlurred)] && [[[self valueForKey:@"_backdropView"] valueForKey:@"_inputSettings"] respondsToSelector:@selector(_isDarkened)]) {
		
			Class newClass = nil;
			// NCLookViewBackdropViewSettings *old = (NCLookViewBackdropViewSettings *)[[self valueForKey:@"_backdropView"] valueForKey:@"_inputSettings"];
			// if (![old _isDarkened] && ![old _isBlurred]) {
			// 	newClass = NSClassFromString(@"OYGBackdropViewSettings");
			// } else {
				newClass = NSClassFromString(@"OYGBackdropViewSettingsBlurred");
			// }

			if (newClass) {
				self.substitutedBackdropView = [[NSClassFromString(@"_UIBackdropView") alloc] initWithSettings:[newClass new]];
				((_UIBackdropView *)[self valueForKey:@"_backdropView"]).duplicatedBackdropView = self.substitutedBackdropView;
				self.substitutedBackdropView.translatesAutoresizingMaskIntoConstraints = NO;
				self.substitutedBackdropView.hidden = YES;
				self.substitutedBackdropView._continuousCornerRadius = ((_UIBackdropView *)[self valueForKey:@"_backdropView"])._continuousCornerRadius;
				[self addSubview:self.substitutedBackdropView];
				[self sendSubviewToBack:self.substitutedBackdropView];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:self.substitutedBackdropView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:0]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:self.substitutedBackdropView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:0]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:self.substitutedBackdropView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:0]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:self.substitutedBackdropView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:0]];
			}
			self.fakeWhiteLayerView = [[UIView alloc] initWithFrame:self.frame];
			self.fakeWhiteLayerView.backgroundColor = nil;
			UIView *subStuff = [[UIView alloc] initWithFrame:self.frame];
			subStuff.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
			[self.fakeWhiteLayerView addSubview:subStuff];
			//[[whiteView layer] setContentsMultiplyColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor];
			[self addSubview:self.fakeWhiteLayerView];
			[self sendSubviewToBack:self.fakeWhiteLayerView];
			[self sendSubviewToBack:self.backdropView];
			[self sendSubviewToBack:self.substitutedBackdropView];
			// [[self superview] sendSubviewToBack:whiteView];
			// [self sendSubviewToBack:whiteView];
			CAFilter *multiplyFilter = [[CAFilter alloc] initWithName:@"multiplyColor"];
		    [multiplyFilter setValue:(id) [[UIColor colorWithWhite:0 alpha:0.2] CGColor] forKey:@"inputColor"];
		    [[self.fakeWhiteLayerView layer] setFilters:[NSArray arrayWithObject:multiplyFilter]];
				//}
			}

	if (self.isDarkModeEnabled != darkModeEnabled) {
		//[self.substitutedBackdropView _setContinuousCornerRadius:((_UIBackdropView *)[self valueForKey:@"_backdropView"])._continuousCornerRadius];
		((_UIBackdropView *)[self valueForKey:@"_backdropView"]).hidden = enabled;
		self.substitutedBackdropView.hidden = enabled ? NO : YES;
		self.fakeWhiteLayerView.hidden = enabled ? NO : YES;
		if ([self valueForKey:@"_lighteningView"]) {
			[(UIView *)[self valueForKey:@"_lighteningView"] setHidden:enabled];
		}
		if (self.fakeWhiteLayerView) {
			self.fakeWhiteLayerView.frame = self.frame;
			for (UIView *view in [self.fakeWhiteLayerView subviews]) {
				view.frame = self.frame;
			}
		}
	}
	[self.substitutedBackdropView _setContinuousCornerRadius:((_UIBackdropView *)[self valueForKey:@"_backdropView"])._continuousCornerRadius];

	callSuper(objc_getClass("UIView"),self,@selector(setDarkModeEnabled:),enabled);

}
%end

%hook UIVisualEffect
%property (nonatomic, assign) BOOL isDarkModeEnabled;
%property (nonatomic, assign) BOOL hasChangeListener;
%property (nonatomic, retain) UIVisualEffect *substitutedEffect;
%property (nonatomic, retain) UIVisualEffectView *effectView;
%new
- (void)darkModeChanged:(NSNotification *)notification {
	[self setDarkModeEnabled:darkModeEnabled];
}

%new
- (void)setDarkModeEnabled:(BOOL)enabled {
	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(darkModeChanged:)
	                                             	 name:@"com.sadie.ogygia.darkmodechanged"
	                                           	   object:nil];
	}
	if (self.isDarkModeEnabled != enabled) {
	self.isDarkModeEnabled = enabled;
	if (self.substitutedEffect) {
		if (self.effectView) {
			[self.effectView _configureForCurrentEffect];
		}
	} } else self.isDarkModeEnabled = enabled;
}

- (id)effectConfig {
	if (self.isDarkModeEnabled && self.substitutedEffect) {
		return [self.substitutedEffect effectConfig];
	} else return %orig;
}
%end

%hook SBUIControlCenterVisualEffect
+ (id)effectWithStyle:(NSInteger)style {
	SBUIControlCenterVisualEffect *effect = %orig;
	if (style == 0) {
		effect.substitutedEffect = [NSClassFromString(@"OGYUIControlCenterVisualEffect") effectWithStyle:0];
		[effect setDarkModeEnabled:darkModeEnabled];
	}
	return effect;
}
- (id)effectConfig {
	if (self.isDarkModeEnabled && self.substitutedEffect) {
		return [self.substitutedEffect effectConfig];
	} else return %orig;
}
%end

%hook SBUIControlCenterSlider
- (void)_updateEffects {
	%orig;
	if ([self valueForKey:@"_maxValueImageView"]) {
		((UIImageView *)[self valueForKey:@"_maxValueImageView"]).shouldForceTemplateImage = YES;
		((UIImageView *)[self valueForKey:@"_maxValueImageView"]).image = [((UIImageView *)[self valueForKey:@"_maxValueImageView"]).image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		((UIImageView *)[self valueForKey:@"_maxValueImageView"]).substitutedTintColor = [UIColor whiteColor];
		((UIImageView *)[self valueForKey:@"_maxValueImageView"]).correctTintColor = [UIColor blackColor];
		((UIImageView *)[self valueForKey:@"_maxValueImageView"]).tintColor = [UIColor blackColor];
		((UIImageView *)[self valueForKey:@"_maxValueImageView"]).layer.substitutedCompositingFilter = @"";
		[(UIImageView *)[self valueForKey:@"_maxValueImageView"] setDarkModeEnabled:darkModeEnabled];
		[((UIView *)[self valueForKey:@"_maxValueImageView"]).layer setDarkModeEnabled:darkModeEnabled];
	}
	if ([self valueForKey:@"_minValueImageView"]) {
		// CAFilter *invertFilter = [CAFilter filterWithType:@"colorMatrix"];
  //       [invertFilter setValue:[NSValue valueWithCAColorMatrix:(CAColorMatrix){-1,0,0,0,1,0,-1,0,0,1,0,0,-1,0,1,0,0,0,1,0}] forKey:@"inputColorMatrix"];
  //       invertFilter.isDarkModeFilter = YES;

		((UIImageView *)[self valueForKey:@"_minValueImageView"]).shouldForceTemplateImage = YES;
		((UIImageView *)[self valueForKey:@"_minValueImageView"]).image = [((UIImageView *)[self valueForKey:@"_minValueImageView"]).image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		((UIImageView *)[self valueForKey:@"_minValueImageView"]).substitutedTintColor = [UIColor whiteColor];
		((UIImageView *)[self valueForKey:@"_minValueImageView"]).correctTintColor = [UIColor blackColor];
		((UIImageView *)[self valueForKey:@"_minValueImageView"]).tintColor = [UIColor blackColor];
		((UIImageView *)[self valueForKey:@"_minValueImageView"]).layer.substitutedCompositingFilter = @"";
		[(UIImageView *)[self valueForKey:@"_minValueImageView"] setDarkModeEnabled:darkModeEnabled];
		//[((UIView *)[self valueForKey:@"_minValueImageView"]).layer setFilters:[NSArray arrayWithObject:invertFilter]];
		[((UIView *)[self valueForKey:@"_minValueImageView"]).layer setDarkModeEnabled:darkModeEnabled];

	}

}
%end

%hook SBUIControlCenterButton
-(void)_updateEffects {
	%orig;

	if ([self valueForKey:@"_glyphImageView"]) {
	//	if (!((UIView *)[self valueForKey:@"_glyphImageView"]).layer.hasChangeListener) {
			CAFilter *invertFilter = [CAFilter filterWithType:@"colorMatrix"];
	        [invertFilter setValue:[NSValue valueWithCAColorMatrix:(CAColorMatrix){-1,0,0,0,1,0,-1,0,0,1,0,0,-1,0,1,0,0,0,1,0}] forKey:@"inputColorMatrix"];
	        invertFilter.isDarkModeFilter = YES;

			((UIView *)[self valueForKey:@"_glyphImageView"]).layer.substitutedCompositingFilter = @"";
			// [(UIImageView *)[self valueForKey:@"_glyphImageView"] setDarkModeEnabled:darkModeEnabled];
			// [((UIView *)[self valueForKey:@"_glyphImageView"]).layer setDarkModeEnabled:darkModeEnabled];
			//((UIImageView *)[self valueForKey:@"_minValueImageView"]).layer.substitutedCompositingFilter = @"s";
		//[(UIImageView *)[self valueForKey:@"_minValueImageView"] setDarkModeEnabled:darkModeEnabled];
		[((UIView *)[self valueForKey:@"_glyphImageView"]).layer setFilters:[NSArray arrayWithObject:invertFilter]];
		[((UIView *)[self valueForKey:@"_glyphImageView"]).layer setDarkModeEnabled:darkModeEnabled];
		//}
	}
	//[self setDarkModeEnabled:darkModeEnabled];
	// if ([self valueForKey:@"_label"]) {
	// 	[((UILabel *)[self valueForKey:@"_label"]).layer setDarkModeEnabled:darkModeEnabled];
	// 	[(UILabel *)[self valueForKey:@"_label"] setDarkModeEnabled:darkModeEnabled];
	// }
	// if ([self valueForKey:@"_alteredStateLabel"]) {
	// 	[((UILabel *)[self valueForKey:@"_alteredStateLabel"]).layer setDarkModeEnabled:darkModeEnabled];
	// 	[(UILabel *)[self valueForKey:@"_alteredStateLabel"] setDarkModeEnabled:darkModeEnabled];
	// }
}
- (void)_updateForStateChange {
	%orig;
	if (!self.selected || self.state == 4) {
		((UIImageView *)[self valueForKey:@"_glyphImageView"]).substitutedAlpha = [UIColor colorWithWhite:1 alpha:1];
		[(UIImageView *)[self valueForKey:@"_glyphImageView"] setDarkModeEnabled:darkModeEnabled];
	} else {
		((UIImageView *)[self valueForKey:@"_glyphImageView"]).substitutedAlpha = [UIColor colorWithWhite:1 alpha:0.65];
		[(UIImageView *)[self valueForKey:@"_glyphImageView"] setDarkModeEnabled:darkModeEnabled];
	}
}
%end

%hook SBCCButtonLikeSectionView
-(void)_updateEffects {
	%orig;
	if ([self valueForKey:@"_label"]) {
		((UILabel *)[self valueForKey:@"_label"]).substitutedTextColor = [UIColor whiteColor];
		((UILabel *)[self valueForKey:@"_label"]).layer.substitutedCompositingFilter = @"";
		[(UILabel *)[self valueForKey:@"_label"] setDarkModeEnabled:darkModeEnabled];
		[((UILabel *)[self valueForKey:@"_label"]).layer setDarkModeEnabled:darkModeEnabled];
	}

}
%end

%hook UIVisualEffectView
-(void)setEffect:(UIVisualEffect *)effect {
	if (self.effect) {
		self.effect.effectView = nil;
	}
	%orig;
	self.effect.effectView = self;
}
-(void)_setEffect:(UIVisualEffect *)effect {
	if (self.effect) {
		self.effect.effectView = nil;
	}
	%orig;
	self.effect.effectView = self;
	%orig;
}
-(id)initWithEffect:(UIVisualEffect *)effect {
	UIVisualEffectView *orig = %orig;
	orig.effect.effectView = orig;
	return orig;
}
%end
// End iOS 9.3.3 Support


%end


%group General
%hook UIView
%property (nonatomic, assign) BOOL isDarkModeEnabled;
%property (nonatomic, assign) BOOL hasChangeListener;
%property (nonatomic, assign) BOOL darkModeChangeInProgress;
%property (nonatomic, retain) UIColor *correctBackgroundColor;
%property (nonatomic, retain) UIColor *substitutedBackgroundColor;
%property (nonatomic, retain) UIColor *correctAlpha;
%property (nonatomic, retain) UIColor *substitutedAlpha;
%new
- (void)applyInvertThing {
	applyInvertFilter(self);
}

- (void)setAlpha:(CGFloat)alpha {
	if (alpha != [self.substitutedAlpha alphaComponent]) {
		self.correctAlpha = [UIColor colorWithWhite:1 alpha:alpha];
	}
	if (darkModeEnabled && self.hasChangeListener) {
		//if (alpha != [self.substitutedAlpha alphaComponent]) {
			if (self.substitutedAlpha) {
				%orig([self.substitutedAlpha alphaComponent]);
			} else {
				%orig;
			}
		// } else {
		// 	%orig;
		// }
	} else {
		%orig;
	}
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
	if (backgroundColor && ![backgroundColor isEqual:[self.substitutedBackgroundColor isEqual:[UIColor clearColor]] ? nil : self.substitutedBackgroundColor]) {
		self.correctBackgroundColor = backgroundColor;
	}
	if (darkModeEnabled && self.hasChangeListener) {
		if (![backgroundColor isEqual:self.substitutedBackgroundColor]) {
			if (self.substitutedBackgroundColor) {
				%orig([self.substitutedBackgroundColor isEqual:[UIColor clearColor]] ? nil : self.substitutedBackgroundColor);
			} else {
				%orig;
			}
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}

%new
- (void)darkModeChanged:(NSNotification *)notification {
	[self setDarkModeEnabled:darkModeEnabled];
}
%new
- (void)setDarkModeEnabled:(BOOL)enabled {

	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(darkModeChanged:)
	                                             	 name:@"com.sadie.ogygia.darkmodechanged"
	                                           	   object:nil];
	}

	if (self.substitutedBackgroundColor) {
		if (self.isDarkModeEnabled != enabled) {
			if (enabled) {
				self.backgroundColor = [self.substitutedBackgroundColor isEqual:[UIColor clearColor]] ? nil : self.substitutedBackgroundColor;
			} else {
					self.backgroundColor = self.correctBackgroundColor;
			}
		} else if (enabled && ![self.backgroundColor isEqual:self.substitutedBackgroundColor]) {
			self.backgroundColor = [self.substitutedBackgroundColor isEqual:[UIColor clearColor]] ? nil : self.substitutedBackgroundColor;
		}
	}
	if (self.substitutedAlpha) {
		if (enabled) {
			self.alpha = [self.substitutedAlpha alphaComponent];
		} else {
			self.alpha = [self.correctAlpha alphaComponent];
		}
	}

	self.isDarkModeEnabled = enabled;
}
%end

%hook UIActivityIndicatorView
%property (nonatomic, retain) UIColor *correctSpinnerColor;
%property (nonatomic, retain) UIColor *substitutedSpinnerColor;
- (void)setColor:(UIColor *)spinnerColor {

	if (spinnerColor && ![spinnerColor isEqual:[self.substitutedSpinnerColor isEqual:[UIColor clearColor]] ? nil : self.substitutedSpinnerColor]) {
		self.correctSpinnerColor = spinnerColor;
	}
	if (darkModeEnabled && self.hasChangeListener) {
		if (![spinnerColor isEqual:self.substitutedSpinnerColor]) {
			if (self.substitutedSpinnerColor) {
				%orig([self.substitutedSpinnerColor isEqual:[UIColor clearColor]] ? nil : self.substitutedSpinnerColor);
			} else {
				%orig;
			}
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}

%new
- (void)darkModeChanged:(NSNotification *)notification {
	[self setDarkModeEnabled:darkModeEnabled];
}
%new
- (void)setDarkModeEnabled:(BOOL)enabled {

	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(darkModeChanged:)
	                                             	 name:@"com.sadie.ogygia.darkmodechanged"
	                                           	   object:nil];
	}
	if (self.substitutedSpinnerColor) {
		if (self.isDarkModeEnabled != enabled) {
			if (enabled) {
				self.color = [self.substitutedSpinnerColor isEqual:[UIColor clearColor]] ? nil : self.substitutedSpinnerColor;
			} else {
					self.color = self.correctSpinnerColor;
			}
		} else if (enabled && ![self.color isEqual:self.substitutedSpinnerColor]) {
			self.color = [self.substitutedSpinnerColor isEqual:[UIColor clearColor]] ? nil : self.substitutedSpinnerColor;
		}
	}

	self.isDarkModeEnabled = enabled;
}
%end

%hook UIButton
%property (nonatomic, retain) UIColor *correctTintColor;
%property (nonatomic, retain) UIColor *substitutedTintColor;
- (void)setTintColor:(UIColor *)tintColor {
	if (![tintColor isEqual:self.substitutedTintColor]) {
		self.correctTintColor = tintColor;
	}
	if (darkModeEnabled && self.hasChangeListener) {
		if (![tintColor isEqual:self.substitutedTintColor]) {
			if (self.substitutedTintColor) {
				%orig(self.substitutedTintColor);
			} else {
				%orig;
			}
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}
%new
- (void)setDarkModeEnabled:(BOOL)enabled {
	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self
	                                			 selector:@selector(darkModeChanged:)
	                                         	     name:@"com.sadie.ogygia.darkmodechanged"
	                                       	       object:nil];
	}
	if (self.substitutedTintColor) {
		if (self.isDarkModeEnabled != enabled) {
			if (enabled) {
				self.tintColor = self.substitutedTintColor;
			} else {
				if (self.substitutedTintColor) {
					self.tintColor = self.correctTintColor;
				}
			}
		} else if (enabled && ![self.tintColor isEqual:self.substitutedTintColor]) {
			self.tintColor = self.substitutedTintColor;
		}
	}
	callSuper(objc_getClass("UIView"),self,@selector(setDarkModeEnabled:),enabled);
}
%end

%hook UILabel
%property (nonatomic, retain) UIColor *correctTextColor;
%property (nonatomic, retain) UIColor *substitutedTextColor;
- (void)setTextColor:(UIColor *)textColor {
	if (![textColor isEqual:self.substitutedTextColor]) {
		self.correctTextColor = textColor;
	}
	if (darkModeEnabled && self.hasChangeListener) {
		if (![textColor isEqual:self.substitutedTextColor]) {
			if (self.substitutedTextColor) {
				%orig(self.substitutedTextColor);
			} else {
				%orig;
			}
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}
%new
- (void)setDarkModeEnabled:(BOOL)enabled {
	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(darkModeChanged:)
	                                             	 name:@"com.sadie.ogygia.darkmodechanged"
	                                           	   object:nil];
	}
	if (self.substitutedTextColor) {
		if (self.isDarkModeEnabled != enabled) {
			if (enabled) {
				self.textColor = self.substitutedTextColor;
			} else {
				if (self.substitutedTextColor) {
					self.textColor = self.correctTextColor;
				}
			}
		} else if (enabled && ![self.textColor isEqual:self.substitutedTextColor]) {
			self.textColor = self.substitutedTextColor;
		}
	}
	callSuper(objc_getClass("UIView"),self,@selector(setDarkModeEnabled:),enabled);
}
%end

%hook UIImageView
%property (nonatomic, assign) BOOL isWhiteLayerView;
%property (nonatomic, assign) BOOL shouldForceTemplateImage;
%property (nonatomic, retain) UIView *contentsMultiplyView;
%property (nonatomic, retain) UIColor *correctTintColor;
%property (nonatomic, retain) UIColor *substitutedTintColor;

%new
- (void)toggleDarkModeStuff {
	if (darkModeEnabled) {
		postDarkModeDisabledNotification();
	} else {
		postDarkModeEnabledNotification();
	}
}

- (void)setTintColor:(UIColor *)tintColor {
	if (![tintColor isEqual:self.substitutedTintColor]) {
		self.correctTintColor = tintColor;
	}
	if (darkModeEnabled && self.hasChangeListener) {
		if (![tintColor isEqual:self.substitutedTintColor]) {
			if (self.substitutedTintColor) {
				%orig(self.substitutedTintColor);
			} else {
				%orig;
			}
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}
- (void)setImage:(UIImage *)image {
	if (self.shouldForceTemplateImage && image) {
		%orig([image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]);
	} else {
		%orig;
	}
	if (self.isWhiteLayerView) {
		if (image) {
			self.correctBackgroundColor = [UIColor clearColor];
		}
		[self setDarkModeEnabled:darkModeEnabled];
	}
}
%new
- (void)setDarkModeEnabled:(BOOL)enabled {
	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self
	                                			 selector:@selector(darkModeChanged:)
	                                         	     name:@"com.sadie.ogygia.darkmodechanged"
	                                       	       object:nil];
	}
	if (self.isWhiteLayerView) {
		// if ([self.correctBackgroundColor isEqual:self.substitutedBackgroundColor]) {

		// }
		// self.correctBackgroundColor
		self.substitutedBackgroundColor = [UIColor clearColor];
		if (!self.contentsMultiplyView) {
			self.contentsMultiplyView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
			self.contentsMultiplyView.translatesAutoresizingMaskIntoConstraints = NO;
			[self addSubview:self.contentsMultiplyView];
			[self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentsMultiplyView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:0]];
			[self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentsMultiplyView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0]];
			[self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentsMultiplyView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1
                                                              constant:0]];
			[self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentsMultiplyView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1
                                                              constant:0]];
			self.contentsMultiplyView.substitutedBackgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.35];
			[self.contentsMultiplyView setDarkModeEnabled:enabled];
			self.contentsMultiplyView.hidden = YES;
		}
		if (self.contentsMultiplyView) {
			self.contentsMultiplyView.layer.cornerRadius = self.layer.cornerRadius;
			self.contentsMultiplyView.clipsToBounds = YES;
		}
		//if (self.isDarkModeEnabled != enabled) {
			if (enabled) {
				if (self.image) {
					//self.substitutedBackgroundColor = [UIColor clearColor];
					self.contentsMultiplyView.hidden = YES;
					self.contentsMultiplyView.alpha = 0;
					self.layer.filters = nil;

					//self.substitutedBackgroundColor = [UIColor clearColor];
				} else {
					self.layer.filters = nil;
					self.layer.substitutedContentsMultiplyColor = [UIColor clearColor];
					CAFilter *multiplyFilter = [[CAFilter alloc] initWithName:@"multiplyColor"];
				    [multiplyFilter setValue:(id) [[UIColor colorWithWhite:0 alpha:0.15] CGColor] forKey:@"inputColor"];
				    multiplyFilter.isDarkModeFilter = YES;
				    [self.layer setFilters:[NSArray arrayWithObjects:multiplyFilter, nil]];
					[self.layer setDarkModeEnabled:darkModeEnabled];
					self.contentsMultiplyView.hidden = NO;
					self.contentsMultiplyView.alpha = 1;

				}
			} else {
					self.layer.filters = nil;
					self.contentsMultiplyView.alpha = 0;
					//self.substitutedBackgroundColor = [UIColor clearColor];
					self.contentsMultiplyView.hidden = YES;
					//self.substitutedBackgroundColor = [UIColor clearColor];
			}
		}
		if (self.substitutedTintColor) {
			if (self.isDarkModeEnabled != enabled) {
				if (enabled) {
					self.tintColor = self.substitutedTintColor;
				} else {
					if (self.substitutedTintColor) {
						self.tintColor = self.correctTintColor;
					}
				}
			} else if (enabled && ![self.tintColor isEqual:self.substitutedTintColor]) {
				self.tintColor = self.substitutedTintColor;
			}
		}
	//}
	callSuper(objc_getClass("UIView"),self,@selector(setDarkModeEnabled:),enabled);
}
%new
- (void)behaveAsWhiteLayerView {
	self.isWhiteLayerView = YES;
	[self setDarkModeEnabled:darkModeEnabled];
}
%end

%hook CAFilter
%property (nonatomic, assign) BOOL isDarkModeFilter;
- (CAFilter *)mutableCopy {
	CAFilter *filter = %orig;
	filter.isDarkModeFilter = self.isDarkModeFilter;
	return filter;
}
%end

%hook CALayer
%property (nonatomic, retain) NSArray *disabledFilters;
%property (nonatomic, assign) BOOL isDarkModeEnabled;
%property (nonatomic, assign) BOOL hasChangeListener;
%property (nonatomic, assign) BOOL isCheckingDarkMode;
%property (nonatomic, retain) UIColor *correctContentsMultiplyColor;
%property (nonatomic, retain) UIColor *substitutedContentsMultiplyColor;
%property (nonatomic, retain) NSString *substitutedCompositingFilter;
%property (nonatomic, retain) NSString *correctCompositingFilter;
- (void)setFilters:(NSArray *)filters {
	%orig;
	// if (!self.isCheckingDarkMode) {
	// 	self.disabledFilters = filters;
	// }
	if (darkModeEnabled && self.hasChangeListener && !self.isCheckingDarkMode) {
		[self setDarkModeEnabled:darkModeEnabled];
	}
}
- (void)setCompositingFilter:(NSString *)filter {
	if (filter && ![filter isEqual:[self.substitutedCompositingFilter isEqualToString:@""] ? nil : self.substitutedCompositingFilter]) {
		self.correctCompositingFilter = filter;
	}
	if (darkModeEnabled && self.hasChangeListener) {
		if (![filter isEqual:[self.substitutedCompositingFilter isEqualToString:@""] ? nil : self.substitutedCompositingFilter]) {
			if (self.substitutedCompositingFilter) {
				%orig([self.substitutedCompositingFilter isEqualToString:@""] ? nil : self.substitutedCompositingFilter);
			} else {
				%orig;
			}
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}
- (void)setContentsMultiplyColor:(CGColorRef)contentsMultiplyColor {
	if (contentsMultiplyColor && ![[UIColor colorWithCGColor:contentsMultiplyColor] isEqual:self.substitutedContentsMultiplyColor]) {
		self.correctContentsMultiplyColor = [UIColor colorWithCGColor:contentsMultiplyColor];
	}
	if (darkModeEnabled && self.hasChangeListener) {
		if (![[UIColor colorWithCGColor:contentsMultiplyColor] isEqual:self.substitutedContentsMultiplyColor]) {
			if (self.substitutedContentsMultiplyColor) {
				%orig(self.substitutedContentsMultiplyColor.CGColor);
			} else {
				%orig;
			}
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}
%new
- (void)darkModeChanged:(NSNotification *)notification {
	[self setDarkModeEnabled:darkModeEnabled];
}
%new
- (void)setDarkModeEnabled:(BOOL)enabled {

	// if (!self.disabledFilters) {
	// 	self.disabledFilters = self.filters;
	// }
	self.isCheckingDarkMode = YES;
	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		if (!self.substitutedContentsMultiplyColor && [self respondsToSelector:@selector(contentsMultiplyColor)]) {
			self.substitutedContentsMultiplyColor = [UIColor colorWithCGColor:self.contentsMultiplyColor];
		}
		if (enabled) {
			if (self.substitutedContentsMultiplyColor && [self respondsToSelector:@selector(contentsMultiplyColor)]) {
				self.contentsMultiplyColor = self.substitutedContentsMultiplyColor.CGColor;
			}
		} else {
			if (self.substitutedContentsMultiplyColor && [self respondsToSelector:@selector(contentsMultiplyColor)]) {
				self.contentsMultiplyColor = self.correctContentsMultiplyColor.CGColor;
			}
		}

		[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(darkModeChanged:)
	                                             	 name:@"com.sadie.ogygia.darkmodechanged"
	                                           	   object:nil];

	} else {
		//if (enabled != self.isDarkModeEnabled) {
			if (enabled) {
				if (self.substitutedContentsMultiplyColor && [self respondsToSelector:@selector(contentsMultiplyColor)]) {
					self.contentsMultiplyColor = self.substitutedContentsMultiplyColor.CGColor;
				}
				if (self.substitutedCompositingFilter) {
					self.compositingFilter = [self.substitutedCompositingFilter isEqualToString:@""] ? nil : self.substitutedCompositingFilter;
				}
			} else {
				if (self.substitutedContentsMultiplyColor && [self respondsToSelector:@selector(contentsMultiplyColor)]) {
					self.contentsMultiplyColor = self.correctContentsMultiplyColor.CGColor;
				}
				if (self.substitutedCompositingFilter) {
					self.compositingFilter = self.correctCompositingFilter;
				}
			}
		if (enabled && [self respondsToSelector:@selector(contentsMultiplyColor)] && ![[UIColor colorWithCGColor:self.contentsMultiplyColor] isEqual:self.substitutedContentsMultiplyColor]) {
			self.contentsMultiplyColor = self.substitutedContentsMultiplyColor.CGColor;
		}
		if (enabled && ![self.compositingFilter isEqual:self.substitutedCompositingFilter]) {
			self.compositingFilter = [self.substitutedCompositingFilter isEqualToString:@""] ? nil : self.substitutedCompositingFilter;
		}
	}
	if (self.filters) {
		NSMutableArray *filters = [NSMutableArray new];
		for (CAFilter *filter in self.filters) {
			if (!filter.isDarkModeFilter) {
				filter.enabled = darkModeEnabled ? NO : YES;
			} else {
				filter.enabled = darkModeEnabled;
			}
			[filters addObject:[filter mutableCopy]];
		}
		self.filters = [filters copy];
	}
	self.isCheckingDarkMode = NO;

	self.isDarkModeEnabled = enabled;
}
%end

%hook CAShapeLayer
%property (nonatomic, retain) UIColor *correctFillColor;
%property (nonatomic, retain) UIColor *substitutedFillColor;
- (void)setFillColor:(CGColorRef)fillColor {
	if (fillColor && ![[UIColor colorWithCGColor:fillColor] isEqual:self.substitutedFillColor]) {
		self.correctFillColor = [UIColor colorWithCGColor:fillColor];
	}
	if (darkModeEnabled && self.hasChangeListener) {
		if (![[UIColor colorWithCGColor:fillColor] isEqual:self.substitutedFillColor]) {
			if (self.substitutedFillColor) {
				%orig(self.substitutedFillColor.CGColor);
			} else {
				%orig;
			}
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}
%new
- (void)darkModeChanged:(NSNotification *)notification {
	[self setDarkModeEnabled:darkModeEnabled];
}
%new
- (void)setDarkModeEnabled:(BOOL)enabled {

	// if (!self.disabledFilters) {
	// 	self.disabledFilters = self.filters;
	// }
	self.isCheckingDarkMode = YES;
	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		if (!self.substitutedFillColor) {
			self.substitutedFillColor = [UIColor colorWithCGColor:self.fillColor];
		}
		if (enabled) {
			if (self.substitutedFillColor) {
				self.fillColor = self.substitutedFillColor.CGColor;
			}
		} else {
			if (self.substitutedFillColor) {
				self.fillColor = self.correctFillColor.CGColor;
			}
		}

		[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(darkModeChanged:)
	                                             	 name:@"com.sadie.ogygia.darkmodechanged"
	                                           	   object:nil];

	} else {
		//if (enabled != self.isDarkModeEnabled) {
			if (enabled) {
				if (self.substitutedFillColor) {
					self.fillColor = self.substitutedFillColor.CGColor;
				}
			} else {
				if (self.substitutedFillColor) {
					self.fillColor = self.correctFillColor.CGColor;
				}
			}
		if (enabled && ![[UIColor colorWithCGColor:self.fillColor] isEqual:self.substitutedFillColor]) {
			self.fillColor = self.substitutedFillColor.CGColor;
		}
	}
	self.isCheckingDarkMode = NO;

	callSuper(objc_getClass("CALayer"),self,@selector(setDarkModeEnabled:),enabled);

}
%end

%hook _UIBackdropView
%property (nonatomic, retain) _UIBackdropView *duplicatedBackdropView;
%new
- (void)testDarkTrans {
	UIView *superview = [self superview];
	_UIBackdropView *_backdropView = [[NSClassFromString(@"_UIBackdropView") alloc] initWithSettings:[NSClassFromString(@"OYGBackdropViewSettingsBlurred") new]];
	[superview addSubview:_backdropView];
	_backdropView.frame = self.frame;
	[superview sendSubviewToBack:_backdropView];
	[self removeFromSuperview];
}
%new
- (void)darkModeChanged:(NSNotification *)notification {
	[self setDarkModeEnabled:darkModeEnabled];
}
%new
- (void)setDarkModeEnabled:(BOOL)enabled {
	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self
	                                			 selector:@selector(darkModeChanged:)
	                                         	     name:@"com.sadie.ogygia.darkmodechanged"
	                                       	       object:nil];
	}
	if ([[self valueForKey:@"_outputSettings"] isKindOfClass:NSClassFromString(@"_UIBackdropViewSettingsCombiner")]) {
		_UIBackdropViewSettingsCombiner *combiner = [self valueForKey:@"_outputSettings"];
		if ([combiner.inputSettingsA isKindOfClass:NSClassFromString(@"NCLookViewBackdropViewSettings")]) {
			if ([combiner.inputSettingsB isKindOfClass:NSClassFromString(@"OYGBackdropViewSettings")] || [combiner.inputSettingsB isKindOfClass:NSClassFromString(@"OYGBackdropViewSettingsBlurred")]) {
				if (combiner.weighting != darkModeEnabled ? (CGFloat)1.0 : (CGFloat)0) {
                    [self transitionIncrementallyToSettings:[NSClassFromString(@"OYGBackdropViewSettingsBlurred") new] weighting:darkModeEnabled ? (CGFloat)1.0 : (CGFloat)0];
                    [self computeAndApplySettingsForTransition];
				}
			}
		}
	} else {
		if ([[self valueForKey:@"_inputSettings"] respondsToSelector:@selector(_isBlurred)] && [[self valueForKey:@"_inputSettings"] respondsToSelector:@selector(_isDarkened)]) {
			NCLookViewBackdropViewSettings *old = (NCLookViewBackdropViewSettings *)[self valueForKey:@"_inputSettings"];
			Class newClass = nil;
			if (![old _isDarkened] && ![old _isBlurred]) {
				newClass = NSClassFromString(@"OYGBackdropViewSettings");
			} else {
				newClass = NSClassFromString(@"OYGBackdropViewSettingsBlurred");
			}
			if (newClass) {
                [self transitionIncrementallyToSettings:[newClass new] weighting:darkModeEnabled ? (CGFloat)1.0 : (CGFloat)0];
                [self computeAndApplySettingsForTransition];
			}
		}
	}
	self.isDarkModeEnabled = enabled;
}
-(void)setFilterMaskImage:(UIImage *)arg1 {
	if (self.duplicatedBackdropView) {
		[self.duplicatedBackdropView setFilterMaskImage:arg1];
	}
	%orig;
}
-(void)setGrayscaleTintMaskImage:(UIImage *)arg1 {
	if (self.duplicatedBackdropView) {
		[self.duplicatedBackdropView setGrayscaleTintMaskImage:arg1];
	}
	%orig;
}
-(void)setColorTintMaskImage:(UIImage *)arg1 {
	if (self.duplicatedBackdropView) {
		[self.duplicatedBackdropView setColorTintMaskImage:arg1];
	}
	%orig;
}
-(void)setColorBurnTintMaskImage:(UIImage *)arg1 {
	if (self.duplicatedBackdropView) {
		[self.duplicatedBackdropView setColorBurnTintMaskImage:arg1];
	}
	%orig;
}
-(void)setDarkeningTintMaskImage:(UIImage *)arg1 {
	if (self.duplicatedBackdropView) {
		[self.duplicatedBackdropView setDarkeningTintMaskImage:arg1];
	}
	%orig;
}
-(void)_setContinuousCornerRadius:(CGFloat)arg1 {
	if (self.duplicatedBackdropView) {
		[self.duplicatedBackdropView _setContinuousCornerRadius:arg1];
	}
	%orig;
}
%end
%hook NCMaterialView
%property (nonatomic, retain) _UIBackdropView *substitutedBackdropView;
- (void)_configureBackdropViewIfNecessary {
	%orig;
	if ([self valueForKey:@"_backdropView"]) {
		[self setDarkModeEnabled:darkModeEnabled];
		[self.substitutedBackdropView _setContinuousCornerRadius:((_UIBackdropView *)[self valueForKey:@"_backdropView"])._continuousCornerRadius];
	}
	//[self _setSubviewsContinuousCornerRadius:((_UIBackdropView *)[self valueForKey:@"_backdropView"])._continuousCornerRadius];
}

%new
- (void)setDarkModeEnabled:(BOOL)enabled {
	if (!self.hasChangeListener) {
		self.hasChangeListener = YES;
		[[NSNotificationCenter defaultCenter] addObserver:self
	                                             selector:@selector(darkModeChanged:)
	                                             	 name:@"com.sadie.ogygia.darkmodechanged"
	                                           	   object:nil];
	}

	if (!self.substitutedBackdropView) {
		if ([[[self valueForKey:@"_backdropView"] valueForKey:@"_inputSettings"] respondsToSelector:@selector(_isBlurred)] && [[[self valueForKey:@"_backdropView"] valueForKey:@"_inputSettings"] respondsToSelector:@selector(_isDarkened)]) {
		
			Class newClass = nil;
			NCLookViewBackdropViewSettings *old = (NCLookViewBackdropViewSettings *)[[self valueForKey:@"_backdropView"] valueForKey:@"_inputSettings"];
			if (![old _isDarkened] && ![old _isBlurred]) {
				newClass = NSClassFromString(@"OYGBackdropViewSettings");
			} else {
				newClass = NSClassFromString(@"OYGBackdropViewSettingsBlurred");
			}

			if (newClass) {
				self.substitutedBackdropView = [[NSClassFromString(@"_UIBackdropView") alloc] initWithSettings:[newClass new]];
				((_UIBackdropView *)[self valueForKey:@"_backdropView"]).duplicatedBackdropView = self.substitutedBackdropView;
				self.substitutedBackdropView.translatesAutoresizingMaskIntoConstraints = NO;
				self.substitutedBackdropView.hidden = YES;
				self.substitutedBackdropView._continuousCornerRadius = ((_UIBackdropView *)[self valueForKey:@"_backdropView"])._continuousCornerRadius;
				[self addSubview:self.substitutedBackdropView];
				[self sendSubviewToBack:self.substitutedBackdropView];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:self.substitutedBackdropView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:0]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:self.substitutedBackdropView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1
                                                                  constant:0]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:self.substitutedBackdropView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1
                                                                  constant:0]];
				[self addConstraint:[NSLayoutConstraint constraintWithItem:self.substitutedBackdropView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:0]];
			}
		}
	}

	if (self.isDarkModeEnabled != darkModeEnabled) {
		//[self.substitutedBackdropView _setContinuousCornerRadius:((_UIBackdropView *)[self valueForKey:@"_backdropView"])._continuousCornerRadius];
		((_UIBackdropView *)[self valueForKey:@"_backdropView"]).hidden = darkModeEnabled;
		self.substitutedBackdropView.hidden = darkModeEnabled ? NO : YES;
	}
	[self.substitutedBackdropView _setContinuousCornerRadius:((_UIBackdropView *)[self valueForKey:@"_backdropView"])._continuousCornerRadius];

	callSuper(objc_getClass("UIView"),self,@selector(setDarkModeEnabled:),enabled);

}
%end
%end


%group Toggle

@interface OGYNightSectionView : CCUIButtonLikeSectionSplitView
- (CGFloat)cornerRadius;
@end
%subclass OGYNightSectionView : CCUIButtonLikeSectionSplitView
- (id)init {
	OGYNightSectionView *orig = %orig;
	return orig;
}
%end
@interface OGYNightSectionController : CCUIControlCenterSectionViewController
@property (nonatomic, retain) CCUINightShiftSectionController *nightShiftController;
@property (nonatomic, retain) CCUIControlCenterPushButton *nightShiftSection;
@property (nonatomic, retain) CCUIControlCenterButton *nightModeSection;
@end

%subclass OGYNightSectionController : CCUIControlCenterSectionViewController
%property (nonatomic, retain) CCUINightShiftSectionController *nightShiftController;
%property (nonatomic, retain) CCUIControlCenterPushButton *nightShiftSection;
%property (nonatomic, retain) CCUIControlCenterButton *nightModeSection;

+ (Class)viewClass {
	return NSClassFromString(@"OGYNightSectionView");
}
- (id)init {
	
	OGYNightSectionController *orig = %orig;
	if (orig) {
		orig.nightShiftController = [[NSClassFromString(@"CCUINightShiftSectionController") alloc] init];
	}
	return orig;
}
- (void)loadView {
	%orig;
	((CCUIButtonLikeSectionSplitView *)self.view).mode = 0;
}
%new
- (void)handleNightModeButton:(CCUIControlCenterButton *)button {
	CFPreferencesSetAppValue ((CFStringRef)@"OGYDarkModeEnabled", (CFPropertyListRef)[NSNumber numberWithBool:button.selected], CFSTR("com.sadie.ogygie"));
	if (button.selected == YES) {
		button.text = [NSString stringWithFormat:@"Mode Théâtre:\nActivé"];
		((UILabel *)[button valueForKey:@"_alteredStateLabel"]).text = [NSString stringWithFormat:@"Mode Théâtre:\nActivé"];
		postDarkModeEnabledNotification();
	} else {
		button.text = [NSString stringWithFormat:@"Mode Théâtre:\nArrêt"];
		((UILabel *)[button valueForKey:@"_alteredStateLabel"]).text = [NSString stringWithFormat:@"Mode Théâtre:\nArrêt"];
		postDarkModeDisabledNotification();
	}
}
- (void)viewDidLoad {
	[self.nightShiftController viewDidLoad];
	if (!self.nightShiftSection) {
		self.nightShiftSection = self.nightShiftController.view.button;
		[self.nightShiftSection removeFromSuperview];
	}
	((CCUIButtonLikeSectionSplitView *)self.view).rightSection = self.nightShiftSection;
	self.nightModeSection = [NSClassFromString(@"CCUIControlCenterButton")  roundRectButtonWithText:[NSString stringWithFormat:@"Mode Théâtre:\nArrêt"] selectedGlyphColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
	self.nightModeSection.text = [NSString stringWithFormat:@"Mode Théâtre:\nArrêt"];
	self.nightModeSection.numberOfLines = 2;
	self.nightModeSection.selectedGlyphImage = [[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Application Support/Ogygia/Theatre@%@x.png", [NSNumber numberWithFloat:[[UIScreen mainScreen] scale]]]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	self.nightModeSection.glyphImage = [[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Application Support/Ogygia/Theatre@%@x.png", [NSNumber numberWithFloat:[[UIScreen mainScreen] scale]]]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	if (!self.nightModeSection.glyphImage) {
		self.nightModeSection.glyphImage = [[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/Library/Application Support/Ogygia/Theatre@%@x.png", [NSNumber numberWithFloat:[[UIScreen mainScreen] scale]]]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	}
	if (!self.nightModeSection.selectedGlyphImage) {
		self.nightModeSection.selectedGlyphImage = [[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/Library/Application Support/Ogygia/Theatre@%@x.png", [NSNumber numberWithFloat:[[UIScreen mainScreen] scale]]]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	}
	[self.nightModeSection _setButtonType:5];
	self.nightModeSection.font = self.nightShiftSection.font;
	((CCUIButtonLikeSectionSplitView *)self.view).leftSection = self.nightModeSection;
	((CCUIButtonLikeSectionSplitView *)self.view).mode = 0;
	self.nightModeSection.selected = darkModeEnabled;
	[self.nightModeSection addTarget:self action:@selector(handleNightModeButton:) forControlEvents:UIControlEventTouchUpInside];
	((UIView *)[self.nightModeSection valueForKey:@"_backgroundFlatColorView"]).layer.cornerRadius = [self.nightModeSection cornerRadius];
	((UIView *)[self.nightModeSection valueForKey:@"_backgroundFlatColorView"]).clipsToBounds = YES;
	((UIView *)[self.nightModeSection valueForKey:@"_backgroundFlatColorView"]).substitutedBackgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.125];
		[(UIView *)[self.nightModeSection valueForKey:@"_backgroundFlatColorView"] setDarkModeEnabled:darkModeEnabled];
}

-(void)viewWillAppear:(BOOL)arg1 {
	[self.nightShiftController viewWillAppear:arg1];
	%orig;
}
-(void)setDelegate:(id<CCUIControlCenterSectionViewControllerDelegate>)delegate {
	%orig;
	[self.nightShiftController setDelegate:delegate];
}
%end


%hook CCUISystemControlsPageViewController
- (void)loadView {
	%orig;
	OGYNightSectionController *controller = [[NSClassFromString(@"OGYNightSectionController") alloc] init];
	[(NSMutableArray *)[self valueForKey:@"_sectionList"] removeObject:[self valueForKey:@"_nightShiftSection"]];
	controller.delegate = self;
	[self setValue:controller forKey:@"_nightShiftSection"];
	//[(NSMutableArray *)[self valueForKey:@"_sectionList"] insertObject:controller atIndex:3];
	// [self _updateColumns];
}
-(void)_updateSectionViews {
	%orig;
	if ([(NSArray *)[self valueForKey:@"_columnStackViews"] count] > 0) {
	UIStackView *stackView = (UIStackView *)[(NSArray *)[self valueForKey:@"_columnStackViews"] objectAtIndex:0];
	NSMutableArray *views = [stackView.arrangedSubviews mutableCopy];
	for (UIView *view in views) {
		if ([view isKindOfClass:NSClassFromString(@"OGYNightSectionView")]) {
			if ([views indexOfObject:view] == 3) return;
			[stackView insertArrangedSubview:view atIndex:3];
		}
	}
	}
}
%end

%hook CCUINightShiftContentView
- (BOOL)isHidden {
	return YES;
}
%end

%hook NCNotificationTextInputView
- (instancetype)initWithFrame:(CGRect)frame {
		NCNotificationTextInputView *inputView = %orig;
	if (darkModeEnabled) {
		inputView.backgroundColor = nil;
		_UIBackdropView *_backdropView = [[NSClassFromString(@"_UIBackdropView") alloc] initWithSettings:[NSClassFromString(@"OYGBackdropViewSettingsBlurred") new]];
		[self addSubview:_backdropView];
		_backdropView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
		[self sendSubviewToBack:_backdropView];
	}
	return inputView;
}
// - (void)setBackgroundColor:(UIColor *)color {
// 	%orig([UIColor greenColor]);
// }
%end

// iOS 9.3.3 Support Begins
%hook SBCCDoNotDisturbSetting
- (void)_updateState {
	%orig;
	CFPreferencesSetAppValue ((CFStringRef)@"OGYDarkModeEnabled", (CFPropertyListRef)[NSNumber numberWithBool:[self _toggleState]], CFSTR("com.sadie.ogygie"));
	if ([self _toggleState] == YES) {
		postDarkModeEnabledNotification();
	} else {
		postDarkModeDisabledNotification();
	}
}
-(void)_setDNDEnabled:(BOOL)arg1 updateServer:(BOOL)arg2 source:(NSUInteger)arg3  {
	%orig;
	CFPreferencesSetAppValue ((CFStringRef)@"OGYDarkModeEnabled", (CFPropertyListRef)[NSNumber numberWithBool:arg1], CFSTR("com.sadie.ogygie"));
	if (arg1 == YES) {
		postDarkModeEnabledNotification();
	} else {
		postDarkModeDisabledNotification();
	}
}
%end

// iOS 9.3.3 Support Ends 
%end
// -(void)transitionIncrementallyToSettings:(id)arg1 weighting:(double)arg2 ;
// %hook _UIBackdropView
// %new
// - (void)testTransitionThing {
// 	[self transitionToSettings:[NSClassFromString(@"OYGBackdropViewSettingsBlurred") new] weighting:1.0];
// }
// %end

%hook NCVibrantSecondaryStyling
- (UIColor *)_burnColor {
	return [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1];
}
- (UIColor *)_darkenColor {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
}
- (NSString *)blendMode {
	return @"vibrantDark";
}
%end

%hook UILabel
%property (nonatomic, retain) NSString *vibrantStylingType;
- (void)nc_applyVibrantStyling:(id)styling {
	%orig;
	self.vibrantStylingType = NSStringFromClass([styling class]);
}
%end

static void darkModeTurnedOn(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	darkModeEnabled = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"com.sadie.ogygia.darkmodechanged"
                                                    object:nil
                                                  userInfo:nil];
}

static void darkModeTurnedOff(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	darkModeEnabled = NO;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"com.sadie.ogygia.darkmodechanged"
                                                    object:nil
                                                  userInfo:nil];
}

static void postDarkModeEnabledNotification() {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), CFSTR("com.sadie.ogygia.darkModeTurnedOn"), nil, nil, true);
}

static void postDarkModeDisabledNotification() {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), CFSTR("com.sadie.ogygia.darkModeTurnedOff"), nil, nil, true);
}

%ctor {
	BOOL shouldLoadGeneralHooks = NO;
	BOOL shouldLoadWidgetHooks = NO;
	BOOL shouldLoadSpringBoardHooks = NO;
	BOOL shouldLoadToggleHooks = NO;
	%init;

	if ([(NSDictionary *)[NSBundle mainBundle].infoDictionary valueForKey:@"NSExtension"]) {
		if ([[(NSDictionary *)[NSBundle mainBundle].infoDictionary valueForKey:@"NSExtension"] valueForKey:@"NSExtensionPointIdentifier"]) {
			if ([[[(NSDictionary *)[NSBundle mainBundle].infoDictionary valueForKey:@"NSExtension"] valueForKey:@"NSExtensionPointIdentifier"] isEqualToString:[NSString stringWithFormat:@"com.apple.widget-extension"]]) {
				shouldLoadWidgetHooks = YES;
				shouldLoadGeneralHooks = YES;
			}
		}
	}
	if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
		shouldLoadSpringBoardHooks = YES;
		shouldLoadGeneralHooks = YES;
		shouldLoadToggleHooks = YES;
	}
	if (shouldLoadGeneralHooks) {
		darkModeEnabled = CFPreferencesGetAppBooleanValue((CFStringRef)@"OGYDarkModeEnabled", CFSTR("com.sadie.ogygie"), NULL);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(),
                                    NULL,
                                    darkModeTurnedOff,
                                    CFSTR("com.sadie.ogygia.darkModeTurnedOff"),
                                    NULL,  
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDistributedCenter(),
                                    NULL,
                                    darkModeTurnedOn,
                                    CFSTR("com.sadie.ogygia.darkModeTurnedOn"),
                                    NULL,  
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
		%init(General);
	}
	if (shouldLoadSpringBoardHooks) {
		%init(SpringBoard);
	}
	if (shouldLoadWidgetHooks) {
		%init(Widget);
	}
	if (shouldLoadToggleHooks) {
		%init(Toggle);
	}
	%init(Simulator);
}

/* 

NCMaterialView Style Options:
1: LongLookNotificationsActionView
2: 3D Touch Action Menu HS
4: Control Center Background, Widgets Edit Button, Widgets in NC
8: Widget Content View
16: Widget Header View
36: Control Center Routing BG


SBUIActionView
Same as Widget Header


*/
