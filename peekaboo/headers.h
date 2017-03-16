@interface CCUIControlCenterButton : UIButton
@property (nonatomic) NSUInteger roundCorners;
@property (nonatomic, retain) NSString *text;
@end

@interface CCUIControlCenterPushButton : CCUIControlCenterButton
@end


@interface CCUINightShiftContentView : UIView
@property (nonatomic, readonly) CCUIControlCenterPushButton *button;
@end
