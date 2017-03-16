//ethan arbuckle

#import "CDTContextHostProvider.h"

@implementation CDTContextHostProvider

- (UIView *)hostViewForApplication:(id)sbapplication {

	//open it
	[self launchSuspendedApplicationWithBundleID:[(SBApplication *)sbapplication bundleIdentifier]];

	//let the app run in the background
	[self enableBackgroundingForApplication:sbapplication];

	//allow hosting of our new hostview
	[[self contextManagerForApplication:sbapplication] enableHostingForRequester:[(SBApplication *)sbapplication bundleIdentifier] orderFront:YES];

	//get our fancy new hosting view
	UIView *hostView = [[self contextManagerForApplication:sbapplication] hostViewForRequester:[(SBApplication *)sbapplication bundleIdentifier] enableAndOrderFront:YES];

	return hostView;
}

- (UIView *)hostViewForApplicationWithBundleID:(NSString *)bundleID {

	//get application reference
	SBApplication *appToHost = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleID];

	//return hostview
	return [self hostViewForApplication:appToHost];
}

- (void)launchSuspendedApplicationWithBundleID:(NSString *)bundleID {
	[[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleID suspended:YES];
}

- (void)disableBackgroundingForApplication:(id)sbapplication {

	//get scene settings
	FBSMutableSceneSettings *sceneSettings = [self sceneSettingsForApplication:sbapplication];

	//force backgrounding to YES
	[sceneSettings setBackgrounded:YES];

	//reapply new settings to scene
	[[self FBSceneForApplication:sbapplication] _applyMutableSettings:sceneSettings withTransitionContext:nil completion:nil];

}

- (void)enableBackgroundingForApplication:(id)sbapplication {

	//get scene settings
	FBSMutableSceneSettings *sceneSettings = [self sceneSettingsForApplication:sbapplication];

	//force backgrounding to NO
	[sceneSettings setBackgrounded:NO];

	//reapply new settings to scene
	[[self FBSceneForApplication:sbapplication] _applyMutableSettings:sceneSettings withTransitionContext:nil completion:nil];

}

- (FBScene *)FBSceneForApplication:(id)sbapplication {
	return [(SBApplication *)sbapplication mainScene];
}

- (FBWindowContextHostManager *)contextManagerForApplication:(id)sbapplication {
	return [[self FBSceneForApplication:sbapplication] contextHostManager];
}

- (FBSMutableSceneSettings *)sceneSettingsForApplication:(id)sbapplication {
	return [[[self FBSceneForApplication:sbapplication] mutableSettings] mutableCopy];
}

- (BOOL)isHostViewHosting:(UIView *)hostView {
    if (hostView && [[hostView subviews] count] >= 1)
        return [(FBWindowContextHostView *)[hostView subviews][0] isHosting];
    return NO;
}

- (void)forceRehostingOnBundleID:(NSString *)bundleID {

    SBApplication *appToForce = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleID];
    [self launchSuspendedApplicationWithBundleID:bundleID];
    [self enableBackgroundingForApplication:appToForce];
    FBWindowContextHostManager *manager = [self contextManagerForApplication:appToForce];
    [manager enableHostingForRequester:bundleID priority:1];
}

- (void)stopHostingForBundleID:(NSString *)bundleID {

	SBApplication *appToHost = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleID];
    [self disableBackgroundingForApplication:appToHost];
    FBWindowContextHostManager *contextManager = [self contextManagerForApplication:appToHost];
	[contextManager disableHostingForRequester:bundleID];

}

- (void)sendLandscapeRotationNotificationToBundleID:(NSString *)bundleID {

	//notification is "identifierLamoRotate"
	NSString *rotateNotification = [NSString stringWithFormat:@"%@LamoLandscapeRotate", bundleID];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)rotateNotification, NULL, NULL, YES);
}

- (void)sendPortraitRotationNotificationToBundleID:(NSString *)bundleID {

	//notification is "identifierLamoRotate"
	NSString *rotateNotification = [NSString stringWithFormat:@"%@LamoPortraitRotate", bundleID];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)rotateNotification, NULL, NULL, YES);
}

- (void)setStatusBarHidden:(NSNumber *)hidden onApplicationWithBundleID:(NSString *)bundleID {


    NSString *changeStatusBarNotification = [NSString stringWithFormat:@"%@LamoStatusBarChange", bundleID];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)changeStatusBarNotification, NULL, (__bridge CFDictionaryRef) @{@"isHidden" : hidden } , YES);
}

@end