#define isNSNull(value) [value isKindOfClass:[NSNull class]]

@interface SBIconIndexMutableList (Curago)
@property (nonatomic, retain) SBIconListView *listView;
- (void)moveToNextPage:(id)icon;
@end

%hook SBIconIndexMutableList

// Add a property to keep the |SBIconListView| object pertaining to
// this |SBIconIndexMutableList| cached so it doesn't need to be 
// found every single time we need it in our calculations to determine
// where icons should get placed if there is any "Blocks" that are
// expanded on the |SBIconListView| pertaining to this |SBIconIndexMutableList|
// instance.

%property (nonatomic, retain) SBIconListView *listView;


- (void)node:(id)node didRemoveContainedNodeIdentifiers:(id)identifiers {

    // Perform the original implementation of this method.

    %orig;

    // If the |SBIconListView| object pertaining to this |SBIconIndexMutableList|
    // reference is not cached.

    if (!self.listView) {

        // No point in grabbing the |SBIconListView| if there aren't any |SBIcon|(s).
        // This also prevents a "Out of Bounds" Exception from occurring.

        if ([[self nodes] count] > 0) { 

            // Grab the |NSIndexPath| for the first |SBIcon| in this |SBIconIndexMutableList|. 
            // The index path consists of two numbers, the first being the index of the |SBIconListView| 
            // page where the |SBIcon| is located and the second number being the index of the 
            // actual |SBIcon|in reference to the rest of the |SBIcon|(s) on the |SBIconListView|.



            NSIndexPath *iconIndexPath = [(SBRootFolder *)[[NSClassFromString(@"SBIconController") sharedInstance] valueForKeyPath:@"rootFolder"] indexPathForIcon:[[self nodes] objectAtIndex:0]];

            // Use the |NSIndexPath| that we grabbed for the first |SBIcon| in this |SBIconIndexMutableList|
            // to grab the |SBIconListView| pertaining to this |SBIconIndexMutableList| and cache it to the
            // [listView] property on this |SBIconIndexMutableList| instance.

            if ([[NSClassFromString(@"SBIconController") sharedInstance] respondsToSelector:@selector(getListView:folder:relativePath:forIndexPath:createIfNecessary)]) {

                [[NSClassFromString(@"SBIconController") sharedInstance] getListView:&self.listView folder:NULL relativePath:NULL forIndexPath:iconIndexPath createIfNecessary:NO];
            } else {
                return;
            }
        }
    }

    // The rest of the icon displacement calculations are performed on a
    // background thread to prevent the UI from locking up and to prevent frames
    // from being dropped.

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        // If an instance of |SBIconListView| exists on the [listView] property of
        // this |SBIconIndexMutableList| instance

        if (self.listView) {

            // Grab the current |UIInterfaceOrientation| so it can be used later on.

            UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];

            // We need to copy the |NSMutableArray| that contains all of the |SBIcon| instances 
            // which can found on the instance Variable [_nodes] on this |SBIconIndexMutableList| instance.
            // If a separate copy wasn't made the future operations below wouldn't be thread safe and
            // it becomes a possibility that SpringBoard could crash quite easily.

            NSMutableArray *nodes = [(NSMutableArray *)[self objectForKey:@"_nodes"] mutableCopy];
            NSMutableArray *unfinishedNodes = [nodes mutableCopy];
            NSMutableArray *nextPage = [NSMutableArray new];
            
            // We need to know the number of rows and columns the |SBIconListView| instance
            // on the [listView] property of this |SBIconIndexMutableList| can hold for the 
            // device's current orientation in order to use the information later in this 
            // method implementation for calculations.

            int maxNumberOfColumns = 0;
            int maxNumberOfRows = 0;

            if ([self.listView respondsToSelector:@selector(iconColumnsForCurrentOrientation)] {
                maxNumberOfColumns = [self.listView iconColumnsForCurrentOrientation];

                if ([self.listView respondsToSelector:@selector(iconRowsForCurrentOrientation)]) {
                    maxNumberOfRows = [self.listView iconRowsForCurrentOrientation];
                }
            }

            if (maxNumberOfColumns == 0 || maxNumberOfRows == 0) return;

            // Now we need to make a 2D array to store the icon Layout that is
            // calculated. The 2D |NSMutableArray| also needs to be filled with |NSNull|(s)
            // so that Objects can be set anywhere in the 2D array. The max rows
            // and columns that were grabbed above will be used to fix the 2D array
            // to the correct size

            id grid[maxNumberOfRows][maxNumberOfColumns];

            for (int r = 0; r < maxNumberOfRows; r++) {
                for (int c = 0; c < maxNumberOfColumns; c++) {
                    grid[r][c] = [NSNull null];
                }
            }

            // Now the 2D array needs to be populated with the |SBIcon|(s), while accounting
            // for any |SBIcon|(s) that expanded into "Block" form. If a |SBIcon| is expanded
            // into "Block" form the rest of spaces in the grid that it consumes will be filled
            // with a pseudo placeholder icon |SBWDXPlaceholderIcon| which is a subclass of |SBIcon|
            // in order to keep the icons laid out properly on the |SBIconListView|. First all the
            // |SBIcon|(s) need to be looped over to check if any of them are expanded into "Block" form because
            // if a |SBIcon| is expanded into block form it has a higher priority of placement in the grid

            for (id icon in nodes) {

                // Every |SBIcon| or subclasses of it have the method "applicationBundleID"
                // that returns a |NSString| containing the unique identifier for that |SBIcon|.
                // We should always make sure of course that the object the method is being performed
                // on can actually respond to the message first. A class called |IBKResources| has the
                // selector "indexForBundleID:" that will return the saved index of any |SBIcon| that 
                // is expanded into "Block" form. The method consumes the |SBIcon|'s unique identifier
                // as a |NSString| and returns a [int] for its corresponding index if one exists. If a
                // corresponding index does not exist it will return 'nil'.

                if ([icon respondsToSelector:@selector(applicationBundleID:)]) {

                    if ([IBKResources indexForBundleID:[(SBIcon *)icon applicationBundleID]]) {

                        NSString *iconIdentifier = [(SBIcon *)icon applicationBundleID]

                        int index = [IBKResources indexForBundleID:iconIdentifier];

                        // The index needs to be converted to |SBIconCoordinate| which is a struct that has
                        // a row and column field. the row field starts a 1 and the column field starts at 1.
                        // An function called "SBIconCoordinateMake" takes in a row and column both of type 
                        // |long long| in that order and returns a |SBIconCoordinate|. The |SBIconListView|
                        // instance that is cached has the selector "iconCoordinateForIndex:forOrientation:" that
                        // consumes the index that needs to be converted to a |SBIconCoordinate| and the orientation
                        // that the |SBIconCoordinate| should be in reference to.

                        SBIconCoordinate coord;
                        SBIconCoordinate origCoord;

                        if ([self.listView respondsToSelector:@selector(iconCoordinateForIndex:forOrientation)]) {
                            coord = [self.listView iconCoordinateForIndex:index forOrientation:currentOrientation];
                            origCoord = coord;
                        } else {
                            return;
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

                        
                        // Now the |SBIconCoordinate| value for the index, the "blockWidth", and "blockHeight" need
                        // to be used to calculate where the block can go on the grid. If it cannot fit on the current
                        // grid it will be sent to the selector called "moveToNextPage:" on this instance of 
                        // |SBIconIndexMutableList| which takes a |SBIcon| and moves it to the next |SBIconListView| 
                        // on SpringBoard. The "grid" 2D array is used to place the |SBIcon|(s) in their positions and to
                        // note which spaces are already taken in the icon layout.

                        BOOL breakOuter = NO;

                        while (!breakOuter) {

                            int lastRow = maxNumberOfRows - blockHeight + 1;
                            int lastCol = maxNumberOfRows - blockWidth + 1;

                            for (int r = coord.row; r < lastRow; r++) {

                                lastCol = maxNumberOfRows - blockWidth + 1

                                int c = 1;

                                if (r == coord.row) {
                                    c = coord.col;
                                }

                                for (; c < lastCol; c++) {

                                    BOOL isValid = YES;
                                    shouldBreak = NO;

                                    while (isValid && !shouldBreak) {
                                        for (int h = 0; h < blockHeight; h++) {


                                            int row = h + coord.row;

                                            if (row > maxNumberOfRows) // If the row exceeds the max number of rows
                                                break;

                                            for (int w = 0; w < blockWidth; w++) {

                                                int col = w + coord.col;
                                                if (col > maxNumberOfColumns)
                                                    break;

                                                if (!isNSNull(grid[row][col])) {
                                                    isValid = NO;
                                                }
                                            }
                                        }
                                        shouldBreak = YES;
                                    }

                                    if (isValid && shouldBreak) {
                                        for (NSInteger h = 0; h < blockHeight; h++) {
                                            for (NSInteger w = 0; w < blockWidth; w++) {
                                                if (h == 0 && w == 0) {
                                                    grid[coord.row][coord.col] = icon;
                                                }
                                                else {
                                                    grid[h + coord.col][w + coord.col] = [[NSClassFromString(@"SBWDXPlaceholderIcon") alloc] initWithIdentifier:[NSString stringWithFormat:@"WIDUXPlaceHolder_%ld/%@", (long)(h + w), iconIdentifier]];
                                                }
                                            }
                                        }

                                        if (coord != origCoord) {
                                            int newIndex = [self.listView indexForCoordinate:coord forOrientation:currentOrientation];
                                            [IBKResources setIndex: newIndex forBundleID:iconIdentifier];
                                        }
                                        [unfinishedNodes removeObject:icon];
                                        breakOuter = YES;
                                    }
                                    coord.col = c;
                                }
                                coord.row = r;
                            }
                            [unfinishedNodes removeObject:icon];
                            [nextPage addObject:icon];
                        }
                    }
                    else if ([icon isKindOfClass:NSClassFromString(SBWDXPlaceholderIcon)]) {
                        [unfinishedNodes removeObject:icon];
                    }
                }
            }

            NSMutableArray leftOverIcons = [unfinishedNodes mutableCopy];
            int count = 0;
            int remainingIcons = [unfinishedNodes count];
            BOOL shouldContinue = YES;
            while (shouldContinue) {
                for (int r = 0; r < maxNumberOfRows; r++) {
                    for (int c = 0; < maxNumberOfColumns; c++) {
                        if (isNSNull(grid[r][c])) {
                            if (count < remainingIcons - 1) {
                                grid[r][c] = [unfinishedNodes objectAtIndex:count];
                                [leftOverIcons removeObject:grid[r][c]];
                                count++;
                            }
                            else {
                                shouldContinue = NO;
                            }
                        }
                    }
                }
            }

            NSMutableArray *finalGrid = [NSMutableArray new];

            for (int r = 0; r < maxNumberOfRows; r++) {
                for (int c = 0; < maxNumberOfColumns; c++) {
                    if (!isNSNull(grid[r][c])) {
                        [finalGrid addObject:grid[r][c]];
                    }
                }
            }
        } else {
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            MSHookIvar<NSMutableArray*>(self,"_nodes") = finalGrid;
        });
    });
}

-(void)node:(id)node didAddContainedNodeIdentifiers:(id)identifiers {
    %orig;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        //Do EXTREME PROCESSING!!!
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"I didn't block the queue.");
        });
    });
}
%end