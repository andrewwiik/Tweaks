#import <UIKit/UIKit.h>
#import "IBIconHandler.h"
static BOOL needsReload = NO;
static BOOL needsRedo = NO;
static BOOL isStatic = NO;
//static BOOL isHunting = NO;
typedef struct SBIconCoordinate {
	long long row;
	long long col;
} SBIconCoordinate;

@interface SBIconListModel : NSObject
- (BOOL)containsLeafIconWithIdentifier:(id)arg1;
- (unsigned long long)indexForLeafIconWithIdentifier:(id)arg1;
- (id)iconAtIndex:(unsigned long long)arg1 ;
-(void)removeIcon:(id)icon;
@end

@interface SBIcon : NSObject
- (id)applicationBundleID;
- (BOOL)isFolderIcon;
- (id)icon;
@end
@interface SBApplicationIcon : SBIcon
- (id)leafIdentifier;
@end
@interface SBFolderIcon : SBIcon
- (id)nodeDescriptionWithPrefix:(id)arg1;
@end

@interface SBIconImageView : UIView
@end
@interface SBIconView : UIView
@property (nonatomic) BOOL isBlockForm;
+(CGSize)defaultIconImageSize;
+(CGSize)defaultIconSize;
- (SBIcon*)icon;
- (SBIconImageView*)_iconImageView;
- (void)reloadViews;
@end


@interface SBIconListView : UIView
@property (nonatomic, retain) NSMutableArray *replaceIndexes;
@property (nonatomic, retain) NSMutableArray *replaceCoords;
@property (nonatomic, retain) NSMutableArray *replaceCoords1;
@property (nonatomic, retain) NSMutableArray *replaceCoords3;
@property (nonatomic, retain) NSMutableArray *moveNextPage;
@property (nonatomic, retain) NSMutableDictionary *takenCoords;
@property (nonatomic, retain) NSMutableDictionary *widgetLocations;
+ (unsigned long long)maxIcons;
+(unsigned long long)iconColumnsForInterfaceOrientation:(long long)arg1;
+(unsigned long long)iconRowsForInterfaceOrientation:(long long)arg1;
- (id)icons;
- (void)reloadWidgetLocations;
- (void)reloadWidgetLocationForBundleIdentifier:(NSString *)arg1;
- (id)model;
- (BOOL)isFull;
- (SBIconCoordinate)iconCoordinateForIndex:(unsigned long long)arg1 forOrientation:(long long)arg2;
- (SBIconCoordinate)coordinateForIconWithIndex:(unsigned int)index andOriginalCoordinate:(SBIconCoordinate)orig forOrientation:(int)orientation;
- (SBIcon*)modifiedIconForIcon:(SBIcon*)icon;
- (BOOL)containsIcon:(id)arg1;
- (void)setIconsNeedLayout;
- (void)layoutIconsIfNeeded:(double)arg1 domino:(BOOL)arg2;
- (id)insertIcon:(id)arg1 atIndex:(unsigned long long)arg2 moveNow:(_Bool)arg3;
- (unsigned long long)indexForCoordinate:(SBIconCoordinate)arg1 forOrientation:(long long)arg2;
- (NSMutableArray*)testLayout;
- (NSMutableArray*)testLayout1;
- (struct CGPoint)centerForIconCoordinate:(struct SBIconCoordinate)arg1;
- (id)iconAtPoint:(struct CGPoint)arg1 index:(unsigned long long *)arg2;
- (NSMutableArray*)testIndex;
- (id)placeIcon:(id)arg1 atIndex:(unsigned long long)arg2 moveNow:(_Bool)arg3 pop:(_Bool)arg4;
- (NSMutableArray *)takenPlaces;
- (id)insertIcon:(id)arg1 atIndex:(unsigned long long)arg2 moveNow:(_Bool)arg3 pop:(_Bool)arg4;
- (void)setCoordinate:(SBIconCoordinate)coord forBundleIdentifier:(NSString*)bundleIdentifier;
- (SBIconView*)viewForIcon:(id)arg1;

@end


@interface SBIconController : UIViewController
+ (id)sharedInstance;
- (id)model;
- (SBIcon *)grabbedIcon;
- (SBIconListView *)currentRootIconList;
- (void)getListView:(id*)arg1 folder:(id*)arg2 relativePath:(id*)arg3 forIndexPath:(id)arg4 createIfNecessary:(BOOL)arg5;
- (id)insertIcon:(id)icon intoListView:(id)view iconIndex:(int)index moveNow:(BOOL)now pop:(BOOL)pop;
- (id)insertIcon:(id)arg1 intoListView:(id)arg2 iconIndex:(long long)arg3 moveNow:(_Bool)arg4;
@end


