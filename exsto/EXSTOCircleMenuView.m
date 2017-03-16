//
//  EXSTOCircleMenuView.m
//


#import "EXSTOCircleMenuView.h"

@interface EXSTOCircleMenuView ()

@property (nonatomic) NSMutableArray* buttons;
@property (unsafe_unretained, nonatomic) UIGestureRecognizer* recognizer;
@property (nonatomic) int hoverTag;

@property (nonatomic) UIColor* innerViewColor;
@property (nonatomic) UIColor* notifColor;
@property (nonatomic) UIColor* innerViewActiveColor;
@property (nonatomic) UIColor* borderViewColor;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat maxAngle;
@property (nonatomic) CGFloat hoverScale;
@property (nonatomic) CGFloat animationDelay;
@property (nonatomic) CGFloat startingAngle;
@property (nonatomic) BOOL depth;
@property (nonatomic) CGFloat buttonRadius;
@property (nonatomic) CGFloat buttonBorderWidth;

@property (nonatomic, unsafe_unretained) UIView* clippingView;

@end


// each button is made up of two views (button image, and background view)
// the buttons get tagged, starting at 1
// components are identified by adding the corresponding offset to the button's logical tag
static int TAG_BUTTON_OFFSET = 100;
static int TAG_INNER_VIEW_OFFSET = 1000;
static CGPoint INITIALPOINT;

// constants used for the configuration dictionary
NSString* const CIRCLE_MENU_BUTTON_BACKGROUND_NORMAL = @"kCircleMenuNormal";
NSString* const CIRCLE_MENU_BUTTON_BACKGROUND_ACTIVE = @"kCircleMenuActive";
NSString* const CIRCLE_MENU_NOTIF_COLOR = @"kCircleMenuNotifColor";
NSString* const CIRCLE_MENU_BUTTON_BORDER = @"kCircleMenuBorder";
NSString* const CIRCLE_MENU_OPENING_DELAY = @"kCircleMenuDelay";
NSString* const CIRCLE_MENU_RADIUS = @"kCircleMenuRadius";
NSString* const CIRCLE_MENU_MAX_ANGLE = @"kCircleMenuMaxAngle";
NSString* const CIRCLE_MENU_HOVER_SCALE = @"kCircleMenuHoverScale";
NSString* const CIRCLE_MENU_DIRECTION = @"kCircleMenuDirection";
NSString* const CIRCLE_MENU_DEPTH = @"kCircleMenuDepth";
NSString* const CIRCLE_MENU_BUTTON_RADIUS = @"kCircleMenuButtonRadius";
NSString* const CIRCLE_MENU_BUTTON_BORDER_WIDTH = @"kCircleMenuButtonBorderWidth";

@implementation EXSTOCircleMenuView

- (id)initWithOptions:(NSDictionary*)anOptionsDictionary
{
    self = [super init];
    if (self) {
        self.buttons = [NSMutableArray new];
        if (anOptionsDictionary) {
            [self updateWithOptions:anOptionsDictionary];
        } else {
            // using some default settings
            self.innerViewColor = [UIColor colorWithRed:0.0 green:0.25 blue:0.5 alpha:1.0];
            self.innerViewActiveColor = [UIColor colorWithRed:0.25 green:0.5 blue:0.75 alpha:1.0];
            self.borderViewColor = [UIColor whiteColor];
            self.notifColor = [UIColor clearColor];
            self.animationDelay = 0.0;
            self.radius = 65.0;
            self.maxAngle = 180.0;
            self.hoverScale = 1.2;
            self.startingAngle = 0.0;
            self.depth = NO;
            self.buttonRadius = 39.0;
            self.buttonBorderWidth = 2.0;
        }
    }
    return self;
}

- (id)initAtOrigin:(CGPoint)aPoint usingOptions:(NSDictionary *)anOptionsDictionary withNotifArray:(NSMutableArray*)notif withImageArray:(NSArray *)anImageArray 
{
    self = [self initWithOptions:anOptionsDictionary];
    if (self) {
        self.frame = CGRectMake(aPoint.x - self.radius - self.buttonRadius, aPoint.y - self.radius - self.buttonRadius, self.radius * 2 + self.buttonRadius * 2, self.radius * 2 + self.buttonRadius * 2);
        int tTag = 1;
        int i = 0;
        for (UIImage* img in anImageArray) {
            UIView* tView;
            if([[notif objectAtIndex:i] boolValue]){
                tView = [self createButtonViewWithImage:img andTag:tTag withNotification: YES];
            } else {
                tView = [self createButtonViewWithImage:img andTag:tTag withNotification: NO];
            }

            [self.buttons addObject:tView];
            tTag++;
            i++;
        }
    }
    return self;
}

