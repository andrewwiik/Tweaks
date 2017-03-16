//
//  Floater.m
//  Floater
//
//  Created by Brian Olencki on 12/22/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import "Floater.h"
#import "CDTContextHostProvider.h"
#import "Interfaces.h"
//UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
@implementation Floater
#define SCREEN ([UIScreen mainScreen].bounds)
@synthesize onScreen = _onScreen, windowLevel = _windowLevel, bundleID = _bundleID;
#pragma mark - Instance Tracking
static NSMutableArray *_aryInstances;
+ (void) initialize {
	if (self == [Floater class]) {
		_aryInstances = [[NSMutableArray alloc] init];
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
- (void) dealloc {
  [_aryInstances removeObject:self];
	//[super dealloc];
}

#pragma mark - System Functions
- (instancetype)initWithApplicationBundleID:(NSString*)bundleID atPoint:(CGPoint)point {
    if (self == [super init]) {
        _onScreen = NO;
        _type = FloaterTypeClosed;
        _windowLevel = 1000;
        _bundleID = bundleID;

        [self createFloater:bundleID];
        [self setFloaterType:FloaterTypeClosed animated:NO];
        _overlay.hidden = YES;
        _overlay.center = point;

    }
    return self;
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

#pragma mark - Private Functions

- (void)reloadStuff {
    //self.appView.frame = CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height);
   
    //[[self contextManagerForApplication:sbapplication] enableHostingForRequester:[(SBApplication *)sbapplication bundleIdentifier] orderFront:YES];



        //[[CDTContextHostProvider sharedInstance] launchSuspendedApplicationWithBundleID:bundleID];
        //[[CDTContextHostProvider sharedInstance] forceRehostingOnBundleID:bundleID];

    //reapply new settings to scene
            //[[self.appView _sceneMonitor].scene.contextHostManager enableHostingForRequester:self.app.bundleIdentifier orderFront:YES];
                //CGFloat *width = SCREEN.size.width
                //view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.70, 0.70);
                //[self.appView _enableContextHosting];
                //[self.appView _configureViewForEffectiveDisplayMode:3];
                //[self.appView _setEffectiveDisplayMode:3 options:0 withAnimationFactory:nil completion:nil];
        //[[CDTContextHostProvider sharedInstance] launchSuspendedApplicationWithBundleID:bundleID];
        //[[CDTContextHostProvider sharedInstance] forceRehostingOnBundleID:bundleID];
   /* [UIApplication.sharedApplication launchApplicationWithIdentifier:bundleID suspended:YES];
    [[[NSClassFromString(@"FBProcessManager") class] sharedInstance] createApplicationProcessForBundleID:[(SBApplication *)self.app bundleIdentifier]];
    SBApplication *application = [[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:bundleID];
    FBSMutableSceneSettings *sceneSettings = [[[(SBApplication *)self.app mainScene] mutableSettings] mutableCopy];
    [sceneSettings setBackgrounded:NO]; 

    //reapply new settings to scene
    [[(SBApplication *)self.app mainScene] _applyMutableSettings:sceneSettings withTransitionContext:nil completion:nil]; */
                //self.appView.frame = CGRectMake(0,20,[self floaterOpenSize].width,[self floaterOpenSize].height-20);

                //float width = _viewOpen.frame.size.width/SCREEN.size.width;
                //float height = _viewOpen.frame.size.height/SCREEN.size.height;
                //[[CDTContextHostProvider sharedInstance] hostViewForApplicationWithBundleID:bundleID].transform = CGAffineTransformScale(CGAffineTransformIdentity, width, height);
}
- (void)removeFloater {
    [UIView animateWithDuration:0.5 animations:^{
        _overlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        _overlay.hidden = YES;
        _onScreen = NO;
        //[self.medusa _bringToForeground:self.app.bundleIdentifier withFrame:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)];
        CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)[NSString stringWithFormat:@"Resize-%@", self.app.bundleIdentifier], NULL, (__bridge CFDictionaryRef) @{@"frame" : [NSValue valueWithCGRect:CGRectMake(0, 0, SCREEN.size.width, SCREEN.size.height)]} , YES);
        //[[[NSClassFromString(@"SBMainSwitcherViewController") class] sharedInstance] _disableContextHostingForApp:[[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:_bundleID]];
        //[self.appView _disableContextHosting]
        //[self.appView removeFromSuperview];
        //[self.appView invalidate];
        //[self.appView release];
        //self.slideView.view.appView.frame = CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height);
        //[self.medusa _sendToBackground:self.app.bundleIdentifier];
        //[[CDTContextHostProvider sharedInstance] stopHostingForBundleID:_bundleID];
        [((SBAppContainerView *)self.slideView.view).appView invalidate];
        //[self.slideView _invalidateSceneDerivedObjects];
        //[self.appView dealloc];
        //[self.slideView dealloc];
        [self.medusa _sendToBackground:self.app.bundleIdentifier];
        //[self.appView performSelector:@selector(invalidate)];
        //self.appView = nil;

        //[self dealloc];
    }];
}
- (void)addFloater {
    _overlay.hidden = NO;
    _overlay.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        _overlay.alpha = 1.0;
    } completion:^(BOOL finished) {
        _onScreen = YES;
    }];
}
- (void)createFloater:(NSString*)bundleID {
    SBMedusaAppsTestRecipe *medusa = [[[NSClassFromString(@"SBMedusaAppsTestRecipe") class] alloc] init];
    self.medusa = medusa;
    _overlay = [[UIWindow alloc] initWithFrame:SCREEN];
    _overlay.rootViewController = _rootViewController = [FloaterRootViewController new];
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

    UILongPressGestureRecognizer *lpgrRemoveFloater = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [_rootViewController.view addGestureRecognizer:lpgrRemoveFloater];

    UIPanGestureRecognizer *pgrMoveFloater = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_rootViewController.view addGestureRecognizer:pgrMoveFloater];

    SBApplication *app = [[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:bundleID];
    self.app = app;

    [self.medusa _bringToForeground:self.app.bundleIdentifier withFrame:CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height)];

    /*_DECAppItem *appItem = [[NSClassFromString(@"_DECAppItem") class] appWithBundleIdentifier:self.app.bundleIdentifier];
    _DECResult *appResult = [[[NSClassFromString(@"_DECResult") class] alloc] initWithConsumer:3];
    [appResult setReason:1];

    _SBExpertAppSuggestion *appSuggestion = [[[NSClassFromString(@"_SBExpertAppSuggestion") class] alloc] initWithAppSuggestion:appItem result:appResult];

    SBSwitcherAppSuggestionSlideUpView *slideUpView = [[[NSClassFromString(@"SBSwitcherAppSuggestionSlideUpView") class] alloc] initWithFrame:CGRectMake(0,20,[self floaterOpenSize].width,[self floaterOpenSize].height-20) appSuggestion:appSuggestion];
    self.slideView = slideUpView; */
    //[[self contextManagerForApplication:sbapplication] enableHostingForRequester:[(SBApplication *)sbapplication bundleIdentifier] orderFront:YES];
    SBWorkspaceApplication *workspaceApplication = [[NSClassFromString(@"SBWorkspaceApplication") class] entityForApplication:self.app];
    SBLayoutElement *applicationLayoutElement = [workspaceApplication layoutElementForRole:1];
    NSSet *elements = [NSSet setWithObjects:applicationLayoutElement, nil];
    SBMainDisplayLayoutState *layoutState = [[[NSClassFromString(@"SBMainDisplayLayoutState") class] alloc] _initWithElements:elements];

    SBAppContainerViewController *appController = [[[NSClassFromString(@"SBAppContainerViewController") class] alloc] initWithDisplay:[[UIScreen mainScreen] valueForKey:@"_fbsDisplay"]];
    appController.view.frame = CGRectMake(0,20,[self floaterOpenSize].width,[self floaterOpenSize].height-20);
    [appController configureWithEntity:workspaceApplication forElement:applicationLayoutElement layoutState:layoutState];
    
    self.slideView = appController;
    //[appController loadView];



        //[[CDTContextHostProvider sharedInstance] launchSuspendedApplicationWithBundleID:bundleID];
        //[[CDTContextHostProvider sharedInstance] forceRehostingOnBundleID:bundleID];

    //reapply new settings to scene
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //self.appView = slideUpView.appView;
            //self.contextView = [self.appView _contextHostView];
           // [[self.appView _sceneMonitor].scene.contextHostManager enableHostingForRequester:self.app.bundleIdentifier orderFront:NO];
                //CGFloat *width = SCREEN.size.width
                //view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.70, 0.70);
                //[self.appView _enableContextHosting];
                //[self.appView setDisplayMode: 3 withAnimationFactory:[[NSClassFromString(@"SBAppView") class] defaultDisplayModeAnimationFactory] completion:nil];
        //[[CDTContextHostProvider sharedInstance] launchSuspendedApplicationWithBundleID:bundleID];
        //[[CDTContextHostProvider sharedInstance] forceRehostingOnBundleID:bundleID];
   /* [UIApplication.sharedApplication launchApplicationWithIdentifier:bundleID suspended:YES];
    [[[NSClassFromString(@"FBProcessManager") class] sharedInstance] createApplicationProcessForBundleID:[(SBApplication *)self.app bundleIdentifier]];
    SBApplication *application = [[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:bundleID];
    FBSMutableSceneSettings *sceneSettings = [[[(SBApplication *)self.app mainScene] mutableSettings] mutableCopy];
    [sceneSettings setBackgrounded:NO]; 

    //reapply new settings to scene
    [[(SBApplication *)self.app mainScene] _applyMutableSettings:sceneSettings withTransitionContext:nil completion:nil]; */
                //self.appView.frame = CGRectMake(0,20,[self floaterOpenSize].width,[self floaterOpenSize].height-20);
    //self.appView = slideUpView;
                [_viewOpen addSubview:appController.view];
                //float width = _viewOpen.frame.size.width/SCREEN.size.width;
                //float height = _viewOpen.frame.size.height/SCREEN.size.height;
                //[[CDTContextHostProvider sharedInstance] hostViewForApplicationWithBundleID:bundleID].transform = CGAffineTransformScale(CGAffineTransformIdentity, width, height);
        //});
}
- (void)setFloaterType:(FloaterType)type animated:(BOOL)animated {
    _type = type;

    CGRect frame = _overlay.frame;
    NSInteger cornerRadius = _overlay.layer.cornerRadius;

    switch (type) {
        case FloaterTypeOpen:
        [self reloadStuff];
            //SBApplication *app = [[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:_bundleID];
           // [UIApplication.sharedApplication launchApplicationWithIdentifier:_bundleID suspended:YES];
            //[[[NSClassFromString(@"FBProcessManager") class] sharedInstance] createApplicationProcessForBundleID:[(SBApplication *)self.app bundleIdentifier]];
            [self.medusa _bringToForeground:self.app.bundleIdentifier withFrame:CGRectMake(0,0,SCREEN.size.width,SCREEN.size.height)];
            FBSMutableSceneSettings *sceneSettings = [[[(SBApplication *)self.app mainScene] mutableSettings] mutableCopy];
            //[sceneSettings setBackgrounded:NO];
            [sceneSettings setInterfaceOrientation:1];
            [sceneSettings setFrame:CGRectMake(0,20,[self floaterOpenSize].width,[self floaterOpenSize].height-20)];
            [[(SBApplication *)self.app mainScene] _applyMutableSettings:sceneSettings withTransitionContext:nil completion:nil];
            //FBWindowContextHostManager *manager = [self.slideView.view.appView _sceneMonitor].scene.contextHostManager;
            //[manager enableHostingForRequester:_bundleID priority:1];
            NSString *windowChange = [NSString stringWithFormat:@"Resize-%@", self.app.displayIdentifier];
            CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)windowChange, NULL, (__bridge CFDictionaryRef) @{@"frame" : [NSValue valueWithCGRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight * .5)] } , YES);
            CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)[NSString stringWithFormat:@"Resize-%@", self.app.bundleIdentifier], NULL, (__bridge CFDictionaryRef) @{@"frame" : [NSValue valueWithCGRect:CGRectMake(0,20,[self floaterOpenSize].width,[self floaterOpenSize].height-20)]} , YES);
            frame.size = [self floaterOpenSize];
            cornerRadius = [self floaterOpenCornerRadius];
            /*SBAppResizingPlaceholderView *placeHolder = [[[NSClassFromString(@"SBAppResizingPlaceholderView") class] alloc] initWithAppView:self.slideView.view.appView];
            SBApplicationIcon *appIcon = [[[NSClassFromString(@"SBApplicationIcon") class] alloc] initWithApplication:self.app];
            SBSceneViewAppIconView *appIconScene = [[[NSClassFromString(@"SBSceneViewAppIconView") class] alloc] initWithIcon:appIcon];
            [placeHolder setAppIconView:appIconScene];
            [_rootViewController.view addSubview:placeHolder];*/
            //[[CDTContextHostProvider sharedInstance] forceRehostingOnBundleID:_bundleID];
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
            //float width = frame.size.width/SCREEN.size.width;
            //float height = frame.size.height/SCREEN.size.height;
            //self.contextView.transform = CGAffineTransformScale(CGAffineTransformIdentity, width, height);
        }];
    } else {
        _overlay.frame = frame;
        _overlay.layer.cornerRadius = cornerRadius;
        _rootViewController.view.layer.cornerRadius = cornerRadius;
        _overlay.layer.shadowRadius = cornerRadius;
        //float width = frame.size.width/SCREEN.size.width;
        //float height = frame.size.height/SCREEN.size.height;
        //self.contextView.transform = CGAffineTransformScale(CGAffineTransformIdentity, width, height);
    }
}

#pragma mark - GestureRecognizer Functions
- (void)handleTap:(UITapGestureRecognizer*)recognizer {
    [self setFloaterType:(_type ? FloaterTypeOpen : FloaterTypeClosed) animated:YES];
    [UIView animateWithDuration:0.5 animations:^{
        if (_type == FloaterTypeClosed) {
            viewClosed.alpha = 1.0;
            _viewOpen.alpha = 0.0;
        } else {
            viewClosed.alpha = 0.0;
            _viewOpen.alpha = 1.0;
        }
    }];
}
- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan && _type == FloaterTypeClosed) {
        [self toggleFloater];
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
    return CGSizeMake(SCREEN.size.width/2, SCREEN.size.height/2);
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
@end
