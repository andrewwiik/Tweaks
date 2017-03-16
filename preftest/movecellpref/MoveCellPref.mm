#import <Preferences/Preferences.h>

@interface MoveCellPrefListController: PSEditableListController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *_group1Cells;
	NSMutableArray *_group2Cells;
}

@property (nonatomic, retain) NSArray *group1Cells;
@property (nonatomic, retain) NSArray *group2Cells2;

@end

static NSString *plistPath = @"/var/mobile/Library/Preferences/edu.self.movecelllpref.plist";

@implementation MoveCellPrefListController
- (id)specifiers {
	if(_specifiers == nil) {
        
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
        if(!settings) {
            settings = [NSMutableDictionary dictionary];
            [settings writeToFile:plistPath atomically:YES];
        }
        
        _group1Cells = [(NSMutableArray *) [settings valueForKey:@"group1"] retain];
        _group2Cells = [(NSMutableArray *) [settings valueForKey:@"group2"] retain];
        
        if(settings == nil || !_group1Cells || !_group2Cells) {
			NSLog(@"Setting up defaults");
			//set defaults
			_group1Cells = [@[@"First",@"Second"] mutableCopy];
			_group2Cells = [@[@"Third", @"Fourth"] mutableCopy];
			[settings setValue:_group1Cells forKey:@"group1"];
			[settings setValue:_group2Cells forKey:@"group2"];
			[settings writeToFile:plistPath atomically:YES];
		}

        
        _specifiers = [[self loadSpecifiersFromPlistName:@"MoveCellPref" target:self] retain];
        
        for(NSString* spec in [[_group1Cells reverseObjectEnumerator] allObjects]) {
            
            PSSpecifier *specifier;
            
            if([spec isEqualToString:@"First"]){
                specifier = [PSSpecifier preferenceSpecifierNamed:spec target:self set:nil get:nil detail:NSClassFromString(@"MoveCellPrefDetailListController") cell:[PSTableCell cellTypeFromString:@"PSLinkCell"] edit:1];
            } else {
                specifier = [PSSpecifier preferenceSpecifierNamed:spec target:self set:nil get:nil detail:nil cell:[PSTableCell cellTypeFromString:@"PSTitleValueCell"] edit:1];
            }
            
            [_specifiers insertObject:specifier atIndex:1];
		
        }
        
        for(NSString* spec in [[_group2Cells reverseObjectEnumerator] allObjects]) {
            
            PSSpecifier *specifier;
            
            if([spec isEqualToString:@"First"]){
                specifier = [PSSpecifier preferenceSpecifierNamed:spec target:self set:nil get:nil detail:NSClassFromString(@"MoveCellPrefDetailListController") cell:[PSTableCell cellTypeFromString:@"PSLinkCell"] edit:1];
            } else {
                specifier = [PSSpecifier preferenceSpecifierNamed:spec target:self set:nil get:nil detail:nil cell:[PSTableCell cellTypeFromString:@"PSTitleValueCell"] edit:1];
            }
            
            [_specifiers insertObject:specifier atIndex:2+[_group1Cells count]];
            
        }

	}
	return _specifiers;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.allowsSelectionDuringEditing = YES;
	if (indexPath.section < 2) {
        return YES;
    }
    
    return NO;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}
-(id)_editButtonBarItem {
	return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
	if (proposedDestinationIndexPath.section > 1) {
	    NSInteger row = 0;
	    if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
	    }
	    return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}


-(int)inPathToIndex:(NSIndexPath *)index {
	return 1;
}



-(void)tableView: (UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndex toIndexPath:(NSIndexPath *)toIndex {
    
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *title = @"";
    
    if(fromIndex.section == 0) {
        title = [_group1Cells objectAtIndex:fromIndex.row];
        [_group1Cells removeObjectAtIndex:fromIndex.row];
        [settings setValue:_group1Cells forKey:@"group1"];
    } else if (fromIndex.section == 1) {
        title = [_group2Cells objectAtIndex:fromIndex.row];
        [_group2Cells removeObjectAtIndex:fromIndex.row];
        [settings setValue:_group2Cells forKey:@"group2"];
    }
    
    if(toIndex.section == 0) {
        [_group1Cells insertObject:title atIndex:toIndex.row];
        [settings setValue:_group1Cells forKey:@"group1"];
    } else if (toIndex.section == 1) {
        [_group2Cells insertObject:title atIndex:toIndex.row];
        [settings setValue:_group2Cells forKey:@"group2"];
    }
    
    [settings writeToFile:plistPath atomically:YES];
    
    
	tableView.allowsSelectionDuringEditing = YES;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	cell.editingAccessoryView = cell.accessoryView;
    
    if (indexPath.section == 0) {
        NSString *cellName = (NSString *)[_group1Cells objectAtIndex:indexPath.row];
        if([cellName isEqualToString:@"First"]) {
            cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if (indexPath.section == 1) {
        NSString *cellName = (NSString *)[_group2Cells objectAtIndex:indexPath.row];
        if([cellName isEqualToString:@"First"]) {
            cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    tableView.allowsSelectionDuringEditing = YES;
	tableView.editing = YES;
	[super setEditingButtonHidden:NO animated:NO];
	[super setEditButtonEnabled:NO];
    
	return cell;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0)
        return [_group1Cells count];
    if(section == 1)
        return [_group2Cells count];
    if(section == 2)
        return 1;
    return 0;
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (id)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *header = [super tableView:tableView titleForHeaderInSection:section];
	return header;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	tableView.allowsSelectionDuringEditing = YES;
    
	if(indexPath.section == 0) {
		NSString *spec = [_group1Cells objectAtIndex:indexPath.row];
        if ([spec isEqualToString:@"First"]) {
            MoveCellPrefDetailListController *_controller = [[MoveCellPrefDetailListController alloc] init];
            if (_controller) {
                [self.navigationController pushViewController:_controller animated:YES];
            }
        }
    } else if(indexPath.section == 1) {
		NSString *spec = [_group2Cells objectAtIndex:indexPath.row];
        if ([spec isEqualToString:@"First"]) {
            MoveCellPrefDetailListController *_controller = [[MoveCellPrefDetailListController alloc] init];
            if (_controller) {
                [self.navigationController pushViewController:_controller animated:YES];
            }
        }

	} else {
		[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}


@end
