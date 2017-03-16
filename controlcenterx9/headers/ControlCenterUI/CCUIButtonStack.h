#import <ControlCenterUI/CCUIControlCenterSectionView.h>
#import <ControlCenterUI/CCUIButtonStackLayoutDelegate-Protocol.h>

@interface CCUIButtonStack : CCUIControlCenterSectionView
{
    NSMutableArray *_buttons;
    UIStackView *_stackView;
    NSLayoutConstraint *_topMargin;
    NSLayoutConstraint *_bottomMargin;
    NSLayoutConstraint *_leadingMargin;
    NSLayoutConstraint *_trailingMargin;
    NSUInteger _buttonStretchThreshold;
    id <CCUIButtonStackLayoutDelegate> _layoutDelegate;
}

@property(nonatomic)  id <CCUIButtonStackLayoutDelegate> layoutDelegate; // @synthesize layoutDelegate=_layoutDelegate;
@property(nonatomic) NSUInteger buttonStretchThreshold; // @synthesize buttonStretchThreshold=_buttonStretchThreshold;
- (void)resortButtons;
@property(copy, nonatomic) NSArray *buttons;
- (void)removeButton:(id)arg1;
- (void)addButton:(id)arg1;
@property(nonatomic) UIEdgeInsets marginInsets; // @dynamic marginInsets;
- (void)_updateStretching;
@property(nonatomic) NSInteger axis; // @dynamic axis;
@property(nonatomic) CGFloat interButtonPadding; // @dynamic interButtonPadding;
- (void)layoutSubviews;
- (id)initWithFrame:(CGRect)arg1;

@end

