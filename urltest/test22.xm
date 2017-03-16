%hook AFSiriTaskExecution
- (void)_completeWithError:(id)arg1 { %log; %orig; }
- (void)_completeWithResponse:(id)arg1 { %log; %orig; }
- (void)_completeWithResponse:(id)arg1 error:(id)arg2 { %log; %orig; }
- (void)dealloc { %log; %orig; }
- (void)handleFailureOfRequest:(id)arg1 error:(id)arg2 { %log; %orig; }
- (void)handleSiriResponse:(id)arg1 { %log; %orig; }
- (id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithRequest:(id)arg1 taskDeliverer:(id)arg2 usageResultListener:(id)arg3 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (BOOL)listener:(id)arg1 shouldAcceptNewConnection:(id)arg2 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (void)setCompletionHandler:(id /* block */)arg1 { %log; %orig; }
- (void)setDeliveryHandler:(id /* block */)arg1 { %log; %orig; }
- (void)start { %log; %orig; }
%end
%hook MPMediaQuery
+ (id)ITunesUAudioQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)ITunesUQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)activeGeniusPlaylist { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)albumArtistsQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)albumsQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)artistsQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)audibleAudiobooksQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)audioPodcastsQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)audiobooksQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)compilationsQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)composersQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)currentDevicePurchasesPlaylist { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)geniusMixesQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)genresQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)homeVideosQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (void)initFilteringDisabled { %log; %orig; }
+ (void)initialize { %log; %orig; }
+ (BOOL)isFilteringDisabled { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
+ (id)movieRentalsQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)moviesQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)musicVideosQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)playbackHistoryPlaylist { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)playlistsQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)playlistsRecentlyAddedQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)podcastsQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (void)setFilteringDisabled:(BOOL)arg1 { %log; %orig; }
+ (id)songsQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (BOOL)supportsSecureCoding { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
+ (id)tvShowsQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)videoITunesUQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)videoPodcastsQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)videosQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void).cxx_destruct { %log; %orig; }
- (BOOL)MPSD_hasDownloadableEntities { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (BOOL)MPSD_hasDownloadingEntities { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (id)MPSD_mediaQueryForDownloadableEntities { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)MPSD_mediaQueryForDownloadingEntities { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (unsigned int)_countOfCollections { %log; unsigned int r = %orig; NSLog(@" = %u", r); return r; }
- (unsigned int)_countOfItems { %log; unsigned int r = %orig; NSLog(@" = %u", r); return r; }
- (void)_enumerateCollectionPersistentIDsInOrder:(BOOL)arg1 usingBlock:(id /* block */)arg2 { %log; %orig; }
- (void)_enumerateCollectionPersistentIDsUsingBlock:(id /* block */)arg1 { %log; %orig; }
- (void)_enumerateCollectionsInOrder:(BOOL)arg1 usingBlock:(id /* block */)arg2 { %log; %orig; }
- (void)_enumerateCollectionsUsingBlock:(id /* block */)arg1 { %log; %orig; }
- (void)_enumerateItemPersistentIDsInOrder:(BOOL)arg1 usingBlock:(id /* block */)arg2 { %log; %orig; }
- (void)_enumerateItemPersistentIDsUsingBlock:(id /* block */)arg1 { %log; %orig; }
- (void)_enumerateItemsInOrder:(BOOL)arg1 usingBlock:(id /* block */)arg2 { %log; %orig; }
- (void)_enumerateItemsUsingBlock:(id /* block */)arg1 { %log; %orig; }
- (void)_enumerateUnorderedCollectionPersistentIDsUsingBlock:(id /* block */)arg1 { %log; %orig; }
- (void)_enumerateUnorderedCollectionsUsingBlock:(id /* block */)arg1 { %log; %orig; }
- (void)_enumerateUnorderedItemPersistentIDsUsingBlock:(id /* block */)arg1 { %log; %orig; }
- (void)_enumerateUnorderedItemsUsingBlock:(id /* block */)arg1 { %log; %orig; }
- (BOOL)_hasCollections { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (BOOL)_hasItems { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (BOOL)_hasStaticEntities { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (BOOL)_isFilteringDisabled { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (id)_orderingDirectionMappings { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)_orderingProperties { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)_representativeCollection { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)_setOrderingDirectionMappings:(id)arg1 { %log; %orig; }
- (void)_setOrderingProperties:(id)arg1 { %log; %orig; }
- (BOOL)_updatePredicateForProperty:(id)arg1 withPropertyPredicate:(id)arg2 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (id)_valueForAggregateFunction:(id)arg1 onProperty:(id)arg2 entityType:(int)arg3 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)addFilterPredicate:(id)arg1 { %log; %orig; }
- (id)collectionByJoiningCollections { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)collectionPersistentIdentifiers { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)collectionPropertiesToFetch { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)collectionSectionInfo { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)collectionSections { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)collections { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)containingPlaylist { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)copyByRemovingStaticEntities { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)copyBySanitizingStaticEntities { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)copyWithZone:(struct _NSZone { }*)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)criteria { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)description { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)encodeWithCoder:(id)arg1 { %log; %orig; }
- (unsigned int)entityLimit { %log; unsigned int r = %orig; NSLog(@" = %u", r); return r; }
- (BOOL)excludesEntitiesWithBlankNames { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (id)filterPredicates { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (unsigned int)groupingThreshold { %log; unsigned int r = %orig; NSLog(@" = %u", r); return r; }
- (int)groupingType { %log; int r = %orig; NSLog(@" = %d", r); return r; }
- (unsigned int)hash { %log; unsigned int r = %orig; NSLog(@" = %u", r); return r; }
- (BOOL)ignoreSystemFilterPredicates { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (BOOL)includeEntitiesWithBlankNames { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithCoder:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithCriteria:(id)arg1 library:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithEntities:(id)arg1 entityType:(int)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithFilterPredicates:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithProtobufferDecodableObject:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (BOOL)isEqual:(id)arg1 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (id)itemPersistentIdentifiers { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)itemPropertiesToFetch { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)itemSectionInfo { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)itemSections { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)items { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)mediaLibrary { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)predicateForProperty:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)protobufferEncodableObject { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)removeFilterPredicate:(id)arg1 { %log; %orig; }
- (void)removePredicatesForProperty:(id)arg1 { %log; %orig; }
- (void)setCollectionPropertiesToFetch:(id)arg1 { %log; %orig; }
- (void)setCriteria:(id)arg1 { %log; %orig; }
- (void)setEntityLimit:(unsigned int)arg1 { %log; %orig; }
- (void)setFilterPredicate:(id)arg1 forProperty:(id)arg2 { %log; %orig; }
- (void)setFilterPredicates:(id)arg1 { %log; %orig; }
- (void)setFilterPropertyPredicate:(id)arg1 { %log; %orig; }
- (void)setGroupingType:(int)arg1 { %log; %orig; }
- (void)setIgnoreSystemFilterPredicates:(BOOL)arg1 { %log; %orig; }
- (void)setIncludeEntitiesWithBlankNames:(BOOL)arg1 { %log; %orig; }
- (void)setItemPropertiesToFetch:(id)arg1 { %log; %orig; }
- (void)setMediaLibrary:(id)arg1 { %log; %orig; }
- (void)setShouldIncludeNonLibraryEntities:(BOOL)arg1 { %log; %orig; }
- (void)setSortItems:(BOOL)arg1 { %log; %orig; }
- (void)setStaticEntities:(id)arg1 entityType:(int)arg2 { %log; %orig; }
- (void)setUseSections:(BOOL)arg1 { %log; %orig; }
- (BOOL)shouldIncludeNonLibraryEntities { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (BOOL)sortItems { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (BOOL)specifiesPlaylistItems { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (BOOL)useSections { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (id)valueForAggregateFunction:(id)arg1 onCollectionsForProperty:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)valueForAggregateFunction:(id)arg1 onItemsForProperty:(id)arg2 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (BOOL)willGroupEntities { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (id)_MPUSDS_searchPredicate { %log; id r = %orig; NSLog(@" = %@", r); return r; }
+ (id)MCD_queryWithFilterPredicates:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (BOOL)MCD_isEqualToNowPlayingQuery:(id)arg1 { %log; BOOL r = %orig; NSLog(@" = %d", r); return r; }
- (id)MCD_playlist { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)MCD_playlistTitle { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)_music_nowPlayingComparableQuery { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
