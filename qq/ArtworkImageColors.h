#import <Foundation/Foundation.h>

@interface ArtworkImageColors : NSObject

- (id)initWithExtractedColors:(NSArray *)colors;

@property (nonatomic, readonly) UIColor *color1;
@property (nonatomic, readonly) UIColor *color2;
@property (nonatomic, readonly) UIColor *color3;
@property (nonatomic, readonly) UIColor *color4;

@end