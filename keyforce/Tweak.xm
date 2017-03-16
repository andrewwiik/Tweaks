#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIKBKeyView.h>
#import <UIKit/UIKBKey.h>
#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIGestureRecognizerSubclass.h> // This import is essential

typedef enum UIApplicationShortcutIconType : NSInteger {
   UIApplicationShortcutIconTypeCompose,
   UIApplicationShortcutIconTypePlay,
   UIApplicationShortcutIconTypePause,
   UIApplicationShortcutIconTypeAdd,
   UIApplicationShortcutIconTypeLocation,
   UIApplicationShortcutIconTypeSearch,
   UIApplicationShortcutIconTypeShare,
   UIApplicationShortcutIconTypeProhibit,
   UIApplicationShortcutIconTypeContact,
   UIApplicationShortcutIconTypeHome,
   UIApplicationShortcutIconTypeMarkLocation,
   UIApplicationShortcutIconTypeFavorite,
   UIApplicationShortcutIconTypeLove,
   UIApplicationShortcutIconTypeCloud,
   UIApplicationShortcutIconTypeInvitation,
   UIApplicationShortcutIconTypeConfirmation,
   UIApplicationShortcutIconTypeMail,
   UIApplicationShortcutIconTypeMessage,
   UIApplicationShortcutIconTypeDate,
   UIApplicationShortcutIconTypeTime,
   UIApplicationShortcutIconTypeCapturePhoto,
   UIApplicationShortcutIconTypeCaptureVideo,
   UIApplicationShortcutIconTypeTask,
   UIApplicationShortcutIconTypeTaskCompleted,
   UIApplicationShortcutIconTypeAlarm,
   UIApplicationShortcutIconTypeBookmark,
   UIApplicationShortcutIconTypeShuffle,
   UIApplicationShortcutIconTypeAudio,
   UIApplicationShortcutIconTypeUpdate 
} UIApplicationShortcutIconType;

extern "C" void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id unknown, NSDictionary *options);

@interface UIApplicationShortcutIcon : NSObject
+ (id)iconWithCustomImage:(id)arg1;
+ (id)iconWithTemplateImageName:(id)arg1;
+ (BOOL)supportsSecureCoding;
- (unsigned int)hash;
- (id)initWithSBSApplicationShortcutIcon:(id)arg1;
- (BOOL)isEqual:(id)arg1;
// Image: /System/Library/Frameworks/ContactsUI.framework/ContactsUI

+ (id)iconWithContact:(id)arg1;

@end

@interface SBIconView : UIView
@property(retain, nonatomic) UILongPressGestureRecognizer *shortcutMenuPeekGesture;
@property(assign, nonatomic) BOOL isEditing;
@property(retain, nonatomic) id icon;
- (void)_handleSecondHalfLongPressTimer:(id)arg1;
- (void)cancelLongPressTimer;
- (id)delegate;
@end

@interface SBApplication : NSObject
@property(copy, nonatomic) NSArray *dynamicShortcutItems;
@property(copy, nonatomic) NSArray *staticShortcutItems;
- (NSString*)bundleIdentifier;
- (NSString*)displayName;
@end

@interface SBIcon : NSObject
- (void)launchFromLocation:(int)location;
- (BOOL)isFolderIcon;// iOS 4+
- (NSString*)applicationBundleID;
- (SBApplication*)application;
- (id)generateIconImage:(int)arg1;
- (id)displayName;
-(id)leafIdentifier;
- (id)displayNameForLocation:(int)arg1;
@end
@interface SBFolder : NSObject
- (SBIcon*)iconAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface SBFolderIcon : NSObject
- (SBFolder*)folder;
@end
@interface SBFolderIconView : SBIconView
- (SBFolderIcon*)folderIcon;
@end

@interface IMDChatRegistry : NSObject
+ (instancetype)sharedInstance;
- (BOOL)loadChatsWithCompletionBlock:(id /* block */)arg1;
- (void)run;

+ (void)performBlockOnMainThreadSynchronously:(id)arg1;

@end
@interface UIPreviewInteractionController : NSObject
- (void)commitInteractivePreview;
@end
@interface UIApplicationShortcutItem : NSObject

+ (unsigned int)_sbsActivationModeFromUIActivationMode:(unsigned int)arg1;
+ (unsigned int)_uiActivationModeFromSBSActivationMode:(unsigned int)arg1;
+ (BOOL)supportsSecureCoding;

- (id)_initWithType:(id)arg1 localizedTitle:(id)arg2 localizedSubtitle:(id)arg3 icon:(id)arg4 userInfoData:(id)arg5 activationMode:(unsigned int)arg6;
- (unsigned int)activationMode;
- (id)description;
- (unsigned int)hash;
- (id)icon;
- (id)init;
- (id)initWithSBSApplicationShortcutItem:(id)arg1;
- (id)initWithType:(id)arg1 localizedTitle:(id)arg2;
- (id)initWithType:(id)arg1 localizedTitle:(id)arg2 localizedSubtitle:(id)arg3 icon:(id)arg4 userInfo:(id)arg5;
- (BOOL)isEqual:(id)arg1;
- (id)localizedSubtitle;
- (id)localizedTitle;
- (id)sbsShortcutItem;
- (void)setActivationMode:(unsigned int)arg1;
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
- (void)setUserInfo:(id)arg1;
- (void)setUserInfoData:(id)arg1;
- (id)type;
- (id)userInfo;
- (id)userInfoData;

@end
@interface UIMutableApplicationShortcutItem : UIApplicationShortcutItem

@property (nonatomic) unsigned int activationMode;
@property (nonatomic, copy) NSString *localizedSubtitle;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSDictionary *userInfo;

@end
@interface SBSApplicationShortcutIcon : NSObject

@end

@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
@end

@interface SBSApplicationShortcutIcon (UF)
- (id)initWithType:(UIApplicationShortcutIconType)arg1;
@end

@interface SBSApplicationShortcutContactIcon : SBSApplicationShortcutIcon
-(instancetype)initWithContactIdentifier:(NSString *)contactIdentifier;
-(instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
-(instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName imageData:(NSData *)imageData;
@end

@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
@property (nonatomic, readonly, retain) NSData *imagePNGData;
-(instancetype)initWithImagePNGData:(NSData *)imageData;
@end

@interface UIApplication (QuickSettings)
@property (nonatomic, copy) NSArray *shortcutItems;
-(void)setShortcutItems:(NSArray*)arg1;
@end

@interface CKSpringBoardActionManager
- (void)updateShortcutItems;
@end

@interface AXForceTouchController : UIViewController
@end

@interface SBSApplicationShortcutItem : NSObject
- (void)setBundleIdentifierToLaunch:(id)arg1;
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
- (void)setUserInfo:(id)arg1;
- (void)setUserInfoData:(id)arg1;
@end

@class SBApplicationShortcutMenu;
@protocol SBApplicationShortcutMenuDelegate <NSObject>
- (void)applicationShortcutMenu:(SBApplicationShortcutMenu *)arg1 launchApplicationWithIconView:(SBIconView *)arg2;
- (void)applicationShortcutMenu:(SBApplicationShortcutMenu *)arg1 startEditingForIconView:(SBIconView *)arg2;
- (void)applicationShortcutMenu:(SBApplicationShortcutMenu *)arg1 activateShortcutItem:(SBSApplicationShortcutItem *)arg2 index:(long long)arg3;

@optional
- (void)applicationShortcutMenuDidPresent:(SBApplicationShortcutMenu *)arg1;
- (void)applicationShortcutMenuDidDismiss:(SBApplicationShortcutMenu *)arg1;
@end

@interface SBApplicationShortcutMenu : UIView
@property(retain, nonatomic) SBApplication *application;
 // @synthesize application=_application;
@property(retain ,nonatomic) id applicationShortcutMenuDelegate;
- (void)updateFromPressGestureRecognizer:(id)arg1;
- (void)menuContentView:(id)arg1 activateShortcutItem:(id)arg2 index:(long long)arg3;
- (void)dismissAnimated:(BOOL)arg1 completionHandler:(id)arg2;
- (id)initWithFrame:(CGRect)arg1 application:(id)arg2 iconView:(id)arg3 interactionProgress:(id)arg4 orientation:(long long)arg5;
- (void)presentAnimated:(_Bool)arg1;
- (void)interactionProgressDidUpdate:(id)arg1;
- (SBFolderIconView*)iconView;
@end

@interface _UITextSelectionForceGesture : UILongPressGestureRecognizer
@end

@interface UIView (AXForceTouchController)
-(UIViewController *)delegate;
@end

@interface SBIconController : UIViewController
@property(retain, nonatomic) SBApplicationShortcutMenu *presentedShortcutMenu; // @synthesize presentedShortcutMenu=_presentedShortcutMenu;
+ (id)sharedInstance;
- (void)_revealMenuForIconView:(id)iconView presentImmediately:(BOOL)now;
- (void)setIsEditing:(BOOL)arg1;
- (BOOL)isEditing;
- (void)_dismissShortcutMenuAnimated:(BOOL)arg1 completionHandler:(id)arg1;
- (void)_launchIcon:(id)icon;
- (void)_handleShortcutMenuPeek:(id)arg1;
- (id)presentedShortcutMenu;
- (void)applicationShortcutMenuDidPresent:(id)arg1;
@end

@interface UIView (SBIconView)
@property(assign, nonatomic) BOOL isEditing;
- (void)cancelLongPressTimer;
@end

@interface UIView (SBApplicationShortcutMenuItemView)
- (void)setHighlighted:(BOOL)arg1;
@end

@interface SBApplicationShortcutMenuItemView : UIView
@property(retain, nonatomic) SBSApplicationShortcutItem *shortcutItem; // @synthesize shortcutItem=_shortcutItem;
@property(readonly, nonatomic) long long menuPosition;
@property(nonatomic) _Bool highlighted; // @synthesize highlighted=_highlighted;
- (id)superviewOfClass:(Class)arg1;
@end

@interface SBApplicationShortcutMenuContentView : UIView
- (void)updateSelectionFromPressGestureRecognizer:(id)arg1;
- (double)_rowHeight;
@end

@interface SBMainSwitcherViewController : UIViewController
+ (id)sharedInstance;
@end

@interface UIKeyboardLayoutStar : UIView
- (void)willBeginIndirectSelectionGesture;
- (void)didEndIndirectSelectionGesture;
@end

@interface UIKeyboardImpl : NSObject
- (UIKeyboardLayoutStar *)_layout;
@end

@interface _UIKeyboardTextSelectionGestureController : NSObject
- (id)oneFingerForcePressRecognizer;
+ (id)sharedInstance;
- (void)addOneFingerForcePressRecognizerToView:(id)arg1;
- (void)configureOneFingerForcePressRecognizer:(id)arg1;
- (void)_willBeginIndirectSelectionGesture:(id)arg1;
- (UIKeyboardImpl *)delegate;
@end

@interface UIKBKeyView (UniversalForce) <UIGestureRecognizerDelegate>
@end

@interface _UITouchForceMessage : NSObject
@property (nonatomic) double timestamp;
@property (nonatomic) float unclampedTouchForce;
- (void)setUnclampedTouchForce:(float)touchForce;
- (float)unclampedTouchForce;
@end

@interface UITouch (Private)
- (void)_setPressure:(float)arg1 resetPrevious:(BOOL)arg2;
- (float)_pathMajorRadius;
- (float)majorRadius;
- (CGPoint)_locationInSceneReferenceSpace;
- (id)_hidEvent;
- (CGFloat)getQuality;
- (CGFloat)getRadius;
- (CGFloat)getDensity;
- (int)getX;
- (int)getY;
@end

@interface NSString (Creatix)
- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end;
@end

@interface STKGroupView : NSObject
- (void)close;
@end

@implementation NSString (Creatix)
- (NSString*) stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;   
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
           targetRange.length = endRange.location - targetRange.location;
           return [self substringWithRange:targetRange];
        }
    }
    return nil;
}
@end

