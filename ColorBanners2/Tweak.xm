#import "ColorBadges.h"

#import <objc/runtime.h>

#import "Defines.h"
#import "PrivateHeaders.h"
#import "CBRAppList.h"
#import "CBRColorCache.h"
#import "CBRGradientView.h"
#import "CBRPrefsManager.h"
#import "CBRReadabilityManager.h"
#import "UIColor+ColorBanners.h"

#define UIColorFromRGBWithAlpha(rgb, a) [UIColor colorWithRed:GETRED(rgb)/255.0 green:GETGREEN(rgb)/255.0 blue:GETBLUE(rgb)/255.0 alpha:a]
#define VIEW_TAG 0xDAE1DEE
#define DARK_GRAY 0x555555
#define MAX_RETRIES 15

static BOOL WatchNotifictionsHooked = NO;


static BOOL isWhitish(int rgb) {
  return ![CBRColorCache isDarkColor:rgb];
}

static int colorToRGBInt(int r, int g, int b) {
  return ((r << 16) | 
          (g << 8) |
          (b));
}

static BOOL compositeIsWhitish(int rgb, int bg, CGFloat fgAlpha) {
  int r = GETRED(rgb);
  int g = GETGREEN(rgb);
  int b = GETBLUE(rgb);

  int x = GETRED(bg);
  int y = GETGREEN(bg);
  int z = GETBLUE(bg);

  CGFloat bgAlpha = 1 - fgAlpha;
  int outRed = (int)(fgAlpha * r) + (int)(bgAlpha * x);
  int outGreen = (int)(fgAlpha * g) + (int)(bgAlpha * y);
  int outBlue = (int)(fgAlpha * b) + (int)(bgAlpha * z);
  return isWhitish(colorToRGBInt(outRed, outGreen, outBlue));
}

// Hack to improve the LS text coloring when the "prefersWhiteText" option is enabled.
static BOOL ls_isWhitish(int rgb) {
  if ([CBRPrefsManager sharedInstance].prefersWhiteText) {
    return compositeIsWhitish(rgb, DARK_GRAY, [CBRPrefsManager sharedInstance].lsAlpha);
  }
  return isWhitish(rgb);
}

static NSAttributedString * copyAttributedStringWithColor(NSAttributedString *str, UIColor *color) {
  NSMutableAttributedString *copy = [str mutableCopy];
  [copy addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [copy length])];
  return copy;
}

// Used for lockscreen notifications.
static id bbServer = nil;

// TODO(DavidGoldman): Figure out how to use BBAction so that it will be dismissed properly.
// Thanks to PriorityHub.
static void showTestLockScreenNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  [[%c(SBLockScreenManager) sharedInstance] lockUIFromSource:1 withOptions:nil];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.7 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    NSString *sectionID = [CBRAppList randomAppIdentifier];
    NSUInteger count = 0;
    if ([bbServer respondsToSelector:@selector(_sectionInfoForSectionID:effective:)]) {
      while (![bbServer _sectionInfoForSectionID:sectionID effective:YES] && count < MAX_RETRIES) {
        sectionID = [CBRAppList randomAppIdentifier];
      }
    }

    BBBulletin *bulletin = [[[%c(BBBulletinRequest) alloc] init] autorelease];
    bulletin.title = @"ColorBanners";
    bulletin.subtitle = @"This is a test notification!";
    bulletin.sectionID = sectionID;
    bulletin.bulletinID = @"com.golddavid.colorbanners";
    bulletin.clearable = YES;
    bulletin.showsMessagePreview = YES;
    NSDate *date = [NSDate date];
    bulletin.date = date;
    bulletin.publicationDate = date;
    bulletin.lastInterruptDate = date;

    NSURL *url= [NSURL URLWithString:@"prefs:root=ColorBanners"];
    bulletin.defaultAction = [%c(BBAction) actionWithLaunchURL:url];

    if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:alwaysToLockScreen:)]) {
      [bbServer publishBulletin:bulletin destinations:4 alwaysToLockScreen:YES];
    }
  });
}

// Thanks for TinyBar (https://github.com/alexzielenski/TinyBar).
static void showTestBanner(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  SBBannerController *controller = [%c(SBBannerController) sharedInstance];
  if ([controller _bannerContext]) { // Don't do anything if there is already a banner showing.
    return;
  }
  // Not sure if these are needed - see TinyBar.
  [NSObject cancelPreviousPerformRequestsWithTarget:controller
                                           selector:@selector(_replaceIntervalElapsed)
                                             object:nil];
  [NSObject cancelPreviousPerformRequestsWithTarget:controller
                                           selector:@selector(_dismissIntervalElapsed)
                                             object:nil];
  [controller _replaceIntervalElapsed];
  [controller _dismissIntervalElapsed];

  BBBulletin *bulletin = [[[%c(BBBulletinRequest) alloc] init] autorelease];
  bulletin.title = @"ColorBanners";
  bulletin.message = @"This is a test banner!";
  bulletin.bulletinID = @"com.golddavid.colorbanners";
  bulletin.sectionID = [CBRAppList randomAppIdentifier];
  bulletin.defaultAction = [%c(BBAction) action];

  SBBulletinBannerController *bc = [%c(SBBulletinBannerController) sharedInstance];
  if ([bc respondsToSelector:@selector(observer:addBulletin:forFeed:)]) {
    [bc observer:nil addBulletin:bulletin forFeed:2];
  } else if ([bc respondsToSelector:@selector(observer:addBulletin:forFeed:playLightsAndSirens:withReply:)]) {
    [bc observer:nil addBulletin:bulletin forFeed:2 playLightsAndSirens:YES withReply:nil];
  }
}

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  SpringBoard *sb = (SpringBoard *)[UIApplication sharedApplication];
  if ([sb respondsToSelector:@selector(_relaunchSpringBoardNow)]) {
    [sb _relaunchSpringBoardNow];
  } else if (%c(FBSystemService)) {
    [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
  }
}