- (id)initAtOrigin:(CGPoint)aPoint usingOptions:(NSDictionary *)anOptionsDictionary withNotifArray:(NSMutableArray*)notif withImages:(UIImage *)anImage, ...
{
    self = [self initWithOptions:anOptionsDictionary];
    if (self) {
        self.frame = CGRectMake(aPoint.x - self.radius - self.buttonRadius, aPoint.y - self.radius - self.buttonRadius, self.radius * 2 + self.buttonRadius * 2, self.radius * 2 + self.buttonRadius * 2);
        int tTag = 1;
        va_list args;
        va_start(args, anImage);
        int i = 0;
        for (UIImage* img = anImage; img != nil; img = va_arg(args, UIImage*)) {
            UIView* tView;
            if([[notif objectAtIndex:i] boolValue]){
                tView = [self createButtonViewWithImage:img andTag:tTag withNotification: YES];
            } else {
                tView = [self createButtonViewWithImage:img andTag:tTag withNotification: NO];
            }

            [self.buttons addObject:tView];
            tTag++;
            i++;
        }
        va_end(args);
    }
    return self;
}

- (void)updateWithOptions:(NSDictionary *)anOptionsDictionary
{
    self.innerViewColor = [anOptionsDictionary valueForKey:CIRCLE_MENU_BUTTON_BACKGROUND_NORMAL];
    self.notifColor = [anOptionsDictionary valueForKey:CIRCLE_MENU_NOTIF_COLOR];
    self.innerViewActiveColor = [anOptionsDictionary valueForKey:CIRCLE_MENU_BUTTON_BACKGROUND_ACTIVE];
    self.borderViewColor = [anOptionsDictionary valueForKey:CIRCLE_MENU_BUTTON_BORDER];
    self.animationDelay = [[anOptionsDictionary valueForKey:CIRCLE_MENU_OPENING_DELAY] doubleValue];
    self.radius = [[anOptionsDictionary valueForKey:CIRCLE_MENU_RADIUS] doubleValue];
    self.maxAngle = [[anOptionsDictionary valueForKey:CIRCLE_MENU_MAX_ANGLE] doubleValue];
    self.hoverScale = [[anOptionsDictionary valueForKey:CIRCLE_MENU_HOVER_SCALE] doubleValue];
    switch ([[anOptionsDictionary valueForKey:CIRCLE_MENU_DIRECTION] integerValue]) {
        case EXSTOCircleMenuDirectionUp:
            self.startingAngle = 0.0;
            break;
        case EXSTOCircleMenuDirectionRight:
            self.startingAngle = 90.0;
            break;
        case EXSTOCircleMenuDirectionDown:
            self.startingAngle = 180.0;
            break;
        case EXSTOCircleMenuDirectionLeft:
            self.startingAngle = 270.0;
            break;
    }
    self.depth = [[anOptionsDictionary valueForKey:CIRCLE_MENU_DEPTH] boolValue];
    self.buttonRadius = [[anOptionsDictionary valueForKey:CIRCLE_MENU_BUTTON_RADIUS] doubleValue];
    self.buttonBorderWidth = [[anOptionsDictionary valueForKey:CIRCLE_MENU_BUTTON_BORDER_WIDTH] doubleValue];
    
    if (self.superview)
    {
        [self calculateButtonPositions];
    }
}

/*!
 * Convenience method that creates a circle button, consisting of
 * the image, a background and a border.
 * @param anImage image to be used as button's icon
 * @param aTag unique identifier (should be index + 1)
 * @return UIView to be used as button
 */
