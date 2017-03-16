//
//  ICGLayerAnimation.m
//  ICGTransitionAnimationDemo
//
//  Created by HuongDo on 5/16/14.
//  Copyright (c) 2014 ichigo. All rights reserved.
//

#import "ICGSlideOverAnimation.h"
#import "../../CCXMainControlsPageViewController.h"
#import "../../CCXNavigationViewController.h"

@implementation ICGSlideOverAnimation

#pragma mark - Init method

- (instancetype)initWithType:(ICGLayerAnimationType)type
{
    self = [super init];
    if (self){
        self.type = type;
    }
    return self;
}


#pragma mark - Overriden method

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromView:(UIView *)fromView toView:(UIView *)toView
{
    UIView *containerView = [transitionContext containerView];
    
    switch (self.type) {
        case ICGLayerAnimationReveal:
            [self executeRevealAnimationIn:containerView from:fromView to:toView withContext:transitionContext];
            break;
            
        case ICGLayerAnimationCover:
            [self executeCoverAnimationIn:containerView from:fromView to:toView withContext:transitionContext];
            break;
    }
}


#pragma mark - Helper methods

- (void) executeRevealAnimationIn:(UIView *)containerView from:(UIView *)fromView to:(UIView *)toView withContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    [containerView addSubview:toView];
    [containerView addSubview:fromView];
    
    CGPoint temporaryPoint = CGPointMake(-CGRectGetMaxX(toView.frame), CGRectGetMidY(toView.frame));
    CGPoint centerPoint = toView.center;

    BOOL updateMaskingStuffFrom = NO;
    BOOL updateMaskingStuffTo = NO;

    
    if (self.reverse){
        toView.center = temporaryPoint;
        [UIView animateWithDuration:self.animationDuration/2 animations:^{
            if (updateMaskingStuffFrom) {
                ((CCXMainControlsPageViewController *)fromView.delegate).animationProgressValue = 1;
            }
            if (updateMaskingStuffTo) {
                ((CCXMainControlsPageViewController *)toView.delegate).animationProgressValue = 1;
            }
            fromView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            fromView.alpha = 0.3;
        } completion:^(BOOL finished){
        }];
        
        [UIView animateWithDuration:self.animationDuration delay:(self.animationDuration/8) usingSpringWithDamping:0.8f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            if (updateMaskingStuffFrom) {
                ((CCXMainControlsPageViewController *)fromView.delegate).animationProgressValue = 7;
            }
            if (updateMaskingStuffTo) {
                ((CCXMainControlsPageViewController *)toView.delegate).animationProgressValue = 7;
            }
            toView.center = centerPoint;
            fromView.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [fromView removeFromSuperview];
        }];
    } else {
        toView.alpha = 0.3;
        toView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:self.animationDuration animations:^{

            fromView.center = temporaryPoint;
            toView.transform = CGAffineTransformIdentity;
            toView.alpha = 1.0;
        } completion:^(BOOL finished){
            [transitionContext completeTransition:YES];
            [fromView removeFromSuperview];
        }];
        
    }
}

