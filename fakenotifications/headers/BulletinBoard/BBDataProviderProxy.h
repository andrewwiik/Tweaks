#import <BulletinBoard/BBDataProviderIdentity.h>

@interface BBDataProviderProxy : NSObject
@property (retain) BBDataProviderIdentity * identity;
-(void)updateIdentity:(/*^block*/id)arg1 ;
-(void)bulletinsWithRequestParameters:(id)arg1 lastCleared:(id)arg2 completion:(/*^block*/id)arg3 ;
-(void)clearedInfoForBulletins:(id)arg1 lastClearedInfo:(id)arg2 completion:(/*^block*/id)arg3 ;
-(void)clearedInfoForClearingAllBulletinsWithLastClearedInfo:(id)arg1 completion:(/*^block*/id)arg2 ;
-(void)clearedInfoForClearingBulletinsFromDate:(id)arg1 toDate:(id)arg2 lastClearedInfo:(id)arg3 completion:(/*^block*/id)arg4 ;
-(void)deliverBulletinActionResponse:(id)arg1 withCompletion:(/*^block*/id)arg2 ;
-(void)getDataForAttachmentUUID:(id)arg1 recordID:(id)arg2 isPrimary:(BOOL)arg3 withHandler:(/*^block*/id)arg4 ;
-(void)getPNGDataForAttachmentUUID:(id)arg1 recordID:(id)arg2 isPrimary:(BOOL)arg3 sizeConstraints:(id)arg4 withHandler:(/*^block*/id)arg5 ;
-(void)getAspectRatioForAttachmentUUID:(id)arg1 recordID:(id)arg2 isPrimary:(BOOL)arg3 withHandler:(/*^block*/id)arg4 ;
-(void)deliverMessageWithName:(id)arg1 userInfo:(id)arg2 ;
-(void)addBulletin:(id)arg1 forDestinations:(NSUInteger)arg2 ;
-(void)withdrawBulletinWithPublisherBulletinID:(id)arg1 ;
-(id)initWithDataProvider:(id)arg1 clientReplyQueue:(id)arg2 ;
-(void)_makeClientRequest:(/*^block*/id)arg1 ;
-(void)_makeServerRequest:(/*^blockad*/id)arg1 ;
-(void)updateSectionInfoWithHandler:(/*^block*/id)arg1 completion:(/*^block*/id)arg2 ;
-(void)reloadSectionParameters;
-(void)updateClearedInfoWithHandler:(/*^block*/id)arg1 ;
-(void)setServerProxy:(id)arg1 ;
-(void)addBulletin:(id)arg1 interrupt:(BOOL)arg2 ;
-(void)withdrawBulletinsWithRecordID:(id)arg1 ;
-(void)updateSectionInfoWithHandler:(/*^block*/id)arg1 ;
-(void)dataProviderDidLoad;
-(void)noteSectionInfoDidChange:(id)arg1 ;
-(void)invalidateBulletins;
-(void)reloadDefaultSectionInfo;
-(void)modifyBulletin:(id)arg1 ;
@end