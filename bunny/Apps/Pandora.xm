#import <substrate.h>
#import "interface.h"

@interface UIImage (THAlpha)

- (BOOL)th_hasAlpha;
- (UIImage *)th_imageWithAlpha;
- (UIImage *)th_transparentBorderImage:(NSUInteger)borderSize;
- (CGImageRef)newBorderMask_th:(NSUInteger)borderSize size:(CGSize)size;

@end

@implementation UIImage (THAlpha)

// Returns true if the image has an alpha layer
- (BOOL)th_hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)th_imageWithAlpha {
    if ([self th_hasAlpha]) {
        return self;
    }
    
    CGFloat scale = MAX(self.scale, 1.0f);
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef)*scale;
    size_t height = CGImageGetHeight(imageRef)*scale;
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha scale:self.scale orientation:UIImageOrientationUp];
    
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

// Returns a copy of the image with a transparent border of the given size added around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)th_transparentBorderImage:(NSUInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self th_imageWithAlpha];
    CGFloat scale = MAX(self.scale, 1.0f);
    NSUInteger scaledBorderSize = borderSize * scale;
    CGRect newRect = CGRectMake(0, 0, image.size.width * scale + scaledBorderSize * 2, image.size.height * scale + scaledBorderSize * 2);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(self.CGImage),
                                                0,
                                                CGImageGetColorSpace(self.CGImage),
                                                CGImageGetBitmapInfo(self.CGImage));
    
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect imageLocation = CGRectMake(scaledBorderSize, scaledBorderSize, image.size.width*scale, image.size.height*scale);
    CGContextDrawImage(bitmap, imageLocation, self.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    // Create a mask to make the border transparent, and combine it with the image
    CGImageRef maskImageRef = [self newBorderMask_th:scaledBorderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef scale:self.scale orientation:UIImageOrientationUp];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

#pragma mark -
#pragma mark Private helper methods

// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease
- (CGImageRef)newBorderMask_th:(NSUInteger)borderSize size:(CGSize)size {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Build a context that's the same dimensions as the new size
    CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8, // 8-bit grayscale
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));
    
    // Get an image of the context
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    // Clean up
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    
    return maskImageRef;
}

@end

@interface UIImage (RoundedCorner)

- (UIImage *)th_roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
- (void)th_addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight;

@end

@implementation UIImage (RoundedCorner)

// Creates a copy of this image with rounded corners
// If borderSize is non-zero, a transparent border of the given size will also be added
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (UIImage *)th_roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self th_imageWithAlpha];

    CGFloat scale = MAX(self.scale,1.0f);
    NSUInteger scaledBorderSize = borderSize * scale;

    // Build a context that's the same dimensions as the new size
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 image.size.width*scale,
                                                 image.size.height*scale,
                                                 CGImageGetBitsPerComponent(image.CGImage),
                                                 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));

    // Create a clipping path with rounded corners
    
    CGContextBeginPath(context);
    [self th_addRoundedRectToPath:CGRectMake(scaledBorderSize, scaledBorderSize, image.size.width*scale - borderSize * 2, image.size.height*scale - borderSize * 2)
                       context:context
                     ovalWidth:cornerSize*scale
                    ovalHeight:cornerSize*scale];
    CGContextClosePath(context);
    CGContextClip(context);

    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width*scale, image.size.height*scale), image.CGImage);
    
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    // Create a UIImage from the CGImage
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage scale:self.scale orientation:UIImageOrientationUp];
    
    CGImageRelease(clippedImage);
    
    return roundedImage;
}

#pragma mark -
#pragma mark Private helper methods

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (void)th_addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight {
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
    CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@end

@interface PMSpotlightManager : NSObject
+ (instancetype)sharedInstance;
- (void)handleOpenStationWithIdentifier:(id)identifier;
@end

@interface PMPhoneApplicationDelegate : NSObject
- (void)updateShortcutItems;
@end

@interface StationDescriptor : NSObject
- (UIImage*)art;
- (NSString*)stationName;
- (NSDate*)lastListenedDate;
- (id)stationId;
- (NSMutableArray*)genre;
@end

@interface PMSortedStationManager : NSObject
+ (instancetype)sharedManager;
- (NSMutableArray*)stationsSortedUsingSortType:(NSInteger)type;
@end

%hook PMPhoneApplicationDelegate
-(void)applicationDidCompleteInitialization {
   %orig;
   [self updateShortcutItems];
}
%new
-(void)updateShortcutItems {
   NSMutableArray *stations = [[%c(PMSortedStationManager) sharedManager] stationsSortedUsingSortType:0];
   NSUInteger count = [stations count];
   NSMutableArray* shortcuts = [[NSMutableArray alloc] init];
   if (count > 11) {
      count = 11;
   }
   for (NSUInteger i = 0; i < count; i++) {
      StationDescriptor *station = [stations objectAtIndex:i];
      NSString *stationName = [station stationName];
      UIImage *stationArt = [station art];
      UIImage *stationArtStuff = [stationArt th_roundedCornerImage:100 borderSize:0];
      NSData *stationArtData = UIImagePNGRepresentation(stationArtStuff);
      id stationID = [station stationId];
      NSString *genre = [NSString stringWithFormat:@"Mixed"];
      if ([[station genre] count] > 0) {
         genre = [[station genre] objectAtIndex:0];
      }
      SBSApplicationShortcutCustomImageIcon *artworkIcon = [[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:stationArtData];
      UIApplicationShortcutIcon *finalArtworkIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon:artworkIcon];
      NSMutableDictionary* userInfoData = [NSMutableDictionary new];
      [userInfoData setObject: stationID forKey:@"stationID"];
      UIMutableApplicationShortcutItem *stationShortcut = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.pandora.station"] localizedTitle:stationName localizedSubtitle: genre icon:finalArtworkIcon userInfo:userInfoData];
      [shortcuts addObject:stationShortcut];
   }
   [UIApplication sharedApplication].shortcutItems = shortcuts;
}
%new
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
  if ([shortcutItem.type isEqualToString:@"com.pandora.station"]) {
    NSDictionary *userInfo = shortcutItem.userInfo;
    id stationID = [userInfo valueForKey:@"stationID"];
    [[[NSClassFromString(@"Pandora.PMSpotlightManager") class] sharedInstance] performSelector:@selector(handleOpenStationWithIdentifier:) withObject:stationID];
  }
  completionHandler(YES);
}
%end

%ctor {
  if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.pandora1"]) { // Pandora App
          %init;
  }
}