#import "headers.h"


@interface NCVibrantStyling : NSObject
+ (id)vibrantStylingWithStyle:(int)arg1;
@end

@interface UIView (Private)
@property (assign,setter=_setContinuousCornerRadius:,nonatomic) CGFloat _continuousCornerRadius; 
-(void)_setContinuousCornerRadius:(CGFloat)radius;
- (void)nc_applyVibrantStyling:(id)styling;
- (UIImage *)_imageFromRect:(CGRect)rect;
- (void)nc_removeAllVibrantStyling;
@end

%group Widget

%hook NCVibrantWidgetPrimaryHighlightStyling
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
}
%end

%hook NCVibrantWidgetPrimaryStyling
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
}

%end

%hook NCVibrantWidgetQuaternaryStyling
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.05];
}

%end

%hook NCVibrantWidgetSecondaryHighlightStylingZ
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.42];
}

%end

%hook NCVibrantWidgetSecondaryStyling
- (CGFloat)alpha {
	return 1;
}
- (UIColor *)color {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
}
%end

%hook NCVibrantWidgetTertiaryStyling
- (CGFloat)alpha {
	return 1.0;
}
- (UIColor *)color {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.13];
}
%end

extern NSString * const kCAFilterVibrantLight;
extern NSString * const kCAFilterVibrantDark;

%hook NCPlusDStyling
- (NSString *)blendMode {
	return kCAFilterVibrantDark;
}
- (BOOL)_inputReversed {
	return YES;
}
%end

%hook UILabel
- (void)nc_applyVibrantStyling:(id)style {
	[self nc_removeAllVibrantStyling];
	%orig([NSClassFromString(@"NCVibrantWidgetPrimaryStyling") new]);
}
- (void)setTextColor:(UIColor *)color {
	[[UILabel appearance] setTextColor:[UIColor blackColor]]; 
	%orig([UIColor whiteColor]);
}
- (UIColor *)textColor {
	return [UIColor whiteColor];
}
- (void)setColor:(UIColor *)color {
	%orig([UIColor whiteColor]);
}

- (void)layoutSubviews {
	%orig;
	[self setTextColor:[UIColor whiteColor]];
	[self nc_removeAllVibrantStyling];
	[self nc_applyVibrantStyling:[NSClassFromString(@"NCVibrantWidgetPrimaryStyling") new]];
}
%end
%end

@interface NCLookViewBackdropViewSettings : _UIBackdropViewSettings

@end


%ctor {
	if ([(NSDictionary *)[NSBundle mainBundle].infoDictionary valueForKey:@"NSExtension"]) {
		if ([[(NSDictionary *)[NSBundle mainBundle].infoDictionary valueForKey:@"NSExtension"] valueForKey:@"NSExtensionPointIdentifier"]) {
			if ([[[(NSDictionary *)[NSBundle mainBundle].infoDictionary valueForKey:@"NSExtension"] valueForKey:@"NSExtensionPointIdentifier"] isEqualToString:[NSString stringWithFormat:@"com.apple.widget-extension"]]) {
				%init(Widget);
				return;
			}
		}
	}
}


