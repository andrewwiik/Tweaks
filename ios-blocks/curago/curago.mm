#line 1 "/Users/Matt/iOS/Projects/Curago/Git/curago/curago.xm"













#import <SpringBoard7.0/SBIconController.h>
#import <SpringBoard7.0/SBFolder.h>
#import <SpringBoard7.0/SBRootFolder.h>
#import <SpringBoard7.0/SBIconListModel.h>
#import <SpringBoard7.0/SBIconModel.h>
#import <SpringBoard7.0/SBIconListView.h>
#import <SpringBoard7.0/SBIconImageView.h>
#import <SpringBoard7.0/SBIconView.h>
#import <SpringBoard7.0/SBApplicationIcon.h>
#import <SpringBoard7.0/SBFolderIcon.h>
#import <SpringBoard7.0/SBIconIndexMutableList.h>
#import <SpringBoard7.0/SBIconViewMap.h>
#import <SpringBoard7.0/SBIconScrollView.h>
#import <SpringBoard7.0/SBIconBadgeView.h>
#import <SpringBoard7.0/SBRootFolderController.h>
#import <SpringBoard7.0/SBRootFolderView.h>

#import <objc/runtime.h>

#import <QuartzCore/QuartzCore.h>
#import <BulletinBoard/BBServer.h>
#import <BulletinBoard/BBBulletin.h>

#import "IBKResources.h"
#import "IBKWidgetViewController.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface SBFAnimationSettings : NSObject
@property double duration;
+ (id)settingsControllerModule;
@end



typedef struct SBIconCoordinate {
    NSUInteger row;
    NSUInteger col;
} SBIconCoordinate;



@interface SBIconListView (Additions)
-(SBIconCoordinate)coordinateForIconWithIndex:(unsigned int)index andOriginalCoordinate:(SBIconCoordinate)orig forOrientation:(int)arg3;
-(SBIcon*)modifiedIconForIcon:(SBIcon*)icon;
@end

@interface SBIconModel (iOS8)
- (void)saveIconStateIfNeeded;
@end

@interface IBKIconView : SBIconView

+(IBKWidgetViewController*)getWidgetViewControllerForIcon:(SBIcon*)arg1 orBundleID:(NSString*)arg2;
-(void)addPreExpandedWidgetIfNeeded:(id)arg1;

@end



NSMutableDictionary *cachedIndexes;
NSMutableDictionary *cachedIndexesLandscape;
NSMutableSet *movedIndexPaths;
NSMutableDictionary *widgetViewControllers;

int icons = 0;
int currentOrientation = 1;
int touchesInAppWindowCount = 0;
int indexOfGrabbedIcon = -1;

id grabbedIcon;

BOOL animatingIn = NO;
BOOL rearrangingIcons = NO;
BOOL iWidgets = NO;
BOOL isRotating = NO;

BOOL allWidgetsNeedLocking = NO;

static BBServer* __weak IBKBBServer;



#pragma mark Icon co-ordinate placements

