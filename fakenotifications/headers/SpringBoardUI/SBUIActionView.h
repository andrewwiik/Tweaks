#import <SpringBoardUI/SBUIActionViewLabel.h>

@interface SBUIActionView : UIView {

	BOOL _interfaceOrientationIsPortrait;
	UIImageView* _imageView;
	UIView* _textContainer;
	SBUIActionViewLabel* _titleLabel;
	SBUIActionViewLabel* _subtitleLabel;
	NSArray* _imageViewLayoutConstraints;
	BOOL _highlighted;
	NSInteger _imagePosition;

}
@property (assign,nonatomic) NSInteger imagePosition;                            //@synthesize imagePosition=_imagePosition - In the implementation block
@property (assign,getter=isHighlighted,nonatomic) BOOL highlighted;              //@synthesize highlighted=_highlighted - In the implementation block
-(id)initWithFrame:(CGRect)arg1 ;
-(id)initWithCoder:(id)arg1 ;
-(void)didMoveToSuperview;
-(void)setHighlighted:(BOOL)arg1 ;
-(BOOL)isHighlighted;
-(id)initWithAction:(id)arg1 ;
-(void)setHighlighted:(BOOL)arg1 withFeedbackRetargetBehavior:(id)arg2 ;
-(void)_updateImageViewLayoutConstraints;
-(void)_setupSubviews;
-(void)setImagePosition:(NSInteger)arg1 ;
-(NSInteger)imagePosition;
@end