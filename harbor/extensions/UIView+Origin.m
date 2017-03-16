#import "UIView+Origin.h"


@implementation UIView (Origin)

- (CGPoint)origin {
	return self.frame.origin;
}

- (void)setOrigin:(CGPoint)newValue {
	CGRect frame = self.frame;
	frame.origin = newValue;
	self.frame = frame;
}

- (CGFloat)yOrigin {
	return self.frame.origin.y;
}

- (void)setYOrigin:(CGFloat)newValue {
	CGRect frame = self.frame;
	frame.origin.y = newValue;
	self.frame = frame;
}

- (CGFloat)xOrigin{
	return self.frame.origin.x;
}

- (void)setXOrigin:(CGFloat)newValue {
	CGRect frame = self.frame;
	frame.origin.x = newValue;
	self.frame = frame;
}


- (CGFloat)xCenter{
	return self.center.x;
}

- (void)setXCenter:(CGFloat)newValue {
	CGPoint center = self.center;
	center.x = newValue;
	self.center = center;
}


- (CGFloat)yCenter{
	return self.center.x;
}

- (void)setYCenter:(CGFloat)newValue {
	CGPoint center = self.center;
	center.y = newValue;
	self.center = center;
}



@end