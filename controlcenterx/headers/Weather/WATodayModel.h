#import "WAForecastModel.h"

@class WATodayAutoupdatingLocationModel;

@interface WATodayModel : NSObject {

	NSHashTable* _observers;
	NSOperationQueue* _modelOperationQueue;
	WAForecastModel* _forecastModel;
	NSDate* _lastUpdateDate;

}

@property (nonatomic,retain) WAForecastModel * forecastModel;              //@synthesize forecastModel=_forecastModel - In the implementation block
@property (nonatomic,readonly) NSDate * lastUpdateDate;                    //@synthesize lastUpdateDate=_lastUpdateDate - In the implementation block
+(WATodayAutoupdatingLocationModel *)autoupdatingLocationModelWithPreferences:(id)arg1 effectiveBundleIdentifier:(id)arg2 ;
+(id)modelWithLocation:(id)arg1 ;
-(id)init;
-(void)addObserver:(id)arg1 ;
-(void)removeObserver:(id)arg1 ;
-(id)location;
-(NSDate *)lastUpdateDate;
-(id)initWithLocation:(id)arg1 ;
-(void)_locationUpdateCompleted:(id)arg1 error:(id)arg2 completion:(/*^block*/id)arg3 ;
-(void)_executeLocationUpdateWithCompletion:(/*^block*/id)arg1 ;
-(void)_forecastUpdateCompleted:(id)arg1 forecastModel:(id)arg2 error:(id)arg3 completion:(/*^block*/id)arg4 ;
-(void)_executeForecastRetrievalForLocation:(id)arg1 completion:(/*^block*/id)arg2 ;
-(WAForecastModel *)forecastModel;
-(void)setForecastModel:(WAForecastModel *)arg1 ;
-(void)_willDeliverForecastModel:(id)arg1 ;
-(void)_fireTodayModelForecastWasUpdated:(id)arg1 ;
-(void)_persistStateWithModel:(id)arg1 ;
-(BOOL)executeModelUpdateWithCompletion:(/*^block*/id)arg1 ;
-(void)_fireTodayModelWantsUpdate;
@end