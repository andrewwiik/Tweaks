#import "IBIconHandler.h"
SBIconCoordinate SBIconCoordinateMake(long long row, long long col) {
    SBIconCoordinate coordinate;
    coordinate.row = row;
    coordinate.col = col;
    return coordinate;
}

@interface IBIconHandler () {
  NSMutableArray *aryItems;
  NSMutableDictionary *horiztonalSizes;
  NSMutableDictionary *verticalSizes;
  NSMutableDictionary *iconIndexes;
}
@end

@implementation IBIconHandler
+ (IBIconHandler*)sharedHandler {
  static dispatch_once_t p = 0;
  __strong static id _sharedObject = nil;
  dispatch_once(&p, ^{
    _sharedObject = [[self alloc] init];
  });
  return _sharedObject;
}
- (NSArray*)icons {
  return aryItems;
}
- (void)addObject:(NSString*)object {
  if (!aryItems) {
    aryItems = [NSMutableArray new];
  }
  [aryItems addObject:object];
}
- (void)removeObject:(NSString*)object {
  if ([aryItems containsObject:object]) {
    [aryItems removeObject:object];
    [verticalSizes removeObjectForKey:object];
    [horiztonalSizes removeObjectForKey:object];
    [iconIndexes removeObjectForKey:object];
  }
}
- (BOOL)containsBundleID:(NSString*)bundleID {
  if ([aryItems containsObject:bundleID]) {
    return YES;
  } else {
    return NO;
  }
}
- (int)horiztonalWidgetSizeForBundleID:(NSString *)bundleID {
  if (!horiztonalSizes) {
    horiztonalSizes = [NSMutableDictionary new];
  }
  return [(NSNumber*)[horiztonalSizes objectForKey:bundleID] intValue];
}

- (void)setHoriztonalWidgetSize:(int)size forBundleID:(NSString *)bundleID {
  if (!horiztonalSizes) {
    horiztonalSizes = [NSMutableDictionary new];
  }
  [horiztonalSizes setObject:[NSNumber numberWithInt:size] forKey:bundleID];

}
- (int)verticalWidgetSizeForBundleID:(NSString *)bundleID {
  if (!verticalSizes) {
    verticalSizes = [NSMutableDictionary new];
  }
  return [(NSNumber*)[verticalSizes objectForKey:bundleID] intValue];
}
- (void)setVerticalWidgetSize:(int)size forBundleID:(NSString *)bundleID {
  if (!verticalSizes) {
    verticalSizes = [NSMutableDictionary new];
  }
  [verticalSizes setObject:[NSNumber numberWithInt:size] forKey:bundleID];

}
- (void)setIndex:(unsigned long long)index forBundleID:(NSString *)bundleID {
  if (!iconIndexes) {
    iconIndexes = [NSMutableDictionary new];
  }
  if (bundleID) {
    [iconIndexes setObject:[NSNumber numberWithUnsignedLongLong:index] forKey:bundleID];
  }

}
- (unsigned long long)indexForBundleID:(NSString *)bundleID {
  if (!iconIndexes) {
    iconIndexes = [NSMutableDictionary new];
  }
  if (bundleID) {
    return [(NSNumber*)[iconIndexes objectForKey:bundleID] unsignedLongLongValue];
  }
  return -1;
}
- (CGSize)sizeForBundleID:(NSString *)bundleID {
  SBIconController *controller = [NSClassFromString(@"SBIconController") sharedInstance];
  SBIcon *icon = [[controller model] leafIconForIdentifier:bundleID];
  if (icon) {
    SBRootFolder *rootFolder = [controller valueForKeyPath:@"rootFolder"];
    NSIndexPath *indexPath = [rootFolder indexPathForIcon:icon];
    SBIconListView *listView = nil;
    [controller getListView:&listView folder:NULL relativePath:NULL forIndexPath:indexPath createIfNecessary:YES];
    if (listView) {
      int horizontalSize = [self horiztonalWidgetSizeForBundleID:bundleID];
      int verticalSize = [self verticalWidgetSizeForBundleID:bundleID];
      unsigned long long primaryIconIndex = [listView indexOfIcon:icon];
      SBIconCoordinate primaryIconCoordinate = [listView iconCoordinateForIndex:primaryIconIndex forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
      SBIconCoordinate widgetCoord = primaryIconCoordinate;
      unsigned long long farIndex = [listView indexForCoordinate:SBIconCoordinateMake(widgetCoord.row + verticalSize -1,widgetCoord.col + horizontalSize -1) forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
      SBIconCoordinate secondaryIconCoordinate = [listView iconCoordinateForIndex:farIndex forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
      
      CGPoint mainPoint = [listView originForIconAtCoordinate:primaryIconCoordinate];
      CGPoint secondaryPoint = [listView originForIconAtCoordinate:secondaryIconCoordinate];

      CGFloat blockWidth = secondaryPoint.x + [NSClassFromString(@"SBIconView") defaultIconImageSize].width - mainPoint.x;
      CGFloat blockHeight = secondaryPoint.y + [NSClassFromString(@"SBIconView") defaultIconImageSize].height - mainPoint.y;
      return CGSizeMake(blockWidth, blockHeight);
    }
  }
  return CGSizeMake(0,0);
}
@end