#include <logos/logos.h>
#include <substrate.h>
@class SBIconController; @class SBIconImageView; @class SBIconBadgeView; @class IBKIconView; @class BBServer; @class SBMediaController; @class IWWidgetsView; @class SBApplication; @class SBLockScreenManager; @class SBIconScrollView; @class SBCloseBoxView; @class SBIconView; @class SBIconViewMap; @class SBUIController; @class SBAppSliderController; @class SBIconListView; @class SBAppSwitcherController; 
static _Bool (*_logos_orig$_ungrouped$SBIconListView$isFull)(SBIconListView*, SEL); static _Bool _logos_method$_ungrouped$SBIconListView$isFull(SBIconListView*, SEL); static void (*_logos_orig$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$)(SBIconListView*, SEL, int); static void _logos_method$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$(SBIconListView*, SEL, int); static void (*_logos_orig$_ungrouped$SBIconListView$cleanupAfterRotation)(SBIconListView*, SEL); static void _logos_method$_ungrouped$SBIconListView$cleanupAfterRotation(SBIconListView*, SEL); static unsigned int (*_logos_orig$_ungrouped$SBIconListView$rowAtPoint$)(SBIconListView*, SEL, struct CGPoint); static unsigned int _logos_method$_ungrouped$SBIconListView$rowAtPoint$(SBIconListView*, SEL, struct CGPoint); static unsigned int (*_logos_orig$_ungrouped$SBIconListView$columnAtPoint$)(SBIconListView*, SEL, struct CGPoint); static unsigned int _logos_method$_ungrouped$SBIconListView$columnAtPoint$(SBIconListView*, SEL, struct CGPoint); static id (*_logos_orig$_ungrouped$SBIconListView$iconAtPoint$index$proposedOrder$grabbedIcon$)(SBIconListView*, SEL, struct CGPoint, unsigned long long *, int *, id); static id _logos_method$_ungrouped$SBIconListView$iconAtPoint$index$proposedOrder$grabbedIcon$(SBIconListView*, SEL, struct CGPoint, unsigned long long *, int *, id); static unsigned int (*_logos_orig$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$)(SBIconListView*, SEL, struct SBIconCoordinate, int); static unsigned int _logos_method$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$(SBIconListView*, SEL, struct SBIconCoordinate, int); static struct SBIconCoordinate (*_logos_orig$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$)(SBIconListView*, SEL, unsigned int, int); static struct SBIconCoordinate _logos_method$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$(SBIconListView*, SEL, unsigned int, int); static SBIconCoordinate _logos_method$_ungrouped$SBIconListView$coordinateForIconWithIndex$andOriginalCoordinate$forOrientation$(SBIconListView*, SEL, unsigned int, SBIconCoordinate, int); static SBIcon* _logos_method$_ungrouped$SBIconListView$modifiedIconForIcon$(SBIconListView*, SEL, SBIcon*); static void (*_logos_orig$_ungrouped$SBAppSliderController$switcherWasDismissed$)(SBAppSliderController*, SEL, BOOL); static void _logos_method$_ungrouped$SBAppSliderController$switcherWasDismissed$(SBAppSliderController*, SEL, BOOL); static void (*_logos_orig$_ungrouped$SBUIController$_activateSwitcher)(SBUIController*, SEL); static void _logos_method$_ungrouped$SBUIController$_activateSwitcher(SBUIController*, SEL); static void (*_logos_orig$_ungrouped$SBAppSwitcherController$switcherWasDismissed$)(SBAppSwitcherController*, SEL, BOOL); static void _logos_method$_ungrouped$SBAppSwitcherController$switcherWasDismissed$(SBAppSwitcherController*, SEL, BOOL); static void (*_logos_orig$_ungrouped$SBApplication$willAnimateDeactivation$)(SBApplication*, SEL, _Bool); static void _logos_method$_ungrouped$SBApplication$willAnimateDeactivation$(SBApplication*, SEL, _Bool); static void (*_logos_orig$_ungrouped$SBApplication$didAnimateDeactivation)(SBApplication*, SEL); static void _logos_method$_ungrouped$SBApplication$didAnimateDeactivation(SBApplication*, SEL); static void (*_logos_orig$_ungrouped$SBApplication$willActivateWithTransactionID$)(SBApplication*, SEL, unsigned long long); static void _logos_method$_ungrouped$SBApplication$willActivateWithTransactionID$(SBApplication*, SEL, unsigned long long); static void (*_logos_orig$_ungrouped$SBApplication$didActivateWithTransactionID$)(SBApplication*, SEL, unsigned long long); static void _logos_method$_ungrouped$SBApplication$didActivateWithTransactionID$(SBApplication*, SEL, unsigned long long); static void (*_logos_orig$_ungrouped$SBApplication$didAnimateActivation)(SBApplication*, SEL); static void _logos_method$_ungrouped$SBApplication$didAnimateActivation(SBApplication*, SEL); static void (*_logos_orig$_ungrouped$SBApplication$willAnimateActivation)(SBApplication*, SEL); static void _logos_method$_ungrouped$SBApplication$willAnimateActivation(SBApplication*, SEL); static void (*_logos_orig$_ungrouped$SBApplication$prepareForUninstallation)(SBApplication*, SEL); static void _logos_method$_ungrouped$SBApplication$prepareForUninstallation(SBApplication*, SEL); static id (*_logos_orig$_ungrouped$SBIconViewMap$mappedIconViewForIcon$)(SBIconViewMap*, SEL, id); static id _logos_method$_ungrouped$SBIconViewMap$mappedIconViewForIcon$(SBIconViewMap*, SEL, id); static id (*_logos_orig$_ungrouped$SBIconView$initWithDefaultSize)(SBIconView*, SEL); static id _logos_method$_ungrouped$SBIconView$initWithDefaultSize(SBIconView*, SEL); static CGRect (*_logos_orig$_ungrouped$SBIconImageView$visibleBounds)(SBIconImageView*, SEL); static CGRect _logos_method$_ungrouped$SBIconImageView$visibleBounds(SBIconImageView*, SEL); static CGRect (*_logos_orig$_ungrouped$SBIconImageView$frame)(SBIconImageView*, SEL); static CGRect _logos_method$_ungrouped$SBIconImageView$frame(SBIconImageView*, SEL); static CGRect (*_logos_orig$_ungrouped$SBIconImageView$bounds)(SBIconImageView*, SEL); static CGRect _logos_method$_ungrouped$SBIconImageView$bounds(SBIconImageView*, SEL); static CGPoint (*_logos_orig$_ungrouped$IBKIconView$iconImageCenter)(IBKIconView*, SEL); static CGPoint _logos_method$_ungrouped$IBKIconView$iconImageCenter(IBKIconView*, SEL); static CGRect (*_logos_orig$_ungrouped$IBKIconView$iconImageFrame)(IBKIconView*, SEL); static CGRect _logos_method$_ungrouped$IBKIconView$iconImageFrame(IBKIconView*, SEL); static void (*_logos_orig$_ungrouped$IBKIconView$prepareToCrossfadeImageWithView$maskCorners$trueCrossfade$anchorPoint$)(IBKIconView*, SEL, id, _Bool, _Bool, struct CGPoint); static void _logos_method$_ungrouped$IBKIconView$prepareToCrossfadeImageWithView$maskCorners$trueCrossfade$anchorPoint$(IBKIconView*, SEL, id, _Bool, _Bool, struct CGPoint); static id (*_logos_orig$_ungrouped$IBKIconView$iconImageSnapshot)(IBKIconView*, SEL); static id _logos_method$_ungrouped$IBKIconView$iconImageSnapshot(IBKIconView*, SEL); static CGRect (*_logos_orig$_ungrouped$IBKIconView$frame)(IBKIconView*, SEL); static CGRect _logos_method$_ungrouped$IBKIconView$frame(IBKIconView*, SEL); static void (*_logos_orig$_ungrouped$IBKIconView$_setIcon$animated$)(IBKIconView*, SEL, id, BOOL); static void _logos_method$_ungrouped$IBKIconView$_setIcon$animated$(IBKIconView*, SEL, id, BOOL); static struct CGRect (*_logos_orig$_ungrouped$IBKIconView$_frameForLabel)(IBKIconView*, SEL); static struct CGRect _logos_method$_ungrouped$IBKIconView$_frameForLabel(IBKIconView*, SEL); static void (*_logos_orig$_ungrouped$IBKIconView$prepareForRecycling)(IBKIconView*, SEL); static void _logos_method$_ungrouped$IBKIconView$prepareForRecycling(IBKIconView*, SEL); static BOOL (*_logos_orig$_ungrouped$IBKIconView$pointInside$withEvent$)(IBKIconView*, SEL, struct CGPoint, UIEvent*); static BOOL _logos_method$_ungrouped$IBKIconView$pointInside$withEvent$(IBKIconView*, SEL, struct CGPoint, UIEvent*); static void (*_logos_orig$_ungrouped$IBKIconView$addSubview$)(IBKIconView*, SEL, UIView*); static void _logos_method$_ungrouped$IBKIconView$addSubview$(IBKIconView*, SEL, UIView*); static IBKWidgetViewController* _logos_meta_method$_ungrouped$IBKIconView$getWidgetViewControllerForIcon$orBundleID$(Class, SEL, SBIcon*, NSString*); static void _logos_method$_ungrouped$IBKIconView$addPreExpandedWidgetIfNeeded$(IBKIconView*, SEL, id); static void (*_logos_orig$_ungrouped$SBIconController$setIsEditing$)(SBIconController*, SEL, BOOL); static void _logos_method$_ungrouped$SBIconController$setIsEditing$(SBIconController*, SEL, BOOL); static BOOL _logos_method$_ungrouped$SBIconController$ibkIsInSwitcher(SBIconController*, SEL); static void _logos_method$_ungrouped$SBIconController$removeIdentifierFromWidgets$(SBIconController*, SEL, NSString*); static void _logos_method$_ungrouped$SBIconController$removeAllCachedIcons(SBIconController*, SEL); static UIScrollView* (*_logos_orig$_ungrouped$SBIconScrollView$initWithFrame$)(SBIconScrollView*, SEL, CGRect); static UIScrollView* _logos_method$_ungrouped$SBIconScrollView$initWithFrame$(SBIconScrollView*, SEL, CGRect); static void (*_logos_orig$_ungrouped$SBIconScrollView$_updatePagingGesture)(SBIconScrollView*, SEL); static void _logos_method$_ungrouped$SBIconScrollView$_updatePagingGesture(SBIconScrollView*, SEL); static void (*_logos_orig$_ungrouped$SBIconScrollView$layoutSubviews)(SBIconScrollView*, SEL); static void _logos_method$_ungrouped$SBIconScrollView$layoutSubviews(SBIconScrollView*, SEL); static BOOL _logos_method$_ungrouped$SBIconScrollView$gestureRecognizerShouldBegin$(SBIconScrollView*, SEL, UIGestureRecognizer *); static BOOL _logos_method$_ungrouped$SBIconScrollView$gestureRecognizer$shouldRequireFailureOfGestureRecognizer$(SBIconScrollView*, SEL, UIGestureRecognizer*, UIGestureRecognizer*); static void _logos_method$_ungrouped$SBIconScrollView$handlePinchGesture$(SBIconScrollView*, SEL, UIPinchGestureRecognizer*); static SBIconListView * _logos_method$_ungrouped$SBIconScrollView$IBKListViewForIdentifierTwo$(SBIconScrollView*, SEL, NSString*); static void (*_logos_orig$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$)(SBIconBadgeView*, SEL, SBIcon*, int, BOOL); static void _logos_method$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$(SBIconBadgeView*, SEL, SBIcon*, int, BOOL); static struct CGPoint (*_logos_orig$_ungrouped$SBIconBadgeView$accessoryOriginForIconBounds$)(SBIconBadgeView*, SEL, CGRect); static struct CGPoint _logos_method$_ungrouped$SBIconBadgeView$accessoryOriginForIconBounds$(SBIconBadgeView*, SEL, CGRect); static void (*_logos_orig$_ungrouped$SBIconBadgeView$layoutSubviews)(SBIconBadgeView*, SEL); static void _logos_method$_ungrouped$SBIconBadgeView$layoutSubviews(SBIconBadgeView*, SEL); static void (*_logos_orig$_ungrouped$SBCloseBoxView$layoutSubviews)(SBCloseBoxView*, SEL); static void _logos_method$_ungrouped$SBCloseBoxView$layoutSubviews(SBCloseBoxView*, SEL); static void (*_logos_orig$_ungrouped$SBLockScreenManager$lockUIFromSource$withOptions$)(SBLockScreenManager*, SEL, int, id); static void _logos_method$_ungrouped$SBLockScreenManager$lockUIFromSource$withOptions$(SBLockScreenManager*, SEL, int, id); static id (*_logos_orig$_ungrouped$BBServer$init)(BBServer*, SEL); static id _logos_method$_ungrouped$BBServer$init(BBServer*, SEL); static void (*_logos_orig$_ungrouped$BBServer$_addBulletin$)(BBServer*, SEL, BBBulletin*); static void _logos_method$_ungrouped$BBServer$_addBulletin$(BBServer*, SEL, BBBulletin*); static void (*_logos_orig$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$)(BBServer*, SEL, id, BOOL, BOOL); static void _logos_method$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$(BBServer*, SEL, id, BOOL, BOOL); static id _logos_meta_method$_ungrouped$BBServer$sharedIBKBBServer(Class, SEL); static void (*_logos_orig$_ungrouped$SBMediaController$_nowPlayingInfoChanged)(SBMediaController*, SEL); static void _logos_method$_ungrouped$SBMediaController$_nowPlayingInfoChanged(SBMediaController*, SEL); 

#line 99 "/Users/Matt/iOS/Projects/Curago/Git/curago/curago.xm"


static _Bool _logos_method$_ungrouped$SBIconListView$isFull(SBIconListView* self, SEL _cmd) {
    int count = 1;

    for (SBIcon *icon in [self icons]) {
        if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]]) {
            count += 3;
        }

        count++;
    }

    return (count >= [objc_getClass("SBIconListView") maxIcons]);
}

static void _logos_method$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$(SBIconListView* self, SEL _cmd, int arg1) {
    currentOrientation = arg1;
    isRotating = YES;

    _logos_orig$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$(self, _cmd, arg1);
}

