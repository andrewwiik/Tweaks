//when the user press the action ---> [self.icon setBadge:0];

//this is the array containing the bundle IDs
NSMutableArray *bundleIDArray = [[NSMutableArray alloc] init];

#define XIS_EMPTY(z) (!z || [(NSString *)z length] < 1)

@interface SBApplication : NSObject
- (void)setBadge:(id)arg1;
@end

@interface SBIcon : NSObject
- (id)badgeNumberOrString;
- (id)displayName;
- (id)applicationBundleID;
- (void)setBadge:(id)arg1;
- (_Bool)isApplicationIcon;
- (SBApplication *)application;
@end

@interface SBIconView : UIView
@property (retain, nonatomic) SBIcon *icon;
- (BOOL)iconHasBadge;
@end
@interface SBApplicationShortcutMenu : UIView
@property(retain, nonatomic) SBIconView *iconView;
@end
@interface SBSApplicationShortcutItem : NSObject
- (void)setBundleIdentifierToLaunch:(id)arg1;
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
- (void)setUserInfo:(id)arg1;
- (void)setUserInfoData:(id)arg1;
@end

@interface SBIconController : UIViewController
+ (id)sharedInstance;
- (void)_dismissShortcutMenuAnimated:(BOOL)arg1 completionHandler:(id)arg1;
@end
%hook SBApplicationShortcutStoreManager
- (id)shortcutItemsForBundleIdentifier:(NSString*)arg1 {
		NSArray *aryItems = [NSArray new];
		if (%orig != NULL || %orig != nil) {
			aryItems = %orig;
		}
		NSMutableArray *aryShortcuts = [aryItems mutableCopy];
		BOOL isInArray = NO;
		for (NSString *bundleID in bundleIDArray) {
			if ([arg1 isEqualToString: bundleID]) {
				isInArray = YES;
				break;
			}
		}
		if (isInArray) {
			SBSApplicationShortcutItem *newAction = [[%c(SBSApplicationShortcutItem) alloc] init];
    		//[newAction setIcon:[[SBSApplicationShortcutSystemIcon alloc] initWithType:UIApplicationShortcutIconTypeAdd]];
    		[newAction setLocalizedTitle:@"Reset Badge"];
    		[newAction setLocalizedSubtitle:@"Reset Badge Number"];
    		[newAction setType:[NSString stringWithFormat:@"resetBadge"]];
    		[aryShortcuts addObject:newAction];
		}
		return aryShortcuts;
}
%end
%hook SBApplicationShortcutMenu
- (void)menuContentView:(id)arg1 activateShortcutItem:(UIApplicationShortcutItem*)arg2 index:(long long)arg3 {
	NSString *shortcutType = arg2.type;
	if ([shortcutType isEqualToString: @"resetBadge"]) {
		[[self.iconView.icon application] setBadge:nil];
		[[%c(SBIconController) sharedInstance] _dismissShortcutMenuAnimated:YES completionHandler:nil];
	}
}
%end
%hook SBIconView

- (void)layoutSubviews {
	%orig;
	if([self iconHasBadge]) {
		if([self.icon isApplicationIcon]) {
			[bundleIDArray addObject:[self.icon applicationBundleID]];
		}
	}
}

%new
- (BOOL)iconHasBadge {
	if(![self isKindOfClass:[%c(SBIconView) class]])
		return NO;

	id badge = [self.icon badgeNumberOrString];

	NSCharacterSet* notNumbers = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];

	if([badge isKindOfClass:[NSString class]]) {
		if(!XIS_EMPTY(badge) && [badge rangeOfCharacterFromSet:notNumbers].location == NSNotFound) {
			return YES;
		}
	}
	if([badge isKindOfClass:[NSNumber class]])
		return YES;
	else
		return NO;
}

%end