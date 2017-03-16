//
//  IBKWidgetSelectorController.m
//  curago
//
//  Created by Matt Clarke on 10/04/2015.
//
//

#import "IBKWidgetSelectorController.h"

@interface IBKWidgetSelectorController ()

@end

static NSBundle *strings;

@implementation IBKWidgetSelectorController

-(id)specifiers {
    if (_specifiers == nil) {
        [self loadFilesystemKeys];
        
		NSMutableArray *testingSpecs = [NSMutableArray array];
        [testingSpecs addObjectsFromArray:[self madeForWidgetSpecifiers]];
        [testingSpecs addObjectsFromArray:[self notificationWidgetSpecifiers]];
        [testingSpecs addObjectsFromArray:[self otherWidgetsSpecifiers]];
        
        _specifiers = testingSpecs;
    }
    
	return _specifiers;
}

-(void)loadFilesystemKeys {
    NSMutableArray *keysForWidget = [NSMutableArray array];
    NSMutableArray *custom = [NSMutableArray array];
    
    NSMutableArray *folders = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Library/Curago/Widgets/" error:nil] mutableCopy];
    
    for (NSString *name in [folders copy]) {
        if ([name rangeOfString:self.bundleIdentifier].location != NSNotFound) {
            [keysForWidget addObject:name];
            [folders removeObject:name];
        }
    }
    
    for (NSString *name in folders) {
        [custom addObject:name];
    }
    
    self.keysMadeForWidget = keysForWidget;
    self.keysCustom = custom;
}

