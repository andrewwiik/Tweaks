//
//  IBKWidgetViewController.m
//  curago
//
//  Created by Matt Clarke on 10/06/2014.
//
//

/*
 TODO:
 
 - Add in listener to settings changes so we can adjust as necessary
 - Implement loading from binary and error handling.
 - Finish rotation handling
 
*/

#import "IBKWidgetViewController.h"
#import "IBKResources.h"
#import "IBKAPI.h"

#import <SpringBoard7.0/SBIconController.h>
#import <SpringBoard7.0/SBIconModel.h>
#import <SpringBoard7.0/SBApplicationController.h>
#import <SpringBoard7.0/SBApplication.h>
#import <objc/runtime.h>
#import "UIImageAverageColorAddition.h"
#import "CKBlurView.h"
#import "IBKNotificationsTableCell.h"
#import <BulletinBoard/BBBulletin.h>
#import <BulletinBoard/BBServer.h>
#import <SpringBoard7.0/SBRootFolder.h>

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define is_IOS7_0 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.10)
#define orient [[UIApplication sharedApplication] statusBarOrientation]

@interface IBKWidgetViewController ()

@end

@interface SBApplicationController (iOS8)
-(id)applicationWithBundleIdentifier:(NSString*)arg1;
@end

@interface SBIconImageView (iOS7_1)
- (void)setIcon:(id)arg1 location:(int)arg2 animated:(BOOL)arg3;
@end

@interface BBServer (Additions)
+(id)sharedIBKBBServer;
- (id)_bulletinsForSectionID:(id)arg1 inFeeds:(unsigned int)arg2;
@end

@interface SBIconController (Additions)
-(void)removeIdentifierFromWidgets:(NSString*)identifier;
-(void)removeAllCachedIcons;
@end

@interface SBIconModel (iOS8)
- (id)applicationIconForBundleIdentifier:(id)arg1;
@end

@implementation IBKWidgetViewController

-(SBIconListView *)IBKListViewForIdentifierTwo:(NSString*)identifier {
    SBIconController *viewcont = [objc_getClass("SBIconController") sharedInstance];
    SBIconModel *model = [viewcont model];
    SBIcon *icon = [model expectedIconForDisplayIdentifier:identifier];
    
    SBIconController *controller = [objc_getClass("SBIconController") sharedInstance];
    SBRootFolder *rootFolder = [controller valueForKeyPath:@"rootFolder"];
    NSIndexPath *indexPath = [rootFolder indexPathForIcon:icon];
    SBIconListView *listView = nil;
    [controller getListView:&listView folder:NULL relativePath:NULL forIndexPath:indexPath createIfNecessary:YES];
    return listView;
}

-(void)loadView {
    // Begin building our base widget view
    
    CGRect initialFrame = CGRectMake(0, 0, [IBKResources widthForWidget], [IBKResources heightForWidget]);
    
    topBase = [IBKWidgetTopBase buttonWithType:UIButtonTypeCustom];
    topBase.frame = initialFrame;
    topBase.backgroundColor = [UIColor clearColor];
    topBase.layer.cornerRadius = 12;
    topBase.layer.masksToBounds = YES;
    topBase.userInteractionEnabled = YES;
    
    [topBase addTarget:self action:@selector(didTapTopBase:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *baseView = [[UIView alloc] initWithFrame:initialFrame];
    baseView.alpha = 1.0;
    baseView.userInteractionEnabled = YES;
    baseView.layer.cornerRadius = 12;
    baseView.layer.masksToBounds = NO;
    baseView.layer.shadowOffset = CGSizeZero;
    baseView.layer.shadowOpacity = 0.3;
    baseView.hidden = YES;
    // Center is configured by IBKIconView
    
    [baseView addSubview:topBase];
    
    self.view = baseView;
}

-(void)didTapTopBase:(id)sender {} // This is just a stub to ensure the topbase view prevents touches as required.

-(UIView*)topBase {
    return topBase;
}

-(CGRect)frameForWidget {
    SBIconListView *listView = [self IBKListViewForIdentifierTwo:self.applicationIdentifer];
    
    CGFloat spacingX, spacingY, width, height;
    
    int iconsInRow = [listView iconsInRowForSpacingCalculation];
    
    CGFloat wid = [UIScreen mainScreen].bounds.size.width;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 && isPad) {
        if (orient == 3 || orient == 4)
            wid = [UIScreen mainScreen].bounds.size.height;
    }
    
    spacingX = wid - ((CGFloat)iconsInRow * (isPad ? 72 : 58));
    spacingX /= (CGFloat)iconsInRow;
    
    NSLog(@"Spacings are %f x, %f y", spacingX, spacingY);
    
    width = (isPad ? 72 : 58);
    height = (isPad ? 72 : 58);
    
    return CGRectMake(0, 0, spacingX + (2*width), spacingY + (2*height));
}

-(void)lockWidget {
    if ([IBKResources isWidgetLocked:[IBKResources getRedirectedIdentifierIfNeeded:self.applicationIdentifer]]) {
        // Hide everything on top of the topBase, and show locked UI
        self.isLocked = YES;
        
        self.viw.alpha = 0.0;
        self.buttons.alpha = 0.0;
        self.alternateIcon.alpha = 0.0;
        self.otherIcon.alpha = 0.0;
        self.iconImageView.alpha = 1.0;
        self.iconImageView.hidden = NO;
        self.notificationsTableView.alpha = 0.0;
        self.gcTableView.alpha = 0.0;
        self.webView.alpha = 0.0;
        self.noNotifsLabel.alpha = 0.0;
        
        [self.lockView removeFromSuperview];
        self.lockView = nil;
        
        self.lockView = [[IBKWidgetLockView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [IBKAPI heightForContentView]) passcodeHash:[IBKResources passcodeHash] isLight:self.isLight];
        self.lockView.delegate = self;
        [topBase addSubview:self.lockView];
        
        self.lockView.alpha = 1.0;
        self.lockView.hidden = NO;
    }
}

-(void)unlockWidget {
    // set up from
    CATransform3D fromViewRotationPerspectiveTrans = CATransform3DIdentity;
    fromViewRotationPerspectiveTrans.m34 = -0.003; // 3D ish effect
    fromViewRotationPerspectiveTrans = CATransform3DRotate(fromViewRotationPerspectiveTrans, M_PI_2, 0.0f, -1.0f, 0.0f);
    
    // set up to
    CATransform3D toViewRotationPerspectiveTrans = CATransform3DIdentity;
    toViewRotationPerspectiveTrans.m34 = -0.003;
    toViewRotationPerspectiveTrans = CATransform3DRotate(toViewRotationPerspectiveTrans, M_PI_2, 0.0f, 1.0f, 0.0f);
    
    [UIView animateWithDuration:0.3 delay:0.15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.layer.transform = fromViewRotationPerspectiveTrans;
    } completion:^(BOOL finished) {
        self.view.layer.transform = toViewRotationPerspectiveTrans;
        
        self.lockView.alpha = 0.0;
        self.viw.alpha = 1.0;
        self.buttons.alpha = 1.0;
        self.alternateIcon.alpha = 1.0;
        self.otherIcon.alpha = 1.0;
        if (self.alternateIcon || self.otherIcon)
            self.iconImageView.alpha = 0.0;
        else
            self.iconImageView.alpha = 1.0;
        self.notificationsTableView.alpha = 1.0;
        self.gcTableView.alpha = 1.0;
        self.webView.alpha = 1.0;
        
        if ([self.notificationsDataSource count] == 0)
            self.noNotifsLabel.alpha = 1.0;
        else
            self.noNotifsLabel.alpha = 0.0;
        
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 0.0);
        } completion:^(BOOL finished) {
            self.lockView.hidden = YES;
            if (self.alternateIcon)
                self.iconImageView.hidden = YES;
            
            self.isLocked = NO;
        }];
                         
    }];
}