@interface NSArray (FindClass)
- (NSMutableArray *) findObjectsOfClass:(Class)theClass;
@end

@implementation NSArray (FindClass)
- (NSMutableArray *) findObjectsOfClass:(Class)theClass {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (id obj in self) {
        if ([obj isKindOfClass:theClass])
            [results addObject:obj];
    }

    return [results autorelease];
}
@end

@interface NSArray (Reverse)
- (NSArray *)reversedArray;
@end

@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end
@interface NSMutableArray (Reverse)
- (void)reverse;
@end
@implementation NSMutableArray (Reverse)

- (void)reverse {
    if ([self count] <= 1)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];

        i++;
        j--;
    }
}

@end

@interface ShortcutCalculator : NSObject
+ (NSInteger)maxShortcutForAssumedWidthAtPoint:(CGPoint)point;
+ (NSInteger)maxShortcutForWidth:(NSInteger)width atPoint:(CGPoint)point;
+ (BOOL)isShortcutUp:(CGPoint)point;
@end

#define SCREEN ([UIScreen mainScreen].bounds)
@implementation ShortcutCalculator
+ (NSInteger)maxShortcutForAssumedWidthAtPoint:(CGPoint)point {
    NSInteger shortcutHeight = 65;
    NSInteger currentY = point.y;
    BOOL isUp = NO;
    if (currentY < SCREEN.size.height/2) {
        isUp = YES;
    }
    
    if (isUp == YES) {
        NSInteger sizeToTop = currentY;
        return sizeToTop/shortcutHeight;
    } else {
        NSInteger sizeToBottom = SCREEN.size.height - currentY;
        return sizeToBottom/shortcutHeight;
    }
}
+ (NSInteger)maxShortcutForWidth:(NSInteger)width atPoint:(CGPoint)point {
    NSInteger shortcutHeight = width;
    NSInteger currentY = point.y;
    BOOL isUp = YES;
    if (currentY < SCREEN.size.height/2+20) {
        isUp = NO;
    }
    
    if (isUp == YES) {
        NSInteger sizeToTop = currentY - width/2 - width/4;
        return sizeToTop/shortcutHeight;
        //return floor(final);
    } else {
        NSInteger sizeToBottom = SCREEN.size.height - currentY - width/2 - width/4;
        return sizeToBottom/shortcutHeight;
        // return floor(final);
    }
}
+ (BOOL)isShortcutUp:(CGPoint)point {
    NSInteger currentY = point.y;
    BOOL isUp = NO;
    if (currentY < SCREEN.size.height/2-20) {
        isUp = YES;
    }
    return isUp;
}
@end

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

void runOnMainQueueWithoutDeadlocking(void (^block)(void))
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

BOOL hasIncreasedByPercent(float percent, float value1, float value2) {

    if (value1 <= 0 || value2 <= 0)
        return NO;
    if (value1 >= value2 + (value2 / percent))
        return YES;
    return NO;
}

void hapticVibe(){
        NSMutableDictionary* VibrationDictionary = [NSMutableDictionary dictionary];
        NSMutableArray* VibrationArray = [NSMutableArray array ];
        [VibrationArray addObject:[NSNumber numberWithBool:YES]];
        [VibrationArray addObject:[NSNumber numberWithInt:30]]; //vibrate for 50ms
        [VibrationDictionary setObject:VibrationArray forKey:@"VibePattern"];
        [VibrationDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
        AudioServicesPlaySystemSoundWithVibration(4095,nil,VibrationDictionary);
}

static CGFloat lastRadius;
static CGFloat lastDensity;
static CGFloat lastQuality;
static int lastX;
static int lastY;
static CGFloat Radius;
static CGFloat Density;
static CGFloat Quality;
static int X;
static int Y;
/*static CGFloat PPlastRadius;
static CGFloat PPlastDensity;
static CGFloat PPlastQuality;
static int PPlastX;
static int PPlastY;
static CGFloat PPRadius;
static CGFloat PPDensity;
static CGFloat PPQuality;
static int PPX;
static int PPY; */
static BOOL MenuOpen;
static int HardPress;
static BOOL AllowedtoOpen;
static BOOL PreviewOpen;
CGPoint touchPoint;
static long long selectedShortcutIndex;
static NSInteger universalShortcutItemHeight;
static BOOL ShortcutItemHeightGrabbed;
static NSInteger maxNumberOfShortcuts;
// static CGFloat lastHighRadius;
CMMotionManager* motionForceManager;
SBIconView* touchedIcon;
SBSApplicationShortcutItem* selectedShortcutItem;
UIPreviewInteractionController* currentPreview;

static BOOL kAllEnabed;
static BOOL kHomeEnabled;
static BOOL kPeekPopEnabled;
static NSInteger kPeekPopForceSensitivity;
static NSInteger kHomeScreenForceSensitivity;

%hook NSString
%new
- (NSString*) stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;   
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
           targetRange.length = endRange.location - targetRange.location;
           return [self substringWithRange:targetRange];
        }
    }
    return nil;
}
%end

@interface ForceGestureRecognizer : UILongPressGestureRecognizer
@end

