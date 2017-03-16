#import "NTXBackdropViewSettings.h"
#import "NTXVibrantStyling.h"
#import "NTXMaterialView.h"
#import "NTXModernNotificationView.h"
#import "headers/_UIBackdropView.h"
#import "headers/SBWallpaperEffectView.h"
#import "headers/SBLockScreenNotificationCell.h"
#import "headers/SBAwayBulletinListItem.h"
#import "headers/NCRelativeDateLabel.h"
#import "headers/SBLockScreenView.h"
#import "headers/SBLockScreenNotificationListView.h"
#import "headers/SBLockScreenNotificationListController.h"
#import "headers/SBLockScreenBulletinCell.h"
#import "headers/SBLockScreenViewController.h"
#import "headers/SBLockScreenNotificationTableView.h"

#include <CoreFoundation/CoreFoundation.h>
#include <CoreGraphics/CoreGraphics.h>
#include <CoreText/CoreText.h>



// typedef struct SBFWallpaperBackdropParameters {
//     NSInteger p1; // style
//     NSInteger p2; // idc about this
//     NSInteger p3; // idc about this
//     CGFloat p4; // idc about this
//     CGFloat p5; // idc about this
//     CGFloat p6; // idc about this
//     CGFloat p7; // idc about this
// } SBFWallpaperBackdropParameters;

// _UIBackdropViewSettings* (*orig_SBFBackdropInputSettingsForWallpaperBackdropParameters)(NSInteger a1,NSInteger a2,NSInteger a3, CGFloat a4,CGFloat a5,CGFloat a6,CGFloat a7);  // a function pointer to store the original CFShow().
// _UIBackdropViewSettings* new_SBFBackdropInputSettingsForWallpaperBackdropParameters(NSInteger a1,NSInteger a2,NSInteger a3, CGFloat a4,CGFloat a5,CGFloat a6,CGFloat a7) {
//   NSLog(@" VALUE FOR THINGY: %@", @(a1));
//   // NSLog(@" VALUE FOR THINGY int %d", (int)a1); 
//   // NSLog(@" VALUE FOR THINGY double: %lf", (double)a1);
//   // NSLog(@" ValueF")

//   if (a1 == (NSInteger)32) {
//   	NSLog(@"Got a 32 value woo");

//   	return [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
//   } else return orig_SBFBackdropInputSettingsForWallpaperBackdropParameters(a1,a2,a3,a4,a5,a6,a7);
// }

// _UIBackdropViewSettings* (*orig_SBFBackdropOutputSettingsForWallpaperBackdropParameters)(NSInteger a1,NSInteger a2,NSInteger a3, CGFloat a4,CGFloat a5,CGFloat a6,CGFloat a7);  // a function pointer to store the original CFShow().
// _UIBackdropViewSettings* new_SBFBackdropOutputSettingsForWallpaperBackdropParameters(NSInteger a1,NSInteger a2,NSInteger a3, CGFloat a4,CGFloat a5,CGFloat a6,CGFloat a7) {
//   if (a1 == (NSInteger)32) {
//   	NSLog(@"Got a 32 value woo");
//   	return [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
//   } else return orig_SBFBackdropOutputSettingsForWallpaperBackdropParameters(a1,a2,a3,a4,a5,a6,a7);
// }

@interface SBLockScreenNotificationCell (NTX)
@property (nonatomic, retain) NTXModernNotificationView *modernView;
@end

@interface UIImage (Private)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
+ (UIImage *)getImageFromBundleNamed:(NSString*)name withExtension:(NSString*)extensio;
@end

@interface UIImage (SB)
- (UIImage *)_applyBackdropViewSettings:(id)arg1;
- (UIImage *)_applyBackdropViewSettings:(id)arg1 includeTints:(BOOL)arg2 includeBlur:(BOOL)arg3;
- (UIImage *)sbf_scaleImage:(CGFloat)scale;
@end