-(void)loadWidgetInterface {
    if (!self.view) {
        [self loadView];
    }
    
    self.view.hidden = NO;
    
    // We need our icon image view here - the widget may define it's own icon
    [self setupIconImageView];
    
    // Fix up animations for the icon's badge.
    NSString *path = [NSString stringWithFormat:@"%@/Info.plist", [self getPathForMainBundle]];
    
    NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile:path];
    
    // Set our background colour to the average of the app's icon.
    switch ([IBKResources defaultColourType]) {
        case 1:
            self.view.backgroundColor = [(UIImage*)[(SBIconImageView*)self.iconImageView squareContentsImage] dominantColor];
            break;
            
        case 0:
        default:
            self.view.backgroundColor = [(UIImage*)[(SBIconImageView*)self.iconImageView squareContentsImage] mergedColor];
            break;
    }
    
    
    // Double check for GameCenter
    SBApplication* app;
    if (![[objc_getClass("SBApplicationController") sharedInstance] respondsToSelector:@selector(applicationWithBundleIdentifier:)])
        app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithDisplayIdentifier:self.applicationIdentifer];
    else
        app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:self.applicationIdentifer];
    
    if ([app hasGameCenterData] && ![[infoPlist objectForKey:@"customGameWidget"] boolValue]) {
        [self loadForGameCenter:infoPlist];
    } else if (!infoPlist || [[infoPlist objectForKey:@"wantsNotificationsTable"] boolValue]) {
        [self loadForNotificationsTable:infoPlist];
    } else {
        // Load up widget UI from NSBundle.
        if ([infoPlist[@"usesHTML"] boolValue]) {
            self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [IBKResources widthForWidget], ([infoPlist[@"hasButtons"] boolValue] ? [IBKResources heightForWidget] : self.iconImageView.frame.origin.y-9))];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[self getPathForMainBundle] stringByAppendingString:@"/Widget.html"]]]];
            self.webView.backgroundColor = [UIColor clearColor];
            self.webView.opaque = NO;
            self.webView.scrollView.scrollEnabled = NO;
            self.webView.scrollView.scrollsToTop = NO;
            self.webView.scrollView.showsHorizontalScrollIndicator = NO;
            self.webView.scrollView.showsVerticalScrollIndicator = NO;
            self.webView.scrollView.minimumZoomScale = 1.0;
            self.webView.scrollView.maximumZoomScale = 1.0;
            self.webView.scalesPageToFit = NO;
            self.webView.suppressesIncrementalRendering = YES;
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 1.0;"];
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
            [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
            [topBase addSubview:self.webView];
        } else {
            // obj-c, it is.
            if (self.bundle) {
                [self.bundle unload];
                self.bundle = nil;
            }
            
            self.bundle = [NSBundle bundleWithPath:[[self getPathForMainBundle] stringByAppendingString:@"/"]];
            [self.bundle load];
            
            Class instance;
            
            if ((instance = [self.bundle principalClass])) {
                self.widget = [[instance alloc] init];
                [self setupForObjC];
            }
        }
        
        // Now that the view is sorted, load custom icon, set custom background.
        [self setColorAndOrIcon:infoPlist];
    }
    
    self.shimIcon = [[objc_getClass("SBIconImageView") alloc] initWithFrame:CGRectMake(0, 0, [IBKResources heightForWidget], [IBKResources heightForWidget])];
    
    if ([[self iconImageView] respondsToSelector:@selector(setIcon:animated:)])
        [(SBIconImageView*)[self shimIcon] setIcon:[(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] applicationIconForDisplayIdentifier:self.applicationIdentifer] animated:NO];
    else if ([(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] respondsToSelector:@selector(applicationIconForDisplayIdentifier:)])
        [(SBIconImageView*)[self shimIcon] setIcon:[(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] applicationIconForDisplayIdentifier:self.applicationIdentifer] location:2 animated:NO];
    else // iOS 8
        [(SBIconImageView*)[self shimIcon] setIcon:[(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] applicationIconForBundleIdentifier:self.applicationIdentifer] location:2 animated:NO];
    
    [self.view addSubview:self.shimIcon];
    
    self.shimIcon.frame = CGRectMake(0, 0, [IBKResources heightForWidget], [IBKResources heightForWidget]);
    self.shimIcon.center = CGPointMake([IBKResources widthForWidget]/2, [IBKResources heightForWidget]/2);
    self.shimIcon.backgroundColor = [UIColor clearColor];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.view addGestureRecognizer:pinch];
    
    // Background color setup.
    self.isLight = [IBKNotificationsTableCell isSuperviewColourationBright:(self.gradientLayer ? [UIColor colorWithCGColor:(__bridge CGColorRef)(self.gradientLayer.colors[0])] : self.view.backgroundColor)];
    
    CGFloat red, green, blue;
    [self.view.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.0];
    self.gradientLayer.opacity = 0.0;
    
    [self setupTransparentWidgetIfNeeded:infoPlist];
    
    self.isWidgetLoaded = YES;
    
    [self lockWidget];
}