%group WatchNotifictions
%hook WNContainerView
- (void)layoutContentView {
  %orig;
  if ([self superview]) {
    for (UIView *view in [[self superview] subviews]) {
      if ([view isKindOfClass:NSClassFromString(@"CBRGradientView")]) {
        UIView *container = (UIView *)[self valueForKey:@"notificationContainerView"];
        container.backgroundColor = [view.backgroundColor colorWithAlphaComponent:view.alpha];
        CAGradientLayer *gradientLayer = nil;
        BOOL isNewGradientLayer = NO;
        for (CALayer *layerObject in container.layer.sublayers) {
          if ([layerObject isKindOfClass:[CAGradientLayer class]]) {
            gradientLayer = (CAGradientLayer *)layerObject;
            break;
          }
        }
        if (!gradientLayer) {
          gradientLayer = [CAGradientLayer new];
          isNewGradientLayer = YES;
        }
        gradientLayer.frame = container.frame;
        gradientLayer.colors = ((CAGradientLayer *)view.layer).colors;
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        if (isNewGradientLayer)
          [container.layer addSublayer:gradientLayer];
      }
    }
  }
  NSLog(@"Got Stuff");
}
- (void)updateViews {
  %orig;
  if ([self superview]) {
    for (UIView *view in [[self superview] subviews]) {
      if ([view isKindOfClass:NSClassFromString(@"CBRGradientView")]) {
        UIView *container = (UIView *)[self valueForKey:@"notificationContainerView"];
        container.backgroundColor = [view.backgroundColor colorWithAlphaComponent:view.alpha];
        CAGradientLayer *gradientLayer = nil;
        BOOL isNewGradientLayer = NO;
        for (CALayer *layerObject in container.layer.sublayers) {
          if ([layerObject isKindOfClass:[CAGradientLayer class]]) {
            gradientLayer = (CAGradientLayer *)layerObject;
            break;
          }
        }
        if (!gradientLayer) {
          gradientLayer = [CAGradientLayer new];
          isNewGradientLayer = YES;
        }
        gradientLayer.frame = container.frame;
        gradientLayer.colors = ((CAGradientLayer *)view.layer).colors;
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        if (isNewGradientLayer)
          [container.layer addSublayer:gradientLayer];
      }
    }
  }
  NSLog(@"Got Stuff");
}
%new
- (void)testIt {
  NSLog(@"LOL");
}
%end
%end

%group TestNotifications
%hook BBServer
- (id)init {
  id me = %orig;
  bbServer = me;
  return me;
}
- (void)dealloc {
  if (bbServer == self) {
    bbServer = nil;
  }
  %orig;
}
%end
%end

%group LockScreen
%hook SBLockScreenNotificationListView

// TODO(DavidGoldman): Try to improve this somehow. Not exactly sure which coloring part causes
// slowdowns (probably the gradient though).
// 
// Move this into -|tableView:cellForRowAtIndexPath:| to provide proper PrettierBanners support.
- (void)_setContentForTableCell:(SBLockScreenBulletinCell *)cell
                       withItem:(SBAwayBulletinListItem *)item
                    atIndexPath:(id)path {
  %orig;
  if (!WatchNotifictionsHooked) {
      if (NSClassFromString(@"WNContainerView")) {
        %init(WatchNotifictions);
        NSLog(@"Loaded this shit");
        WatchNotifictionsHooked = YES;
      }
    }

  Class sbbc = %c(SBLockScreenBulletinCell);
  CBRPrefsManager *prefsManager = [CBRPrefsManager sharedInstance];
  if (prefsManager.lsEnabled && [cell isMemberOfClass:sbbc]) {
    int color;

    if (prefsManager.lsUseConstantColor) {
      color = prefsManager.lsBackgroundColor;
    } else {
      UIImage *image = [item iconImage];
      if (!image) {
        [cell revertIfNeeded];
        return;
      }

      // Don't cache bulletins from Calendar for Lockscreen.
      NSString *bulletinID = item.activeBulletin.bulletinID;
      if ([bulletinID hasPrefix:@"LockScreenCalendar"]) {
        color = [[CBRColorCache sharedInstance] colorForImage:image];
      } else {
        color = [[CBRColorCache sharedInstance] colorForIdentifier:item.activeBulletin.sectionID
                                                             image:image];
      }
    }

    [cell colorize:color];
  }
}

// Hiding separators thanks to PriorityHub.
- (void)layoutSubviews {
  %orig;

  BOOL showSeparators = [CBRPrefsManager sharedInstance].showSeparators;

  UITableView *tableView = MSHookIvar<UITableView *>(self, "_tableView");
  UITableViewCellSeparatorStyle style = 
      showSeparators ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
  tableView.separatorStyle = style;

  UIView *topSeparator = MSHookIvar<UIView *>(self, "_topPocketView");
  UIView *bottomSeparator = MSHookIvar<UIView *>(self, "_bottomPocketView");
  topSeparator.hidden = !showSeparators;
  bottomSeparator.hidden = !showSeparators;
}

%end

%hook SBLockScreenBulletinCell

- (void)prepareForReuse {
  %orig;

  if (![CBRPrefsManager sharedInstance].lsEnabled) {
    [self revertIfNeeded];
  }
}

- (UIColor *)_vibrantTextColor {
  NSNumber *colorObj = [self cbr_color];
  if (colorObj && ls_isWhitish([colorObj intValue])) {
    return [UIColor darkGrayColor];
  }
  return %orig;
}

// This method adds the compositingFilter and updates the text color via _vibrantTextColor.
- (void)_updateUnlockText:(NSString *)text {
  %orig;

  NSNumber *colorObj = [self cbr_color];
  if (colorObj && ls_isWhitish([colorObj intValue])) {
    MSHookIvar<UILabel *>(self, "_unlockTextLabel").layer.compositingFilter = nil;
  }
}

// TODO(DavidGoldman): Possibly move this hook into the superclass (SBLockScreenNotificationCell).
- (void)setContentAlpha:(CGFloat)alpha {
  if ([CBRPrefsManager sharedInstance].disableDimming) {
    alpha = 1;
  }

  %orig;
}

