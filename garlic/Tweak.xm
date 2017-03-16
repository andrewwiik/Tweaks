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
@interface AVButton : UIButton
@end

%group LoadLate
%hook AVButton
%new
- (void)testingHook {

}
- (void)setImage:(UIImage *)image forState:(NSUInteger)state {
	image = [image maskWithColor:[UIColor whiteColor]];
	%orig(image,state);
}
- (UIImage *)currentImage {
	return [%orig maskWithColor:[UIColor whiteColor]];
}
- (void)layoutSubviews {
	%orig;
	[self setImage:[self currentImage] forState:0];
	[self setImage:[self currentImage] forState:1];
	[self setImage:[self currentImage] forState:2];
}
%end
%end


static void loadFuck() {
	%init(LoadLate);
}

@interface ButtHole : NSObject
+ (void)testingShit;
@end
@implementation ButtHole
+ (void)testingShit {
	loadFuck();
}
@end

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	if ([(( __bridge NSDictionary *)userInfo)[NSLoadedClasses] containsObject:@"AVButton"]) {
	}
}

%ctor {
	%init;
	CFNotificationCenterAddObserver(
		CFNotificationCenterGetLocalCenter(), NULL,
		notificationCallback,
		(CFStringRef)NSBundleDidLoadNotification,
		NULL, CFNotificationSuspensionBehaviorCoalesce);
}