@interface SBApplication : NSObject
@property(copy, nonatomic) NSArray *staticShortcutItems;
- (NSString*)bundleIdentifier;
- (id)urlScheme;
@end;
@interface SBApplicationShortcutMenu : UIView
@property(retain, nonatomic) SBApplication *application;
- (id)initWithFrame:(CGRect)arg1 application:(id)arg2 iconView:(id)arg3 interactionProgress:(id)arg4 orientation:(long long)arg5;
- (void)_setupViews;
- (void)_peekWithContentFraction:(double)arg1 smoothedBlurFraction:(double)arg2;
- (void)dismissAnimated:(_Bool)arg1 completionHandler:(id)arg2;
- (id)_shortcutItemsToDisplay;
@end
@interface SBSApplicationShortcutIcon : NSObject
@end
@interface SBSApplicationShortcutItem : NSObject
- (void)setIcon:(id)arg1;
- (void)setLocalizedSubtitle:(id)arg1;
- (void)setLocalizedTitle:(id)arg1;
- (void)setType:(id)arg1;
@end
@interface SBSApplicationShortcutSystemIcon : SBSApplicationShortcutIcon
- (id)initWithType:(UIApplicationShortcutIconType)arg1;
@end

@interface SBIconViewMap : NSObject
+ (id)homescreenMap;
- (id)mappedIconViewForIcon:(id)arg1;
@end

@interface SBRootFolder : NSObject
- (id)indexPathForIcon:(id)arg1;
- (id)listAtIndex:(unsigned long long)arg1;
- (unsigned long long)indexOfList:(id)arg1;
@end
@interface SBPlaceholderIcon : SBIcon
+ (id)emptyPlaceholder;
@end


@interface NSValue (SBIconCoordinate)
+ (NSValue *)valueWithSBIconCoordinate:(SBIconCoordinate)coord;
- (SBIconCoordinate)SBIconCoordinateValue;
@end

@implementation NSValue (SBIconCoordinate)
+ (NSValue *)valueWithSBIconCoordinate:(SBIconCoordinate)coord {
	return [NSValue valueWithCGPoint:CGPointMake((CGFloat)coord.col, (CGFloat)coord.row)];
}
- (SBIconCoordinate)SBIconCoordinateValue {
	SBIconCoordinate coordinate;
    coordinate.row = (long long)self.CGPointValue.y;
    coordinate.col = (long long)self.CGPointValue.x;
    return coordinate;
}
@end
@interface SBHelpPlaceholderIcon : SBPlaceholderIcon
+ (id)newIcon;
@end


// %ctor {
//	@autoreleasepool {
//		[[IBIconHandler sharedHandler] addObject:@"com.apple.MobileSMS"];
//	}
// }

#define BLOCK_SIZE (CGSizeMake(152,162))
#define BLOCK_CORNER (15.0)

SBIconCoordinate SBIconCoordinateMake(long long row, long long col) {
    SBIconCoordinate coordinate;
    coordinate.row = row;
    coordinate.col = col;
    return coordinate;
}
void reloadListViewWithIcon(SBIcon *icon) {
	SBIconController *controller = [NSClassFromString(@"SBIconController") sharedInstance];
	SBRootFolder *rootFolder = [controller valueForKeyPath:@"rootFolder"];
	NSIndexPath *indexPath = [rootFolder indexPathForIcon:icon];
	SBIconListView *listView = nil;
	[controller getListView:&listView folder:NULL relativePath:NULL forIndexPath:indexPath createIfNecessary:YES];
	[listView setIconsNeedLayout];
	[listView layoutIconsIfNeeded:1.0 domino:NO];
}

