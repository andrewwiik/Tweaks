#import "BNHourlyView.h"


@interface UIImage (ImageUtils)
- (UIImage *) maskWithColor:(UIColor *)color;
@end
@implementation UIImage (ImageUtils)
- (UIImage *)maskWithColor:(UIColor *)color
{
    CGImageRef maskImage = self.CGImage;
    CGFloat width = self.size.width * self.scale;
    CGFloat height = self.size.height * self.scale;
    CGRect bounds = CGRectMake(0,0,width,height);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    CGContextClipToMask(bitmapContext, bounds, maskImage);
    CGContextSetFillColorWithColor(bitmapContext, color.CGColor);
    CGContextFillRect(bitmapContext, bounds);

    CGImageRef cImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *coloredImage = [UIImage imageWithCGImage:cImage scale:self.scale orientation:self.imageOrientation];

    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(cImage);

    return coloredImage;
}
@end


@implementation BNHourlyView

- (id)initWithTime:(NSString *)time conditionCode:(int)condition tempature:(NSString *)tempature {
	if (self = [super init]) {
	self.frame = CGRectMake(0,0,66,93);
	NSString *hour = [time substringToIndex:2];
	if ([[hour substringToIndex:1] isEqualToString: @"0"]) {
		hour = [hour substringWithRange:NSMakeRange(1, 1)];
	}
	if ([hour intValue] >= 12) {
		_time = [NSString stringWithFormat:@"%@PM", hour];
	}
	else {
		_time = [NSString stringWithFormat:@"%@AM", hour];
	}
	if ([hour intValue] == 0) {
		_time = [NSString stringWithFormat:@"12AM"];
	}
	double temp = [tempature intValue]*1.8+32;
	_conditionImage = [[[NSClassFromString(@"WeatherImageLoader") conditionImageWithConditionIndex:condition] maskWithColor:[UIColor blackColor]] sbf_resizeImageToSize:CGSizeMake([NSClassFromString(@"WeatherImageLoader") conditionImageWithConditionIndex:condition].size.width*1,[NSClassFromString(@"WeatherImageLoader") conditionImageWithConditionIndex:condition].size.height*1)];
	_tempature = [NSString stringWithFormat:@"%dO", (int)temp];
	}
	return self;

}
- (void)layoutSubviews {
	[super layoutSubviews];


	_conditionIconView = [[UIImageView alloc] init];
	_conditionIconView.image = _conditionImage;
	_conditionIconView.translatesAutoresizingMaskIntoConstraints = NO;
	_conditionIconView.tintColor = [UIColor blackColor];
	[self addSubview:_conditionIconView];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:_conditionIconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:_conditionIconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-2.5]];

	_timeLabel = [[UILabel alloc] init];
	_timeLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:13];
	_timeLabel.text = _time;
	_timeLabel.textColor = [UIColor blackColor];
	_timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:_timeLabel];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:14]]; 

	_tempatureLabel = [[UILabel alloc] init];
	//_tempatureLabel.font = [UIFont systemFontOfSize: 17 weight:UIFontWeightThin];

	 NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_tempature
                                                                                         attributes:@{NSFontAttributeName: [UIFont fontWithName:@".SFUIDisplay-Ultralight" size:16]}];
    [attributedString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@".SFUIDisplay-Ultralight" size:7],NSBaselineOffsetAttributeName : @6} range:NSMakeRange([_tempature length]-1, 1)];

    _tempatureLabel.attributedText = attributedString;
	_tempatureLabel.textColor = [UIColor blackColor];
	_tempatureLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:_tempatureLabel];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:_tempatureLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	//[self addConstraint:[NSLayoutConstraint constraintWithItem:_tempatureLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_conditionIconView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:_tempatureLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-14]];


}

@end