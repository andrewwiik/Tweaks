// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping

@interface UIImage (Resize)

- (UIImage *)th_croppedImage:(CGRect)bounds;

- (UIImage *)th_thumbnailImage:(NSInteger)thumbnailSize
             transparentBorder:(NSUInteger)borderSize
                  cornerRadius:(NSUInteger)cornerRadius
          interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)th_resizedImage:(CGSize)newSize
        interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)th_resizedImageWithMaximumDimension:(CGFloat)maximumWidthOrHeight
                            interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)th_resizedImageWithContentMode:(UIViewContentMode)contentMode
                                     bounds:(CGSize)bounds
                       interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)th_resizedImage:(CGSize)newSize
                   transform:(CGAffineTransform)transform
              drawTransposed:(BOOL)transpose
     	interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)th_transformForOrientation:(CGSize)newSize;

@end
