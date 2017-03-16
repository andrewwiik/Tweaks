%hook MusicApplicationDelegate
-(void)_supportedTabIdentifiersDidChangeNotification:(id)arg1  { %log; %orig; }
-(void)_cloudServiceControllerSubscriptionStatusDidChangeNotification:(id)arg1  { %log; %orig; }
-(void)_cloudServiceControllerCloudLibraryEnabledDidChangeNotification:(id)arg1  { %log; %orig; }
-(void)_configureRadioOperationQueue { %log; %orig; }
-(void)_networkingStartNotification:(id)arg1  { %log; %orig; }
-(void)_networkingStopNotification:(id)arg1  { %log; %orig; }
-(void)_playerPlaybackLeaseControllerDidPausePlaybackForLeaseEndNotification:(id)arg1  { %log; %orig; }
-(void)_playerPlaybackErrorNotification:(id)arg1  { %log; %orig; }
-(void)_updateTabBarItemsAnimated:(char)arg1  { %log; %orig; }
-(id)_fairPlaySAPSession { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)radioApplicationWillFinishLaunching:(id)arg1  { %log; %orig; }
-(char)_isOfflineForReporting { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(unsigned long long)_storeAccountIdentifierForReporting { %log; unsigned long long r = %orig; NSLog(@" = %llu", r); return r; }
-(void)_setIAmTheIPod { %log; %orig; }
-(void)_setupWindowIfNecessary { %log; %orig; }
-(void)_presentWelcomeScreenIfAppropriate { %log; %orig; }
-(id)_validatedUserActivityContextWithContext:(id)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(char)_handleUserActivityContext:(id)arg1  { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(void)radioApplicationDidFinishLaunching:(id)arg1  { %log; %orig; }
-(void)_populateMediaSocialProfileCache { %log; %orig; }
-(void)_presentNowPlayingViewControllerForSharing { %log; %orig; }
-(void)presentNowPlayingViewControllerAnimated:(char)arg1  { %log; %orig; }
-(void)_populateMediaSocialAdminPermissionsCache { %log; %orig; }
-(void)_disableAllowsNewPlaybackErrorItemIfAppropriate { %log; %orig; }
-(char)_hasTabWithIdentifier:(id)arg1  { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(void)_switchViewTest:(id)arg1 fromIdentifier:(id)arg2 toIdentifier:(id)arg3  { %log; %orig; }
-(void)_scrollViewTest:(id)arg1 withOptions:(id)arg2 withIdentifier:(id)arg3  { %log; %orig; }
-(void)_bringUpActionSheet:(id)arg1  { %log; %orig; }
-(void)_enterRecentlyAdded:(id)arg1  { %log; %orig; }
-(void)_switchToLibraryDetailView:(id)arg1  { %log; %orig; }
-(void)_switchToViewConfigurationTest:(id)arg1  { %log; %orig; }
-(void)_dismissNowPlayingViewControllerAnimated:(char)arg1  { %log; %orig; }
-(void)_switchToMyMusicTabAndSegmentWithIdentifier:(id)arg1 completion:(/*^block*/id)arg2  { %log; %orig; }
-(void)_switchToTabWithIdentifier:(id)arg1 completion:(/*^block*/id)arg2  { %log; %orig; }
-(void)_playLocalLibrarySongForTestNamed:(id)arg1  { %log; %orig; }
-(void)_searchLocalLibraryForTestName:(id)arg1 withOptions:(id)arg2  { %log; %orig; }
-(void)_selectViewConfigurationWithIdentifier:(id)arg1 inLibrarySplitViewController:(id)arg2 completion:(/*^block*/id)arg3  { %log; %orig; }
-(void)_selectFirstItemFromLibraryBrowseTableViewController:(id)arg1  { %log; %orig; }
-(void)_switchToDetailSegmentedTabView:(id)arg1 withIdentifier:(id)arg2  { %log; %orig; }
-(void)_switchToViewConfiguration:(id)arg1 completion:(/*^block*/id)arg2  { %log; %orig; }
-(void)_switchToSegmentedTabWithIdentifier:(id)arg1 completion:(/*^block*/id)arg2  { %log; %orig; }
-(void)remoteController:(id)arg1 addStationWithDictionary:(id)arg2 completionHandler:(/*^block*/id)arg3  { %log; %orig; }
-(void)remoteController:(id)arg1 completeAdditionOfStationWithContext:(id)arg2 animated:(char)arg3  { %log; %orig; }
-(void)_showAddSharedStationFailedAlertWithErrorCode:(int)arg1  { %log; %orig; }
-(void)_itemDidChangeNotification:(id)arg1  { %log; %orig; }
-(void)_playerWillReloadWithPlaybackContextNotification:(id)arg1  { %log; %orig; }
-(void)_networkTypeDidChangeNotification:(id)arg1  { %log; %orig; }
-(void)dealloc { %log; %orig; }
-(id)init { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(char)application:(id)arg1 openURL:(id)arg2 sourceApplication:(id)arg3 annotation:(id)arg4  { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(void)applicationDidBecomeActive:(id)arg1  { %log; %orig; }
-(void)applicationWillResignActive:(id)arg1  { %log; %orig; }
-(void)applicationDidEnterBackground:(id)arg1  { %log; %orig; }
-(void)applicationWillEnterForeground:(id)arg1  { %log; %orig; }
-(char)application:(id)arg1 shouldSaveApplicationState:(id)arg2  { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(char)application:(id)arg1 shouldRestoreApplicationState:(id)arg2  { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(char)application:(id)arg1 willFinishLaunchingWithOptions:(id)arg2  { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(char)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2  { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(void)setWindow:(UIWindow *)arg1  { %log; %orig; }
-(char)application:(id)arg1 continueUserActivity:(id)arg2 restorationHandler:(/*^block*/id)arg3  { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(char)application:(id)arg1 willContinueUserActivityWithType:(id)arg2  { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(void)application:(id)arg1 willEncodeRestorableStateWithCoder:(id)arg2  { %log; %orig; }
-(void)application:(id)arg1 didDecodeRestorableStateWithCoder:(id)arg2  { %log; %orig; }
-(char)application:(id)arg1 runTest:(id)arg2 options:(id)arg3  { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(void)_playerDidReloadWithPlaybackContextNotification:(id)arg1  { %log; %orig; }
-(void)transferAggregatorDidChange:(id)arg1  { %log; %orig; }
-(void)welcomeNavigationControllerDidDisappear:(id)arg1  { %log; %orig; }
-(void)_itemWillChangeNotification:(id)arg1  { %log; %orig; }
-(void)_availableMediaLibrariesDidChangeNotification:(id)arg1  { %log; %orig; }
-(void)_isExplicitTracksEnabledDidChangeNotification:(id)arg1  { %log; %orig; }
-(id)overlayViewControllerWithBackgroundStyle:(int)arg1  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(char)shouldShowStatusOverlayForViewController:(id)arg1  { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(void)application:(id)arg1 evaluateAppJavaScriptInContext:(id)arg2 JSContext:(id)arg3  { %log; %orig; }
-(void)application:(id)arg1 didSelectTabBarItem:(id)arg2  { %log; %orig; }
-(void)applicationDidLoadFromUpdatableAssetsCache:(id)arg1  { %log; %orig; }
-(id)bundledUpdatableAssetsManifestURL { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(char)clearUpdatableAssetsCacheOnLaunch { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(char)loadApplicationAfterUpdatableAssetsRefresh { %log; char r = %orig; NSLog(@" = '%c'", r); return r; }
-(id)updatableAssetsManifestURL { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(id)application:(id)arg1 navigationControllerWithTabBarItem:(id)arg2  { %log; id r = %orig; NSLog(@" = %@", r); return r; }
-(void)applicationDidChangeClientContext:(id)arg1  { %log; %orig; }
-(void)_accountStoreDidChangeNotification:(id)arg1  { %log; %orig; }
%end
%hook AFConnectionClientServiceDelegate
- (id)_connectionDelegate { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)aceConnectionWillRetryOnError:(id)arg1 { %log; %orig; }
- (void)acousticIDRequestDidFinishWithSuccess:(BOOL)arg1 { %log; %orig; }
- (void)acousticIDRequestWillStart { %log; %orig; }
- (void)getBulletinContext:(id /* block */)arg1 { %log; %orig; }
- (id)initWithConnection:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)invalidateCurrentUserActivity { %log; %orig; }
- (void)musicWasDetected { %log; %orig; }
- (void)requestDidFailWithError:(id)arg1 requestClass:(id)arg2 { %log; %orig; }
- (void)requestDidFinish { %log; %orig; }
- (void)requestDidReceiveCommand:(id)arg1 reply:(id /* block */)arg2 { %log; %orig; }
- (void)requestRequestedDismissAssistant { %log; %orig; }
- (void)requestRequestedOpenApplicationWithBundleID:(id)arg1 URL:(id)arg2 reply:(id /* block */)arg3 { %log; %orig; }
- (void)requestRequestedOpenURL:(id)arg1 reply:(id /* block */)arg2 { %log; %orig; }
- (void)setUserActivityInfo:(id)arg1 webpageURL:(id)arg2 { %log; %orig; }
- (void)shouldSpeakChanged:(BOOL)arg1 { %log; %orig; }
- (void)speechRecognitionDidFail:(id)arg1 { %log; %orig; }
- (void)speechRecognized:(id)arg1 { %log; %orig; }
- (void)speechRecognizedPartialResult:(id)arg1 { %log; %orig; }
- (void)speechRecordingDidBeginOnAVRecordRoute:(id)arg1 { %log; %orig; }
- (void)speechRecordingDidCancel { %log; %orig; }
- (void)speechRecordingDidChangeAVRecordRoute:(id)arg1 { %log; %orig; }
- (void)speechRecordingDidEnd { %log; %orig; }
- (void)speechRecordingDidFail:(id)arg1 { %log; %orig; }
- (void)speechRecordingWillBeginWithLevelsSharedMem:(id)arg1 { %log; %orig; }
%end
%hook AFSiriTask
+ (void)initialize { %log; %orig; }
- (id)_initWithRequest:(id)arg1 remoteResponseListenerEndpoint:(id)arg2 usageResultListenerEndpoint:(id)arg3 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)_responseHandlerConnection { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)_usageResultHandlerConnection { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)completeWithResponse:(id)arg1 { %log; %orig; }
- (id)description { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)encodeWithCoder:(id)arg1 { %log; %orig; }
- (void)encodeWithXPCDictionary:(id)arg1 { %log; %orig; }
- (void)failWithError:(id)arg1 { %log; %orig; }
- (id)initWithCoder:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithXPCDictionary:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)reportUsageResult:(id)arg1 { %log; %orig; }
- (id)request { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end
%hook AFUIApplicationSiriTaskDeliverer
- (unsigned int )hash { %log; unsigned int  r = %orig; NSLog(@" = %u", r); return r; }
- (void)_invalidateAssertionTimer { %log; %orig; }
- (void)_invalidateBackboardServices { %log; %orig; }
- (id)_queue { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)deliverSiriTask:(id)arg1 completionHandler:(id /* block */)arg2 { %log; %orig; }
- (id)description { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (id)initWithAppBundleIdentifier:(id)arg1 { %log; id r = %orig; NSLog(@" = %@", r); return r; }
- (void)setTaskmaster:(id)arg1 { %log; %orig; }
- (void)siriTaskDidFinish { %log; %orig; }
- (id)taskmaster { %log; id r = %orig; NSLog(@" = %@", r); return r; }
%end

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