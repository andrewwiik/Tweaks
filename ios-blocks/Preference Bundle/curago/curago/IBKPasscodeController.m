//
//  IBKPasscodeController.m
//  curago
//
//  Created by Matt Clarke on 14/04/2015.
//
//

#import "IBKPasscodeController.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface IBKPasscodeController ()

@end

@interface DevicePINController (IOS7)
- (void)setPinDelegate:(id)arg1;
- (void)setSpecifier:(id)arg1;
- (void)setMode:(int)arg1;
@end

@interface UIPopoverPresentationController : UIViewController
@property (nonatomic, assign) UIPopoverArrowDirection permittedArrowDirections;
@property (nonatomic, weak) id delegate;
- (void)setSourceRect:(CGRect)arg1;
- (void)setSourceView:(id)arg1;
@end

@interface UINavigationController (iOS8)
@property (nonatomic, strong) UIPopoverPresentationController *popoverPresentationController;
@end

@implementation IBKPasscodeController

-(id)specifiers {
    if (_specifiers == nil) {
		NSMutableArray *testingSpecs = [self loadSpecifiersFromPlistName:@"Passcode" target:self];
        _specifiers = [self localizedSpecifiersForSpecifiers:[self modifySpecifiersAsNeeded:testingSpecs]];
    }
    
	return _specifiers;
}

-(NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)s {
	int i;
	for (i=0; i<[s count]; i++) {
		if ([[s objectAtIndex: i] name]) {
			[[s objectAtIndex: i] setName:[[self bundle] localizedStringForKey:[[s objectAtIndex: i] name] value:[[s objectAtIndex: i] name] table:nil]];
		}
		if ([[s objectAtIndex: i] titleDictionary]) {
			NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
			for(NSString *key in [[s objectAtIndex: i] titleDictionary]) {
				[newTitles setObject: [[self bundle] localizedStringForKey:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] value:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] table:nil] forKey: key];
			}
			[[s objectAtIndex: i] setTitleDictionary: newTitles];
		}
	}
	
	return s;
}

-(NSArray*)modifySpecifiersAsNeeded:(NSMutableArray*)input {
    NSDictionary *currentSettings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
    
    if ([[currentSettings objectForKey:@"passcodeHash"] isEqualToString:@""] || ![currentSettings objectForKey:@"passcodeHash"]) {
        // No passcode is currently set.
        for (PSSpecifier *spec in [input copy]) {
            if ([[spec propertyForKey:@"id"] isEqualToString:@"passOff"]) {
                [input removeObject:spec];
            }
        }
    } else {
        for (PSSpecifier *spec in [input copy]) {
            if ([[spec propertyForKey:@"id"] isEqualToString:@"passOn"]) {
                [input removeObject:spec];
            } else if ([[spec propertyForKey:@"id"] isEqualToString:@"changePass"]) {
                [spec setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
            }
        }
    }
    
    return input;
}

-(void)setAllWidgetsLocked:(id)value specifier:(id)specifier {
    [self setPreferenceValue:value specifier:specifier];
    
    if ((__bridge CFBooleanRef)value == kCFBooleanTrue) {
        // We should show an alert saying that all widgets will be locked after
        // locking the device.
        
        NSDictionary *currentSettings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
        
        if ([[currentSettings objectForKey:@"passcodeHash"] isEqualToString:@""] || ![currentSettings objectForKey:@"passcodeHash"]) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Settings" message:@"You must set a passcode before widgets will be locked." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }
}

-(id)readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary *exampleTweakSettings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
	if (!exampleTweakSettings[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return exampleTweakSettings[specifier.properties[@"key"]];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist" atomically:YES];
	CFStringRef toPost = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
	if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

-(void)presentPasscodeControllerWithMode:(int)mode andSpecifierID:(NSString*)identifier {
    self.pinController = [[IBKPINModalController alloc] init];
    self.pinController.ibkDelegate = self;
    self.pinController.customMode = mode;
    
    [self.pinController setPinDelegate:self];
    [self.pinController setSpecifier:[self specifierForID:identifier]];
    
    [(DevicePINPane*)[self.pinController pane] activateKeypadView];
    [(DevicePINPane*)[self.pinController pane] becomeFirstResponder];
    
    if (isPad) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.pinController];
        if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
            self.ipadPopover = [[UIPopoverController alloc] initWithContentViewController:navController];
            
            //size as needed
            self.ipadPopover.popoverContentSize = CGSizeMake(320, 480);
            self.ipadPopover.delegate = self;
            
            //show the popover next to the annotation view (pin)
            [self.ipadPopover presentPopoverFromRect:[[UIApplication sharedApplication] keyWindow].bounds inView:[[UIApplication sharedApplication] keyWindow] permittedArrowDirections:NULL animated:YES];
        } else {
            navController.modalPresentationStyle = 7;
            navController.preferredContentSize = CGSizeMake(320, 480);
            
            // Load up UIPopoverPresentationController.
            UIPopoverPresentationController *cont = navController.popoverPresentationController;
            [cont setSourceRect:[[UIApplication sharedApplication] keyWindow].bounds];
            [cont setSourceView:[[UIApplication sharedApplication] keyWindow]];
            cont.permittedArrowDirections = NULL;
            cont.delegate = self;
            
            [self.parentController presentViewController:navController animated:YES completion:nil];
        }
    } else {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.pinController];
    
        [self.parentController presentViewController:navController animated:YES completion:nil];
    }
}

-(void)popoverController:(UIPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view {
    *rect = [[UIApplication sharedApplication] keyWindow].bounds;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView **)view {
    *rect = [[UIApplication sharedApplication] keyWindow].bounds;
}

-(void)turnPasscodeOn:(id)sender {
    // Show PIN pane if needed.
    [self presentPasscodeControllerWithMode:IBKTurnOnPasscode andSpecifierID:@"passOn"];
}

-(void)turnPasscodeOff:(id)sender {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Turn Off Passcode?" message:@"Any sensitive information currently displayed can be viewed by anyone who has access to your device if you turn off passcode lock." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Turn Off", nil];
    [av show];
}

-(void)changePasscode:(id)sender {
    [self presentPasscodeControllerWithMode:IBKChangePasscode andSpecifierID:@"changePass"];
}

-(void)didAcceptEnteredPIN {
    if (isPad) {
        if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
            [self.ipadPopover dismissPopoverAnimated:YES];
        else
            [self.parentController dismissViewControllerAnimated:YES completion:nil];
    } else
        [self.parentController dismissViewControllerAnimated:YES completion:nil];
}

-(void)didChangePasscode {
    [self reloadSpecifiers];
    
    if (isPad) {
        if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
            [self.ipadPopover dismissPopoverAnimated:YES];
        else
            [self.parentController dismissViewControllerAnimated:YES completion:nil];
    } else
        [self.parentController dismissViewControllerAnimated:YES completion:nil];
}

-(void)didCancelEnteringPIN {
    if (isPad) {
        if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
            [self.ipadPopover dismissPopoverAnimated:YES];
        else
            [self.parentController dismissViewControllerAnimated:YES completion:nil];
    } else
        [self.parentController dismissViewControllerAnimated:YES completion:nil];}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self presentPasscodeControllerWithMode:IBKTurnOffPasscode andSpecifierID:@"passOff"];
    }
}

@end