static void _logos_method$_ungrouped$SBIconListView$cleanupAfterRotation(SBIconListView* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBIconListView$cleanupAfterRotation(self, _cmd);

    

    isRotating = NO;

    if (currentOrientation == 1 || currentOrientation == 2) {
        [cachedIndexes removeAllObjects];
    } else if (currentOrientation == 3 || currentOrientation == 4) {
        [cachedIndexesLandscape removeAllObjects];
    }

    [(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.0 domino:NO forceRelayout:YES];
}



static unsigned int _logos_method$_ungrouped$SBIconListView$rowAtPoint$(SBIconListView* self, SEL _cmd, struct CGPoint arg1) {
    unsigned int orig = _logos_orig$_ungrouped$SBIconListView$rowAtPoint$(self, _cmd, arg1);
    NSLog(@"*** [Curago] :: designating row %d for point %@", orig, NSStringFromCGPoint(arg1));

    return orig;
}

static unsigned int _logos_method$_ungrouped$SBIconListView$columnAtPoint$(SBIconListView* self, SEL _cmd, struct CGPoint arg1) {
    unsigned int column = _logos_orig$_ungrouped$SBIconListView$columnAtPoint$(self, _cmd, arg1);
    NSLog(@"*** [Curago] :: designating column %d for point %@", column, NSStringFromCGPoint(arg1));

    return column;
}

static id _logos_method$_ungrouped$SBIconListView$iconAtPoint$index$proposedOrder$grabbedIcon$(SBIconListView* self, SEL _cmd, struct CGPoint arg1, unsigned long long * arg2, int * arg3, id arg4) {
    id orig = _logos_orig$_ungrouped$SBIconListView$iconAtPoint$index$proposedOrder$grabbedIcon$(self, _cmd, arg1, arg2, arg3, arg4);

    if ([IBKResources hoverOnly]) {
        return orig;
    }

    







    

    NSLog(@"ICON AT POINT WITH INDEX: %llu", *arg2);

    if ([[IBKResources widgetBundleIdentifiers] containsObject:[arg4 leafIdentifier]]) {
        grabbedIcon = arg4;
        indexOfGrabbedIcon = (int)*arg2;

        if (*arg3 == 3 || *arg3 == 2) {
            *arg3 = 1;
        }
    } else {
        grabbedIcon = nil;
        indexOfGrabbedIcon = -1;
    }

    return orig;
}

static unsigned int _logos_method$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$(SBIconListView* self, SEL _cmd, struct SBIconCoordinate arg1, int arg2) {
    unsigned int orig = _logos_orig$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$(self, _cmd, arg1, arg2);
    NSLog(@"Old index == %u", orig);

    if ([IBKResources hoverOnly]) {
        return orig;
    }

    

    

    
    unsigned int i = 0;

    for (NSString *bundleIdentifier in [IBKResources widgetBundleIdentifiers]) {
        if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
            
            int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
            SBIconCoordinate widget = [self iconCoordinateForIndex:a forOrientation:arg2];

            

            
            if ((widget.col+1) == arg1.col && widget.row == arg1.row) {
                NSLog(@"INVALID LOCATION");
                return -1;
            } else {
                if (widget.row < arg1.row)
                    i++;
                else if ((widget.col+1) < arg1.col && widget.row == arg1.row)
                    i++;
            }

            
            if (widget.col == arg1.col && (widget.row+1) == arg1.row) {
                NSLog(@"INVALID LOCATION");
                return -1;
            } else {
                if ((widget.row+1) < arg1.row)
                    i++;
                else if (widget.col < arg1.col && (widget.row+1) == arg1.row)
                    i++;
            }

            
            if ((widget.col+1) == arg1.col && (widget.row+1) == arg1.row) {
                NSLog(@"INVALID LOCATION");
                return -1;
            } else {
                if ((widget.row+1) < arg1.row)
                    i++;
                else if ((widget.col+1) < arg1.col && (widget.row+1) == arg1.row)
                    i++;
            }

        }
    }

    orig -= i;

    
    NSLog(@"Final index == %u", orig);

    return orig;
}



static struct SBIconCoordinate _logos_method$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$(SBIconListView* self, SEL _cmd, unsigned int arg1, int arg2) {
    SBIconCoordinate orig = _logos_orig$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$(self, _cmd, arg1, arg2);

    if ([IBKResources hoverOnly]) {
        return orig;
    }

    if (![[self class] isEqual:[objc_getClass("SBDockIconListView") class]] && ![[self class] isEqual:[objc_getClass("SBFolderIconListView") class]]) {
        
        orig = [self coordinateForIconWithIndex:arg1 andOriginalCoordinate:orig forOrientation:arg2];

        
    }

    return orig;
}



static SBIconCoordinate _logos_method$_ungrouped$SBIconListView$coordinateForIconWithIndex$andOriginalCoordinate$forOrientation$(SBIconListView* self, SEL _cmd, unsigned int index, SBIconCoordinate orig, int orientation) {
   

    

















    




    if (!cachedIndexes)
        cachedIndexes = [NSMutableDictionary dictionary];
    if (!cachedIndexesLandscape)
        cachedIndexesLandscape = [NSMutableDictionary dictionary];

    SBApplicationIcon *icon = [[self model] iconAtIndex:index];
    NSString *bundleIdentifier = [icon leafIdentifier];

    if (!bundleIdentifier) {
        
        bundleIdentifier = [(SBFolderIcon*)icon nodeDescriptionWithPrefix:@"IBK"];
    }

    NSIndexPath *path;

    if (orientation == 1 || orientation == 2)
        path = [cachedIndexes objectForKey:bundleIdentifier];
    else if (orientation == 3 || orientation == 4)
        path = [cachedIndexesLandscape objectForKey:bundleIdentifier];

    if (path && !rearrangingIcons) {
        

        orig.row = (NSInteger)path.row;
        orig.col = (NSInteger)path.section;

        return orig;
    }

    NSLog(@"Getting icon co-ordinates for index %d", index);

    if (!movedIndexPaths) {
        
        movedIndexPaths = [NSMutableSet set];
    }

    BOOL invalid = YES;

    
    if ([[IBKResources widgetBundleIdentifiers] containsObject:bundleIdentifier] || ([self containsIcon:grabbedIcon] && indexOfGrabbedIcon == index)) {
        
        

        while (invalid) {
            
            

            NSIndexPath *testpath = [NSIndexPath indexPathForRow:orig.row inSection:orig.col];

            if (![movedIndexPaths containsObject:testpath]) {
                
                invalid = NO;
            } else {
                

                orig.col += 1;
                if (orig.col > [objc_getClass("SBIconListView") iconColumnsForInterfaceOrientation:currentOrientation]) {
                    orig.row += 1;
                    orig.col = 1;
                }
            }
        }

        NSUInteger widgetRow = orig.row;
        NSUInteger widgetCol = orig.col;

        
        NSIndexPath *path2 = [NSIndexPath indexPathForRow:widgetRow inSection:widgetCol+1];
        NSIndexPath *path3 = [NSIndexPath indexPathForRow:widgetRow+1 inSection:widgetCol];
        NSIndexPath *path4 = [NSIndexPath indexPathForRow:widgetRow+1 inSection:widgetCol+1];

        

        
        [movedIndexPaths addObject:path2];
        [movedIndexPaths addObject:path3];
        [movedIndexPaths addObject:path4];
    }

    while (invalid) {
        
        

        NSIndexPath *testpath = [NSIndexPath indexPathForRow:orig.row inSection:orig.col];

        if (![movedIndexPaths containsObject:testpath]) {
            
            invalid = NO;
        } else {
            

            orig.col += 1;
            if (orig.col > [objc_getClass("SBIconListView") iconColumnsForInterfaceOrientation:currentOrientation]) {
                

                orig.row += 1;
                orig.col = 1;
            }
        }
    }

    
    NSIndexPath *pathz = [NSIndexPath indexPathForRow:orig.row inSection:orig.col];
    [movedIndexPaths addObject:pathz];

    
    if (!rearrangingIcons) {
       
        if (orientation == 1 || orientation == 2)
            [cachedIndexes setObject:pathz forKey:bundleIdentifier];
        else if (orientation == 3 || orientation == 4)
            [cachedIndexesLandscape setObject:pathz forKey:bundleIdentifier];
    }

    
    if (index == [(NSArray*)[self icons] count]-1) {
        NSLog(@"Killing array");
        [movedIndexPaths removeAllObjects];
    }

    return orig;
}



static SBIcon* _logos_method$_ungrouped$SBIconListView$modifiedIconForIcon$(SBIconListView* self, SEL _cmd, SBIcon* icon) {
    

    int index = 0;

    if ([[self icons] containsObject:icon]) {
        NSLog(@"We have the icon, and it's index is %lu", (unsigned long)[[self icons] indexOfObject:icon]);
        index = (int)[[self icons] indexOfObject:icon];
    } else {
        NSLog(@"Wtf. the icon is %@", icon);
    }

    NSLog(@"Old index == %d", index);

    int i = 0;
    int columns = [objc_getClass("SBIconListView") iconColumnsForInterfaceOrientation:currentOrientation];

     for (NSString *bundleIdentifier in [IBKResources widgetBundleIdentifiers]) {

         if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
             

             int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
             if (a < index)
                 i++;
             if (a+1 < index)
                 i++;

             int b = a + columns;
             if (b < index)
                 i++;
             if (b+1 < index)
                 i++;
         }
     }

    index -= (i == 0 ? 0 : i-1);

    NSLog(@"New index == %d", index);

    return [(SBIconListModel*)[self model] iconAtIndex:index];


    

    
}



#pragma mark App switcher detection

BOOL inSwitcher = NO;



static void _logos_method$_ungrouped$SBAppSliderController$switcherWasDismissed$(SBAppSliderController* self, SEL _cmd, BOOL arg1) {
    _logos_orig$_ungrouped$SBAppSliderController$switcherWasDismissed$(self, _cmd, arg1);
    inSwitcher = NO;
}





static void _logos_method$_ungrouped$SBUIController$_activateSwitcher(SBUIController* self, SEL _cmd) {
    inSwitcher = YES;
    
    
    for (NSString *key in [widgetViewControllers allKeys]) {
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:key];
        widgetController.view.alpha = 1.0;
    }
    
    _logos_orig$_ungrouped$SBUIController$_activateSwitcher(self, _cmd);
}





NSString *lastOpenedWidgetId;



static void _logos_method$_ungrouped$SBAppSwitcherController$switcherWasDismissed$(SBAppSwitcherController* self, SEL _cmd, BOOL arg1) {
    _logos_orig$_ungrouped$SBAppSwitcherController$switcherWasDismissed$(self, _cmd, arg1);
    inSwitcher = NO;
}



#import <SpringBoard7.0/SBApplication.h>

#pragma mark Opening/closing app animations

BOOL sup;
BOOL launchingWidget;



static void _logos_method$_ungrouped$SBApplication$willAnimateDeactivation$(SBApplication* self, SEL _cmd, _Bool arg1) {
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];
    widgetController.view.alpha = 0.0;

    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.25] animations:^{
        widgetController.view.alpha = 1.0;
    }];

    sup = YES;

    _logos_orig$_ungrouped$SBApplication$willAnimateDeactivation$(self, _cmd, arg1);
}

static void _logos_method$_ungrouped$SBApplication$didAnimateDeactivation(SBApplication* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBApplication$didAnimateDeactivation(self, _cmd);

    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];
    [(UIImageView*)[widgetController.correspondingIconView _iconImageView] setAlpha:0.0];

    sup = NO;
}

