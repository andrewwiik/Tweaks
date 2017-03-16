#import <WeatherFoundation/WFTemperatureUnitObserver-Protocol.h>
#import "City.h"
#import "WeatherPreferencesPersistence-Protocol.h"
#import "SynchronizedDefaultsDelegate-Protocol.h"
#import "WeatherCloudPreferences.h"

@interface WeatherPreferences : NSObject <WFTemperatureUnitObserver, NSURLConnectionDelegate> {

	NSString* _UUID;
	NSString* _serviceHost;
	BOOL _serviceDebugging;
	NSArray* _lastUbiquitousWrittenDefaults;
	id<WeatherPreferencesPersistence> _persistence;
	NSString* _cacheDirectoryPath;
	BOOL _logUnitsAndLocale;
	BOOL _userGroupPrefsLockedWhenInit;
	id<SynchronizedDefaultsDelegate> _syncDelegate;
	WeatherCloudPreferences* _cloudPreferences;

}

@property (assign,nonatomic) BOOL userGroupPrefsLockedWhenInit;                                                                   //@synthesize userGroupPrefsLockedWhenInit=_userGroupPrefsLockedWhenInit - In the implementation block
@property (readonly) int userTemperatureUnit; 
@property (retain) WeatherCloudPreferences * cloudPreferences;                                                                    //@synthesize cloudPreferences=_cloudPreferences - In the implementation block
@property (assign,nonatomic) id<SynchronizedDefaultsDelegate> syncDelegate;                                                //@synthesize syncDelegate=_syncDelegate - In the implementation block
@property (assign,setter=setLocalWeatherEnabled:,getter=isLocalWeatherEnabled,nonatomic) BOOL isLocalWeatherEnabled; 
@property (nonatomic,readonly) City * localWeatherCity; 
+(id)sharedPreferences;
+(id)_getGroupDefaultsFromURLInApp:(id)arg1 ;
+(id)userDefaultsPersistence;
+(id)preferencesWithPersistence:(id)arg1 ;
+(id)readInternalDefaultValueForKey:(id)arg1 ;
+(BOOL)performUpgradeOfPersistence:(id)arg1 fileManager:(id)arg2 error:(id*)arg3 ;
+(id)serviceDebuggingPath;
-(id)init;
-(id)UUID;
-(void)resetLocale;
-(City *)localWeatherCity;
-(id)loadSavedCities;
-(void)setSyncDelegate:(id<SynchronizedDefaultsDelegate>)arg1 ;
-(void)setLocalWeatherEnabled:(BOOL)arg1 ;
-(void)saveToDiskWithLocalWeatherCity:(id)arg1 ;
-(void)saveToDiskWithCities:(id)arg1 ;
-(id)readDefaultValueForKey:(id)arg1 ;
-(void)writeDefaultValue:(id)arg1 forKey:(id)arg2 ;
-(void)synchronizeStateToDisk;
-(BOOL)_defaultsAreValid;
-(void)saveToDiskWithCities:(id)arg1 activeCity:(unsigned long long)arg2 ;
-(id<SynchronizedDefaultsDelegate>)syncDelegate;
-(id)_defaultCities;
-(BOOL)areCitiesDefault:(id)arg1 ;
-(void)setCelsius:(BOOL)arg1 ;
-(void)setupUbiquitousStoreIfNeeded;
-(id)initWithPersistence:(id)arg1 ;
-(WeatherCloudPreferences *)cloudPreferences;
-(void)setCloudPreferences:(WeatherCloudPreferences *)arg1 ;
-(void)setDefaultSelectedCityID:(id)arg1 ;
-(void)synchronizeStateToDiskDoNotify:(BOOL)arg1 ;
-(BOOL)isLocalWeatherEnabled;
-(int)userTemperatureUnit;
-(BOOL)_defaultsCurrent;
-(id)cityFromPreferencesDictionary:(id)arg1 ;
-(id)preferencesDictionaryForCity:(id)arg1 ;
-(id)citiesByConsolidatingDuplicates:(id)arg1 originalOrder:(id)arg2 ;
-(int)loadActiveCity;
-(void)setActiveCity:(unsigned long long)arg1 ;
-(id)citiesByConsolidatingDuplicatesInBucket:(id)arg1 ;
-(void)saveToUbiquitousStore;
-(id)readInternalDefaultValueForKey:(id)arg1 ;
-(BOOL)ensureValidSelectedCityID;
-(void)adjustPrefsForLocalWeatherEnabled:(BOOL)arg1 ;
-(void)registerTemperatureUnits;
-(BOOL)readTemperatureUnits;
-(void)saveToDiskWithCity:(id)arg1 forActiveIndex:(unsigned long long)arg2 ;
-(void)setDefaultCities:(id)arg1 ;
-(int)loadDefaultSelectedCity;
-(id)loadDefaultSelectedCityID;
-(void)setDefaultSelectedCity:(unsigned long long)arg1 ;
-(id)twcLogoURL;
-(id)twcLogoURL:(id)arg1 ;
-(void)_clearCachedObjects;
-(BOOL)userGroupPrefsLockedWhenInit;
-(void)setUserGroupPrefsLockedWhenInit:(BOOL)arg1 ;
-(BOOL)serviceDebugging;
-(id)_cacheDirectoryPath;
-(id)serviceHost;
-(BOOL)isCelsius;
-(void)temperatureUnitObserver:(id)arg1 didChangeTemperatureUnitTo:(int)arg2 ;
@end