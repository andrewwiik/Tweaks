@interface MPUTextDrawingContext : NSObject
- (NSDictionary *)uniformTextAttributes;
@end

@interface MPUTextDrawingView : UIView
- (MPUTextDrawingContext*)textDrawingContext;
@end

@interface MusicEntityAbstractLockupView : UIView
@end

@interface MusicStoreItemMetadataContext : NSObject
- (NSDictionary*)JSDictionary; // trackDuration - NSCFNUmber
- (NSMutableArray *)childrenStoreItemMetadataContexts;
@end


@interface MusicStoreEntityProvider : NSObject
- (NSArray*)storeItemMetadataContexts;
- (int)totalPlayTimeInSeconds;
- (NSString *)playDuration;
@end

@interface MusicStorePlaylistEntityValueProvider : MusicStoreEntityProvider
- (int)totalPlayTimeInSeconds2;
- (NSString *)playDuration2;
- (MusicStoreItemMetadataContext *)storeItemMetadataContext;
@end

@interface MusicEntityProductHeaderLockupView : MusicEntityAbstractLockupView
@property (nonatomic, retain) UILabel *durationLabel;
- (id)delegate; // Album
- (MusicStorePlaylistEntityValueProvider *)entityValueProvider;
@end

@interface MPMediaItem : NSObject
- (CGFloat)playbackDuration;
@end
@interface MPMediaQuery : NSObject
- (NSArray*)items;
@end
@interface MusicMediaEntityProvider : NSObject
- (MPMediaQuery *)mediaQuery;
- (int)totalPlayTimeInSeconds;
- (NSString *)playDuration;
@end

@interface MusicMediaProductHeaderContentViewController : UIViewController
- (MusicMediaEntityProvider *)containerEntityProvider;
@end

@interface MusicMediaAlbumHeaderContentViewController : MusicMediaProductHeaderContentViewController // album
@end
@interface MusicEntityValueContext : NSObject 
- (MusicStorePlaylistEntityValueProvider *)containerEntityValueProvider;
@end
@interface MusicMediaPlaylistHeaderContentViewController : MusicMediaProductHeaderContentViewController
-(MusicEntityValueContext *)_containerEntityValueContext;
@end
@interface MusicMediaDetailViewController : UIViewController
- (MusicMediaPlaylistHeaderContentViewController* )headerContentViewController;
@end

@interface MusicMediaProductDetailViewController : MusicMediaDetailViewController
- (MusicStoreEntityProvider*)tracklistEntityProvider;
@end

@interface MusicMediaPlaylistDetailViewController : MusicMediaProductDetailViewController
@end

@interface MPConcreteMediaItemCollection : NSObject
- (NSArray *)items;
- (MPMediaQuery *)itemsQuery;
@end
@interface MusicCoalescingEntityValueProvider : NSObject
- (MPConcreteMediaItemCollection *)baseEntityValueProvider;
- (int)totalPlayTimeInSeconds;
- (NSString *)playDuration;
@end

@interface MusicEntityHorizontalLockupView : MusicEntityAbstractLockupView
@property (nonatomic, retain) UILabel *durationLabel;
- (MusicCoalescingEntityValueProvider*)entityValueProvider;
@end

@interface MusicEntityHorizontalLockupTableViewCell : UITableViewCell
- (MusicEntityHorizontalLockupView*)lockupView;
@end