@interface UILabel (NTX)
+ (CGFloat)getLabelHeightForText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;
@end
@interface UIView (Priv)
- (UIImage *)_imageFromRect:(CGRect)frame;
@end
@implementation UILabel (NTX)
+ (CGFloat)getLabelHeightForText:(NSString *)text font:(UIFont *)font width:(CGFloat)width
{
    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
    CGSize size;

    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:font}
                                                  context:context].size;

    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));

    return size.height;
}
@end

// %hook UIImage
// %new
// - (UIImage *)materialImageThing {
// 	_UIBackdropViewSettings *settings = [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
// 	[settings setDefaultValues];
// 	return [self _applyBackdropViewSettings:settings];
// }

// -(id)_applyBackdropViewSettings:(id)arg1 includeTints:(BOOL)arg2 includeBlur:(BOOL)arg3 {
// 	return %orig([NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES],YES,YES);
// }
// -(id)_applyBackdropViewSettings:(id)arg1 allowImageResizing:(BOOL)arg2 {
// 	return %orig([NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES],arg2);

// }
// -(id)_applyBackdropViewSettings:(id)arg1 includeTints:(BOOL)arg2 includeBlur:(BOOL)arg3 allowImageResizing:(BOOL)arg4 {
// 	return %orig([NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES],YES,YES,arg4);

// }
// -(id)_applyBackdropViewSettings:(id)arg1 {
// 	return %orig([NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES]);
// }
// %end

UIImage *sharedImage;
static BOOL setShared = NO;

// %hook UIView
// %new
// - (void)materialview {
// 	NTXMaterialView *view = [NTXMaterialView materialViewWithStyleOptions:2];
// 	[view setGroupName:@"CCUIControlCenterBaseMaterialBlur"];
// 	SBWallpaperEffectView *wallpaperEffect = [[NSClassFromString(@"SBWallpaperEffectView") alloc] initWithWallpaperVariant:1];
// 	wallpaperEffect.forcesOpaque = YES;
// 	[wallpaperEffect setStyle:0];
// 	[view setColorInfusionView:wallpaperEffect];
// 	[view _setColorInfusionViewAlpha:0.25];
// 	view.frame = CGRectMake(8,8,398,398);
// 	view.layer.cornerRadius = 15;
// 	view.layer.masksToBounds = YES;
// 	[self addSubview:view];

// 	// _UIBackdropViewSettings *_backdropSettings = [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
// 	// _UIBackdropView *_backdropView = [[_UIBackdropView alloc] initWithSettings:_backdropSettings];
// 	// [self addSubview:_backdropView];
// }
// // %new
// // - (id)material2 {
// // 	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
// // 	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,sharedImage.size.width,sharedImage.size.height)];
// // 	[window addSubview:imageView];
// // 	imageView.image = sharedImage;
// // 	_UIBackdropViewSettings *_backdropSettings = [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
// // 	_UIBackdropView *_backdropView = [[_UIBackdropView alloc] initWithSettings:_backdropSettings];
// // 	[imageView addSubview:_backdropView];
// // 	window.hidden = NO;
// // 	__block UIImage *thing;
// // 	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
// //     	thing = [window _imageFromRect:window.frame];
// // 		thing = [thing sbf_scaleImage:(CGFloat)1.0/(CGFloat)[UIScreen mainScreen].scale]; 
// // 		sharedImage = thing;
// // 	});
// // 	return thing;
// // }
// %end

