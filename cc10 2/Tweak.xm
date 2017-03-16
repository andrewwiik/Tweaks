#import "WNBackdropViewSettings.h"
#import "WNVibrantStyling.h"
#import "headers/_UIBackdropView.h"

#include <CoreFoundation/CoreFoundation.h>
#include <CoreGraphics/CoreGraphics.h>


void WNApplyVibrantStyling(WNVibrantStyling *style, id view) {
	if ([view isKindOfClass:[UILabel class]]) {
		UILabel *label = (UILabel *)view;
		[label setAlpha:[style alpha]];
		[label.layer setFilters:@[[style composedFilter]]];
	}
}

@interface UIImage (Private)
/*
 @param format
 0 - 29x29
 1 - 40x40
 2 - 62x62
 3 - 42x42
 4 - 37x48
 5 - 37x48
 6 - 82x82
 7 - 62x62
 8 - 20x20
 9 - 37x48
 10 - 37x48
 11 - 122x122
 12 - 58x58
 */
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
+ (UIImage*)getImageFromBundleNamed:(NSString*)name withExtension:(NSString*)extensio;
@end

%hook UIView
%new
- (void)dimmingTest4 {

	UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(8,0,398,98)];
	notificationView.backgroundColor = [UIColor clearColor];
	notificationView.layer.cornerRadius = 15;
	notificationView.layer.masksToBounds = YES;
	[self addSubview:notificationView];

	WNBackdropViewSettings *settings = [WNBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];
	[notificationView addSubview:backdropView];

	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,398,36)];
	headerView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.35];
	[notificationView addSubview:headerView];

	UIImage *iconImage = [UIImage _applicationIconImageForBundleIdentifier:@"com.apple.MobileSMS" format:0 scale:2.0];
	UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(8,8,20,20)];
	iconView.image = iconImage;
	[headerView addSubview:iconView];

	UILabel *appLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 13)];

	appLabel.translatesAutoresizingMaskIntoConstraints = NO;
	appLabel.text = [NSString stringWithFormat:@"MESSAGES"];
	appLabel.textColor = [UIColor whiteColor];
	appLabel.font = [UIFont fontWithName:@".SFUIText" size:13];
	[appLabel sizeToFit];
	[headerView addSubview:appLabel];

	[headerView addConstraint:[NSLayoutConstraint constraintWithItem:appLabel
                                                      attribute:NSLayoutAttributeCenterY
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:headerView
                                                      attribute:NSLayoutAttributeCenterY
                                                     multiplier:1
                                                       constant:0]];
	[headerView addConstraint:[NSLayoutConstraint constraintWithItem:appLabel
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:headerView
                                                      attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                       constant:36]];
	[appLabel sizeToFit];
	WNVibrantStyling *styling = [WNVibrantSecondaryStyling new];
	WNApplyVibrantStyling(styling,appLabel);
}
%end