@protocol CCUIControlCenterPageContainerViewControllerDelegate
@required
-(NSInteger)layoutStyle;
-(void)containerViewControllerWantsDismissal:(id)arg1;
-(void)containerViewController:(id)arg1 backdropViewDidUpdate:(id)arg2;
-(void)visibilityPreferenceChangedForContainerViewController:(id)arg1;
-(id)controlCenterSystemAgent;
// - (CGFloat)contentHeightForContainerView:(CCUIConterPageContainerViewController)
- (CGFloat)_scrollviewContentMaxHeight;
@end