%hook _UIBackdropViewSettings
+ (id)settingsForPrivateStyle:(NSInteger)arg1 graphicsQuality:(NSInteger)arg2 {
	NSLog(@"Style STuff: %@", @(arg1));
	if (arg1 == (NSInteger)32)
		return [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
	else return %orig;
// 	if (arg1 == 2071) {
// 		return [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
// 	}
// 	if (arg1 == 32) {
// 		return [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
// 	}
	
// 	return %orig;
}
%end

@interface _UIBackdropViewSettingsFlatSemiLight: _UIBackdropViewSettings
- (BOOL)_isDarkened;
- (BOOL)_isBlurred;
@end

%hook _SBFakeBlurView
+(UIImage *)_imageForStyle:(NSInteger*)arg1 withSource:(id)arg2 {
	if (!setShared) {

		NSInteger ttr = 0;
		sharedImage = %orig(&ttr,arg2);
		UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0,0,sharedImage.size.width,sharedImage.size.height)];
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,sharedImage.size.width,sharedImage.size.height)];
		[window addSubview:imageView];
		imageView.image = sharedImage;
		_UIBackdropViewSettings *_backdropSettings = [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
		_UIBackdropView *_backdropView = [[_UIBackdropView alloc] initWithSettings:_backdropSettings];
		[imageView addSubview:_backdropView];
		window.hidden = NO;
		__block UIImage *thing;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
	    	thing = [window _imageFromRect:window.frame];
			thing = [thing sbf_scaleImage:(CGFloat)1.0/(CGFloat)[UIScreen mainScreen].scale]; 
			sharedImage = thing;
			window.hidden = YES;
			window.alpha = 0;
			window.userInteractionEnabled = NO;
			// [UIWindow _removeWindowFromStack:window];

		});
		setShared = YES;
	}
	NSInteger style = *arg1;
	if (style == (NSInteger)32) {

		if (sharedImage) return sharedImage;
		else return nil;

		// UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

		// UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,image.size.width,image.size.height)];
		// [window addSubview:imageView];
		// imageView.image = image;
		// _UIBackdropViewSettings *_backdropSettings = [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
		// _UIBackdropView *_backdropView = [[_UIBackdropView alloc] initWithSettings:_backdropSettings];
		// [imageView addSubview:_backdropView];


		// UIGraphicsBeginImageContext(CGSizeMake(imageView.frame.size.width, imageView.frame.size.height));
		// CGContextRef context = UIGraphicsGetCurrentContext();
		// UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
		// UIGraphicsEndImageContext();
		// return screenShot;
		// return sharedImage;
	} else return %orig;

}
%end

%hook SBWallpaperEffectView
- (void)_configureFromScratch {
	NSInteger style = MSHookIvar<NSInteger>(self,"_startStyle");
	if (style == (NSInteger)32) {
		MSHookIvar<BOOL>(self,"_forcesOpaque") = YES;
	}
	%orig;
	// MSHookIvar<BOOL>(self,@"_forcesOpaque") = NO;
}
// -(void)_configureForCurrentBlurStyle {
// 	MSHookIvar<BOOL>(self,"_forcesOpaque") = NO;
// 	%orig;
// }
%end

%hook SBLockScreenNotificationCell
%property (nonatomic, retain) NTXModernNotificationView *modernView;