%hook SBIconView
%new
- (id)testStuff {
	return [%c(SBHelpPlaceholderIcon) newIcon];
}
%property (nonatomic, retain) BOOL isBlockForm;
- (id)initWithContentType:(unsigned long long)arg1 {
	self = %orig;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadViews) name:@"IBIconNeedsLayout" object:nil];

	return self;
}
- (void)layoutSubviews {
	%orig;
	if ([[self.superview class] isEqual:NSClassFromString(@"UIView")]) {
		
	} else {
		[self reloadViews];
	}
}
%new
- (void)reloadViews {
	if ([[self.superview class] isEqual:NSClassFromString(@"SBDockIconListView")] || [[self.superview class] isEqual:NSClassFromString(@"SBFolderIconListView")]) return;
	if ([[IBIconHandler sharedHandler] containsBundleID:self.icon.applicationBundleID]) {
		[self._iconImageView setFrame:CGRectMake(self._iconImageView.frame.origin.x,self._iconImageView.frame.origin.y,BLOCK_SIZE.width,BLOCK_SIZE.height)];
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y,BLOCK_SIZE.width,BLOCK_SIZE.height)];
		if (!self.isBlockForm) {
			self.isBlockForm = YES;
			UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(self._iconImageView.frame.origin.x,self._iconImageView.frame.origin.y,BLOCK_SIZE.width,BLOCK_SIZE.height)];
			viewTemp.tag = 1313;
			viewTemp.layer.cornerRadius = BLOCK_CORNER;
			viewTemp.backgroundColor = [UIColor redColor];
			[self._iconImageView addSubview:viewTemp];
			reloadListViewWithIcon(self.icon);
		}
	} else {
		[self._iconImageView setFrame:CGRectMake(self._iconImageView.frame.origin.x,self._iconImageView.frame.origin.y,[NSClassFromString(@"SBIconView") defaultIconImageSize].width,[NSClassFromString(@"SBIconView") defaultIconImageSize].height)];
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y,[NSClassFromString(@"SBIconView") defaultIconSize].width,[NSClassFromString(@"SBIconView") defaultIconSize].height)];
		if (self.isBlockForm) {
			self.isBlockForm = NO;
			[[self viewWithTag:1313] removeFromSuperview];
			reloadListViewWithIcon(self.icon);
		}
	}
}
%end
static BOOL isFinding = NO;
%hook SBIconListView
%property (nonatomic, retain) NSMutableArray *replaceCoords;
%property (nonatomic, retain) NSMutableArray *replaceCoords1;
%property (nonatomic, retain) NSMutableArray *replaceIndexes;
%property (nonatomic, retain) NSMutableArray *replaceCoords3;
%property (nonatomic, retain) NSMutableDictionary *takenCoords;
%property (nonatomic, retain) NSMutableArray *moveNextPage;
%property (nonatomic, retain) NSMutableDictionary *widgetLocations;
%new
- (NSMutableArray*)testLayout {
	if ([[[IBIconHandler sharedHandler] icons] count] < 1) return nil;
	//SBIconController *controller = [NSClassFromString(@"SBIconController") sharedInstance];
	//SBIconListView *listView = [controller currentRootIconList];
	NSMutableArray *coordinates = [NSMutableArray new];
	for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {
		if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
	    	int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];

	    	isFinding = YES;
	    	SBIconCoordinate widgetCoord = [self iconCoordinateForIndex:a forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
		
			if (!self.widgetLocations) [self reloadWidgetLocations];
	    	NSValue *fixedCoordinate = [self.widgetLocations objectForKey:bundleIdentifier];
	    
	    	if ([[%c(SBIconController) sharedInstance] grabbedIcon]) {
	    		if (![[[[%c(SBIconController) sharedInstance] grabbedIcon] applicationBundleID] isEqualToString:bundleIdentifier]) {
					if (value23) widgetCoord = [value23 SBIconCoordinateValue];
	    		}
	    	else {
		//if (value23) widgetCoord = [value23 SBIconCoordinateValue];
	    	}
	    }
	    else {
			if (value23) widgetCoord = [value23 SBIconCoordinateValue];
	    	}
			[replaceCoords addObject:[NSValue valueWithSBIconCoordinate:widgetCoord]];

	    	SBIconCoordinate topRight = SBIconCoordinateMake(widgetCoord.row, widgetCoord.col + 1);
	    	[replaceCoords addObject:[NSValue valueWithSBIconCoordinate:topRight]];;

	    	SBIconCoordinate bottomLeft = SBIconCoordinateMake(widgetCoord.row +1, widgetCoord.col);
	    	[replaceCoords addObject:[NSValue valueWithSBIconCoordinate:bottomLeft]];

	    	SBIconCoordinate bottomRight = SBIconCoordinateMake(widgetCoord.row+1, widgetCoord.col+1);
	    	[replaceCoords addObject:[NSValue valueWithSBIconCoordinate:bottomRight]];
		}
    }
    if (self.replaceCoords3)
    	[replaceCoords addObjectsFromArray:self.replaceCoords3];

    	NSComparator comparatore = ^NSComparisonResult(id p1d, id p2d) {
		SBIconCoordinate p1 = [(NSValue *)p1d SBIconCoordinateValue];
		SBIconCoordinate p2 = [(NSValue *)p2d SBIconCoordinateValue];
		if (p1.row == p2.row) return p1.col > p2.col;
		return p1.row > p2.row;
	};
    [replaceCoords sortUsingComparator:comparatore];

	// for (id coord in replaceCoords) {
	//	[self insertIcon:[%c(SBPlaceholderIcon) emptyPlaceholder] atIndex:[self indexForCoordinate:[(NSValue*)coord SBIconCoordinateValue] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]] moveNow:YES];
	// }
	if ([replaceCoords count] < 1) return nil;
	return replaceCoords;
}
%new
- (NSMutableArray *)takenPlaces {
	if ([[[IBIconHandler sharedHandler] icons] count] < 1) return nil;
	//SBIconController *controller = [NSClassFromString(@"SBIconController") sharedInstance];
	//SBIconListView *listView = [controller currentRootIconList];
	NSMutableArray *replaceCoords = [NSMutableArray new];
	for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {
	if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
	    int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
	    //SBPlaceholderIcon *place = [%c(SBPlaceholderIcon) emptyPlaceholder];
	    //MSHookIvar<NSString*>(place,"_nodeIdentifier") = [NSString stringWithFormat:@"SUCKIT"];
	    isFinding = YES;
	    SBIconCoordinate widgetCoord = [self iconCoordinateForIndex:a forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
	    SBIconCoordinate proposedCoord = widgetCoord;
			if (proposedCoord.col >= [%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]) {
				int newCol = proposedCoord.col - 1;
				proposedCoord = SBIconCoordinateMake(proposedCoord.row, newCol);
				needsRedo = YES;
			}
			if (proposedCoord.row >= [%c(SBIconListView) iconRowsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]) {
				int newRow = proposedCoord.row - 1;
				proposedCoord = SBIconCoordinateMake(newRow, proposedCoord.col);
				needsRedo = YES;
			}
			
		//[replaceCoords addObject:[NSValue valueWithSBIconCoordinate:widgetCoord]];

	    SBIconCoordinate topRight = SBIconCoordinateMake(widgetCoord.row, widgetCoord.col + 1);
	    [replaceCoords addObject:[NSValue valueWithSBIconCoordinate:topRight]];
	    //[self insertIcon:place atIndex:[self indexForCoordinate:topRight forOrientation:1] moveNow:YES];

	    SBIconCoordinate bottomLeft = SBIconCoordinateMake(widgetCoord.row +1, widgetCoord.col);
	    [replaceCoords addObject:[NSValue valueWithSBIconCoordinate:bottomLeft]];
	    //[self insertIcon:place atIndex:14 moveNow:YES];

	    SBIconCoordinate bottomRight = SBIconCoordinateMake(widgetCoord.row+1, widgetCoord.col+1);
	    [replaceCoords addObject:[NSValue valueWithSBIconCoordinate:bottomRight]];
	    //[self insertIcon:place atIndex:15 moveNow:YES];
	}
    }
    int maxCol = (int)[%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    for (int x = 0; x < [%c(SBIconListView) iconRowsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]; x++) {
	[replaceCoords addObject:[NSValue valueWithSBIconCoordinate:SBIconCoordinateMake((long long)x, (long long)maxCol)]];
    }
    int maxRow = (int)[%c(SBIconListView) iconRowsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    for (int x = 0; x < [%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]; x++) {
	[replaceCoords addObject:[NSValue valueWithSBIconCoordinate:SBIconCoordinateMake((long long)x, (long long)maxRow)]];
    }

    NSComparator comparatore = ^NSComparisonResult(id p1d, id p2d) {
	SBIconCoordinate p1 = [(NSValue *)p1d SBIconCoordinateValue];
	SBIconCoordinate p2 = [(NSValue *)p2d SBIconCoordinateValue];
	if (p1.row == p2.row) return p1.col > p2.col;
	return p1.row > p2.row;
	};
    [replaceCoords sortUsingComparator:comparatore];

	// for (id coord in replaceCoords) {
	//	[self insertIcon:[%c(SBPlaceholderIcon) emptyPlaceholder] atIndex:[self indexForCoordinate:[(NSValue*)coord SBIconCoordinateValue] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]] moveNow:YES];
	// }
	if ([replaceCoords count] < 1) return nil;
	return replaceCoords;
}
%new
- (void)reloadWidgetLocations {
	if (!self.widgetLocations) self.widgetLocations = [NSMutableDictionary new];
	for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {

		if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
			if (![self.widgetLocations objectForKey:bundleIdentifier]) {
		int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
		isFinding = YES;
			SBIconCoordinate widgetCoord = [self iconCoordinateForIndex:a forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
			[self.widgetLocations setObject:[NSValue valueWithSBIconCoordinate:widgetCoord] forKey:bundleIdentifier];
		}
		}
	}
}
%new
- (void)reloadWidgetLocationForBundleIdentifier:(NSString*)bundleIdentifier {
	if (!self.widgetLocations) [self reloadWidgetLocations];
	if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
	    int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
	    isFinding = YES;
		SBIconCoordinate widgetCoord = [self iconCoordinateForIndex:a forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
		[self.widgetLocations setObject:[NSValue valueWithSBIconCoordinate:widgetCoord] forKey:bundleIdentifier];
	}
}
%new
- (void)setCoordinate:(SBIconCoordinate)coord forBundleIdentifier:(NSString *)bundleIdentifier {
	if (!self.widgetLocations) [self reloadWidgetLocations];
	if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
	    //int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
	   // isFinding = YES;
		//SBIconCoordinate widgetCoord = [self iconCoordinateForIndex:a forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
		[self.widgetLocations setObject:[NSValue valueWithSBIconCoordinate:coord] forKey:bundleIdentifier];
	}
}
%new
- (NSMutableArray*)testLayout1 {
	if ([[[IBIconHandler sharedHandler] icons] count] < 1) return nil;
	//SBIconController *controller = [NSClassFromString(@"SBIconController") sharedInstance];
	//SBIconListView *listView = [controller currentRootIconList];
	NSMutableArray *replaceCoords3 = [NSMutableArray new];
	for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {
	if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
	    int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
	    //SBPlaceholderIcon *place = [%c(SBPlaceholderIcon) emptyPlaceholder];
	    //MSHookIvar<NSString*>(place,"_nodeIdentifier") = [NSString stringWithFormat:@"SUCKIT"];
	    isFinding = YES;
	    SBIconCoordinate widgetCoord = [self iconCoordinateForIndex:a forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
	    SBIconCoordinate proposedCoord = widgetCoord;
			if (proposedCoord.col >= [%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]) {
				int newCol = proposedCoord.col - 1;
				proposedCoord = SBIconCoordinateMake(proposedCoord.row, newCol);
				needsRedo = YES;
			}
			if (proposedCoord.row >= [%c(SBIconListView) iconRowsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]) {
				int newRow = proposedCoord.row - 1;
				proposedCoord = SBIconCoordinateMake(newRow, proposedCoord.col);
				needsRedo = YES;
			}
		[replaceCoords3 addObject:[NSValue valueWithSBIconCoordinate:widgetCoord]];
	}
    }
    NSComparator comparatore = ^NSComparisonResult(id p1d, id p2d) {
	SBIconCoordinate p1 = [(NSValue *)p1d SBIconCoordinateValue];
	SBIconCoordinate p2 = [(NSValue *)p2d SBIconCoordinateValue];
	if (p1.row == p2.row) return p1.col > p2.col;
	return p1.row > p2.row;
	};
    [replaceCoords3 sortUsingComparator:comparatore];
    return replaceCoords3;
}
%new
- (NSMutableArray*)testIndex {
	if ([[[IBIconHandler sharedHandler] icons] count] < 1) return nil;
	//SBIconController *controller = [NSClassFromString(@"SBIconController") sharedInstance];
	//SBIconListView *listView = [controller currentRootIconList];
	NSMutableArray *replaceIndexes = [NSMutableArray new];
	for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {
	if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
	    int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
	    [replaceIndexes addObject:[NSNumber numberWithInteger:a]];
	}
    }
    return replaceIndexes;

}
// - (id)insertIcon:(id)arg1 atIndex:(unsigned long long)arg2 moveNow:(_Bool)arg3 pop:(_Bool)arg4 {
// 	if (isStatic) {
// 		isStatic = NO;
// 		return %orig;
// 	}

