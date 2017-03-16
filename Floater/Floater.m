//
//  Floater.m
//  Floater
//
//  Created by Brian Olencki on 12/22/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import "Floater.h"

@implementation UIImage (Color)
- (UIColor*)averageColor {

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);

    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}
@end

@implementation Floater
#define SCREEN ([UIScreen mainScreen].bounds)
@synthesize onScreen = _onScreen, bundleID = _bundleID;
#pragma mark - Instance Tracking
static NSMutableArray *_aryInstances;
static NSInteger _currentWindowLevel;
+ (void) initialize {
	if (self == [Floater class]) {
		_aryInstances = [[NSMutableArray alloc] init];
		_currentWindowLevel = 1000;
	}
}
+ (id) alloc {
	id objCreated =  [super alloc];
	[_aryInstances addObject:objCreated];

	return objCreated;
}
+ (NSMutableArray*)getInstances {
	return _aryInstances;
}

#pragma mark - System Functions
- (instancetype)initWithApplicationBundleID:(NSString*)bundleID atPoint:(CGPoint)point withBaseWindowLevel:(NSInteger)baseWindow {
    if (self == [super init]) {
        _onScreen = NO;
        _type = FloaterTypeClosed;
        _baseWindowLevel = baseWindow;
        [self setWindowLevel:_baseWindowLevel];
        _bundleID = bundleID;


        [self createFloater];
        [self setFloaterType:FloaterTypeClosed animated:NO];
        _overlay.hidden = YES;
        _overlay.center = point;
    }
    return self;
}
- (void)dealloc {
  [_aryInstances removeObject:self];

	//DO NOT PUT "[super dealloc]" IT WILL CRASH
	//AUTO ADDED WITH ARC
}

#pragma mark - Public Functions
- (void)toggleFloater {
    if (_onScreen == YES) {
        [self removeFloater];
    } else {
        [self addFloater];
    }
}
- (void)setPosition:(CGPoint)point {
    _overlay.center = point;
}
- (void)setWindowLevel:(NSInteger)windowLevel {
	_overlay.windowLevel = _windowLevel = _currentWindowLevel = windowLevel;
}

#pragma mark - Private Functions
- (void)removeFloater {
    [UIView animateWithDuration:0.25 animations:^{
        _overlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        _overlay.hidden = YES;
        _onScreen = NO;
        [self dealloc];
    }];
}
- (void)addFloater {
    _overlay.hidden = NO;
    _overlay.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        _overlay.alpha = 1.0;
    } completion:^(BOOL finished) {
        _onScreen = YES;
    }];
}
- (void)createFloater {
    _overlay = [[UIWindow alloc] initWithFrame:SCREEN];
    _overlay.rootViewController = _rootViewController = [UIViewController new];
    _overlay.windowLevel = _windowLevel;
    _overlay.backgroundColor = [UIColor clearColor];
    _overlay.layer.masksToBounds = NO;
    _overlay.layer.shadowColor = [UIColor blackColor].CGColor;
    _overlay.layer.shadowOffset = CGSizeMake(2.5, 2.5);
    _overlay.layer.shadowOpacity = 0.5;
    _overlay.layer.shadowRadius = 1.0;
    [_overlay makeKeyAndVisible];

    _rootViewController.view.backgroundColor = [UIColor clearColor];
    _rootViewController.providesPresentationContextTransitionStyle = YES;
    _rootViewController.definesPresentationContext = YES;
    _rootViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    _rootViewController.view.layer.masksToBounds = YES;
    // _rootViewController.view.layer.borderColor = [[UIColor blackColor] CGColor];
    // _rootViewController.view.layer.borderWidth = 1.0;

    viewClosed = [[UIImageView alloc] initWithImage:[self imageForApplicationWithBundlID:_bundleID]];
    viewClosed.frame = CGRectMake(0, 0, [self floaterClosedSize].width, [self floaterClosedSize].height);
    viewClosed.backgroundColor = [UIColor clearColor];
    [_rootViewController.view addSubview:viewClosed];

    _viewOpen = [[UIView alloc] init];
    _viewOpen.backgroundColor = [UIColor whiteColor];
    _viewOpen.frame = CGRectMake(0, 0, [self floaterOpenSize].width, [self floaterOpenSize].height);
    _viewOpen.alpha = 0.0;
    [_rootViewController.view addSubview:_viewOpen];

    UITapGestureRecognizer *tgrToggleFloaterType = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_rootViewController.view addGestureRecognizer:tgrToggleFloaterType];

    UITapGestureRecognizer *tgrReorder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    tgrReorder.numberOfTapsRequired = 2;
    [tgrToggleFloaterType requireGestureRecognizerToFail:tgrReorder];
    [_rootViewController.view addGestureRecognizer:tgrReorder];

    UILongPressGestureRecognizer *lpgrRemoveFloater = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [_rootViewController.view addGestureRecognizer:lpgrRemoveFloater];

    UIPanGestureRecognizer *pgrMoveFloater = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_rootViewController.view addGestureRecognizer:pgrMoveFloater];
}
- (void)setFloaterType:(FloaterType)type animated:(BOOL)animated {
    _type = type;

    CGRect frame = _overlay.frame;
    NSInteger cornerRadius = _overlay.layer.cornerRadius;

    switch (type) {
        case FloaterTypeOpen:
            frame.size = [self floaterOpenSize];
            cornerRadius = [self floaterOpenCornerRadius];
            break;
        case FloaterTypeClosed:
            frame.size = [self floaterClosedSize];
            cornerRadius = [self floaterClosedCornerRadius];
            break;

        default:
            break;
    }

		if (animated == YES) {
        [UIView animateWithDuration:0.5 animations:^{
            _overlay.frame = frame;
            _overlay.layer.cornerRadius = cornerRadius;
            _rootViewController.view.layer.cornerRadius = cornerRadius;
            _overlay.layer.shadowRadius = cornerRadius;
            if (_type == FloaterTypeClosed) {
                viewClosed.alpha = 1.0;
                _viewOpen.alpha = 0.0;
            } else {
                viewClosed.alpha = 0.0;
                _viewOpen.alpha = 1.0;
            }
        }];
    } else {
        _overlay.frame = frame;
        _overlay.layer.cornerRadius = cornerRadius;
        _rootViewController.view.layer.cornerRadius = cornerRadius;
        _overlay.layer.shadowRadius = cornerRadius;
        if (_type == FloaterTypeClosed) {
            viewClosed.alpha = 1.0;
            _viewOpen.alpha = 0.0;
        } else {
            viewClosed.alpha = 0.0;
            _viewOpen.alpha = 1.0;
        }
    }
}

