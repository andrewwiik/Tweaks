#import <ControlCenterUI/CCUIControlCenterSectionView.h>
#import <ControlCenterUI/CCUIControlCenterPushButton.h>

@interface CCUINightShiftContentView : CCUIControlCenterSectionView {

	CCUIControlCenterPushButton* _button;

}

@property (nonatomic,readonly) CCUIControlCenterPushButton * button;              //@synthesize button=_button - In the implementation block
-(id)initWithFrame:(CGRect)arg1 ;
-(CCUIControlCenterPushButton *)button;
-(CGSize)intrinsicContentSize;
-(UIColor *)_selectedStateColor;
-(void)addMediaControlsView;
@end
