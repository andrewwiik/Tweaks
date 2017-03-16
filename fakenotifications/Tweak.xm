#import "headers.h"
extern dispatch_queue_t __BBServerQueue;

%hook UIView
%new
- (void)showFakeNotifications {

	 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC),__BBServerQueue, ^{

		// [notificationListController _showTestBulletin];

		BBBulletinRequest *bulletin = [[NSClassFromString(@"BBBulletinRequest") alloc] init];
		bulletin.title = @"Priority Hub";
		bulletin.sectionID = @"com.apple.MobileSMS";
		bulletin.message = @"This is a test notification!";
		bulletin.bulletinID = @"reg-6";
		bulletin.threadID = @"req-6";
		bulletin.publisherBulletinID = @"stuff6";
		bulletin.clearable = YES;
		bulletin.showsMessagePreview = YES;
		bulletin.defaultAction = [%c(BBAction) action];
		NSDate *now = [NSDate date];
		bulletin.date = now;
		bulletin.publicationDate = now;
		bulletin.lastInterruptDate = now;

		if ([NSClassFromString(@"SBTestDataProvider") sharedInstance]) {
			SBTestDataProvider *dataProvider = [NSClassFromString(@"SBTestDataProvider") sharedInstance];

			NSLog(@"Posting Notification");
			[bulletin publish];
			[(BBDataProviderProxy *)[dataProvider valueForKey:@"_proxy"] addBulletin:bulletin forDestinations:16];
			[dataProvider publishBulletinsWithCount:6];
		}
	});
}
%end

%hook SBTestDataProvider
%property (nonatomic, retain) NSString *sectionIdentifierReplacement;
- (id)sectionIdentifier {
	// if (self.sectionIdentifierReplacement) {
	// 	return self.sectionIdentifierReplacement;
	// } else return %orig;
	return @"com.apple.MobileSMS";
}
// - (id)defaultSectionInfo {
// 	__block id sectionInfo = nil;
// 	dispatch_sync(__BBServerQueue, ^{
// 		if ([NSClassFromString(@"BBServer") sharedConferoBBServer]) {
// 			sectionInfo = [[NSClassFromString(@"BBServer") sharedConferoBBServer] _sectionInfoForSectionID:@"com.apple.MobileSMS" effective:YES];
// 		} else return %orig;
// 	});
// }
// %new
// - (void)setUpStuff {
// 	dispatch_sync(__BBServerQueue, ^{
// 		[(BBDataProviderProxy *)[self valueForKey:@"_proxy"] updateIdentity:nil];
// 		[(BBDataProviderProxy *)[self valueForKey:@"_proxy"] reloadDefaultSectionInfo];
// 		//[self noteSectionInfoDidChange:[self defaultSectionInfo]];
// 	});
// }
%end
@interface NSPopover : UIWindow
@end
%hook NSPopover
- (id)init {
	id orig = %orig;
	[orig setWindowLevel:-1];
	return orig;
}
%end

@interface PopoverView : UIView
@property (nonatomic, retain) UIView *contentView;
@end
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
@interface ConferoIconView : UIView
@property (nonatomic, retain) UIVisualEffectView *vibrancyView;
@property (nonatomic, retain) UILabel *label;
@end

%hook ConferoIconView
%property (nonatomic, retain) UIVisualEffectView *vibrancyView;
- (void)setLabel:(UILabel *)label {
	%orig;
	// if (!self.vibrancyView) {
	// 	NCVibrantStyling *vibrantStyling = [NSClassFromString(@"NCVibrantStyling") vibrantStylingWithStyle:2];
	// 	self.vibrancyView = [[UIVisualEffectView alloc] initWithEffect:[vibrantStyling visualEffect]];
	// 	self.vibrancyView.frame = self.frame;
	// 	[self addSubview:self.vibrancyView];
	// 	[label removeFromSuperview];
	// 	[self.vibrancyView.contentView addSubview:label];
	// }
	label.substitutedTextColor = [UIColor colorWithWhite:1 alpha:0.9];
	[label setDarkModeEnabled:CFPreferencesGetAppBooleanValue((CFStringRef)@"OGYDarkModeEnabled", CFSTR("com.sadie.ogygie"), NULL)];
}
- (void)layoutSubviews {
	%orig;
	// self.label.textColor = [UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1];
	// if (self.vibrancyView) {
	// 	[self.label removeFromSuperview];
	// 	[self.vibrancyView.contentView addSubview:self.label];
	// 	self.vibrancyView.frame = self.frame;
	// }
}
%end

@interface ConferoExtraCollectionViewCell : UICollectionViewCell
@property (nonatomic, retain) NCMaterialView *effectView;
@end
%hook ConferoExtraCollectionViewCell
%property (nonatomic, retain) NCMaterialView *materialView;
- (void)setEffectView:(NCMaterialView *)effectView {
	%orig;
	// if ([effectView valueForKey:@"_backdropView"]) {
	// 	[(UIView *)[[effectView valueForKey:@"_backdropView"] valueForKey:@"_backdropEffectView"] setAlpha:0];
	// 	if (effectView.substitutedBackdropView) {
	// 		[(UIView *)[effectView.substitutedBackdropView valueForKey:@"_backdropEffectView"] setAlpha:0];
	// 	}
	// }
}
- (void)setSubEffectView:(NCMaterialView *)effectView {
	%orig;
	if (effectView) {
		effectView.backgroundColor = nil;
	}
}
- (void)layoutSubviews {
	%orig;
}
%end
