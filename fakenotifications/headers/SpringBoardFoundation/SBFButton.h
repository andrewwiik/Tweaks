@interface SBFButton : UIButton

- (BOOL)_drawingAsSelected;
- (void)_touchUpInside;
- (void)_updateForStateChange;
- (void)_updateSelected:(BOOL)arg1 highlighted:(BOOL)arg2;
- (id)initWithFrame:(CGRect)arg1;
- (void)setHighlighted:(BOOL)arg1;
- (void)setSelected:(BOOL)arg1;

@end