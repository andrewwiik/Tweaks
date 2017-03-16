#import "CBRGradientView.h"

@implementation CBRGradientView

+ (Class)layerClass {
  return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.opaque = NO;
  }
  return self;
}

- (void)setSolidColor:(UIColor *)color {
  self.backgroundColor = color;
  if (color) {
    [self setColors:nil];
  }
}

- (void)setColors:(NSArray *)colors {
  [colors retain];
  [_colors release];
  _colors = colors;
  [self refreshGradientLayer];
  if (colors) {
    self.backgroundColor = nil;
  }
}

- (void)refreshGradientLayer {
  CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
  gradientLayer.colors = _colors;
  gradientLayer.startPoint = CGPointMake(0.0, 0.5);
  gradientLayer.endPoint = CGPointMake(1.0, 0.5);
}

- (void)dealloc {
  [_colors release];
  [super dealloc];
}

@end
