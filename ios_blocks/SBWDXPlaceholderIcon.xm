
#import "headers.h"

@interface NSObject (SBWDXPlaceholderIcon)
- (BOOL)isWDXPlaceholderIcon;
- (BOOL)isWDXWidgetIcon;
@end

@implementation NSObject (SBWDXPlaceholderIcon)

- (BOOL)isWDXPlaceholderIcon
{
	return NO;
}

- (BOOL)isWDXWidgetIcon {
	return NO;
}

@end

UIImage *imageFromView(UIView *view)
{
    CGRect rect = view.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedImage;
}


%subclass SBWDXPlaceholderIcon : SBLeafIcon

%new
- (id)initWithIdentifier:(NSString *)identifier {

	if ([self respondsToSelector:@selector(initWithLeafIdentifier:applicationBundleID:)]) {
		self = [self initWithLeafIdentifier:identifier applicationBundleID:nil];
	} else {
		self = [self initWithLeafIdentifier:identifier];
	}
	return self;
}

- (void)dealloc {
	%orig();
}

- (BOOL)isWDXPlaceholderIcon {
	return YES;
}

%new
- (NSString *)WDXidentifier
{
	return [self leafIdentifier];
}

- (UIImage *)getGenericIconImage:(int)image {

	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,67,67)];
	v.layer.cornerRadius = 18.0;
	v.layer.masksToBounds = YES;
	v.backgroundColor = [UIColor clearColor];
	UIImage *i = imageFromView(v);
	return i;
}

- (UIImage *)generateIconImage:(int)image {

	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,67,67)];
	v.layer.cornerRadius = 33.0;
	v.layer.masksToBounds = YES;
	v.backgroundColor = [UIColor clearColor];
	UIImage *i = imageFromView(v);
	//[gradient release];
	return i;
}

// when updating image view of icon
//	[self reloadIconImagePurgingImageCache:YES];

- (void)launchFromViewSwitcher {
	//Do something when icon is tapped
}

- (void)launch {
	//Other launch method from some OS
}

- (void)launchFromLocation:(int)location {
	// Same
}

- (BOOL)launchEnabled {
	return YES;
}

- (NSString *)displayName {
	return [NSString stringWithFormat:@" "];
}

- (BOOL)canEllipsizeLabel {
	return NO;
}

- (NSString *)folderFallbackTitle {
	return @"Liberi Profiles";
}

- (NSString *)applicationBundleID {
	return [self WDXidentifier];
}

- (Class)iconViewClassForLocation:(int)location {
	return NSClassFromString(@"SBWDXPlaceholderIconView");
}

- (Class)iconImageViewClassForLocation:(int)location {
	return NSClassFromString(@"SBWDXPlaceholderIconImageView");
}

%end

%subclass SBWDXWidgetIcon : SBLeafIcon

%new
- (id)initWithIdentifier:(NSString *)identifier {

	if ([self respondsToSelector:@selector(initWithLeafIdentifier:applicationBundleID:)]) {
		self = [self initWithLeafIdentifier:identifier applicationBundleID:nil];
	} else {
		self = [self initWithLeafIdentifier:identifier];
	}
	return self;
}

- (void)dealloc {
	%orig();
}

- (BOOL)isWDXWidgetIcon {
	return YES;
}

%new
- (NSString *)WDXidentifier
{
	return [self leafIdentifier];
}

- (UIImage *)getGenericIconImage:(int)image {

	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,67,67)];
	v.layer.cornerRadius = 18.0;
	v.layer.masksToBounds = YES;
	v.backgroundColor = [UIColor clearColor];
	UIImage *i = imageFromView(v);
	return i;
}

- (UIImage *)generateIconImage:(int)image {

	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,67,67)];
	v.layer.cornerRadius = 33.0;
	v.layer.masksToBounds = YES;
	v.backgroundColor = [UIColor clearColor];
	UIImage *i = imageFromView(v);
	//[gradient release];
	return i;
}

// when updating image view of icon
//	[self reloadIconImagePurgingImageCache:YES];

- (void)launchFromViewSwitcher {
	//Do something when icon is tapped
}

- (void)launch {
	//Other launch method from some OS
}

- (void)launchFromLocation:(int)location {
	// Same
}

- (BOOL)launchEnabled {
	return YES;
}

- (NSString *)displayName {
	return [NSString stringWithFormat:@" "];
}

- (BOOL)canEllipsizeLabel {
	return NO;
}

- (NSString *)folderFallbackTitle {
	return @"Liberi Profiles";
}

- (NSString *)applicationBundleID {
	return [self WDXidentifier];
}

- (Class)iconViewClassForLocation:(int)location {
	return NSClassFromString(@"SBWDXWidgetIconView");
}

- (Class)iconImageViewClassForLocation:(int)location {
	return NSClassFromString(@"SBWDXWidgetIconImageView");
}

%end

%subclass SBWDXPlaceholderIconView : SBIconView

- (NSString *)accessibilityValue {

	return @"Widux Space";
}

- (NSString *)accessibilityHint {

	return @"Widux Space";
}

- (void)_updateIconImageViewAnimated:(BOOL)animated {
	%orig();
}
- (BOOL)userInteractionEnabled {
	return NO;
}

%end

%subclass SBWDXPlaceholderIconImageView : SBIconImageView

- (void)updateImageAnimated:(BOOL)animated {
	%orig();
}

%end

%subclass SBWDXWidgetIconView : SBIconView

- (NSString *)accessibilityValue {

	return @"Widux Space";
}

- (NSString *)accessibilityHint {

	return @"Widux Space";
}

- (void)_updateIconImageViewAnimated:(BOOL)animated {
	%orig();
}
- (BOOL)userInteractionEnabled {
	return YES;
}

%end

%subclass SBWDXWidgetIconImageView : SBIconImageView

- (void)updateImageAnimated:(BOOL)animated {
	%orig();
}

%end

%hook SBIconController

- (Class)viewMap:(id)map iconViewClassForIcon:(SBIcon *)icon {

	if ([icon isWDXPlaceholderIcon])
		return NSClassFromString(@"SBWDXPlaceholderIconView");
	if ([icon isWDXWidgetIcon])
		return NSClassFromString(@"SBWDXWidgetIconView");
	return %orig();
}

%end