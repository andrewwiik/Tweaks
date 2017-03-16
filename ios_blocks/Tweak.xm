// #import <UIKit/UIKit.h>
// #import "IBIconHandler.h"
// #import "headers.h"
// //static BOOL isHunting = NO;
// // static BOOL coordinateForIndexOriginal = FALSE;
// static BOOL isDropping = NO;
// // static BOOL isRegular = NO;
// // static BOOL isPausing = NO;
// static unsigned long long previousPauseIndex = -1;

// #define BLOCK_SIZE (CGSizeMake(152,162))
// #define BLOCK_CORNER (15.0)
// #import "headers.h"


// SBIconCoordinate SBIconCoordinateMake(long long row, long long col) {
//     SBIconCoordinate coordinate;
//     coordinate.row = row;
//     coordinate.col = col;
//     return coordinate;
// }

// CATransform3D CATransform3DMake(CGFloat m11, CGFloat m12, CGFloat m13, CGFloat m14,
//                                 CGFloat m21, CGFloat m22, CGFloat m23, CGFloat m24,
//                                 CGFloat m31, CGFloat m32, CGFloat m33, CGFloat m34,
//                                 CGFloat m41, CGFloat m42, CGFloat m43, CGFloat m44)
// {
//     CATransform3D t;
//     t.m11 = m11; t.m12 = m12; t.m13 = m13; t.m14 = m14;
//     t.m21 = m21; t.m22 = m22; t.m23 = m23; t.m24 = m24;
//     t.m31 = m31; t.m32 = m32; t.m33 = m33; t.m34 = m34;
//     t.m41 = m41; t.m42 = m42; t.m43 = m43; t.m44 = m44;
//     return t;
// }


// @interface NSValue (SBIconCoordinate)
// + (NSValue *)valueWithSBIconCoordinate:(SBIconCoordinate)coord;
// - (SBIconCoordinate)SBIconCoordinateValue;
// @end

// @implementation NSValue (SBIconCoordinate)
// + (NSValue *)valueWithSBIconCoordinate:(SBIconCoordinate)coord {
//     return [NSValue valueWithCGPoint:CGPointMake((CGFloat)coord.col, (CGFloat)coord.row)];
// }
// - (SBIconCoordinate)SBIconCoordinateValue {
//     SBIconCoordinate coordinate;
//     coordinate.row = (long long)self.CGPointValue.y;
//     coordinate.col = (long long)self.CGPointValue.x;
//     return coordinate;
// }
// @end

// @interface NSMutableDictionary (Blocks)
// - (NSArray*)allObjects;
// @end


// @interface MPUNowPlayingController : NSObject
// - (void)_updateCurrentNowPlaying;
// - (UIImage*)currentNowPlayingArtwork;
// - (void)setShouldUpdateNowPlayingArtwork:(BOOL)arg1;
// - (NSMutableDictionary*)currentNowPlayingInfo;
// @end

// @class CAFilter;
// @interface CAFilter : NSObject
// +(instancetype)filterWithName:(NSString *)name;
// @end

// @interface UIImage (Resize)
// + (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
// - (UIImage *)drawImage:(UIImage *)inputImage inRect:(CGRect)frame;
// @end
// @implementation UIImage (Resize)
// + (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
//     UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//     [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//     UIGraphicsEndImageContext();
//     return newImage;
// }
// - (UIImage *)drawImage:(UIImage *)inputImage inRect:(CGRect)frame {
//     UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
//     [self drawInRect:CGRectMake(0.0, 0.0, self.size.width, self.size.height)];
//     [inputImage drawInRect:frame];
//     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//     UIGraphicsEndImageContext();
//     return newImage;
// }
// @end

// void reloadListViewWithIcon(SBIcon *icon) {
//     SBIconController *controller = [NSClassFromString(@"SBIconController") sharedInstance];
//     SBRootFolder *rootFolder = [controller valueForKeyPath:@"rootFolder"];
//     NSIndexPath *indexPath = [rootFolder indexPathForIcon:icon];
//     SBIconListView *listView = nil;
//     [controller getListView:&listView folder:NULL relativePath:NULL forIndexPath:indexPath createIfNecessary:YES];
//     unsigned long long index = [(SBIconListModel*)[listView model] indexForLeafIconWithIdentifier:[icon applicationBundleID]];
//     [[IBIconHandler sharedHandler] setIndex:index forBundleID:[icon applicationBundleID]];
//     [listView setIconsNeedLayout];
//     [listView layoutIconsIfNeeded:1.0 domino:NO];
// }
// @interface SBIconView (WDXPinchGesture)
// @property (nonatomic, retain) UIView *widgetView;
// @end
// %hook SBIconView

