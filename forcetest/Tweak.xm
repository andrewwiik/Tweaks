%hook UITouch
- (CGFloat)force {
	// [self setValue:(CGFloat)400 forKey:@"_pressure"];
	MSHookIvar<CGFloat>(self, "_pressure") = 4000;
	MSHookIvar<CGFloat>(self, "_previousPressure") = 3000;
	MSHookIvar<CGFloat>(self, "_maximumPossiblePressure") = 5000;
	NSLog(@"Pressure: %@ /n Previous Pressure: %@", [self valueForKey:@"_pressure"], [self valueForKey:@"_previousPressure"]);
	return %orig;
}

- (BOOL)_supportsForce {
return YES;
}
%end

%hook UITraitCollection
- (int)forceTouchCapability {
	return 2;
}
+ (id)traitCollectionWithForceTouchCapability:(int)arg1 {
	return %orig(2);
}
%end

%hook UIDevice
- (BOOL)_supportsForceTouch {
return YES;
}
%end

// CGFloat x;
// %hook _UITouchForceMessage
// - (void)setUnclampedTouchForce:(CGFloat)touchForce {
// 	%orig(x);
// 	x+=10;
// 	if (x > 400) x = 0;
// }
// %end