@implementation ForceGestureRecognizer
- (id)initWithTarget:(id)target action:(SEL)action{
    if ((self = [super initWithTarget:target action:action])){
        // so simple there's no setup
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    Radius = [touch getRadius];
	X = [touch getX];
	Y = [touch getY];
	Density = [touch getDensity];
	Quality = [touch getQuality];
	//touchPoint = CGPointMake( X, Y);
	/* if ([touch _pathMajorRadius] > 40) {
		self.state = UIGestureRecognizerStateBegan;
		MenuOpen = YES;
	} */
	if (hasIncreasedByPercent(kHomeScreenForceSensitivity, Density, lastDensity) && hasIncreasedByPercent(kHomeScreenForceSensitivity, Radius, lastRadius) && hasIncreasedByPercent(5, Quality, lastQuality)) {
		self.state = UIGestureRecognizerStateBegan;
    //self.cancelsTouchesInView = YES;
		NSLog(@"Begin Complete");
		MenuOpen = YES;
	}
	if ([touch _pathMajorRadius] > kPeekPopForceSensitivity) {
		self.state = UIGestureRecognizerStateBegan;
    //self.cancelsTouchesInView = YES;
		NSLog(@"Begin Complete");
		MenuOpen = YES;
	}
	lastRadius = Radius;
	lastX = X;
	lastY = Y;
	lastDensity = Density;
	lastQuality = Quality;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
   	Radius = [touch getRadius];
	X = [touch getX];
	Y = [touch getY];
	Density = [touch getDensity];
	Quality = [touch getQuality];
	//touchPoint = CGPointMake( X, Y);
	if (MenuOpen == NO) {
		if ((lastX - [touch getX] >= 10 || lastX - [touch getX] <= -10) || (lastY - [touch getY] >= 10 || lastY - [touch getY] <= -10)) {
			self.state = UIGestureRecognizerStateFailed;
		 	NSLog(@"Too Much Movement");
     	}
	}
	if (self.state == UIGestureRecognizerStatePossible) { 
		if (hasIncreasedByPercent(kHomeScreenForceSensitivity, Density, lastDensity) && hasIncreasedByPercent(kHomeScreenForceSensitivity, Radius, lastRadius) && hasIncreasedByPercent(5, Quality, lastQuality)) {
			self.state = UIGestureRecognizerStateBegan;
      // self.cancelsTouchesInView = YES;
			MenuOpen = YES;
		}
	}
	if (self.state == UIGestureRecognizerStateChanged) {
		if (hasIncreasedByPercent(kHomeScreenForceSensitivity, Density, lastDensity) && hasIncreasedByPercent(kHomeScreenForceSensitivity, Radius, lastRadius) && hasIncreasedByPercent(5, Quality, lastQuality)) {
			touchPoint = CGPointMake( X, Y);
			// self.state = UIGestureRecognizerStateEnded;
		}
		else {
			self.state = UIGestureRecognizerStateChanged;
      //self.state = UIGestureRecognizerStateEnded;
		}
	}
	lastRadius = Radius;
	lastX = X;
	lastY = Y;
	lastDensity = Density;
	lastQuality = Quality;
	touchPoint = CGPointMake( X, Y);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateEnded;
    MenuOpen = NO;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateCancelled;
}

-(void)reset{
    // so simple there's no resets
}
@end
// %group EverythingElse
%hook _UITouchForceMessage
- (void)setUnclampedTouchForce:(CGFloat)touchForce {
if (kPeekPopEnabled) {
	if (HardPress == 3) {
		if (sizeof(void*) == 4) {
      %orig((float) 200);
    }
    else if (sizeof(void*) == 8) {
      %orig((double) 200);
    }
	}
	if (HardPress == 2) {
		if (sizeof(void*) == 4) {
      %orig((float) 20);
    } 
    else if (sizeof(void*) == 8) {
      %orig((double) 20);
    }
	}
	if (HardPress == 1) {
		if (sizeof(void*) == 4) {
      %orig((float) 0);
    } 
    else if (sizeof(void*) == 8) {
      %orig((double) 0);
    }
	}
}
else {
  %orig;
}
}
%end
/* %hook UIKeyboardLayoutStar
- (void)installGestureRecognizers {
	%orig;
	[[%c(_UIKeyboardTextSelectionGestureController) sharedInstance] addOneFingerForcePressRecognizerToView: self];
	[[%c(_UIKeyboardTextSelectionGestureController) sharedInstance] configureOneFingerForcePressRecognizer: [self.gestureRecognizers objectAtIndex:0]];
} 
%end
%hook _UIKeyboardTextSelectionGestureController
- (void)oneFingerForcePan:(id)arg1 {
	%orig;
	NSLog(@"Gestures TrackPad: %@", arg1);
}
%end
%hook _UITextSelectionForceGesture
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

	self.cancelsTouchesInView = YES;
	//self.state = UIGestureRecognizerStateBegan;
    UITouch *touch = [touches anyObject];
    Radius = [touch getRadius];
	X = [touch getX];
	Y = [touch getY];
	Density = [touch getDensity];
	Quality = [touch getQuality];
	//touchPoint = CGPointMake( X, Y);
	/* if ([touch _pathMajorRadius] > 40) {
		self.state = UIGestureRecognizerStateBegan;
		MenuOpen = YES;
	} 
	if (hasIncreasedByPercent(10, Density, lastDensity) && hasIncreasedByPercent(10, Radius, lastRadius) && hasIncreasedByPercent(5, Quality, lastQuality)) {
		%orig;
    self.state = UIGestureRecognizerStateBegan;
		NSLog(@"Begin Complete");
	}
	if ([touch _pathMajorRadius] > 43) {
    %orig;
		self.state = UIGestureRecognizerStateBegan;
		NSLog(@"Begin Complete");
	}
	lastRadius = Radius;
	lastX = X;
	lastY = Y;
	lastDensity = Density;
	lastQuality = Quality;
} */

/*-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	%orig;
	UITouch *touch = [touches anyObject];
   	Radius = [touch getRadius];
	X = [touch getX];
	Y = [touch getY];
	Density = [touch getDensity];
	Quality = [touch getQuality];
	//touchPoint = CGPointMake( X, Y);
	//if (MenuOpen == NO) {
		//if ((lastX - [touch getX] >= 10 || lastX - [touch getX] <= -10) || (lastY - [touch getY] >= 10 || lastY - [touch getY] <= -10)) {
		//	self.state = UIGestureRecognizerStateFailed;
		 //	NSLog(@"Too Much Movement");
     	//}
	//}
	if (self.state == UIGestureRecognizerStatePossible) { 
		if (hasIncreasedByPercent(15, Density, lastDensity) && hasIncreasedByPercent(15, Radius, lastRadius) && hasIncreasedByPercent(5, Quality, lastQuality)) {
			self.state = UIGestureRecognizerStateBegan;
			//MenuOpen = YES;
		}
	}
	if (self.state == UIGestureRecognizerStateChanged) {
		
			self.state = UIGestureRecognizerStateChanged;
	}
	lastRadius = Radius;
	lastX = X;
	lastY = Y;
	lastDensity = Density;
	lastQuality = Quality;
	touchPoint = CGPointMake( X, Y);
}*/
/* -(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateCancelled;
    %orig;
    self.enabled = NO;
    [[%c(_UIKeyboardTextSelectionGestureController) sharedInstance] addOneFingerForcePressRecognizerToView: self.view];
} */
/* -(BOOL)_shouldDelayUntilForceLevelRequirementIsMet {
	return NO;
}
-(BOOL)shouldFailWithoutForce {
	return NO;
} */
/*-(void)setRequiredPreviewForceState:(long long)arg1 {
	%orig(0);
}*/
//%end
// %end
@interface CKConversationListCell : UITableViewCell
- (void)layoutSubviews;
@end
@interface CKConversationListController : UITableViewController
- (id)registerForPreviewingWithDelegate:(id)arg1 sourceView:(id)arg2;
@property (nonatomic, strong) id previewingContext;
@end
%hook CKConversationListController
- (void)viewDidLoad {
  %orig;
       [self registerForPreviewingWithDelegate:self 
                                    sourceView:self.tableView];
 }
 %end
 %hook CKConversationListCell
 - (void)layoutSubviews {
  %orig;
  while (self.gestureRecognizers.count) {
        [self removeGestureRecognizer:[self.gestureRecognizers objectAtIndex:0]];
    }

 }
 %end
%hook UIPreviewInteractionController
-(id)init {
	currentPreview = %orig;
	PreviewOpen = YES;
	return %orig;
}
%end
%hook UITouch
 - (void)setMajorRadius:(float)arg1 {
  if (![[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
 	  NSInteger lightPress = kPeekPopForceSensitivity;

	// NSLog(@"View: %@", self.view.gestureRecognizers);
	  if (![self.view isKindOfClass:[NSClassFromString(@"SBIconView") class]]) {
	    if ([self _pathMajorRadius] > lightPress) {
		    HardPress = 2;
      }
	    if ([self _pathMajorRadius] > lightPress + lightPress /2) {
		    HardPress = 3;
	    }
	    if ([self _pathMajorRadius] < lightPress) {
		    HardPress = 1;
		  }
	    %orig;
    }
  }
  else {
    %orig;
  }
}

%new
- (CGFloat)getQuality {
	return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Quality:" andString:@"Density:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}

%new
- (CGFloat)getDensity {
	return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Density:" andString:@"Irregularity:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];	
}

%new
- (CGFloat)getRadius {
	return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"MajorRadius:" andString:@"MinorRadius:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}

%new
- (int)getX {
return [[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"X:" andString:@"Y:"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
}

%new
- (int)getY {
	return [[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Y:" andString:@"Z:"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
}

%end

%hook UIScreen
- (long long)_forceTouchCapability {
  PeekPopEnabled = YES;
  HomeEnabled = YES;
return 2;
}
%end

%hook UIDevice
- (BOOL)_supportsForceTouch {
	return TRUE;
}
%end
%group SpringBoard
%hook UITouch
 - (void)setMajorRadius:(float)arg1 {
  %orig;
  HardPress = 1;
}

%end

%hook SBApplicationShortcutServer
- (id)_sanitizeShortcutItems:(id)arg1 entitlements:(unsigned long long)arg2 {
	return arg1;
}

%end /*
%hook _UITouchForceMessage
- (void)setUnclampedTouchForce:(CGFloat)touchForce {
	if (HardPress == 3) {
		if (sizeof(void*) == 4) {
    		%orig((float) 0);
    	} 
    	else if (sizeof(void*) == 8) {
   			%orig((double) 0);
		}
	}
	if (HardPress == 2) {
		if (sizeof(void*) == 4) {
    		%orig((float) 0);
		}
 		else if (sizeof(void*) == 8) {
   			%orig((double) 0);
   		}
	}
	if (HardPress == 1) {
		if (sizeof(void*) == 4) {
    		%orig((float) 0);
		}
 		else if (sizeof(void*) == 8) {
   			%orig((double) 0);
		}
	}
}  
%end */
%hook SBApplicationShortcutMenuContentView
- (void)updateSelectionFromPressGestureRecognizer:(UIGestureRecognizer *)gesture {
	%orig;
  if (kHomeEnabled) {
	  NSMutableArray *itemViews = MSHookIvar<NSMutableArray *>(self,"_itemViews");
	  NSUInteger count = [itemViews count];
	  for (NSUInteger i = 0; i < count; i++) {
    	SBApplicationShortcutMenuItemView *currentItemView = [itemViews objectAtIndex: i];
		  CGPoint locationInView = [currentItemView convertPoint:touchPoint fromView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]];
		    if ( CGRectContainsPoint(currentItemView.bounds, locationInView) ) {
    		  if (gesture.state == UIGestureRecognizerStateChanged) {
    		    [currentItemView setHighlighted: YES];
        	  selectedShortcutItem = currentItemView.shortcutItem;
        	  selectedShortcutIndex = currentItemView.menuPosition;
    		  }
		    }
		    else {
			    [currentItemView setHighlighted: NO];
		    }
	    }
    }
  }
%end

%hook SBApplicationShortcutMenu
- (id)_shortcutItemsToDisplay {
  if (self.application == nil) {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.bolencki13.appendix.list"]) {
      return %orig;
    }
    else {
    NSMutableArray *aryItems = [NSMutableArray new];
      for (int x = 0; x < maxNumberOfShortcuts; x++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:x inSection:0];
        NSString *bundleID = [[[self iconView].folderIcon.folder iconAtIndexPath:indexPath] leafIdentifier];
        UIImage *icon1 = [[[self iconView].folderIcon.folder iconAtIndexPath:indexPath] generateIconImage:2];
        if (icon1 == nil) {
          break;
        }
        //NSString *folderName = @"Jailbreak";
  
        SBSApplicationShortcutItem *action = [[%c(SBSApplicationShortcutItem) alloc] init];
        [action setIcon:[[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:UIImagePNGRepresentation(icon1)]];
        NSString *appName = [[[self iconView].folderIcon.folder iconAtIndexPath:indexPath] displayNameForLocation:1];
        [action setLocalizedTitle:appName];
        if ([[self iconView].folderIcon.folder iconAtIndexPath:indexPath].application == nil) {
          // [action setType:@"UniversalForce_Web"];
          NSMutableDictionary* userInfoData = [NSMutableDictionary new];
          [userInfoData setObject: bundleID forKey:@"webID"];
          [action setBundleIdentifierToLaunch:[NSString stringWithFormat:@"com.apple.webapp.%@", bundleID]];
          [action setUserInfo:userInfoData];
        }
        else {
          [action setType:@"UniversalForce"];
          [action setBundleIdentifierToLaunch:bundleID];
        }

        [aryItems addObject:action];
      }
    return aryItems;
    }
  }
  else {
	  NSMutableArray *ShortcutItemsArray = [[NSMutableArray alloc] init];
	  [ShortcutItemsArray addObjectsFromArray:self.application.staticShortcutItems];
	  [ShortcutItemsArray addObjectsFromArray:self.application.dynamicShortcutItems];
	  NSMutableArray *ShortcutItemsArrayFix = [[NSMutableArray alloc] init];
	  for (id obj in ShortcutItemsArray) {
      if (![ShortcutItemsArrayFix containsObject:obj]) {
          [ShortcutItemsArrayFix addObject:obj];
      }
	  }
	  NSLog(@"Shortcuts: %@", ShortcutItemsArrayFix);
	  NSUInteger itemsAvailible = [ShortcutItemsArrayFix count];
	  NSMutableArray *FinalShortcutItemsArray = [[NSMutableArray alloc] init];
	  for (NSUInteger i = 0; i < itemsAvailible && i < maxNumberOfShortcuts; i++) {
	 	  [FinalShortcutItemsArray addObject:[ShortcutItemsArrayFix objectAtIndex: i]];
	  }
	return [FinalShortcutItemsArray copy];
  }
}
- (void)updateFromPressGestureRecognizer:(UIGestureRecognizer *)gesture {
	%orig;
  if (kHomeEnabled) {
	  if (gesture.state == UIGestureRecognizerStateEnded) {
		  [self dismissAnimated: YES completionHandler: nil];
	  }
  }
}
/* -(void) _peekWithContentFraction:(double)arg1 smoothedBlurFraction:(double) arg2 {
  if (kHomeEnabled) {
    %orig(5, 1);
  }
  else {
    %orig;
  }
}*/
- (void)menuContentView:(id)arg1 activateShortcutItem:(UIApplicationShortcutItem*)arg2 index:(long long)arg3 {
  if (kHomeEnabled) {
    NSString *input = arg2.type;
    if ([input isEqualToString:@"UniversalForce_Web"]) {
    //NSDictionary *userInfo = arg2.userInfo;
    //NSString *urlString = [NSString stringWithFormat:@"webapp:%@", [userInfo valueForKey:@"webID"]];
    //[[UIApplication sharedApplication] applicationOpenURL:[NSURL URLWithString:urlString]];
      NSLog(@"Web Shortcut");
    }
    else {
      %orig;
    }
  }
  else %orig;
}
%end
%hook SBIconController

%new
-(id)chats {
  dlopen("/System/Library/PrivateFrameworks/IMDaemonCore.framework/IMDaemonCore", 2);
  IMDChatRegistry *chatStore = [%c(IMDChatRegistry) sharedInstance];
  //[chatStore run];
 // runOnMainQueueWithoutDeadlocking(^{
    //[chatStore loadChatsWithCompletionBlock:nil];
//});
        return chatStore;
}
%new
- (void)_handleUFShortcutMenuPeek:(UILongPressGestureRecognizer *)gesture {
	if (![self isEditing]) {
      if ([gesture.view class] == [%c(SBFolderIconView) class]) {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
          AllowedtoOpen = YES;
      if (ShortcutItemHeightGrabbed) {

      }
      else {
        SBApplicationShortcutMenuContentView *heightHelper = [[%c(SBApplicationShortcutMenuContentView) alloc] init];
        universalShortcutItemHeight = [heightHelper _rowHeight];
        ShortcutItemHeightGrabbed = YES;
      }
      CGPoint relativePoint = [gesture.view.superview convertPoint:gesture.view.center toView:nil];
      maxNumberOfShortcuts = [ShortcutCalculator maxShortcutForWidth:universalShortcutItemHeight atPoint:relativePoint];
        self.presentedShortcutMenu = [[%c(SBApplicationShortcutMenu) alloc] initWithFrame:[UIScreen mainScreen].bounds application:nil iconView:gesture.view interactionProgress:nil orientation:1];
            self.presentedShortcutMenu.applicationShortcutMenuDelegate = self;
            UIViewController *rootView = [[UIApplication sharedApplication].keyWindow rootViewController];
            [rootView.view addSubview:self.presentedShortcutMenu];
       NSLog(@"Max Number of Shortcuts %ld",  (long)maxNumberOfShortcuts);

            [self.presentedShortcutMenu presentAnimated:YES];
            hapticVibe();
        [self.presentedShortcutMenu updateFromPressGestureRecognizer: gesture];
            [self applicationShortcutMenuDidPresent:self.presentedShortcutMenu];

          }break;

          case UIGestureRecognizerStateChanged: {
            if (self.presentedShortcutMenu) {
        [self.presentedShortcutMenu updateFromPressGestureRecognizer: gesture];
      }

          }break;
        default:
            break;
    }

  }
 		if (gesture.state == UIGestureRecognizerStateBegan) {
 			AllowedtoOpen = YES;
 			if (ShortcutItemHeightGrabbed) {

 			}
 			else {
 				SBApplicationShortcutMenuContentView *heightHelper = [[%c(SBApplicationShortcutMenuContentView) alloc] init];
 				universalShortcutItemHeight = [heightHelper _rowHeight];
 				ShortcutItemHeightGrabbed = YES;
 			}
 			CGPoint relativePoint = [gesture.view.superview convertPoint:gesture.view.center toView:nil];
 			maxNumberOfShortcuts = [ShortcutCalculator maxShortcutForWidth:universalShortcutItemHeight atPoint:relativePoint];
 			 NSLog(@"Max Number of Shortcuts %ld",  (long)maxNumberOfShortcuts);
 			[self _revealMenuForIconView: gesture.view presentImmediately: TRUE];
 			hapticVibe();
    		[self.presentedShortcutMenu updateFromPressGestureRecognizer: gesture];
        [self applicationShortcutMenuDidPresent:self.presentedShortcutMenu];
 		}
 		else if (gesture.state == UIGestureRecognizerStateChanged) {
 			if (self.presentedShortcutMenu) {
 				[self.presentedShortcutMenu updateFromPressGestureRecognizer: gesture];
 			}
 		}
 		else if (gesture.state == UIGestureRecognizerStateEnded) {
 			if (self.presentedShortcutMenu) {
 				// [self.presentedShortcutMenu updateFromPressGestureRecognizer: gesture];
 				SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(self.presentedShortcutMenu,"_contentView");
 				if (contentView) {
            NSMutableArray *itemViews = MSHookIvar<NSMutableArray *>(contentView,"_itemViews");
            for(SBApplicationShortcutMenuItemView *item in itemViews) {
              if (item.highlighted == YES) {
                [self.presentedShortcutMenu menuContentView:contentView activateShortcutItem:item.shortcutItem index:item.menuPosition];
                break;
              }
            }
            [self.presentedShortcutMenu updateFromPressGestureRecognizer: gesture];
				}
				//[self.presentedShortcutMenu dismissAnimated: YES completionHandler: nil];
				AllowedtoOpen = NO;
				selectedShortcutItem = nil;
				selectedShortcutIndex = nil;

			}
		}
	}
}
/* -(void)applicationShortcutMenu:(id)arg1 startEditingForIconView:(id)arg2 {
	if (allowEditing){
		%orig;
	}
	else {
		return;
	}
} */
- (void)_revealMenuForIconView:(id)iconView presentImmediately:(BOOL)now {
  if (kHomeEnabled) {
	  if (AllowedtoOpen) {
		  %orig(iconView, YES);
	  }
  }
  else {
    %orig;
  }
}
%end

%hook SBIconView
/*- (void)layoutSubviews {
	%orig;
		NSMutableArray *gestures = MSHookIvar<id>(self,"_gestureRecognizers");
		id byebyegesture = MSHookIvar<id>(self,"_shortcutMenuPeekGesture");
		if ([gestures containsObject:byebyegesture] && Butt == NO) {
			[gestures removeObjectAtIndex:[gestures indexOfObject:byebyegesture]];
			BOOL Butt = YES;
		}
} */
- (id)initWithContentType:(unsigned long long)arg1 {
  if (kHomeEnabled) {
	  SBIconController *sbIconC = [objc_getClass("SBIconController") sharedInstance];
	  UILongPressGestureRecognizer *shortcutMenuPeekGesture = MSHookIvar<UILongPressGestureRecognizer *>(self, "_shortcutMenuPeekGesture");
	  shortcutMenuPeekGesture = [[ForceGestureRecognizer alloc] initWithTarget:sbIconC action:@selector(_handleUFShortcutMenuPeek:)];
	  shortcutMenuPeekGesture.cancelsTouchesInView = NO;
	  [self addGestureRecognizer:shortcutMenuPeekGesture];
  }
	return %orig;
}

- (void)setIsEditing:(BOOL)arg1 {
	%orig;
  if (kHomeEnabled) {
	  NSMutableArray *gestures = MSHookIvar<id>(self,"_gestureRecognizers");
	  NSMutableArray *objects = [gestures findObjectsOfClass:[NSClassFromString(@"ForceGestureRecognizer") class]];
	  UIGestureRecognizer *forceRecognizer = [objects objectAtIndex:0];
	  if (arg1 == TRUE) {
		  forceRecognizer.enabled = NO;
	  }
	  else {
		  forceRecognizer.enabled = YES;
	  }
  }
}

- (void)setIsEditing:(BOOL)arg1 animated:(BOOL)arg2 {
	%orig;
  if (kHomeEnabled) {
	  NSMutableArray *gestures = MSHookIvar<id>(self,"_gestureRecognizers");
	  NSMutableArray *objects = [gestures findObjectsOfClass:[NSClassFromString(@"ForceGestureRecognizer") class]];
	  UIGestureRecognizer *forceRecognizer = [objects objectAtIndex:0];
	  if (arg1 == TRUE) {
		  forceRecognizer.enabled = NO;
	  }
	  else {
		  forceRecognizer.enabled = YES;
	  }
  }
}


/* - (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 

   UITouch *touch = [[event allTouches] anyObject];
    if (forcePress) {
    if ([self.delegate isKindOfClass:[NSClassFromString(@"STKGroupController") class]]) {
        		id groupController = [self delegate];
        		id selfGroup = MSHookIvar<id>(groupController,"_openingGroupView");
        		[selfGroup performSelector:@selector(close)];
        	}      		
        			NSLog(@"Universal Force: Opening Quick Action Menu");
					SBIconController *iconController = [%c(SBIconController) sharedInstance];
					[iconController _revealMenuForIconView: self presentImmediately:TRUE];
					[self cancelLongPressTimer];
				}
	Radius = [touch getRadius];
	X = [touch getX];
	Y = [touch getY];
	Density = [touch getDensity];
	Quality = [touch getQuality];
	if (hasIncreasedByPercent(15, Density, lastDensity) && hasIncreasedByPercent(15, Radius, lastRadius) && hasIncreasedByPercent(5, Quality, lastQuality)) {
        		if ([self.delegate isKindOfClass:[NSClassFromString(@"STKGroupController") class]]) {
        		id groupController = [self delegate];
        		id selfGroup = MSHookIvar<id>(groupController,"_openingGroupView");
        		[selfGroup performSelector:@selector(close)];
        	}
        		NSLog(@"Universal Force: We Force Pressed");
					SBIconController *iconController = [%c(SBIconController) sharedInstance];
					[iconController _revealMenuForIconView: self presentImmediately:TRUE];
					[self cancelLongPressTimer];
					allowEditing = NO;
   	}
   	lastRadius = [touch getRadius];
	lastX = [touch getX];
	lastY = [touch getY];
	lastDensity = [touch getDensity];
	lastQuality = [touch getQuality];
	%orig;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	   UITouch *touch = [[event allTouches] anyObject];
	Radius = [touch getRadius];
	X = [touch getX];
	Y = [touch getY];
	Density = [touch getDensity];
	Quality = [touch getQuality];
	if ((lastX - [touch getX] >= 3 || lastX - [touch getX] <= -3) || (lastY - [touch getY] >= 3 || lastY - [touch getY] <= -3)) {
    }
	else {
		if (hasIncreasedByPercent(15, Density, lastDensity) && hasIncreasedByPercent(15, Radius, lastRadius) && hasIncreasedByPercent(5, Quality, lastQuality)) {
        	if ([self.delegate isKindOfClass:[NSClassFromString(@"STKGroupController") class]]) {
        		id groupController = [self delegate];
        		id selfGroup = MSHookIvar<id>(groupController,"_openingGroupView");
        		[selfGroup performSelector:@selector(close)];
        	}
			SBIconController *iconController = [%c(SBIconController) sharedInstance];
			[iconController _revealMenuForIconView: self presentImmediately:TRUE];
			[self cancelLongPressTimer];
			allowEditing = NO;
		}
   	else {
   		if ([touch _pathMajorRadius] > 28) {
   			if ([self.delegate isKindOfClass:[NSClassFromString(@"STKGroupController") class]]) {
        		id groupController = [self delegate];
        		id selfGroup = MSHookIvar<id>(groupController,"_openingGroupView");
        		[selfGroup performSelector:@selector(close)];
        	}      		
        			NSLog(@"Universal Force: Opening Quick Action Menu");
					SBIconController *iconController = [%c(SBIconController) sharedInstance];
					[iconController _revealMenuForIconView: self presentImmediately:TRUE];
					[self cancelLongPressTimer];
				}
		if (lastHighRadius < [touch _pathMajorRadius]) {
			if ([self.delegate isKindOfClass:[NSClassFromString(@"STKGroupController") class]]) {
        		id groupController = [self delegate];
        		id selfGroup = MSHookIvar<id>(groupController,"_openingGroupView");
        		[selfGroup performSelector:@selector(close)];
        	}
			NSLog(@"Universal Force: Opening Quick Action Menu");
					SBIconController *iconController = [%c(SBIconController) sharedInstance];
					[iconController _revealMenuForIconView: self presentImmediately:TRUE];
					[self cancelLongPressTimer];
			}
			if (forcePress) {
				if ([self.delegate isKindOfClass:[NSClassFromString(@"STKGroupController") class]]) {
        		id groupController = [self delegate];
        		id selfGroup = MSHookIvar<id>(groupController,"_openingGroupView");
        		[selfGroup performSelector:@selector(close)];
        	}
				NSLog(@"Universal Force: Opening Quick Action Menu");
					SBIconController *iconController = [%c(SBIconController) sharedInstance];
					[iconController _revealMenuForIconView: self presentImmediately:TRUE];
					[self cancelLongPressTimer];
				}	allowEditing = NO;

   	}
   }
    lastHighRadius = [touch _pathMajorRadius];
   	lastRadius = [touch getRadius];
	lastX = [touch getX];
	lastY = [touch getY];
	lastDensity = [touch getDensity];
	lastQuality = [touch getQuality];
	%orig;
	}
*/
/* - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [self hitTest:point withEvent:event];

    SBIconController *iconController = [%c(SBIconController) sharedInstance];
	UIView *menu = [iconController presentedShortcutMenu];
    if (hitView == self) {
    	if (menu)
        return menu;
        else return hitView;
    }
    // Else return the hitView (as it coalpineuld be one of this view's buttons):
    return hitView;
}*/
/* -(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	SBIconController *iconController = [%c(SBIconController) sharedInstance];
	id menu = [iconController presentedShortcutMenu];
    if (!menu){
        return YES;
    }else{
        return NO;
    }
} */
/* - (void)_handleFirstHalfLongPressTimer:(id)timer {
	if (self.isEditing) {
		%orig;
	}
} */

/*
- (BOOL)gesturesEnabled {
	return NO;
}
-(BOOL)canHandleGestures {
	return NO;
} */

%end

%hook SBApplicationShortcutMenuItemView
- (void)icon:(id)arg1 touchMoved:(id)arg2 {
	%orig;
	NSLog(@"Icon: %@ Moved: %@", arg1, arg2);
}
- (void)iconTouchBegan:(id)arg1 {
	%orig;
	NSLog(@"Touch began: %@", arg1);
}
%end
%end

%group TouchSettings
%hook AXForceTouchController
- (void)loadView {
	%orig;
	self.view.center = CGPointMake(self.view.center.x,self.view.center.y + 44);
}
-(void)viewWillAppear:(BOOL)arg1 {
	%orig;
	self.view.center = CGPointMake(self.view.center.x,self.view.center.y + 44);
}
- (id)navigationController {
	return [[self.view superview] delegate].navigationController;
}
%new
-(void)asshole {

}
%end
%end
%group Messages
CKSpringBoardActionManager* messagesActionManager;
%hook SMSApplication
- (BOOL)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
	%orig;
	messagesActionManager = [[[NSClassFromString(@"CKSpringBoardActionManager") class] alloc] init];
	return %orig;
}
- (void)_chatItemsDidChange:(id)arg1 {
	%orig;
	[messagesActionManager updateShortcutItems];
}
%end
%end

@interface DCIMImageWellUtilities : NSObject
+ (id)cameraPreviewWellImage;
+ (id)cameraPreviewWellImageFileURL;
@end

@interface PLQuickActionManager : NSObject
+ (instancetype)sharedManager;
-(void)_setCachedMostRecentPhotoData:(id)arg1;
- (id)_buildMostRecentPhotoQuickAction;
@end

%hook PLQuickActionManager
-(void)_setCachedMostRecentPhotoData:(id)arg1 {
	NSURL *lastImageURL = [%c(DCIMImageWellUtilities) cameraPreviewWellImageFileURL];
	NSData *imageData = [[NSData alloc] initWithContentsOfURL:lastImageURL];
	%orig(imageData);
}
%new
- (void)updateItems {
	NSMutableArray *items = [[NSMutableArray alloc] init];
	[self _setCachedMostRecentPhotoData:nil];
	[items addObject: [self _buildMostRecentPhotoQuickAction]];
	[UIApplication sharedApplication].shortcutItems = items;
}
%end

%hook PhotosApplication
%new
- (void)updateItems {
	NSMutableArray *items = [[NSMutableArray alloc] init];
	PLQuickActionManager *Manager = [%c(PLQuickActionManager) sharedManager];
	[Manager _setCachedMostRecentPhotoData:nil];
	[items addObject: [Manager _buildMostRecentPhotoQuickAction]];
	[UIApplication sharedApplication].shortcutItems = items;
}
%end

%group Hangouts

NSArray* RecentConversationsDataSource;
NSMutableArray* ConversationsInstances;
GBMConversationSyncer* ConversationsLookUp;
GBAConversationListViewController* ConversationListController;

@interface GBMConversationsStore : NSObject
@end

@interface GBMConversationSyncer : NSObject
@end

@interface GBMUserClient : NSObject
@property(retain, nonatomic) GBMConversationSyncer *conversationsClient;
@end

@interface GBMAvatar : NSObject
- (id)cachedAvatarForType:(int)type;
@end

@interface GBMConversation : NSObject
- (NSString*)displayName;
- (NSMutableArray*)participantPersons;
@end

@interface GPCPerson : NSObject
- (GBMAvatar *)avatar;
@end

@interface GBAConversationListViewController : UIViewController
-(NSArray*)conversations;
@end

@interface GBAApplicationDelegate : NSObject
- (void)navigateToConversation:(id)arg1 userInfo:(id)arg2;
- (void)navigateToCompose:(id)arg1 groupChat:(int)arg2 withEntities:(id)arg3;
- (void)updateDynamicQuickActions:(NSArray*)recentConversations;
+ (id)sharedDelegate;
- (NSMutableArray*)conversations;
- (void)setupNewViewControllers;
- (GBMUserClient *)savedUserClient;
@end
%hook GBAApplicationDelegate
%new
- (NSMutableArray *)conversations {
	GBMConversationSyncer *conversationsListPartOne = [self savedUserClient].conversationsClient;
	GBMConversationsStore *ConversationsStore = MSHookIvar<id>(conversationsListPartOne,"_conversationsStore");
	NSMutableOrderedSet *ConversationSetPartTwo = MSHookIvar<id>(ConversationsStore,"_conversationsKeepAliveLRUCache");
	NSArray *FinalConversationsStoreArray = [ConversationSetPartTwo array];
	NSMutableArray *Final = [FinalConversationsStoreArray mutableCopy]; 
	return Final;
}
%new
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
	if ([shortcutItem.type isEqualToString:@"com.google.hangouts.newchat"]) {
		[self navigateToCompose:nil groupChat:nil withEntities:nil];
	}
	if ([shortcutItem.type isEqualToString:@"com.google.hangouts.conversation"]) {
		NSDictionary *userInfo = shortcutItem.userInfo;
		NSString *DisplayName = [NSString stringWithFormat:@"%@", [userInfo valueForKey:@"Conversation_Name"]];
		NSMutableArray *ConversationsArray = [self conversations];
		NSUInteger count = [ConversationsArray count];
		for (NSUInteger i = 0; i < count; i++) {
			GBMConversation *conversation = [ConversationsArray objectAtIndex: i];
			if ([[conversation displayName] isEqualToString: DisplayName]) {
				[self navigateToConversation: conversation userInfo:nil];
			}
		}
		[self setupNewViewControllers];
		NSLog(@"Conversations: %@", ConversationListController);

	}
    NSLog(@"%@-%@-%@", shortcutItem.type, shortcutItem.localizedTitle, shortcutItem.localizedSubtitle);
    
    completionHandler(YES);
}
%new
-(void)updateDynamicQuickActions:(NSArray*)recentConversations {
    NSMutableArray* shortcutItems = [[NSMutableArray alloc] init];
    UIApplicationShortcutIcon *newChatShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeCompose]];
	//UIApplicationShortcutIcon *newChatShortcutIcon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType: UIApplicationShortcutIconTypeCompose];
	UIApplicationShortcutItem *NewChat = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.google.hangouts.newchat" localizedTitle:@"New Chat" localizedSubtitle: nil icon:newChatShortcutIcon userInfo:nil];
	[shortcutItems addObject: NewChat];
    NSUInteger count = [recentConversations count];
	for (NSUInteger i = 0; i < count; i++) {
	 	if ([[recentConversations objectAtIndex: i] isKindOfClass:[NSClassFromString(@"GBMConversation") class]]) {
			GBMConversation *conversation = [recentConversations objectAtIndex: i];
			GPCPerson *conversationContact = [[conversation participantPersons] objectAtIndex: 0];
			GBMAvatar *conversationContactAvatar = [conversationContact avatar];
			UIImage *conversationContactAvatarImage = [conversationContactAvatar cachedAvatarForType: 0];
			NSArray *FirstLastArray = [[conversation displayName] componentsSeparatedByString:@" "];
			NSString *FirstName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 0]];
			NSString *LastName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 1]];
			// UIImage *conversationContactAvatarImageRounded = [conversationContactAvatarImage th_roundedCornerImage: conversationContactAvatarImage.size.width / 2 borderSize: 0];
			NSData *conversationContactAvatarImageData = UIImagePNGRepresentation(conversationContactAvatarImage);
			UIApplicationShortcutIcon *conversationContactAvatarShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: FirstName lastName: LastName imageData:conversationContactAvatarImageData]];
			NSLog(@"Recent Conversation %@", conversation);
			NSString* conversationID = MSHookIvar<NSString *>(conversation,"_conversationId");
			NSMutableDictionary* userInfoData = [NSMutableDictionary new];
			[userInfoData setObject: conversationID forKey:@"ConversationID"];
			if (conversationContactAvatarImageData) {
				[userInfoData setObject: conversationContactAvatarImageData forKey:@"Avatar"];
			}
			[userInfoData setObject: [conversation displayName] forKey:@"Conversation_Name"];

			// NSLog(@"Conversation ID: %@", MSHookIvar<id>(conversation,"_conversationId"));
			UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.google.hangouts.conversation"] localizedTitle:[conversation displayName] localizedSubtitle: nil icon:conversationContactAvatarShortcutIcon userInfo:userInfoData];
			[shortcutItems addObject: recentConversation];
		}
	}
	[[UIApplication sharedApplication] setShortcutItems: nil];
	[UIApplication sharedApplication].shortcutItems = nil;
	[[UIApplication sharedApplication] setShortcutItems: shortcutItems];
	[UIApplication sharedApplication].shortcutItems = shortcutItems;
}
%end

