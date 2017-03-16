#import <UIKit/UIKit.h>
#import "IBIconHandler.h"
#import "headers.h"
//static BOOL isHunting = NO;
// static BOOL coordinateForIndexOriginal = FALSE;
static BOOL isDropping = NO;
// static BOOL isRegular = NO;
// static BOOL isPausing = NO;
static unsigned long long previousPauseIndex = -1;

#define BLOCK_SIZE (CGSizeMake(152,162))
#define BLOCK_CORNER (15.0)
#import "headers.h"


SBIconCoordinate SBIconCoordinateMake(long long row, long long col) {
    SBIconCoordinate coordinate;
    coordinate.row = row;
    coordinate.col = col;
    return coordinate;
}

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

@interface NSMutableDictionary (Blocks)
- (NSArray*)allObjects;
@end


@interface MPUNowPlayingController : NSObject
- (void)_updateCurrentNowPlaying;
- (UIImage*)currentNowPlayingArtwork;
- (void)setShouldUpdateNowPlayingArtwork:(BOOL)arg1;
- (NSMutableDictionary*)currentNowPlayingInfo;
@end

@class CAFilter;
@interface CAFilter : NSObject
+(instancetype)filterWithName:(NSString *)name;
@end

@interface UIImage (Resize)
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (UIImage *)drawImage:(UIImage *)inputImage inRect:(CGRect)frame;
@end
@implementation UIImage (Resize)
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();	
    UIGraphicsEndImageContext();
    return newImage;
}
- (UIImage *)drawImage:(UIImage *)inputImage inRect:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    [self drawInRect:CGRectMake(0.0, 0.0, self.size.width, self.size.height)];
    [inputImage drawInRect:frame];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

void reloadListViewWithIcon(SBIcon *icon) {
	SBIconController *controller = [NSClassFromString(@"SBIconController") sharedInstance];
	SBRootFolder *rootFolder = [controller valueForKeyPath:@"rootFolder"];
	NSIndexPath *indexPath = [rootFolder indexPathForIcon:icon];
	SBIconListView *listView = nil;
	[controller getListView:&listView folder:NULL relativePath:NULL forIndexPath:indexPath createIfNecessary:YES];
	unsigned long long index = [(SBIconListModel*)[listView model] indexForLeafIconWithIdentifier:[icon applicationBundleID]];
	int i = 0;
	// for (int t = index; t >= 0; t--) {
	// 	if (t < [[listView icons] count]) {
	// 		if ([[(SBIconListModel *)[listView model] iconAtIndex:t] isKindOfClass:[%c(SBWDXPlaceholderIcon) class]])
	// 			i++;
	// 	}
	// }
	[[IBIconHandler sharedHandler] setIndex:index - i forBundleID:[icon applicationBundleID]];
	// [listView reloadCustomWidgetCoordinates];
	[listView setIconsNeedLayout];
	[listView layoutIconsIfNeeded:1.0 domino:NO];
}

%hook SBIconView
%property (nonatomic, retain) BOOL isBlockForm;
%property (nonatomic, retain) MPUNowPlayingController *playController;
%property (nonatomic, retain) UILabel *songLabel;
%property (nonatomic, retain) UILabel *artistLabel;

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
	// if ([[[self icon] applicationBundleID] isEqualToString:@"com.apple.Music"]) {

	// 			//self.clipsToBounds = YES;
	// 			if (!self.playController)
	// 			self.playController = [[%c(MPUNowPlayingController) alloc] init];
	// 			[self.playController setShouldUpdateNowPlayingArtwork:YES];
	// 			[self.playController _updateCurrentNowPlaying];
	// }
}

