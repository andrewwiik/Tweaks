#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_1_2
#define kCFCoreFoundationVersionNumber_iOS_7_1_2 847.27
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
#define kCFCoreFoundationVersionNumber_iOS_8_0 1140.10
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_1_1
#define kCFCoreFoundationVersionNumber_iOS_8_1_1 1145.15 
#endif

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define CURRENT_INTERFACE_ORIENTATION iPad ? [[UIApplication sharedApplication] statusBarOrientation] : [[UIApplication sharedApplication] activeInterfaceOrientation]

#define iOS8 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0 \
&& kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_8_1_1

#define iOS7 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0 \
&& kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_7_1_2


#import <UIKit/UIKit.h>

@interface PHObject : NSObject
- (id)photoLibrary;
@end

@interface PHAsset : PHObject
- (id)pl_managedAsset;
- (id)pl_photoLibrary;
- (void)deletePhotoForever;
- (id)mainFileURL;
@end
@interface PHAssetCollection : NSObject
-(BOOL)isTrashBin;
@end
@interface PHObjectDeleteRequest : NSObject
@end

@interface PHAssetChangeRequest : NSObject
+ (void)deleteAssets:(id)arg1;
@end

@interface PHAssetDeleteRequest : PHObjectDeleteRequest
- (void)deleteManagedObject:(id)arg1 photoLibrary:(id)arg2;
- (BOOL)validateForDeleteManagedObject:(id)arg1 error:(id*)arg2;
@end

@interface PLGatekeeperClient : NSObject
+ (id)sharedInstance;
- (void)deleteAssetWithURL:(id)arg1 handler:(id)arg2;
@end

@interface PUDeletePhotosActionController : UIViewController <UIAlertViewDelegate>
-(UIAlertController *)actionSheet;
- (void)_runDestructiveActionWithCompletion:(id /* block */)arg1;
- (void)_didCompleteWithDestructiveAction:(BOOL)arg1;
- (NSArray *)assets;
-(NSInteger)action;
- (void)_showOnetimeConfirmation;
- (void)_handleFinalUserDecisionShouldDelete:(BOOL)arg1;
- (void)_handleMainAlertConfirmed:(BOOL)arg1;
@end
@interface UIAlertController (DeleteForever)
-(void)_dismissWithCancelAction;
@end
@interface PLDeletePhotosActionController : NSObject
-(UIAlertController *)actionSheet;
- (void)runDestructiveActionWithCompletion:(id /* block */)arg1;
- (void)_didCompleteWithDestructiveAction:(BOOL)arg1;
- (NSArray *)assets;
-(NSInteger)action;
@end
static BOOL kHideDefaultAction;
%hook PLDeletePhotosActionController
%new
-(UIAlertController *)actionSheet {
	return MSHookIvar<id>(self, "_actionSheetController");
}
- (void)_setupActionSheet {
	%orig;
	if ([self action] == 0) {
	UIAlertAction *regularDelete = [[[self actionSheet] actions] objectAtIndex:1];
	NSString *deleteOriginalTitle = [regularDelete title];
		NSString *deleteForeverActionTitle = [NSString stringWithFormat: @"Permanently %@", deleteOriginalTitle];
		UIAlertAction* Delete = [UIAlertAction actionWithTitle:deleteForeverActionTitle style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
                                                   	MSHookIvar<NSInteger>(self, "_action") = 2;
                                                   	[self runDestructiveActionWithCompletion: nil];
                                                   	[self _didCompleteWithDestructiveAction: TRUE];
                                                       [[self actionSheet] dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [[self actionSheet] addAction:Delete];
    if (kHideDefaultAction) {
    	[[[self actionSheet] performSelector:@selector(_actions)] removeObjectAtIndex: 1];
    }
    if (!kHideDefaultAction) {
    [[[self actionSheet] performSelector:@selector(_actions)] exchangeObjectAtIndex: 2 withObjectAtIndex: 1];	
    }
}
}
%end
%hook PUDeletePhotosActionController
%new
-(UIAlertController *)actionSheet {
	return MSHookIvar<id>(self, "__mainAlertController");
}
- (void)_setMainAlertController:(id)arg1 {
	%orig;
	if ([self action] == 0) {
	UIAlertAction *regularDelete = [[[self actionSheet] actions] objectAtIndex:1];
	NSString *deleteOriginalTitle = [regularDelete title];
		NSString *deleteForeverActionTitle = [NSString stringWithFormat: @"Permanently %@", deleteOriginalTitle];
		UIAlertAction* Delete = [UIAlertAction actionWithTitle:deleteForeverActionTitle style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * action) {
                                                   	MSHookIvar<NSInteger>(self, "_action") = 4;
                                                   	[self _handleMainAlertConfirmed: YES];
                                                       [[self actionSheet] dismissViewControllerAnimated:YES completion:nil];
                                                   	
                                                   }];
    [[self actionSheet] addAction:Delete];
    if (kHideDefaultAction) {
    	[[[self actionSheet] performSelector:@selector(_actions)] removeObjectAtIndex: 1];
    }
    if (!kHideDefaultAction) {
    [[[self actionSheet] performSelector:@selector(_actions)] exchangeObjectAtIndex: 2 withObjectAtIndex: 1];	
    }                                              
}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex) {
        case 0: //"No" pressed
        
            [[self actionSheet] _dismissWithCancelAction];
            break;
        case 1: //"Yes" pressed
            MSHookIvar<NSInteger>(self, "_action") = 4;
                                                   	[self _runDestructiveActionWithCompletion: nil];
                                                   	[self _didCompleteWithDestructiveAction: TRUE];
                                                       [[self actionSheet] dismissViewControllerAnimated:YES completion:nil];
            
            break;
    }
}
%end
static void loadPrefs() {

       NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.creatix.deleteforever.plist"];
    if(prefs)
    {
    	kHideDefaultAction = ([prefs objectForKey:@"HideDefaultAction"] ? [[prefs objectForKey:@"HideDefaultAction"] boolValue] : NO);
        
    }
    [prefs release];
}

static void settingschanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    loadPrefs();
}

%ctor{

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingschanged, CFSTR("com.creatix.deleteforever/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}