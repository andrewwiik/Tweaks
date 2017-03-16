#import "QCRCrashCell.h"
#import <Preferences/PSSpecifier.h>

@implementation QCRCrashCell

+ (UIColor*)defaultDetailTextColor {
    int value = 0x7F7F7F;
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0];
}
+ (CGFloat)defaultCellHeight {
    return 40.f;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width {
	// Return a custom cell height.
	return 50.f;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:3 reuseIdentifier:@"QCRCrashCell"];
    if (self) {
    	CRCrashReport *report = [CRCrashReport crashReportWithFile:[specifier propertyForKey:@"crashPath"] filterType:CRCrashReportFilterTypePackage];
    	if (report) self.report = report;
    	NSString *syslogPath = syslogPathForFile([specifier propertyForKey:@"crashPath"]);
        if (syslogPath) {
        	self.syslogPath = syslogPath;
        }
        self.textLabel.text = [self.report.properties objectForKey:@"app_name"];
        self.detailTextLabel.text = [self.report.properties objectForKey:@"timestamp"];
        //self.imageView.image = [[NSClassFromString(@"_UIAssetManager") assetManagerForBundle:[NSBundle bundleWithIdentifier:[NSString stringWithFormat:@"com.apple.settings.BatteryUsageUI"]]] imageNamed:@"SpringBoard"];
        self.imageView.image = [self testImage];
        if (![specifier propertyForKey:@"submitting"])
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    	if ([[specifier propertyForKey:@"submitting"] boolValue] == YES) {
        	self.accessoryType = UITableViewCellAccessoryNone;
        	self.userInteractionEnabled = NO;
        }
        self.textLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.textColor = [QCRCrashCell defaultDetailTextColor];
    }
    return self;
}

- (UIImage *)testImage {
	return [UIImage imageWithContentsOfFile:@"/System/Library/PreferenceBundles/BatteryUsageUI.bundle/SpringBoard.png"];
}

- (void)layoutSubviews {
	if ([[self.specifier propertyForKey:@"submitting"] boolValue] == YES) {
        	self.accessoryType = UITableViewCellAccessoryNone;
        	self.userInteractionEnabled = NO;
        }
	[[self iconImageView] setImage:[self testImage]];
	self.textLabel.text = [self.report.properties objectForKey:@"app_name"];
    self.detailTextLabel.text = [self.report.properties objectForKey:@"timestamp"];
    [super layoutSubviews];
    [self setFrameHeight:[self preferredHeightForWidth:self.frame.size.width]];

    NSInteger image_Height = 29;
    //self.imageView.frame = CGRectMake(12, (self.frame.size.height-image_Height)/2, image_Height, image_Height);
    
    //self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2;

    self.textLabel.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 12, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, 19.5);
    self.detailTextLabel.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width + 12, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, 14.5);
    self.separatorInset = UIEdgeInsetsMake(0,self.textLabel.frame.origin.x,0,0);
}
@end