%hook GBAConversationListViewController
- (void)updateConversationViewIfNecessary {
	%orig;
	[[%c(GBAApplicationDelegate) sharedDelegate] updateDynamicQuickActions:[self conversations]];
}
- (void)layoutSubviews {
	[[%c(GBAApplicationDelegate) sharedDelegate] updateDynamicQuickActions:[self conversations]];
}
- (id)init {
	%orig;
	ConversationListController = %orig;
	return %orig;
}
%end

%hook GBMConversation
- (id)initWithUserClient:(id)arg1 personsClient:(id)arg2 plusClient:(id)arg3 conversationsSyncer:(id)arg4 viewQuery:(id)arg5  {
	%orig;
	[ConversationsInstances addObject: %orig];
	return %orig;
}
%end

%hook GBMConversationSyncer
- (id)initWithUserClient:(id)arg1 sqliteDatabase:(id)arg2 apiaryChatClient:(id)arg3 personsClient:(id)arg4 plusClient:(id)arg5 photosClient:(id)arg6 conversationSyncInfo:(id)arg7 {
	ConversationsLookUp = %orig;
	ConversationsInstances = [[NSMutableArray alloc] init];
	return %orig;
}
%end
%end
%group WhatsApp
NSArray* shortcutItemsShared;

@interface WAVoiceCallViewController : UIViewController
- (void)minimizeWithAnimation:(_Bool)arg1;
@end

