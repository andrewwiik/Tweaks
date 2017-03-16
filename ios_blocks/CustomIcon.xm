@implementation NSObject (LiberiOSIcons)

- (BOOL)isLiberiOSIcon
{
	return NO;
}

@end

%subclass SBLiberiIcon : SBLeafIcon

%new
- (id)initWithTestIdentifier:(NSString *)testIdentifier {

	NSString *leafIdentifier = [kIdentifierPrefix stringByAppendingString:testIdentifier];
	if ([self respondsToSelector:@selector(initWithLeafIdentifier:applicationBundleID:)]) {
		self = [self initWithLeafIdentifier:leafIdentifier applicationBundleID:nil];
	} else {
		self = [self initWithLeafIdentifier:leafIdentifier];
	}
	return self;
}

- (void)dealloc {
	%orig();
}

- (BOOL)isLiberiOSIcon {
	return YES;
}

%new
- (NSString *)testIdentifier
{
	return [[self leafIdentifier] substringFromIndex:24];
}

- (UIImage *)getGenericIconImage:(int)image {

	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,67,67)];
	v.layer.cornerRadius = 18.0;
	v.layer.masksToBounds = YES;
	v.backgroundColor = [UIColor blueColor];
	CAGradientLayer *gradient = [CAGradientLayer layer];
			gradient.frame = v.bounds;
			gradient.colors = kColorGradientAqua2;
	[v.layer insertSublayer:gradient atIndex:0];
	UILabel *letterLabel = [[UILabel alloc]initWithFrame:v.bounds];
	letterLabel.font = [UIFont fontWithName:@"Helvetica" size:30];
	letterLabel.text = [[self leafIdentifier] stringByReplacingOccurrencesOfString:@"com.cpdigitaldarkroom.liberios." withString:@""];
	letterLabel.textColor = [UIColor whiteColor];
	letterLabel.textAlignment = NSTextAlignmentCenter;
	[v addSubview:letterLabel];
	UIImage *i = imageFromView(v);
	[v release];
	//[gradient release];
	return i;
}

- (UIImage *)generateIconImage:(int)image {

	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,67,67)];
	v.layer.cornerRadius = 33.0;
	v.layer.masksToBounds = YES;
	v.backgroundColor = [UIColor blueColor];
	CAGradientLayer *gradient = [CAGradientLayer layer];
			gradient.frame = v.bounds;
			gradient.colors = colorForProfileName([[self leafIdentifier] stringByReplacingOccurrencesOfString:@"com.cpdigitaldarkroom.liberios." withString:@""]);
	[v.layer insertSublayer:gradient atIndex:0];
	UILabel *letterLabel = [[UILabel alloc]initWithFrame:v.bounds];
	letterLabel.font = [UIFont fontWithName:@"Helvetica" size:30];
	letterLabel.text = [[[[self leafIdentifier] stringByReplacingOccurrencesOfString:@"com.cpdigitaldarkroom.liberios." withString:@""] substringToIndex:1] uppercaseString];
	letterLabel.textColor = [UIColor whiteColor];
	letterLabel.textAlignment = NSTextAlignmentCenter;
	[v addSubview:letterLabel];
	UIImage *i = imageFromView(v);
	[v release];
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
	return [[self leafIdentifier] stringByReplacingOccurrencesOfString:@"com.cpdigitaldarkroom.liberios." withString:@""];
}

- (BOOL)canEllipsizeLabel {
	return NO;
}

- (NSString *)folderFallbackTitle {
	return @"Liberi Profiles";
}

- (NSString *)applicationBundleID {
	return [@"testicon-" stringByAppendingString:[self testIdentifier]];
}

- (Class)iconViewClassForLocation:(int)location {
	return NSClassFromString(@"SBLiberiIconView");
}

- (Class)iconImageViewClassForLocation:(int)location {
	return NSClassFromString(@"SBLiberiIconImageView");
}

%end

%subclass SBLiberiIconView : SBIconView

- (NSString *)accessibilityValue {

	return @"Test";
}

- (NSString *)accessibilityHint {

	return @"Test";
}

- (void)_updateIconImageViewAnimated:(BOOL)animated {
	%orig();
}

%end

%subclass SBLiberiIconImageView : SBIconImageView

- (void)updateImageAnimated:(BOOL)animated {
	%orig();
}

%end

%hook SBIconController

- (Class)viewMap:(id)map iconViewClassForIcon:(SBIcon *)icon {

	if ([icon isLiberiOSIcon])
		return NSClassFromString(@"SBLiberiIconView");

	return %orig();
}

%end

%hook SBIconModel

- (void)loadAllIcons {

	%orig();
	
	SBLiberiIcon *icon = [[%c(SBLiberiIcon) alloc] initWithTestIdentifier:str];
	[self addIcon:icon];
	[[NSClassFromString(@"SBIconController") sharedInstance] addNewIconToDesignatedLocation:icon animate:YES scrollToList:NO saveIconState:YES]; 
	[icon release];

}

%end