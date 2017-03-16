#import "CCXSettingsPageTableViewController.h"
#include <notify.h>

%subclass CCXSettingsPageTableViewController : UITableViewController
%property (nonatomic, retain) CCUIControlCenterPageContainerViewController *delegate;
%property (nonatomic, retain) NSMutableArray *books;
// %property (nonatomic, retain) NSMutableArray *enabledToggles;
// %property (nonatomic, retain) NSMutableArray *disabledToggles;
// %property (nonatomic, retain) NSMutableArray *enabledShortcuts;
// %property (nonatomic, retain) NSMutableArray *disabledShortcuts;
%property (nonatomic, retain) NSMutableArray *disabledSections;
%property (nonatomic, retain) NSMutableArray *enabledSections;
%property (nonatomic, retain) _UIVisualEffectLayerConfig *primaryEffectConfig;
%property (nonatomic, retain) NSBundle *templateBundle;
%property (nonatomic, retain) NSString *enabledKey;
%property (nonatomic, retain) NSMutableArray *enabledIdentifiers;
%property (nonatomic, retain) NSString *disabledKey;
%property (nonatomic, retain) NSMutableArray *disabledIdentifiers;
%property (nonatomic, retain) NSArray *allSwitches;
%property (nonatomic, assign) BOOL usingFlipControlCenter;
%property (nonatomic, retain) NSString *settingsFile;
%property (nonatomic, retain) NSString *preferencesApplicationID;
%property (nonatomic, retain) NSString *notificationName;
- (void)viewDidLoad
{
    %orig;
    [self.tableView registerClass:[CCXSectionSettingsTableViewCell class] forCellReuseIdentifier:@"Cell"];
     CCUIControlCenterVisualEffect *effect = [NSClassFromString(@"CCUIControlCenterVisualEffect")  _primaryRegularTextOnPlatterEffect];
    _UIVisualEffectConfig *effectConfig = [effect effectConfig];
   	self.primaryEffectConfig = effectConfig.contentConfig;
    
    self.view.backgroundColor = nil;

	self.settingsFile = @"/var/mobile/Library/Preferences/com.atwiiks.controlcenterx.plist";
	self.preferencesApplicationID = @"com.atwiiks.controlcenterx";
	self.notificationName = @"com.atwiiks.controlcenterx.settingschanged";
	NSDictionary *settings = nil;
	self.enabledKey = @"SectionsEnabledIdentifiers";
	self.disabledKey = @"SectionsDisabledIdentifiers";
	if (self.settingsFile) {
		if (self.preferencesApplicationID) {
			CFPreferencesAppSynchronize((__bridge CFStringRef)self.preferencesApplicationID);
			CFArrayRef keyList = CFPreferencesCopyKeyList((__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
			if (keyList) {
				settings = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost));
			}
		} else {
			settings = [NSDictionary dictionaryWithContentsOfFile:self.settingsFile];
		}
	}
	NSArray *originalEnabled = [settings objectForKey:self.enabledKey];
	self.enabledIdentifiers = [originalEnabled mutableCopy];
	NSArray *originalDisabled = [settings objectForKey:self.disabledKey];
	self.disabledIdentifiers = [originalDisabled mutableCopy];

	if (!self.enabledIdentifiers) {
		self.enabledIdentifiers = [NSMutableArray new];
	}
	if (!self.disabledIdentifiers) {
		self.disabledIdentifiers = [NSMutableArray new];
	}
	self.allSwitches = [(CCXSectionsPanel *)[NSClassFromString(@"CCXSectionsPanel") sharedInstance] sortedSectionIdentifiers];
	NSMutableArray *allIdentifiers = [self.allSwitches mutableCopy];
	for  (NSString *identifier in originalEnabled) {
		if ([allIdentifiers containsObject:identifier]) {
			[allIdentifiers removeObject:identifier];
			[self.disabledIdentifiers removeObject:identifier];
		} else {
			[self.enabledIdentifiers removeObject:identifier];
		}
	}
	for (NSString *identifier in originalDisabled) {
		if ([allIdentifiers containsObject:identifier]) {
			[allIdentifiers removeObject:identifier];
		} else {
			[self.disabledIdentifiers removeObject:identifier];
		}
	}

	NSMutableArray *arrayToAddNewIdentifiers = self.disabledIdentifiers;
	for (NSString *identifier in allIdentifiers) {
		[arrayToAddNewIdentifiers addObject:identifier];
	}

	[(UITableView *)self.view setEditing: YES animated: YES];
	CGFloat dummyViewHeight = 36;
	UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, dummyViewHeight)];
	self.tableView.tableHeaderView = dummyView;
	self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
	[self.tableView setSeparatorColor:[UIColor colorWithWhite:0 alpha:0.15]];
	self.tableView.allowsSelectionDuringEditing = YES;
	//[self.tableView setContentInset:UIEdgeInsetsMake(36,0,0,0)];
	// CGRect originalFrame = self.tableView.frame;
	// originalFrame.origin.y = 36;
	// originalFrame.size.height = originalFrame.size.height - 36;
	// self.tableView.frame = originalFrame;
	// [self _layoutHeaderView];
	// self.headerView.frame = CGRectMake(0,0,[self.view superview].frame.size.width, 36);
	// self.tableView.tableHeaderView = self.headerView;
	// self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
	//self.tabl
}

