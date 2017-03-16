%hook SBDockIconListView
- (NSUInteger)iconColumnsOrRows {
	return 7;
}
+ (unsigned long long)iconColumnsForInterfaceOrientation:(long long)arg1 {
	return 7;
}
// - (NSUInteger)iconsInColumnForSpacingCalculation {
// 	return 8;
// }
%end
// 7 cols - landscape
// 6 rows landscape
// 6 cols - porttrait
// 7 rows - portrait
%hook SBRootIconListView 
+ (unsigned long long)iconColumnsForInterfaceOrientation:(long long)arg1 {
	if (arg1 == 3 || arg1 == 4) {
		return 6;
	}
	else return 4;
}

+ (unsigned long long)iconRowsForInterfaceOrientation:(long long)arg1 {
	if (arg1 == 3 || arg1 == 4) {
		return 4;
	}
	else return 6;
}

+ (unsigned long long)maxVisibleIconRowsInterfaceOrientation:(long long)arg1 {
	if (arg1 == 3 || arg1 == 4) {
		return 4;
	}
	else return 6;
}
%end

// @interface NewShit : NSObject
// - (NSString *)testString;
// @end

// @implementation NewShit
// - (id)init {
// 	return [super init];
// }
// - (NSString *)testString {
// 	return [NSString stringWithFormat:@"Shit Head"];
// }
// @end
%ctor {
	%init;
}