#import "CDTContextHostProvider.h"

@implementation CDTContextHostProvider

+ (instancetype)sharedInstance {
	// Setup instance for current class once
    static id sharedInstance = nil;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        sharedInstance = [self new];
    });
    // Provide instance
    return sharedInstance;
}

- (id)init {
	if ((self = [super init])) {
		_hostedApplications = [[NSMutableDictionary alloc] init];
		_currentAppHasFinishedLaunching = NO;
	}
	return self;
}

- (UIView *)hostViewForApplication:(SBApplication*)sbapplication {
	NSString* bundleIdentifier = sbapplication.bundleIdentifier;

	if ([_hostedApplications objectForKey:bundleIdentifier]) {
		return [_hostedApplications objectForKey:bundleIdentifier];
	}

	//let the app run in the background
	[self enableBackgroundingForApplication:sbapplication];

	//open it
	[self launchSuspendedApplicationWithBundleID:[(SBApplication *)sbapplication bundleIdentifier]];

	//allow hosting of our new hostview
	[[self contextManagerForApplication:sbapplication] enableHostingForRequester:[(SBApplication *)sbapplication bundleIdentifier] orderFront:YES];

	//get our fancy new hosting view

	//wait for the app to launch if it wasn't already live in the background
	UIView *hostView = [[self contextManagerForApplication:sbapplication] hostViewForRequester:[(SBApplication *)sbapplication bundleIdentifier] enableAndOrderFront:YES];
	/*
	__block UIView *hostView = [[self contextManagerForApplication:sbapplication] hostViewForRequester:[(SBApplication *)sbapplication bundleIdentifier] enableAndOrderFront:YES];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		while (!hostView) {
			[NSThread sleepForTimeInterval:0.05];
			dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				hostView = [[self contextManagerForApplication:sbapplication] hostViewForRequester:[(SBApplication *)sbapplication bundleIdentifier] enableAndOrderFront:YES];
			});
		}
	});
	*/
	//UIView* hostView = [self forceHostViewRetrievalWithApplication:sbapplication];
//__block UIView *hostView = [[self contextManagerForApplication:sbapplication] hostViewForRequester:[(SBApplication *)sbapplication bundleIdentifier] enableAndOrderFront:YES];
/*
	UIView* hostView = nil;
	[self retrieveHostView:&hostView application:sbapplication completion:^{
		*/
		//[_hostedApplications setObject:hostView forKey:bundleIdentifier];

		hostView.accessibilityHint = bundleIdentifier;
	//}];

	return hostView;
}
/*
- (void)retrieveHostView:(UIView**)hostView application:(SBApplication*)sbapplication completion:(void(^)(void))completion {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		UIView *realHostView = [[self contextManagerForApplication:sbapplication] hostViewForRequester:[(SBApplication *)sbapplication bundleIdentifier] enableAndOrderFront:YES];
		if (realHostView) {
			*hostView = realHostView;
			completion();
		}
		else {
			[self retrieveHostView:*hostView application:sbapplication completion:completion];
		}
	});
}
*/
- (NSString*)bundleIDFromHostView:(UIView*)hostView {
	return hostView.accessibilityHint;
}
/*
- (UIView*)forceHostViewRetrievalWithApplication:(SBApplication*)sbapplication {
	UIView *hostView = [[self contextManagerForApplication:sbapplication] hostViewForRequester:[(SBApplication *)sbapplication bundleIdentifier] enableAndOrderFront:YES];
	if (hostView) return hostView;

	NSLog(@"[Popcorn] host view did not exist, trying again");

	SEL selector = @selector(forceHostViewRetrievalWithApplication:);
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[CDTContextHostProvider instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setArgument:&sbapplication atIndex:0];
    [invocation setTarget:self];
    //[invocation invoke];
    [invocation performSelector:@selector(invoke) withObject:nil afterDelay:0.05f];
    UIView* returnValue;
    [invocation getReturnValue:&returnValue];
    return returnValue;
}
*/
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
	FBWindowContextHostManager *contextManager = [self contextManagerForApplication:appToHost];
	[contextManager disableHostingForRequester:bundleID];
    [self disableBackgroundingForApplication:appToHost];

    [_hostedApplications removeObjectForKey:bundleID];

    if (__is__iOS9__) {
	    SBWorkspaceApplicationTransitionContext* transitionContext = [[NSClassFromString(@"SBWorkspaceApplicationTransitionContext") alloc] init];

	    //set layout role to 'side' (deactivating)
	    SBWorkspaceDeactivatingEntity* deactivatingEntity = [NSClassFromString(@"SBWorkspaceDeactivatingEntity") entity];
	    [deactivatingEntity setLayoutRole:3];
	    [transitionContext setEntity:deactivatingEntity forLayoutRole:3];

	    //set layout role for 'primary' (activating)
	    SBWorkspaceHomeScreenEntity* homescreenEntity = [[NSClassFromString(@"SBWorkspaceHomeScreenEntity") alloc] init];
	    [transitionContext setEntity:homescreenEntity forLayoutRole:2];

	    [transitionContext setAnimationDisabled:YES];

	    //create transititon request
	    SBMainWorkspaceTransitionRequest* transitionRequest = [[NSClassFromString(@"SBMainWorkspaceTransitionRequest") alloc] initWithDisplay:[[UIScreen mainScreen] valueForKey:@"_fbsDisplay"]];
	    [transitionRequest setValue:transitionContext forKey:@"_applicationContext"];

	    //create apptoapp transaction
	    SBAppToAppWorkspaceTransaction* transaction = [[NSClassFromString(@"SBAppToAppWorkspaceTransaction") alloc] initWithTransitionRequest:transitionRequest];
	    [transaction begin];
	}
	else {
		SBAppToAppWorkspaceTransaction *transaction = [[NSClassFromString(@"SBAppToAppWorkspaceTransaction") alloc] initWithAlertManager:nil exitedApp:appToHost];
        [transaction begin];
	}

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