// %new
// - (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
// {
//     return NO;
// }


#pragma mark - Table view data source

%new
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

%new
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self arrayForSection:section] count];
}

%new
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CCXSectionSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    CCXSectionsPanel *panel = (CCXSectionsPanel *)[NSClassFromString(@"CCXSectionsPanel") sharedInstance];
    NSString *sectionIdentifier = [[self arrayForSection:indexPath.section] objectAtIndex:indexPath.row];
    CCXSectionObject *data = [panel sectionObjectForIdentifier:sectionIdentifier];

    cell.textLabel.text = data.sectionName;
	cell.imageView.image = data.sectionIcon;
	((CCXSectionSettingsTableViewCell *)cell).sectionColor = [panel primaryColorForSectionIdentifier:sectionIdentifier] ? [panel primaryColorForSectionIdentifier:sectionIdentifier] : [UIColor colorWithWhite:0.55 alpha:1];

    if (data.settingsControllerClass) {
    	cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


	//////////////
    	
	// UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,29,29)];
 //    backgroundView.backgroundColor = [panel primaryColorForSectionIdentifier:sectionIdentifier] ? [panel primaryColorForSectionIdentifier:sectionIdentifier] : [UIColor grayColor];
 //    backgroundView.layer.cornerRadius = 7;
 //    backgroundView.clipsToBounds = YES;
 //    backgroundView.tag = 34;

 //    [cell addSubview:backgroundView];

 //    backgroundView.center = cell.imageView.center;

 //    if (cell && cell.imageView && [backgroundView superview]) {
 //    	backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
 //    	[cell addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
	// 	                                             attribute:NSLayoutAttributeCenterY
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:cell.imageView
	// 	                                             attribute:NSLayoutAttributeCenterY
	// 	                                             multiplier:1
	// 	                                               constant:0]];
 //    	[cell addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
	// 	                                             attribute:NSLayoutAttributeCenterX
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:cell.imageView
	// 	                                             attribute:NSLayoutAttributeCenterX
	// 	                                             multiplier:1
	// 	                                               constant:0]];
 //    	[cell addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
	// 	                                             attribute:NSLayoutAttributeWidth
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:nil
	// 	                                             attribute:NSLayoutAttributeNotAnAttribute
	// 	                                             multiplier:1
	// 	                                               constant:29]];
 //    	[cell addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
	// 	                                             attribute:NSLayoutAttributeHeight
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:nil
	// 	                                             attribute:NSLayoutAttributeNotAnAttribute
	// 	                                             multiplier:1
	// 	                                               constant:29]];

 //    	// cell.imageView.backgroundColor = [panel primaryColorForSwitchIdentifier:switchIdentifier];
 //    	// cell.imageView.layer.cornerRadius = 13;
 //    	// cell.imageView.clipsToBounds = YES;
 //    	cell.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
 //    	cell.imageView.tintColor = [UIColor whiteColor];
 //    }


 //    if (self.usingFlipControlCenter) {

 //    	if ([cell viewWithTag:34]) {
 //    		[[cell viewWithTag:34] removeFromSuperview];
 //    	}

 //    	FSSwitchPanel *panel = (FSSwitchPanel *)[NSClassFromString(@"FSSwitchPanel") sharedPanel];
	// 	NSString *switchIdentifier = [[self arrayForSection:indexPath.section] objectAtIndex:indexPath.row];
	// 	cell.textLabel.text = [panel titleForSwitchIdentifier:switchIdentifier];
	// 	cell.imageView.image = [[panel imageOfSwitchState:FSSwitchStateIndeterminate controlState:UIControlStateNormal forSwitchIdentifier:switchIdentifier usingTemplate:self.templateBundle] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    	
	// 	UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,29,29)];
 //    	backgroundView.backgroundColor = [panel primaryColorForSectionIdentifier:sectionIdentifier] ? [panel primaryColorForSectionIdentifier:sectionIdentifier] : [UIColor grayColor];
 //    	backgroundView.layer.cornerRadius = 7;
 //    	backgroundView.clipsToBounds = YES;
 //    	backgroundView.tag = 34;


 //    	///////////












 //    	////////////////

 //    	[cell addSubview:backgroundView];

 //    	backgroundView.center = cell.imageView.center;
 //    	if (cell && cell.imageView && [backgroundView superview]) {
 //    	backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
 //    	[cell addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
	// 	                                             attribute:NSLayoutAttributeCenterY
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:cell.imageView
	// 	                                             attribute:NSLayoutAttributeCenterY
	// 	                                             multiplier:1
	// 	                                               constant:0]];
 //    	[cell addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
	// 	                                             attribute:NSLayoutAttributeCenterX
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:cell.imageView
	// 	                                             attribute:NSLayoutAttributeCenterX
	// 	                                             multiplier:1
	// 	                                               constant:0]];
 //    	[cell addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
	// 	                                             attribute:NSLayoutAttributeWidth
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:nil
	// 	                                             attribute:NSLayoutAttributeNotAnAttribute
	// 	                                             multiplier:1
	// 	                                               constant:29]];
 //    	[cell addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
	// 	                                             attribute:NSLayoutAttributeHeight
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:nil
	// 	                                             attribute:NSLayoutAttributeNotAnAttribute
	// 	                                             multiplier:1
	// 	                                               constant:29]];

 //    	cell.imageView.backgroundColor = [panel primaryColorForSwitchIdentifier:switchIdentifier];
 //    	cell.imageView.layer.cornerRadius = 13;
 //    	cell.imageView.clipsToBounds = YES;
 //    	cell.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
 //    	cell.imageView.tintColor = [UIColor whiteColor];
 //    }
 //    	//[cell sendSubviewToBack:backgroundView];


 //    } else {

	//     //cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	    
	//     NSDictionary *dc = [(NSMutableArray *)self.books[indexPath.section] objectAtIndex:indexPath.row];
	//     //cell.textLabel.text = [dc objectForKey:@"label"];
	//     if (indexPath.section == 0) {
	// 	    if (indexPath.row == 0) {
	// 	    	//cell.textLabel.text = @"Airplane Mode";
	// 	    	//cell.imageView.image = [UIImage imageNamed:@"AirplaneMode" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Preferences.framework/"]];
	// 	    	cell.textLabel.text = @"Toggles";
	// 	    	cell.imageView.image = [[UIImage imageNamed:@"Settings_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	// 			cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	// 		} else if (indexPath.row == 1) {
	// 			// cell.textLabel.text = @"Wi-Fi";
	// 			cell.textLabel.text = @"Music";
	// 			cell.imageView.image = [[UIImage imageNamed:@"Music_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	// 			cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	// 			//cell.imageView.image = [UIImage imageNamed:@"WiFi" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Preferences.framework/"]];
	// 		} else if (indexPath.row == 2) {
	// 			// cell.textLabel.text = @"Bluetooth";
	// 			cell.textLabel.text = @"Multi-Slider";
	// 			cell.imageView.image = [[UIImage imageNamed:@"Sliders_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	// 			cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	// 			//cell.imageView.image = [UIImage imageNamed:@"Bluetooth" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Preferences.framework/"]];
			
	// 		} else if (indexPath.row == 3) {
	// 			// cell.textLabel.text = @"Do Not Disturb";
	// 			cell.textLabel.text = @"Air & Night";
	// 			cell.imageView.image = [[UIImage imageNamed:@"Button_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	// 			cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	// 			//cell.imageView.image = [UIImage imageNamed:@"DND" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Preferences.framework/"]];
	// 		} else if (indexPath.row == 4) {
	// 			// cell.textLabel.text = @"Do Not Disturb";
	// 			cell.textLabel.text = @"Shortcuts";
	// 			cell.imageView.image = [[UIImage imageNamed:@"Shortcuts_Section" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/Horseshoe.bundle/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	// 			cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	// 			//cell.imageView.image = [UIImage imageNamed:@"DND" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Preferences.framework/"]];
	// 		} else {
	// 			cell.textLabel.text = [dc objectForKey:@"label"]; 
	// 		}
	// 	} else if (indexPath.section == 1)  {
	// 		if (indexPath.row == 0) {
	// 			cell.textLabel.text = @"Brightness";
	// 			cell.imageView.image = [[UIImage imageNamed:@"ControlCenterGlyphMoreBright" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/ControlCenterUI.framework/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	// 	    	// cell.textLabel.text = @"Hotspot";
	// 	    	// cell.imageView.image = [UIImage imageNamed:@"PersonalHotspot" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Preferences.framework/"]];
	// 		} else if (indexPath.row == 1) {
	// 			cell.textLabel.text = @"Volume";
	// 			cell.imageView.image = [[UIImage imageNamed:@"volume-maximum-value-image" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/MediaPlayerUI.framework/"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	// 			// cell.textLabel.text = @"Cellular";
	// 			// cell.imageView.image = [UIImage imageNamed:@"CellularData" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Preferences.framework/"]];
	// 		} else if (indexPath.row == 2) {
	// 			// cell.textLabel.text = @"Low Power Mode";
	// 			// cell.imageView.image = [UIImage imageNamed:@"BatteryUsage" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Preferences.framework/"]];
	// 		} else {
	// 			cell.textLabel.text = [dc objectForKey:@"label"]; 
	// 		}
	// 	}

	// 	cell.imageView.tintColor = [UIColor whiteColor];
	// 	UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,29,29)];
 //    	backgroundView.backgroundColor = [UIColor colorWithWhite:0.55 alpha:1];
 //    	backgroundView.layer.cornerRadius = 7;
 //    	backgroundView.clipsToBounds = YES;
 //    	backgroundView.tag = 34;

 //    	[cell.contentView addSubview:backgroundView];
 //    	backgroundView.center = cell.imageView.center;
 //    	if (cell.contentView && cell.imageView && [backgroundView superview]) {
 //    	backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
 //    	[cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
	// 	                                             attribute:NSLayoutAttributeCenterY
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:cell.imageView
	// 	                                             attribute:NSLayoutAttributeCenterY
	// 	                                             multiplier:1
	// 	                                               constant:0]];
 //    	[cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
	// 	                                             attribute:NSLayoutAttributeCenterX
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:cell.imageView
	// 	                                             attribute:NSLayoutAttributeCenterX
	// 	                                             multiplier:1
	// 	                                               constant:0]];
 //    	[cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
	// 	                                             attribute:NSLayoutAttributeWidth
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:nil
	// 	                                             attribute:NSLayoutAttributeNotAnAttribute
	// 	                                             multiplier:1
	// 	                                               constant:29]];
 //    	[cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView
	// 	                                             attribute:NSLayoutAttributeHeight
	// 	                                             relatedBy:NSLayoutRelationEqual
	// 	                                                toItem:nil
	// 	                                             attribute:NSLayoutAttributeNotAnAttribute
	// 	                                             multiplier:1
	// 	                                               constant:29]];
 //    }

 //    	//cell.imageView.backgroundColor = [panel primaryColorForSwitchIdentifier:switchIdentifier];
 //    	//cell.imageView.layer.cornerRadius = 13;
 //    	//cell.imageView.clipsToBounds = YES;
 //    	cell.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
 //    	cell.imageView.tintColor = [UIColor whiteColor];
 //    	[cell.contentView sendSubviewToBack:backgroundView];

	// }
    //cell.tag = [[dc objectForKey:@"tag"] intValue];
    
   // cell.imageView.image = [UIImage imageNamed:@"AirplaneMode" inBundle:[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/Preferences.framework/"]];
    //cell.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);

	
   // [cell setSeparatorColor:[UIColor whiteColor]];
    //[self.primaryEffectConfig configureLayerView:[cell valueForKey:@"_separatorView"]];
   // [cell _setSeparatorEffect:[NSClassFromString(@"CCUIControlCenterVisualEffect")  _primaryRegularTextOnPlatterEffect]];
 //    [self.primaryEffectConfig deconfigureLayerView:[cell valueForKey:@"_separatorView"]];
	// [self.primaryEffectConfig configureLayerView:[cell valueForKey:@"_separatorView"]];
    return cell;
}

