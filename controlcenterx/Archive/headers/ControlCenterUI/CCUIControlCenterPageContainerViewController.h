#import "CCUIControlCenterPageContainerViewControllerDelegate-Protocol.h"
#import "CCUIControlCenterPageContentViewControllerDelegate-Protocol.h"
#import "CCUIControlCenterPagePlatterViewDelegate-Protocol.h"
#import "CCUIControlCenterObserver-Protocol.h"
#import "CCUIControlCenterPageContentProviding-Protocol.h"
#import "CCUIControlCenterPagePlatterView.h"

@interface CCUIControlCenterPageContainerViewController : UIViewController <CCUIControlCenterPageContentViewControllerDelegate, CCUIControlCenterPagePlatterViewDelegate, CCUIControlCenterObserver> {

	UIViewController* _contentViewController;
	CGFloat _revealPercentage;
	NSMutableSet* _punchOutMaskCachingSuppressionReasons;
	id<CCUIControlCenterPageContainerViewControllerDelegate> _delegate;

}

@property (nonatomic,retain) id<CCUIControlCenterPageContainerViewControllerDelegate> delegate;                             //@synthesize delegate=_delegate - In the implementation block
@property (nonatomic,readonly) id<CCUIControlCenterPageContentProviding> contentViewController; 
@property (assign,nonatomic) CGFloat revealPercentage; 
@property (assign,nonatomic) UIEdgeInsets marginInsets; 
@property (nonatomic,readonly) BOOL shouldSuppressPunchOutMaskCaching; 
@property (nonatomic, retain) CCUIControlCenterPagePlatterView *view;
-(void)setDelegate:(id<CCUIControlCenterPageContainerViewControllerDelegate>)arg1 ;
-(id<CCUIControlCenterPageContainerViewControllerDelegate>)delegate;
-(void)loadView;
-(id<CCUIControlCenterPageContentProviding>)contentViewController;
-(void)viewDidLoad;
-(long long)layoutStyle;
-(UIEdgeInsets)marginInsets;
-(void)setMarginInsets:(UIEdgeInsets)arg1 ;
-(CGFloat)revealPercentage;
-(void)setRevealPercentage:(CGFloat)arg1 ;
-(id)initWithContentViewController:(id)arg1 delegate:(id)arg2 ;
-(void)contentViewControllerWantsDismissal:(id)arg1 ;
-(id)_pagePlatterView;
-(BOOL)shouldSuppressPunchOutMaskCaching;
-(id)_platterView;
-(id)controlCenterSystemAgent;
-(void)visibilityPreferenceChangedForContentViewController:(id)arg1 ;
-(void)beginSuppressingPunchOutMaskCachingForReason:(id)arg1 ;
-(void)endSuppressingPunchOutMaskCachingForReason:(id)arg1 ;
-(BOOL)dismissModalFullScreenIfNeeded;
-(void)controlCenterWillPresent;
-(void)controlCenterDidDismiss;
-(void)controlCenterWillBeginTransition;
-(void)controlCenterDidFinishTransition;
-(void)controlCenterWillFinishTransitionOpen:(BOOL)arg1 withDuration:(CGFloat)arg2 ;
@end