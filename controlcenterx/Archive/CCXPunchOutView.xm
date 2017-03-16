#import "CCXPunchOutView.h"

%subclass CCXPunchOutStyling : NCVibrantRuleStyling
- (UIColor *)color {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25];
}
- (UIColor *)_darkenColor {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}
%end

%subclass CCXPunchOutView : UIView
%property (nonatomic, assign) NSInteger style;                                //@synthesize style=_style - In the implementation block
%property (nonatomic, assign) CGFloat cornerRadius;                            //@synthesize cornerRadius=_cornerRadius - In the implementation block
%property (nonatomic, assign) NSUInteger roundCorners;

- (CCUIPunchOutMask *)ccuiPunchOutMaskForView:(UIView *)view {
	return nil;
	// CGRect frame = CGRectZero;
	// if (view != nil) {
	// 	frame = [self convertRect:self.bounds fromView:view];
	// } 
	// return [[NSClassFromString(@"CCUIPunchOutMask") alloc] initWithFrame:frame style:self.style radius:self.cornerRadius roundedCorners:self.roundCorners];
}
- (void)layoutSubviews {
	%orig;
	[self nc_removeAllVibrantStyling];
	[self nc_applyVibrantStyling:[NSClassFromString(@"CCXPunchOutStyling") new]];
}
%end