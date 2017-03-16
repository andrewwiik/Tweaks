#import "CCXSliderToggleButton.h"

%subclass CCXSliderToggleButton : CCUIControlCenterButton
- (void)_updateEffects {
	%orig;
	((UIImageView *)[self valueForKey:@"_alteredStateGlyphImageView"]).layer.filters = [((UIImageView *)[self valueForKey:@"_glyphImageView"]).layer.filters mutableCopy];
}
-(void)_updateGlyphAndTextForStateChange {
	%orig;
	((UIImageView *)[self valueForKey:@"_alteredStateGlyphImageView"]).layer.filters = [((UIImageView *)[self valueForKey:@"_glyphImageView"]).layer.filters mutableCopy];
}
// - (NSUInteger)state {
// 	return 0;
// }
// - (NSInteger)_currentState {
// 	return 0;
// }
%end