#import <EventKit/EventKit.h>
#import <BulletinBoard/BBBulletin.h>

//static BOOL pageDrawn = nil;

//static int numberOfPages = 3; //Min is 2 max is unknown
static int prevHour = 0;
static BOOL shouldKeepAwake = NO;
//Current user name
// Test label
@interface SBFLockScreenDateView : UIView
+ (float)defaultHeight;
- (void)layoutSubviews;
@property(nonatomic, getter = isDateHidden) BOOL dateHidden;
- (id)initWithFrame:(struct CGRect)arg1;
- (void)setCustomSubtitleText:(id)arg1 withColor:(id)arg2;
- (float)dateBaselineOffsetFromOrigin;
- (float)timeBaselineOffsetFromOrigin;
@end

@interface SBLockScreenView : UIView
	@property(retain, nonatomic) SBFLockScreenDateView *dateView;
- (void)setTopBottomGrabbersHidden:(_Bool)arg1 forRequester:(id)arg2;
@end

@interface SBTodayTableViewCell : UIView
	@property(copy, nonatomic) NSString *labelText;
@end

@interface SBLockScreenScrollView : UIScrollView
- (void)setUserInteractionEnabled:(_Bool)arg1;
- (_Bool)gestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2;
- (_Bool)touchesShouldCancelInContentView:(id)arg1;
@end

@interface SBTodayViewController : UIViewController
- (void)listSubviewsOfView:(UIView *)view;
@end

@interface BBBulletinRequest : BBBulletin
@end

/*
@interface BBBulletin : NSObject
- (id)message;
- (id)section;
- (id)publisherBulletinID;
@end
*/