#pragma mark - GestureRecognizer Functions
- (void)handleTap:(UITapGestureRecognizer*)recognizer {
    [self setFloaterType:(_type ? FloaterTypeOpen : FloaterTypeClosed) animated:YES];
}
- (void)handleDoubleTap:(UITapGestureRecognizer*)recognizer {
  NSArray *aryTemp = [Floater getInstances];
  for (id item in aryTemp) {
    if ([item isMemberOfClass:[Floater class]]) {
     [item setFloaterType:FloaterTypeClosed animated:YES];
     [UIView animateWithDuration:0.5 animations:^{
         [item setPosition:CGPointMake([item floaterClosedSize].width/2, ([item floaterClosedSize].height/3*2)*([aryTemp indexOfObject:item]+2))];
     }];
    }
  }
}
- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
			if (recognizer.state == UIGestureRecognizerStateBegan) {
			        if (_type == FloaterTypeClosed) {
			            [self toggleFloater];
			        } else {
									[self setWindowLevel:[self nextWindowHeight]];
			        }
			    }
    }
}
- (void)handlePan:(UIPanGestureRecognizer*)recognizer {
    static CGPoint originalCenter;
    UIView *movementView = recognizer.view.superview;

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        originalCenter = movementView.center;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translate = [recognizer translationInView:recognizer.view.superview.superview.superview];
        CGPoint centerToBe = CGPointMake(originalCenter.x + translate.x, originalCenter.y + translate.y);
        CGSize sizeView = movementView.bounds.size;
        CGRect newViewRect = CGRectMake(centerToBe.x-sizeView.width/2, centerToBe.y-sizeView.height/2, sizeView.width, sizeView.height);
        if (newViewRect.origin.x >= 0 && (newViewRect.origin.x+newViewRect.size.width) <= SCREEN.size.width) {
            movementView.center = CGPointMake(centerToBe.x, movementView.center.y);
        }
        if (newViewRect.origin.y >= 0 && (newViewRect.origin.y+newViewRect.size.height) <= SCREEN.size.height) {
            movementView.center = CGPointMake(movementView.center.x, centerToBe.y);
        }
    }
}

#pragma mark - App Functions
- (UIImage*)imageForApplicationWithBundlID:(NSString*)bundleID {
    UIImage *imgIcon = nil;
    imgIcon = [UIImage _applicationIconImageForBundleIdentifier:bundleID format:2 scale:[UIScreen mainScreen].scale];

    return imgIcon;
}

#pragma mark - Other
- (CGSize)floaterOpenSize {
    return CGSizeMake(SCREEN.size.width/5*4, SCREEN.size.height/5*4);
}
- (CGSize)floaterClosedSize {
    return CGSizeMake(65,65);
}
- (NSInteger)floaterOpenCornerRadius {
    return [self floaterClosedCornerRadius];
}
- (NSInteger)floaterClosedCornerRadius {
    return 3.0;
}
- (NSInteger)nextWindowHeight {
    if (_currentWindowLevel >= _baseWindowLevel+[[Floater getInstances] count]) {
        _currentWindowLevel = _baseWindowLevel;
        for (id item in [Floater getInstances]) {
            if ([item isMemberOfClass:[Floater class]]) {
                [(Floater*)item setWindowLevel:_currentWindowLevel];
            }
        }
    }
    return _currentWindowLevel+1;
}
@end