// 	if ([arg1 isKindOfClass:[%c(SBPlaceholderIcon) class]]) {
// 		isStatic = TRUE;
// 		[self insertIcon:arg1 atIndex:arg2 moveNow:YES pop:NO];
// 		isStatic = TRUE;
// 		[self insertIcon:arg1 atIndex:arg2+1 moveNow:YES pop:NO];
// 		isStatic = TRUE;
// 		[self insertIcon:arg1 atIndex:arg2+[%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] moveNow:YES pop:NO];
// 		isStatic = TRUE;
// 		[self insertIcon:arg1 atIndex:arg2+1+[%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] moveNow:YES pop:NO];
// 		return nil;
// 	}
// 	return %orig;
// }
- (BOOL)isFull {
	int count = 1;
  for (SBIcon *icon in [self icons]) {
      if ([[IBIconHandler sharedHandler] containsBundleID:[icon applicationBundleID]]) {
	  count += 3;
      }
      count++;
  }
  return (count >= [NSClassFromString(@"SBIconListView") maxIcons]);
}
- (unsigned long long)indexForCoordinate:(SBIconCoordinate)arg1 forOrientation:(long long)arg2 {
       // return %orig;
    unsigned int orig = %orig;
    // Alright. We calculate precisely how many widget spaces are before us.
    unsigned int i = 0;

    for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {
	if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
	    int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
	    isFinding=YES;
	    SBIconCoordinate widget = [self iconCoordinateForIndex:a forOrientation:arg2];
	    if (!self.widgetLocations) [self reloadWidgetLocations];
	    NSValue *value23 = [self.widgetLocations objectForKey:bundleIdentifier];
	    if (value23) widget = [value23 SBIconCoordinateValue];

	    // Top right.
	    if ((widget.col+1) == arg1.col && widget.row == arg1.row) {
		NSLog(@"INVALID LOCATION");
		return -1;
	    } else {
		if (widget.row < arg1.row)
		    i++;
		else if ((widget.col+1) < arg1.col && widget.row == arg1.row)
		    i++;
	    }

	    // Bottom left
	    if (widget.col == arg1.col && (widget.row+1) == arg1.row) {
		NSLog(@"INVALID LOCATION");
		return -1;
	    } else {
		if ((widget.row+1) < arg1.row)
		    i++;
		else if (widget.col < arg1.col && (widget.row+1) == arg1.row)
		    i++;
	    }

	    // Bottom right
	    if ((widget.col+1) == arg1.col && (widget.row+1) == arg1.row) {
		NSLog(@"INVALID LOCATION");
		return -1;
	    } else {
		if ((widget.row+1) < arg1.row) {
									i++;
								} else if ((widget.col+1) < arg1.col && (widget.row+1) == arg1.row) {
									i++;
								}
	    }
	}
    }
    orig -= i;
    return orig;
}