%new
- (void)reloadViews {

	if ([[self.superview class] isEqual:NSClassFromString(@"SBDockIconListView")] || [[self.superview class] isEqual:NSClassFromString(@"SBFolderIconListView")]) return;

	if ([[IBIconHandler sharedHandler] containsBundleID:self.icon.applicationBundleID]) {

		SBIconListView *listView = [[[%c(SBIconController) sharedInstance] _rootFolderController] iconListViewContainingIcon:self.icon];
		int horizontalSize = [[IBIconHandler sharedHandler] horiztonalWidgetSizeForBundleID:self.icon.applicationBundleID];
		int verticalSize = [[IBIconHandler sharedHandler] verticalWidgetSizeForBundleID:self.icon.applicationBundleID];
		CGFloat blockWidth = ([%c(SBIconView) defaultIconSize].width * horizontalSize) + ([listView horizontalIconPadding] * (horizontalSize - 1));
		CGFloat blockHeight = ([%c(SBIconView) defaultIconSize].height * verticalSize) + ([listView verticalIconPadding] * (verticalSize - 1));

		[self._iconImageView setFrame:CGRectMake(self._iconImageView.frame.origin.x,self._iconImageView.frame.origin.y,blockWidth,blockHeight)];
		[self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y,blockWidth,blockHeight)];
		if (!self.isBlockForm) {

			self.isBlockForm = YES;
			UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(self._iconImageView.frame.origin.x,self._iconImageView.frame.origin.y,blockWidth,blockHeight)];
			viewTemp.tag = 1313;
			viewTemp.layer.cornerRadius = BLOCK_CORNER;
			viewTemp.backgroundColor = [UIColor clearColor];
			[self addSubview:viewTemp];
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

%hook SBIconListView

- (void)layoutIconsIfNeeded:(double)arg1 domino:(bool)arg2 {
	if (isDropping) {
		isDropping = NO;
		%orig(0.0,NO);
	}
	else {
		%orig;
	}
}

// %property (nonatomic, retain) NSMutableArray *fullWidgetCoordinates;
// %property (nonatomic, retain) NSMutableDictionary *primaryWidgetCoordinates;
// %property (nonatomic, retain) NSMutableDictionary *takenIconCoordinates;

// %new
// - (void)reloadCustomWidgetCoordinates {
// 	NSMutableArray *fullWidgetCoordinates = [NSMutableArray new];
// 	if (!self.primaryWidgetCoordinates) self.primaryWidgetCoordinates = [NSMutableDictionary new];
// 	for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {
// 		if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
// 			// BOOL isBeingDragged = NO;
// 			// if ([[%c(SBIconController) sharedInstance] grabbedIcon]) {
// 			//	if ([[[[%c(SBIconController) sharedInstance] grabbedIcon] applicationBundleID] isEqualToString:bundleIdentifier]) {
// 			//		isBeingDragged = YES;
// 			//		 int w = previousPauseIndex;
// 			//		 coordinateForIndexOriginal = TRUE;
// 			//		 SBIconCoordinate grabbedCoordinate = [self iconCoordinateForIndex:w forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
// 			//		 [self.primaryWidgetCoordinates setObject:[NSValue valueWithSBIconCoordinate:grabbedCoordinate] forKey:bundleIdentifier];
					

// 			//	}
// 			// }
// 			//if (!isBeingDragged) {
// 				isRegular = YES;
// 		int primaryWidgetIndex = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
// 		if ([self.primaryWidgetCoordinates objectForKey:bundleIdentifier]) {
// 			primaryWidgetIndex = (int)[self indexForCoordinate:[(NSValue *)[self.primaryWidgetCoordinates objectForKey:bundleIdentifier] SBIconCoordinateValue] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
// 		}
// 		for (int y = 0; y < [[IBIconHandler sharedHandler] verticalWidgetSizeForBundleID:bundleIdentifier]; y++) {
// 				for (int x = 0; x < [[IBIconHandler sharedHandler] horiztonalWidgetSizeForBundleID:bundleIdentifier]; x++) {
					
// 					unsigned long long index = primaryWidgetIndex+([%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] * y)+x;
// 					if (primaryWidgetIndex == index) {
// 						// if (!isBeingDragged) {
// 						coordinateForIndexOriginal = TRUE;
// 						SBIconCoordinate indexCoordinate = [self iconCoordinateForIndex:index forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
// 						if (![self.primaryWidgetCoordinates objectForKey:bundleIdentifier])
// 						[self.primaryWidgetCoordinates setObject:[NSValue valueWithSBIconCoordinate:indexCoordinate] forKey:bundleIdentifier];
// 						[fullWidgetCoordinates addObject:[NSValue valueWithSBIconCoordinate:indexCoordinate]];
// 						}
// 					else {
// 						coordinateForIndexOriginal = TRUE;
// 						SBIconCoordinate indexCoordinate = [self iconCoordinateForIndex:index forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
// 						[fullWidgetCoordinates addObject:[NSValue valueWithSBIconCoordinate:indexCoordinate]];
// 						[self.takenIconCoordinates setObject:[NSValue valueWithSBIconCoordinate:indexCoordinate] forKey:[NSString stringWithFormat:@"%d-%d", (int)index, (int)(long)[[UIApplication sharedApplication] statusBarOrientation]]];
// 					}
// 				}
// 			}
// 		}
// 	}
// 	if (self.takenIconCoordinates) {
// 		[fullWidgetCoordinates addObjectsFromArray:[self.takenIconCoordinates allObjects]];
// 	}
// 	NSComparator iconCoordinatesComparator = ^NSComparisonResult(id icon, id otherIcon) {
// 		SBIconCoordinate iconCoordinate = [(NSValue *)icon SBIconCoordinateValue];
// 		SBIconCoordinate otherIconCoordinate = [(NSValue *)otherIcon SBIconCoordinateValue];
// 		if (iconCoordinate.row == otherIconCoordinate.row) return iconCoordinate.col > otherIconCoordinate.col;
// 		return iconCoordinate.row > otherIconCoordinate.row;
// 	};
//     [fullWidgetCoordinates sortUsingComparator:iconCoordinatesComparator];

//     self.fullWidgetCoordinates = fullWidgetCoordinates;
// }

// %new
// - (unsigned long long)indexAdditionNeededForCoordinate:(SBIconCoordinate)arg1 forOrientation:(long long)arg2 {
// 	unsigned int i = 0;



//     for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {
// 		if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
// 			int primaryWidgetIndex = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
// 			for (int y = 0; y < [[IBIconHandler sharedHandler] verticalWidgetSizeForBundleID:bundleIdentifier]; y++) {
// 					for (int x = 0; x < [[IBIconHandler sharedHandler] horiztonalWidgetSizeForBundleID:bundleIdentifier]; x++) {
// 						unsigned long long index = primaryWidgetIndex+([%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] * y)+x;
// 						coordinateForIndexOriginal = YES;
// 						SBIconCoordinate widget = [self iconCoordinateForIndex:index forOrientation:arg2];
// 						if ((y == 0) && (x == 0)) {

// 						}
// 						else if ((widget.row < arg1.row) || ((widget.row == arg1.row) && (widget.col < arg1.col)))
// 						i++;
// 						else if ((widget.row == arg1.row) && (widget.col == arg1.col)) return -1;
// 				}
// 			}
// 		}
// 	}
// 	return (unsigned long long)i;
// }

 - (unsigned long long)indexForCoordinate:(SBIconCoordinate)arg1 forOrientation:(long long)arg2 {
 	unsigned long long orig = %orig;
 	NSString *logString = [NSString stringWithFormat:@"INDEX FOR COORDINATE: row: %llu col: %llu RETURNED INDEX: %llu", arg1.row,arg1.col, orig];
 	NSLog(@"%@",logString);
 	return orig;
}
%end
//     unsigned int orig = %orig;
//     if (isRegular) {
// 	isRegular = NO;
// 	return orig;
//     }
//     unsigned int i = 0;



//     for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {
// 		if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
// 			if ([[%c(SBIconController) sharedInstance] grabbedIcon]) {
// 				if ([[[[%c(SBIconController) sharedInstance] grabbedIcon] applicationBundleID] isEqualToString:bundleIdentifier]) {
// 					continue;
// 				}
// 			}

// 			int primaryWidgetIndex = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
// 			for (int y = 0; y < [[IBIconHandler sharedHandler] verticalWidgetSizeForBundleID:bundleIdentifier]; y++) {
// 					for (int x = 0; x < [[IBIconHandler sharedHandler] horiztonalWidgetSizeForBundleID:bundleIdentifier]; x++) {
// 						unsigned long long index = primaryWidgetIndex+([%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] * y)+x;
// 						coordinateForIndexOriginal = YES;
// 						SBIconCoordinate widget = [self iconCoordinateForIndex:index forOrientation:arg2];
// 						if ((y == 0) && (x == 0)) {

// 						}
// 						else if ((widget.row < arg1.row) || ((widget.row == arg1.row) && (widget.col < arg1.col)))
// 						i++;
// 						else if ((widget.row == arg1.row) && (widget.col == arg1.col)) return -1;
// 				}
// 			}
// 		}
// 	}
//     //orig -= i;
//    // NSLog(@"ICON ROW: %i \n ICON COL: %i \n ICON INDEX: %i", (int)arg1.row, (int)arg1.col, (int)orig);
//     for (NSString *bundleIdentifier in [[IBIconHandler sharedHandler] icons]) {
// 		if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
// 			if ([[%c(SBIconController) sharedInstance] grabbedIcon]) {
// 				if ([[[[%c(SBIconController) sharedInstance] grabbedIcon] applicationBundleID] isEqualToString:bundleIdentifier]) {
// 					NSLog(@"WIDGET HOLD -- ICON ROW: %i \n ICON COL: %i \n ICON INDEX: %i", (int)arg1.row, (int)arg1.col, (int)orig);
// 					return orig+i;
// 				}
// 			}
// 		}
// 	}
// 	NSLog(@"ICON ROW: %i \n ICON COL: %i \n ICON INDEX: %i", (int)arg1.row, (int)arg1.col, (int)orig-i);
// 	if (isPausing) return orig-i;
//     return orig -1;
// }



// - (struct SBIconCoordinate)iconCoordinateForIndex:(unsigned int)arg1 forOrientation:(int)arg2 {
// 	SBIconCoordinate orig = %orig;
// 	if (![[self class] isEqual:[objc_getClass("SBDockIconListView") class]] && ![[self class] isEqual:[objc_getClass("SBFolderIconListView") class]]) {
// 	SBIcon *icon = [[self model] iconAtIndex:arg1];
// 	if ([icon isKindOfClass:NSClassFromString(@"SBPlaceholderIcon")]) NSLog(@"CURRENT CALC IS FOR PLACEHOLDER ICON AT INDEX: di")
// 	if (self.primaryWidgetCoordinates) {
// 	NSValue *coordValue = [self.primaryWidgetCoordinates objectForKey:[icon applicationBundleID]];
// 	if (coordValue) {
// 		if ([[IBIconHandler sharedHandler] containsBundleID:[icon applicationBundleID]]) {
// 		// [self.takenIconCoordinates setObject:coordValue forKey:[NSString stringWithFormat:@"%d-%d", arg1, arg2]];
// 		return [coordValue SBIconCoordinateValue];
// 	}

// 	}
// }
// 	if (coordinateForIndexOriginal) {
// 		coordinateForIndexOriginal = FALSE;
// 		return orig;
// 	}

// 	if ([[[IBIconHandler sharedHandler] icons] count] < 1) return orig;

// 	if (!(self.fullWidgetCoordinates) || !(self.primaryWidgetCoordinates)) [self reloadCustomWidgetCoordinates]; // If we don't have widget coordinates calculated;

// 	SBIconCoordinate coord = orig;
// 	// int index33 = [self indexForCoordinate:orig forOrientation:arg2];
// 	// coordinateForIndexOriginal = TRUE;
// 	// return [self iconCoordinateForIndex:index33 forOrientation:arg2];
// 	int newIndex = arg1;
// 	// [self reloadCustomWidgetCoordinates];
// 	for (NSValue *value in self.fullWidgetCoordinates) {
// 		SBIconCoordinate badCoord = [value SBIconCoordinateValue];
// 		while ((badCoord.row == coord.row && badCoord.col == coord.col) || ([self.takenIconCoordinates objectForKey:[NSString stringWithFormat:@"%d-%d", newIndex, arg2]])) {
// 			long long rows = coord.row;
// 			long long cols = coord.col;
// 			newIndex+=1;
// 			cols+=1;
// 			if (cols > [%c(SBIconListView) iconColumnsForInterfaceOrientation:arg2])  {
// 				rows+=1;
// 				cols=1;
// 			}
// 			coord = SBIconCoordinateMake(rows,cols);
// 		}
// 	}
// 	[self.takenIconCoordinates setObject:[NSValue valueWithSBIconCoordinate:coord] forKey:[NSString stringWithFormat:@"%d-%d", newIndex, arg2]];
// 	return coord;
// }
// 	return orig;

// }

// - (void)layoutIconsIfNeeded:(double)arg1 domino:(bool)arg2 {

// 	self.takenIconCoordinates = [NSMutableDictionary new];
// 	[self reloadCustomWidgetCoordinates];
// 	if (isDropping) {
// 		isDropping = NO;
// 		%orig(0.0,NO);
// 	}
// 	else {
// 		%orig(arg1, NO);
// 	}
// }

// %end

// %hook SBIconListModel
// - (id)placeIcon:(id)arg1 atIndex:(unsigned long long *)arg2 {
// 	NSLog(@"Before Place Icon -- Icon: %@ Index: %llu", arg1, *arg2);
// 	id orig = %orig;
// 	NSLog(@"After Place Icon -- Icon: %@ Index: %llu Return: %@", arg1, *arg2, orig);
// 	return orig;

// }
// %end

%hook SBIconIndexMutableList
- (NSArray *)nodes {
	if ([[[IBIconHandler sharedHandler] icons] count] < 1) {
		return %orig;
	}
	NSMutableArray *originalIcons = [%orig mutableCopy];
	NSMutableArray *indexesToBeReplaced = [NSMutableArray new];
	NSMutableArray *originalIconsFixed = [NSMutableArray arrayWithCapacity:[originalIcons count]];
	NSMutableDictionary *fixedIcons = [NSMutableDictionary new];
	NSMutableArray *nodesToRemove = [NSMutableArray new];
	for (id object in originalIcons) {
    	if (![object isKindOfClass:[%c(SBWDXPlaceholderIcon) class]]) {
        	if ([object isKindOfClass:[%c(SBIcon) class]]) {
        		NSString *bundleIdentifier = [(SBIcon *)object applicationBundleID];
        		if ([[IBIconHandler sharedHandler] containsBundleID:bundleIdentifier]) {
		 			if ([[IBIconHandler sharedHandler] indexForBundleID:bundleIdentifier]) {
		 				[fixedIcons setObject:object forKey:[NSString stringWithFormat:@"%llu", [[IBIconHandler sharedHandler] indexForBundleID:bundleIdentifier]]];
		 				[nodesToRemove addObject:object];
		 			}
		 		}
        	}
        	[originalIconsFixed addObject:object];
    	}
    	else if ([object isKindOfClass:[%c(SBWDXPlaceholderIcon) class]]) {
    		[self removeNode:object];
    	}
	}
	[originalIcons setArray:originalIconsFixed];
	for (int z = 0; z < [originalIcons count]; z++) {
		if ([[originalIcons objectAtIndex:z] isKindOfClass:[%c(SBIcon) class]]) {
			SBIcon *icon = [originalIcons objectAtIndex:z];
			NSString *bundleIdentifier = [icon applicationBundleID];
			if ([[IBIconHandler sharedHandler] containsBundleID:bundleIdentifier]) {
				for (int y = 0; y < [[IBIconHandler sharedHandler] verticalWidgetSizeForBundleID:bundleIdentifier]; y++) {
					for (int x = 0; x < [[IBIconHandler sharedHandler] horiztonalWidgetSizeForBundleID:bundleIdentifier]; x++) {
						if ((y == 0) && (x == 0)) {
							int w = z;
							if ([[IBIconHandler sharedHandler] indexForBundleID:bundleIdentifier]) {
								w = [[IBIconHandler sharedHandler] indexForBundleID:bundleIdentifier];
								NSNumber *indexWrapper = [NSNumber numberWithUnsignedLongLong:w];
								if (![indexesToBeReplaced containsObject:indexWrapper]) {
									[indexesToBeReplaced addObject:indexWrapper];
								}
							}
						}
						else {
							int w = z;
							if ([[IBIconHandler sharedHandler] indexForBundleID:bundleIdentifier]) {
								w = [[IBIconHandler sharedHandler] indexForBundleID:bundleIdentifier];
							}
							unsigned long long index = w+([%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] * y)+x;
							NSNumber *indexWrapper = [NSNumber numberWithUnsignedLongLong:index];
							if (![indexesToBeReplaced containsObject:indexWrapper]) {
								[indexesToBeReplaced addObject:indexWrapper];
							}
 						}
 					}
 				}
			}
		}
	}
	if ([indexesToBeReplaced count] < 1) return originalIcons;
	NSSortDescriptor *indexSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
	[indexesToBeReplaced sortUsingDescriptors:[NSArray arrayWithObject:indexSortDescriptor]];
	for (id object in nodesToRemove) {
		[self removeNode:object];
		[originalIcons removeObject:object];
	}

	MSHookIvar<NSMutableArray*>(self,"_nodes") = originalIcons;
	for (NSNumber *index in indexesToBeReplaced) {
		if ([fixedIcons objectForKey:[NSString stringWithFormat:@"%llu", [index unsignedLongLongValue]]]) {
			[self insertNode:[fixedIcons objectForKey:[NSString stringWithFormat:@"%llu", [index unsignedLongLongValue]]] atIndex:[index unsignedLongLongValue]];
		}
		else {
			[self insertNode:[[%c(SBWDXPlaceholderIcon) alloc] initWithIdentifier:[NSString stringWithFormat:@"WIDUXPlaceHolder-%llu", [index unsignedLongLongValue]]] atIndex:[index unsignedLongLongValue]];
		}
	}
	return [originalIcons copy];
}
%end
%hook SBIconController
-(BOOL)icon:(id)iconView canReceiveGrabbedIcon:(id)grabbedIconView {
	if ([[IBIconHandler sharedHandler] containsBundleID:[[(SBIconView*)grabbedIconView icon] applicationBundleID]] || [[IBIconHandler sharedHandler] containsBundleID:[[(SBIconView*)iconView icon] applicationBundleID]]) {
		return NO;
	}
	return %orig;
}
- (id)insertIcon:(id)arg1 intoListView:(id)arg2 iconIndex:(long long)arg3 moveNow:(_Bool)arg4 {
	NSLog(@"Insert Icon: %@ Into List View: %@ Icon Index: %i", arg1,arg2,(int)arg3);
	id orig = %orig;
	NSLog(@"INSERT ICON RETURNS: %@", orig);
	return orig;
}

- (BOOL)folderController:(SBFolderView *)controller draggedIconDidPauseAtLocation:(CGPoint)draggedIcon inListView:(SBIconListView *)listView {
	NSUInteger pauseIndex;
	int propose;
	[listView iconAtPoint:draggedIcon index:&pauseIndex proposedOrder:&propose grabbedIcon:[self grabbedIcon]];

	if (pauseIndex != previousPauseIndex) {
		if ([self grabbedIcon]) {
			if ([[IBIconHandler sharedHandler] containsBundleID:[[self grabbedIcon] applicationBundleID]]) {
				SBIcon *icon = [[listView model] iconAtIndex:pauseIndex];
				if ([icon isPlaceholder]) {
					if (![icon isEmptyPlaceholder]) {
						while ([listView containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
						 	[self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
						}
					}
				}
			}
		}
	}
	previousPauseIndex = pauseIndex;
	[self compactIconsInIconListsInFolder:[controller folder] moveNow:YES limitToIconList:nil];
	BOOL proposedReturn = %orig;
	if ([self grabbedIcon]) {
		if (proposedReturn == TRUE && [[IBIconHandler sharedHandler] containsBundleID:[[self grabbedIcon] applicationBundleID]]) {
			/* Remove all exiting palceholders */
			while ([listView containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
				[self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
			}
					// [self compactIconsInIconListsInFolder:[controller folder] moveNow:YES limitToIconList:nil];
					//[listView reloadCustomWidgetCoordinates];
					//coordinateForIndexOriginal = YES;
					//int addition = (int)[listView indexAdditionNeededForCoordinate:[listView iconCoordinateForIndex:pauseIndex forOrientation:[[UIApplication sharedApplication] statusBarOrientation]] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
					//pauseIndex = pauseIndex + addition;
			for (int y = 0; y < [[IBIconHandler sharedHandler] verticalWidgetSizeForBundleID:[[self grabbedIcon] applicationBundleID]]; y++) {
				for (int x = 0; x < [[IBIconHandler sharedHandler] horiztonalWidgetSizeForBundleID:[[self grabbedIcon] applicationBundleID]]; x++) {
					unsigned long long index = pauseIndex+([%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] * y)+x;
					if ((x == 0) && (y == 0)) {
					
					}
							//coordinateForIndexOriginal = YES;
							//SBIconCoordinate palceholderCoordinate = [listView iconCoordinateForIndex:index forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
							// int row = (int)(index/[%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]);
							// int col = 
							//NSLog(@"INDEX FOR PLACEHOLDER: %i", (int)index);
					[self insertIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] intoListView:listView iconIndex:index moveNow:NO];
							//[listView.takenIconCoordinates setObject:[NSValue valueWithSBIconCoordinate:palceholderCoordinate] forKey:[NSString stringWithFormat:@"%d-%d", (int)index, (int)(long)[[UIApplication sharedApplication] statusBarOrientation]]];
				}
			}

				/* Done remove exxsisting placeholders */

				/* Adding extra placeholders because it is a block */
				// [self insertIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] intoListView:listView iconIndex:pauseIndex moveNow:NO];
			//	[self insertIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] intoListView:listView iconIndex:pauseIndex+1 moveNow:NO];
			//	[self insertIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] intoListView:listView iconIndex:pauseIndex+[%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] moveNow:NO];
				// [self insertIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]  intoListView:listView iconIndex:pauseIndex+1+[%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]] moveNow:NO];
				/* Done adding extra placeholders */	
		}
		//reloadListViewWithIcon([[%c(SBIconController) sharedInstance] grabbedIcon]);
	}
	return proposedReturn;
}

- (_Bool)folderController:(SBFolderView *)controller draggedIconDidMoveFromListView:(SBIconListView *)fromList toListView:(SBIconListView *)toList {

	BOOL proposedReturn = %orig;

	if (proposedReturn == TRUE) {
		if ([self grabbedIcon]) {
			if ([[IBIconHandler sharedHandler] containsBundleID:[[self grabbedIcon] applicationBundleID]]) {
				while ([fromList containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
					[self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
				}
				while ([toList containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
					[self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
				}
				//[self compactIconsInIconListsInFolder:[controller folder] moveNow:NO limitToIconList:nil];
			}
		}
		return TRUE;
	}
	else return FALSE;
}

- (void)_dropIcon:(SBIcon *)icon withInsertionPath:(id)insertionPath {
// 	NSLog(@"DROP APPLICATION: %@ AT INDEX PATH: %@", [icon applicationBundleID], insertionPath);
// 	%orig;
// }

	SBIconListView *listView;
	[[objc_getClass("SBIconController") sharedInstance] getListView:&listView folder:nil relativePath:nil forIndexPath:insertionPath createIfNecessary:YES];
	if ([[IBIconHandler sharedHandler] containsBundleID:[icon applicationBundleID]]) {

		while ([listView containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
			[self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
		}
		[[IBIconHandler sharedHandler] setIndex:[insertionPath indexAtPosition:[insertionPath length] - 1] forBundleID:[icon applicationBundleID]];
		isDropping = YES;
	}
	%orig(icon, insertionPath);
	/* Done removing all the left over placeholders */
}
%end

%hook SBFolderController
- (void)_resetDragPauseTimerForPoint:(struct CGPoint)point inIconListView:(SBIconListView *)listView {
	if ([[IBIconHandler sharedHandler] containsBundleID:[(SBIcon*)[self valueForKey:@"grabbedIcon"] applicationBundleID]]) { // If dragged icon is a widget
		SBIconView *draggedIconView = [[NSClassFromString(@"SBIconViewMap") homescreenMap] mappedIconViewForIcon:[self valueForKey:@"grabbedIcon"]];
		NSLog(@"DRAGGED ICON VIEW: %@", draggedIconView);
		//CGPoint properPausePoint = [[draggedIconView superview] convertPoint:CGPointMake(draggedIconView.frame.origin.x, draggedIconView.frame.origin.y) toView:listView];
		CGPoint properPausePoint = CGPointMake(draggedIconView.frame.origin.x + [%c(SBIconView) defaultIconSize].width/2, draggedIconView.frame.origin.y + [%c(SBIconView) defaultIconSize].height/2);
		point = properPausePoint;
	}
	%orig;
}


- (void)noteGrabbedIconDidChange:(id)arg1 {
	%orig;
	previousPauseIndex = -1;
}
%end


%hook SBIconStateArchiver

+ (id)_representationForIcon:(SBIcon *)icon {
	if ([icon isPlaceholder]) {
		if (![icon isEmptyPlaceholder]) {
			if (![icon referencedIcon]) {
				return 0;
			}
		}
	}
	return %orig;
}
%end

%hook MPUNowPlayingController
- (BOOL)shouldUpdateNowPlayingArtwork {
	return TRUE;
}
%end


%group MusicWidget

@interface SpringBoard : NSObject
@property (nonatomic, retain) MusicRemoteController *musicRemote;
@end

%hook SpringBoard

%property (nonatomic, retain) MusicRemoteController *musicRemote;

%new
- (MusicRemoteController *)remoteController {
	if (!self.musicRemote) self.musicRemote = [[NSClassFromString(@"MusicRemoteController") alloc] initWithPlayer:[NSClassFromString(@"MusicAVPlayer") sharedAVPlayer]];
	return self.musicRemote;
}
%end
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
		}

		else {

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
		}

		else {
			if ([bundleID isEqualToString:@"com.apple.Music"]) {
				[[IBIconHandler sharedHandler] setHoriztonalWidgetSize:4 forBundleID:bundleID];
				[[IBIconHandler sharedHandler] setVerticalWidgetSize:1 forBundleID:bundleID];
				//[[IBIconHandler sharedHandler] setIndex:4 forBundleID:bundleID];
			}
			else {
				[[IBIconHandler sharedHandler] setHoriztonalWidgetSize:2 forBundleID:bundleID];
				[[IBIconHandler sharedHandler] setVerticalWidgetSize:2 forBundleID:bundleID];
			}

			// SBIconController *controller = [NSClassFromString(@"SBIconController") sharedInstance];
			// SBRootFolder *rootFolder = [controller valueForKeyPath:@"rootFolder"];
			// NSIndexPath *indexPath = [rootFolder indexPathForIcon:icon];
			// SBIconListView *listView = nil;
			// [controller getListView:&listView folder:NULL relativePath:NULL forIndexPath:indexPath createIfNecessary:YES];
			// unsigned long long index = (unsigned long long)[[listView model] indexForLeafIconWithIdentifier:bundleID];
			// [[IBIconHandler sharedHandler] setIndex:index forKey:bundleID]

			[[IBIconHandler sharedHandler] addObject:bundleID];
		}

	[[NSNotificationCenter defaultCenter] postNotificationName:@"IBIconNeedsLayout" object:nil];

  }
  else {

		%orig;
	}
}
%end


%ctor {
	%init;
	%init(MusicWidget);
}