@interface WhatsAppAppDelegate : NSObject {
	WAVoiceCallViewController *_activeVoiceCallViewController;
}
@property(readonly, nonatomic) _Bool isCallWindowVisible;
@property(readonly, nonatomic) UITabBarController *tabBarController; // @synthesize 
@property(retain, nonatomic) NSString *chatJID; // @synthesize chatJID=_chatJID;
- (void)revm_PerformLastChat;
- (void)openChatAnimated:(_Bool)arg1 presentKeyboard:(_Bool)arg2;
- (void)updateDynamicQuickActions;
- (void)openConversationWithID:(NSString *)arg1;
@end

@interface WAApplication : UIApplication
+ (WhatsAppAppDelegate *)wa_delegate;
@end

@interface WAChatSession : NSObject
@property(retain, nonatomic) NSString *contactJID; // @dynamic contactJID;
@property(retain, nonatomic) NSString *partnerName; // @dynamic partnerName;
@end

@interface WAChatStorage : NSObject
- (NSArray *)allChatSessions;
@end

@interface WAProfilePictureManager
- (id)pictureDataForJID:(id)arg1;
- (id)profilePictureThumbnailForJID:(id)arg1;
@end

@interface WASharedAppData : NSObject
+ (WAChatStorage *)chatStorage;
+ (WAProfilePictureManager *)profilePictureManager;
@end