static void _logos_method$_ungrouped$SBApplication$willActivateWithTransactionID$(SBApplication* self, SEL _cmd, unsigned long long arg1) {
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];

    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.25] animations:^{
        widgetController.view.alpha = 0.0;
    }];

    sup = YES;

    _logos_orig$_ungrouped$SBApplication$willActivateWithTransactionID$(self, _cmd, arg1);
}

static void _logos_method$_ungrouped$SBApplication$didActivateWithTransactionID$(SBApplication* self, SEL _cmd, unsigned long long arg1) {
    lastOpenedWidgetId = [self bundleIdentifier];

    _logos_orig$_ungrouped$SBApplication$didActivateWithTransactionID$(self, _cmd, arg1);

    sup = NO;
    
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];
    widgetController.view.alpha = 1.0;
}



static void _logos_method$_ungrouped$SBApplication$didAnimateActivation(SBApplication* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBApplication$didAnimateActivation(self, _cmd);

    sup = NO;
}

static void _logos_method$_ungrouped$SBApplication$willAnimateActivation(SBApplication* self, SEL _cmd) {
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];

    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.3] animations:^{
        widgetController.view.alpha = 0.0;
    }];

    sup = YES;

    _logos_orig$_ungrouped$SBApplication$willAnimateActivation(self, _cmd);
}



#pragma mark Injection into icon views



static id _logos_method$_ungrouped$SBIconViewMap$mappedIconViewForIcon$(SBIconViewMap* self, SEL _cmd, id arg1) {
    id orig = _logos_orig$_ungrouped$SBIconViewMap$mappedIconViewForIcon$(self, _cmd, arg1);

    if ([[orig class] isEqual:[objc_getClass("IBKIconView") class]]) {
        if (!isRotating)
            [(IBKIconView*)orig addPreExpandedWidgetIfNeeded:arg1];
    }

    return orig;
}






static id _logos_method$_ungrouped$SBIconView$initWithDefaultSize(SBIconView* self, SEL _cmd) {
    SBIconView *original = _logos_orig$_ungrouped$SBIconView$initWithDefaultSize(self, _cmd);
    if (![[original class] isEqual:[objc_getClass("IBKIconView") class]] && ![[original class] isEqual:[objc_getClass("SBFolderIconView") class]])
        object_setClass(original, objc_getClass("IBKIconView"));
    return original;
}



CGSize defaultIconSizing;

#import <SpringBoard8.1/SBIconImageCrossfadeView.h>



static CGRect _logos_method$_ungrouped$SBIconImageView$visibleBounds(SBIconImageView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
        CGRect frame = _logos_orig$_ungrouped$SBIconImageView$visibleBounds(self, _cmd);
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

        return frame;
    }

    return _logos_orig$_ungrouped$SBIconImageView$visibleBounds(self, _cmd);
}

static CGRect _logos_method$_ungrouped$SBIconImageView$frame(SBIconImageView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
        CGRect frame = _logos_orig$_ungrouped$SBIconImageView$frame(self, _cmd);
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

        return frame;
    }

    return _logos_orig$_ungrouped$SBIconImageView$frame(self, _cmd);
}

static CGRect _logos_method$_ungrouped$SBIconImageView$bounds(SBIconImageView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
        CGRect frame = _logos_orig$_ungrouped$SBIconImageView$bounds(self, _cmd);
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

        return frame;
    }

    return _logos_orig$_ungrouped$SBIconImageView$bounds(self, _cmd);
}





static CGPoint _logos_method$_ungrouped$IBKIconView$iconImageCenter(IBKIconView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        CGPoint point = _logos_orig$_ungrouped$IBKIconView$iconImageCenter(self, _cmd);

        if ([IBKResources hoverOnly]) {
            return point;
        }

        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        point = CGPointMake(widgetController.view.frame.size.width/2, widgetController.view.frame.size.height/2);

        return point;
    }

    return _logos_orig$_ungrouped$IBKIconView$iconImageCenter(self, _cmd);
}

static CGRect _logos_method$_ungrouped$IBKIconView$iconImageFrame(IBKIconView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        CGRect frame = _logos_orig$_ungrouped$IBKIconView$iconImageFrame(self, _cmd);
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

        return frame;
    }

    return _logos_orig$_ungrouped$IBKIconView$iconImageFrame(self, _cmd);
}

static void _logos_method$_ungrouped$IBKIconView$prepareToCrossfadeImageWithView$maskCorners$trueCrossfade$anchorPoint$(IBKIconView* self, SEL _cmd, id arg1, _Bool arg2, _Bool arg3, struct CGPoint arg4) {
    _logos_orig$_ungrouped$IBKIconView$prepareToCrossfadeImageWithView$maskCorners$trueCrossfade$anchorPoint$(self, _cmd, arg1, arg2, arg3, arg4);
}

static id _logos_method$_ungrouped$IBKIconView$iconImageSnapshot(IBKIconView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        UIView *view = widgetController.view;

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];

        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        return img;
    } else {
        return _logos_orig$_ungrouped$IBKIconView$iconImageSnapshot(self, _cmd);
    }
}

static CGRect _logos_method$_ungrouped$IBKIconView$frame(IBKIconView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && !animatingIn && (iWidgets || [IBKResources hoverOnly])) {
        CGRect frame = _logos_orig$_ungrouped$IBKIconView$frame(self, _cmd);
        defaultIconSizing = frame.size;
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height + [self _frameForLabel].size.height);

        if ([IBKResources hoverOnly]) {
            frame.origin = CGPointMake(frame.origin.x - ((widgetController.view.frame.size.width - frame.size.width)/2), frame.origin.y - ((widgetController.view.frame.size.height - frame.size.height)/2));
        }

        return frame;
    }

    return _logos_orig$_ungrouped$IBKIconView$frame(self, _cmd);
}

static void _logos_method$_ungrouped$IBKIconView$_setIcon$animated$(IBKIconView* self, SEL _cmd, id arg1, BOOL arg2) { 
    _logos_orig$_ungrouped$IBKIconView$_setIcon$animated$(self, _cmd, arg1, arg2);

    [self addPreExpandedWidgetIfNeeded:arg1];
}

static struct CGRect _logos_method$_ungrouped$IBKIconView$_frameForLabel(IBKIconView* self, SEL _cmd) {
    CGRect orig = _logos_orig$_ungrouped$IBKIconView$_frameForLabel(self, _cmd);

    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && ![IBKResources hoverOnly]) {
        orig.origin = CGPointMake(8, [IBKResources heightForWidget] + (isPad ? 7 : 2));
    }

    return orig;
}

static void _logos_method$_ungrouped$IBKIconView$prepareForRecycling(IBKIconView* self, SEL _cmd) {
    _logos_orig$_ungrouped$IBKIconView$prepareForRecycling(self, _cmd);

    IBKWidgetViewController *cont = [objc_getClass("IBKIconView") getWidgetViewControllerForIcon:self.icon orBundleID:nil];
    [cont unloadWidgetInterface];

    NSLog(@"**** [Curago] :: recycling view");

    if ([self.icon applicationBundleID])
        [widgetViewControllers removeObjectForKey:[self.icon applicationBundleID]];
}

static BOOL _logos_method$_ungrouped$IBKIconView$pointInside$withEvent$(IBKIconView* self, SEL _cmd, struct CGPoint arg1, UIEvent* arg2) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        

        if ([IBKResources hoverOnly]) {
            UIView *view = [[widgetViewControllers objectForKey:[self.icon applicationBundleID]] view];

            
            arg1.x = arg1.x + ((view.frame.size.width - self.frame.size.width)/2);
            arg1.y = arg1.y + ((view.frame.size.width - self.frame.size.width)/2);
            
        }

        NSLog(@"Checking if point %@ is inside.", NSStringFromCGPoint(arg1));

        return [[[widgetViewControllers objectForKey:[self.icon applicationBundleID]] view] pointInside:arg1 withEvent:arg2];
    }

    BOOL orig = _logos_orig$_ungrouped$IBKIconView$pointInside$withEvent$(self, _cmd, arg1, arg2);

    
    

    return orig;
}

static void _logos_method$_ungrouped$IBKIconView$addSubview$(IBKIconView* self, SEL _cmd, UIView* view) {    
    IBKWidgetViewController *cont = [objc_getClass("IBKIconView") getWidgetViewControllerForIcon:self.icon orBundleID:nil];
    if (cont && [[view class] isEqual:[objc_getClass("SBCloseBoxView") class]]) {
        [cont.view addSubview:view];
    } else {
        _logos_orig$_ungrouped$IBKIconView$addSubview$(self, _cmd, view);
    }
}



static IBKWidgetViewController* _logos_meta_method$_ungrouped$IBKIconView$getWidgetViewControllerForIcon$orBundleID$(Class self, SEL _cmd, SBIcon* arg1, NSString* arg2) {
    NSString *bundleIdentifier;
    if (arg1)
        bundleIdentifier = [arg1 applicationBundleID];
    else
        bundleIdentifier = arg2;

    return [widgetViewControllers objectForKey:bundleIdentifier];
}