%new
- (void)revertIfNeeded {
  if (![self cbr_color]) {
    return;
  }

  // // Hide/revert all the things!
  [self cbr_setColor:nil];

  // Hide gradient.
  CBRGradientView *gradientView = (CBRGradientView *)[self.realContentView viewWithTag:VIEW_TAG];
  gradientView.hidden = YES;

  // Revert text colors.
  NSString *compositingFilter = @"colorDodgeBlendMode";
  self.eventDateLabel.layer.compositingFilter = compositingFilter;
  self.relevanceDateLabel.layer.compositingFilter = compositingFilter;
  MSHookIvar<UILabel *>(self, "_unlockTextLabel").layer.compositingFilter = compositingFilter;

  Class BulletinCell = %c(SBLockScreenBulletinCell);
  self.primaryTextColor = [BulletinCell defaultColorForPrimaryText];
  self.subtitleTextColor = [BulletinCell defaultColorForSubtitleText];
  self.secondaryTextColor = [BulletinCell defaultColorForSecondaryText];

  UIColor *vibrantColor = [self _vibrantTextColor];
  self.relevanceDateColor = vibrantColor;
  self.eventDateColor = vibrantColor;
}

%new
- (void)refreshAlphaAndVibrancy {
  int color = [[self cbr_color] intValue];

  CBRGradientView *gradientView = (CBRGradientView *)[self.realContentView viewWithTag:VIEW_TAG];
  gradientView.alpha = [CBRPrefsManager sharedInstance].lsAlpha;

  BOOL wantsBlack = ls_isWhitish(color);
  NSString *compositingFilter = (wantsBlack) ? nil : @"colorDodgeBlendMode";

  self.eventDateLabel.layer.compositingFilter = compositingFilter;
  self.relevanceDateLabel.layer.compositingFilter = compositingFilter;
  MSHookIvar<UILabel *>(self, "_unlockTextLabel").layer.compositingFilter = compositingFilter;

  // TODO(DavidGoldman): See if this "smart" refresh/reversion is worth it. I highly doubt it.
  [self colorizeText:color];
}

%new
- (void)colorizeBackground:(int)color {
  CBRGradientView *gradientView = (CBRGradientView *)[self.realContentView viewWithTag:VIEW_TAG];
  UIColor *color1 = UIColorFromRGB(color);

  if (!gradientView) {
    gradientView = [[CBRGradientView alloc] initWithFrame:self.frame];
    gradientView.tag = VIEW_TAG;
    [self.realContentView insertSubview:gradientView atIndex:0];
    [gradientView release];
  }
  gradientView.hidden = NO;
  gradientView.alpha = [CBRPrefsManager sharedInstance].lsAlpha;

  if ([CBRPrefsManager sharedInstance].useLSGradient) {
    UIColor *color2 = (ls_isWhitish(color)) ? [color1 cbr_darken:0.2] : [color1 cbr_lighten:0.2];
    NSArray *colors = @[ (id)color1.CGColor, (id)color2.CGColor ];
    [gradientView setColors:colors];
  } else {
    [gradientView setSolidColor:color1];
  }
}

%new
- (void)colorizeText:(int)color {
  BOOL wantsBlack = ls_isWhitish(color);
  NSString *compositingFilter = (wantsBlack) ? nil : @"colorDodgeBlendMode";

  self.eventDateLabel.layer.compositingFilter = compositingFilter;
  self.relevanceDateLabel.layer.compositingFilter = compositingFilter;
  UILabel *unlockTextLabel = MSHookIvar<UILabel *>(self, "_unlockTextLabel");
  unlockTextLabel.layer.compositingFilter = compositingFilter;

  if (wantsBlack) {
    UIColor *textColor = [UIColor darkGrayColor];
    self.primaryTextColor = textColor;
    self.subtitleTextColor = textColor;
    self.secondaryTextColor = textColor;
    self.relevanceDateColor = textColor;
    self.eventDateColor = textColor;
    unlockTextLabel.textColor = textColor;
  } else {
    Class BulletinCell = %c(SBLockScreenBulletinCell);
    self.primaryTextColor = [BulletinCell defaultColorForPrimaryText];
    self.subtitleTextColor = [BulletinCell defaultColorForSubtitleText];
    self.secondaryTextColor = [BulletinCell defaultColorForSecondaryText];

    UIColor *vibrantColor = [self _vibrantTextColor];
    self.relevanceDateColor = vibrantColor;
    self.eventDateColor = vibrantColor;
    unlockTextLabel.textColor = vibrantColor;
  }
}

- (void)layoutSubviews {
  %orig;

  CBRGradientView *gradientView = (CBRGradientView *)[self.realContentView viewWithTag:VIEW_TAG];
  gradientView.frame = self.realContentView.bounds;
}

%new
- (void)colorize:(int)color {
  NSNumber *colorObj = @(color);
  if ([colorObj isEqual:[self cbr_color]]) {
    CBRLOG(@"%@: Ignoring repeated colorize %d", self, color);
    [self refreshAlphaAndVibrancy];
    return;
  } else {
    CBRLOG(@"%@: Colorize to %d from %@", self, color, [self cbr_color]);
  }

  [self cbr_setColor:colorObj];
  [self colorizeBackground:color];
  [self colorizeText:color];
}

%new
- (NSNumber *)cbr_color {
  return objc_getAssociatedObject(self, @selector(cbr_color));
}