-(UIColor*)colorFromString:(NSString*)arg1 {
    NSString *cleanString = [arg1 stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(BOOL)objcWidgetHasGradient {
    return [self.widget respondsToSelector:@selector(wantsGradientBackground)] && [self.widget wantsGradientBackground] && [self.widget respondsToSelector:@selector(gradientBackgroundColors)];
}

-(void)setupTransparentWidgetIfNeeded:(NSDictionary*)infoPlist {
    if ([IBKResources transparentBackgroundForWidgets] && [IBKResources showBorderWhenTransparent]) {
        // We have a transparent background with border.
        
        NSString *colorHex;
        UIColor *final;
        
        if (infoPlist[@"customGradientColors"] || [self objcWidgetHasGradient]) {
            if ([self.widget respondsToSelector:@selector(gradientBackgroundColors)]) {
                colorHex = [self.widget gradientBackgroundColors][0];
            } else if ([self.widget respondsToSelector:@selector(gradientBackgroundColorsUIColor)]) {
                final = [self.widget gradientBackgroundColorsUIColor][0];
            } else {
                colorHex = infoPlist[@"customGradientColors"][0];
            }
        } else if (infoPlist[@"customColor"] || [self.widget respondsToSelector:@selector(customHexColor)]) {
            // Color is saved as a hex string; #FFFFFF.
            
            if ([self.widget respondsToSelector:@selector(customHexColor)]) {
                colorHex = [self.widget customHexColor];
            } else {
                colorHex = infoPlist[@"customColor"];
            }
        } else {
            CGFloat red, green, blue;
            [self.view.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
            final = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        }
        
        if (!final && colorHex) {
            final = [self colorFromString:colorHex];
        }
        
        CGFloat red, green, blue;
        [final getRed:&red green:&green blue:&blue alpha:nil];
        
        final = [UIColor colorWithRed:red green:green blue:blue alpha:0.0];
        
        self.view.layer.borderColor = final.CGColor;
        self.view.layer.borderWidth = 1.5;
    }
}

-(void)setColorAndOrIcon:(NSDictionary*)infoPlist {
    if (infoPlist[@"customGradientColors"] || [self objcWidgetHasGradient]) {
        
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.anchorPoint = CGPointZero;
        self.gradientLayer.startPoint = CGPointMake(0.5f, 1.0f);
        self.gradientLayer.endPoint = CGPointMake(0.5f, 0.0f);
        
        NSMutableArray *colors = [NSMutableArray arrayWithObjects:nil];
        
        if ([self.widget respondsToSelector:@selector(gradientBackgroundColors)]) {
            for (NSString *string in [self.widget gradientBackgroundColors]) {
                [colors addObject:(id)[self colorFromString:string].CGColor];
            }
        } else if ([self.widget respondsToSelector:@selector(gradientBackgroundColorsUIColor)]) {
            for (UIColor *color in [self.widget gradientBackgroundColorsUIColor]) {
                [colors addObject:(id)color.CGColor];
            }
        } else {
            for (NSString *string in infoPlist[@"customGradientColors"]) {
                [colors addObject:(id)[self colorFromString:string].CGColor];
            }
        }
        
        self.gradientLayer.colors = colors;
        self.gradientLayer.bounds = CGRectMake(0, 0, self.viw.frame.size.width, self.viw.frame.size.height);
        
        [self.topBase.layer insertSublayer:self.gradientLayer atIndex:0];
    } else if (infoPlist[@"customColor"] || [self.widget respondsToSelector:@selector(customHexColor)]) {
        // Color is saved as a hex string; #FFFFFF.
        
        if ([self.widget respondsToSelector:@selector(customHexColor)]) {
            self.view.backgroundColor = [self colorFromString:[self.widget customHexColor]];
        } else {
            self.view.backgroundColor = [self colorFromString:infoPlist[@"customColor"]];
        }
    }
    
    UIImage *iconfile = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon%@", [self getPathForMainBundle], [IBKResources suffix]]];
    
    if (iconfile || [self.widget respondsToSelector:@selector(alternativeIconViewWithFrame:)]) {
        // Deal with loading up the custom icon.
        
        self.iconImageView.hidden = YES;
        
        if ([self.widget respondsToSelector:@selector(alternativeIconViewWithFrame:)] && [self.widget hasAlternativeIconView]) {
            self.alternateIcon = [self.widget alternativeIconViewWithFrame:self.iconImageView.frame];
            self.alternateIcon.backgroundColor = [UIColor clearColor];
            [topBase addSubview:self.alternateIcon];
        } else {
            self.otherIcon = [[UIImageView alloc] initWithImage:iconfile];
            self.otherIcon.frame = self.iconImageView.frame;
            self.otherIcon.backgroundColor = [UIColor clearColor];
        
            [topBase addSubview:self.otherIcon];
        }
    } else {
        // Bring icon back up to top view
        [topBase addSubview:self.iconImageView];
    }
}

-(void)setupIconImageView {
    self.iconImageView = [[objc_getClass("SBIconImageView") alloc] initWithFrame:CGRectMake(10, [IBKResources heightForWidget]-(isPad ? 60 : 40), (isPad ? 60 : 40), (isPad ? 60 : 40))];
    
    if ([[self iconImageView] respondsToSelector:@selector(setIcon:animated:)])
        [(SBIconImageView*)[self iconImageView] setIcon:[(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] applicationIconForDisplayIdentifier:self.applicationIdentifer] animated:NO];
    else if ([(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] respondsToSelector:@selector(applicationIconForDisplayIdentifier:)])
        [(SBIconImageView*)[self iconImageView] setIcon:[(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] applicationIconForDisplayIdentifier:self.applicationIdentifer] location:2 animated:NO];
    else // iOS 8
        [(SBIconImageView*)[self iconImageView] setIcon:[(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] applicationIconForBundleIdentifier:self.applicationIdentifer] location:2 animated:NO];
    
    self.iconImageView.frame = CGRectMake(7, [IBKResources heightForWidget]-(isPad ? 50 : 30)-7, (isPad ? 50 : 30), (isPad ? 50 : 30));
    self.iconImageView.alpha = 0.0;
    self.iconImageView.layer.shadowOpacity = 0.15;
    self.iconImageView.layer.shadowOffset = CGSizeZero;
    self.iconImageView.layer.shadowRadius = 5.0;
    
    [topBase addSubview:self.iconImageView];
}

-(void)setupForObjC {
    // Setup content view
    
    BOOL hasButtons = [self.widget hasButtonArea];
    
    /*
     * Having buttons means that we have a fade applied to the content view.
     *
     * Additionally, the content area does not mask to bounds, but the underlying widget does,
     * therefore full widget backgrounds are possible if needs be.
     */
    
    self.viw = [self.widget viewWithFrame:CGRectMake(0, 0, [IBKResources widthForWidget], [IBKResources heightForWidget]) isIpad:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)];
    self.viw.backgroundColor = [UIColor clearColor];
    [topBase addSubview:self.viw];
    
    if (hasButtons) {
        /*
         * Here, we need to add the button view next to the icon, and then also ensure that
         * the content view is faded appropriately.
         */
        
        @try {
            CGFloat originx = self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 4;
            self.buttons = [self.widget buttonAreaViewWithFrame:CGRectMake(originx, self.iconImageView.frame.origin.y, [IBKResources widthForWidget] - originx - 8, self.iconImageView.frame.size.height)];
            self.buttons.backgroundColor = [UIColor clearColor];
            [topBase addSubview:self.buttons];
        } @catch (NSException *e) {
            NSLog(@"\n\n%@\n\nPlease ensure you have implemented -buttonAreaViewWithFrame: within your widget if -hasButtonArea is returning YES!", e);
        }
        
        // Apply fade to content view.
        
        BOOL wantsNoFade = [self.widget respondsToSelector:@selector(wantsNoContentViewFadeWithButtons)];
        
        if (wantsNoFade) {
            wantsNoFade = [self.widget wantsNoContentViewFadeWithButtons];
        }
        
        if (!wantsNoFade) {
            CAGradientLayer *grad = [CAGradientLayer layer];
            grad.anchorPoint = CGPointZero;
            grad.startPoint = CGPointMake(0.5f, 1.0f);
            grad.endPoint = CGPointMake(0.5f, 0.25f);
        
            UIColor *innerColour = [UIColor colorWithWhite:1.0 alpha:1.0];
        
            NSArray *colors = [NSArray arrayWithObjects:
                           (id)[innerColour CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.975f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.95f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.9f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.8f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.7f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.6f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.5f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.4f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.3f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.2f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.1f] CGColor],
                           (id)[[UIColor clearColor] CGColor],
                           nil];
        
            colors = [[colors reverseObjectEnumerator] allObjects];
        
            grad.colors = colors;
            grad.bounds = CGRectMake(0, 0, self.viw.frame.size.width, self.iconImageView.frame.origin.y + (self.iconImageView.frame.size.height/4));
        
            self.viw.layer.mask = grad;
        }
    }
}

-(NSMutableArray*)orderedArrayForNotifications:(NSMutableArray*)array {
    for (int i = 1; i < [array count]; i++) {
        for (int j = 0; j < [array count] - 1; j++) {
            NSDate *firstDate = [(BBBulletin*)array[j] date];
            NSDate *secondDate = [(BBBulletin*)array[j + 1] date];
            
            if ([secondDate timeIntervalSinceDate:firstDate] > 0) {
                BBBulletin *temp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = temp;
            }
        }
    }
    
    return array;
}

-(void)loadForNotificationsTable:(NSDictionary*)infoPlist {
    // Create table view.
    
    CGRect frame = self.view.frame;
    frame.origin = CGPointZero;
    
    self.notificationsDataSource = [NSMutableArray array];
    
    // Fill the array with notifications
    
    BBServer *server = [objc_getClass("BBServer") sharedIBKBBServer];
    for (BBBulletin *bulletin in [server _allBulletinsForSectionID:self.applicationIdentifer])
        [self.notificationsDataSource addObject:bulletin];
    
    self.notificationsDataSource = [self orderedArrayForNotifications:self.notificationsDataSource];
    
    NSLog(@"Bulletins array == %@", self.notificationsDataSource);
    
    CGRect initialFrame = CGRectMake(10, 7, [IBKResources widthForWidget]-14, self.iconImageView.frame.origin.y-9);
    
    self.notificationsTableView = [[UITableView alloc] initWithFrame:initialFrame style:UITableViewStylePlain];
    
    self.notificationsTableView.delegate = self;
    self.notificationsTableView.dataSource = self;
    self.notificationsTableView.backgroundColor = [UIColor clearColor];
    self.notificationsTableView.showsVerticalScrollIndicator = YES;
    self.notificationsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.notificationsTableView.allowsSelection = NO;
    self.notificationsTableView.layer.masksToBounds = NO;
    
    [self.notificationsTableView registerClass:[IBKNotificationsTableCell class] forCellReuseIdentifier:@"notificationTableCell"];
    
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.anchorPoint = CGPointZero;
    grad.startPoint = CGPointMake(0.5f, 1.0f);
    grad.endPoint = CGPointMake(0.5f, 0.5f);
    
    UIColor *innerColour = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[innerColour CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.975f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.95f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.9f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.8f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.7f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.6f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.5f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.4f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.3f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.2f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.1f] CGColor],
                       (id)[[UIColor clearColor] CGColor],
                       nil];
    
    colors = [[colors reverseObjectEnumerator] allObjects];
    
    grad.colors = colors;
    grad.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.iconImageView.frame.origin.y + (self.iconImageView.frame.size.height/4));
    
    UIView *tableViewBase = [[UIView alloc] initWithFrame:topBase.frame];
    tableViewBase.backgroundColor = [UIColor clearColor];
    
    tableViewBase.layer.mask = grad;
    
    [topBase addSubview:tableViewBase];
    
    [tableViewBase addSubview:self.notificationsTableView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (BBBulletin *bulletin in self.notificationsDataSource) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:[self.notificationsDataSource indexOfObject:bulletin] inSection:0]];
        }
        
        [self.notificationsTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    
    // If no notifications, say so
    self.noNotifsLabel = [[IBKLabel alloc] initWithFrame:CGRectMake(20, 10, [IBKResources widthForWidget]-40, [IBKResources heightForWidget]-(isPad ? 50 : 30))];
    self.noNotifsLabel.text = @"No notifications";
    self.noNotifsLabel.textAlignment = NSTextAlignmentCenter;
    self.noNotifsLabel.numberOfLines = 0;
    self.noNotifsLabel.textColor = ([IBKNotificationsTableCell isSuperviewColourationBright:self.view.backgroundColor] ? [UIColor darkTextColor] : [UIColor whiteColor]);
    
    [self.noNotifsLabel setLabelSize:kIBKLabelSizingLarge];
    self.noNotifsLabel.shadowingEnabled = ![IBKNotificationsTableCell isSuperviewColourationBright:self.view.backgroundColor];
    
    self.noNotifsLabel.backgroundColor = [UIColor clearColor];
    if ([self.notificationsDataSource count] == 0)
        self.noNotifsLabel.alpha = 1.0;
    else
        self.noNotifsLabel.alpha = 0.0;
    
    [topBase addSubview:self.noNotifsLabel];
    
    // Bring icon back up to top view
    [topBase addSubview:self.iconImageView];
    
    [self setColorAndOrIcon:infoPlist];
}

