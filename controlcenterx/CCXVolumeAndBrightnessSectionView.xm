#import "CCXVolumeAndBrightnessSectionView.h"

%subclass CCXVolumeAndBrightnessSectionView : CCUIControlCenterSectionView
-(CGSize)intrinsicContentSize {
	if (self.layoutStyle == 1) {
		return CGSizeMake(-1, 60);
	} else {
		return CGSizeMake(-1, 23);
	}
}
- (UIEdgeInsets)layoutMargins {
	if (self.layoutStyle == 1) {
		return UIEdgeInsetsMake(0,1,0,1);
	} else {
		return UIEdgeInsetsMake(-5,1,1,1);
	}
}
%end