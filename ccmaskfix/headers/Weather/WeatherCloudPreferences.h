#import "WeatherCloudPersistenceDelegate-Protocol.h"
#import "SynchronizedDefaultsDelegate-Protocol.h"
#import "WeatherPreferencesPersistence-Protocol.h"

@class WeatherPreferences;

@interface WeatherCloudPreferences : NSObject <WeatherCloudPersistenceDelegate> {

	id<SynchronizedDefaultsDelegate> _syncDelegate;
	id<WeatherPreferencesPersistence> _cloudStore;
	WeatherPreferences* _localPreferences;

}

@property (retain) id<WeatherPreferencesPersistence> cloudStore;                                //@synthesize cloudStore=_cloudStore - In the implementation block
@property (retain) WeatherPreferences * localPreferences;                                       //@synthesize localPreferences=_localPreferences - In the implementation block
@property (assign,nonatomic) id<SynchronizedDefaultsDelegate> syncDelegate;              //@synthesize syncDelegate=_syncDelegate - In the implementation block
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(void)setSyncDelegate:(id<SynchronizedDefaultsDelegate>)arg1 ;
-(id)initWithLocalPreferences:(id)arg1 persistence:(id)arg2 ;
-(void)setLocalPreferences:(WeatherPreferences *)arg1 ;
-(void)setCloudStore:(id<WeatherPreferencesPersistence>)arg1 ;
-(void)cloudCitiesChangedExternally:(id)arg1 ;
-(id<WeatherPreferencesPersistence>)cloudStore;
-(BOOL)legacyCloudCity:(id)arg1 isEqualToALCity:(id)arg2 ;
-(id)cloudCityFromALCity:(id)arg1 name:(id)arg2 ;
-(id)cloudCitiesFromLegacyCloudCities:(id)arg1 ;
-(WeatherPreferences *)localPreferences;
-(id)cloudCityRepresentationsFromLegacyRepresentations;
-(id)reconcileCloudCities:(id)arg1 withLocal:(id)arg2 isInitialSync:(BOOL)arg3 ;
-(BOOL)areCloudCities:(id)arg1 equalToLocalCities:(id)arg2 ;
-(void)updateLocalStoreWithRemoteChanges:(id)arg1 ;
-(void)saveCitiesToCloud:(id)arg1 ;
-(id<SynchronizedDefaultsDelegate>)syncDelegate;
-(id)citiesByEnforcingSizeLimitOnResults:(id)arg1 ;
-(id)prepareLocalCitiesForReconciliation:(id)arg1 isInitialSync:(BOOL)arg2 ;
-(id)cloudRepresentationFromCities:(id)arg1 ;
-(BOOL)shouldWriteCitiesToCloud:(id)arg1 ;
-(void)setCloudStoreCities:(id)arg1 ;
-(void)cloudPersistenceDidSynchronize:(id)arg1 ;
-(id)initWithLocalPreferences:(id)arg1 ;
@end