-(void)loadForGameCenter:(NSDictionary*)plist {
    // It will be much easier to have a subclass that handles all of this for us!
    
    self.gcTableView = [[IBKGameCenterTableView alloc] initWithIdentifier:self.applicationIdentifer andFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.iconImageView.frame.origin.y-6) andColouration:self.view.backgroundColor];
    
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.anchorPoint = CGPointZero;
    grad.startPoint = CGPointMake(0.5f, 1.0f);
    grad.endPoint = CGPointMake(0.5f, 0.5f);
    
    UIColor *innerColour = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[innerColour CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.975f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.95f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.9f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.8f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.7f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.6f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.5f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.4f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.3f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.2f] CGColor],
                       (id)[[innerColour colorWithAlphaComponent:0.1f] CGColor],
                       (id)[[UIColor clearColor] CGColor],
                       nil];
    
    colors = [[colors reverseObjectEnumerator] allObjects];
    
    grad.colors = colors;
    grad.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.iconImageView.frame.origin.y + (self.iconImageView.frame.size.height/4));
    
    UIView *tableViewBase = [[UIView alloc] initWithFrame:topBase.frame];
    tableViewBase.backgroundColor = [UIColor clearColor];
    
    tableViewBase.layer.mask = grad;
    
    [topBase addSubview:tableViewBase];

    self.gcTableView.layer.masksToBounds = NO;
    
    [tableViewBase addSubview:self.gcTableView];
    
    IBKLabel *achLabel = [[IBKLabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, self.iconImageView.frame.origin.y, 50, self.iconImageView.frame.size.height)];
    achLabel.textColor = ([IBKNotificationsTableCell isSuperviewColourationBright:self.view.backgroundColor] ? [UIColor darkTextColor] : [UIColor whiteColor]);
    achLabel.textAlignment = NSTextAlignmentCenter;
    achLabel.text = @"Achievements";
    achLabel.backgroundColor = [UIColor clearColor];
    achLabel.alpha = 0.5;
    
    [achLabel setLabelSize:kIBKLabelSizingButtonView];
    
    [achLabel sizeToFit];
    
    achLabel.frame = CGRectMake(self.view.bounds.size.width - achLabel.frame.size.width - 20, self.iconImageView.frame.origin.y, achLabel.frame.size.width, self.iconImageView.frame.size.height);
    
    [topBase addSubview:achLabel];
    
    // Deal with background image!
    
    NSString *suffix = @"";
    
    if (isPad) {
        suffix = @"~ipad";
    }
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (scale >= 2.0 && scale < 3.0) {
        suffix = [suffix stringByAppendingString:@"@2x.png"];
    } else if (scale >= 3.0) {
        suffix = [suffix stringByAppendingString:@"@3x.png"];
    } else if (scale < 2.0) {
        suffix = [suffix stringByAppendingString:@".png"];
    }
    
    // Pull image if available.
    
    UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/LargeBackground%@", [self getPathForMainBundle], suffix]];
    if (!img) {
        // Pull iTunes artwork.
    }
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:img];
    bg.backgroundColor = [UIColor clearColor];
    bg.alpha = 0.1;
    bg.contentMode = UIViewContentModeScaleAspectFill;
    bg.frame = tableViewBase.bounds;
    
    [tableViewBase insertSubview:bg atIndex:0];
    
    [self setColorAndOrIcon:plist];
}