- (UIView*)createButtonViewWithImage:(UIImage*)anImage andTag:(int)aTag withNotification:(BOOL)hasNotif
{
    UIButton* tButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat tButtonViewX = self.buttonRadius - anImage.size.width / 2;
    CGFloat tButtonViewY = self.buttonRadius - anImage.size.height / 2;
    tButton.frame = CGRectMake(tButtonViewX, tButtonViewY, anImage.size.width, anImage.size.height);
    
    if(hasNotif){
        tButton.layer.shadowColor = self.notifColor.CGColor;
        tButton.layer.shadowRadius = 5.0f;
        tButton.layer.shadowOpacity = .9;
        tButton.layer.shadowOffset = CGSizeZero;
        tButton.layer.masksToBounds = NO;
    }

    [tButton setImage:anImage forState:UIControlStateNormal];
    tButton.tag = aTag + TAG_BUTTON_OFFSET;
    
    UIView* tInnerView = [[EXSTORoundView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.buttonRadius * 2, self.buttonRadius * 2)];
    tInnerView.backgroundColor = self.innerViewColor;
    tInnerView.opaque = YES;
    tInnerView.clipsToBounds = NO;
    tInnerView.layer.cornerRadius = self.buttonRadius;
    tInnerView.layer.borderColor = [self.borderViewColor CGColor];
    tInnerView.layer.borderWidth = self.buttonBorderWidth;

    if (self.depth) {
        [self applyInactiveDepthToButtonView:tInnerView];
    }

    tInnerView.tag = aTag + TAG_INNER_VIEW_OFFSET;
    [tInnerView addSubview:tButton];
    
    return tInnerView;
}

/*!
 * Does the math to put buttons on a circle.
 */
- (void)calculateButtonPositions
{
    if (!self.clippingView) {
        // climb view hierarchy up, until first view with clipToBounds = YES
        self.clippingView = [self clippingViewOfChild:self];
    }
    CGFloat tMaxX = self.frame.size.width - self.buttonRadius;
    CGFloat tMinX = self.buttonRadius;
    CGFloat tMaxY = self.frame.size.height - self.buttonRadius;
    CGFloat tMinY = self.buttonRadius;
    if (self.clippingView) {
        CGRect tClippingFrame = [self.clippingView convertRect:self.clippingView.bounds toView:self];
        tMaxX = tClippingFrame.size.width + tClippingFrame.origin.x - self.buttonRadius * 2;
        tMinX = tClippingFrame.origin.x;
        tMaxY = tClippingFrame.size.height + tClippingFrame.origin.y - self.buttonRadius * 2;
        tMinY = tClippingFrame.origin.y;
    }

    int tButtonCount = (int)self.buttons.count;
    CGPoint tOrigin = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGFloat tRadius = self.radius;
    int tCounter = 0;

    // issue #1 - align buttons perfectly on circle of max angle is 360.0       
    if (self.maxAngle == 360.0) {       
        self.maxAngle = 360.0 - 360.0 / self.buttons.count;     
    }

    for (UIView* tView in self.buttons) {
        CGFloat tCurrentWinkel;
        if (tCounter == 0) {
            tCurrentWinkel = self.startingAngle + 0.0;
        } else if (tCounter > 0 && tCounter < tButtonCount) {
            tCurrentWinkel = self.startingAngle + (self.maxAngle / (tButtonCount - 1)) * tCounter;
        } else {
            tCurrentWinkel = self.startingAngle + self.maxAngle;
        }
        CGSize tSize = tView.frame.size;
        CGFloat tX = tOrigin.x - (tRadius * cosf(tCurrentWinkel / 180.0 * M_PI)) - (tSize.width / 2);
        CGFloat tY = tOrigin.y - (tRadius * sinf(tCurrentWinkel / 180.0 * M_PI)) - (tSize.width / 2);
        
        if (tX > tMaxX) tX = tMaxX;
        if (tX < tMinX) tX = tMinX;
        if (tY > tMaxY) tY = tMaxY;
        if (tY < tMinY) tY = tMinY;
        
        CGRect tRect = CGRectMake(tX, tY, tSize.width, tSize.height);
        tView.frame = tRect;
        tCounter++;
    }
}

/*!
 * Climbs up the view hierarchy to find the first which has clipToBounds = YES.
 * Returns the topmost view if no view has clipsToBound set to YES.
 * @return UIView with clipToBounds = YES
 */
- (UIView*)clippingViewOfChild:(UIView*)aView
{
    UIView* tView = [aView superview];
    if (tView) {
        if (tView.clipsToBounds) {
            return tView;
        } else {
            return [self clippingViewOfChild:tView];
        }
    } else {
        return aView;
    }
}

- (void)openMenuWithRecognizer:(UIGestureRecognizer*)aRecognizer
{
    self.recognizer = aRecognizer;
    // use target action to get notified upon gesture changes
    [aRecognizer addTarget:self action:@selector(gestureChanged:)];
 
    CGPoint tOrigin = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    INITIALPOINT = tOrigin;
    [self calculateButtonPositions];
    for (UIView* tButtonView in self.buttons) {
        [self addSubview:tButtonView];
        tButtonView.alpha = 0.0;
        CGFloat tDiffX = tOrigin.x - tButtonView.frame.origin.x - self.buttonRadius;
        CGFloat tDiffY = tOrigin.y - tButtonView.frame.origin.y - self.buttonRadius;
        tButtonView.transform = CGAffineTransformMakeTranslation(tDiffX, tDiffY);
    }

    CGFloat tDelay = 0.0;
    for (UIView* tButtonView in self.buttons) {
        tDelay = tDelay + self.animationDelay;
        [UIView animateWithDuration:0.6 delay:tDelay usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            tButtonView.alpha = 1.0;
            tButtonView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        
        }];
    }
}

