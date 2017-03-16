#import <BulletinBoard/BBContent.h>
#import <BulletinBoard/BBSectionIcon.h>
#import <BulletinBoard/BBAccessoryIcon.h>
#import <BulletinBoard/BBSound.h>
#import <BulletinBoard/BBAttachmentMetadata.h>
#import <BulletinBoard/BBColor.h>
#import <BulletinBoard/BBAction.h>
#import <BulletinBoard/BBBulletin.h>

@class NSString, NSSet, NSArray, BBContent, BBSectionIcon, NSDate, NSTimeZone, BBAccessoryIcon, BBSound, BBAttachmentMetadata, BBAction;

@interface BBBulletinRequest : BBBulletin

@property (nonatomic,copy) NSString * bulletinID; 
@property (nonatomic,copy) NSString * sectionID; 
@property (nonatomic,copy) NSSet * subsectionIDs; 
@property (nonatomic,copy) NSString * recordID; 
@property (nonatomic,copy) NSString * publisherBulletinID; 
@property (nonatomic,copy) NSString * dismissalID; 
@property (nonatomic,copy) NSString * categoryID; 
@property (nonatomic,copy) NSString * threadID; 
@property (nonatomic,copy) NSArray * peopleIDs; 
@property (assign,nonatomic) NSInteger addressBookRecordID; 
@property (assign,nonatomic) NSInteger sectionSubtype; 
@property (nonatomic,copy) NSArray * intentIDs; 
@property (assign,nonatomic) NSUInteger counter; 
@property (nonatomic,copy) NSString * title; 
@property (nonatomic,copy) NSString * subtitle; 
@property (nonatomic,copy) NSString * message; 
@property (nonatomic,retain) BBContent * modalAlertContent; 
@property (nonatomic,retain) BBSectionIcon * icon; 
@property (assign,nonatomic) BOOL hasEventDate; 
@property (nonatomic,retain) NSDate * date; 
@property (nonatomic,retain) NSDate * endDate; 
@property (nonatomic,retain) NSDate * recencyDate; 
@property (assign,nonatomic) NSInteger dateFormatStyle; 
@property (assign,nonatomic) BOOL dateIsAllDay; 
@property (nonatomic,retain) NSTimeZone * timeZone; 
@property (nonatomic,retain) BBAccessoryIcon * accessoryIconMask; 
@property (assign,nonatomic) BOOL clearable; 
@property (nonatomic,retain) BBSound * sound; 
@property (assign,nonatomic) BOOL turnsOnDisplay; 
@property (nonatomic,copy) BBAttachmentMetadata * primaryAttachment; 
@property (nonatomic,copy) NSArray * additionalAttachments; 
@property (assign,nonatomic) BOOL wantsFullscreenPresentation; 
@property (assign,nonatomic) BOOL ignoresQuietMode; 
@property (nonatomic,copy) NSSet * alertSuppressionContexts; 
@property (nonatomic,copy) BBAction * defaultAction; 
@property (nonatomic,copy) BBAction * alternateAction; 
@property (nonatomic,copy) BBAction * acknowledgeAction; 
@property (nonatomic,copy) BBAction * dismissAction; 
@property (nonatomic,copy) BBAction * snoozeAction; 
@property (nonatomic,copy) BBAction * raiseAction; 
@property (nonatomic,copy) BBAction * silenceAction; 
@property (nonatomic,copy) NSArray * supplementaryActions; 
@property (nonatomic,retain) NSDate * expirationDate; 
@property (assign,nonatomic) NSUInteger expirationEvents;                 //@synthesize expirationEvents=_expirationEvents - In the implementation block
@property (nonatomic,copy) BBAction * expireAction; 
@property (assign,nonatomic) BOOL usesExternalSync; 
@property (assign,getter=isLoading,nonatomic) BOOL loading; 
@property (nonatomic,copy) NSArray * buttons; 
@property (nonatomic,retain) BBContent * starkBannerContent; 
@property (assign,nonatomic) BOOL expiresOnPublisherDeath; 
@property (nonatomic,copy) NSString * section; 
@property (assign,nonatomic) NSUInteger realertCount; 
@property (assign,nonatomic) BOOL showsUnreadIndicator; 
@property (assign,nonatomic) BOOL tentative; 
@property (assign,nonatomic) NSInteger primaryAttachmentType; 
-(void)publish;
-(NSUInteger)expirationEvents;
-(void)setExpirationEvents:(NSUInteger)arg1 ;
-(void)publish:(BOOL)arg1 ;
-(void)setSupplementaryActions:(id)arg1 forLayout:(NSInteger)arg2 ;
-(void)_updateSupplementaryAction:(id)arg1 ;
-(void)addButton:(id)arg1 ;
-(void)withdraw;
-(void)setUnlockActionLabel:(id)arg1 ;
-(void)addAlertSuppressionAppID:(id)arg1 ;
-(void)generateBulletinID;
-(void)setShowsUnreadIndicator:(BOOL)arg1 ;
-(BOOL)showsUnreadIndicator;
-(BOOL)tentative;
-(BOOL)hasContentModificationsRelativeTo:(id)arg1 ;
-(void)generateNewBulletinID;
-(void)setTentative:(BOOL)arg1 ;
-(void)setContextValue:(id)arg1 forKey:(id)arg2 ;
-(void)setSupplementaryActions:(NSArray *)arg1 ;
-(void)setPrimaryAttachmentType:(NSInteger)arg1 ;
-(void)addAttachmentOfType:(NSInteger)arg1 ;
-(NSUInteger)realertCount;
-(void)setRealertCount:(NSUInteger)arg1 ;
@end