-(void)layoutViewForPreExpandedWidget {
    // Layout view as this widget is already expanded.
    //if (!self.isWidgetLoaded)
    [self loadWidgetInterface];
    
    // Set scaling of baseView
    self.view.alpha = 1.0;
    self.view.hidden = NO;
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.view.layer.shadowOpacity = 0.0;
    
    if ([IBKResources transparentBackgroundForWidgets]) {
        if ([IBKResources showBorderWhenTransparent]) {
            const CGFloat *components = CGColorGetComponents(self.view.layer.borderColor);
            self.view.layer.borderColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:1.0].CGColor;
        }
    } else {
        CGFloat red, green, blue;
        [self.view.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
    
        self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        self.gradientLayer.opacity = 1.0;
    }
    
    // Set alpha of icon image view
    self.iconImageView.alpha = 1.0;
    self.shimIcon.alpha = 0.0;
    self.shimIcon.hidden = YES;
}

-(void)setScaleForView:(CGFloat)scale withDuration:(CGFloat)duration {
    // This scale value should have Hooke's Law applied if it is greater than 1.0
    
    BOOL fin = NO;
    
    if (scale >= 8.0) {
        fin = YES;
    }
    
    scale -= 1.0;
    
    // Modify scaling to be based off icon sizing.
    
    // ShimIcon needs to be looking at scale 1.0
    // (widgetWidth - self.shimIcxon.bounds.size.width) = gap between widget and icon (may be negative)
    
    CGFloat iconScale = (isPad ? 72 : 60) / [IBKResources heightForWidget];
    
    if (!self.scalingDown)
        scale = iconScale + scale;
    
    if (scale < iconScale)
        scale = iconScale;
    
    if (fin)
        scale = 1.0;
    
    if (scale > 1.0) {
        CGFloat force = log(scale)/(2.0*scale);
        
        scale = 1.0+force;
    }
    
    // Icon scaling.
    
    CGFloat __block iconAlpha = 1.0;
    
    // We can assume that past 1.35 pinch scale, the icon shim will be alpha 0
    
    if (scale >= (0.15 + iconScale)) {
        iconAlpha = ((0.45+iconScale)-scale)*5;
    }
    
    NSLog(@"WE'LL BE SETTING TO SCALE %f", scale);
    
    if ([IBKResources transparentBackgroundForWidgets]) {
        if ([IBKResources showBorderWhenTransparent]) {
            const CGFloat *components = CGColorGetComponents(self.view.layer.borderColor);
            self.view.layer.borderColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:1.0-iconAlpha].CGColor;
        }
    } else {
        CGFloat red, green, blue;
        [self.view.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
        
        self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0-iconAlpha];
        self.gradientLayer.opacity = 1.0-iconAlpha;
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeScale((fin ? 1.0 : scale), (fin ? 1.0 : scale));
        self.shimIcon.alpha = iconAlpha;
        if (!self.isLocked) {
            self.viw.alpha = 1.0-iconAlpha;
            self.notificationsTableView.alpha = 1.0-iconAlpha;
            self.gcTableView.alpha = 1.0-iconAlpha;
        }
    
        // Depending on how far we've scaled, adjust the icon image view at a much faster rate.
        self.iconImageView.alpha = 1.0-iconAlpha;
        
        if (self.scalingDown)
            [[self.correspondingIconView _iconImageView] setAlpha:0.0];
    }];
}