// - (BOOL)isUserInteractionEnabled {
//     if ([self.icon isKindOfClass:[%c(SBWDXPlaceholderIcon) class]]) return NO;
//     else return %orig;
// }
// %property (nonatomic, retain) BOOL isBlockForm;
// %property (nonatomic, retain) MPUNowPlayingController *playController;
// %property (nonatomic, retain) UILabel *songLabel;
// %property (nonatomic, retain) UILabel *artistLabel;
// %property (nonatomic, retain) UIWebView *webView;
// %property (nonatomic, retain) UIView *widgetView;

// - (id)initWithContentType:(unsigned long long)arg1 {
//     self = %orig;
    
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadViews) name:@"IBIconNeedsLayout" object:nil];
    
//     return self;
// }

// - (void)layoutSubviews {
//     %orig;
//     if ([[self.superview class] isEqual:NSClassFromString(@"UIView")]) {
        
//     } else {
//         [self reloadViews];
//     }
//     if ([[[self icon] applicationBundleID] isEqualToString:@"com.apple.Music"]) {
        
//         //self.clipsToBounds = YES;
//         if (!self.playController)
//             self.playController = [[%c(MPUNowPlayingController) alloc] init];
//             [self.playController setShouldUpdateNowPlayingArtwork:YES];
//         [self.playController _updateCurrentNowPlaying];
//     }
//     // [self.layer setSublayerTransform:CATransform3DMake(0.6,0,0,0,0,0.6,0,0,0,0,1,0,0,0,0,1)];
// }
// // - (CGSize)iconImageVisibleSize {
// // 	CGSize orig = %orig;
// // 	return CGSizeMake(orig.width * 0.6, orig.height * 0.6);
// // }
// %new
// -(UIImage *)imageFromView {
    
//     UIGraphicsBeginImageContext(self.bounds.size);
    
//     [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
//     UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//     UIGraphicsEndImageContext();
    
//     return viewImage;
// }
// // - (void)setIsGrabbed:(BOOL)isGrabbed {
// //     self.alpha = 1;
// //     if (isGrabbed) {
// //         if ([[IBIconHandler sharedHandler] containsBundleID:self.icon.applicationBundleID]) {
// //             UIImage *widgetSnapshot = [self imageFromView];
// //             UIImageView *blurredWidgetView = [[UIImageView alloc] initWithImage:[widgetSnapshot stackBlur:30]];
// //             [self addSubview:blurredWidgetView];
// //             blurredWidgetView.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
// //             blurredWidgetView.layer.cornerRadius = BLOCK_CORNER;
// //             blurredWidgetView.clipsToBounds = YES;
// //         }
// //     }
// //     %orig;
// //     self.alpha = 1;
// // }
// %new
// - (void)reloadViews {
//     if ([[self.superview class] isEqual:NSClassFromString(@"SBDockIconListView")] || [[self.superview class] isEqual:NSClassFromString(@"SBFolderIconListView")]) return;
//     if ([[IBIconHandler sharedHandler] containsBundleID:self.icon.applicationBundleID]) {
//         CGSize blockSize = [[IBIconHandler sharedHandler] sizeForBundleID:self.icon.applicationBundleID];
//         [self._iconImageView setFrame:CGRectMake(self._iconImageView.frame.origin.x,self._iconImageView.frame.origin.y,blockSize.width,blockSize.height)];
//         [self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y,blockSize.width,blockSize.height)];
//         if (!self.isBlockForm) {
//             self.isBlockForm = YES;
//             UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(self._iconImageView.frame.origin.x,self._iconImageView.frame.origin.y,blockSize.width,blockSize.height)];
//             viewTemp.tag = 1313;
//             viewTemp.layer.cornerRadius = BLOCK_CORNER;
//             viewTemp.backgroundColor = [UIColor clearColor];
//             [self addSubview:viewTemp];
//             self.widgetView = viewTemp;
//             if ([[[self icon] applicationBundleID] isEqualToString:@"com.apple.Music"]) {
                
//                 //self.clipsToBounds = YES;
//                 if (!self.playController)
//                     self.playController = [[%c(MPUNowPlayingController) alloc] init];
//                     [self.playController setShouldUpdateNowPlayingArtwork:YES];
//                 [self.playController _updateCurrentNowPlaying];
                
//                 _UIBackdropViewSettings *blurSettings= [_UIBackdropViewSettings MPU_settingsForNowPlayingBackdrop];
//                 MPUBlurEffectView *blurView = [[%c(MPUBlurEffectView) alloc] initWithFrame:CGRectZero];
//                 [blurView setEffectSettings:blurSettings];
//                 [blurView setEffectImage:[self updateArtwork]];
//                 [blurView setReferenceView:blurView];
//                 blurView.translatesAutoresizingMaskIntoConstraints = NO;
//                 viewTemp.clipsToBounds = YES;
//                 blurView.clipsToBounds = YES;
//                 [viewTemp addSubview:blurView];
                