- (void) executeCoverAnimationIn:(UIView *)containerView from:(UIView *)fromView to:(UIView *)toView withContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    CATransform3D t1 = CATransform3DIdentity;
   // t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 1, 1, 1);
   // t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
   // 
    CATransform3D t2 = CATransform3DIdentity;
  //  t2.m34 = t1.m34;
    //t2 = CATransform3DTranslate(t2, 0, fromView.frame.size.height*-0.08, 0);
    t2 = CATransform3DScale(t2, 1, 1, 1);

    CATransform3D t3 = CATransform3DIdentity;
    t3 = CATransform3DScale(t3, 1.05, 1, 1);

    CATransform3D t4 = CATransform3DIdentity;
    t4 = CATransform3DScale(t4, 2, 1, 1);

    
    if (!self.reverse){
        CGRect offScreenFrame1 = containerView.frame;
        offScreenFrame1.origin.x = containerView.frame.size.width;
        toView.frame = offScreenFrame1;


        CGRect offScreenFrame = containerView.frame;
        offScreenFrame.origin.x = containerView.frame.size.width*-1;
        
        [containerView insertSubview:toView aboveSubview:fromView];
        
        CFTimeInterval duration = self.animationDuration;
        CFTimeInterval halfDuration = duration/2;
        
       //  CCXNavigationViewController *navController = nil;
       // // CGRect leftFrame1 = CGRectMake()
       //  if ([(CCXNavigationViewController *)((CCUIControlCenterPageContainerViewController *)[[fromView ccuiPunchOutMaskedContainer] valueForKey:@"_delegate"]).contentViewController isKindOfClass:NSClassFromString(@"CCXNavigationViewController")]) {
       //      navController = (CCXNavigationViewController *)((CCUIControlCenterPageContainerViewController *)[[fromView ccuiPunchOutMaskedContainer] valueForKey:@"_delegate"]).contentViewController;
       //  }

       // [navController _rerenderPunchThroughMaskIfNecessary];
    
        [UIView animateKeyframesWithDuration:halfDuration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:1.0f animations:^{
                
                toView.frame = containerView.frame;
                fromView.frame = offScreenFrame;
               // navController.maskingView.frame = offScreenFrame;
               
            }];
            
    
            
        } completion:^(BOOL finished) {
            CGRect offScreenFrame = containerView.frame;
        offScreenFrame.origin.x = containerView.frame.size.width*-1;
          //  CCXNavigationViewController *navController = nil;
           // CGRect leftFrame1 = CGRectMake()
            // if ([(CCXNavigationViewController *)((CCUIControlCenterPageContainerViewController *)[[fromView ccuiPunchOutMaskedContainer] valueForKey:@"_delegate"]).contentViewController isKindOfClass:NSClassFromString(@"CCXNavigationViewController")]) {
            //     navController = (CCXNavigationViewController *)((CCUIControlCenterPageContainerViewController *)[[fromView ccuiPunchOutMaskedContainer] valueForKey:@"_delegate"]).contentViewController;
            // }
           // navController.maskingView.hidden = YES;
           // navController.maskingView.frame = offScreenFrame;
            [transitionContext completeTransition:YES];
        }];
        
        
        

    } else {
        if (self.modalTransition){
            toView.frame = containerView.frame;
        }
        
        CGRect offScreenFrame = containerView.frame;
        offScreenFrame.origin.x = containerView.frame.size.width*-1;
        toView.frame = offScreenFrame;



        CGRect offScreenFrame1 = containerView.frame;
        offScreenFrame1.origin.x = containerView.frame.size.width;

        CGRect offScreenFrame2 = containerView.frame;
        offScreenFrame2.origin.x = containerView.frame.size.width*-1;

        
        [containerView insertSubview:toView belowSubview:fromView];
        
        CFTimeInterval duration = self.animationDuration;
        CFTimeInterval halfDuration = duration/2;
        
        // CCXNavigationViewController *navController = nil;
     
        // if ([(CCXNavigationViewController *)((CCUIControlCenterPageContainerViewController *)[[fromView ccuiPunchOutMaskedContainer] valueForKey:@"_delegate"]).contentViewController isKindOfClass:NSClassFromString(@"CCXNavigationViewController")]) {
        //     navController = (CCXNavigationViewController *)((CCUIControlCenterPageContainerViewController *)[[fromView ccuiPunchOutMaskedContainer] valueForKey:@"_delegate"]).contentViewController;
        // }
        //navController.maskingView.hidden = NO;
        // navController.maskingView.hidden = YES;
        // //navController.maskingView.frame = containerView.frame;
        // toView.frame = containerView.frame;
        // navController.platterView.suppressRenderingMask = NO;
        // [navController.mainViewController _updateAllSectionVisibilityAnimated:NO];
        // [navController.platterView _rerenderPunchThroughMaskIfNecessary];
        // navController.platterView.suppressRenderingMask = YES;
        // navController.maskingView.hidden = NO;

        //navController.maskingView.frame = offScreenFrame2;
        toView.frame = offScreenFrame;
    
        
        [UIView animateKeyframesWithDuration:halfDuration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:1.0f animations:^{
                
                toView.frame = containerView.frame;
                //navController.maskingView.frame = containerView.frame;


                fromView.frame = offScreenFrame1;
               
            }];
            
           
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];

    }
    
}

@end