-(void)unloadFromPinchGesture {
    CGFloat iconScale = (isPad ? 72 : 60) / [IBKResources heightForWidget];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformMakeScale(iconScale, iconScale);
        self.view.alpha = 0.0;
        self.iconImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self unloadWidgetInterface];
    }];
}

float scale2 = 0.0;
-(void)handlePinchGesture:(UIPinchGestureRecognizer*)pinch {
    if (pinch.state == UIGestureRecognizerStateBegan) {
        NSLog(@"XXX: Pinching began");
        // Handle setting up the view.
        self.scalingDown = YES;
        self.shimIcon.hidden = NO;
        
        // Add widget view onto icon.
        [self.correspondingIconView.superview addSubview:self.correspondingIconView]; // Move the view to be the top most subview
    } else if (pinch.state == UIGestureRecognizerStateChanged) {
       // NSLog(@"XXX: Pinching changed");
        
        // Set scale of our widget view, using scale/velocity as our time duration for animation
        CGFloat duration = (pinch.scale/pinch.velocity);
        if (duration < 0)
            duration = -duration;
        
        scale2 = 1.0+pinch.scale;
        
        [self setScaleForView:scale2 withDuration:0.0];
    } else if (pinch.state == UIGestureRecognizerStateEnded) {
        NSLog(@"XXX: Pinching ended");
        if ((scale2-1.0) > 0.8) { // Scale is 1.0 onwards, but we expect 0.0 onwards
            [self setScaleForView:8.0 withDuration:0.3];
            self.shimIcon.hidden = YES;
            
            // We remain in position.
        } else {
            // Animate shim icon to top corner.
            CGFloat iconScale = (isPad ? 72 : 60) / [IBKResources heightForWidget];
            
            const CGFloat *components;
            
            if ([IBKResources transparentBackgroundForWidgets]) {
                if ([IBKResources showBorderWhenTransparent]) {
                    components = CGColorGetComponents(self.view.layer.borderColor);
                }
            }
            
            CGFloat red, green, blue;
            [self.view.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
            
            if (self.applicationIdentifer) {
                [IBKResources removeIdentifier:self.applicationIdentifer];
            }
            
            SBIconListView *lst = [self IBKListViewForIdentifierTwo:self.applicationIdentifer];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.view.transform = CGAffineTransformMakeScale(iconScale, iconScale);
                if (![IBKResources hoverOnly])
                    self.view.center = CGPointMake(([(UIView*)[self.correspondingIconView _iconImageView] frame].size.width/2)-1, ([(UIView*)[self.correspondingIconView _iconImageView] frame].size.height/2)-1);
                self.shimIcon.alpha = 1.0;
                /*for (UIView *subview in self.view.subviews) {
                    if (![subview isEqual:self.shimIcon] && subview != self.shimIcon)
                        subview.alpha = 0.0;
                }*/
                
                self.iconImageView.alpha = 0.0;
                
                if ([IBKResources transparentBackgroundForWidgets]) {
                    if ([IBKResources showBorderWhenTransparent]) {
                        self.view.layer.borderColor = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:0.0].CGColor;
                    }
                } else {
                    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.0];
                    self.gradientLayer.opacity = 0.0;
                }
                
                // Reload everything.
                if (![IBKResources hoverOnly]) {
                    [(SBIconController*)[objc_getClass("SBIconController") sharedInstance] removeAllCachedIcons];
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                        //[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.3 domino:NO forceRelayout:YES];
                    
                        [lst setIconsNeedLayout];
                        [lst layoutIconsIfNeeded:0.3 domino:NO];
                    } else
                        [(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.3 domino:NO forceRelayout:YES];
                }
            } completion:^(BOOL finished) {
                [[self.correspondingIconView _iconImageView] setAlpha:1.0];
                self.view.hidden = YES;
                [self unloadFromPinchGesture];
                [[objc_getClass("SBIconController") sharedInstance] removeIdentifierFromWidgets:self.applicationIdentifer];
                
                // Reset icon frames.
                if (![IBKResources hoverOnly]) {
                    [lst setIconsNeedLayout];
                    [lst layoutIconsIfNeeded:0.0 domino:NO];
                }
            }];
        }
        
        self.scalingDown = NO;
    } else if (pinch.state == UIGestureRecognizerStateCancelled) {
        [self setScaleForView:8.0 withDuration:0.3];
        self.shimIcon.hidden = NO;
        
        self.scalingDown = NO;
    }
}