- (void)layoutSubviews {
	%orig;
	// if (self.tableView.frame.origin.y != 36) {
	//     CGRect originalFrame = self.tableView.frame;
	// 	originalFrame.origin.y = 36;
	// 	originalFrame.size.height = [self.view superview].frame.size.height - 36;
	// 	self.tableView.frame = originalFrame;
	// }

	// if (![self.headerView superview] && [self.view superview]) {
	// 	[[self.view superview] addSubview:self.headerView];
	// 	self.headerView.frame = CGRectMake(0,0,[self.view superview].frame.size.width, 36);
	// }
}

-(void)viewWillAppear:(BOOL)arg1 {
	%orig;
	// if (self.delegate) {
	// 	[self.delegate.view _rerenderPunchThroughMaskIfNecessary];
	// }
	// if (self.view.frame.origin.y != 36) {
	//     CGRect originalFrame = self.tableView.frame;
	// 	originalFrame.origin.y = 36;
	// 	originalFrame.size.height = [self.view superview].frame.size.height - 36;
	// 	self.tableView.frame = originalFrame;
	// }

	// if (![self.headerView superview] && [self.view superview]) {
	// 	[[self.view superview] addSubview:self.headerView];
	// 	self.headerView.frame = CGRectMake(0,0,[self.view superview].frame.size.width, 36);
	// }
}

