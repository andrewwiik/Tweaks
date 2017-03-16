@interface AFSiriTaskExecution : NSObject <AFSiriResponseHandling, NSXPCListenerDelegate> {
    id /* block */ _completionHandler;
    id /* block */ _deliveryHandler;
    NSObject<OS_dispatch_queue> *_queue;
    AFSiriRequest *_request;
    int _state;
    <AFSiriTaskDelivering> *_taskDeliverer;
    NSXPCListener *_taskResponseListener;
    AFWatchdogTimer *_taskResponseWatchdogTimer;
    NSXPCListener *_usageResultListener;
}

- (void)_completeWithError:(id)arg1;
- (void)_completeWithResponse:(id)arg1;
- (void)_completeWithResponse:(id)arg1 error:(id)arg2;
- (void)dealloc;
- (void)handleFailureOfRequest:(id)arg1 error:(id)arg2;
- (void)handleSiriResponse:(id)arg1;
- (id)init;
- (id)initWithRequest:(id)arg1 taskDeliverer:(id)arg2 usageResultListener:(id)arg3;
- (BOOL)listener:(id)arg1 shouldAcceptNewConnection:(id)arg2;
- (void)setCompletionHandler:(id /* block */)arg1;
- (void)setDeliveryHandler:(id /* block */)arg1;
- (void)start;

@end

@interface MPMediaQuery : NSObject <MPPProtobufferCoding, NSCopying, NSSecureCoding> {
    MPMediaQueryCriteria *_criteria;
    int _isFilteringDisabled;
    MPMediaLibrary *_mediaLibrary;
    NSArray *_staticEntities;
    int _staticEntityType;
}

// Image: /System/Library/Frameworks/MediaPlayer.framework/MediaPlayer

+ (id)ITunesUAudioQuery;
+ (id)ITunesUQuery;
+ (id)activeGeniusPlaylist;
+ (id)albumArtistsQuery;
+ (id)albumsQuery;
+ (id)artistsQuery;
+ (id)audibleAudiobooksQuery;
+ (id)audioPodcastsQuery;
+ (id)audiobooksQuery;
+ (id)compilationsQuery;
+ (id)composersQuery;
+ (id)currentDevicePurchasesPlaylist;
+ (id)geniusMixesQuery;
+ (id)genresQuery;
+ (id)homeVideosQuery;
+ (void)initFilteringDisabled;
+ (void)initialize;
+ (BOOL)isFilteringDisabled;
+ (id)movieRentalsQuery;
+ (id)moviesQuery;
+ (id)musicVideosQuery;
+ (id)playbackHistoryPlaylist;
+ (id)playlistsQuery;
+ (id)playlistsRecentlyAddedQuery;
+ (id)podcastsQuery;
+ (void)setFilteringDisabled:(BOOL)arg1;
+ (id)songsQuery;
+ (BOOL)supportsSecureCoding;
+ (id)tvShowsQuery;
+ (id)videoITunesUQuery;
+ (id)videoPodcastsQuery;
+ (id)videosQuery;

