#import "HeaderFiles.h"

/*
 * SpringBoardServices framework header.
 *
 * Borrows work done by KennyTM.
 * See https://github.com/kennytm/iphone-private-frameworks/blob/master/SpringBoardServices/SpringBoardServices.h
 * for more information.
 *
 * Copyright (c) 2013, Cykey (David Murray)
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the <organization> nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef SPRINGBOARDSERVICES_H_
#define SPRINGBOARDSERVICES_H_

#include <CoreFoundation/CoreFoundation.h>

#if __cplusplus
extern "C" {
#endif
    
#pragma mark - API
    
    mach_port_t SBSSpringBoardServerPort();
    void SBSetSystemVolumeHUDEnabled(mach_port_t springBoardPort, const char *audioCategory, Boolean enabled);
    
    void SBSOpenNewsstand();
    void SBSSuspendFrontmostApplication();
    
    CFStringRef SBSCopyBundlePathForDisplayIdentifier(CFStringRef displayIdentifier);
    CFStringRef SBSCopyExecutablePathForDisplayIdentifier(CFStringRef displayIdentifier);
    CFDataRef SBSCopyIconImagePNGDataForDisplayIdentifier(CFStringRef displayIdentifier);
    
    CFSetRef SBSCopyDisplayIdentifiers();
    
    CFStringRef SBSCopyFrontmostApplicationDisplayIdentifier();
    CFStringRef SBSCopyDisplayIdentifierForProcessID(pid_t PID);
    CFArrayRef SBSCopyDisplayIdentifiersForProcessID(pid_t PID);
    BOOL SBSProcessIDForDisplayIdentifier(CFStringRef identifier, pid_t *pid);
    
    int SBSLaunchApplicationWithIdentifier(CFStringRef identifier, Boolean suspended);
    int SBSLaunchApplicationWithIdentifierAndLaunchOptions(CFStringRef identifier, CFDictionaryRef launchOptions, BOOL suspended);
    CFStringRef SBSApplicationLaunchingErrorString(int error);
    
#if __cplusplus
}
#endif

#endif /* SPRINGBOARDSERVICES_H_ */

%hook SBApplicationShortcutStoreManager
- (id)shortcutItemsForBundleIdentifier:(NSString*)arg1 {
		NSArray *aryItems = [NSArray new];
		if (%orig != NULL || %orig != nil) {
			aryItems = %orig;
		}
		NSMutableArray *aryShortcuts = [aryItems mutableCopy];

		if ([arg1 isEqualToString:@"com.apple.Health"]) {
			SBSApplicationShortcutItem *action = [[NSClassFromString(@"SBSApplicationShortcutItem") alloc] init];
			// [action setIcon:[[NSClassFromString(@"SBSApplicationShortcutSystemIcon") alloc] initWithType:UIApplicationShortcutIconTypeAdd]];
			//[action setIcon:[[NSClassFromString(@"SBSApplicationShortcutCustomImageIcon") alloc] initWithImagePNGData:UIImagePNGRepresentation([%c(UIImage) imageNamed:@"/Library/Application Support/QuickSugar/Resources.bundle/bloodsugar"])]];
			[action setIcon:[[NSClassFromString(@"SBSApplicationShortcutCustomImageIcon") alloc] initWithImagePNGData:UIImagePNGRepresentation([[NSClassFromString(@"_UIAssetManager") assetManagerForBundle:[NSBundle bundleWithIdentifier:@"com.apple.HealthKitUI"]] imageNamed:@"healthdata_glyph_bodymeasurements"])]];
			[action setLocalizedTitle:@"Weight"];
			[action setLocalizedSubtitle:nil];
			[action setType:@"com.creatix.quicksugar-weight"];
			[aryShortcuts addObject:action];
			
			//[[NSClassFromString(@"_UIAssetManager") assetManagerForBundle:[NSBundle bundleWithPath:SBSCopyBundlePathForDisplayIdentifier(@"com.apple.HealthKitUI")]] imageNamed:@"healthdata_glyph_reproductive"];
		}

		return aryShortcuts;
}
%end


@interface WDTabBarController : UITabBarController
@end
@interface WDMyHealthViewController : UITableViewController
- (void)searchBarSearchButtonClicked:(id)arg1;
- (void)searchBar:(id)arg1 textDidChange:(id)arg2;
- (void)_tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2 animated:(_Bool)arg3;
- (void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2;
- (void)_pushDataUnitGroupDetailViewControllerForDataUnitGroup:(id)arg1 animated:(BOOL)arg2;
- (void)test;
@end

%hook WDAppDelegate
%new
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
	if ([shortcutItem.type isEqualToString:@"com.creatix.quicksugar-weight"]) {
		WDTabBarController *tabBarController = MSHookIvar<WDTabBarController *>(self, "_tabBarController");
		[tabBarController setSelectedIndex:1];
		UIViewController *currentViewController = [tabBarController selectedViewController];
		if ([currentViewController isKindOfClass:NSClassFromString(@"UINavigationController")]) {
			if ([((UINavigationController*)currentViewController).visibleViewController isKindOfClass:NSClassFromString(@"WDHealthDataViewController")]) {
				WDMyHealthViewController *listVC = MSHookIvar<WDMyHealthViewController *>(((UINavigationController*)currentViewController).visibleViewController , "_listVC");
				UISearchBar *searchBar = MSHookIvar<UISearchBar *>(listVC, "_searchBar");
				searchBar.text = @"Weight";
				[listVC test];
			}
		}
	}
}
%end

%hook WDMyHealthViewController
%new
- (void)test {
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				UISearchBar *searchBar = MSHookIvar<UISearchBar *>(self, "_searchBar");
				[self searchBar:searchBar textDidChange:searchBar.text];
				NSMutableArray *results = MSHookIvar<id>(self,"_searchResults");
				[self _pushDataUnitGroupDetailViewControllerForDataUnitGroup:[results objectAtIndex:0] animated:YES];
				});
}
%end