-(NSString*)getPathForMainBundle {
    NSString *thing = [NSString stringWithFormat:@"/var/mobile/Library/Curago/Widgets/%@", [IBKResources getRedirectedIdentifierIfNeeded:self.applicationIdentifer]];
    
    // Wait! If we don't have a default widget, or the redirected is uninstalled, what happens then? We fallback!
    // Fallback to default first.
    
    return thing;
}

-(void)reloadWidgetForSettingsChange {
    NSLog(@"RELAYING OUT WIDGET FOR SETTINGS CHANGE");
    
    [self unloadWidgetInterface];
    [self layoutViewForPreExpandedWidget];
}

#pragma mark Rotation handling

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (!isPad) return;
    
    // Alright. Let's rotate.
    CGRect baseViewFrame;
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == 0) {
        if (isPad) {
            baseViewFrame = CGRectMake(0, 0, 252, 237);
        } else {
            baseViewFrame = CGRectMake(0, 0, [IBKResources widthForWidget], [IBKResources heightForWidget]);
        }
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        if (isPad) {
            baseViewFrame = CGRectMake(0, 0, 272, 217);
        } else {
            baseViewFrame = CGRectMake(0, 0, [IBKResources widthForWidget], [IBKResources heightForWidget]);
        }
    }
    
    // Also, adjust icon frame.
    CGRect iconViewFrame = CGRectMake(10, baseViewFrame.size.height-(isPad ? 60 : 40), (isPad ? 60 : 40), (isPad ? 60 : 40));
    
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = baseViewFrame;
        self.iconImageView.frame = iconViewFrame;
    }];
}