- (struct SBIconCoordinate)iconCoordinateForIndex:(unsigned int)arg1 forOrientation:(int)arg2 {
	if (!self.replaceCoords3) self.replaceCoords3 = [NSMutableArray new];
	if (!self.takenCoords) self.takenCoords = [NSMutableDictionary new];
	if (needsRedo) { self.takenCoords = [NSMutableDictionary new];
		//self.replaceCoords3 = [NSMutableArray new];
	}

	//if ([self.replaceCoords3 count] > [%c(SBIconListView) maxIcons]) self.replaceCoords3 = [NSMutableArray new];
	SBIconCoordinate orig = %orig;
	if (isFinding) {
		isFinding = NO;
		return %orig;
	}
    if ([[[IBIconHandler sharedHandler] icons] count] < 1) return orig;


    if (![[self class] isEqual:[objc_getClass("SBDockIconListView") class]] && ![[self class] isEqual:[objc_getClass("SBFolderIconListView") class]]) {
	// Deal with row underneath widget
	if (!self.widgetLocations) [self reloadWidgetLocations];
	if ([self.widgetLocations count] > 0) {
		SBIcon *icon = [[self model] iconAtIndex:arg1];
		NSValue *coordValue = [self.widgetLocations objectForKey:[icon applicationBundleID]];
		if (coordValue) {
			return [coordValue SBIconCoordinateValue];

		}
	}


	if ([self.takenCoords objectForKey:[NSString stringWithFormat:@"%d-%d", arg1, arg2]]) return (SBIconCoordinate)[(NSValue *)[self.takenCoords objectForKey:[NSString stringWithFormat:@"%d-%d", arg1, arg2]] SBIconCoordinateValue];
	self.replaceIndexes = [self testIndex];
       self.replaceCoords1 = [self testLayout1];
	SBIconCoordinate coord = orig;
	if ([self.replaceCoords1 count] > 0) {
		for (NSValue *value in self.replaceCoords1) {
			SBIconCoordinate badCoord = [value SBIconCoordinateValue];
		if (badCoord.row == coord.row && badCoord.col == coord.col) {
			[self.takenCoords setObject:[NSValue valueWithSBIconCoordinate:coord] forKey:[NSString stringWithFormat:@"%d-%d", arg1,arg2]];
			return coord;
		}
		}
	}
	if (!self.replaceCoords) self.replaceCoords = [self testLayout];
	// if (needsRedo == YES) {
		// else self.replaceCoords = [self testLayout];
	//}

	if ([self.replaceCoords count] < 1) return %orig;
	else self.replaceCoords = [self testLayout];
	// if ([self.replaceIndexes containsObject:@(arg1)]) {

	// }
	//if (needsReload) {
		//self.replaceCoords = [self testLayout];
		//needsReload = NO;
	//}
	int newCoord = arg1;
	BOOL replaced;
	for (NSValue *value in self.replaceCoords) {
		SBIconCoordinate badCoord = [value SBIconCoordinateValue];
		while ((badCoord.row == coord.row && badCoord.col == coord.col) || ([self.takenCoords objectForKey:[NSString stringWithFormat:@"%d-%d", newCoord, arg2]])) {
			long long rows = coord.row;
			long long cols = coord.col;
			newCoord+=1;
			cols+=1;
			if (cols > [%c(SBIconListView) iconColumnsForInterfaceOrientation:arg2])  {
				rows+=1;
				cols=1;
			}
			replaced = YES;
			coord = SBIconCoordinateMake(rows,cols);
			//[self.replaceCoords3 addObject:[NSValue valueWithSBIconCoordinate:coord]];
		}
	}
	if (![self.replaceCoords3 containsObject:[NSValue valueWithSBIconCoordinate:coord]])
		[self.replaceCoords3 addObject:[NSValue valueWithSBIconCoordinate:coord]];
	if (coord.row > [%c(SBIconListView) iconRowsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]) {
		if (!self.moveNextPage) self.moveNextPage = [NSMutableArray new];
		[self.moveNextPage addObject:[NSValue valueWithSBIconCoordinate:SBIconCoordinateMake(1,arg1)]];
		
	}
	return coord;

	//NSLog(@"Resultant co-ordinates are row: %lu and column: %lu", (unsigned long)orig.row, (unsigned long)orig.col);
    }
    return orig;
}
- (struct CGPoint)centerForIcon:(id)arg1 {
	CGPoint original = %orig;
	for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {
	if ([bundleIdentifier isEqualToString:[(SBIcon*)arg1 applicationBundleID]]) {
		return CGPointMake(original.x *2, original.y*2);
	}
    }
    return original;
}

