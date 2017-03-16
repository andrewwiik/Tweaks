//
//  IBKWidgetSettingsController.m
//  curago
//
//  Created by Matt Clarke on 19/03/2015.
//
//

#import "IBKWidgetSettingsController.h"
#import "IBKWidgetSelectorController.h"

NSBundle *strings;

@interface IBKWidgetSettingsController ()

@end

@interface PSListController ()
- (id)loadSpecifiersFromPlistName:(id)arg1 target:(id)arg2 bundle:(id)arg3;
@end

@implementation IBKWidgetSettingsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)view {
    [super viewWillAppear:view];
    
    [self reloadSpecifiers];
}

-(id)specifiers {
    if (_specifiers == nil) {
		NSMutableArray *testingSpecs = [NSMutableArray array];
        [testingSpecs addObjectsFromArray:[self topGeneralSpecifiers]];
        [testingSpecs addObjectsFromArray:[self widgetSpecificSpecifiers]];
        
        _specifiers = testingSpecs;
    }
    
	return _specifiers;
}

-(NSArray*)topGeneralSpecifiers {
    NSMutableArray *array = [NSMutableArray array];
    
    if (!strings)
        strings = [[NSBundle alloc] initWithPath:@"/Library/PreferenceBundles/Convergance-Prefs.bundle"];
    
    PSSpecifier* groupSpecifier1 = [PSSpecifier groupSpecifierWithName:[strings localizedStringForKey:@"General:" value:@"General:" table:@"Root"]];
    [array addObject:groupSpecifier1];
    
    PSSpecifier *spe = [PSSpecifier preferenceSpecifierNamed:[strings localizedStringForKey:@"Set Widget" value:@"Set Widget" table:@"Root"] target:self set:nil get:@selector(getIsWidgetSetForSpecifier:) detail:[IBKWidgetSelectorController class] cell:PSLinkListCell edit:nil];
    [spe setProperty:@"IBKWidgetSelectorController" forKey:@"detail"];
    [spe setProperty:[NSNumber numberWithBool:YES] forKey:@"isController"];
    [spe setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    [spe setProperty:_bundleIdentifier forKey:@"bundleIdentifier"];
    [spe setProperty:self.displayName forKey:@"displayName"];
    
    [array addObject:spe];
    
    // Also check if we can lock this widget.
    
    NSDictionary *currentSettings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
    if ([[currentSettings objectForKey:@"passcodeHash"] isEqualToString:@""] || ![currentSettings objectForKey:@"passcodeHash"]) {
        // Don't do anything.
    } else {
        
        PSSpecifier *spe2 = [PSSpecifier preferenceSpecifierNamed:[strings localizedStringForKey:@"Lock Widget" value:@"Lock Widget" table:@"Root"] target:self set:@selector(setCurrentWidgetLocked:specifier:) get:@selector(getCurrentWidgetLocked) detail:nil cell:PSSwitchCell edit:nil];
        [spe2 setProperty:[NSNumber numberWithBool:NO] forKey:@"default"];
        [spe2 setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
        
        [array addObject:spe2];
    }
    
    return array;
}

-(id)getCurrentWidgetLocked {
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
    NSArray *lockedBundleIdentifiers = settings[@"lockedBundleIdentifiers"];
    return [NSNumber numberWithBool:[lockedBundleIdentifiers containsObject:self.bundleIdentifier]];
}

-(void)setCurrentWidgetLocked:(id)value specifier:(id)specifier {
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
    if (!settings) {
        settings = [NSMutableDictionary dictionary];
    }
    NSMutableArray *array = settings[@"lockedBundleIdentifiers"];
    
    if (!array) {
        array = [NSMutableArray array];
    }
    
    if ((__bridge CFBooleanRef)value == kCFBooleanTrue) {
        if (![array containsObject:self.bundleIdentifier]) {
            [array addObject:self.bundleIdentifier];
        }
    } else {
        if ([array containsObject:self.bundleIdentifier]) {
            [array removeObject:self.bundleIdentifier];
        }
    }
    
    [settings setObject:array forKey:@"lockedBundleIdentifiers"];
    [settings setObject:self.bundleIdentifier forKey:@"changedBundleIdFromSettings"];
    [settings writeToFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist" atomically:YES];
    
    CFStringRef toPost = (__bridge CFStringRef)@"com.matchstic.ibk/settingschangeforwidget";
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

-(NSArray*)widgetSpecificSpecifiers {
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Curago/Widgets/%@/Settings", [self getRedirectedIdentifierIfNeeded:self.bundleIdentifier]];
    
    NSBundle *widgetBundle = [NSBundle bundleWithPath:path];
    
    array = [self loadSpecifiersFromPlistName:@"Root" target:self bundle:widgetBundle];
    array = [[self localizedSpecifiersForSpecifiers:array andBundle:widgetBundle] mutableCopy];
    
    if ([self respondsToSelector:@selector(navigationItem)]) {
        [[self navigationItem] setTitle:self.displayName];
    }
    
    if (array.count == 0) {
        // Well, shit. No widget settings!?
        // If this is a notification widget, we should provide the notification widget settings.
        // Else, we say no settings associated with this widget.
        
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Curago/Widgets/%@/Info.plist", [self getRedirectedIdentifierIfNeeded:self.bundleIdentifier]]];
        if (!dict || [[dict objectForKey:@"wantsNotificationsTable"] boolValue]) {
            return [self notificationWidgetSettings];
        } else {
            // We definitely have no settings then for this widget.
            PSSpecifier *spe = [PSSpecifier preferenceSpecifierNamed:[strings localizedStringForKey:@"No settings available for this widget" value:@"No settings available for this widget" table:@"Root"] target:self set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil];
            [spe setProperty:[NSNumber numberWithBool:NO] forKey:@"enabled"];
            
            [array addObject:spe];
        }
    }
    
    PSSpecifier *first = [array firstObject];
    if (first.cellType != PSGroupCell) {
        PSSpecifier* groupSpecifier2 = [PSSpecifier groupSpecifierWithName:@""];
        [array insertObject:groupSpecifier2 atIndex:0];
    }
    
    return array;
}

-(NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)s andBundle:(NSBundle*)bundle {
	int i;
	for (i=0; i<[s count]; i++) {
		if ([[s objectAtIndex: i] name]) {
			[[s objectAtIndex: i] setName:[bundle localizedStringForKey:[[s objectAtIndex: i] name] value:[[s objectAtIndex: i] name] table:nil]];
		}
		if ([[s objectAtIndex: i] titleDictionary]) {
			NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
			for(NSString *key in [[s objectAtIndex: i] titleDictionary]) {
				[newTitles setObject: [bundle localizedStringForKey:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] value:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] table:nil] forKey: key];
			}
			[[s objectAtIndex: i] setTitleDictionary: newTitles];
		}
	}
	
	return s;
}

-(NSArray*)notificationWidgetSettings {
    NSMutableArray *array = [NSMutableArray array];
    
    PSSpecifier *spe = [PSSpecifier preferenceSpecifierNamed:[strings localizedStringForKey:@"No settings available for this widget" value:@"No settings available for this widget" table:@"Root"] target:self set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil];
    [spe setProperty:[NSNumber numberWithBool:NO] forKey:@"enabled"];
    
    [array addObject:spe];
    
    PSSpecifier *first = [array firstObject];
    if (first.cellType != PSGroupCell) {
        PSSpecifier* groupSpecifier2 = [PSSpecifier groupSpecifierWithName:@""];
        [array insertObject:groupSpecifier2 atIndex:0];
    }
    
    return array;
}

-(NSString*)getIsWidgetSetForSpecifier:(PSSpecifier*)spec {
    return @"";
}

-(void)setSpecifier:(PSSpecifier*)specifier {
    [super setSpecifier:specifier];
    
    // Load up stuff from here!
    self.displayName = [specifier name];
    self.bundleIdentifier = [specifier propertyForKey:@"bundleIdentifier"];
}

-(NSString*)getRedirectedIdentifierIfNeeded:(NSString*)identifier {
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
    
    NSDictionary *dict = settings[@"redirectedIdentifiers"];
    
    if (dict && [dict objectForKey:identifier])
        return [dict objectForKey:identifier];
    else
        return identifier;
}

-(id)readPreferenceValue:(PSSpecifier*)specifier {
    NSString *fileString = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", [specifier propertyForKey:@"defaults"]];
    
	NSDictionary *exampleTweakSettings = [NSDictionary dictionaryWithContentsOfFile:fileString];
	if (!exampleTweakSettings[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
    
	return exampleTweakSettings[specifier.properties[@"key"]];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSString *fileString = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", [specifier propertyForKey:@"defaults"]];
    
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:fileString]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:fileString atomically:YES];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"]];
	[dict setObject:self.bundleIdentifier forKey:@"changedBundleIdFromSettings"];
	[dict writeToFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist" atomically:YES];
    
	CFStringRef toPost = (__bridge CFStringRef)@"com.matchstic.ibk/settingschangeforwidget";
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

@end
