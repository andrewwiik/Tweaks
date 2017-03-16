#import "CCXNoEffectsButton.h"

%subclass CCXNoEffectsButton : CCUIControlCenterButton
- (void)_updateEffects {
	[(UILabel *)[self valueForKey:@"_label"] layer].filters = nil;
	[(UILabel *)[self valueForKey:@"_alteredStateLabel"] layer].filters = nil;
	[(UIView *)[self valueForKey:@"_backgroundFlatColorView"] setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.25]];
	[((UIView *)[self valueForKey:@"_backgroundFlatColorView"]).layer setCornerRadius:((UIView *)[self valueForKey:@"_backgroundFlatColorView"]).frame.size.height/2];
	return;
}
- (void)_updateForStateChange {
	[(UILabel *)[self valueForKey:@"_label"] layer].filters = nil;
	[(UILabel *)[self valueForKey:@"_alteredStateLabel"] layer].filters = nil;
	[(UIView *)[self valueForKey:@"_backgroundFlatColorView"] setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.25]];
	[((UIView *)[self valueForKey:@"_backgroundFlatColorView"]).layer setCornerRadius:((UIView *)[self valueForKey:@"_backgroundFlatColorView"]).frame.size.height/2];
	return;
}
- (void)_updateBackgroundForStateChange {
	[(UILabel *)[self valueForKey:@"_label"] layer].filters = nil;
	[(UILabel *)[self valueForKey:@"_alteredStateLabel"] layer].filters = nil;
	[(UIView *)[self valueForKey:@"_backgroundFlatColorView"] setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.25]];
	[((UIView *)[self valueForKey:@"_backgroundFlatColorView"]).layer setCornerRadius:((UIView *)[self valueForKey:@"_backgroundFlatColorView"]).frame.size.height/2];
	return;
}
- (void)_updateGlyphAndTextForStateChange {
	[(UILabel *)[self valueForKey:@"_label"] layer].filters = nil;
	[(UILabel *)[self valueForKey:@"_alteredStateLabel"] layer].filters = nil;
	[(UIView *)[self valueForKey:@"_backgroundFlatColorView"] setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.25]];
	[((UIView *)[self valueForKey:@"_backgroundFlatColorView"]).layer setCornerRadius:((UIView *)[self valueForKey:@"_backgroundFlatColorView"]).frame.size.height/2];
	return;
}

// %new
// + (id)capsuleButtonWithText:(id)arg1 {
// 	self =
// }
%end