- (void)layoutIconsIfNeeded:(double)arg1 domino:(bool)arg2 {
	self.replaceCoords3 = [NSMutableArray new];
	%orig;
	if (self.moveNextPage) {
		if ([self.moveNextPage count] > 4) self.moveNextPage = nil;
	}
	if (self.moveNextPage) {
		NSMutableArray *movingIcons = self.moveNextPage;
		NSComparator comparatore = ^NSComparisonResult(id p1d, id p2d) {
		SBIconCoordinate p1 = [(NSValue *)p1d SBIconCoordinateValue];
		SBIconCoordinate p2 = [(NSValue *)p2d SBIconCoordinateValue];
		if (p1.row == p2.row) return p1.col < p2.col;
		return p1.row > p2.row;
		};
    [movingIcons sortUsingComparator:comparatore];

    SBIconController *controller = [objc_getClass("SBIconController") sharedInstance];
    //SBIconModel *model = [controller model];
    SBRootFolder *rootFolder = [controller valueForKeyPath:@"rootFolder"];
    //int currentListIndex = [rootFolder indexOfList:self];
    //int nextListIndex = currentListIndex+1;
    for (NSValue *value in movingIcons) {
	SBIcon *icon = [[self model] iconAtIndex:[value SBIconCoordinateValue].col];
	NSIndexPath *indexPath = [rootFolder indexPathForIcon:icon];
	SBIconListView *nextListView = nil;
	int dd = 1;
	[controller getListView:&nextListView folder:NULL relativePath:NULL forIndexPath:[NSIndexPath indexPathForRow:1 inSection:[(NSIndexPath*)indexPath section] +dd] createIfNecessary:YES];
	while ([nextListView isFull]) {
		dd+=1;
		[controller getListView:&nextListView folder:NULL relativePath:NULL forIndexPath:[NSIndexPath indexPathForRow:1 inSection:[(NSIndexPath*)indexPath section] +dd] createIfNecessary:YES];
	}
	[[self model] removeIcon:icon];
	[nextListView insertIcon:icon atIndex:0 moveNow:YES pop:YES];
	[nextListView setIconsNeedLayout];
	[nextListView layoutIconsIfNeeded:0.0 domino:NO];
	//int currentListIndex = [rootFolder indexOfList]

	//[(SBIconListView)[rootFolder listAtIndex:nextListIndex] insertIcon:icon atIndex:0 moveNow:YES pop:YES];
    }
    self.moveNextPage = nil;
	}
}
%end



