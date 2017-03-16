// UIImage+Alpha.h
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Helper methods for adding an alpha layer to an image

@interface UIImage (THAlpha)

- (BOOL)th_hasAlpha;
- (UIImage *)th_imageWithAlpha;
- (UIImage *)th_transparentBorderImage:(NSUInteger)borderSize;
- (CGImageRef)newBorderMask_th:(NSUInteger)borderSize size:(CGSize)size;

@end
