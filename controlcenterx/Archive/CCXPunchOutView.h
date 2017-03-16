#import "headers.h"

@interface NCVibrantRuleStyling : NCVibrantStyling
@end

@interface CCXPunchOutStyling : NCVibrantRuleStyling
@end

@interface CCXPunchOutView : UIView
@property (nonatomic,assign) NSInteger style;                                //@synthesize style=_style - In the implementation block
@property (nonatomic,assign) CGFloat cornerRadius;                            //@synthesize cornerRadius=_cornerRadius - In the implementation block
@property (nonatomic,assign) NSUInteger roundCorners;  
- (CCUIPunchOutMask *)ccuiPunchOutMaskForView:(id)arg1;
@end