%hook ChatManager
- (void)chatStorage:(id)arg1 didUpdateChatSessions:(id)arg2 {
	%orig;
	[[%c(WAApplication) wa_delegate] updateDynamicQuickActions];
}
%end

%hook WhatsAppAppDelegate
%new
- (void)updateDynamicQuickActions {
	NSArray* recentConversations =  [[%c(WASharedAppData) chatStorage] allChatSessions];
	NSMutableArray* shortcutItems = [[NSMutableArray alloc] init];
	
	// UIApplicationShortcutIcon *searchShortcutIcon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeSearch];
	UIApplicationShortcutIcon *searchShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeSearch]];
	UIApplicationShortcutItem *Search = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"Search" localizedTitle:@"Search" localizedSubtitle: nil icon:searchShortcutIcon userInfo:nil];
	[shortcutItems addObject: Search];

	UIApplicationShortcutIcon *newChatShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeCompose]];
	//UIApplicationShortcutIcon *newChatShortcutIcon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType: UIApplicationShortcutIconTypeCompose];
	UIApplicationShortcutItem *NewChat = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"NewChat" localizedTitle:@"New Chat" localizedSubtitle: nil icon:newChatShortcutIcon userInfo:nil];
	[shortcutItems addObject: NewChat];

	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"lastMessageDate"  ascending:NO];
	NSMutableArray *correctOrderArray = [[recentConversations sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]]mutableCopy];
	NSArray *FinalConversationArray = [correctOrderArray copy];
	recentConversations = FinalConversationArray;
	
	NSUInteger count = [recentConversations count];
	NSLog(@"Recent Conversatons: %@", recentConversations);
	for (NSUInteger i = 0; i < count; i++) {
		WAChatSession *conversation = [recentConversations objectAtIndex: i];
		NSArray *FirstLastArray = [conversation.partnerName componentsSeparatedByString:@" "];
		NSString *FirstName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 0]];
		if ([FirstLastArray count] > 1) {
			UIImage *conversationContactAvatarImage = [[%c(WASharedAppData) profilePictureManager] profilePictureThumbnailForJID: conversation.contactJID];
			NSData *conversationContactAvatarImageData = UIImagePNGRepresentation(conversationContactAvatarImage);
			NSString *LastName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 1]];
			UIApplicationShortcutIcon *conversationContactAvatarShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: FirstName lastName: LastName imageData:conversationContactAvatarImageData]];
			NSMutableDictionary* userInfoData = [NSMutableDictionary new];
			[userInfoData setObject: conversation.contactJID forKey:@"contactJID"];
			UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"net.whatsapp.WhatsApp.conversation"] localizedTitle:conversation.partnerName localizedSubtitle: nil icon:conversationContactAvatarShortcutIcon userInfo:userInfoData];
			[shortcutItems addObject: recentConversation];
		}
		else {
			UIImage *conversationContactAvatarImage = [[%c(WASharedAppData) profilePictureManager] profilePictureThumbnailForJID: conversation.contactJID];
			NSData *conversationContactAvatarImageData = UIImagePNGRepresentation(conversationContactAvatarImage);
			UIApplicationShortcutIcon *conversationContactAvatarShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: FirstName lastName: nil imageData:conversationContactAvatarImageData]];
			NSMutableDictionary* userInfoData = [NSMutableDictionary new];
			[userInfoData setObject: conversation.contactJID forKey:@"contactJID"];
			UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"net.whatsapp.WhatsApp.conversation"] localizedTitle:conversation.partnerName localizedSubtitle: nil icon:conversationContactAvatarShortcutIcon userInfo:userInfoData];
			[shortcutItems addObject: recentConversation];
		}

	}
	// NSLog(@"Chat Updated");
	shortcutItemsShared = shortcutItems;
	[UIApplication sharedApplication].shortcutItems = shortcutItems;

}

