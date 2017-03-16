#define GETRED(rgb) ((rgb >> 16) & 0xFF)
#define GETGREEN(rgb) ((rgb >> 8) & 0xFF)
#define GETBLUE(rgb) (rgb & 0xFF)
#define UIColorFromRGB(rgb) [UIColor colorWithRed:GETRED(rgb)/255.0 green:GETGREEN(rgb)/255.0 blue:GETBLUE(rgb)/255.0 alpha:1.0]

@interface ColorBadges : NSObject

+ (instancetype)sharedInstance;
+ (BOOL)isDarkColor:(int)color;
+ (BOOL)areBordersEnabled;
+ (BOOL)isEnabled;

// Return RGB ints. i.e. 0xRRGGBB.
- (int)colorForImage:(UIImage *)image;
- (int)colorForIcon:(id)icon; // Must be an SBIcon *

@end

// You can use the API like the following. Note that you may need to dlopen ColorBadges first.
/*
@implementation YourObject
- (void)configureMyBadge:(id)badge forIcon:(id)icon {
  Class cb = %c(ColorBadges);
  if ([cb isEnabled]) {
    int color = [[cb sharedInstance] colorForIcon:icon];
    badge.tintColor = UIColorFromRGB(color);
    UIColor *textColor = ([cb isDarkColor:color]) ? [UIColor whiteColor] : [UIColor blackColor];
    badge.textColor = textColor;

    if ([cb areBordersEnabled]) {
      UIColor *borderColor = textColor;
      // Add border.
    }
  } else {
    badge.tintColor = [UIColor redColor]; // Default color
  }
}
@end
*/
