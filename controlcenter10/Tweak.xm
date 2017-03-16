@interface SBControlCenterContainerView : UIView
-(UIColor *)_currentBGColor;
@end

@interface SBControlCenterContentContainerView : UIView
@end

// static CGFloat previousY = 0;
%hook SBControlCenterContainerView
- (void)updateBackgroundSettings:(id)arg1 {
NSLog(@"Updating Settings: %@",arg1);
}

- (void)_updateDarkeningFrame {
	%orig;
	[(UIView *)[self valueForKey:@"_dynamicsContainerView"] setBackgroundColor:[self _currentBGColor]];
}
- (void)setContentHeight:(CGFloat)arg1 {
// CGFloat originalHeight = previousY;
%orig(428.5);
// CGFloat newHeight = [(UIView *)[self valueForKey:@"_dynamicsContainerView"] frame].size.height;
// CGRect origFrame = [[(UIView *)[self valueForKey:@"_dynamicsContainerView"] frame];
// [[(UIView *)[self valueForKey:@"_dynamicsContainerView"] superview] setFrame: CGRectMake(origFrame.origin.x,origFrame.origin.y + (originalHeight - newHeight),origFrame.size.width,428.5)];

}
%end

%hook SBControlCenterContentContainerView
- (void)setFrame:(CGRect)frame {
	%orig(CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,428.5));
}
%end



@interface SBAppSwitcherSnapshotView : UIView
@end

%hook SBSwitcherWallpaperPageContentView
%new
- (id)initShit {
	return [self initWithFrame:CGRectMake(0,0,414,736)];
}
%end
id objHelp;
%hook SBAppSwitcherSnapshotView
- (id)initWithDisplayItem:(id)arg1 application:(id)arg2 orientation:(long long)arg3 preferringDownscaledSnapshot:(_Bool)arg4 async:(_Bool)arg5 withQueue:(id)arg6 {
		if (objHelp) {
		return %orig(arg1,arg2,arg3,arg4,arg5,objHelp);
		}
		else {
		objHelp = arg6;
		return %orig(arg1,arg2,arg3,arg4,arg5,arg6);
		}
}
%new
+ (id)getSnapshotImageForApplicationWithBundleIdentifier:(NSString *)bundleID {
		
	//	SBAppSwitcherSnapshotView *obj = [[%c(SBAppSwitcherSnapshotView) alloc] initWithFrame:CGRectMake(0,0,414,736)];
		// Method method = class_getInstanceMethod([%c(SBSwitcherWallpaperPageContentView) class], @selector(initShit));
		SEL originalSelector = @selector(initWithFrame:);
        SEL swizzledSelector = @selector(initWithFrame:);

        Method originalMethod = class_getInstanceMethod(%c(SBAppSwitcherSnapshotView), originalSelector);
        Method swizzledMethod = class_getInstanceMethod(%c(SBSwitcherWallpaperPageContentView), swizzledSelector);
		method_exchangeImplementations(originalMethod, swizzledMethod);
		// IMP imp = method_getImplementation(method);
		// obj = ((id (*)(id, SEL))imp)(obj, @selector(initShit)); // cast the function to the correct signature
		SBAppSwitcherSnapshotView *obj = [[%c(SBAppSwitcherSnapshotView) alloc] initWithFrame:CGRectMake(0,0,414,736)];
		MSHookIvar<id>(obj, "_application") = [[[NSClassFromString(@"SBApplicationController") class] sharedInstance] applicationWithBundleIdentifier:bundleID];
		
		// [obj setDisplayItem:[%c(SBDisplayItem) displayItemWithType:nil displayIdentifier:bundleID]];
		MSHookIvar<id>(obj, "_displayItem") = [%c(SBDisplayItem) displayItemWithType:@"App" displayIdentifier:bundleID];
		obj.frame = [[UIScreen mainScreen] bounds];
		return obj;
		return	[obj _syncImageFromSnapshot:[[obj _contextForAvailableSnapshotWithLayoutState:nil preferringDownscaled:NO defaultImageOnly:NO] snapshot]];
}
%new
+ (id)helpQueue {
return objHelp;
}
%end


@class SBDeckSwitcherItemContainer;
@class SBDisplayItem;

@interface SBDisplayItem : NSObject
+ (id)displayItemWithType:(NSString *)arg1 displayIdentifier:(NSString *)arg1;
@end

@interface SBDeckSwitcherItemContainer : UIView
- (id)initWithFrame:(CGRect)frame displayItem:(id)displayItem delegate:(id)delegate;
@end

@protocol SBDeckSwitcherItemContainerDelegate <NSObject>
- (double)minimumVerticalTranslationForKillingOfContainer:(SBDeckSwitcherItemContainer *)arg1;
- (void)scrollViewKillingProgressUpdated:(double)arg1 ofContainer:(SBDeckSwitcherItemContainer *)arg2;
- (struct CGRect)frameForPageViewOfContainer:(SBDeckSwitcherItemContainer *)arg1 fullyPresented:(_Bool)arg2;
- (void)selectedDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1;
- (_Bool)canSelectDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 numberOfTaps:(long long)arg2;
- (void)killDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 withVelocity:(double)arg2;
- (_Bool)shouldShowIconAndLabelOfContainer:(SBDeckSwitcherItemContainer *)arg1;
- (_Bool)isDisplayItemOfContainerRemovable:(SBDeckSwitcherItemContainer *)arg1;
@end