- (void)configureShortcutItemsForApplication:(UIApplication *)arg1 {
	[self updateDynamicQuickActions];
}

- (void)application:(id)arg1 performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(id)arg3 {
	%orig;
	if ([shortcutItem.type isEqualToString:@"net.whatsapp.WhatsApp.conversation"]) {
		NSDictionary *userInfo = shortcutItem.userInfo;
		NSString *contactJID = [NSString stringWithFormat:@"%@", [userInfo valueForKey:@"contactJID"]];
		[self openConversationWithID: contactJID];
	}
}

%new
- (void)openConversationWithID:(NSString *)ChatID {
if ([self isCallWindowVisible]) {
		WAVoiceCallViewController *callVC = MSHookIvar<WAVoiceCallViewController *>(self, "_activeVoiceCallViewController");
		[callVC minimizeWithAnimation:NO];
	}
	[self setChatJID:ChatID];
	if (self.tabBarController.selectedViewController.presentedViewController) {
		[[self.tabBarController selectedViewController] dismissViewControllerAnimated:NO completion:nil];
	}
	[self openChatAnimated:YES presentKeyboard:NO];
}
%end
%end

%group Twitter

@interface T1ApplicationShortcuts : NSObject
+ (void)registerShortcutItemsWithNewMessageEnabled:(BOOL)arg1;
@end

%hook T1AppDelegate
- (id)init {
  %orig;
  [%c(T1ApplicationShortcuts) registerShortcutItemsWithNewMessageEnabled:YES];
  return %orig;
}
%end
%end

%group AlienBlue

@interface NavigationManager : NSObject
+ (instancetype)shared;
- (void)showCreatePostScreen;
@end

@interface AlienBlueAppDelegate : NSObject
@end

%hook AlienBlueAppDelegate
- (id)init {
  %orig;
  NSMutableArray *shortcutItems = [[NSMutableArray alloc] init];
  UIApplicationShortcutIcon *newPostShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeCompose]];
  //UIApplicationShortcutIcon *newChatShortcutIcon = [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType: UIApplicationShortcutIconTypeCompose];
  UIApplicationShortcutItem *NewPost = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"NewPost" localizedTitle:@"New Post" localizedSubtitle: nil icon:newPostShortcutIcon userInfo:nil];
  [shortcutItems addObject: NewPost];
  [UIApplication sharedApplication].shortcutItems = shortcutItems;
  return %orig;
}
%new
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
  if ([shortcutItem.type isEqualToString:@"NewPost"]) {
    [[%c(NavigationManager) shared] showCreatePostScreen];
  }
  completionHandler(YES);
}
%end
%end

%group Kik

@interface ConversationsViewController : NSObject
- (void)didSelectChat:(id)chat;
@end

@interface KikUser : NSObject
- (NSString *)getDisplayName;
@end

@interface KikChat : NSObject
@property (nonatomic,retain) KikUser* user;
- (id)chatIdentifier;
@end

@interface KikProfilePictureHelper : NSObject
- (UIImage *)retrieveThumbProfilePictureForUser:(id)user;
@end

@interface KikChatHelper : NSObject
- (NSArray *)allChats;
- (NSMutableArray *)allChatsMutable;
-(id)chatForID:(id)arg1;
@end

@interface KikStorage : NSObject
- (KikChatHelper *)chats;
@end

@interface ChatManager : NSObject
- (KikStorage *)storage;
@end

@interface Core : NSObject
- (ChatManager *)chatManager;
- (KikProfilePictureHelper *)profilePictureHelper;
@end

@interface AppDelegate : NSObject
- (Core *)core;
- (NSMutableArray*)allChats;
- (ConversationsViewController *)conversationsViewController;
+ (instancetype)appDelegate;
- (void)updateShortcuts;
@end

%hook KikChatHelper
%new
- (NSMutableArray *)allChatsMutable {
  return [[self allChats] mutableCopy];
}
%end

%hook ChatManager
%new
- (id)storage {
  return  MSHookIvar<id>(self,"_storage");
}
%end

%hook AppDelegate
%new
- (NSMutableArray*)allChats {
  NSMutableArray *allChatsInitialArray = [[[[[self core] chatManager] storage] chats] allChatsMutable];
  NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"dateUpdated"  ascending:NO];
  NSMutableArray *correctOrderArray = [[allChatsInitialArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]] mutableCopy];
  return correctOrderArray;
}

