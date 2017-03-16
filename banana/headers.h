#import <MapKit/MapKit.h>

@interface GEOLatLng : NSObject
- (CGFloat)lat;
- (CGFloat)lng;
@end

@interface GEOPDAutocompleteEntryAddress : NSObject
- (BOOL)hasCenter;
- (GEOLatLng *)center;
@end

@interface GEOPDAutocompleteEntry : NSObject
- (BOOL)hasAddress;
- (GEOPDAutocompleteEntryAddress *)address;
@end

@interface _GEOPlaceSearchCompletionItem : NSObject
- (GEOPDAutocompleteEntry *)entry;
@end
@interface MKSearchCompletion : NSObject
-(NSString *)queryLine;
- (_GEOPlaceSearchCompletionItem *)geoCompletionItem;
@end

@interface WeatherIconsUtility : NSObject
+ (NSString *)lookupWeatherDescriptionShort:(int)arg1;
@end

@interface WeatherImageLoader : NSObject
+ (UIImage *)conditionImageWithConditionIndex:(int)arg1;
@end


@interface HourlyForecast : NSObject
- (NSString *)detail; // tempature
- (int)conditionCode;
- (NSString *)time;
@end

@interface DayForecast : NSObject
- (NSString *)high;
- (NSString *)low;
- (unsigned int)icon;
@end

@interface City : NSObject
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) double latitude;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic) double longitude;
@property (nonatomic, retain) MKSearchCompletion *searchCompletion;
- (void)update;
- (NSString *)temperature;
- (NSMutableArray *)dayForecasts;
- (NSMutableArray *)hourlyForecasts;
- (NSString *)name;
- (NSString *)naturalLanguageDescription;
- (NSDictionary *)dictionaryRepresentation;
@end

@interface WeatherPreferences : NSObject
+ (instancetype)sharedPreferences;
- (City*)localWeatherCity;
- (NSMutableArray *)loadSavedCities;
@end

@interface SBApplicationShortcutMenuContentView : UIView
@property (nonatomic, retain) UIView *hourlyWeatherView;
@property (nonatomic, retain) UILabel *cityLabel;
@property (nonatomic, retain) UIView *weatherDivider;
@property (nonatomic, retain) UILabel *conditionLabel;
@property (nonatomic, retain) UILabel *lowTempLabel;
@property (nonatomic, retain) UILabel *highTempLabel;
@property (nonatomic, retain) UILabel *bigTempLabel;
@property (nonatomic, retain) NSMutableArray *hourlyViews;
- (UILongPressGestureRecognizer *)highlightGesture;
- (void)_presentForFraction:(double)arg1;
- (void)_configureForMenuPosition:(NSInteger)arg1 menuItemCount:(NSInteger)arg2;
- (void)clearMenuBN;
- (void)showWeather;
@end

@interface UIImage (BNPrivate)
- (UIImage *)sbf_resizeImageToSize:(CGSize)arg1;
- (UIImage *)FU_imageTintedWithColor:(UIColor *)arg1;
- (UIImage *)_flatImageWithColor:(UIColor *)arg1;
@end

@interface UIApplicationShortcutItem (help)

+ (unsigned int)_sbsActivationModeFromUIActivationMode:(unsigned int)arg1;
+ (unsigned int)_uiActivationModeFromSBSActivationMode:(unsigned int)arg1;

- (id)_initWithType:(id)arg1 localizedTitle:(id)arg2 localizedSubtitle:(id)arg3 icon:(id)arg4 userInfoData:(id)arg5 activationMode:(unsigned int)arg6;
- (id)initWithSBSApplicationShortcutItem:(id)arg1;

@end

@interface SBApplication : NSObject
- (NSString*)bundleIdentifier;
@end

@interface MKSearchCompleter : NSObject
@end

@interface MKLocalSearchCompleter : MKSearchCompleter
- (BOOL)isSearching;
- (NSMutableArray*)results;
- (void)setFragment:(NSString *)arg1;
@end

@interface CLPlacemark (BNAPrivate)
@property (nonatomic, readonly, copy) NSString *subAdministrativeArea;
@property (nonatomic, readonly, copy) NSString *locality;
@end