//                 [self addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:-1]];
//                 [self addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//                 [self addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:2 constant:-1]];
//                 [self addConstraint:[NSLayoutConstraint constraintWithItem:blurView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
                
                
//                 MPUVibrantContentEffectView *contentView1 = [[%c(MPUVibrantContentEffectView) alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
//                 [contentView1 setReferenceView:blurView];
//                 [contentView1 setEffectImage:[self updateArtwork]];
//                 [contentView1 setEffectSettings:[_UIBackdropViewSettings MPU_settingsForNowPlayingVibrantContent]];
//                 contentView1.translatesAutoresizingMaskIntoConstraints = NO;
                
//                 [viewTemp addSubview:contentView1];
//                 [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:-1]];
//                 [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//                 [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:2 constant:-1]];
//                 [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
                
                
//                 UIImageView *artworkView = [[UIImageView alloc] initWithImage:[UIImage imageWithImage:[self.playController currentNowPlayingArtwork] scaledToSize:CGSizeMake(self.frame.size.height, self.frame.size.height)]];
//                 artworkView.translatesAutoresizingMaskIntoConstraints = NO;
//                 artworkView.clipsToBounds = YES;
                
//                 [viewTemp addSubview:artworkView];
//                 [self addConstraint:[NSLayoutConstraint constraintWithItem:artworkView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:-1]];
//                 [self addConstraint:[NSLayoutConstraint constraintWithItem:artworkView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//                 [self addConstraint:[NSLayoutConstraint constraintWithItem:artworkView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:-1]];
//                 [self addConstraint:[NSLayoutConstraint constraintWithItem:artworkView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
                
//                 // UIView *buddy = [[UIView alloc] init];
//                 // buddy.backgroundColor = [UIColor clearColor];
//                 // buddy.clipsToBounds = YES;
//                 // [[contentView1.contentView superview] addSubview:buddy];
//                 // [contentView1 setValue:buddy forKey:@"contentView"];
                
//                 MPUMediaControlsTitlesView *titles = [[NSClassFromString(@"MPUMediaControlsTitlesView") alloc] initWithMediaControlsStyle:0];
//                 [contentView1.contentView addSubview:titles];
//                 titles.frame = CGRectMake(0,(self.frame.size.height+40)/2,self.frame.size.width - self.frame.size.height-30, 40);
//                 titles.center = CGPointMake((self.frame.size.width-self.frame.size.height)/2, self.frame.size.height/2);
//                 [titles updateTrackInformationWithNowPlayingInfo:[self.playController currentNowPlayingInfo]];
//             }
//             if ([[[self icon] applicationBundleID] isEqualToString:@"com.apple.Maps"]) {
//                 self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 200,200)];
//                 [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"/var/mobile/Library/Widgets/FlipDate8/Widget.html"]]];
//                 self.webView.backgroundColor = [UIColor clearColor];
//                 self.webView.opaque = NO;
//                 self.webView.scrollView.scrollEnabled = NO;
//                 self.webView.scrollView.scrollsToTop = NO;
//                 self.webView.scrollView.showsHorizontalScrollIndicator = NO;
//                 self.webView.scrollView.showsVerticalScrollIndicator = NO;
//                 self.webView.scrollView.minimumZoomScale = 1.0;
//                 self.webView.scrollView.maximumZoomScale = 1.0;
//                 self.webView.scalesPageToFit = NO;
//                 self.webView.suppressesIncrementalRendering = YES;
//                 [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 1.0;"];
//                 [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//                 [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
//                 [viewTemp addSubview:self.webView];
//             }
//             reloadListViewWithIcon(self.icon);
//         }
//     } else {
//         [self._iconImageView setFrame:CGRectMake(self._iconImageView.frame.origin.x,self._iconImageView.frame.origin.y,[NSClassFromString(@"SBIconView") defaultIconImageSize].width,[NSClassFromString(@"SBIconView") defaultIconImageSize].height)];
//         [self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y,[NSClassFromString(@"SBIconView") defaultIconSize].width,[NSClassFromString(@"SBIconView") defaultIconSize].height)];
//         if (self.isBlockForm) {
//             self.isBlockForm = NO;
//             [[self viewWithTag:1313] removeFromSuperview];
//             reloadListViewWithIcon(self.icon);
//         }
//     }
// }

