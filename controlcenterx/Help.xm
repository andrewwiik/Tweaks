// %hook SBIconController
// %new
// - (void)_revealMenuForIconView:(SBIconView *)iconView {
// 	if ([iconView appIconForceTouchGestureRecognizer]) {
// 		UIGestureRecognizer *forceGesture = [iconView appIconForceTouchGestureRecognizer];
// 		NSMutableArray *targets = [forceGesture valueForKeyPath:@"_targets"];
// 		for (id targetContainer in targets) {
// 			if ([(NSObject *)targetContainer valueForKeyPath:@"_target"]) {
// 				id target = [(NSObject *)targetContainer valueForKeyPath:@"_target"];
// 				if (target) {
// 					if ([(NSObject *)target isKindOfClass:NSClassFromString(@"SBUIIconForceTouchController")]) {
// 						SBUIIconForceTouchController *forceController = [targetContainer valueForKeyPath:@"_target"];
// 						[forceController _setupWithGestureRecognizer:forceGesture];
// 						[forceController _presentAnimated:YES withCompletionHandler:nil];
// 					}
// 				}
// 			}
// 		}

// 	}
// }
// %end