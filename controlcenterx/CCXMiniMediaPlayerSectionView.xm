#import "CCXMiniMediaPlayerSectionView.h"
#import "CCXVolumeAndBrightnessSectionController.h"

%subclass CCXMiniMediaPlayerSectionView : CCUIControlCenterSectionView
%property (nonatomic, retain) CCXMiniMediaPlayerMediaControlsView *mediaControlsView;

- (id)init {
	CCXMiniMediaPlayerSectionView *orig = %orig;
	if (orig) {

	}
	return orig;
}
- (void)layoutSubviews {
	%orig;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (self.frame.size.height == [self superview].frame.size.height) {
			CGRect newFrame = self.frame;
			newFrame.size.height = newFrame.size.height+24;
			self.frame = newFrame;
		}
	} else {
		CGRect newFrame = self.frame;
		newFrame.size.height = 100;
		self.frame = newFrame;
	}

	if (self.mediaControlsView) {

		self.mediaControlsView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
	}
}
-(CGSize)intrinsicContentSize {
	return CGSizeMake(-1,100);
}
%end