#pragma mark End rotation handling.

#pragma mark UITableView delegate methods. (for notifications fallback)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Handle stuff like QR tweaks etc.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Launch bulletin!
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Each has it's own height I think. Two visible at all times for iPhone
    if (isPad)
        return 70;
    else
        return 52.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // THIS IS IMPORTANT
    
    NSLog(@"Asking for a new cell");
    
    IBKNotificationsTableCell *cell = [self.notificationsTableView dequeueReusableCellWithIdentifier:@"notificationTableCell"];
    if (!cell) {
        cell = [[IBKNotificationsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationTableCell"];
    }
    
    BBBulletin *bulletin = (self.notificationsDataSource)[indexPath.row];
    
    cell.superviewColouration = self.view.backgroundColor;
    [cell initialiseForBulletin:bulletin andRowWidth:[IBKResources widthForWidget]-20];
    
    NSLog(@"Finished creating new cell");
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notificationsDataSource count];
}

#pragma mark End UITableView delegate methods

#pragma mark BBBulletin methods

-(void)addBulletin:(id)arg2 {
    NSLog(@"Recieved bulletin");
    
    if ([self.notificationsDataSource count] == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.noNotifsLabel.alpha = 0.0;
        }];
    }
    
    [self.notificationsDataSource insertObject:arg2 atIndex:0];
    
    self.notificationsDataSource = [self orderedArrayForNotifications:self.notificationsDataSource];
    
    [self.notificationsTableView reloadData];
    
    //[self.notificationsTableView reloadSections:0 withRowAnimation:UITableViewRowAnimationTop];
    
    //[self.notificationsTableView reloadData];
    
    /*NSMutableArray *indexPaths = [NSMutableArray array];
    [indexPaths addObject:[NSIndexPath indexPathForRow:[self.notificationsDataSource indexOfObject:arg2] inSection:0]];
    [self.notificationsTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];*/
    
}

-(void)removeBulletin:(id)arg2 {
    // TODO: Check whether we need to use the bulletin ID for removal
    [self.notificationsDataSource removeObject:arg2];
    
    self.notificationsDataSource = [self orderedArrayForNotifications:self.notificationsDataSource];
    
    [self.notificationsTableView reloadData];
    
    if ([self.notificationsDataSource count] == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.noNotifsLabel.alpha = 1.0;
        }];
    }
}

- (void)observer:(id)observer modifyBulletin:(id)bulletin {
    
}

-(void)observer:(id)observer noteInvalidatedBulletinIDs:(id)ids {
    
}

#pragma mark End BBObserverDelegate

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)unloadWidgetInterface {
    // Unload the widget UI.
    self.view.hidden = YES;
    
    // Well, shit. We need to tear all this UI down.
    
    if (self.notificationsTableView) {
        [self.notificationsTableView removeFromSuperview];
        self.notificationsTableView = nil;
    }
    
    if (self.webView) {
        [self.webView removeFromSuperview];
        self.webView = nil;
    }
    
    if (self.viw) {
        [self.viw removeFromSuperview];
        self.viw = nil;
    }
    
    if (self.widget)
        self.widget = nil;
    
    if (self.bundle) {
        [self.bundle unload];
        self.bundle = nil;
    }
    
    if (self.iconImageView) {
        [self.iconImageView removeFromSuperview];
        self.iconImageView = nil;
    }
    
    if (self.noNotifsLabel) {
        [self.noNotifsLabel removeFromSuperview];
        self.noNotifsLabel = nil;
    }
    
    if (self.gcTableView) {
        [self.gcTableView removeFromSuperview];
        self.gcTableView = nil;
    }
    
    [topBase removeFromSuperview];
    topBase = nil;
    
    [self.view removeFromSuperview];
    self.view = nil;
}

-(void)dealloc {
    NSLog(@"*** [Curago] :: Tearing down a widget");
    
    [self unloadWidgetInterface];
}

@end
