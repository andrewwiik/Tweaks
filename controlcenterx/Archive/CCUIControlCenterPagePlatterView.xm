#import "headers.h"

%hook CCUIControlCenterPagePlatterView
%property (nonatomic, assign) BOOL suppressRenderingMask;

- (void)_rerenderPunchThroughMaskIfNecessary {
	if (self.suppressRenderingMask)
		return;
	else 
		%orig;
}
%end