@interface CRTXSwitcherCollectionViewController : UIViewController <SBDeckSwitcherItemContainerDelegate> 

- (double)minimumVerticalTranslationForKillingOfContainer:(SBDeckSwitcherItemContainer *)arg1;
- (void)scrollViewKillingProgressUpdated:(double)arg1 ofContainer:(SBDeckSwitcherItemContainer *)arg2;
- (struct CGRect)frameForPageViewOfContainer:(SBDeckSwitcherItemContainer *)arg1 fullyPresented:(_Bool)arg2;
- (void)selectedDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1;
- (_Bool)canSelectDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 numberOfTaps:(long long)arg2;
- (void)killDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 withVelocity:(double)arg2;
- (_Bool)shouldShowIconAndLabelOfContainer:(SBDeckSwitcherItemContainer *)arg1;
- (_Bool)isDisplayItemOfContainerRemovable:(SBDeckSwitcherItemContainer *)arg1;

@end

@implementation CRTXSwitcherCollectionViewController
- (double)minimumVerticalTranslationForKillingOfContainer:(SBDeckSwitcherItemContainer *)arg1 {
	return 100;
}
- (void)scrollViewKillingProgressUpdated:(double)arg1 ofContainer:(SBDeckSwitcherItemContainer *)arg2 {

}
- (struct CGRect)frameForPageViewOfContainer:(SBDeckSwitcherItemContainer *)arg1 fullyPresented:(_Bool)arg2 {
	return CGRectMake(0,0,414,736);
}
- (void)selectedDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 {

}
- (_Bool)canSelectDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 numberOfTaps:(long long)arg2 {
	return YES;
}
- (void)killDisplayItemOfContainer:(SBDeckSwitcherItemContainer *)arg1 withVelocity:(double)arg2 {

}
- (_Bool)shouldShowIconAndLabelOfContainer:(SBDeckSwitcherItemContainer *)arg1 {
	return YES;
}
- (_Bool)isDisplayItemOfContainerRemovable:(SBDeckSwitcherItemContainer *)arg1 {
	return YES;
}
@end

CRTXSwitcherCollectionViewController *sharedController;
dispatch_queue_t specialQueue = dispatch_queue_create("SBAppSwitcherSnapshotView queue", &_dispatch_queue_attr_concurrent);
SBDeckSwitcherPageViewProvider *pageProvider;
%hook SpringBoard
%new
+ (id)testPageViewWithIdentifier:(id)bundleID {
	if (sharedController) {

	}
	else {
		sharedController = [[CRTXSwitcherCollectionViewController alloc] init];
	}
	id obj = [[%c(SBDeckSwitcherItemContainer) alloc] initWithFrame:CGRectMake(0,0,414,736) displayItem:[%c(SBDisplayItem) displayItemWithType:@"App" displayIdentifier:bundleID] delegate:sharedController];
	id pageView = [[%c(SBDeckSwitcherPageView) alloc] initWithFrame:CGRectMake(0,0,414,736)];
	if (pageProvider) {
		id snapshotView = [pageProvider _snapshotViewForDisplayItem:[%c(SBDisplayItem) displayItemWithType:@"App" displayIdentifier:bundleID] preferringDownscaledSnapshot:NO synchronously:NO];
		[snapshotView setFrame:CGRectMake(0,0,414,736)];
		// [snapshotView layoutSubviews];
		[snapshotView _loadSnapshotSyncPreferringDownscaled:YES];
		[pageView setView:snapshotView animated:NO];
		[obj setPageView:pageView];
	}
	else {
		pageProvider = [[%c(SBDeckSwitcherPageViewProvider) alloc] initWithDelegate:nil];
		id snapshotView = [pageProvider _snapshotViewForDisplayItem:[%c(SBDisplayItem) displayItemWithType:@"App" displayIdentifier:bundleID] preferringDownscaledSnapshot:NO synchronously:NO];
		[snapshotView setFrame:CGRectMake(0,0,414,736)];
		// [snapshotView layoutSubviews];
		[snapshotView _loadSnapshotSyncPreferringDownscaled:YES];
		[pageView setView:snapshotView animated:NO];
		[obj setPageView:pageView];
	}
	//id snapshotView = [pageProvider _snapshotViewForDisplayItem:[%c(SBDisplayItem) displayItemWithType:@"App" displayIdentifier:bundleID] preferringDownscaledSnapshot:NO synchronously:NO];
	// [obj setPageView:
	[[sharedController view] addSubview:obj];
	return obj;
}
%end

%hook SBDeckSwitcherPageViewProvider
%new
- (id)snapshotViewForDisplayIdentifier:(NSString *)bundleID {
	return [self _snapshotViewForDisplayItem:[%c(SBDisplayItem) displayItemWithType:@"App" displayIdentifier:bundleID] preferringDownscaledSnapshot:NO synchronously:NO];
}
%end


