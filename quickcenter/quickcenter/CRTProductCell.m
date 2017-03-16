#import "CRTProductCell.h"

@implementation CRTProductCell
- (id)_createInstallButton {
	return [super _createInstallButton];
	
}
- (id)_createLabelForAppName:(id)arg1 {
	return [super _createLabelForAppName:arg1];
}
- (id)_createLabelForPublisher:(id)arg1 {
	return [super _createLabelForPublisher:arg1];
}
- (void)_updateInstallButtonWithState:(int)arg1 {
	[super _updateInstallButtonWithState:arg1];
}
- (void)_updateSubviewsWithInstallState:(int)arg1 {
	[super _updateSubviewsWithInstallState:arg1];
}
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(PSSpecifier*)arg3 {
	[arg3 setProperty:[UIImage imageWithContentsOfFile:[arg3 propertyForKey:@"icon"]] forKey:@"ACUIAppInstallIcon"];
	return [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
}
- (int)installState {
	return [super installState];
}
- (void)layoutSubviews {
	[super layoutSubviews];
}
- (void)setInstallState:(int)arg1 {
	[super setInstallState:arg1];
}
- (void)touchesBegan:(id)arg1 withEvent:(id)arg2 {
	[super touchesBegan:arg1 withEvent:arg2];
	
}
- (void)touchesCancelled:(id)arg1 withEvent:(id)arg2 {
	[super touchesCancelled:arg1 withEvent:arg2];
}
- (void)touchesEnded:(id)arg1 withEvent:(id)arg2 {
	[super touchesEnded:arg1 withEvent:arg2];
}
- (void)touchesMoved:(id)arg1 withEvent:(id)arg2 {
	[super touchesMoved:arg1 withEvent:arg2];
}
@end