-(NSArray*)madeForWidgetSpecifiers {
    if (self.keysMadeForWidget.count == 0)
        return [NSArray array];
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (!strings)
        strings = [[NSBundle alloc] initWithPath:@"/Library/PreferenceBundles/curago.bundle"];
    
    PSSpecifier* groupSpecifier1 = [PSSpecifier groupSpecifierWithName:[NSString stringWithFormat:[strings localizedStringForKey:@"Made for %@:" value:@"Made for %@:" table:@"Root"], self.displayName]];
    [groupSpecifier1 setProperty:[NSNumber numberWithBool:YES] forKey:@"isRadioGroup"];
    [array addObject:groupSpecifier1];
    
    for (NSString *name in self.keysMadeForWidget) {
        PSSpecifier *spe = [PSSpecifier preferenceSpecifierNamed:name target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSListItemCell edit:nil];
        [spe setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
        [spe setProperty:name forKey:@"filesystemKey"];
        
        BOOL isSelected = [[self readPreferenceValue:spe] boolValue];
        if (isSelected) {
            [groupSpecifier1 setProperty:spe forKey:@"radioGroupCheckedSpecifier"];
        }
    
        [array addObject:spe];
    }
    
    return array;
}

-(NSArray*)notificationWidgetSpecifiers {
    NSMutableArray *array = [NSMutableArray array];
    
    if (!strings)
        strings = [[NSBundle alloc] initWithPath:@"/Library/PreferenceBundles/curago.bundle"];
    
    PSSpecifier* groupSpecifier1 = [PSSpecifier groupSpecifierWithName:[strings localizedStringForKey:@"Generic widgets:" value:@"Generic widgets:" table:@"Root"]];
    [groupSpecifier1 setProperty:[NSNumber numberWithBool:YES] forKey:@"isRadioGroup"];
    [array addObject:groupSpecifier1];
    
    PSSpecifier *spe = [PSSpecifier preferenceSpecifierNamed:@"NOTIFICATIONS" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSListItemCell edit:nil];
    [spe setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    [spe setProperty:@"NOTIFICATIONS" forKey:@"filesystemKey"];
    
    BOOL isSelected = [[self readPreferenceValue:spe] boolValue];
    if (isSelected) {
        [groupSpecifier1 setProperty:spe forKey:@"radioGroupCheckedSpecifier"];
    }
    
    [array addObject:spe];
    
    return array;
}

-(NSArray*)otherWidgetsSpecifiers {
    NSMutableArray *array = [NSMutableArray array];
    
    if (!strings)
        strings = [[NSBundle alloc] initWithPath:@"/Library/PreferenceBundles/curago.bundle"];
    
    PSSpecifier* groupSpecifier1 = [PSSpecifier groupSpecifierWithName:[strings localizedStringForKey:@"Made for other apps:" value:@"Made for other apps:" table:@"Root"]];
    [groupSpecifier1 setProperty:[NSNumber numberWithBool:YES] forKey:@"isRadioGroup"];
    [array addObject:groupSpecifier1];
    
    for (NSString *name in self.keysCustom) {
        PSSpecifier *spe = [PSSpecifier preferenceSpecifierNamed:name target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSListItemCell edit:nil];
        [spe setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
        [spe setProperty:name forKey:@"filesystemKey"];
        
        [array addObject:spe];
        
        BOOL isSelected = [[self readPreferenceValue:spe] boolValue];
        if (isSelected) {
            [groupSpecifier1 setProperty:spe forKey:@"radioGroupCheckedSpecifier"];
        }
    }
    
    return array;
}

-(void)setSpecifier:(PSSpecifier *)specifier {
    [super setSpecifier:specifier];
    
    // Load up stuff from here!
    self.displayName = [specifier propertyForKey:@"displayName"];
    self.bundleIdentifier = [specifier propertyForKey:@"bundleIdentifier"];
}

-(id)readPreferenceValue:(PSSpecifier*)specifier {
    return [self getForKey:[specifier propertyForKey:@"filesystemKey"]];
}

-(id)getForKey:(NSString*)key {
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
    if (!settings) {
        settings = [NSDictionary dictionary];
    }
    
    NSString *currentKey = settings[@"redirectedIdentifiers"][self.bundleIdentifier];
    
    if (!currentKey) {
        if (self.keysMadeForWidget.count == 0 && [key isEqualToString:@"NOTIFICATIONS"]) {
            return [NSNumber numberWithBool:YES];
        } else if ([key isEqualToString:self.bundleIdentifier]) {
            return [NSNumber numberWithBool:YES];
        } else {
            return [NSNumber numberWithBool:NO];
        }
    }
    
    if ([key isEqualToString:currentKey]) {
        return [NSNumber numberWithBool:YES];
    } else {
        return [NSNumber numberWithBool:NO];
    }
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSLog(@"SETTING PREFERNCE VALUE: %@", specifier);
    
    [self setForKey:[specifier propertyForKey:@"filesystemKey"]];
}

-(void)setForKey:(NSString*)key {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"]];
    
    NSMutableDictionary *changed = [dict[@"redirectedIdentifiers"] mutableCopy];
    if (!changed) {
        changed = [NSMutableDictionary dictionary];
    }
    
    [changed setObject:key forKey:self.bundleIdentifier];
    
    [dict setObject:changed forKey:@"redirectedIdentifiers"];
	[dict setObject:self.bundleIdentifier forKey:@"changedBundleIdFromSettings"];
	[dict writeToFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist" atomically:YES];
    
	CFStringRef toPost = (__bridge CFStringRef)@"com.matchstic.ibk/settingschangeforwidget";
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

#pragma mark UITableViewDelegate overrides

-(void)tableView:(UITableView*)view didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    // Remove all things.
    [view deselectRowAtIndexPath:indexPath animated:YES];
    
    for (UITableViewCell *cell in view.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *key = @"";
    
    if (self.keysMadeForWidget.count == 0) {
        // Two sections.
        switch (indexPath.section) {
            case 0:
                key = @"NOTIFICATIONS";
                break;
            
            case 1:
                key = self.keysCustom[indexPath.row];
            
            default:
                break;
        }
    } else {
        // Two sections.
        switch (indexPath.section) {
            case 0:
                key = self.keysMadeForWidget[indexPath.row];
                break;
                
            case 1:
                key = @"NOTIFICATIONS";
                break;
                
            case 2:
                key = self.keysCustom[indexPath.row];
                
            default:
                break;
        }
    }
    
    [self setForKey:key];
    
    [view reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSString *key = @"";
    
    if (self.keysMadeForWidget.count == 0) {
        // Two sections.
        switch (indexPath.section) {
            case 0:
                key = @"NOTIFICATIONS";
                break;
                
            case 1:
                key = self.keysCustom[indexPath.row];
                
            default:
                break;
        }
    } else {
        // Two sections.
        switch (indexPath.section) {
            case 0:
                key = self.keysMadeForWidget[indexPath.row];
                break;
                
            case 1:
                key = @"NOTIFICATIONS";
                break;
                
            case 2:
                key = self.keysCustom[indexPath.row];
                
            default:
                break;
        }
    }
    
    NSLog(@"CHECKING AGAINST KEY: %@", key);
    
    BOOL isSelected = [[self getForKey:key] boolValue];
    if (isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

@end