static void _logos_method$_ungrouped$IBKIconView$addPreExpandedWidgetIfNeeded$(IBKIconView* self, SEL _cmd, id arg1) {
    SBApplicationIcon *icon = (SBApplicationIcon*)arg1;

    if (!icon) {
        icon = (SBApplicationIcon*)self.icon;
    }

    if (!inSwitcher) {
        if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]]) {

            
            IBKWidgetViewController *widgetController;
            if (![widgetViewControllers objectForKey:[icon applicationBundleID]]) {
                widgetController = [[IBKWidgetViewController alloc] init];
                widgetController.applicationIdentifer = [icon applicationBundleID];
                [widgetController layoutViewForPreExpandedWidget]; 
            } else {
                widgetController = [widgetViewControllers objectForKey:[icon applicationBundleID]];
            }

            
            [self addSubview:widgetController.view];

            if (!widgetViewControllers)
                widgetViewControllers = [NSMutableDictionary dictionary];

                if ([icon applicationBundleID] && ![widgetViewControllers objectForKey:[icon applicationBundleID]])
                    [widgetViewControllers setObject:widgetController forKey:[icon applicationBundleID]]; 

            
            [(UIImageView*)[self _iconImageView] setAlpha:0.0];
            widgetController.correspondingIconView = self;

            widgetController.view.layer.shadowOpacity = 0.0;
            widgetController.shimIcon.alpha = 0.0;
            widgetController.shimIcon.hidden = YES;

            if ([IBKResources hoverOnly]) {
                widgetController.view.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
                widgetController.view.layer.shadowOpacity = 0.3;
            }
        }

        
        
    }

}





#pragma mark Handle de-caching indexes when in editing mode



static void _logos_method$_ungrouped$SBIconController$setIsEditing$(SBIconController* self, SEL _cmd, BOOL arg1) {
    rearrangingIcons = arg1;

    _logos_orig$_ungrouped$SBIconController$setIsEditing$(self, _cmd, arg1);

    if (arg1) {
        
            [cachedIndexes removeAllObjects];
        
            [cachedIndexesLandscape removeAllObjects];
    }
}



static BOOL _logos_method$_ungrouped$SBIconController$ibkIsInSwitcher(SBIconController* self, SEL _cmd) {
    return inSwitcher;
}



static void _logos_method$_ungrouped$SBIconController$removeIdentifierFromWidgets$(SBIconController* self, SEL _cmd, NSString* identifier) {
    [widgetViewControllers removeObjectForKey:identifier];
}



static void _logos_method$_ungrouped$SBIconController$removeAllCachedIcons(SBIconController* self, SEL _cmd) {
    if (currentOrientation == 1 || currentOrientation == 2)
        [cachedIndexes removeAllObjects];
    else if (currentOrientation == 3 || currentOrientation == 4)
        [cachedIndexesLandscape removeAllObjects];
}



#pragma mark Handle pinching of icons

IBKWidgetViewController *widget;
SBIcon *widgetIcon;



@interface SBIconScrollView (Additions2)
-(void)handlePinchGesture:(UIPinchGestureRecognizer*)pinch;
@end

@interface SBIconScrollView (Additions)
-(SBIconListView *)IBKListViewForIdentifierTwo:(NSString*)identifier;
@end

UIPinchGestureRecognizer *pinch;
NSObject *panGesture;



static UIScrollView* _logos_method$_ungrouped$SBIconScrollView$initWithFrame$(SBIconScrollView* self, SEL _cmd, CGRect frame) {
    UIScrollView *orig = _logos_orig$_ungrouped$SBIconScrollView$initWithFrame$(self, _cmd, frame);

    NSLog(@"*** [Curago] :: Adding pinch gesture onto SBIconScrollView");

    pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [(UIView*)orig addGestureRecognizer:pinch];

    for (UIGestureRecognizer *arg in [self gestureRecognizers]) {
        if ([[arg class] isEqual:[objc_getClass("UIScrollViewPanGestureRecognizer") class]]) {
            arg.delegate = self;
            panGesture = arg;
        } else if ([[arg class] isEqual:[objc_getClass("UIScrollViewPinchGestureRecognizer") class]]) {
            [orig removeGestureRecognizer:arg];
        }
    }

    return orig;
}

static void _logos_method$_ungrouped$SBIconScrollView$_updatePagingGesture(SBIconScrollView* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBIconScrollView$_updatePagingGesture(self, _cmd);

    for (UIGestureRecognizer *arg in [self gestureRecognizers]) {
        if ([[arg class] isEqual:[objc_getClass("UIScrollViewPanGestureRecognizer") class]]) {
            arg.delegate = self;
            panGesture = arg;
        } else if ([[arg class] isEqual:[objc_getClass("UIScrollViewPinchGestureRecognizer") class]]) {
            [self removeGestureRecognizer:arg];
        } else if ([[arg class] isEqual:[objc_getClass("UIScrollViewPagingSwipeGestureRecognizer") class]]) {
            [arg requireGestureRecognizerToFail:pinch];
        }
    }
}

static void _logos_method$_ungrouped$SBIconScrollView$layoutSubviews(SBIconScrollView* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBIconScrollView$layoutSubviews(self, _cmd);

    

    if ([IBKResources hoverOnly]) {
        for (NSString *key in [widgetViewControllers allKeys]) {
            IBKWidgetViewController *contr = [widgetViewControllers objectForKey:key];
            UIView *view = contr.view;

            [[view superview] addSubview:view];
        }
    }
}



static BOOL _logos_method$_ungrouped$SBIconScrollView$gestureRecognizerShouldBegin$(SBIconScrollView* self, SEL _cmd, UIGestureRecognizer * gestureRecognizer) {
    BOOL isPan = [gestureRecognizer isEqual:panGesture];

    if (isPan && gestureRecognizer.numberOfTouches > 1) {
        return NO;
    } else {
        return YES;
    }
}



static BOOL _logos_method$_ungrouped$SBIconScrollView$gestureRecognizer$shouldRequireFailureOfGestureRecognizer$(SBIconScrollView* self, SEL _cmd, UIGestureRecognizer* gestureRecognizer, UIGestureRecognizer* recTwo) {
    if ([recTwo isEqual:pinch] && gestureRecognizer.numberOfTouches > 1) {
        return YES;
    } else {
        return NO;
    }
}



int scale = 0;
NSInteger page = 0;
static void _logos_method$_ungrouped$SBIconScrollView$handlePinchGesture$(SBIconScrollView* self, SEL _cmd, UIPinchGestureRecognizer* pinch) {
    
    if ([[objc_getClass("SBIconController") sharedInstance] hasOpenFolder]) return;

    if (pinch.state == UIGestureRecognizerStateBegan) {
         NSLog(@"Pinching began");
        

        
        CGFloat width = self.frame.size.width;
        page = (self.contentOffset.x + (0.5f * width)) / width;
        CGPoint rawMidpoint = [pinch locationInView:(UIView*)self];
        CGPoint finalMidpoint = CGPointMake(rawMidpoint.x - (page * width), rawMidpoint.y);
        NSLog(@"*** final midpoint == %@", NSStringFromCGPoint(finalMidpoint));

        
        SBIconListView *listView;
        [[objc_getClass("SBIconController") sharedInstance] getListView:&listView folder:nil relativePath:nil forIndexPath:[NSIndexPath indexPathForRow:1 inSection:page] createIfNecessary:NO];

        
        unsigned int index;
        widgetIcon = [listView iconAtPoint:finalMidpoint index:&index];
        NSLog(@"Widget icon == %@", widgetIcon);

        

        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) {
            widget = nil;
            return;
        }

        
        if ([widgetViewControllers objectForKey:[widgetIcon applicationBundleID]]) {
            widget = nil;
            return;
        }

        
        widget = [[IBKWidgetViewController alloc] init];
        widget.applicationIdentifer = [widgetIcon applicationBundleID];

        if (!widgetViewControllers)
            widgetViewControllers = [NSMutableDictionary dictionary];

        if ([widgetIcon applicationBundleID])
            [widgetViewControllers setObject:widget forKey:[widgetIcon applicationBundleID]];

        
        IBKIconView *view = [[objc_getClass("SBIconViewMap") homescreenMap] iconViewForIcon:widgetIcon];
        [view addSubview:widget.view];
        [view.superview addSubview:view]; 

        widget.correspondingIconView = view;

        [[(SBIconView*)view _iconImageView] setAlpha:0.0];

        widget.view.transform = CGAffineTransformMakeScale(1.0, 1.0);

        [widget loadWidgetInterface];

        widget.view.center = CGPointMake(([(UIView*)[view _iconImageView] frame].size.width/2)-1, ([(UIView*)[view _iconImageView] frame].size.height/2)-1);

        CGFloat iconScale = (isPad ? 72 : 60) / [IBKResources heightForWidget];

        NSLog(@"BEGINNING SCALE IS %f", iconScale);

        widget.view.transform = CGAffineTransformMakeScale(iconScale, iconScale);
    } else if (pinch.state == UIGestureRecognizerStateChanged && widget) {
         NSLog(@"Pinching changed");
        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) return;

        

        CGFloat duration = (pinch.scale/pinch.velocity);

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            duration = (pinch.scale-1)/pinch.velocity;
            
        }

        if (duration < 0)
            duration = -duration;

        scale = pinch.scale;

        [widget setScaleForView:pinch.scale withDuration:0.1];
    } else if (pinch.state == UIGestureRecognizerStateEnded && widget) {
         NSLog(@"Pinching ended");
        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) return;
         
         
         

        if ((scale-1.0) > 0.75) { 
            [widget setScaleForView:8.0 withDuration:0.3];
            [IBKResources addNewIdentifier:[widgetIcon applicationBundleID]];

            if ([IBKResources hoverOnly]) {
                return;
            }

            
            if (currentOrientation == 1 || currentOrientation == 2)
                [cachedIndexes removeAllObjects];
            else if (currentOrientation == 3 || currentOrientation == 4)
                [cachedIndexesLandscape removeAllObjects];

            

            SBIconListView *lst = [self IBKListViewForIdentifierTwo:widget.applicationIdentifer];

            
            int count = 0;

            for (SBIcon *icon in [lst icons]) {
                if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]])
                    count += 3;
            }

            if ([lst icons].count + count > [objc_getClass("SBIconListView") maxIcons]) {
                

                count = ((int)[lst icons].count + count) - (int)[objc_getClass("SBIconListView") maxIcons];

                

                rearrangingIcons = YES;

                NSMutableArray *arr = [NSMutableArray array];

                for (int i = (int)[lst icons].count - 1; i > (int)[lst icons].count - 1 - count; --i) {
                    [arr addObject:[[lst icons] objectAtIndex:i]];
                }

                NSLog(@"Arr is %@", arr);

                

                SBIconListView *listView;
                [[objc_getClass("SBIconController") sharedInstance] getListView:&listView folder:nil relativePath:nil forIndexPath:[NSIndexPath indexPathForRow:0 inSection:page + 1] createIfNecessary:YES];

                for (SBIcon *icon in arr) {
                    NSLog(@"Icon is %@", icon);

                    [[lst model] removeIcon:icon];
                    

                    [listView insertIcon:icon atIndex:0 moveNow:YES pop:YES];
                    
                    

                    [listView setIconsNeedLayout];
                    [listView layoutIconsIfNeeded:0.0 domino:NO];

                    

                    
                }

                if ([[[objc_getClass("SBIconController") sharedInstance] model] respondsToSelector:@selector(saveIconStateIfNeeded)])
                    [(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] saveIconStateIfNeeded];
                else
                    [(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] saveIconState];

                rearrangingIcons = NO;
            }

            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                
                [lst setIconsNeedLayout];
                [lst layoutIconsIfNeeded:0.3 domino:NO];
            } else
                [(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.3 domino:NO forceRelayout:YES];

            
            CGRect widgetViewFrame = widget.correspondingIconView.frame;
            widgetViewFrame.size = CGSizeMake([IBKResources widthForWidget], [IBKResources heightForWidget]);
            [UIView animateWithDuration:0.3 animations:^{
                widget.view.frame = CGRectMake(0, 0, [IBKResources widthForWidget], [IBKResources heightForWidget]);
                widget.view.layer.shadowOpacity = 0.0;

                [(SBIconImageView*)[widget.correspondingIconView _iconImageView] setFrame:widgetViewFrame];

                
            }];
        } else {
            CGFloat iconScale = (isPad ? 72 : 60) / [IBKResources heightForWidget];

            CGFloat red, green, blue;
            [widget.view.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];

            [UIView animateWithDuration:0.25 animations:^{
                widget.view.transform = CGAffineTransformMakeScale(iconScale, iconScale);
                widget.shimIcon.alpha = 1.0;
                widget.viw.alpha = 0.0;
                widget.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.0];
            } completion:^(BOOL finished) {
                [widget unloadFromPinchGesture];
                if (widget && widget.applicationIdentifer) [widgetViewControllers removeObjectForKey:widget.applicationIdentifer];
                [[(SBIconView*)widget.correspondingIconView _iconImageView] setAlpha:1.0];
            }];
        }
    } else if (pinch.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"PINCHING WAS CANCELLED");

        CGFloat scale = (isPad ? 72 : 60) / [IBKResources heightForWidget];

        [UIView animateWithDuration:0.3 animations:^{
            widget.view.transform = CGAffineTransformMakeScale(scale, scale);
            widget.view.center = CGPointMake(([(UIView*)[widget.correspondingIconView _iconImageView] frame].size.width/2)-1, ([(UIView*)[widget.correspondingIconView _iconImageView] frame].size.height/2)-1);
            widget.shimIcon.alpha = 1.0;

            widget.iconImageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [[widget.correspondingIconView _iconImageView] setAlpha:1.0];
            widget.view.hidden = YES;
            [widget unloadFromPinchGesture];

            if (widget && widget.applicationIdentifer) [widgetViewControllers removeObjectForKey:widget.applicationIdentifer];
        }];

    }
}