- (id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 {
	SBLockScreenNotificationCell *cell = %orig;
	cell.modernView = [[NTXModernNotificationView alloc] init];
	[cell addSubview:cell.modernView];
	[self.modernView addConstraintsNow];
	cell.clipsToBounds = YES;
	return cell;
	// UIGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
 //    recognizer.delegate = self;
 //    [self addGestureRecognizer:recognizer];
}

// %new
// - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
// {
//     // note: we might be called from an internal UITableViewCell long press gesture

//     if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {

//         UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer*)gestureRecognizer;
//         UIView *cell = [panGestureRecognizer view];
//         CGPoint translation = [panGestureRecognizer translationInView:[cell superview]];

//         // Check for horizontal gesture
//         if (fabs(translation.x) > fabs(translation.y))
//         {
//             return YES;
//         }

//     }

//     return NO;
// }

// %new
// - (void)handlePan:(UIPanGestureRecognizer *)recognizer {
// 	if (recognizer.state == UIGestureRecognizerStateBegan) {
// 	    //if the gesture has just started record the center location
// 	    NSLog(@"handlePan");
// 	    self.originalCenter = self.modernView.center; //Declared as a CGPoint at the top of my TableViewCell
// 	}

// 	if (recognizer.state == UIGestureRecognizerStateChanged) {
// 	    //translate the center (aka translate from the center of the cell)
// 	    CGPoint translation = [recognizer translationInView:self.modernView];
// 	    self.modernView.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
// 	    // determine whether the item has been dragged far enough to delete/complete

// 	}

// 	if (recognizer.state == UIGestureRecognizerStateEnded) {
// 	    // the frame this cell would have had before being dragged
// 	    CGRect originalFrame = CGRectMake(0, self.modernView.frame.origin.y, self.modernView.bounds.origin.x, self.modernView.bounds.size.height);
// 	    [UIView animateWithDuration:0.2 animations:^{
// 	        self.modernView.frame = originalFrame;}
// 	     ];
// 	}
// }








// -(void)setRelevanceDateLabel:(NCRelativeDateLabel *)label {
// 	%orig;
// 	if (self.modernView) {
// 		if (self.modernView.syncDateLabel) {
// 			self.modernView.syncDateLabel.syncTextDelegate = nil;
// 			self.modernView.syncDateLabel = nil;
// 		}
// 	}
// 	if (self.modernView) {
// 		label.syncTextDelegate = self.modernView;
// 		self.modernView.syncDateLabel = label;
// 		[self.modernView updateDate:label];
// 		if ([label superview]) {
// 			[label removeFromSuperview];
// 			[self.modernView addSubview:label];
// 			label.hidden = YES;
// 			label.alpha = 0;
// 		}
// 	}
// }
- (void)addSubview:(UIView *)view {
	if (self.modernView) {
		if ([view isKindOfClass:[NTXModernNotificationView class]]) {
			%orig;
		}
	} else {
		%orig;
	}
}

- (void)setIsTopCell:(BOOL)isTopCell {
	MSHookIvar<BOOL>(self, "_isTopCell") = isTopCell;
	if (self.modernView) {
		if ([self.modernView listItem]) {
			[self.modernView showHintLabel:isTopCell];
		}
	}
}

+ (CGFloat)rowHeightForTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body maxLines:(unsigned long long)arg4 attachmentSize:(CGSize)attachmentSize secondaryContentSize:(CGSize)arg6 datesVisible:(BOOL)arg7 rowWidth:(CGFloat)arg8 includeUnlockActionText:(BOOL)arg9 {
	CGFloat height = 0;
	height = height+32;
	CGFloat contentWidth = arg8-(8*2)-(15*2);
	if (attachmentSize.width > 1) {
		contentWidth -= 35+15;
	}
	if (title) {
		height += [UILabel getLabelHeightForText:title font:[NTXModernNotificationView primaryLabelFont] width:contentWidth];
	}
	if (subtitle) {
		height += [UILabel getLabelHeightForText:subtitle font:[NTXModernNotificationView primarySubtitleLabelFont] width:contentWidth];
	}
	if (body) {
		height += [UILabel getLabelHeightForText:body font:[NTXModernNotificationView secondaryLabelFont] width:contentWidth];
	}
	// if (arg9) {
	// 	height += [UILabel getLabelHeightForText:@"Slide to Reply" font:[NTXModernNotificationView hintLabelFont] width:contentWidth];
	// }
	height=height+(8*2);
	return height;
}
%end

%hook SBLockScreenBulletinCell
+ (CGFloat)rowHeightForTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body maxLines:(unsigned long long)arg4 attachmentSize:(CGSize)attachmentSize secondaryContentSize:(CGSize)arg6 datesVisible:(BOOL)arg7 rowWidth:(CGFloat)arg8 includeUnlockActionText:(BOOL)arg9 {
	CGFloat height = 0;
	height = height+32;
	CGFloat contentWidth = arg8-(8*2)-(15*2);
	if (attachmentSize.width > 1) {
		contentWidth -= 35+15;
	}
	if (title) {
		height += [UILabel getLabelHeightForText:title font:[NTXModernNotificationView primaryLabelFont] width:contentWidth];
	}
	if (subtitle) {
		height += [UILabel getLabelHeightForText:subtitle font:[NTXModernNotificationView primarySubtitleLabelFont] width:contentWidth];
	}
	if (body) {
		height += [UILabel getLabelHeightForText:body font:[NTXModernNotificationView secondaryLabelFont] width:contentWidth];
	}
	// if (arg9) {
	// 	height += [UILabel getLabelHeightForText:@"Slide to Reply" font:[NTXModernNotificationView hintLabelFont] width:contentWidth];
	// }
	height=height+(8*2);
	return height;
}
%end

%hook SBLockScreenNotificationListView
%property (nonatomic, retain) NTXModernNotificationView *draggedCell;

-(void)scrollViewWillBeginDragging:(id)arg1 {
	if (self.draggedCell) {
		[self.draggedCell closeActionsView];
		self.draggedCell = nil;
		return;
	}
	%orig;
}

- (void)_setContentForTableCell:(SBLockScreenNotificationCell *)cell withItem:(SBAwayBulletinListItem *)item atIndexPath:(NSIndexPath *)path {
  	%orig;
  	if (!cell.modernView) {
  		cell.modernView = [[NTXModernNotificationView alloc] init];
  		[cell addSubview:cell.modernView];
 		[cell.modernView addConstraintsNow];
  	}


  	[cell.modernView setListItem:item withActions:[self tableView:[self valueForKey:@"_tableView"] editActionsForRowAtIndexPath:path]];
  	NCRelativeDateLabel *dateLabel = MSHookIvar<NCRelativeDateLabel *>(cell, "_relevanceDateLabel");
  	if (dateLabel) {
  		dateLabel.syncTextDelegate = cell.modernView;
  		[cell.modernView updateDate:dateLabel];
		if ([dateLabel superview]) {
			[dateLabel removeFromSuperview];
			[cell.modernView addSubview:dateLabel];
			dateLabel.hidden = YES;
			dateLabel.alpha = 0;
		}
  	}

  	[cell.modernView showHintLabel:MSHookIvar<BOOL>(cell, "_isTopCell")];
  	for (UIView *subview in [cell subviews]) {
  		if (![subview isKindOfClass:[NTXModernNotificationView class]]) {
  			[subview removeFromSuperview];
  		}
  	}
}

- (BOOL)tableView:(id)arg1 shouldDrawTopSeparatorForSection:(long long)arg2 {
	return NO;
}

// - (int)_rowAnimationForInsert {
// 	return 5;
// }
// -(void)updateForRemovalOfItemAtIndex:(unsigned long long)arg1 removedItem:(id)arg2 {
// 	[UIView setAnimationsEnabled:NO];
// 	%orig;
// 	[UIView setAnimationsEnabled:YES];
// }

// - (id)tableView:(id)arg1 editActionsForRowAtIndexPath:(id)arg2 {
// 	return nil;
// }

- (void)tableView:(id)arg1 willBeginSwipingRowAtIndexPath:(id)arg2 {
	return;
}

- (void)tableView:(id)arg1 didEndSwipingRowAtIndexPath:(id)arg2 {
	return;
}

- (BOOL)tableView:(id)arg1 canEditRowAtIndexPath:(id)arg2 {
	return NO;
}

// - (SBLockScreenNotificationCell *)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 {
// 	SBLockScreenNotificationCell *cell = %orig;
// 	if (cell.modernView) {
// 		[cell.modernView updateHeight];
// 	}
// 	return cell;
// }

%new
- (void)updateListItem:(SBAwayBulletinListItem *)item withHeight:(CGFloat)height {
	NSMutableDictionary *_heights = MSHookIvar<NSMutableDictionary *>(self,"_heightForListItemCache");
	[_heights setObject:@(height) forKey:item];
	[self _updateTotalContentHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat origHeight = %orig;
	// if ([indexPath row] == 0) {
	// 	if ([self _activeBulletinForIndexPath:indexPath].fullUnlockActionLabel)
	// 		if([self _activeBulletinForIndexPath:indexPath].fullUnlockActionLabel.length > 0)
	// 			origHeight += [UILabel getLabelHeightForText:@"Slide to Reply" font:[NTXModernNotificationView hintLabelFont] width:self.frame.size.width];
	// }
	return origHeight;
}
%end

%hook SBAwayBulletinListItem
- (BOOL)wantsHighlightOnInsert {
	return NO;
}
%end

%hook SBLockScreenNotificationTableView
-(void)setSeparatorStyle:(long long)arg1 {
	%orig(UITableViewCellSeparatorStyleNone);
}

- (long long)separatorStyle {
	return  UITableViewCellSeparatorStyleNone;
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UISwipeGestureRecognizer *)otherGestureRecognizer 
{
    return YES;
}

// - (void)beginUpdates {
// 	[UIView setAnimationsEnabled:NO];
// 	%orig;
// }
// - (void)endUpdates {
// 	%orig;
// 	[UIView setAnimationsEnabled:YES];
// }
%end

%hook NCRelativeDateLabel
%property (nonatomic, retain) NTXModernNotificationView *syncTextDelegate;

- (void)setText:(NSString *)text {
	%orig;
	if (self.syncTextDelegate) {
		[self.syncTextDelegate updateDate:self];
	}
}
%end

%hook SBLockScreenView
-(void)_addLockContentUnderlayWithRequester:(id)arg1 {
	if (!([self _percentScrolled] > 0)) {
		if ([[NSString stringWithFormat:@"%@",arg1] isEqualToString:@"NotificationList"]) {
			return;
		}
	}
	%orig;
}

-(void)scrollViewWillBeginDragging:(id)arg1 {
	if (self.notificationView.draggedCell) {
		[self.notificationView.draggedCell closeActionsView];
		self.notificationView.draggedCell = nil;
		// for (UIGestureRecognizer *gesture in [self gestures]) {
		// 	if (gesture.enabled) {
		// 		gesture.enabled = NO;
		// 		gesture.enabled = YES;
		// 	}
		// }
		return;
	}
	%orig;
}
%end

%ctor {
	NSString *basePath = @"/Library/Application Support/NotificationsX/Resources.bundle/";
	NSMutableArray *customFontFilePaths = [NSMutableArray new];
	[customFontFilePaths addObject:[NSString stringWithFormat:@"%@SFUIText.otf",basePath]];
	if (customFontFilePaths) {
		for(NSString *fontFilePath in customFontFilePaths){
            if([[NSFileManager defaultManager] fileExistsAtPath:fontFilePath]){
                NSData *inData = [NSData dataWithContentsOfFile:fontFilePath];
                CFErrorRef error;
                CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
                CGFontRef font = CGFontCreateWithDataProvider(provider);
                // NSString *fontName = (__bridge NSString *)CGFontCopyFullName(font);
                if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
                    CFStringRef errorDescription = CFErrorCopyDescription(error);
                    NSLog(@"Failed to load font: %@", errorDescription);
                    CFRelease(errorDescription);
                }
                CFRelease(font);
                CFRelease(provider);
            }
        }
    }
    %init;
 //    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	// UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,sharedImage.size.width,sharedImage.size.height)];
	// [window addSubview:imageView];
	// imageView.image = sharedImage;
	// _UIBackdropViewSettings *_backdropSettings = [NTXBackdropViewSettings watchNotificationsBackdropViewSettingsWithBlur:YES];
	// _UIBackdropView *_backdropView = [[_UIBackdropView alloc] initWithSettings:_backdropSettings];
	// [imageView addSubview:_backdropView];
	// window.hidden = NO;
	// __block UIImage *thing;
	// dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
 //    	thing = [window _imageFromRect:window.frame];
	// 	thing = [thing sbf_scaleImage:(CGFloat)1.0/(CGFloat)[UIScreen mainScreen].scale]; 
	// 	sharedImage = thing;
	// });
    // MSHookFunction((void *)MSFindSymbol(NULL,"_SBFBackdropInputSettingsForWallpaperBackdropParameters"), (void *)new_SBFBackdropInputSettingsForWallpaperBackdropParameters, (void **)&orig_SBFBackdropInputSettingsForWallpaperBackdropParameters);
    // MSHookFunction((void *)MSFindSymbol(NULL,"_SBFBackdropOutputSettingsForWallpaperBackdropParameters"), (void *)new_SBFBackdropOutputSettingsForWallpaperBackdropParameters, (void **)&orig_SBFBackdropOutputSettingsForWallpaperBackdropParameters);
}