-(void)viewDidLayoutSubviews
{
    %orig;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
 //    if (self.delegate) {
	// 	[self.delegate.view _rerenderPunchThroughMaskIfNecessary];
	// }
 //    if (self.view.frame.origin.y != 36) {
	//     CGRect originalFrame = self.tableView.frame;
	// 	originalFrame.origin.y = 36;
	// 	originalFrame.size.height = [self.view superview].frame.size.height - 36;
	// 	self.tableView.frame = originalFrame;
	// }

 //    if (self.tableView.frame.origin.y != 36) {
	//     CGRect originalFrame = self.tableView.frame;
	// 	originalFrame.origin.y = 36;
	// 	originalFrame.size.height = [self.view superview].frame.size.height - 36;
	// 	self.tableView.frame = originalFrame;
	// }

	// if (![self.headerView superview] && [self.view superview]) {
	// 	[[self.view superview] addSubview:self.headerView];
	// 	self.headerView.frame = CGRectMake(0,0,[self.view superview].frame.size.width, 36);
	// }
}

%new
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	// CCUIControlCenterVisualEffect *effect = [NSClassFromString(@"CCUIControlCenterVisualEffect")  _primaryRegularTextOnPlatterEffect];
 //    _UIVisualEffectConfig *effectConfig = [effect effectConfig];
 //    _UIVisualEffectLayerConfig *effectLayerConfig = effectConfig.contentConfig;

	for (UIView *view in [cell subviews]) {
		if ([view isKindOfClass:NSClassFromString(@"UITableViewCellReorderControl")]) {
			for (UIImageView *imageView in [view subviews]) {
				imageView.image = [imageView.image  imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
				imageView.tintColor = [UIColor whiteColor];
				//[self.primaryEffectConfig deconfigureLayerView:imageView];
				[self.primaryEffectConfig configureLayerView:imageView];
			}
			[self.primaryEffectConfig configureLayerView:view];
		} else {
			if (view.frame.size.width == 0.5) {
				view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
			}
		}
	}
	if ([cell valueForKey:@"_accessoryView"])
    	[self.primaryEffectConfig configureLayerView:[cell valueForKey:@"_accessoryView"]];

 //    if (self.usingFlipControlCenter) {
	//     cell.imageView.layer.cornerRadius = 7;
	//     cell.imageView.clipsToBounds = YES;
	// }
	if ([cell viewWithTag:34]) {
		[cell sendSubviewToBack:[cell viewWithTag:34]];
		[cell viewWithTag:34].layer.cornerRadius = 7;
		[cell.contentView sendSubviewToBack:[cell viewWithTag:34]];
		//[cell viewWithTag:34].center = cell.imageView.center;
    	//[[cell viewWithTag:34] removeFromSuperview];
    }
 //    if (self.delegate) {
	// 	[self.delegate.view _rerenderPunchThroughMaskIfNecessary];
	// }
	// [self.primaryEffectConfig deconfigureLayerView:[cell valueForKey:@"_separatorView"]];
	// [self.primaryEffectConfig configureLayerView:[cell valueForKey:@"_separatorView"]];
}