static SBIconListView * _logos_method$_ungrouped$SBIconScrollView$IBKListViewForIdentifierTwo$(SBIconScrollView* self, SEL _cmd, NSString* identifier) {
    SBIconController *viewcont = [objc_getClass("SBIconController") sharedInstance];
    SBIconModel *model = [viewcont model];
    SBIcon *icon = [model expectedIconForDisplayIdentifier:identifier];

    SBIconController *controller = [objc_getClass("SBIconController") sharedInstance];
    SBRootFolder *rootFolder = [controller valueForKeyPath:@"rootFolder"];
    NSIndexPath *indexPath = [rootFolder indexPathForIcon:icon];
    SBIconListView *listView = nil;
    [controller getListView:&listView folder:NULL relativePath:NULL forIndexPath:indexPath createIfNecessary:YES];
    return listView;
}



#pragma mark Icon badge handling



static SBIcon *temp;

static void _logos_method$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$(SBIconBadgeView* self, SEL _cmd, SBIcon* arg1, int arg2, BOOL arg3) {
    temp = arg1;

    _logos_orig$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$(self, _cmd, arg1, arg2, arg3);

    if ([[IBKResources widgetBundleIdentifiers] containsObject:[arg1 applicationBundleID]] && !inSwitcher) {
        
        [[self superview] addSubview:self]; 
    }

}

static struct CGPoint _logos_method$_ungrouped$SBIconBadgeView$accessoryOriginForIconBounds$(SBIconBadgeView* self, SEL _cmd, CGRect arg1) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[temp applicationBundleID]] && !inSwitcher) {
        
        IBKWidgetViewController *contr = [widgetViewControllers objectForKey:[temp applicationBundleID]];
        arg1 = contr.view.bounds;

        

        [[self superview] addSubview:self]; 
    }

    return _logos_orig$_ungrouped$SBIconBadgeView$accessoryOriginForIconBounds$(self, _cmd, arg1);
}

static void _logos_method$_ungrouped$SBIconBadgeView$layoutSubviews(SBIconBadgeView* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBIconBadgeView$layoutSubviews(self, _cmd);

    [[self superview] addSubview:self]; 
}



#pragma mark Close button handling

@interface SBCloseBoxView : UIView
@end



static void _logos_method$_ungrouped$SBCloseBoxView$layoutSubviews(SBCloseBoxView* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBCloseBoxView$layoutSubviews(self, _cmd);

    [[self superview] addSubview:self]; 
}



#pragma mark Handle uninstallation of apps



static void _logos_method$_ungrouped$SBApplication$prepareForUninstallation(SBApplication* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBApplication$prepareForUninstallation(self, _cmd);

    NSString *bundleId;
    if ([self respondsToSelector:@selector(bundleIdentifier)]) {
        bundleId = [self bundleIdentifier];
    } else {
        bundleId = [self displayIdentifier];
    }

    IBKWidgetViewController *contr = [widgetViewControllers objectForKey:bundleId];
    [widgetViewControllers removeObjectForKey:bundleId];
    [contr unloadWidgetInterface];
    contr = nil;

    [IBKResources removeIdentifier:bundleId];
}



#pragma mark Handle re-locking widgets when locking



static void _logos_method$_ungrouped$SBLockScreenManager$lockUIFromSource$withOptions$(SBLockScreenManager* self, SEL _cmd, int arg1, id arg2) {
    _logos_orig$_ungrouped$SBLockScreenManager$lockUIFromSource$withOptions$(self, _cmd, arg1, arg2);

    if ([IBKResources relockWidgets] || allWidgetsNeedLocking) {
        for (NSString *key in [widgetViewControllers allKeys]) {
            IBKWidgetViewController *contr = [widgetViewControllers objectForKey:key];
            [contr lockWidget];
        }

        allWidgetsNeedLocking = NO;
    }
}



#pragma mark BBServer hooks for notification tables



static id _logos_method$_ungrouped$BBServer$init(BBServer* self, SEL _cmd) {
    BBServer *orig = _logos_orig$_ungrouped$BBServer$init(self, _cmd);
    IBKBBServer = orig;
    return orig;
}

