#import "CCUIControlCenterSectionView.h"

@interface CCUIBrightnessContentView : CCUIControlCenterSectionView {

	BOOL _usesCompactHeight;

}

@property (assign,nonatomic) BOOL usesCompactHeight;              //@synthesize usesCompactHeight=_usesCompactHeight - In the implementation block
-(UIEdgeInsets)layoutMargins;
-(CGSize)intrinsicContentSize;
-(void)setUsesCompactHeight:(BOOL)arg1 ;
-(BOOL)usesCompactHeight;
@end