%new
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 28;
}

%new
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CCXPunchOutView *view = [[NSClassFromString(@"CCXPunchOutView") alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    /* Create custom view to display section header... */
    view.cornerRadius = 13;
    view.roundCorners = 0;
    view.style = 0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setFont:[[self class] sectionHeaderFont]];
    NSString *text;
    // if (section == 0)
    // 	text = @"Toggles (Enabled)";
    // else if (section == 1)
    // 	text = @"Toggles (Disabled)";
     if (section == 0)
    	text = @"Sections (Enabled)";
    else if (section == 1)
    	text = @"Sections (Disabled)";
    /* Section header is in 0th index... */
    [label setText:text];
    [view addSubview:label];

    // [self.primaryEffectConfig configureLayerView:label];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
   // [[NSClassFromString(@"CUIControlCenterVisualEffect")  effectWithControlState:0 inContext:6].effectConfig.contentConfig configureLayerView:label.layer];
    // CUIControlCenterVisualEffect

    label.translatesAutoresizingMaskIntoConstraints = NO;
	[view addConstraint:[NSLayoutConstraint constraintWithItem:label
		                                             attribute:NSLayoutAttributeCenterY
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:view
		                                             attribute:NSLayoutAttributeCenterY
		                                             multiplier:1
		                                               constant:0]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:label
		                                             attribute:NSLayoutAttributeLeft
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:view
		                                             attribute:NSLayoutAttributeLeft
		                                             multiplier:1
		                                               constant:15]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:label
		                                             attribute:NSLayoutAttributeRight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:view
		                                             attribute:NSLayoutAttributeRight
		                                             multiplier:1
		                                               constant:0]];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:label
		                                             attribute:NSLayoutAttributeHeight
		                                             relatedBy:NSLayoutRelationEqual
		                                                toItem:view
		                                             attribute:NSLayoutAttributeHeight
		                                             multiplier:1
		                                               constant:0]];
		
    [view setBackgroundColor:nil];
    return view;
}
#pragma mark - Table view delegate
%new
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    // if (_detailViewController == nil) {
    //     _detailViewController = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
    // }
        
    // // データを受け渡す
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // _detailViewController.navigationItem.title = [[NSString alloc] initWithFormat:@"%@", cell.textLabel.text];
    // _detailViewController.textLabel.text = [[NSString alloc] initWithFormat:@"%@", cell.textLabel.text];
    
    // // Pass the selected object to the new view controller.
    // [self.navigationController pushViewController:_detailViewController animated:YES];
}