// %new
// - (void)fixLabels {
//     self.songLabel.translatesAutoresizingMaskIntoConstraints = NO;
// 				self.songLabel.font = [UIFont fontWithName:@".SFUIText-Regular" size:17];
// 				self.songLabel.text = (NSString *)[[self.playController currentNowPlayingInfo] objectForKey:@"kMRMediaRemoteNowPlayingInfoTitle"];
// 				self.songLabel.textColor = [UIColor whiteColor];
// 				//self.songLabel.opaque = NO;
// 				//self.songLabel.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithName:@"plusD"];
// 				[[self.songLabel superview] addConstraint:[NSLayoutConstraint constraintWithItem:self.songLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self.songLabel superview] attribute:NSLayoutAttributeLeft multiplier:1 constant:40]];
// 				[[self.songLabel superview] addConstraint:[NSLayoutConstraint constraintWithItem:self.songLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self.songLabel superview] attribute:NSLayoutAttributeCenterY multiplier:1 constant:2]];
				
// 				self.artistLabel.translatesAutoresizingMaskIntoConstraints = NO;
// 				self.artistLabel.font = [UIFont fontWithName:@".SFUIText-Regular" size:12];
// 				self.artistLabel.text = (NSString *)[[self.playController currentNowPlayingInfo] objectForKey:@"kMRMediaRemoteNowPlayingInfoArtist"];
// 				self.artistLabel.textColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0f];
// 				//self.artistLabel.opaque = NO;
// 				//self.artistLabel.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithName:@"plusD"];
// 				[[self.artistLabel superview] addConstraint:[NSLayoutConstraint constraintWithItem:self.artistLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:[self.artistLabel superview] attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
// 				[[self.artistLabel superview] addConstraint:[NSLayoutConstraint constraintWithItem:self.artistLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.songLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
// }
// %new
// - (UIImage *)updateArtwork {
//     if (!self.playController) self.playController = [[%c(MPUNowPlayingController) alloc] init];
//         [self.playController setShouldUpdateNowPlayingArtwork:YES];
//     [self.playController _updateCurrentNowPlaying];
    
//     return [UIImage imageWithImage:[self.playController currentNowPlayingArtwork] scaledToSize:CGSizeMake(self.frame.size.width-self.frame.size.height, self.frame.size.width-self.frame.size.height)];
// }
// %end

// @interface SBIconListView (WDXPinchGesture)
// @property (nonatomic, retain) UIView *pinchedIconView;
// @property (nonatomic, retain) SBIcon *pinchedIcon;
// @end
// CGFloat prevScale;
// %hook SBIconListView
// %property (nonatomic, retain) UIView *pinchedIconView;
// %property (nonatomic, retain) SBIcon *pinchedIcon;

// - (void)layoutIconsIfNeeded:(double)arg1 domino:(bool)arg2 {
//     if (isDropping) {
//         isDropping = NO;
//         %orig(0.0,NO);
//     }
//     else {
//         %orig;
//     }
// }


// - (void)cleanupAfterRotation {
//     %orig;
//     for (SBIcon *icon in [self visibleIcons]) {
//         if ([[IBIconHandler sharedHandler] containsBundleID:[icon applicationBundleID]]) {
//            SBIconView *iconView = [[NSClassFromString(@"SBIconViewMap") homescreenMap] mappedIconViewForIcon:icon];
//            [iconView reloadViews];
//         }
//     }
// }



// %new
// - (void)addPinchGesture {
    
//     UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(WDXHandlePinch:)];
//     [self addGestureRecognizer:pinch];
// }
// %new
// -(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
// {
//     CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
//                                    view.bounds.size.height * anchorPoint.y);
//     CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
//                                    view.bounds.size.height * view.layer.anchorPoint.y);
    
//     newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
//     oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
//     CGPoint position = view.layer.position;
    
//     position.x -= oldPoint.x;
//     position.x += newPoint.x;
    
//     position.y -= oldPoint.y;
//     position.y += newPoint.y;
    
//     view.layer.position = position;
//     view.layer.anchorPoint = anchorPoint;
// }
// %new
// - (void)WDXHandlePinch:(UIPinchGestureRecognizer *)sender {
    
    
//     if (sender.state == UIGestureRecognizerStateBegan) {
        
//         CGPoint point = [sender locationInView:self];
//         unsigned long long iconIndex;
//         NSLog(@"PINCHED ICON: %@", [self iconAtPoint:point index:&iconIndex]);
//         self.pinchedIcon = [self iconAtPoint:point index:&iconIndex];
//         SBIconView *iconView = [[NSClassFromString(@"SBIconViewMap") homescreenMap] mappedIconViewForIcon:[self iconAtPoint:point index:&iconIndex]];
//         iconView.backgroundColor = [UIColor clearColor];
//         if (!iconView.widgetView) {
//             UIView *tempo = [[UIView alloc] initWithFrame:CGRectMake(0,0,iconView.frame.size.width,iconView.frame.size.height)];
//             tempo.backgroundColor = [UIColor clearColor];
//             [iconView addSubview:tempo];
//             self.pinchedIconView = tempo;
//         }
//         else self.pinchedIconView = iconView.widgetView;
            
