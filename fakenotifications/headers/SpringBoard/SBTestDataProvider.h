#import <BulletinBoard/BBDataProviderProxy.h>

@interface SBTestDataProvider : NSObject {

	NSMutableArray* _bulletinRequests;
	BBDataProviderProxy* _proxy;

}

+(id)sharedInstance;
-(id)_existingBulletinRequestForPublisherBulletinID:(id)arg1 ;
-(id)_newBulletinRequest:(id)arg1 ;
-(void)_publishBulletinWithID:(id)arg1 ;
-(id)_publisherBulletinIDWithIndex:(NSInteger)arg1 ;
-(void)publishBulletinsWithCount:(NSInteger)arg1 ;
-(void)publish;
-(id)init;
-(void)update;
-(id)sortDescriptors;
-(id)sectionIdentifier;
-(id)defaultSectionInfo;
-(id)bulletinsWithRequestParameters:(id)arg1 lastCleared:(id)arg2 ;
-(id)clearedInfoForBulletins:(id)arg1 lastClearedInfo:(id)arg2 ;
-(id)clearedInfoForClearingAllBulletinsWithLastClearedInfo:(id)arg1 ;
-(id)clearedInfoForClearingBulletinsFromDate:(id)arg1 toDate:(id)arg2 lastClearedInfo:(id)arg3 ;
-(id)sectionParameters;
-(id)attachmentPNGDataForRecordID:(id)arg1 sizeConstraints:(id)arg2 ;
-(CGFloat)attachmentAspectRatioForRecordID:(id)arg1 ;
-(void)dataProviderDidLoad;
-(id)defaultSubsectionInfos;
-(id)displayNameForSubsectionID:(id)arg1 ;
-(void)noteSectionInfoDidChange:(id)arg1 ;
-(void)receiveMessageWithName:(id)arg1 userInfo:(id)arg2 ;
-(void)handleBulletinActionResponse:(id)arg1 ;
-(id)sectionDisplayName;
@end