%new
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
// Return NO if you do not want the specified item to be editable.
return YES;
}

%new
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// if (indexPath.section == 0)
	// 	return UITableViewCellEditingStyleDelete;
	// else 
	// 	return UITableViewCellEditingStyleInsert;
	return UITableViewCellEditingStyleNone;
}

%new
 - (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath 
 {
 return NO;
 }

 %new
 - (BOOL) tableView: (UITableView *) tableView canMoveRowAtIndexPath: (NSIndexPath *) indexPath {
 	return YES;
 }

 %new
 - (void)tableView: (UITableView *) tableView moveRowAtIndexPath: (NSIndexPath *) fromIndexPath toIndexPath: (NSIndexPath *) toIndexPath {
	
	//[(UIPanGestureRecognizer *)[[[NSClassFromString(@"SBControlCenterController") sharedInstance] _controlCenterViewController] valueForKey:@"_panGesture"] setEnabled:NO];
	
	NSMutableArray *fromArray = fromIndexPath.section ? self.disabledIdentifiers : self.enabledIdentifiers;
	NSMutableArray *toArray = toIndexPath.section ? self.disabledIdentifiers : self.enabledIdentifiers;
	NSString *identifier = [fromArray objectAtIndex:fromIndexPath.row];
	[fromArray removeObjectAtIndex:fromIndexPath.row];
	[toArray insertObject:identifier atIndex:toIndexPath.row];
	[self _flushSettings];
	//[(UIPanGestureRecognizer *)[[[NSClassFromString(@"SBControlCenterController") sharedInstance] _controlCenterViewController] valueForKey:@"_panGesture"] setEnabled:YES];
	//[(UIPanGestureRecognizer *)[[[[NSClassFromString(@"SBControlCenterController") sharedInstance] _controlCenterViewController] valueForKey:@"_panGesture"] setEnabled:YES];
 	return;
}

%new
- (void)tableView:(UITableView *)tableView willBeginReorderingRowAtIndexPath:(NSIndexPath *)indexPath {
	[(UIPanGestureRecognizer *)[[[NSClassFromString(@"SBControlCenterController") sharedInstance] _controlCenterViewController] valueForKey:@"_panGesture"] setEnabled:NO];
}

%new
- (void)tableView:(UITableView *)tableView didEndReorderingRowAtIndexPath:(NSIndexPath *)indexPath {
	[(UIPanGestureRecognizer *)[[[NSClassFromString(@"SBControlCenterController") sharedInstance] _controlCenterViewController] valueForKey:@"_panGesture"] setEnabled:YES];
	// tableView.editing = NO;
	// tableView.editing = YES;
}

%new
- (void)tableView:(UITableView *)tableView didCancelReorderingRowAtIndexPath:(NSIndexPath *)indexPath {
	[(UIPanGestureRecognizer *)[[[NSClassFromString(@"SBControlCenterController") sharedInstance] _controlCenterViewController] valueForKey:@"_panGesture"] setEnabled:YES];
}

%new
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }    
}

