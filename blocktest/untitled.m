- (id)nodes {

    if (self.processing) return %orig;

    self.processing = YES;

    NSMutableArray orig = [%orig mutableCopy];

    if (!self.listView) {
        
        // No point in grabbing the |SBIconListView| if there aren't any |SBIcon|(s).
        // This also prevents a "Out of Bounds" Exception from occurring.
        
        if ([[self valueForKey:@"_nodes"] count] > 0) {
            
            // Grab the |NSIndexPath| for the first |SBIcon| in this |SBIconIndexMutableList|.
            // The index path consists of two numbers, the first being the index of the |SBIconListView|
            // page where the |SBIcon| is located and the second number being the index of the
            // actual |SBIcon|in reference to the rest of the |SBIcon|(s) on the |SBIconListView|.
            
            NSIndexPath *iconIndexPath = [(SBRootFolder *)[[NSClassFromString(@"SBIconController") sharedInstance] valueForKeyPath:@"rootFolder"] indexPathForIcon:[[self valueForKey:@"_nodes"] objectAtIndex:0]];
            
            // Use the |NSIndexPath| that we grabbed for the first |SBIcon| in this |SBIconIndexMutableList|
            // to grab the |SBIconListView| pertaining to this |SBIconIndexMutableList| and cache it to the
            // [listView] property on this |SBIconIndexMutableList| instance.
            
            if ([[NSClassFromString(@"SBIconController") sharedInstance] respondsToSelector:@selector(getListView:folder:relativePath:forIndexPath:createIfNecessary:)]) {
                
                SBIconListView *listView = nil;
                [[NSClassFromString(@"SBIconController") sharedInstance] getListView:&listView folder:NULL relativePath:NULL forIndexPath:iconIndexPath createIfNecessary:NO];
                self.listView = listView;
            } else {
                return orig;
            }
        }
    }
    
    // If an instance of |SBIconListView| exists on the [listView] property of
    // this |SBIconIndexMutableList| instance
        
    NSMutableArray *finalGrid = [NSMutableArray new];
        
    if (self.listView != nil) {
            
        // Grab the current |UIInterfaceOrientation| so it can be used later on.
            
        UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            
        // We need to copy the |NSMutableArray| that contains all of the |SBIcon| instances
        // which can found on the instance Variable [_nodes] on this |SBIconIndexMutableList| instance.
        // If a separate copy wasn't made the future operations below wouldn't be thread safe and
        // it becomes a possibility that SpringBoard could crash quite easily.
            
        NSMutableArray *nodes = [(NSMutableArray *)[self valueForKey:@"_nodes"] mutableCopy];
        NSMutableArray *unfinishedNodes = [nodes mutableCopy];
        NSMutableArray *nextPage = [NSMutableArray new];
            
        // We need to know the number of rows and columns the |SBIconListView| instance
        // on the [listView] property of this |SBIconIndexMutableList| can hold for the
        // device's current orientation in order to use the information later in this
        // method implementation for calculations.
            
        int maxNumberOfColumns = 0;
        int maxNumberOfRows = 0;
            
        if ([self.listView respondsToSelector:@selector(iconColumnsForCurrentOrientation)]) {
            maxNumberOfColumns = [self.listView iconColumnsForCurrentOrientation];
                
            if ([self.listView respondsToSelector:@selector(iconRowsForCurrentOrientation)]) {
                maxNumberOfRows = [self.listView iconRowsForCurrentOrientation];
            }
        }
            
        if (maxNumberOfColumns == 0 || maxNumberOfRows == 0) return orig;
            
        // Now we need to make a 2D array to store the icon Layout that is
        // calculated. The 2D |NSMutableArray| also needs to be filled with |NSNull|(s)
        // so that Objects can be set anywhere in the 2D array. The max rows
        // and columns that were grabbed above will be used to fix the 2D array
        // to the correct size
            
        NSMutableArray *grid = [NSMutableArray new];

        for (int r = 0; r < maxNumberOfRows; r++) {
            grid[r] = [NSMutableArray new];
            for (int c = 0; c < maxNumberOfColumns; c++) {
                grid[r][c] = [NSNull null];
            }
        }

        // First the current |NSMutableArray| of |SBIcon|(s) needs to be filtered to remove all the
        // instances of |SBWDXPlaceholderIcon| which is a custom subclass of |SBIcon| that is used when
        // an icon is in "Block" form to provide pseudo |SBIconView|(s) in order to keep the layout of
        // the |SBIconListView| looking as it should.

        NSMutableArray *temp = [NSMutableArray new];

        for (id icon in nodes) {

            // If the [icon] isn't a instance of |SBWDXPlaceholderIcon| It is added to the [temp]
            // |NSMutableArray| which is filled with all of instances of |SBIcon| that were not
            // also instances of |SBWDXPlaceholderIcon|

            if (![icon isKindOfClass:NSClassFromString(@"SBWDXPlaceholderIcon")]) {
                [temp addObject:icon];
            }
        }

        nodes = temp;

        NSMutableArray *unfinishedNodes = [nodes mutableCopy];
            
        // Now the 2D array needs to be populated with the |SBIcon|(s), while accounting
        // for any |SBIcon|(s) that expanded into "Block" form. If a |SBIcon| is expanded
        // into "Block" form the rest of spaces in the grid that it consumes will be filled
        // with a pseudo placeholder icon |SBWDXPlaceholderIcon| which is a subclass of |SBIcon|
        // in order to keep the icons laid out properly on the |SBIconListView|. First all the
        // |SBIcon|(s) need to be looped over to check if any of them are expanded into "Block" form because
        // if a |SBIcon| is expanded into block form it has a higher priority of placement in the grid
            
        for (id icon in nodes) {
                
            // Every |SBIcon| or subclasses of it has the method "applicationBundleID"
            // that returns a |NSString| containing the unique identifier for that |SBIcon|.
            // We should always make sure of course that the object the method is being performed
            // on can actually respond to the message first. A class called |IBKResources| has the
            // selector "indexForBundleID:" that will return the saved index of any |SBIcon| that
            // is expanded into "Block" form. The method consumes the |SBIcon|'s unique identifier
            // as a |NSString| and returns a [int] for its corresponding index if one exists. If a
            // corresponding index does not exist it will return 'nil'.

            // If the icon is pseudo placeholder of the class |SBWDXPlaceholderIcon| it should be skipped
            // because all of the pseudo placeholders are getting recalculated in this method implimentation.
            // Although early in this method implimentation all of the |SBWDXPlaceholderIcon|(s) were supposedly
            // filter out of the "nodes" |NSMutableArray| it is always better to be safe than sorry.

            if (![icon isKindOfClass:NSClassFromString(@"SBWDXPlaceholderIcon")]) {

                // Everytime a private method is accessed it should be checked in case the method name, signature
                // or implimentation changes in a later version of iOS. Thank you to John Coates for this tip.

                if ([icon respondsToSelector:@selector(applicationBundleID)]) {

                    // If the |SBIcon|'s identifier is saved to a variable it will reduce the number of method calls
                    // for this method implimentation

                    NSString *iconIdentifier = [(SBIcon *)icon applicationBundleID];

                    // If the |SBIcon|'s identifier is null the current iteration of this loop should be skipped because
                    // without a identifier the rest of the processing in this loop is uselss.
                        
                    if (!iconIdentifier) continue;
                        
                    int index = [IBKResources indexForBundleID:iconIdentifier];

                    if (index == 973) {
                        continue;
                    }

                    // The index needs to be converted to |SBIconCoordinate| which is a struct that has
                    // a row and column field. the row field starts at 1 and the column field starts at 1.
                    // An function called "SBIconCoordinateMake" takes in a row and column both of type
                    // |long long| in that order and returns a |SBIconCoordinate|. The |SBIconListView|
                    // instance that is cached has the selector "iconCoordinateForIndex:forOrientation:" that
                    // consumes the index that needs to be converted to a |SBIconCoordinate| and the orientation
                    // that the |SBIconCoordinate| should be in reference to. The variable 'origCoord' is used
                    // later in this method implementation in order to check if the coordinate had to be moved due
                    // to the widget not being able to be placed in its original primary position.

                    SBIconCoordinate coord;
                    SBIconCoordinate origCoord;
                        
                    if ([self.listView respondsToSelector:@selector(iconCoordinateForIndex:forOrientation:)]) {
                        coord = [self.lisetView iconCoordinateForIndex:index forOrientation:currentOrientation];
                        origCoord = coord;
                    } else {

                        // If |SBIconListView| does not respond to the selector (iconCoordinateForIndex:forOrientation)
                        // it can safely be assumed that the rest of this method implementation will process incorrect
                        // results so the best route would be to return this method's original implimentation in order
                        // to avoid unwanted side-effects due to incorrect calculations.

                        return %orig;
                    }

                    // Every "Block" can consume a custom number of rows and columns that the user can set
                    // in the Preferneces for that block. The default number of columns and rows consumed if no
                    // custom number is set in settings is 2 columns and 2 rows. The class |IBKResources| has
                    // two selectors, "horiztonalWidgetSizeForBundleID:" and "verticalWidgetSizeForBundleID:",
                    // they both consume the unique identifier return by the "applicationBundleID" selector
                    // which is found on all instances of |SBIcon| and any subclasses of |SBIcon|. The
                    // selector "horiztonalWidgetSizeForBundleID:" returns the number of columns the |SBIcon| in
                    // "Block" form should consume and the selector "verticalWidgetSizeForBundleID:" returns the
                    // number of rows the |SBIcon| in "Block" form should consume.

                    int blockWidth = [IBKResources horiztonalWidgetSizeForBundleID:iconIdentifier];
                        
                    int blockHeight = [IBKResources verticalWidgetSizeForBundleID:iconIdentifier];

                    // The |SBIconCoordinate|, "blockWidth" and "blockHeight" need to be used to calculate
                    // where the best fit for the "block" of this |SBIcon|. The "blockWidth" and "blockHeight" are
                    // used to check all coordinates the "block" would consume on the 2D grid "grid". If all the 
                    // coordinates that the "block" would consume return |NSNull| It can safely be assumed that it is 
                    // safe to place the "block" in this current position. If any of the cooridnates that the "block" would
                    // return anything other than |NSNull| it has to assumed that there is something currently placed
                    // at that coordinate in the 2D grid so the "block" will be unable to placed in the position.
                    // In the event that the "block" cannot be placed in its original primary coordinate its primary
                    // coordinate will be moved over one and the above conditions will be tested again against the new
                    // primary coordinate. If it is decided that the "block" cannot be fit in any of the availbale
                    // coordinates on the 2D grid it will placed in |NSMutableArray| that will processed at the end
                    // of this method implimentation to move all icons and or blocks to the next available spot on
                    // another |SBIconListView|

                    // A while loop is used to loop over every possible coordinate the "block" can be placed until
                    // a position is found where the "block" can be placed while meeting all of the conditions outlined
                    // above. 

                    BOOL isPlaced = NO

                    while (!isPlaced) {

                        // If the primary coordinate being checked has a row or column that would cause the "block"
                        // to overflow the page vertical or horizonatly it should be iterated until the coordinate does not.

                        while (coord.row + blockHeight - 1 > maxNumberOfRows || coord.col + blockWidth - 1 > maxNumberOfColumns) {

                            if (coord.col + blockWidth - 1 > maxNumberOfColumns) {

                                coord.row = coord.row + 1;
                                coord.col = 1;
                            }

                            if (coord.row + blockHeight - 1 > maxNumberOfColumns) {

                                [nextPage addObject:icon];
                                [unfinishedNodes removeObject: icon];
                                continue;
                            }
                        }

                        // The "blockWidth" and "blockHeight" are used to check every coordinate that the block would consume
                        // to check if they are empty. If they are all empty the "block" can be placed in that position.

                        BOOL isValid = YES

                        for (int row = 0; row < blockHeight; row++) {
                            for (int col = 0; col < blockWidth; col++) {

                                if (!isNSNull(grid[coord.row + row - 1][coord.col + col - 1])) {

                                    isValid = NO;
                                }
                            }
                        }

                        // If all of the coordinates that the block would consume are empty we can place it in the 2D grid.

                        if (isValid) {

                            for (int row = 0; row < blockHeight; row++) {
                                for (int col = 0; col < blockWidth; col++) {

                                    if (row == 0 && col == 0) {

                                        grid[coord.row - 1][coord.col - 1] = icon;
                                    } else {

                                        SBWDXPlaceholderIcon *placeHolder = [[NSClassFromString(@"SBWDXPlaceholderIcon") alloc] initWithIdentifier:[NSString stringWithFormat:@"WIDUXPlaceHolder_%ld/%@", (long)row+col, iconIdentifier]]
                                        grid[coord.row + row - 1][coord.col + col - 1] = placeHolder;
                                    }
                                }
                            }

                            [unfinishedNodes removeObject: icon];
                            isPlaced = YES;
                        }
                        else {

                            if (coord.col + blockWidth - 1 == maxNumberOfColumns) {

                                coord.row = coord.row + 1;
                                coord.col = 1;
                            }
                            else {

                                coord.col = coord.col + 1;
                            }
                        }
                    }
                }
            } else {

                [unfinishedNodes removeObject: icon];
            }
        }
    } else {

        return %orig;
    }

    NSMutableArray *unfinishedNodesCopy = [unfinishedNodes mutableCopy];
    int count = 0;

    for (int row = 0; row < maxNumberOfRows; row++) {
        for (int col = 0; col < maxNumberOfColumns; col++) {
            if (isNSNull(grid[row[col]])) {
                if (count < [unfinishedNodes count]) {
                    grid[row][col] = [unfinishedNodes objectAtIndex:count];
                    [unfinishedNodesCopy removeObject:[unfinishedNodes objectAtIndex:count]];
                    count++;
                }
            }
        }
    }

    if ([unfinishedNodesCopy count] > 0) {
        for (id icon in unfinishedNodesCopy) {
            [nextPage addObject:icon];
        }
    }

    NSLog(@"Left Over Icons: %@", nextPage);

    NSMutableArray *finalGrid = [NSMutableArray new];

    for (int row = 0; row < maxNumberOfRows; row++) {
        for (int col = 0; col < maxNumberOfColumns; col++) {

            if (!isNSNull(grid[row][col])) {

                [finalGrid addObject:grid[row][col]];
            }
        }
    }

    [self removeAllNodes];

    for (id icon in finalGrid) {
        [self addNode: icon];
    }

    self.processing = NO;
    return finalGrid;

            
            
            
        
        //                [self setValue:finalGrid forKey:@"_nodes"];
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self setValue:finalGrid forKey:@"_nodes"];
    NSLog(@"%@", finalGrid);
    return [self valueForKey:@"_nodes"];
            //                MSHookIvar<NSMutableArray*>(self,"_nodes") = finalGrid;
//        });
//    });
}