static void _logos_method$_ungrouped$BBServer$_addBulletin$(BBServer* self, SEL _cmd, BBBulletin* arg1) {
    IBKWidgetViewController *contr = [widgetViewControllers objectForKey:[arg1 sectionID]];
    if (contr)
        [contr addBulletin:arg1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@/notificationrecieved", [arg1 sectionID]] object:arg1];

    _logos_orig$_ungrouped$BBServer$_addBulletin$(self, _cmd, arg1);
}

static void _logos_method$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$(BBServer* self, SEL _cmd, id arg1, BOOL arg2, BOOL arg3) {
    for (NSString *key in widgetViewControllers) {
        if ([[(IBKWidgetViewController*)[widgetViewControllers objectForKey:key] applicationIdentifer] isEqual:[arg1 sectionID]])
            [(IBKWidgetViewController*)[widgetViewControllers objectForKey:key] removeBulletin:arg1];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@/notificationremoved", [arg1 sectionID]] object:arg1];

    _logos_orig$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$(self, _cmd, arg1, arg2, arg3);
}



static id _logos_meta_method$_ungrouped$BBServer$sharedIBKBBServer(Class self, SEL _cmd) {
    return IBKBBServer;
}



#pragma mark Media data handling



static void _logos_method$_ungrouped$SBMediaController$_nowPlayingInfoChanged(SBMediaController* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBMediaController$_nowPlayingInfoChanged(self, _cmd);

    [[NSNotificationCenter defaultCenter] postNotificationName:@"IBK-UpdateMusic" object:nil];
}



#pragma mark IOS 8 stuff

static id _logos_method$iOS8$SBIconImageView$alternateIconView(SBIconImageView*, SEL); 




static id _logos_method$iOS8$SBIconImageView$alternateIconView(SBIconImageView* self, SEL _cmd) {
    return nil; 
}





#pragma mark iWidgets fixes

static _Bool (*_logos_orig$iWidgets$IWWidgetsView$pointInside$withEvent$)(IWWidgetsView*, SEL, struct CGPoint, id); static _Bool _logos_method$iWidgets$IWWidgetsView$pointInside$withEvent$(IWWidgetsView*, SEL, struct CGPoint, id); 



static _Bool _logos_method$iWidgets$IWWidgetsView$pointInside$withEvent$(IWWidgetsView* self, SEL _cmd, struct CGPoint arg1, id arg2) {
    iWidgets = YES;
    BOOL original = _logos_orig$iWidgets$IWWidgetsView$pointInside$withEvent$(self, _cmd, arg1, arg2);
    iWidgets = NO;

    return original;
}





#pragma mark Settings callbacks

static void settingsChangedForWidget(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [IBKResources reloadSettings];

    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];

    
    IBKWidgetViewController *controller = [widgetViewControllers objectForKey:[dict objectForKey:@"changedBundleIdFromSettings"]];
    [controller reloadWidgetForSettingsChange];
}

static void reloadAllWidgets(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    
    [IBKResources reloadSettings];

    for (NSString *key in [widgetViewControllers allKeys]) {
        IBKWidgetViewController *controller = [widgetViewControllers objectForKey:key];
        [controller reloadWidgetForSettingsChange];
    }
}

static void changedLockAll(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSLog(@"RECIEVED LOCK ALL");

    [IBKResources reloadSettings];

    for (NSString *key in [widgetViewControllers allKeys]) {
        IBKWidgetViewController *controller = [widgetViewControllers objectForKey:key];
        [controller reloadWidgetForSettingsChange];
    }
}

static void reloadSettings(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [IBKResources reloadSettings];
}

#pragma mark Constructor and anti-piracy code

@interface ISIconSupport : NSObject
+(instancetype)sharedInstance;
-(void)addExtension:(NSString*)arg1;
@end

static __attribute__((constructor)) void _logosLocalCtor_26a84aca() {

    
    Class $IBKIconView = objc_allocateClassPair(objc_getClass("SBIconView"), "IBKIconView", 0);

    objc_registerClassPair($IBKIconView);

    
    {Class _logos_class$_ungrouped$SBIconListView = objc_getClass("SBIconListView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(isFull), (IMP)&_logos_method$_ungrouped$SBIconListView$isFull, (IMP*)&_logos_orig$_ungrouped$SBIconListView$isFull);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(prepareToRotateToInterfaceOrientation:), (IMP)&_logos_method$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(cleanupAfterRotation), (IMP)&_logos_method$_ungrouped$SBIconListView$cleanupAfterRotation, (IMP*)&_logos_orig$_ungrouped$SBIconListView$cleanupAfterRotation);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(rowAtPoint:), (IMP)&_logos_method$_ungrouped$SBIconListView$rowAtPoint$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$rowAtPoint$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(columnAtPoint:), (IMP)&_logos_method$_ungrouped$SBIconListView$columnAtPoint$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$columnAtPoint$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(iconAtPoint:index:proposedOrder:grabbedIcon:), (IMP)&_logos_method$_ungrouped$SBIconListView$iconAtPoint$index$proposedOrder$grabbedIcon$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$iconAtPoint$index$proposedOrder$grabbedIcon$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(indexForCoordinate:forOrientation:), (IMP)&_logos_method$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(iconCoordinateForIndex:forOrientation:), (IMP)&_logos_method$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(SBIconCoordinate), strlen(@encode(SBIconCoordinate))); i += strlen(@encode(SBIconCoordinate)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = 'I'; i += 1; memcpy(_typeEncoding + i, @encode(SBIconCoordinate), strlen(@encode(SBIconCoordinate))); i += strlen(@encode(SBIconCoordinate)); _typeEncoding[i] = 'i'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconListView, @selector(coordinateForIconWithIndex:andOriginalCoordinate:forOrientation:), (IMP)&_logos_method$_ungrouped$SBIconListView$coordinateForIconWithIndex$andOriginalCoordinate$forOrientation$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(SBIcon*), strlen(@encode(SBIcon*))); i += strlen(@encode(SBIcon*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(SBIcon*), strlen(@encode(SBIcon*))); i += strlen(@encode(SBIcon*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconListView, @selector(modifiedIconForIcon:), (IMP)&_logos_method$_ungrouped$SBIconListView$modifiedIconForIcon$, _typeEncoding); }Class _logos_class$_ungrouped$SBAppSliderController = objc_getClass("SBAppSliderController"); MSHookMessageEx(_logos_class$_ungrouped$SBAppSliderController, @selector(switcherWasDismissed:), (IMP)&_logos_method$_ungrouped$SBAppSliderController$switcherWasDismissed$, (IMP*)&_logos_orig$_ungrouped$SBAppSliderController$switcherWasDismissed$);Class _logos_class$_ungrouped$SBUIController = objc_getClass("SBUIController"); MSHookMessageEx(_logos_class$_ungrouped$SBUIController, @selector(_activateSwitcher), (IMP)&_logos_method$_ungrouped$SBUIController$_activateSwitcher, (IMP*)&_logos_orig$_ungrouped$SBUIController$_activateSwitcher);Class _logos_class$_ungrouped$SBAppSwitcherController = objc_getClass("SBAppSwitcherController"); MSHookMessageEx(_logos_class$_ungrouped$SBAppSwitcherController, @selector(switcherWasDismissed:), (IMP)&_logos_method$_ungrouped$SBAppSwitcherController$switcherWasDismissed$, (IMP*)&_logos_orig$_ungrouped$SBAppSwitcherController$switcherWasDismissed$);Class _logos_class$_ungrouped$SBApplication = objc_getClass("SBApplication"); MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(willAnimateDeactivation:), (IMP)&_logos_method$_ungrouped$SBApplication$willAnimateDeactivation$, (IMP*)&_logos_orig$_ungrouped$SBApplication$willAnimateDeactivation$);MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(didAnimateDeactivation), (IMP)&_logos_method$_ungrouped$SBApplication$didAnimateDeactivation, (IMP*)&_logos_orig$_ungrouped$SBApplication$didAnimateDeactivation);MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(willActivateWithTransactionID:), (IMP)&_logos_method$_ungrouped$SBApplication$willActivateWithTransactionID$, (IMP*)&_logos_orig$_ungrouped$SBApplication$willActivateWithTransactionID$);MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(didActivateWithTransactionID:), (IMP)&_logos_method$_ungrouped$SBApplication$didActivateWithTransactionID$, (IMP*)&_logos_orig$_ungrouped$SBApplication$didActivateWithTransactionID$);MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(didAnimateActivation), (IMP)&_logos_method$_ungrouped$SBApplication$didAnimateActivation, (IMP*)&_logos_orig$_ungrouped$SBApplication$didAnimateActivation);MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(willAnimateActivation), (IMP)&_logos_method$_ungrouped$SBApplication$willAnimateActivation, (IMP*)&_logos_orig$_ungrouped$SBApplication$willAnimateActivation);MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(prepareForUninstallation), (IMP)&_logos_method$_ungrouped$SBApplication$prepareForUninstallation, (IMP*)&_logos_orig$_ungrouped$SBApplication$prepareForUninstallation);Class _logos_class$_ungrouped$SBIconViewMap = objc_getClass("SBIconViewMap"); MSHookMessageEx(_logos_class$_ungrouped$SBIconViewMap, @selector(mappedIconViewForIcon:), (IMP)&_logos_method$_ungrouped$SBIconViewMap$mappedIconViewForIcon$, (IMP*)&_logos_orig$_ungrouped$SBIconViewMap$mappedIconViewForIcon$);Class _logos_class$_ungrouped$SBIconView = objc_getClass("SBIconView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconView, @selector(initWithDefaultSize), (IMP)&_logos_method$_ungrouped$SBIconView$initWithDefaultSize, (IMP*)&_logos_orig$_ungrouped$SBIconView$initWithDefaultSize);Class _logos_class$_ungrouped$SBIconImageView = objc_getClass("SBIconImageView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconImageView, @selector(visibleBounds), (IMP)&_logos_method$_ungrouped$SBIconImageView$visibleBounds, (IMP*)&_logos_orig$_ungrouped$SBIconImageView$visibleBounds);MSHookMessageEx(_logos_class$_ungrouped$SBIconImageView, @selector(frame), (IMP)&_logos_method$_ungrouped$SBIconImageView$frame, (IMP*)&_logos_orig$_ungrouped$SBIconImageView$frame);MSHookMessageEx(_logos_class$_ungrouped$SBIconImageView, @selector(bounds), (IMP)&_logos_method$_ungrouped$SBIconImageView$bounds, (IMP*)&_logos_orig$_ungrouped$SBIconImageView$bounds);Class _logos_class$_ungrouped$IBKIconView = objc_getClass("IBKIconView"); Class _logos_metaclass$_ungrouped$IBKIconView = object_getClass(_logos_class$_ungrouped$IBKIconView); MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(iconImageCenter), (IMP)&_logos_method$_ungrouped$IBKIconView$iconImageCenter, (IMP*)&_logos_orig$_ungrouped$IBKIconView$iconImageCenter);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(iconImageFrame), (IMP)&_logos_method$_ungrouped$IBKIconView$iconImageFrame, (IMP*)&_logos_orig$_ungrouped$IBKIconView$iconImageFrame);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(prepareToCrossfadeImageWithView:maskCorners:trueCrossfade:anchorPoint:), (IMP)&_logos_method$_ungrouped$IBKIconView$prepareToCrossfadeImageWithView$maskCorners$trueCrossfade$anchorPoint$, (IMP*)&_logos_orig$_ungrouped$IBKIconView$prepareToCrossfadeImageWithView$maskCorners$trueCrossfade$anchorPoint$);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(iconImageSnapshot), (IMP)&_logos_method$_ungrouped$IBKIconView$iconImageSnapshot, (IMP*)&_logos_orig$_ungrouped$IBKIconView$iconImageSnapshot);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(frame), (IMP)&_logos_method$_ungrouped$IBKIconView$frame, (IMP*)&_logos_orig$_ungrouped$IBKIconView$frame);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(_setIcon:animated:), (IMP)&_logos_method$_ungrouped$IBKIconView$_setIcon$animated$, (IMP*)&_logos_orig$_ungrouped$IBKIconView$_setIcon$animated$);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(_frameForLabel), (IMP)&_logos_method$_ungrouped$IBKIconView$_frameForLabel, (IMP*)&_logos_orig$_ungrouped$IBKIconView$_frameForLabel);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(prepareForRecycling), (IMP)&_logos_method$_ungrouped$IBKIconView$prepareForRecycling, (IMP*)&_logos_orig$_ungrouped$IBKIconView$prepareForRecycling);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(pointInside:withEvent:), (IMP)&_logos_method$_ungrouped$IBKIconView$pointInside$withEvent$, (IMP*)&_logos_orig$_ungrouped$IBKIconView$pointInside$withEvent$);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(addSubview:), (IMP)&_logos_method$_ungrouped$IBKIconView$addSubview$, (IMP*)&_logos_orig$_ungrouped$IBKIconView$addSubview$);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(IBKWidgetViewController*), strlen(@encode(IBKWidgetViewController*))); i += strlen(@encode(IBKWidgetViewController*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(SBIcon*), strlen(@encode(SBIcon*))); i += strlen(@encode(SBIcon*)); memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$_ungrouped$IBKIconView, @selector(getWidgetViewControllerForIcon:orBundleID:), (IMP)&_logos_meta_method$_ungrouped$IBKIconView$getWidgetViewControllerForIcon$orBundleID$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$IBKIconView, @selector(addPreExpandedWidgetIfNeeded:), (IMP)&_logos_method$_ungrouped$IBKIconView$addPreExpandedWidgetIfNeeded$, _typeEncoding); }Class _logos_class$_ungrouped$SBIconController = objc_getClass("SBIconController"); MSHookMessageEx(_logos_class$_ungrouped$SBIconController, @selector(setIsEditing:), (IMP)&_logos_method$_ungrouped$SBIconController$setIsEditing$, (IMP*)&_logos_orig$_ungrouped$SBIconController$setIsEditing$);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconController, @selector(ibkIsInSwitcher), (IMP)&_logos_method$_ungrouped$SBIconController$ibkIsInSwitcher, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconController, @selector(removeIdentifierFromWidgets:), (IMP)&_logos_method$_ungrouped$SBIconController$removeIdentifierFromWidgets$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconController, @selector(removeAllCachedIcons), (IMP)&_logos_method$_ungrouped$SBIconController$removeAllCachedIcons, _typeEncoding); }Class _logos_class$_ungrouped$SBIconScrollView = objc_getClass("SBIconScrollView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconScrollView, @selector(initWithFrame:), (IMP)&_logos_method$_ungrouped$SBIconScrollView$initWithFrame$, (IMP*)&_logos_orig$_ungrouped$SBIconScrollView$initWithFrame$);MSHookMessageEx(_logos_class$_ungrouped$SBIconScrollView, @selector(_updatePagingGesture), (IMP)&_logos_method$_ungrouped$SBIconScrollView$_updatePagingGesture, (IMP*)&_logos_orig$_ungrouped$SBIconScrollView$_updatePagingGesture);MSHookMessageEx(_logos_class$_ungrouped$SBIconScrollView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$SBIconScrollView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$SBIconScrollView$layoutSubviews);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIGestureRecognizer *), strlen(@encode(UIGestureRecognizer *))); i += strlen(@encode(UIGestureRecognizer *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconScrollView, @selector(gestureRecognizerShouldBegin:), (IMP)&_logos_method$_ungrouped$SBIconScrollView$gestureRecognizerShouldBegin$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIGestureRecognizer*), strlen(@encode(UIGestureRecognizer*))); i += strlen(@encode(UIGestureRecognizer*)); memcpy(_typeEncoding + i, @encode(UIGestureRecognizer*), strlen(@encode(UIGestureRecognizer*))); i += strlen(@encode(UIGestureRecognizer*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconScrollView, @selector(gestureRecognizer:shouldRequireFailureOfGestureRecognizer:), (IMP)&_logos_method$_ungrouped$SBIconScrollView$gestureRecognizer$shouldRequireFailureOfGestureRecognizer$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIPinchGestureRecognizer*), strlen(@encode(UIPinchGestureRecognizer*))); i += strlen(@encode(UIPinchGestureRecognizer*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconScrollView, @selector(handlePinchGesture:), (IMP)&_logos_method$_ungrouped$SBIconScrollView$handlePinchGesture$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(SBIconListView *), strlen(@encode(SBIconListView *))); i += strlen(@encode(SBIconListView *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconScrollView, @selector(IBKListViewForIdentifierTwo:), (IMP)&_logos_method$_ungrouped$SBIconScrollView$IBKListViewForIdentifierTwo$, _typeEncoding); }Class _logos_class$_ungrouped$SBIconBadgeView = objc_getClass("SBIconBadgeView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconBadgeView, @selector(configureForIcon:location:highlighted:), (IMP)&_logos_method$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$, (IMP*)&_logos_orig$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$);MSHookMessageEx(_logos_class$_ungrouped$SBIconBadgeView, @selector(accessoryOriginForIconBounds:), (IMP)&_logos_method$_ungrouped$SBIconBadgeView$accessoryOriginForIconBounds$, (IMP*)&_logos_orig$_ungrouped$SBIconBadgeView$accessoryOriginForIconBounds$);MSHookMessageEx(_logos_class$_ungrouped$SBIconBadgeView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$SBIconBadgeView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$SBIconBadgeView$layoutSubviews);Class _logos_class$_ungrouped$SBCloseBoxView = objc_getClass("SBCloseBoxView"); MSHookMessageEx(_logos_class$_ungrouped$SBCloseBoxView, @selector(layoutSubviews), (IMP)&_logos_method$_ungrouped$SBCloseBoxView$layoutSubviews, (IMP*)&_logos_orig$_ungrouped$SBCloseBoxView$layoutSubviews);Class _logos_class$_ungrouped$SBLockScreenManager = objc_getClass("SBLockScreenManager"); MSHookMessageEx(_logos_class$_ungrouped$SBLockScreenManager, @selector(lockUIFromSource:withOptions:), (IMP)&_logos_method$_ungrouped$SBLockScreenManager$lockUIFromSource$withOptions$, (IMP*)&_logos_orig$_ungrouped$SBLockScreenManager$lockUIFromSource$withOptions$);Class _logos_class$_ungrouped$BBServer = objc_getClass("BBServer"); Class _logos_metaclass$_ungrouped$BBServer = object_getClass(_logos_class$_ungrouped$BBServer); MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(init), (IMP)&_logos_method$_ungrouped$BBServer$init, (IMP*)&_logos_orig$_ungrouped$BBServer$init);MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(_addBulletin:), (IMP)&_logos_method$_ungrouped$BBServer$_addBulletin$, (IMP*)&_logos_orig$_ungrouped$BBServer$_addBulletin$);MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(_removeBulletin:rescheduleTimerIfAffected:shouldSync:), (IMP)&_logos_method$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$, (IMP*)&_logos_orig$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$_ungrouped$BBServer, @selector(sharedIBKBBServer), (IMP)&_logos_meta_method$_ungrouped$BBServer$sharedIBKBBServer, _typeEncoding); }Class _logos_class$_ungrouped$SBMediaController = objc_getClass("SBMediaController"); MSHookMessageEx(_logos_class$_ungrouped$SBMediaController, @selector(_nowPlayingInfoChanged), (IMP)&_logos_method$_ungrouped$SBMediaController$_nowPlayingInfoChanged, (IMP*)&_logos_orig$_ungrouped$SBMediaController$_nowPlayingInfoChanged);}

    dlopen("/Library/MobileSubstrate/DynamicLibraries/IconSupport.dylib", RTLD_NOW);
    dlopen("/Library/MobileSubstrate/DynamicLibraries/iWidgets.dylib", RTLD_NOW);
    [[objc_getClass("ISIconSupport") sharedInstance] addExtension:@"com.matchstic.curago"];

    

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {Class _logos_class$iOS8$SBIconImageView = objc_getClass("SBIconImageView"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$iOS8$SBIconImageView, @selector(alternateIconView), (IMP)&_logos_method$iOS8$SBIconImageView$alternateIconView, _typeEncoding); }}

    {Class _logos_class$iWidgets$IWWidgetsView = objc_getClass("IWWidgetsView"); MSHookMessageEx(_logos_class$iWidgets$IWWidgetsView, @selector(pointInside:withEvent:), (IMP)&_logos_method$iWidgets$IWWidgetsView$pointInside$withEvent$, (IMP*)&_logos_orig$iWidgets$IWWidgetsView$pointInside$withEvent$);}

    [IBKResources reloadSettings];

    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChangedForWidget, CFSTR("com.matchstic.ibk/settingschangeforwidget"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, reloadAllWidgets, CFSTR("com.matchstic.ibk/reloadallwidgets"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, reloadSettings, CFSTR("com.matchstic.ibk/reloadsettings"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, changedLockAll, CFSTR("com.matchstic.ibk/changedlockall"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