%new
- (NSArray *)arrayForSection:(NSInteger)section
{
	return section ? self.disabledIdentifiers : self.enabledIdentifiers;
}

%new
- (void)_flushSettings
{
	if (self.preferencesApplicationID && (self.enabledKey || self.disabledKey)) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		if (self.enabledKey) {
			[dict setObject:self.enabledIdentifiers forKey:self.enabledKey];
		}
		if (self.disabledKey) {
			[dict setObject:self.disabledIdentifiers forKey:self.disabledKey];
		}
		CFPreferencesSetMultiple((CFDictionaryRef)dict, NULL, (__bridge CFStringRef)self.preferencesApplicationID, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
		CFPreferencesAppSynchronize((__bridge CFStringRef)self.preferencesApplicationID);
	}
	if (self.settingsFile) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:self.settingsFile] ?: [NSMutableDictionary dictionary];
		if (self.enabledKey) {
			[dict setObject:self.enabledIdentifiers forKey:self.enabledKey];
		}
		if (self.disabledKey) {
			[dict setObject:self.disabledIdentifiers forKey:self.disabledKey];
		}
		NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListBinaryFormat_v1_0 errorDescription:NULL];
		[data writeToFile:self.settingsFile atomically:YES];
	}
	if (self.notificationName) {
		[[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName
                                                    object:nil
                                                  userInfo:nil];
	}
}

%new
+ (UIFont *)sectionHeaderFont {
	UIFontDescriptor *descriptor = [[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote] fontDescriptorWithFamily:@".SFUIText"];
	descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitCondensed];
	return [UIFont fontWithDescriptor:descriptor size:0];
// 	return [UIFont fontWithName:@".SFUIText" size:font.pointSize-1*[UIScreen mainScreen].scale) traits:[font traits]];
}
%end