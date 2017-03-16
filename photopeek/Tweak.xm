#import <UIKit/UIKit.h>
#import "CNPPopupController.h"
@interface PHObject : NSObject
@end
@interface PHAsset : PHObject
-(NSURL *)fileURLforFullsizeImage;
@end
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
- (PHAsset *)assetAtIndexPath:(id)arg1;
@end

@interface PUPhotosAlbumViewController : PUPhotosGridViewController<UIGestureRecognizerDelegate>
@property (nonatomic, retain) UICollectionView *collectionView;
-(void)setUpPhotoSwipe;
-(void)handlePeekGesture:(UILongPressGestureRecognizer *)gestureRecognizer;
@end
@interface PUZoomableGridViewController : PUPhotosGridViewController<UIGestureRecognizerDelegate>
@property (nonatomic, retain) UICollectionView *collectionView;
-(void)setUpPhotoSwipe;
-(void)handlePeekGesture:(UILongPressGestureRecognizer *)gestureRecognizer;
@end
%hook PUCollectionView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
%end
%hook PUPhotosAlbumViewController
-(void)viewWillAppear:(BOOL)arg1 {
	%orig;
	UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePeekGesture:)];
    [self.collectionView addGestureRecognizer:gestureRecognizer];
}
%new
- (void) handlePeekGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{    
    float pointerX = [gestureRecognizer locationInView:self.collectionView].x;
    float pointerY = [gestureRecognizer locationInView:self.collectionView].y;
        for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        float cellSX = cell.frame.origin.x;
        float cellEX = cell.frame.origin.x + cell.frame.size.width;
        float cellSY = cell.frame.origin.y;
        float cellEY = cell.frame.origin.y + cell.frame.size.height;
        
        if (pointerX >= cellSX && pointerX <= cellEX && pointerY >= cellSY && pointerY <= cellEY)
        {
            NSIndexPath *peekCell = [self.collectionView indexPathForCell:cell];
            id object = [self assetAtIndexPath:peekCell];
            NSLog(@"long press %@", object);

        }
    }
}
%end