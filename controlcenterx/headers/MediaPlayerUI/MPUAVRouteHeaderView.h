#import <UIKit/UIControl.h>
#import <MediaPlayerUI/MPAVRoute.h>
#import <MediaPlayerUI/MPUAVRouteHeaderLabel.h>

@interface MPUAVRouteHeaderView : UIControl {

	CAShapeLayer* _topSeparatorLayer;
	CAShapeLayer* _bottomSeparatorLayer;
	UIImageView* _iconImageView;
	UIImageView* _disclosureIndicatorImageView;
	BOOL _activated;
	MPAVRoute* _route;
	UIVisualEffect* _primaryVisualEffect;
	UIVisualEffect* _secondaryVisualEffect;
	MPUAVRouteHeaderLabel* _textLabel;

}

@property (nonatomic,retain) MPAVRoute * route;                                   //@synthesize route=_route - In the implementation block
@property (nonatomic,retain) UIVisualEffect * primaryVisualEffect;                //@synthesize primaryVisualEffect=_primaryVisualEffect - In the implementation block
@property (nonatomic,retain) UIVisualEffect * secondaryVisualEffect;              //@synthesize secondaryVisualEffect=_secondaryVisualEffect - In the implementation block
@property (assign,getter=isActivated,nonatomic) BOOL activated;                   //@synthesize activated=_activated - In the implementation block
@property (nonatomic,readonly) MPUAVRouteHeaderLabel * textLabel;                 //@synthesize textLabel=_textLabel - In the implementation block
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(id)initWithCoder:(id)arg1 ;
-(void)_init;
-(void)setHighlighted:(BOOL)arg1 ;
-(MPUAVRouteHeaderLabel *)textLabel;
-(void)setActivated:(BOOL)arg1 ;
-(MPAVRoute *)route;
-(void)setRoute:(MPAVRoute *)arg1 ;
-(UIVisualEffect *)primaryVisualEffect;
-(UIVisualEffect *)secondaryVisualEffect;
-(void)setPrimaryVisualEffect:(UIVisualEffect *)arg1 ;
-(void)setSecondaryVisualEffect:(UIVisualEffect *)arg1 ;
-(BOOL)isActivated;
-(void)setActivated:(BOOL)arg1 animated:(BOOL)arg2 ;
-(id)_disclosureIconImageForCurrentState;
-(void)_updateBottomClippingForAnimatedTransition;
@end