/*!
 * Performs the closing animation.
 */
- (void)closeMenu
{
    [self.recognizer removeTarget:self action:@selector(gestureChanged:)];
        // [self.delegate.EXSTOBlurView deactivateBlur];

        for (UIView* tButtonView in self.buttons) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            tButtonView.alpha = 0;
            tButtonView.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
            //tButtonView.frame = CGRectMake(self.frame.size.width/2 - tButtonView.frame.size.width/2,self.frame.size.height/2 - tButtonView.frame.size.height/2,12,12);
            // tButtonView.transform = CGAffineTransformMakeScale(0.75,0.75);
            // tButtonView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        
        }];
        }

        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            // self.alpha = 0;
            // tButtonView.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
            //tButtonView.frame = CGRectMake(self.frame.size.width/2 - tButtonView.frame.size.width/2,self.frame.size.height/2 - tButtonView.frame.size.height/2,12,12);
            // tButtonView.transform = CGAffineTransformMakeScale(0.75,0.75);
            // tButtonView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        
        }];
        [UIView animateWithDuration:0.6 delay:0.6 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            // for (UIView* tButtonView in self.buttons) {
            //     tButtonView.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
            // }
            // tButtonView.transform = CGAffineTransformMakeScale(0.75,0.75);
            // tButtonView.alpha = 0;
        } completion:^(BOOL finished) {
            // [self removeFromSuperview];
            if (self.delegate && [self.delegate respondsToSelector:@selector(circleMenuClosed)]) {
                [self.delegate circleMenuClosed];
            }
        }];

    // [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    //     for (UIView* tButtonView in self.buttons) {
    //         if (self.hoverTag > 0 && self.hoverTag == [self bareTagOfView:tButtonView]) {
    //             tButtonView.transform = CGAffineTransformMakeScale(1.8, 1.8);
    //         }
    //         tButtonView.alpha = 0.0;
    //     }
    // } completion:^(BOOL finished) {
    //     [self removeFromSuperview];
    //     if (self.delegate && [self.delegate respondsToSelector:@selector(circleMenuClosed)]) {
    //         [self.delegate circleMenuClosed];
    //     }
    // }];
}

- (void)gestureMovedToPoint:(CGPoint)aPoint
{

    int tTag;
    UIView* closestButton;
    float shortestDist = 100000.0;

    if([self distanceFromPoint: INITIALPOINT toPointB: aPoint] > self.buttonRadius)
    {
        for (UIView *but in self.buttons){
            float distance = [self distanceFromPoint:but.center toPointB:aPoint];
            
            if(distance < shortestDist)
            {
                shortestDist = distance;
                closestButton = but;
            }
        }
        tTag = [self bareTagOfView:closestButton];
    }
    else {
        tTag = 0;
    }

    //UIView* tView = [self hitTest:aPoint withEvent:nil];
    //int tTag = [self bareTagOfView:tView];
    if (tTag > 0) {
        if (tTag == self.hoverTag) {
            // this button is already the active one
            return;
        }
        else
        {
            // Animate previous button back to identity
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView animateWithDuration:0.1 animations:^
            {
                UIView* tInnerView = [self viewWithTag:self.hoverTag];
                tInnerView.transform = CGAffineTransformIdentity;
                
                [self sendSubviewToBack:tInnerView];
            }];
        }
        
        self.hoverTag = tTag;
        
        // display all (other) buttons in normal state
        [self resetButtonState];
        
        // display this button in active color
        tTag = tTag + TAG_INNER_VIEW_OFFSET;
        UIView* tInnerView = [self viewWithTag:tTag];
        tInnerView.backgroundColor = self.innerViewActiveColor;
        
        
        
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView animateWithDuration:0.1 animations:^
        {
            [self bringSubviewToFront:tInnerView];
            tInnerView.transform = CGAffineTransformMakeScale(self.hoverScale, self.hoverScale);
        }];
        
        if (self.depth) {
            [self applyActiveDepthToButtonView:tInnerView];
        }
    } else {
        // the view "hit" is none of the buttons -> display all in normal state
        [self resetButtonState];        
        self.hoverTag = 0;
    }
    
    if ([self.delegate respondsToSelector:@selector(circleMenuHoverOnButtonWithIndex:)])
    {
        [self.delegate circleMenuHoverOnButtonWithIndex:tTag - 1 - TAG_INNER_VIEW_OFFSET];
    }
}