%new
- (void)cbr_setColor:(NSNumber *)color {
  objc_setAssociatedObject(self, @selector(cbr_color), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_beginSwiping {
  %orig;

  NSNumber *colorObj = [self cbr_color];
  if (colorObj) {
    int color = [colorObj intValue];

    UITableViewCellDeleteConfirmationView *view = [self _swipeToDeleteConfirmationView];
    NSArray *buttons = MSHookIvar<NSArray *>(view, "_actionButtons");
    for (id button in buttons) {
      if ([button isMemberOfClass:%c(SBTableViewCellDismissActionButton)]) {
        SBTableViewCellDismissActionButton *actionButton = button;
        [actionButton colorize:color];
      }
    }
  }
}

%end

%hook SBTableViewCellDismissActionButton

%new
- (void)colorize:(int)color {
  if ([CBRPrefsManager sharedInstance].colorDismissButton) {
    CGFloat alpha = [CBRPrefsManager sharedInstance].lsAlpha * 3 / 4;
    self.backgroundColor = UIColorFromRGBWithAlpha(color, alpha);
  }

  if (![CBRPrefsManager sharedInstance].showSeparators) {
    self.drawsBottomSeparator = NO;
    self.drawsTopSeparator = NO;
  }
}

%end

%end

%group Banners
%hook SBBannerContextView

%new
- (void)colorize:(int)color {
  [self cbr_setColor:@(color)];
  [self colorize:color withBackground:-1 force:YES];

  CBRPrefsManager *manager = [CBRPrefsManager sharedInstance];
  if (manager.bannerAlpha == 1 || !manager.wantsDeepBannerAnalyzing) {
    return;
  }

  // Modify the settings to use color statistics/computing color.
  _UIBackdropView *backdropView = MSHookIvar<_UIBackdropView *>(self, "_backdropView");
  _UIBackdropViewSettings *s = [backdropView inputSettings];
  s.statisticsInterval = 0.25;
  s.requiresColorStatistics = YES;

  [backdropView setIsForBannerContextView:YES];
  [backdropView setComputesColorSettings:YES];
}

%new
- (void)colorizeBackgroundForColor:(int)color alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack {
  // Remove background tint.
  _UIBackdropView *backdropView = MSHookIvar<_UIBackdropView *>(self, "_backdropView");
  [backdropView setIsForBannerContextView:YES];
  backdropView.colorSaturateFilter = nil;
  backdropView.tintFilter = nil;
  [backdropView _updateFilters];

  // Hide background blur if needed.
  if ([CBRPrefsManager sharedInstance].removeBannersBlur) {
    backdropView.hidden = YES;
  }

  // Create/update gradient.
  CBRGradientView *gradientView = (CBRGradientView *)[self viewWithTag:VIEW_TAG];
  UIColor *color1 = UIColorFromRGB(color);

  if (!gradientView) {
    gradientView = [[CBRGradientView alloc] initWithFrame:self.bounds];
    gradientView.tag = VIEW_TAG;
    [self insertSubview:gradientView atIndex:1];
    [gradientView release];
  }
  gradientView.hidden = NO;
  gradientView.alpha = alpha;

  if ([CBRPrefsManager sharedInstance].useBannerGradient) {
    UIColor *color2 = (wantsBlack) ? [color1 cbr_darken:0.1] : [color1 cbr_lighten:0.1];
    NSArray *colors = @[ (id)color1.CGColor, (id)color2.CGColor ];
    [gradientView setColors:colors];
  } else {
    [gradientView setSolidColor:color1];
  }
}

%new
- (void)colorizeTextForColor:(int)color alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack {
  SBDefaultBannerView *view = MSHookIvar<SBDefaultBannerView *>(self, "_contentView");
  SBDefaultBannerTextView *textView = MSHookIvar<SBDefaultBannerTextView *>(view, "_textView");

  UIColor *dateColor;
  UIColor *textColor;
  NSString *compositingFilter;

  if (wantsBlack) {
    dateColor = textColor = [UIColor darkGrayColor];
    compositingFilter = nil;
  } else {
    dateColor = UIColorFromRGB(color);
    textColor = [UIColor whiteColor];
    compositingFilter = @"colorDodgeBlendMode";
  }

  // Auki 2 Support.
  if (textView.class == %c(KJUARRTextViewScrollContainerView)) {
    KJUARRTextViewScrollContainerView *aukiView = (KJUARRTextViewScrollContainerView *)textView;
    [aukiView setRelevanceDateLabelLayerCompositingFilter:compositingFilter];
    [aukiView setRelevanceDateColor:dateColor];
  } else {
    textView.relevanceDateLabel.layer.compositingFilter = compositingFilter;
    [view _setRelevanceDateColor:dateColor];
  }
  [textView setPrimaryTextColor:textColor];
  [textView setSecondaryTextColor:textColor];

  [textView setNeedsDisplay];
}

%new
- (void)colorizeGrabberForColor:(int)color alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack {
  // Colorize/hide the grabber.
  UIView *grabberView = MSHookIvar<UIView *>(self, "_grabberView");
  if ([CBRPrefsManager sharedInstance].hideGrabber) {
    grabberView.hidden = YES;
  } else {
    BOOL normallyWantsBlack = isWhitish(color);
    grabberView.layer.compositingFilter = nil;
    grabberView.opaque = NO;

    UIColor *grabberColor;
    if (normallyWantsBlack && !wantsBlack) { // Go with fully white because it's blurred darker.
      grabberColor = [UIColor whiteColor];
    } else {
      grabberColor = (wantsBlack) ? [UIColor darkGrayColor] : [UIColorFromRGBWithAlpha(color, 0.6) cbr_darken:0.3];
    }
    [self _setGrabberColor:grabberColor];
  }
}

%new
- (void)colorizePullDown:(UIView *)pullDownView forColor:(int)color
                   alpha:(CGFloat)alpha  preferringBlack:(BOOL)wantsBlack {
  // Colorize the buttons.
  if ([pullDownView isKindOfClass:%c(SBBannerButtonView)]) {
    SBBannerButtonView *buttonView = (SBBannerButtonView *)pullDownView;
    [buttonView colorizeWithColor:color alpha:alpha preferringBlack:wantsBlack];
  }

  // Colorize Text View.
  if (IS_IOS9_OR_NEWER) {
    id viewController = [pullDownView _viewDelegate];
    if ([viewController isKindOfClass:%c(NCNotificationActionTextInputViewController)]) {
      [(NCNotificationActionTextInputViewController *)viewController cbr_colorize:color
                                                                            alpha:alpha
                                                                  preferringBlack:wantsBlack];
    }
  }
}

%new
- (void)colorize:(int)color withBackground:(int)bg force:(BOOL)force {
  CGFloat alpha = [CBRPrefsManager sharedInstance].bannerAlpha;
  BOOL isWhite = (bg != -1) ? compositeIsWhitish(color, bg, alpha) : isWhitish(color);

  if (!force) {
    NSNumber *curColor = [self cbr_color];
    NSNumber *curPrefersBlack = [self cbr_prefersBlack];
    if (curColor && curPrefersBlack
        && [curColor intValue] == color && [curPrefersBlack boolValue] == isWhite) {
      return;
    }
  }
  [[CBRReadabilityManager sharedInstance] setShouldUseDarkTextAndSynchronize:isWhite];

  [self cbr_setPrefersBlack:@(isWhite)];

  [self colorizeBackgroundForColor:color alpha:alpha preferringBlack:isWhite];
  [self colorizeTextForColor:color alpha:alpha preferringBlack:isWhite];
  [self colorizeGrabberForColor:color alpha:alpha preferringBlack:isWhite];
  [self colorizePullDown:self.pullDownView forColor:color alpha:alpha preferringBlack:isWhite];
}

%new
- (void)recolorizePullDown:(UIView *)pullDownView {
  NSNumber *curColor = [self cbr_color];
  NSNumber *curPrefersBlack = [self cbr_prefersBlack];
  if (curColor && curPrefersBlack) {
    [self colorizePullDown:pullDownView
                  forColor:[curColor intValue]
                     alpha:[CBRPrefsManager sharedInstance].bannerAlpha
           preferringBlack:[curPrefersBlack boolValue]];
  }
}

%new
- (NSNumber *)cbr_color {
  return objc_getAssociatedObject(self, @selector(cbr_color));
}

%new
- (void)cbr_setColor:(NSNumber *)color {
  objc_setAssociatedObject(self, @selector(cbr_color), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBannerContext:(SBUIBannerContext *)context withReplaceReason:(int)replaceReason {
  %orig;

  SBDefaultBannerView *view = MSHookIvar<SBDefaultBannerView *>(self, "_contentView");
  if ([view isMemberOfClass:%c(SBDefaultBannerView)]) {
    CBRPrefsManager *prefsManager = [CBRPrefsManager sharedInstance];

    if (!prefsManager.bannersEnabled) {
      CBRGradientView *gradientView = (CBRGradientView *)[self viewWithTag:VIEW_TAG];
      gradientView.hidden = YES; // Not sure if needed (probably isn't).
    } else {
      int color;
      if (prefsManager.bannersUseConstantColor) {
        color = prefsManager.bannerBackgroundColor;
      } else {
        id item = [context item];
        NSString *identifier = nil;

        if ([item isKindOfClass:%c(SBBulletinBannerItem)]) {
          identifier = [item seedBulletin].sectionID;
        } else if ([item isKindOfClass:%c(SBLockScreenNotificationBannerItem)]) {
          SBAwayBulletinListItem *listItem = [item listItem];
          identifier = listItem.activeBulletin.sectionID;
        } else {
          // Revert/don't color.
          CBRLOG(@"Unknown bulletin item %@", item);

          CBRGradientView *gradientView = (CBRGradientView *)[self viewWithTag:VIEW_TAG];
          gradientView.hidden = YES; // Not sure if needed (probably isn't).
          return;
        }

        UIImage *image = [item iconImage];
        color = [[CBRColorCache sharedInstance] colorForIdentifier:identifier image:image];
      }

      if (prefsManager.roundCorners) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
      }

      [self colorize:color];
    }
  }
}

%new
- (NSNumber *)cbr_prefersBlack {
  return objc_getAssociatedObject(self, @selector(cbr_prefersBlack));
}

%new
- (void)cbr_setPrefersBlack:(NSNumber *)prefersBlack {
  objc_setAssociatedObject(self,
                           @selector(cbr_prefersBlack),
                           prefersBlack, 
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)layoutSubviews {
  %orig;

  CBRGradientView *gradientView = (CBRGradientView *)[self viewWithTag:VIEW_TAG];
  gradientView.frame = self.bounds;
}

%end

%hook SBDefaultBannerTextView

%new
- (void)setPrimaryTextColor:(UIColor *)color {
  NSAttributedString *s = MSHookIvar<NSAttributedString *>(self, "_primaryTextAttributedString");
  MSHookIvar<NSAttributedString *>(self, "_primaryTextAttributedString") = copyAttributedStringWithColor(s, color);
  [s release];
  
  s = MSHookIvar<NSAttributedString *>(self, "_primaryTextAttributedStringComponent");
  MSHookIvar<NSAttributedString *>(self, "_primaryTextAttributedStringComponent") = copyAttributedStringWithColor(s, color);
  [s release];

  // Subtitle appears to have been added in 8.3. Still need to see where this is actually used.
  // It appears to be used in Group Chats, but I'm not sure.
  Ivar ivar = class_getInstanceVariable(object_getClass(self), "_subtitleTextAttributedString");
  if (ivar) {
    s = MSHookIvar<NSAttributedString *>(self, "_subtitleTextAttributedString");
    MSHookIvar<NSAttributedString *>(self, "_subtitleTextAttributedString") = copyAttributedStringWithColor(s, color);
    [s release];
  }

  // TinyBar support (deferred colorizing).
  if ([self respondsToSelector:@selector(tb_titleLabel)]) {
    [self tb_titleLabel].textColor = color;
  }
}

%new
- (void)setSecondaryTextColor:(UIColor *)color {
  NSAttributedString *s = MSHookIvar<NSAttributedString *>(self, "_secondaryTextAttributedString");
  MSHookIvar<NSAttributedString *>(self, "_secondaryTextAttributedString") = copyAttributedStringWithColor(s, color);
  [s release];
  
  s = MSHookIvar<NSAttributedString *>(self, "_alternateSecondaryTextAttributedString");
  MSHookIvar<NSAttributedString *>(self, "_alternateSecondaryTextAttributedString") = copyAttributedStringWithColor(s, color);
  [s release];

  // TinyBar support (deferred colorizing).
  if ([self respondsToSelector:@selector(tb_secondaryLabel)]) {
    [self tb_secondaryLabel].textColor = color;
  }

  // TinyBar support.
  objc_setAssociatedObject(self, @selector(secondaryTextColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// TinyBar support.
%new
- (UIColor *)secondaryTextColor {
  return objc_getAssociatedObject(self, @selector(secondaryTextColor));
}

// TinyBar support.
- (id)_newAttributedStringForSecondaryText:(id)secondaryText italicized:(BOOL)italicized {
  NSAttributedString *str = %orig;
  UIColor *secondaryTextColor = [self secondaryTextColor];

  if (secondaryTextColor) {
    NSAttributedString *newStr = copyAttributedStringWithColor(str, secondaryTextColor);
    [str release];
    return newStr;
  }
  return str;
}

// TinyBar support (iOS 9.3+).
- (id)_attributedStringForSecondaryText:(id)secondaryText italicized:(BOOL)italicized {
  NSAttributedString *str = %orig;
  UIColor *secondaryTextColor = [self secondaryTextColor];

  if (secondaryTextColor) {
    NSAttributedString *newStr = copyAttributedStringWithColor(str, secondaryTextColor);
    return [newStr autorelease];
  }
  return str;
}

%end

%hook SBBannerButtonView

%new
- (void)colorizeWithColor:(int)color alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack {
  for (UIButton *button in self.buttons) {
    if ([button isKindOfClass:%c(SBNotificationVibrantButton)]) {
      SBNotificationVibrantButton *vibrantButton = (SBNotificationVibrantButton *)button;
      [vibrantButton colorizeWithColor:color alpha:alpha preferringBlack:wantsBlack];
    }
  }
}

%end

%hook SBNotificationVibrantButton

%new
- (void)configureButton:(UIButton *)button
          withTintColor:(UIColor *)tintColor
      selectedTintColor:(UIColor *)selectedTintColor
              textColor:(UIColor *)textColor
      selectedTextColor:(UIColor *)selectedTextColor {
  UIImage *buttonImage = [self _buttonImageForColor:tintColor selected:NO];
  UIImage *selectedImage = [self _buttonImageForColor:selectedTintColor selected:YES];
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
  [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
  [button setTitleColor:textColor forState:UIControlStateNormal];
  [button setTitleColor:selectedTextColor forState:UIControlStateHighlighted];
  [button setTitleColor:selectedTextColor forState:UIControlStateSelected];
}

%new
- (void)colorizeWithColor:(int)colorInt alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack {
  alpha = (alpha / 2) + 0.2;
  UIColor *color = UIColorFromRGBWithAlpha(colorInt, alpha);
  UIColor *darkerColor = [color cbr_darken:0.2];
  UIColor *textColor = (wantsBlack) ? [UIColor darkGrayColor] : [UIColor whiteColor];

  UIButton *overlayButton = MSHookIvar<UIButton *>(self, "_overlayButton");
  [self configureButton:overlayButton
          withTintColor:color
      selectedTintColor:darkerColor
              textColor:textColor
      selectedTextColor:textColor];

  UIButton *vibrantButton = MSHookIvar<UIButton *>(self, "_vibrantButton");
  vibrantButton.hidden = YES;
}

%end

// TODO(DavidGoldman): Make this less hacky. Would probably be better if we just set the tintFilter
// to be white (hopefully that will work)/use a light filter instead of the dark one.
%hook _UIBackdropView

%new
- (void)setIsForBannerContextView:(BOOL)flag {
  NSNumber *value = @(flag);
  objc_setAssociatedObject(self, @selector(isForBannerContextView), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (BOOL)isForBannerContextView {
  NSNumber *value = objc_getAssociatedObject(self, @selector(isForBannerContextView));
  return [value boolValue];
}

- (void)backdropLayerStatisticsDidChange:(CABackdropLayer *)layer {
  %orig;

  if ([self isForBannerContextView]) {
    NSDictionary *dict = [layer statisticsValues];
    if (!dict) {
      return;
    }

    int r = (int)([dict[@"redAverage"] floatValue] * 255);
    int g = (int)([dict[@"greenAverage"] floatValue] * 255);
    int b = (int)([dict[@"blueAverage"] floatValue] * 255);

    UIView *superview = self.superview;
    if ([superview isMemberOfClass:%c(SBBannerContextView)]) {
      SBBannerContextView *bannerView = (SBBannerContextView *)superview;

      int color = [[bannerView cbr_color] intValue];
      int bgColor = colorToRGBInt(r, g, b);
      [bannerView colorize:color withBackground:bgColor force:NO];

      // Only do the analysis once if not "live".
      if (![CBRPrefsManager sharedInstance].wantsLiveAnalysis) {
        _UIBackdropView *backdropView = MSHookIvar<_UIBackdropView *>(bannerView, "_backdropView");
        [backdropView setComputesColorSettings:NO];
      }
    }
  }
}

- (void)setTintFilterForSettings:(id)settings {
  if ([self isForBannerContextView]) {
    return;
  }

  %orig;
}

- (void)setSaturationDeltaFactor:(CGFloat)factor {
  if ([self isForBannerContextView]) {
    return;
  }

  %orig;
}

%end
%end

%group RemoveUnderlay
%hook SBLockScreenView

- (void)_addLockContentUnderlayWithRequester:(id)requester {
  if ([CBRPrefsManager sharedInstance].removeLSBlur && [requester isEqual:@"NotificationList"]) {
    return;
  }

  %orig;
}

%end
%end

%group iOS9_NotificationCenter_Widgets
%hook SBWidgetSectionInfo

- (void)populateReusableView:(UIView *)view {
  %orig;

  if ([view isKindOfClass:%c(SBNotificationCenterHeaderView)]) {
    SBNotificationCenterHeaderView *headerView = (SBNotificationCenterHeaderView *)view;
    CBRPrefsManager *prefsManager = [CBRPrefsManager sharedInstance];

    if (!prefsManager.ncEnabled) {
      [headerView cbr_setColor:nil];
      return;
    }

    int color;

    if (prefsManager.ncUseConstantColor) {
      color = prefsManager.ncBackgroundColor;
    } else {
      SBWidgetRowInfo *widgetRowInfo = self.widgetRowInfo;
      NSString *identifier = [widgetRowInfo identifier];
      UIImage *image = [widgetRowInfo icon];

      if (!identifier) {
        CBRLOG(@"WARNING: No identifier for %@", self);
      }

      if (!image) {
        [headerView cbr_setColor:nil];
        return;
      }

      color = [[CBRColorCache sharedInstance] colorForIdentifier:identifier image:image];
    }

    [headerView cbr_setColor:@(color)];
    [headerView cbr_colorizeIfNeeded];
  }
}

%end
%end

%group NotificationCenter_BB
%hook SBNotificationCenterSectionInfo

- (void)populateReusableView:(UIView *)view {
  %orig;

  if ([view isKindOfClass:%c(SBNotificationCenterHeaderView)]) {
    SBNotificationCenterHeaderView *headerView = (SBNotificationCenterHeaderView *)view;
    CBRPrefsManager *prefsManager = [CBRPrefsManager sharedInstance];

    if (!prefsManager.ncEnabled) {
      [headerView cbr_setColor:nil];
      return;
    }

    int color;

    if (prefsManager.ncUseConstantColor) {
      color = prefsManager.ncBackgroundColor;
    } else {
      NSString *identifier = nil;
      if ([self respondsToSelector:@selector(listSectionIdentifier)]) {
        identifier = [self listSectionIdentifier];
      }
      UIImage *image = nil;
      if ([self respondsToSelector:@selector(representedListSection)]) {
        image = [self representedListSection].iconImage;
      }

      if (!identifier) {
        CBRLOG(@"WARNING: No identifier for %@", self);
      }

      if (!image) {
        [headerView cbr_setColor:nil];
        return;
      }

      color = [[CBRColorCache sharedInstance] colorForIdentifier:identifier image:image];
    }

    [headerView cbr_setColor:@(color)];
    // Need to manually colorize on iOS 9.
    if (IS_IOS9_OR_NEWER) {
      [headerView cbr_colorizeIfNeeded];
    }
  }
}

%end
%end

%group NotificationCenter

%hook SBNotificationCenterHeaderView

- (void)setGraphicsQuality:(NSInteger)quality {
  %orig;

  [self cbr_colorizeIfNeeded];
}

- (void)layoutSubviews {
  %orig;

  CBRGradientView *gradientView = (CBRGradientView *)[self.contentView viewWithTag:VIEW_TAG];
  gradientView.frame = self.contentView.bounds;
}

%new
- (void)cbr_colorizeIfNeeded {
  NSNumber *color = [self cbr_color];
  NSNumber *activeColor = [self cbr_activeColor];

  if (color == activeColor || [color isEqual:activeColor]) {
    return;
  }

  if (color) {
    [self cbr_colorize:[color intValue]];
  } else {
    [self cbr_revert];
  }
}

%new
- (void)cbr_colorize:(int)color {
  [self cbr_setActiveColor:@(color)];

  // Create/update gradient.
  CBRGradientView *gradientView = (CBRGradientView *)[self.contentView viewWithTag:VIEW_TAG];
  UIColor *color1 = UIColorFromRGB(color);

  if (!gradientView) {
    gradientView = [[CBRGradientView alloc] initWithFrame:self.contentView.bounds];
    gradientView.tag = VIEW_TAG;
    [self.contentView insertSubview:gradientView atIndex:0];
    [gradientView autorelease];
  }
  gradientView.hidden = NO;
  gradientView.alpha = [CBRPrefsManager sharedInstance].ncAlpha;

  if ([CBRPrefsManager sharedInstance].useNCGradient) {
    UIColor *color2 = (isWhitish(color)) ? [color1 cbr_darken:0.1] : [color1 cbr_lighten:0.1];
    NSArray *colors = @[ (id)color1.CGColor, (id)color2.CGColor ];
    [gradientView setColors:colors];
  } else {
    [gradientView setSolidColor:color1];
  }

  // Remove the darkening view.
  UIView *view = MSHookIvar<UIView *>(self, "_plusDView");
  view.hidden = YES;

  UILabel *label = self.titleLabel;
  label.textColor = (isWhitish(color)) ? [UIColor darkGrayColor] : [UIColor whiteColor];
}

%new
- (void)cbr_revert {
  [self cbr_setActiveColor:nil];
  CBRGradientView *gradientView = (CBRGradientView *)[self.contentView viewWithTag:VIEW_TAG];
  gradientView.hidden = YES;

  UIView *view = MSHookIvar<UIView *>(self, "_plusDView");
  view.hidden = NO;

  UILabel *label = self.titleLabel;
  label.textColor = UIColorFromRGBWithAlpha(0xFFFFFF, 0.7);
}

%new
- (NSNumber *)cbr_activeColor {
  return objc_getAssociatedObject(self, @selector(cbr_activeColor));
}

%new
- (void)cbr_setActiveColor:(NSNumber *)color {
  objc_setAssociatedObject(self, @selector(cbr_activeColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (NSNumber *)cbr_color {
  return objc_getAssociatedObject(self, @selector(cbr_color));
}

%new
- (void)cbr_setColor:(NSNumber *)color {
  objc_setAssociatedObject(self, @selector(cbr_color), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end
%end

static UIColor * getNormalColor(BOOL darker) {
  return (darker) ? [UIColor darkGrayColor] : [UIColor whiteColor];
}

static UIColor * getMildColor(BOOL darker) {
  return (darker) ? [UIColor grayColor] :
      [UIColor colorWithRed:0.780392 green:0.780392 blue:0.8 alpha:1];
}

%group Messages_QuickReply
%hook CKMessageEntryView

%new
- (void)cbr_setModal:(BOOL)modal {
  objc_setAssociatedObject(self, @selector(cbr_isModal), @(modal), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new
- (BOOL)cbr_isModal {
  NSNumber *value = objc_getAssociatedObject(self, @selector(cbr_isModal));
  return [value boolValue];
}

// According to InspectiveC logging, they like to set colors in here.
- (void)updateEntryView {
  %orig;

  if ([self cbr_isModal] || ![CBRPrefsManager sharedInstance].bannersEnabled) {
    return;
  }

  BOOL useDarkText = [CBRReadabilityManager sharedInstance].shouldUseDarkText;
  UIColor *tintColor = getNormalColor(useDarkText);

  self.audioButton.tintColor = tintColor;
  UIButton *button = self.sendButton;
  [button setTitleColor:tintColor forState:UIControlStateNormal];
  [button setTitleColor:getMildColor(useDarkText) forState:UIControlStateDisabled];
}

%end

%hook CKInlineReplyViewController

- (void)updateSendButton {
  %orig;

  if (self.modal || ![CBRPrefsManager sharedInstance].bannersEnabled) {
    return;
  }

  BOOL useDarkText = [CBRReadabilityManager sharedInstance].shouldUseDarkText;
  UIButton *button = self.entryView.sendButton;
  [button setTitleColor:getNormalColor(useDarkText) forState:UIControlStateNormal];
  [button setTitleColor:getMildColor(useDarkText) forState:UIControlStateDisabled];
}

- (void)setupView {
  %orig;

  BOOL modal = self.modal;
  [self.entryView cbr_setModal:modal];
  if (modal || ![CBRPrefsManager sharedInstance].bannersEnabled) {
    return;
  }

  [CBRReadabilityManager sharedInstance].delegate = (id<CBRReadabilityManagerDelegate>)self;

  // To hide the rounded-rect altogether.
  if ([CBRPrefsManager sharedInstance].hideQRRect) {
    CKMessageEntryView *entryView = self.entryView;
    _UITextFieldRoundedRectBackgroundViewNeue *view = MSHookIvar<id>(entryView, "_coverView");
    view.hidden = YES;
  }

  [self cbr_updateReadability:[CBRReadabilityManager sharedInstance].shouldUseDarkText];
}

%new
- (void)cbr_updateReadability:(BOOL)useDarkText {
  if (self.modal) {
    return;
  }
  UIColor *tintColor = getNormalColor(useDarkText);
  UIColor *mildColor = getMildColor(useDarkText);

  UIButton *button = self.entryView.sendButton;
  [button setTitleColor:tintColor forState:UIControlStateNormal];
  [button setTitleColor:mildColor forState:UIControlStateDisabled];

  CKMessageEntryContentView *contentView = self.entryView.contentView;
  CKMessageEntryRichTextView *textView = contentView.textView;
  textView.textColor = tintColor;

  textView.tintColor = tintColor;
  // Needed in order to get the UITextView to properly change the cursor color.
  // See http://stackoverflow.com/questions/23725552/uitextview-cursor-color-not-changing-ios-7
  if ([textView isFirstResponder]) {
    [textView resignFirstResponder];
    [textView becomeFirstResponder];
  }
  textView.placeholderLabel.textColor = mildColor;

  UIButton *audioButton = self.entryView.audioButton;
  audioButton.tintColor = tintColor;
}

%new
- (void)managersReadabilityStateDidChange:(CBRReadabilityManager *)manager {
  [self cbr_updateReadability:manager.shouldUseDarkText];
}

- (void)dealloc {
  [CBRReadabilityManager sharedInstance].delegate = nil;
  %orig;
}

%end
%end

%group iOS9_QuickReply
%hook SBBannerContextView
- (void)replacePullDownViewWithView:(UIView *)view animated:(BOOL)animated {
  [self recolorizePullDown:view];

  %orig;
}
%end
%hook NCNotificationActionTextInputViewController
%new
- (void)cbr_colorize:(int)color alpha:(CGFloat)alpha preferringBlack:(BOOL)wantsBlack {
  // TODO: Make sure this means what I think it means.
  if (self.modal) {
    return;
  }

  // To hide the rounded-rect altogether.
  if ([CBRPrefsManager sharedInstance].hideQRRect) {
    self.coverView.hidden = YES;
  }

  UIColor *tintColor = getNormalColor(wantsBlack);

  UIButton *sendButton = self.sendButton;
  [sendButton setTitleColor:tintColor forState:UIControlStateNormal];
  [sendButton setTitleColor:getMildColor(wantsBlack) forState:UIControlStateDisabled];

  UITextView *textView = self.textEntryView;
  textView.textColor = tintColor;
  textView.tintColor = tintColor;
  // Needed in order to get the UITextView to properly change the cursor color.
  // See http://stackoverflow.com/questions/23725552/uitextview-cursor-color-not-changing-ios-7
  if ([textView isFirstResponder]) {
    [textView resignFirstResponder];
    [textView becomeFirstResponder];
  }
}
%end
%end

%ctor {
  NSString *bundle = [NSBundle mainBundle].bundleIdentifier;

  if ([bundle isEqualToString:@"com.apple.springboard"]) {
    %init(TestNotifications);
    %init(LockScreen);
    %init(Banners);
    %init(NotificationCenter);
    %init(RemoveUnderlay);

    // iOS 9 Notification Center stuff.
    BOOL iOS9 = IS_IOS9_OR_NEWER;
    Class SectionInfo_Class = %c(SBNotificationCenterSectionInfo);
    if (iOS9) {
      %init(iOS9_NotificationCenter_Widgets);
      SectionInfo_Class = %c(SBBBSectionInfo);
    }
    %init(NotificationCenter_BB, SBNotificationCenterSectionInfo=SectionInfo_Class);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    &showTestLockScreenNotification,
                                    CFSTR(TEST_LS),
                                    NULL,
                                    0);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    &showTestBanner,
                                    CFSTR(TEST_BANNER),
                                    NULL,
                                    0);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    &respring,
                                    CFSTR(RESPRING),
                                    NULL,
                                    0);

    // iOS 9 has some Quick Reply classes loaded in SpringBoard.
    if (iOS9) {
      %init(iOS9_QuickReply);
    }

    [CBRReadabilityManager sharedInstance];
  }
  else if ([bundle isEqualToString:@"com.apple.mobilesms.notification"]) {
    %init(Messages_QuickReply);
    [CBRReadabilityManager sharedInstance];
  }
}