//             }
//     else if (sender.state == UIGestureRecognizerStateChanged) {
//         // if (sender.scale != 1) {
//         // 	if (sender.scale > 1) sender.scale += sender.scale/50;
//         // 	else sender.scale -= sender.scale/50;
//         // }
        
//         SBIconView *iconView = [[NSClassFromString(@"SBIconViewMap") homescreenMap] mappedIconViewForIcon:self.pinchedIcon];
        
//         [self setAnchorPoint:CGPointMake(0, 0) forView:iconView];
//         CGFloat xScale = sender.scale;
//         CGFloat yScale = sender.scale;
//         CGSize maxSize = [[IBIconHandler sharedHandler] sizeForBundleID:[self.pinchedIcon applicationBundleID]];
//         CGSize defaultSize = [%c(SBIconView) defaultIconSize];
//         if (sender.scale > 1) {
//             if (iconView.frame.size.width >= maxSize.width) xScale = 1.0;
//             if (iconView.frame.size.height >= maxSize.height) yScale = 1.0;
//             if (iconView.frame.size.width < defaultSize.width) xScale = 1.0;
//             if (iconView.frame.size.height < defaultSize.height) yScale = 1.0;
//         }
//         if (sender.scale < 1) {
//             xScale = 1;
//             yScale =1;
//         }
        
        
//         iconView.transform = CGAffineTransformScale(iconView.transform, xScale, yScale);
//         // if (newSize.size.width > maxSize.width ||  newSize.size.width < [%c(SBIconView) defaultIconSize].height) {
//         // 	newSize.size.width = self.pinchedIconView.frame.size.width;
//         // }
//         // if (newSize.size.height > maxSize.height || newSize.size.height < [%c(SBIconView) defaultIconSize].height) {
//         // 	newSize.size.height = self.pinchedIconView.frame.size.height;
//         // }
//         // self.pinchedIconView.frame = newSize;
//         prevScale = sender.scale;
//         sender.scale = 1.0;
//     }
// }
// // - (_Bool)compactIcons:(_Bool)arg1 {
// //	arg1 = NO;
// //	return %orig(arg1);
// // }
// %end
// %hook SBIconIndexMutableList
// - (NSArray *)nodes {
//     NSMutableArray *originalIcons = [%orig mutableCopy];
//     NSMutableArray *indexesToBeReplaced = [NSMutableArray new];
//     NSMutableArray *originalIconsFixed = [NSMutableArray arrayWithCapacity:[originalIcons count]];
//     NSMutableDictionary *fixedIcons = [NSMutableDictionary new];
//     NSMutableArray *nodesToRemove = [NSMutableArray new];
//     for (id object in originalIcons) {
//         if (![object isKindOfClass:[%c(SBWDXPlaceholderIcon) class]]) {
//             if ([object isKindOfClass:[%c(SBIcon) class]]) {
//                 NSString *bundleIdentifier = [(SBIcon *)object applicationBundleID];
//                 if ([[IBIconHandler sharedHandler] containsBundleID:bundleIdentifier]) {
//                     if ([[IBIconHandler sharedHandler] indexForBundleID:bundleIdentifier]) {
//                         [fixedIcons setObject:object forKey:[NSString stringWithFormat:@"%llu", [[IBIconHandler sharedHandler] indexForBundleID:bundleIdentifier]]];
//                         [nodesToRemove addObject:object];
//                     }
//                 }
//             }
//             [originalIconsFixed addObject:object];
//         }
//         else if ([object isKindOfClass:[%c(SBWDXPlaceholderIcon) class]]) {
//             [self removeNode:object];
//         }
//     }
//     [originalIcons setArray:originalIconsFixed];
//     for (int z = 0; z < [originalIcons count]; z++) {
//         if ([[originalIcons objectAtIndex:z] isKindOfClass:[%c(SBIcon) class]]) {
//             SBIcon *icon = [originalIcons objectAtIndex:z];
//             NSString *bundleIdentifier = [icon applicationBundleID];
//             if ([[IBIconHandler sharedHandler] containsBundleID:bundleIdentifier]) {
//                 for (int y = 0; y < [[IBIconHandler sharedHandler] verticalWidgetSizeForBundleID:bundleIdentifier]; y++) {
//                     for (int x = 0; x < [[IBIconHandler sharedHandler] horiztonalWidgetSizeForBundleID:bundleIdentifier]; x++) {
//                         if ((y == 0) && (x == 0)) {
//                             int w = z;
//                             if ([[IBIconHandler sharedHandler] indexForBundleID:bundleIdentifier]) {
//                                 w = [[IBIconHandler sharedHandler] indexForBundleID:bundleIdentifier];
//                                 NSNumber *indexWrapper = [NSNumber numberWithUnsignedLongLong:w];
//                                 if (![indexesToBeReplaced containsObject:indexWrapper]) {
//                                     [indexesToBeReplaced addObject:indexWrapper];
//                                 }
//                             }
//                         }
//                         else {
//                             int w = z;
//                             if ([[IBIconHandler sharedHandler] indexForBundleID:bundleIdentifier]) {
//                                 w = [[IBIconHandler sharedHandler] indexForBundleID:bundleIdentifier];
//                             }
//                             unsigned long long index = w+([%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] * y)+x;
//                             NSNumber *indexWrapper = [NSNumber numberWithUnsignedLongLong:index];
//                             if (![indexesToBeReplaced containsObject:indexWrapper]) {
//                                 [indexesToBeReplaced addObject:indexWrapper];
//                             }
//                         }
//                     }
//                 }
//             }
//         }
//     }
//     NSSortDescriptor *indexSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
//     [indexesToBeReplaced sortUsingDescriptors:[NSArray arrayWithObject:indexSortDescriptor]];
    
