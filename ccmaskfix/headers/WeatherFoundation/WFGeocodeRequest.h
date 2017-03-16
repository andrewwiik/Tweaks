#import "WFTask.h"
#import "WFLocation.h"

@interface WFGeocodeRequest : WFTask {

	/*^block*/id _resultHandler;
	NSString* _searchString;
	WFLocation* _geocodedResult;
	CLLocationCoordinate2D _coordinate;

}

@property (retain) NSString * searchString;                                         //@synthesize searchString=_searchString - In the implementation block
@property (assign) CLLocationCoordinate2D coordinate;                               //@synthesize coordinate=_coordinate - In the implementation block
@property (retain) WFLocation * geocodedResult;                                     //@synthesize geocodedResult=_geocodedResult - In the implementation block
@property (readonly) id resultHandler;                                              //@synthesize resultHandler=_resultHandler - In the implementation block
@property (readonly) NSString * searchTerm; 
-(id)description;
-(NSString *)searchString;
-(void)cleanup;
-(void)setSearchString:(NSString *)arg1 ;
-(void)handleResponse:(id)arg1 ;
-(NSString *)searchTerm;
-(id)resultHandler;
-(void)setCoordinate:(CLLocationCoordinate2D)arg1 ;
-(CLLocationCoordinate2D)coordinate;
-(id)initWithCoordinate:(CLLocationCoordinate2D)arg1 resultHandler:(/*^block*/id)arg2 ;
-(id)initWithSearchString:(id)arg1 resultHandler:(/*^block*/id)arg2 ;
-(void)startWithService:(id)arg1 ;
-(id)initWithSearchCompletion:(id)arg1 resultHandler:(/*^block*/id)arg2 ;
-(void)handleCancellation;
-(void)setGeocodedResult:(WFLocation *)arg1 ;
-(WFLocation *)geocodedResult;
@end