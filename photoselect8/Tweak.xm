#import <UIKit/UIKit.h>
@interface UIGestureRecognizer (PhotoSelect8)
-(void)_setCanPanVertically:(BOOL)arg1;
@end
@interface UICollectionView (PhotoSelect8)
-(void)_userSelectItemAtIndexPath:(NSIndexPath *)arg1;
@end

@interface PHFetchResult : NSObject
@end

@interface PUPhotoSelectionManager : NSObject
- (void)selectAssetAtIndex:(unsigned int)arg1 inAssetCollection:(id)arg2;
@end

@interface PUPhotosGridViewController : UICollectionViewController
@property (setter=_setPhotoSelectionManager:, nonatomic, retain) PUPhotoSelectionManager *photoSelectionManager;
@property (nonatomic, readonly) PHFetchResult *assetCollectionsFetchResult;
@end

@interface PUPhotosAlbumViewController : PUPhotosGridViewController<UIGestureRecognizerDelegate>
@property (nonatomic, retain) UICollectionView *collectionView;
-(void)setUpPhotoSwipe;
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer;
- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer;
@end
@interface PUZoomableGridViewController : PUPhotosGridViewController<UIGestureRecognizerDelegate>
@property (nonatomic, retain) UICollectionView *collectionView;
-(void)setUpPhotoSwipe;
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer;
- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer;
@end
static BOOL selecting;
PUPhotosAlbumViewController* albumviewcontroller;
UIPanGestureRecognizer* gestureRecognizer;
UIPanGestureRecognizer* gestureRecognizerZoom;
NSIndexPath *lastAccessed;
%hook PUCollectionView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL recognizeSimultaneously = !selecting;
    return recognizeSimultaneously;
}
%end
%hook PUPhotosAlbumViewController
-(void)viewWillAppear:(BOOL)arg1 {
	%orig;
	UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.collectionView addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer setMinimumNumberOfTouches:1];
    [gestureRecognizer setMaximumNumberOfTouches:1];
    [gestureRecognizer _setCanPanVertically:NO];
}
%new
- (void) handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{    
    float pointerX = [gestureRecognizer locationInView:self.collectionView].x;
    float pointerY = [gestureRecognizer locationInView:self.collectionView].y;
    CGPoint velocity = [gestureRecognizer velocityInView:self.collectionView];
if ([self isEditing]) {
if (!self.collectionView.isDecelerating) {
        // Handle pan
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            // Reset pan states
            selecting = NO;
            lastAccessed = nil;
        	self.collectionView.scrollEnabled = YES;
        	[gestureRecognizer _setCanPanVertically:NO];
        } else {
            if (fabs(velocity.x) < fabs(velocity.y) && !selecting) {
            	[gestureRecognizer _setCanPanVertically:NO];
                // Register as scrolling the collection view
                selecting = NO;
            }else {
                // Register as selecting the cells, not scrolling the collection view
                selecting = YES;
                [gestureRecognizer _setCanPanVertically:YES];
                for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        float cellSX = cell.frame.origin.x;
        float cellEX = cell.frame.origin.x + cell.frame.size.width;
        float cellSY = cell.frame.origin.y;
        float cellEY = cell.frame.origin.y + cell.frame.size.height;
        
        if (pointerX >= cellSX && pointerX <= cellEX && pointerY >= cellSY && pointerY <= cellEY)
        {
            NSIndexPath *touchOver = [self.collectionView indexPathForCell:cell];
            
            if (lastAccessed != touchOver)
            {
                if (cell.selected) {
                   [self.collectionView _userSelectItemAtIndexPath: touchOver];
               }
                else 

                    [self.collectionView _userSelectItemAtIndexPath: touchOver];
            }
            
            lastAccessed = touchOver;
        }
    }

                }
            }
        }
    }
}
%new
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];

    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");            
    } else {
        // get the cell at indexPath (the one you long pressed)
        NSLog(@"cell for path ");
    }
}
%end

%hook PUZoomableGridViewController
-(void)viewWillAppear:(BOOL)arg1 {
	%orig;
	UIPanGestureRecognizer *gestureRecognizerZoom = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.collectionView addGestureRecognizer:gestureRecognizerZoom];
    [gestureRecognizerZoom setMinimumNumberOfTouches:1];
    [gestureRecognizerZoom setMaximumNumberOfTouches:1];
    [gestureRecognizerZoom _setCanPanVertically:NO];
}
%new
- (void) handleGesture:(UIPanGestureRecognizer *)gestureRecognizerZoom
{    
    float pointerX = [gestureRecognizerZoom locationInView:self.collectionView].x;
    float pointerY = [gestureRecognizerZoom locationInView:self.collectionView].y;
    CGPoint velocity = [gestureRecognizerZoom velocityInView:self.collectionView];
if ([self isEditing]) {
if (!self.collectionView.isDecelerating) {
        // Handle pan
        if (gestureRecognizerZoom.state == UIGestureRecognizerStateEnded) {
            // Reset pan states
            selecting = NO;
            lastAccessed = nil;
        	self.collectionView.scrollEnabled = YES;
        	[gestureRecognizerZoom _setCanPanVertically:NO];
        } else {
            if (fabs(velocity.x) < fabs(velocity.y) && !selecting) {
            	[gestureRecognizerZoom _setCanPanVertically:NO];
                // Register as scrolling the collection view
                selecting = NO;
            }else {
                // Register as selecting the cells, not scrolling the collection view
                selecting = YES;
                [gestureRecognizerZoom _setCanPanVertically:YES];
                for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        float cellSX = cell.frame.origin.x;
        float cellEX = cell.frame.origin.x + cell.frame.size.width;
        float cellSY = cell.frame.origin.y;
        float cellEY = cell.frame.origin.y + cell.frame.size.height;
        
        if (pointerX >= cellSX && pointerX <= cellEX && pointerY >= cellSY && pointerY <= cellEY)
        {
            NSIndexPath *touchOver = [self.collectionView indexPathForCell:cell];
            
            if (lastAccessed != touchOver)
            {
                if (cell.selected) {
                   [self.collectionView _userSelectItemAtIndexPath: touchOver];
               }
                else
                    [self.collectionView _userSelectItemAtIndexPath: touchOver];
            }
            
            lastAccessed = touchOver;
        }
    }

                }
            }
        }
    }
}
%end