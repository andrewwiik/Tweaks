#import <SpringBoardFoundation/SBFButton.h>
#import <ControlCenterUI/CCUIControlCenterButtonDelegate-Protocol.h>

@interface CCUIControlCenterButton : SBFButton
{
    NSUInteger _buttonType;
    UIColor *_selectedColor;
    UIImageView *_glyphImageView;
    UILabel *_label;
    UIImageView *_alteredStateGlyphImageView;
    UILabel *_alteredStateLabel;
    UIView *_backgroundFlatColorView;
    BOOL _animatesStateChanges;
    BOOL _showingMenu;
    id <CCUIControlCenterButtonDelegate> _delegate;
    NSUInteger _roundCorners;
    UIImage *_glyphImage;
    UIImage *_selectedGlyphImage;
    CGFloat _naturalHeight;
}

+ (id)capsuleButtonWithText:(id)arg1;
+ (id)_buttonWithSelectedColor:(id)arg1 text:(id)arg2 type:(NSUInteger)arg3;
+ (id)roundRectButtonWithText:(id)arg1 selectedGlyphColor:(id)arg2;
+ (id)roundRectButtonWithText:(id)arg1;
+ (id)roundRectButton;
+ (id)circularButtonWithSelectedColor:(id)arg1;
+ (id)smallCircularButtonWithSelectedColor:(id)arg1;
@property(nonatomic) CGFloat naturalHeight; // @synthesize naturalHeight=_naturalHeight;
@property(retain, nonatomic) UIImage *selectedGlyphImage; // @synthesize selectedGlyphImage=_selectedGlyphImage;
@property(retain, nonatomic) UIImage *glyphImage; // @synthesize glyphImage=_glyphImage;
@property(nonatomic, getter=isShowingMenu) BOOL showingMenu; // @synthesize showingMenu=_showingMenu;
@property(nonatomic) NSUInteger roundCorners; // @synthesize roundCorners=_roundCorners;
@property(nonatomic) BOOL animatesStateChanges; // @synthesize animatesStateChanges=_animatesStateChanges;
@property(nonatomic)  id <CCUIControlCenterButtonDelegate> delegate; // @synthesize delegate=_delegate;
@property (nonatomic, retain) UIView *punchOutView;
@property (nonatomic) BOOL preventPunchOutMask;
// - (void).cxx_destruct;
- (void)settings:(id)arg1 changedValueForKey:(id)arg2;
- (void)_updateForDarkerSystemColorsChange:(id)arg1;
- (void)_updateForReduceTransparencyChange;
- (void)_updateEffects;
- (id)ccuiPunchOutMaskForView:(id)arg1;
- (CGFloat)cornerRadius;
- (void)didMoveToSuperview;
- (void)setEnabled:(BOOL)arg1;
- (void)_pressAction;
- (void)setGlyphImage:(id)arg1 selectedGlyphImage:(id)arg2 name:(id)arg3;
- (void)_updateForStateChange;
- (void)_updateBackgroundForStateChange;
- (void)_updateGlyphAndTextForStateChange;
- (NSInteger)_currentState;
- (BOOL)_drawingAsSelected;
- (void)_updateNaturalHeight;
- (id)_glyphImageForState:(NSInteger)arg1;
- (void)setBackgroundImage:(id)arg1 forState:(NSUInteger)arg2;
- (void)setImage:(id)arg1 forState:(NSUInteger)arg2;
@property(retain, nonatomic) NSString *text; // @dynamic text;
@property(nonatomic) NSInteger numberOfLines; // @dynamic numberOfLines;
@property(retain, nonatomic) UIFont *font; // @dynamic font;
- (void)layoutSubviews;
- (void)setBounds:(CGRect)arg1;
- (void)setFrame:(CGRect)arg1;
- (CGSize)sizeThatFits:(CGSize)arg1;
- (id)_effectiveSelectedColor;
- (BOOL)_isCapsuleButton;
- (BOOL)_isTextButton;
- (BOOL)_isRectTextButton;
- (BOOL)_isRectButton;
- (BOOL)_isCircleButton;
- (void)_setButtonType:(NSUInteger)arg1;
- (void)_calculateRectForGlyph:(CGRect *)arg1 rectForLabel:(CGRect *)arg2 ignoringBounds:(BOOL)arg3;
@property(readonly, nonatomic, getter=isInternal) BOOL internal;
- (CGSize)intrinsicContentSize;
- (id)_controlStateStringFromState:(NSInteger)arg1;
- (BOOL)_shouldAnimatePropertyWithKey:(id)arg1;
// - (void)dealloc;
- (id)initWithFrame:(CGRect)arg1;
- (id)initWithFrame:(CGRect)arg1 selectedColor:(id)arg2 text:(id)arg3 type:(NSUInteger)arg4;

// Remaining properties
// @property(readonly, copy) NSString *debugDescription;
// @property(readonly, copy) NSString *description;
// @property(readonly) NSUInteger hash;
// @property(readonly) Class superclass;

@end