%hook SBApplicationShortcutStoreManager
- (id)shortcutItemsForBundleIdentifier:(NSString*)arg1 {
		NSArray *aryItems = [NSArray new];
		if (%orig != NULL || %orig != nil) {
			aryItems = %orig;
		}
		NSMutableArray *aryShortcuts = [aryItems mutableCopy];

    SBSApplicationShortcutItem *newAction = [[NSClassFromString(@"SBSApplicationShortcutItem") alloc] init];
		SBSApplicationShortcutSystemIcon *icon = [NSClassFromString(@"SBSApplicationShortcutSystemIcon") alloc];
    [newAction setIcon:[icon initWithType:UIApplicationShortcutIconTypeHome]];
		[newAction setLocalizedTitle:@"\"iOS Block\""];
		if ([[[IBIconHandler sharedHandler] icons] containsObject:arg1]) {
	    [newAction setLocalizedSubtitle:@"Make me a Icon"];
		} else {
			[newAction setLocalizedSubtitle:@"Make me a Block"];
		}
    [newAction setType:[NSString stringWithFormat:@"%@*_*iOSBlockMe",arg1]];
    [aryShortcuts addObject:newAction];

		return aryShortcuts;
}
%end
%hook SBApplicationShortcutMenu
- (void)menuContentView:(id)arg1 activateShortcutItem:(UIApplicationShortcutItem*)arg2 index:(long long)arg3 {
	NSString *input = arg2.type;

	if ([input containsString:@"*_*"]) {
		NSArray *arySplitString = [input componentsSeparatedByString:@"*_*"];
		NSString *bundleID = [arySplitString objectAtIndex:0];
		[self dismissAnimated:YES completionHandler:nil];

		if ([[IBIconHandler sharedHandler] containsBundleID:bundleID]) {
			[[IBIconHandler sharedHandler] removeObject:bundleID];
		} else {
			[[IBIconHandler sharedHandler] addObject:bundleID];
			needsReload = YES;
			needsRedo = YES;
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:@"IBIconNeedsLayout" object:nil];
  } else {
		%orig;
	}
}
%end


