#import "BulletinBoard/BulletinBoard.h"


@interface SBAwayBulletinListItem : NSObject <NSCopying>
@property (assign,nonatomic) BOOL shouldPlayLightsAndSirens;                       //@synthesize shouldPlayLightsAndSirens=_shouldPlayLightsAndSirens - In the implementation block
@property (retain) BBBulletin *activeBulletin;                                    //@synthesize activeBulletin=_activeBulletin - In the implementation block
@property (retain) UIViewController *secondaryContentViewController;              //@synthesize secondaryContentViewController=_secondaryContentViewController - In the implementation block
-(void)prepareWithCompletion:(/*^block*/id)arg1;
-(void)setSecondaryContentViewController:(UIViewController *)arg1;
-(UIViewController *)secondaryContentViewController;
-(UIImage *)attachmentImageForKey:(id)arg1;
-(BBBulletin *)activeBulletin;
-(BOOL)wantsHighlightOnInsert;
-(BOOL)canBeRemovedByNotificationCenterPresentation;
-(BOOL)canBeRemovedByUnlock;
-(void)_updateActiveBulletin;
-(void)_updateSortDate;
-(void)_updateDisplayDate;
-(id)sortedBulletins;
-(void)setActiveBulletin:(BBBulletin *)arg1;
-(BOOL)_suppressesMessageForPrivacy;
-(unsigned long long)maxMessageLines;
-(id)bulletinWithID:(id)arg1;
-(BOOL)hasSamePersonAsBulletin:(id)arg1;
-(BOOL)_hasCustomSecondaryContent;
-(BOOL)canSnooze;
-(id)initWithBulletin:(id)arg1 andObserver:(id)arg2;
-(BOOL)containsBulletinWithID:(id)arg1;
-(BOOL)canCoalesceWithBulletin:(id)arg1;
-(long long)snoozeButtonindex;
-(id)description;
-(id)title;
-(id)date;
-(void)_update;
-(id)subtitle;
-(id)sortDate;
-(id)message;
-(id)observer;
-(UIImage *)iconImage;
-(BOOL)hasEventDate;
-(BOOL)wantsFullscreenPresentation;
-(BOOL)shouldPlayLightsAndSirens;
-(BOOL)inertWhenLocked;
-(BOOL)allowsAutomaticRemovalFromLockScreen;
-(BOOL)overridesQuietMode;
-(BOOL)overridesPocketMode;
-(void)_updateImage;
-(id)attachmentText;
-(void)_updateMessage;
-(id)publishDate;
-(void)setShouldPlayLightsAndSirens:(BOOL)arg1;
-(void)buttonPressed;
-(id)bulletins;
-(void)modifyBulletin:(id)arg1;
-(void)removeBulletin:(id)arg1;
-(void)removeAllBulletins;
-(BOOL)isCritical;
-(void)addBulletin:(id)arg1;
@end