- (void)resetButtonState
{
    if (self.hoverTag > 0)
    {
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView animateWithDuration:0.1 animations:^
        {
            UIView* tInnerView = [self viewWithTag:self.hoverTag];
            tInnerView.transform = CGAffineTransformIdentity;
            [self sendSubviewToBack:tInnerView];
        }];
    }
    
    for (int i = 1; i <= self.buttons.count; i++) {
        UIView* tView = [self viewWithTag:i + TAG_INNER_VIEW_OFFSET];
        tView.backgroundColor = self.innerViewColor;
        if (self.depth) {
            [self applyInactiveDepthToButtonView:tView];
        }
        
        tView.transform = CGAffineTransformIdentity;
        
        [self bringSubviewToFront:tView];
    }
}

- (void)applyInactiveDepthToButtonView:(UIView*)aView
{
    aView.layer.shadowColor = [[UIColor blackColor] CGColor];
    aView.layer.shadowOffset = CGSizeMake(4,2);
    aView.layer.shadowRadius = 8;
    aView.layer.shadowOpacity = 0.35;
    aView.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
}

- (void)applyActiveDepthToButtonView:(UIView*)aView
{
    aView.layer.shadowColor = [[UIColor blackColor] CGColor];
    aView.layer.shadowOffset = CGSizeMake(2,1);
    aView.layer.shadowRadius = 5;
    aView.layer.shadowOpacity = 0.42;
    aView.layer.affineTransform = CGAffineTransformMakeScale(0.985, 0.985);
}

/*!
 * Target action method that gets called when the gesture used to open
 * the EXSTOCircleMenuView changes.
 */
- (void)gestureChanged:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint tPoint = [sender locationInView:self];
        [self gestureMovedToPoint:tPoint];        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        // determine wether a button was hit when the gesture ended
        CGPoint tPoint = [sender locationInView:self];
        UIView* closestButton;
        float shortestDist = 100000.0;
        int tTag;
        if([self distanceFromPoint: INITIALPOINT toPointB: tPoint] > self.radius)
        {
            for (UIView *but in self.buttons){
                float distance = [self distanceFromPoint:but.center toPointB:tPoint];
                
                if(distance < shortestDist)
                {
                    shortestDist = distance;
                    closestButton = but;
                }
            }
            tTag = [self bareTagOfView:closestButton];
        }
        else {
            tTag = 0;
        }

        //UIView* tView = [self hitTest:tPoint withEvent:nil];
        //int tTag = [self bareTagOfView:closestButton];
        if (tTag > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(circleMenuActivatedButtonWithIndex:)]) {
                [self.delegate circleMenuActivatedButtonWithIndex:self.hoverTag - 1];
            }
        }
        [self closeMenu];
    }
}

/*!
 * Return the 'virtual' tag of the button, no matter which of its components
 * (image, background, border) is passed as argument.
 * @param aView view to be examined
 * @return 'virtual' tag without offsets
 */
- (int)bareTagOfView:(UIView*)aView
{
    int tTag = (int)aView.tag;
    if (tTag > 0) {
        if (tTag >= TAG_INNER_VIEW_OFFSET) {
            tTag = tTag - TAG_INNER_VIEW_OFFSET;
        }
        if (tTag >= TAG_BUTTON_OFFSET) {
            tTag = tTag - TAG_BUTTON_OFFSET;
        }
    }
    return tTag;
}

//line intersects rect
- (CGFloat)distanceFromPoint:(CGPoint)a toPointB:(CGPoint)b
{
    return sqrt(pow(a.x - b.x, 2.0) + pow(a.y - b.y, 2.0));
}

@end

@implementation EXSTORoundView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    // Pythagoras a^2 + b^2 = c^2
    CGFloat tRadius = self.bounds.size.width / 2;
    CGFloat tDiffX = tRadius - point.x;
    CGFloat tDiffY = tRadius - point.y;
    CGFloat tDistanceSquared = tDiffX * tDiffX + tDiffY * tDiffY;
    CGFloat tRadiusSquared = tRadius * tRadius;
    return tDistanceSquared < tRadiusSquared;
}

@end