%hook SBIconController
// -(void)_dropIcon:(id)icon withInsertionPath:(id)insertionPath {
// %orig;
// // return;
// 	for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {
// 		if ([[icon applicationBundleID] isEqualToString:bundleIdentifier]) {
// 			SBIconListView *listView;
// 			[[objc_getClass("SBIconController") sharedInstance] getListView:&listView folder:nil relativePath:nil forIndexPath:insertionPath createIfNecessary:YES];
// 			[listView reloadWidgetLocationForBundleIdentifier:bundleIdentifier];
// 			// [[objc_getClass("SBIconController") sharedInstance] getListView:&listView folder:nil relativePath:nil forIndexPath:insertionPath createIfNecessary:YES];
// 			// [listView.widgetLocations removeObjectForKey:bundleIdentifier];
// 			// %orig;
// 			// isFinding = YES;
// 			// SBIconCoordinate newCoord = [listView iconCoordinateForIndex:(int)[insertionPath indexAtPosition:[insertionPath length] - 1] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
// 			// [listView setCoordinate:newCoord forBundleIdentifier:bundleIdentifier];
// 			// id obj1 = [self insertIcon:icon intoListView:listView iconIndex:(int)[insertionPath indexAtPosition:[insertionPath length] - 1] moveNow:YES pop:NO];
// 			// NSLog(@"%@", obj1);
// 			return;
// 		}
// 	}
// 	%orig;
// }
//			SBIconListView *listView;
//			[[objc_getClass("SBIconController") sharedInstance] getListView:&listView folder:nil relativePath:nil forIndexPath:insertionPath createIfNecessary:YES];
//			 isFinding = YES;
//			 SBIconCoordinate proposedCoord = [listView iconCoordinateForIndex:(int)[insertionPath indexAtPosition:[insertionPath length] - 1] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
//			if (proposedCoord.col >= [%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]) {
//				int newCol = proposedCoord.col - 1;
//				proposedCoord = SBIconCoordinateMake(proposedCoord.row, newCol);
//				needsRedo = YES;
//			}
//			if (proposedCoord.row >= [%c(SBIconListView) iconRowsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]) {
//				int newRow = proposedCoord.row - 1;
//				proposedCoord = SBIconCoordinateMake(newRow, proposedCoord.col);
//				needsRedo = YES;
//			}

//			// for (NSValue *value in [listView takenPlaces]) {
//			//	SBIconCoordinate badCoord = [value SBIconCoordinateValue];
//			//	while (badCoord.row == proposedCoord.row && badCoord.col == proposedCoord.row) {
//			//		long long rows = proposedCoord.row;
//   // 			long long cols = proposedCoord.col;
//   // 			cols+=1;
//   // 			if (cols > [%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]])  {
//   // 				rows+=1;
//   // 				cols=1;
//   // 			}
//   // 			proposedCoord = SBIconCoordinateMake(rows,cols);
//			//	}
//			// }
//			 //isHunting = YES;
//			 int finalIndex = [listView indexForCoordinate:proposedCoord forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
//			insertionPath = [NSIndexPath indexPathForRow:finalIndex inSection:[(NSIndexPath*)insertionPath section]];
//			break;
//		}
//	}

//	%orig(icon,insertionPath);
//	NSLog(@"INSERT PATH: %@", insertionPath);
	

//	needsReload = YES;
//	//needsRedo = YES;
// }
-(BOOL)icon:(id)icon canReceiveGrabbedIcon:(id)icon2 {
	for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {
		if ([[[(SBIconView*)icon2 icon] applicationBundleID] isEqualToString:bundleIdentifier] || [[[(SBIconView*)icon icon] applicationBundleID] isEqualToString:bundleIdentifier]) {
			return NO;
		}
	}
	return %orig;
}


- (BOOL)folderController:(id)controller draggedIconDidPauseAtLocation:(CGPoint)draggedIcon inListView:(id)listView {
	needsReload = YES;
	NSLog(@"CONTROLLER: %@", controller);
	
	BOOL butt = %orig;
	unsigned long long arg2;
	
	SBIcon *icon = [listView iconAtPoint:draggedIcon index:&arg2];
	if (icon) {
		if ([self grabbedIcon]) {
		if ([[IBIconHandler sharedHandler] containsBundleID:[[self grabbedIcon] applicationBundleID]]) {
	
		//isStatic = TRUE;
 		//[listView insertIcon:arg1 atIndex:arg2 moveNow:YES pop:NO];
 		isStatic = TRUE;
 		[listView insertIcon:[%c(SBPlaceholderIcon) emptyPlaceholder] atIndex:arg2+1 moveNow:YES pop:YES];
 		isStatic = TRUE;
 		[listView insertIcon:[%c(SBPlaceholderIcon) emptyPlaceholder] atIndex:arg2+[%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] moveNow:YES pop:YES];
		isStatic = TRUE;
		[listView insertIcon:[%c(SBPlaceholderIcon) emptyPlaceholder] atIndex:arg2+1+[%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] moveNow:YES pop:YES];
		NSLog(@"IT WORKED");
	}
	}
}
	//needsRedo = YES;
	return butt;
}
%end

%hook SBPlaceholderIcon
-(id)representation {
	if (!%orig) {
		return [%c(SBPlaceholderIcon) emptyPlaceholder];
	}
	else return %orig;
}
%end