//     MSHookIvar<NSMutableArray*>(self,"_nodes") = originalIcons;
//     for (id object in nodesToRemove) {
//         [self removeNode:object];
//         [originalIcons removeObject:object];
//     }
//     int newCount = [originalIcons count];
//     for (NSNumber *index in indexesToBeReplaced) {
//         if ([index unsignedLongLongValue] < [NSClassFromString(@"SBIconListView") maxIcons]) {
//             if ([fixedIcons objectForKey:[NSString stringWithFormat:@"%llu", [index unsignedLongLongValue]]]) {
//                 if ([index unsignedLongLongValue] <= newCount) {
//                 [self insertNode:[fixedIcons objectForKey:[NSString stringWithFormat:@"%llu", [index unsignedLongLongValue]]] atIndex:[index unsignedLongLongValue]];
//                 newCount++;
//             }
//             }
//             else {
//                 if ([index unsignedLongLongValue] <= newCount) {
//                 [self insertNode:[[%c(SBWDXPlaceholderIcon) alloc] initWithIdentifier:[NSString stringWithFormat:@"WIDUXPlaceHolder-%llu", [index unsignedLongLongValue]]] atIndex:[index unsignedLongLongValue]];
//                 newCount++;
//             }
//             }
//         }
//     }
//     return [originalIcons copy];
// }
// %end
// %hook SBIconController
// -(BOOL)icon:(id)iconView canReceiveGrabbedIcon:(id)grabbedIconView {
//     if ([[IBIconHandler sharedHandler] containsBundleID:[[(SBIconView*)grabbedIconView icon] applicationBundleID]] || [[IBIconHandler sharedHandler] containsBundleID:[[(SBIconView*)iconView icon] applicationBundleID]]) {
//         return NO;
//     }
//     if ([[(SBIconView*)grabbedIconView icon] isKindOfClass:[NSClassFromString(@"SBWDXPlaceholderIcon") class]] || [[(SBIconView*)iconView icon] isKindOfClass:[NSClassFromString(@"SBWDXPlaceholderIcon") class]]) {
//         return NO;
//     }
//     return %orig;
// }
// - (BOOL)folderController:(SBFolderView *)controller draggedIconDidPauseAtLocation:(CGPoint)draggedIcon inListView:(SBIconListView *)listView {
//     NSUInteger pauseIndex;
//     int propose;
//     [listView iconAtPoint:draggedIcon index:&pauseIndex proposedOrder:&propose grabbedIcon:[self grabbedIcon]];
//     // if ([[IBIconHandler sharedHandler] containsBundleID:[[self grabbedIcon] applicationBundleID]]) {
//     //	SBIconCoordinate coordinate = [listView iconCoordinateForIndex:pauseIndex forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
//     //	if (coordinate.col + [[IBIconHandler sharedHandler] horiztonalWidgetSizeForBundleID:[[self grabbedIcon] applicationBundleID]] > [%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]-1) {
//     //		coordinate = SBIconCoordinateMake(coordinate.row, coordinate.col-1);
//     //	}
//     //	if (coordinate.row + [[IBIconHandler sharedHandler] verticalWidgetSizeForBundleID:[[self grabbedIcon] applicationBundleID]] > [%c(SBIconListView) iconRowsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]) {
//     //		coordinate = SBIconCoordinateMake(coordinate.row-1, coordinate.col);
//     //	}
//     //	pauseIndex = [listView indexForCoordinate:coordinate forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
//     // }
//     if (pauseIndex != previousPauseIndex) {
//         if ([self grabbedIcon]) {
//             if ([[IBIconHandler sharedHandler] containsBundleID:[[self grabbedIcon] applicationBundleID]]) {
//                 SBIcon *icon = [[listView model] iconAtIndex:pauseIndex];
//                 if ([icon isPlaceholder]) {
//                     if (![icon isEmptyPlaceholder]) {
//                         while ([listView containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
//                             [self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
//                         }
//                     }
//                 }
//             }
//         }
//     }
    