%new
- (void)updateShortcuts {
  NSMutableArray *shortcutItems = [[NSMutableArray alloc] init];
  NSMutableArray *chats = [self allChats];
  NSUInteger count = [chats count];
  for (NSUInteger i = 0; i < count; i++) {
    KikChat *chatSession = [chats objectAtIndex: i];
    KikUser *otherPerson = chatSession.user;
    NSArray *FirstLastArray = [[otherPerson getDisplayName] componentsSeparatedByString:@" "];
    NSString *FirstName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 0]];
    if ([FirstLastArray count] > 1) {
      UIImage *conversationContactAvatarImage = [[[self core] profilePictureHelper] retrieveThumbProfilePictureForUser: otherPerson];
      NSData *conversationContactAvatarImageData = UIImagePNGRepresentation(conversationContactAvatarImage);
      NSString *LastName = [NSString stringWithFormat:@"%@", [FirstLastArray objectAtIndex: 1]];
      UIApplicationShortcutIcon *conversationContactAvatarShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: FirstName lastName: LastName imageData:conversationContactAvatarImageData]];
      NSMutableDictionary* userInfoData = [NSMutableDictionary new];
      [userInfoData setObject: [chatSession chatIdentifier] forKey:@"contactID"];
      UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.kik.chat.conversation"] localizedTitle:[otherPerson getDisplayName] localizedSubtitle: nil icon:conversationContactAvatarShortcutIcon userInfo:userInfoData];
      [shortcutItems addObject: recentConversation];
    }
    else {
      UIImage *conversationContactAvatarImage = [[[self core] profilePictureHelper] retrieveThumbProfilePictureForUser: otherPerson];
      NSData *conversationContactAvatarImageData = UIImagePNGRepresentation(conversationContactAvatarImage);
      UIApplicationShortcutIcon *conversationContactAvatarShortcutIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutContactIcon) alloc] initWithFirstName: FirstName lastName: nil imageData:conversationContactAvatarImageData]];
      NSMutableDictionary* userInfoData = [NSMutableDictionary new];
      [userInfoData setObject: [chatSession chatIdentifier] forKey:@"contactID"];
      UIMutableApplicationShortcutItem *recentConversation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:[NSString stringWithFormat:@"com.kik.chat.conversation"] localizedTitle:[otherPerson getDisplayName] localizedSubtitle: nil icon:conversationContactAvatarShortcutIcon userInfo:userInfoData];
      [shortcutItems addObject: recentConversation];
    }


  }
  [UIApplication sharedApplication].shortcutItems = shortcutItems;
}

%new
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
  if ([shortcutItem.type isEqualToString:@"com.kik.chat.conversation"]) {
    NSDictionary *userInfo = shortcutItem.userInfo;
    NSString *contactID = [NSString stringWithFormat:@"%@", [userInfo valueForKey:@"contactID"]];
    KikChat *currentChat = [[[[[self core] chatManager] storage] chats] chatForID: contactID];
    [[self conversationsViewController] didSelectChat: currentChat];
  }
  completionHandler(YES);
}
%end

%hook KikStorage
- (void)watchAutoSave{
  %orig;
  [[%c(AppDelegate) appDelegate] updateShortcuts];
}

- (void)save {
  %orig;
  [[%c(AppDelegate) appDelegate] updateShortcuts];
}

- (void)doSave {
  %orig;
  [[%c(AppDelegate) appDelegate] updateShortcuts];
}

- (void)saveImmediately:(BOOL)arg1 {
    %orig;
  [[%c(AppDelegate) appDelegate] updateShortcuts];
}

%end
%end

%group Maps
%hook MapsAppDelegate
- (id)init {
  %orig;
  UIApplicationShortcutIcon *directionsIcon = [%c(UIApplicationShortcutIcon) iconWithTemplateImageName:@"action-home-OrbHW"];
  UIApplicationShortcutIcon *markIcon = [%c(UIApplicationShortcutIcon) iconWithTemplateImageName:@"action-drop-pin-OrbHW"];

  UIMutableApplicationShortcutItem *directionHome = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.Maps.directions" localizedTitle:[[NSBundle mainBundle] localizedStringForKey:@"QUICK_ACTION_DIRECTIONS_HOME" value:@"" table:@"InfoPlist-OrbHW"] localizedSubtitle:nil icon:directionsIcon userInfo:nil];
  UIMutableApplicationShortcutItem *markLocation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.Maps.mark-my-location" localizedTitle:[[NSBundle mainBundle] localizedStringForKey:@"QUICK_ACTION_MARK_MY_LOCATION" value:@"" table:@"InfoPlist-OrbHW"] localizedSubtitle:nil icon:markIcon userInfo:nil];
  UIMutableApplicationShortcutItem *shareLocation = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.Maps.share-location" localizedTitle:[[NSBundle mainBundle] localizedStringForKey:@"QUICK_ACTION_SEND_MY_LOCATION" value:@"" table:@"InfoPlist-OrbHW"] localizedSubtitle:nil icon:[[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeShare]] userInfo:nil];
  UIMutableApplicationShortcutItem *searchNearBy = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.Maps.search-nearby" localizedTitle:[[NSBundle mainBundle] localizedStringForKey:@"QUICK_ACTION_SEARCH_NEARBY" value:@"" table:@"InfoPlist-OrbHW"] localizedSubtitle:nil icon:[[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeSearch]] userInfo:nil];
  [[UIApplication sharedApplication] setShortcutItems: @[ directionHome, markLocation, shareLocation, searchNearBy ]];
  return %orig;
}
%end
%end

%group Photos
%hook PhotosApplication
- (id)init {
  %orig;

  NSURL *lastImageURL = [%c(DCIMImageWellUtilities) cameraPreviewWellImageFileURL];
  NSData *imageData = [[NSData alloc] initWithContentsOfURL:lastImageURL];
  PLQuickActionManager *qActionManager = [%c(PLQuickActionManager) sharedManager];
  [qActionManager _setCachedMostRecentPhotoData:imageData];
  // [qActionManager _setMostRecentPhotoIsInvalid:NO];

  // i don't know why it doesn't work :(
  SBSApplicationShortcutCustomImageIcon *recentSbsIcon = [[%c(SBSApplicationShortcutCustomImageIcon) alloc] initWithImagePNGData:imageData];
  UIApplicationShortcutIcon *recentIcon = [[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon:recentSbsIcon];
  UIApplicationShortcutIcon *favoruIcon = [%c(UIApplicationShortcutIcon) iconWithTemplateImageName:@"QuickActionFavorite-OrbHW"];
  UIApplicationShortcutIcon *onYearIcon = [%c(UIApplicationShortcutIcon) iconWithTemplateImageName:@"QuickActionAYearAgo-OrbHW"];

  UIMutableApplicationShortcutItem *recent = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.photos.shortcuts.recentphoto" localizedTitle:@"MOST_RECENT_PHOTO" localizedSubtitle:nil icon:recentIcon userInfo:nil];
  UIMutableApplicationShortcutItem *favorite = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.photos.shortcuts.favorites" localizedTitle:@"FAVORITES" localizedSubtitle:nil icon:favoruIcon userInfo:nil];
  UIMutableApplicationShortcutItem *yearago = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.photos.shortcuts.oneyearago" localizedTitle:@"ONE_YEAR_AGO" localizedSubtitle:nil icon:onYearIcon userInfo:nil];
  UIMutableApplicationShortcutItem *search = [[%c(UIMutableApplicationShortcutItem) alloc] initWithType:@"com.apple.photos.shortcuts.search" localizedTitle:@"SEARCH" localizedSubtitle:nil icon:[[%c(UIApplicationShortcutIcon) alloc] initWithSBSApplicationShortcutIcon: [[%c(SBSApplicationShortcutSystemIcon) alloc] initWithType:UIApplicationShortcutIconTypeSearch]] userInfo:nil];
  [[UIApplication sharedApplication] setShortcutItems: @[ recent, favorite, yearago, search ]];
  return %orig;
}

%end
%end
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	if ([((NSDictionary *)userInfo)[NSLoadedClasses] containsObject:@"AXForceTouchController"]) {
		%init(TouchSettings);
	}
}

static void loadPrefs() {

       NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creatix.keyforce.plist"];
    if(prefs)
    {
kPeekPopForceSensitivity = ([prefs objectForKey:@"PeekPopForceSensitivity"] ? [[prefs objectForKey:@"PeekPopForceSensitivity"] integerValue] : 43);
kAllEnabed = ([prefs objectForKey:@"AllEnabled"] ? [[prefs objectForKey:@"AllEnabled"] boolValue] : YES);
kHomeScreenForceSensitivity = ([prefs objectForKey:@"HomeScreenForceSensitivity"] ? [[prefs objectForKey:@"HomeScreenForceSensitivity"] integerValue] : kHomeScreenForceSensitivity);
kHomeEnabled = ([prefs objectForKey:@"HomeEnabled"] ? [[prefs objectForKey:@"HomeEnabled"] boolValue] : YES);
kPeekPopEnabled = ([prefs objectForKey:@"PeekPopEnabled"] ? [[prefs objectForKey:@"PeekPopEnabled"] boolValue] : YES);
}
    [prefs release];
}

static void settingschanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    loadPrefs();
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingschanged, CFSTR("com.creatix.keyforce/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  loadPrefs();
  if (kAllEnabed) {
	 %init;
	    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
          %init(SpringBoard);
      }
      if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.MobileSMS"]) {
          %init(Messages);
      }
      if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.google.hangouts"]) {
          %init(Hangouts);
      }
      if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"net.whatsapp.WhatsApp"]) {
          %init(WhatsApp);
      }
      if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.atebits.Tweetie2"]) {
          %init(Twitter);
      }
      if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.reddit.alienblue"]) {
          %init(AlienBlue);
      }
      if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.kik.chat"]) {
          %init(Kik);
      }
      if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.mobileslideshow"]) {
          %init(Photos);
      }
      if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.Maps"]) {
          %init(Maps);
      }
    }
	CFNotificationCenterAddObserver(
		CFNotificationCenterGetLocalCenter(), NULL,
		notificationCallback,
		(CFStringRef)NSBundleDidLoadNotification,
		NULL, CFNotificationSuspensionBehaviorCoalesce);
}