#import <UIKit/UIKit.h>

enum IBKLabelSizing {
    kIBKLabelSizingTiny,
    kIBKLabelSizingSmall,
    kIBKLabelSizingSmallBold,
    kIBKLabelSizingButtonView,
    kIBKLabelSizingMedium,
    kIBKLabelSizingLarge,
    kIBKLabelSizingGiant
};

@interface IBKLabel : UILabel {
    CGFloat _blurRadius;
    CGFloat _shadowAlpha;
}

@property (nonatomic, readwrite) BOOL shadowingEnabled;

/**
 * Sets up the label for the appropriate size
 *
 * @param size The size desired for the label
 */
-(void)setLabelSize:(int)size;

@end