//     previousPauseIndex = pauseIndex;
    
//     // [self compactIconsInIconListsInFolder:[controller folder] moveNow:YES limitToIconList:listView];
//     BOOL proposedReturn = %orig;
//     if ([self grabbedIcon]) {
//         if (proposedReturn == TRUE && [[IBIconHandler sharedHandler] containsBundleID:[[self grabbedIcon] applicationBundleID]]) {
//             while ([listView containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
//                 [self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
//             }
//             for (int y = 0; y < [[IBIconHandler sharedHandler] verticalWidgetSizeForBundleID:[[self grabbedIcon] applicationBundleID]]; y++) {
//                 for (int x = 0; x < [[IBIconHandler sharedHandler] horiztonalWidgetSizeForBundleID:[[self grabbedIcon] applicationBundleID]]; x++) {
//                     unsigned long long index = pauseIndex+([%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] * y)+x;
//                     if ((x == 0) && (y == 0)) {
                        
//                     }
//                     [self insertIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] intoListView:listView iconIndex:index moveNow:NO];
//                 }
//             }
//         }
//     }
//     return proposedReturn;
// }

// - (_Bool)folderController:(SBFolderView *)controller draggedIconDidMoveFromListView:(SBIconListView *)fromList toListView:(SBIconListView *)toList {
    
//     BOOL proposedReturn = %orig;
    
//     if (proposedReturn == TRUE) {
//         if ([self grabbedIcon]) {
//             if ([[IBIconHandler sharedHandler] containsBundleID:[[self grabbedIcon] applicationBundleID]]) {
//                 while ([fromList containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
//                     [self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
//                 }
//                 while ([toList containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
//                     [self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
//                 }
//             }
//         }
//         return TRUE;
//     }
//     else return FALSE;
// }

// - (void)_dropIcon:(SBIcon *)icon withInsertionPath:(id)insertionPath {
//     SBIconListView *listView;
//     [[objc_getClass("SBIconController") sharedInstance] getListView:&listView folder:nil relativePath:nil forIndexPath:insertionPath createIfNecessary:YES];
//     if ([[IBIconHandler sharedHandler] containsBundleID:[icon applicationBundleID]]) {
        
//         while ([listView containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
//             [self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
//         }
        
//         SBIconCoordinate coordinate = [listView iconCoordinateForIndex:[insertionPath indexAtPosition:[insertionPath length] - 1] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
//         while (coordinate.col + [[IBIconHandler sharedHandler] horiztonalWidgetSizeForBundleID:[icon applicationBundleID]] -1 > [%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]) {
//             coordinate = SBIconCoordinateMake(coordinate.row, coordinate.col-1);
//         }
//         while (coordinate.row + [[IBIconHandler sharedHandler] verticalWidgetSizeForBundleID:[icon applicationBundleID]] -1 > [%c(SBIconListView) iconRowsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]) {
//             coordinate = SBIconCoordinateMake(coordinate.row-1, coordinate.col);
//         }
//         insertionPath = [NSIndexPath indexPathForRow:[listView indexForCoordinate:coordinate forOrientation:[[UIApplication sharedApplication] statusBarOrientation]] inSection:[(NSIndexPath*)insertionPath section]];
//         [[IBIconHandler sharedHandler] setIndex:[listView indexForCoordinate:coordinate forOrientation:[[UIApplication sharedApplication] statusBarOrientation]] forBundleID:[icon applicationBundleID]];
//         isDropping = YES;
//     }
//     %orig(icon, insertionPath);
// }
// %end

// %hook SBFolderController
// - (void)_resetDragPauseTimerForPoint:(struct CGPoint)point inIconListView:(SBIconListView *)listView {
//     if ([[IBIconHandler sharedHandler] containsBundleID:[(SBIcon*)[self valueForKey:@"grabbedIcon"] applicationBundleID]]) { // If dragged icon is a widget
//         SBIconView *draggedIconView = [[NSClassFromString(@"SBIconViewMap") homescreenMap] mappedIconViewForIcon:[self valueForKey:@"grabbedIcon"]];
//         NSLog(@"DRAGGED ICON VIEW: %@", draggedIconView);
//         CGPoint properPausePoint = CGPointMake(draggedIconView.frame.origin.x + [%c(SBIconView) defaultIconSize].width/2, draggedIconView.frame.origin.y + [%c(SBIconView) defaultIconSize].height/2);
//         point = properPausePoint;
//     }
//     %orig;
// }


// - (void)noteGrabbedIconDidChange:(id)arg1 {
//     %orig;
//     previousPauseIndex = -1;
// }
// %end


