#import "CCUIControlCenterPagePlatterViewDelegate-Protocol.h"

@class NCMaterialView, CCUIControlCenterPageContainerViewController;

@interface CCUIControlCenterPagePlatterView : UIView {

	NCMaterialView* _baseMaterialView;
	UIImageView* _whiteLayerView;
	UIView* _contentView;
	NSSet* _renderedPunchOutMasks;
	NSLayoutConstraint* _topMargin;
	NSLayoutConstraint* _bottomMargin;
	NSLayoutConstraint* _leadingMargin;
	NSLayoutConstraint* _trailingMargin;

}

@property (nonatomic,retain) UIView * contentView;                   //@synthesize contentView=_contentView - In the implementation block
@property (assign,nonatomic) UIEdgeInsets marginInsets; 
@property (nonatomic, retain) CCUIControlCenterPageContainerViewController *delegate;
-(void)setContentView:(UIView *)arg1 ;
-(void)layoutSubviews;
-(UIView *)contentView;
-(void)dealloc;
-(id)initWithDelegate:(id)arg1 ;
-(UIEdgeInsets)marginInsets;
-(void)setMarginInsets:(UIEdgeInsets)arg1 ;
-(void)_reduceTransparencyStatusDidChange;
-(void)_rerenderPunchThroughMaskIfNecessary;
-(void)_recursivelyVisitSubviewsOfView:(id)arg1 forPunchedThroughView:(id)arg2 collectingMasksIn:(id)arg3 ;
-(BOOL)_searchForUpdatedMask;
-(BOOL)_shouldSuppressCachingPunchOutMaskImage;
-(id)_renderAlphaOnlyPunchThroughMaskForPlatterSize:(CGSize)arg1 ;
-(id)_systemAgent;
// -(id)ccuiPunchOutMaskedContainer;
@end