- (void).cxx_destruct;
- (BOOL)MPSD_hasDownloadableEntities;
- (BOOL)MPSD_hasDownloadingEntities;
- (id)MPSD_mediaQueryForDownloadableEntities;
- (id)MPSD_mediaQueryForDownloadingEntities;
- (unsigned int)_countOfCollections;
- (unsigned int)_countOfItems;
- (void)_enumerateCollectionPersistentIDsInOrder:(BOOL)arg1 usingBlock:(id /* block */)arg2;
- (void)_enumerateCollectionPersistentIDsUsingBlock:(id /* block */)arg1;
- (void)_enumerateCollectionsInOrder:(BOOL)arg1 usingBlock:(id /* block */)arg2;
- (void)_enumerateCollectionsUsingBlock:(id /* block */)arg1;
- (void)_enumerateItemPersistentIDsInOrder:(BOOL)arg1 usingBlock:(id /* block */)arg2;
- (void)_enumerateItemPersistentIDsUsingBlock:(id /* block */)arg1;
- (void)_enumerateItemsInOrder:(BOOL)arg1 usingBlock:(id /* block */)arg2;
- (void)_enumerateItemsUsingBlock:(id /* block */)arg1;
- (void)_enumerateUnorderedCollectionPersistentIDsUsingBlock:(id /* block */)arg1;
- (void)_enumerateUnorderedCollectionsUsingBlock:(id /* block */)arg1;
- (void)_enumerateUnorderedItemPersistentIDsUsingBlock:(id /* block */)arg1;
- (void)_enumerateUnorderedItemsUsingBlock:(id /* block */)arg1;
- (BOOL)_hasCollections;
- (BOOL)_hasItems;
- (BOOL)_hasStaticEntities;
- (BOOL)_isFilteringDisabled;
- (id)_orderingDirectionMappings;
- (id)_orderingProperties;
- (id)_representativeCollection;
- (void)_setOrderingDirectionMappings:(id)arg1;
- (void)_setOrderingProperties:(id)arg1;
- (BOOL)_updatePredicateForProperty:(id)arg1 withPropertyPredicate:(id)arg2;
- (id)_valueForAggregateFunction:(id)arg1 onProperty:(id)arg2 entityType:(int)arg3;
- (void)addFilterPredicate:(id)arg1;
- (id)collectionByJoiningCollections;
- (id)collectionPersistentIdentifiers;
- (id)collectionPropertiesToFetch;
- (id)collectionSectionInfo;
- (id)collectionSections;
- (id)collections;
- (id)containingPlaylist;
- (id)copyByRemovingStaticEntities;
- (id)copyBySanitizingStaticEntities;
- (id)copyWithZone:(struct _NSZone { }*)arg1;
- (id)criteria;
- (id)description;
- (void)encodeWithCoder:(id)arg1;
- (unsigned int)entityLimit;
- (BOOL)excludesEntitiesWithBlankNames;
- (id)filterPredicates;
- (unsigned int)groupingThreshold;
- (int)groupingType;
- (unsigned int)hash;
- (BOOL)ignoreSystemFilterPredicates;
- (BOOL)includeEntitiesWithBlankNames;
- (id)init;
- (id)initWithCoder:(id)arg1;
- (id)initWithCriteria:(id)arg1 library:(id)arg2;
- (id)initWithEntities:(id)arg1 entityType:(int)arg2;
- (id)initWithFilterPredicates:(id)arg1;
- (id)initWithProtobufferDecodableObject:(id)arg1;
- (BOOL)isEqual:(id)arg1;
- (id)itemPersistentIdentifiers;
- (id)itemPropertiesToFetch;
- (id)itemSectionInfo;
- (id)itemSections;
- (id)items;
- (id)mediaLibrary;
- (id)predicateForProperty:(id)arg1;
- (id)protobufferEncodableObject;
- (void)removeFilterPredicate:(id)arg1;
- (void)removePredicatesForProperty:(id)arg1;
- (void)setCollectionPropertiesToFetch:(id)arg1;
- (void)setCriteria:(id)arg1;
- (void)setEntityLimit:(unsigned int)arg1;
- (void)setFilterPredicate:(id)arg1 forProperty:(id)arg2;
- (void)setFilterPredicates:(id)arg1;
- (void)setFilterPropertyPredicate:(id)arg1;
- (void)setGroupingType:(int)arg1;
- (void)setIgnoreSystemFilterPredicates:(BOOL)arg1;
- (void)setIncludeEntitiesWithBlankNames:(BOOL)arg1;
- (void)setItemPropertiesToFetch:(id)arg1;
- (void)setMediaLibrary:(id)arg1;
- (void)setShouldIncludeNonLibraryEntities:(BOOL)arg1;
- (void)setSortItems:(BOOL)arg1;
- (void)setStaticEntities:(id)arg1 entityType:(int)arg2;
- (void)setUseSections:(BOOL)arg1;
- (BOOL)shouldIncludeNonLibraryEntities;
- (BOOL)sortItems;
- (BOOL)specifiesPlaylistItems;
- (BOOL)useSections;
- (id)valueForAggregateFunction:(id)arg1 onCollectionsForProperty:(id)arg2;
- (id)valueForAggregateFunction:(id)arg1 onItemsForProperty:(id)arg2;
- (BOOL)willGroupEntities;

// Image: /System/Library/PrivateFrameworks/MPUFoundation.framework/MPUFoundation

- (id)_MPUSDS_searchPredicate;

// Image: /System/Library/PrivateFrameworks/MusicCarDisplayUI.framework/MusicCarDisplayUI

+ (id)MCD_queryWithFilterPredicates:(id)arg1;

- (BOOL)MCD_isEqualToNowPlayingQuery:(id)arg1;
- (id)MCD_playlist;
- (id)MCD_playlistTitle;
- (id)_music_nowPlayingComparableQuery;

@end