// %hook SBIconStateArchiver

// + (id)_representationForIcon:(SBIcon *)icon {
//     if ([icon isPlaceholder]) {
//         if (![icon isEmptyPlaceholder]) {
//             if (![icon referencedIcon]) {
//                 return 0;
//             }
//         }
//     }
//     return %orig;
// }
// %end

// %hook MPUNowPlayingController
// - (BOOL)shouldUpdateNowPlayingArtwork {
//     return TRUE;
// }
// %end


// %group MusicWidget

// @interface SpringBoard : NSObject
// @property (nonatomic, retain) MusicRemoteController *musicRemote;
// @end

// %hook SpringBoard

// %property (nonatomic, retain) MusicRemoteController *musicRemote;

// %new
// - (MusicRemoteController *)remoteController {
//     if (!self.musicRemote) self.musicRemote = [[NSClassFromString(@"MusicRemoteController") alloc] initWithPlayer:[NSClassFromString(@"MusicAVPlayer") sharedAVPlayer]];
//         return self.musicRemote;
// }
// %end


// %end


// %hook SBApplicationShortcutStoreManager
// - (id)shortcutItemsForBundleIdentifier:(NSString*)arg1 {
    
//     NSArray *aryItems = [NSArray new];
//     if (%orig != NULL || %orig != nil) {
        
//         aryItems = %orig;
//     }
//     NSMutableArray *aryShortcuts = [aryItems mutableCopy];
    
//     SBSApplicationShortcutItem *newAction = [[NSClassFromString(@"SBSApplicationShortcutItem") alloc] init];
//     [newAction setLocalizedTitle:@"\"iOS Block\""];
    
//     if ([[[IBIconHandler sharedHandler] icons] containsObject:arg1]) {
        
//         [newAction setLocalizedSubtitle:@"Make me a Icon"];
//     }
    
//     else {
        
//         [newAction setLocalizedSubtitle:@"Make me a Block"];
//     }
    
//     [newAction setType:[NSString stringWithFormat:@"%@*_*iOSBlockMe",arg1]];
//     [aryShortcuts addObject:newAction];
    
//     return aryShortcuts;
// }
// %end

// %hook SBApplicationShortcutMenu

// - (void)menuContentView:(id)arg1 activateShortcutItem:(UIApplicationShortcutItem*)arg2 index:(long long)arg3 {
    
//     NSString *input = arg2.type;
    
//     if ([input containsString:@"*_*"]) {
        
//         NSArray *arySplitString = [input componentsSeparatedByString:@"*_*"];
//         NSString *bundleID = [arySplitString objectAtIndex:0];
//         [self dismissAnimated:YES completionHandler:nil];
        
//         if ([[IBIconHandler sharedHandler] containsBundleID:bundleID]) {
            
//             [[IBIconHandler sharedHandler] removeObject:bundleID];
//         }
//         else {
//             if ([bundleID isEqualToString:@"com.apple.Music"]) {
//                 [[IBIconHandler sharedHandler] setHoriztonalWidgetSize:4 forBundleID:bundleID];
//                 [[IBIconHandler sharedHandler] setVerticalWidgetSize:1 forBundleID:bundleID];
//                 //[[IBIconHandler sharedHandler] setIndex:4 forBundleID:bundleID];
//             }
//             else if ([bundleID isEqualToString:@"com.apple.Maps"]) {
//                 [[IBIconHandler sharedHandler] setHoriztonalWidgetSize:2 forBundleID:bundleID];
//                 [[IBIconHandler sharedHandler] setVerticalWidgetSize:2 forBundleID:bundleID];
//                 //[[IBIconHandler sharedHandler] setIndex:4 forBundleID:bundleID];
//             }
//             else {
//                 [[IBIconHandler sharedHandler] setHoriztonalWidgetSize:2 forBundleID:bundleID];
//                 [[IBIconHandler sharedHandler] setVerticalWidgetSize:2 forBundleID:bundleID];
//             }
            
//             [[IBIconHandler sharedHandler] addObject:bundleID];
//         }
        
//         [[NSNotificationCenter defaultCenter] postNotificationName:@"IBIconNeedsLayout" object:nil];
        
//     }
//     else {
        
//         %orig;
//     }
// }
// %end

// %ctor {
//     %init;
//     %init(MusicWidget);
//     // [[IBIconHandler sharedHandler] addObject:[NSString stringWithFormat:@"com.apple.Music"]];
//     [[IBIconHandler sharedHandler] setHoriztonalWidgetSize:4 forBundleID:@"com.apple.Music"];
//     [[IBIconHandler sharedHandler] setVerticalWidgetSize:1 forBundleID:@"com.apple.Music"];
//     // [[IBIconHandler sharedHandler] setIndex:4 forBundleID:@"com.apple.Music"];
    
// }
