#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <MediaPlayer/MediaPlayer.h>
//#import <MediaPlayer/MPMediaPropertyPredicate.h>
#import <QuartzCore/QuartzCore.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import "CWStatusBarNotification.h"


extern "C" void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id unknown, NSDictionary *options);

void hapticVibe(){
        NSMutableDictionary* VibrationDictionary = [NSMutableDictionary dictionary];
        NSMutableArray* VibrationArray = [NSMutableArray array ];
        [VibrationArray addObject:[NSNumber numberWithBool:YES]];
        [VibrationArray addObject:[NSNumber numberWithInt:30]]; //vibrate for 50ms
        [VibrationDictionary setObject:VibrationArray forKey:@"VibePattern"];
        [VibrationDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
        AudioServicesPlaySystemSoundWithVibration(4095,nil,VibrationDictionary);
}

/* Notifications */




static int const UITapticEngineFeedbackPop = 1002;
@interface UITapticEngine : NSObject
- (void)actuateFeedback:(int)arg1;
- (void)endUsingFeedback:(int)arg1;
- (void)prepareUsingFeedback:(int)arg1;
@end
@interface UIDevice (Private)
-(UITapticEngine*)_tapticEngine;
@end

@interface UIForceGestureRecognizer : UILongPressGestureRecognizer
@property (nonatomic, readwrite) CGFloat currentForce;
@property (nonatomic) CGFloat minimumForce;
- (BOOL)forceTouchSupported;
- (NSString *)platform;
- (void)cancel;
@end

@interface MusicHUDViewController : UIViewController

@property (nonatomic) double dismissalDelay;
@property (nonatomic) BOOL shouldWaitForExplicitDismissal;
@property (nonatomic, copy) NSString *text;

//- (void).cxx_destruct;
- (void)_dismissHUDAnimated:(BOOL)arg1 completion:(id /* block */)arg2;
- (void)_playAnimation;
- (void)dismiss;
- (void)dismissAnimated:(BOOL)arg1 completion:(id /* block */)arg2;
- (double)dismissalDelay;
- (id)initWithHUDType:(int)arg1;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
- (void)presentFromRootViewController;
- (void)setDismissalDelay:(double)arg1;
- (void)setShouldWaitForExplicitDismissal:(BOOL)arg1;
- (void)setText:(NSString*)arg1;
- (BOOL)shouldWaitForExplicitDismissal;
- (NSString*)text;
- (void)viewDidAppear:(BOOL)arg1;
- (void)viewDidLayoutSubviews;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)arg1;

@end

@interface UITouch (Private)


@property (nonatomic, readonly) float force;
@property (nonatomic, readonly) float maximumPossibleForce;
- (void)_setPressure:(float)arg1 resetPrevious:(BOOL)arg2;
- (float)_pathMajorRadius;
- (float)majorRadius;
- (id)_hidEvent;
- (CGFloat)pressureBuddy;
@end


#import <UIKit/UIGestureRecognizerSubclass.h>

@interface NSString (UIForceGestureRecognizer)
- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end;
@end

@implementation NSString (UIForceGestureRecognizer)
- (NSString*) stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;   
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
           targetRange.length = endRange.location - targetRange.location;
           return [self substringWithRange:targetRange];
        }
    }
    return nil;
}
@end

@interface UITouch (UIForceGestureRecognizer)
- (CGFloat)getQuality;
- (CGFloat)getRadius;
- (CGFloat)getDensity;
- (int)getX;
- (int)getY;
@end

@implementation UITouch (UIForceGestureRecognizer)

- (CGFloat)getQuality {
    return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Quality:" andString:@"Density:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}

- (CGFloat)getDensity {
    return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Density:" andString:@"Irregularity:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];  
}

- (CGFloat)getRadius {
    return (CGFloat)[[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"MajorRadius:" andString:@"MinorRadius:"] stringByReplacingOccurrencesOfString:@" " withString:@""] floatValue];
}

- (int)getX {
return [[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"X:" andString:@"Y:"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
}

- (int)getY {
    return [[[[NSString stringWithFormat: @"%@", [self _hidEvent]] stringBetweenString:@"Y:" andString:@"Z:"] stringByReplacingOccurrencesOfString:@" " withString:@""] intValue];
}
@end

%hook UITouch
%new
- (CGFloat)pressureBuddy {
    return MSHookIvar<CGFloat>(self, "_previousPressure");
}
%end

static CGFloat Density;
static CGFloat Radius;
static CGFloat Quality;
static int X;
static int Y;

static CGFloat lastDensity;
static CGFloat lastRadius;
static CGFloat lastQuality;
static int lastX;
static int lastY;

BOOL hasIncreasedByPercent(float percent, float value1, float value2) {

    if (value1 <= 0 || value2 <= 0)
        return NO;
    if (value1 >= value2 + (value2 / percent))
        return YES;
    return NO;
}

@implementation UIForceGestureRecognizer
- (void)cancel {
    self.state = UIGestureRecognizerStateCancelled;
}
- (id)initWithTarget:(id)target action:(SEL)action{
    if ((self = [super initWithTarget:target action:action])){
        // so simple there's no setup
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (![self forceTouchSupported])
    Radius = [touch getRadius];
    X = [touch getX];
    Y = [touch getY];
    Density = [touch getDensity];
    Quality = [touch getQuality];
    //touchPoint = CGPointMake( X, Y);
    /* if ([touch _pathMajorRadius] > 40) {
        self.state = UIGestureRecognizerStateBegan;
        MenuOpen = YES;
    } */
    if (hasIncreasedByPercent(15, Density, lastDensity) && hasIncreasedByPercent(15, Radius, lastRadius)) {
        self.state = UIGestureRecognizerStateBegan;
    //self.cancelsTouchesInView = YES;
        NSLog(@"Begin Complete");
        //MenuOpen = YES;
    }
    lastRadius = Radius;
    lastX = X;
    lastY = Y;
    lastDensity = Density;
    lastQuality = Quality;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (![self forceTouchSupported]) {
        Radius = [touch getRadius];
        X = [touch getX];
        Y = [touch getY];
        Density = [touch getDensity];
        Quality = [touch getQuality];
        //touchPoint = CGPointMake( X, Y);
        if (self.state == UIGestureRecognizerStatePossible) { 
            if ((lastX - [touch getX] >= 10 || lastX - [touch getX] <= -10) || (lastY - [touch getY] >= 10 || lastY - [touch getY] <= -10)) {
                self.state = UIGestureRecognizerStateFailed;
                NSLog(@"Too Much Movement");
            }
            else if (hasIncreasedByPercent(15, Density, lastDensity) && hasIncreasedByPercent(15, Radius, lastRadius)) {
                self.state = UIGestureRecognizerStateBegan;
          // self.cancelsTouchesInView = YES;
                //MenuOpen = YES;
            }
        }
        if (self.state == UIGestureRecognizerStateChanged) {
            self.state = UIGestureRecognizerStateChanged;
        }
        lastRadius = Radius;
        lastX = X;
        lastY = Y;
        lastDensity = Density;
        lastQuality = Quality;
    }
    else {
        CGFloat pressure = [touch pressureBuddy];
        if (pressure > 300) {
            self.state = UIGestureRecognizerStateEnded;
        }
    //touchPoint = CGPointMake( X, Y);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
    [self reset];
    //MenuOpen = NO;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
    [self reset];
}

-(void)reset{
    [super reset];
  lastRadius = 0;
  lastX = 0;
  lastY = 0;
  lastDensity = 0;
  lastQuality = 0;
  //touchPoint = CGPointMake( 0, 0);
}

- (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
- (BOOL)forceTouchSupported {
    return ([[[self platform] substringToIndex: 7] isEqualToString:@"iPhone8"]);
}

@end

%group Music

@interface MusicStoreItemMetadataContext : NSObject
@property (nonatomic, readonly, copy) NSString *storeID;
@end

@interface MPConcreteMediaItem : NSObject
-(unsigned long long)persistentID;
-(MPMediaQuery *)itemsQuery;
@property (nonatomic, readonly) MusicStoreItemMetadataContext *storeItemMetadataContext;
@end
%hook MPConcreteMediaItem
-(MPMediaQuery *)itemsQuery {
    return %orig;
}
%end
@interface MusicEntityValueContext : NSObject
@property (nonatomic, retain) MPConcreteMediaItem *itemEntityValueProvider;
@end

@interface MusicLibraryBrowseTableViewController : UITableViewController {
    MusicEntityValueContext *_itemEntityValueContext;
}

@end
/* End of Force Gesture Recongizer */
@interface MusicContextualUpNextAlertAction : NSObject
+ (instancetype)contextualUpNextActionWithEntityValueContext:(id)arg1 insertionType:(int)arg2 didDismissHandler:(id)arg3;
- (void)_handleUpNextAction;
- (id)initWithPlaybackContext:(id)arg1;
@end


@interface MusicEntityValueProvider : NSObject
@property (nonatomic, readonly) MPConcreteMediaItem *baseEntityValueProvider;
@end


@interface  MusicTableView : UITableView
@end

@interface MusicCoalescingEntityValueProvider : NSObject
- (NSString *)valueForEntityProperty:(NSString *)property;
@property (nonatomic, readonly) MPConcreteMediaItem *baseEntityValueProvider;

@end

@interface MusicEntityHorizontalLockupTableViewCell : UITableViewCell //<DFContinuousForceTouchDelegate>
@property (nonatomic, retain) MusicCoalescingEntityValueProvider *entityValueProvider;

/*- (void) forceTouchRecognized:(DFContinuousForceTouchGestureRecognizer*)recognizer;
- (void) forceTouchRecognizer:(DFContinuousForceTouchGestureRecognizer*)recognizer didMoveWithForce:(CGFloat)force maxForce:(CGFloat)maxForce;
- (void) forceTouchRecognizer:(DFContinuousForceTouchGestureRecognizer*)recognizer didStartWithForce:(CGFloat)force maxForce:(CGFloat)maxForce;
- (void) forceTouchRecognizer:(DFContinuousForceTouchGestureRecognizer*)recognizer didCancelWithForce:(CGFloat)force maxForce:(CGFloat)maxForce;
- (void) forceTouchRecognizer:(DFContinuousForceTouchGestureRecognizer*)recognizer didEndWithForce:(CGFloat)force maxForce:(CGFloat)maxForce;
- (void) forceTouchDidTimeout:(DFContinuousForceTouchGestureRecognizer*)recognizer; */


@end


@interface MusicTableView (Private)
- (MusicLibraryBrowseTableViewController *)delegate;
- (MusicEntityHorizontalLockupTableViewCell*)_nearestCellToPoint:(CGPoint)point;
@end

@interface MusicEntityHorizontalLockupTableViewCell (Private)
- (NSString *)platform;
- (MusicTableView *)_tableView;
@end

@interface MusicQueryPlaybackContext : NSObject
- (id)initWithQuery:(id)arg1;
@end

@interface MusicStorePlaybackContext : NSObject
- (id)initWithStoreIDs:(NSArray *)arg1;
@end


@interface MusicLibraryBrowseTableViewController (PrivateStuff) <UIGestureRecognizerDelegate>
- (NSString *)platform;
- (BOOL)is6S;
- (void)hapticFeedback;
@property (nonatomic, retain) UIForceGestureRecognizer *forcePress;
- (MusicEntityValueContext *)_entityValueContextAtIndexPath:(id)arg1;
@end

@interface UITableView (Cabbage)
- (MusicEntityHorizontalLockupTableViewCell *)_nearestCellToPoint:(CGPoint)point;
@end

@interface MusicAVPlayer : NSObject
+ (instancetype)sharedAVPlayer;
@end

@interface UITableViewCell (Cabbage)
@property (nonatomic, retain) MusicCoalescingEntityValueProvider *entityValueProvider;
@end

%hook MusicContextualUpNextAlertAction
%new
- (id)initWithPlaybackContext:(id)context {
    self = [self init];
    if (self) {
        MSHookIvar<id>(self,"_player") = [%c(MusicAVPlayer) sharedAVPlayer];
        MSHookIvar<id>(self,"_playbackContext") = context;
        MSHookIvar<NSInteger>(self,"_insertionType") = 1;
    }
    return self;
}
%end

%hook MusicLibraryBrowseTableViewController

%property (nonatomic, retain) UIForceGestureRecognizer *forcePress;
- (void)viewDidLoad {
    %orig;
    if (self.forcePress) {

    }
    else {
        //if ([[self delegate] isKindOfClass:[NSClassFromString(@"MusicLibraryBrowseTableViewController") class]]) {
            //if (![self isKindOfClass:[%c(MusicProfileAlbumsViewController) class]]) {
    UIForceGestureRecognizer *forcePress = [[UIForceGestureRecognizer alloc] initWithTarget:self action:@selector(_handleForcePress:)];
    forcePress.minimumPressDuration = 300;
    forcePress.cancelsTouchesInView = YES;
    forcePress.minimumForce = 10;
    forcePress.delegate = self;
    [self.tableView addGestureRecognizer:forcePress];
    self.forcePress = forcePress;
//}
//}
}
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
%new
- (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

%new
- (BOOL)is6S {
    return ([[[self platform] substringToIndex: 7] isEqualToString:@"iPhone8"]);
}
%new
- (void)hapticFeedback {
    if ([self is6S]) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(_tapticEngine)]) {
            UITapticEngine *tapticEngine = [UIDevice currentDevice]._tapticEngine;
            if (tapticEngine) {
            [tapticEngine actuateFeedback:UITapticEngineFeedbackPop];
            }
        }
    }
    else {
        hapticVibe();
    }
}
%new
- (void)_handleForcePress:(UIForceGestureRecognizer *)gesture {
    if (![self is6S]) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            //indexPathForRowAtPoint:(CGPoint)point
            //[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]];
            if ([[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider.baseEntityValueProvider respondsToSelector:@selector(persistentID)]) {
                NSNumber *UpNextID = [[NSNumber alloc] initWithUnsignedLongLong:[[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider.baseEntityValueProvider persistentID]];
                if (!(UpNextID == 0)) {
                    NSLog(@"Number: %@", UpNextID);
                    MPMediaQuery *query = nil;
                    //MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:UpNextID forProperty:MPMediaItemPropertyPersistentID];
                    if ([[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider.baseEntityValueProvider respondsToSelector:@selector(itemsQuery)]) {
                        query = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider.baseEntityValueProvider itemsQuery];
                    }
                    else {
                    //MPMediaQuery *query = [MPMediaPropertyPredicate predicateWithValue:UpNextID forProperty:MPMediaItemPropertyPersistentID];
                    }
                    if (query) {
                        [[[%c(MusicContextualUpNextAlertAction) alloc] initWithPlaybackContext:[[%c(MusicQueryPlaybackContext) alloc] initWithQuery:query]] _handleUpNextAction];
                    
                    }
                    else {
                    [[[%c(MusicContextualUpNextAlertAction) alloc] initWithPlaybackContext:[[%c(MusicQueryPlaybackContext) alloc] initWithQuery:[[MPMediaQuery alloc] initWithFilterPredicates: [NSSet setWithObjects: [MPMediaPropertyPredicate predicateWithValue:UpNextID forProperty:MPMediaItemPropertyPersistentID], nil]]]] _handleUpNextAction];
                    }
                    [self hapticFeedback];
                    CWStatusBarNotification *notification = [CWStatusBarNotification new];
                    notification.notificationLabelTextColor =  [UIColor whiteColor];//[[UIApplication sharedApplication] delegate].window.tintColor;
                    //notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
                    NSString *title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"title"];
                    NSString *fullTitle = [NSString stringWithFormat:@"'%@' was added to 'Up Next'", title];
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"albumName"];
                        fullTitle = [NSString stringWithFormat:@"Songs from '%@' were added to 'Up Next'", title];

                    }
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"albumArtistName"];
                        fullTitle = [NSString stringWithFormat:@"All songs by %@ were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"genreName"];
                        fullTitle = [NSString stringWithFormat:@"All %@ songs were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"composerName"];
                        fullTitle = [NSString stringWithFormat:@"All songs composed by '%@' were added to 'Up Next'", title];
                    }
                    //notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
                    [notification displayNotificationWithMessage:fullTitle
                           forDuration:1.5f];
                    notification = nil;
                    //MusicHUDViewController *hud = [[%c(MusicHUDViewController) alloc] initWithHUDType:3];
                    //hud.text = @"Added";
                    //[hud presentFromRootViewController];
                }
            }
            else {
                if ([[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider.baseEntityValueProvider respondsToSelector:@selector(storeItemMetadataContext)] && !([[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"musicCopyrightText"])) {
                    NSString *storeID = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider.baseEntityValueProvider.storeItemMetadataContext.storeID;
                    [[[%c(MusicContextualUpNextAlertAction) alloc] initWithPlaybackContext:[[%c(MusicStorePlaybackContext) alloc] initWithStoreIDs:[NSArray arrayWithObjects:storeID, nil]]] _handleUpNextAction];
                    [self hapticFeedback];
                    CWStatusBarNotification *notification = [CWStatusBarNotification new];
                    notification.notificationLabelTextColor =  [UIColor whiteColor];//[[UIApplication sharedApplication] delegate].window.tintColor;
                    //notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
                    NSString *title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"title"];
                    NSString *fullTitle = [NSString stringWithFormat:@"'%@' was added to 'Up Next'", title];
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"albumName"];
                        fullTitle = [NSString stringWithFormat:@"Songs from '%@' were added to 'Up Next'", title];

                    }
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"albumArtistName"];
                        fullTitle = [NSString stringWithFormat:@"All songs by %@ were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"genreName"];
                        fullTitle = [NSString stringWithFormat:@"All %@ songs were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"composerName"];
                        fullTitle = [NSString stringWithFormat:@"All songs composed by '%@' were added to 'Up Next'", title];
                    }
                    [notification displayNotificationWithMessage:fullTitle
                           forDuration:1.5f];
                    notification = nil;
                }

            }
        }
    }
    else {
        if (gesture.state == UIGestureRecognizerStateEnded) {
            if ([[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider.baseEntityValueProvider respondsToSelector:@selector(persistentID)]) {
                NSNumber *UpNextID = [[NSNumber alloc] initWithUnsignedLongLong:[[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider.baseEntityValueProvider persistentID]];
                if (!(UpNextID == 0)) {
                    NSLog(@"Number: %@", UpNextID);
                    MPMediaQuery *query = nil;
                    //MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:UpNextID forProperty:MPMediaItemPropertyPersistentID];
                    if ([[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider.baseEntityValueProvider respondsToSelector:@selector(itemsQuery)]) {
                        query = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider.baseEntityValueProvider itemsQuery];
                    }
                    else {
                    //MPMediaQuery *query = [MPMediaPropertyPredicate predicateWithValue:UpNextID forProperty:MPMediaItemPropertyPersistentID];
                    }
                    if (query) {
                        [[[%c(MusicContextualUpNextAlertAction) alloc] initWithPlaybackContext:[[%c(MusicQueryPlaybackContext) alloc] initWithQuery:query]] _handleUpNextAction];
                    
                    }
                    else {
                    [[[%c(MusicContextualUpNextAlertAction) alloc] initWithPlaybackContext:[[%c(MusicQueryPlaybackContext) alloc] initWithQuery:[[MPMediaQuery alloc] initWithFilterPredicates: [NSSet setWithObjects: [MPMediaPropertyPredicate predicateWithValue:UpNextID forProperty:MPMediaItemPropertyPersistentID], nil]]]] _handleUpNextAction];
                    }
                    [self hapticFeedback];
                    CWStatusBarNotification *notification = [CWStatusBarNotification new];
                    notification.notificationLabelTextColor =  [UIColor whiteColor];//[[UIApplication sharedApplication] delegate].window.tintColor;
                    //notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
                    NSString *title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"title"];
                    NSString *fullTitle = [NSString stringWithFormat:@"'%@' was added to 'Up Next'", title];
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"albumName"];
                        fullTitle = [NSString stringWithFormat:@"Songs from '%@' were added to 'Up Next'", title];

                    }
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"albumArtistName"];
                        fullTitle = [NSString stringWithFormat:@"All songs by %@ were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"genreName"];
                        fullTitle = [NSString stringWithFormat:@"All %@ songs were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"composerName"];
                        fullTitle = [NSString stringWithFormat:@"All songs composed by '%@' were added to 'Up Next'", title];
                    }
                    [notification displayNotificationWithMessage:fullTitle
                           forDuration:1.5f];
                    notification = nil;
                    //MusicHUDViewController *hud = [[%c(MusicHUDViewController) alloc] initWithHUDType:3];
                    //hud.text = @"Added";
                    //[hud presentFromRootViewController];
                }
            }
            else {
                if ([[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider.baseEntityValueProvider respondsToSelector:@selector(storeItemMetadataContext)] && !([[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"musicCopyrightText"])) {
                    NSString *storeID = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider.baseEntityValueProvider.storeItemMetadataContext.storeID;
                    [[[%c(MusicContextualUpNextAlertAction) alloc] initWithPlaybackContext:[[%c(MusicStorePlaybackContext) alloc] initWithStoreIDs:[NSArray arrayWithObjects:storeID, nil]]] _handleUpNextAction];
                    [self hapticFeedback];
                    CWStatusBarNotification *notification = [CWStatusBarNotification new];
                    notification.notificationLabelTextColor =  [UIColor whiteColor];//[[UIApplication sharedApplication] delegate].window.tintColor;
                    //notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
                    NSString *title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"title"];
                    NSString *fullTitle = [NSString stringWithFormat:@"'%@' was added to 'Up Next'", title];
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"albumName"];
                        fullTitle = [NSString stringWithFormat:@"Songs from '%@' were added to 'Up Next'", title];

                    }
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"albumArtistName"];
                        fullTitle = [NSString stringWithFormat:@"All songs by %@ were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"genreName"];
                        fullTitle = [NSString stringWithFormat:@"All %@ songs were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]]].entityValueProvider valueForEntityProperty:@"composerName"];
                        fullTitle = [NSString stringWithFormat:@"All songs composed by '%@' were added to 'Up Next'", title];
                    }
                    [notification displayNotificationWithMessage:fullTitle
                           forDuration:1.5f];
                    notification = nil;
                }

            }
        }
    }
}
%end
@interface MusicNowPlayingViewController : UIViewController
@end
%hook MusicNowPlayingViewController
- (void)viewDidLoad {
    %orig;
    self.navigationController.navigationBar.translucent = NO; 
}
%end
@interface MusicEntityHorizontalLockupTableViewHeaderFooterView : UITableViewHeaderFooterView <UIGestureRecognizerDelegate>
@property (nonatomic, retain) MusicCoalescingEntityValueProvider *entityValueProvider;
@property (nonatomic, retain) UIForceGestureRecognizer *forcePress;
-(BOOL)is6S;
-(NSString *)platform;
-(void)hapticFeedback;
@end



%hook MusicEntityHorizontalLockupTableViewHeaderFooterView
%property (nonatomic, retain) UIForceGestureRecognizer *forcePress;
-(void)layoutSubviews {
    %orig;
    if (self.forcePress) {

    }
    else {
        //if ([[self delegate] isKindOfClass:[NSClassFromString(@"MusicLibraryBrowseTableViewController") class]]) {
        UIForceGestureRecognizer *forcePress = [[UIForceGestureRecognizer alloc] initWithTarget:self action:@selector(_handleForcePress:)];
        forcePress.minimumPressDuration = 300;
        forcePress.cancelsTouchesInView = YES;
        forcePress.minimumForce = 10;
        forcePress.delegate = self;
        [self addGestureRecognizer:forcePress];
        self.forcePress = forcePress;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
%new
- (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

%new
- (BOOL)is6S {
    return ([[[self platform] substringToIndex: 7] isEqualToString:@"iPhone8"]);
}
%new
- (void)hapticFeedback {
    if ([self is6S]) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(_tapticEngine)]) {
            UITapticEngine *tapticEngine = [UIDevice currentDevice]._tapticEngine;
            if (tapticEngine) {
            [tapticEngine actuateFeedback:UITapticEngineFeedbackPop];
            }
        }
    }
    else {
        hapticVibe();
    }
}

%new
- (void)_handleForcePress:(UIForceGestureRecognizer *)gesture {
    if (![self is6S]) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            [self.forcePress cancel];
            //indexPathForRowAtPoint:(CGPoint)point
            //self;
            if ([self.entityValueProvider.baseEntityValueProvider respondsToSelector:@selector(persistentID)]) {
                NSNumber *UpNextID = [[NSNumber alloc] initWithUnsignedLongLong:[self.entityValueProvider.baseEntityValueProvider persistentID]];
                if (!(UpNextID == 0)) {
                    NSLog(@"Number: %@", UpNextID);
                    MPMediaQuery *query = nil;
                    //MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:UpNextID forProperty:MPMediaItemPropertyPersistentID];
                    if ([self.entityValueProvider.baseEntityValueProvider respondsToSelector:@selector(itemsQuery)]) {
                        query = [self.entityValueProvider.baseEntityValueProvider itemsQuery];
                    }
                    else {
                    //MPMediaQuery *query = [MPMediaPropertyPredicate predicateWithValue:UpNextID forProperty:MPMediaItemPropertyPersistentID];
                    }
                    if (query) {
                        [[[%c(MusicContextualUpNextAlertAction) alloc] initWithPlaybackContext:[[%c(MusicQueryPlaybackContext) alloc] initWithQuery:query]] _handleUpNextAction];
                    
                    }
                    else {
                    [[[%c(MusicContextualUpNextAlertAction) alloc] initWithPlaybackContext:[[%c(MusicQueryPlaybackContext) alloc] initWithQuery:[[MPMediaQuery alloc] initWithFilterPredicates: [NSSet setWithObjects: [MPMediaPropertyPredicate predicateWithValue:UpNextID forProperty:MPMediaItemPropertyPersistentID], nil]]]] _handleUpNextAction];
                    }
                    [self hapticFeedback];
                    CWStatusBarNotification *notification = [[CWStatusBarNotification alloc] init];
                    notification.notificationLabelTextColor =  [UIColor whiteColor];//[[UIApplication sharedApplication] delegate].window.tintColor;
                    //notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
                    NSString *title = [self.entityValueProvider valueForEntityProperty:@"title"];
                    NSString *fullTitle = [NSString stringWithFormat:@"'%@' was added to 'Up Next'", title];
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"albumName"];
                        fullTitle = [NSString stringWithFormat:@"Songs from '%@' were added to 'Up Next'", title];

                    }
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"albumArtistName"];
                        fullTitle = [NSString stringWithFormat:@"All songs by %@ were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"genreName"];
                        fullTitle = [NSString stringWithFormat:@"All %@ songs were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"composerName"];
                        fullTitle = [NSString stringWithFormat:@"All songs composed by '%@' were added to 'Up Next'", title];
                    }
                    [notification displayNotificationWithMessage:fullTitle
                           forDuration:1.5f];
                    notification = nil;
                    //MusicHUDViewController *hud = [[%c(MusicHUDViewController) alloc] initWithHUDType:3];
                    //hud.text = @"Added";
                    //[hud presentFromRootViewController];
                }
            }
            else {
                if ([self.entityValueProvider.baseEntityValueProvider respondsToSelector:@selector(storeItemMetadataContext)] && !([self.entityValueProvider valueForEntityProperty:@"musicCopyrightText"])) {
                    NSString *storeID = self.entityValueProvider.baseEntityValueProvider.storeItemMetadataContext.storeID;
                    [[[%c(MusicContextualUpNextAlertAction) alloc] initWithPlaybackContext:[[%c(MusicStorePlaybackContext) alloc] initWithStoreIDs:[NSArray arrayWithObjects:storeID, nil]]] _handleUpNextAction];
                    [self hapticFeedback];
                    CWStatusBarNotification *notification = [CWStatusBarNotification new];
                    notification.notificationLabelTextColor =  [UIColor whiteColor];//[[UIApplication sharedApplication] delegate].window.tintColor;
                    //notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
                    NSString *title = [self.entityValueProvider valueForEntityProperty:@"title"];
                    NSString *fullTitle = [NSString stringWithFormat:@"'%@' was added to 'Up Next'", title];
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"albumName"];
                        fullTitle = [NSString stringWithFormat:@"Songs from '%@' were added to 'Up Next'", title];

                    }
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"albumArtistName"];
                        fullTitle = [NSString stringWithFormat:@"All songs by %@ were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"genreName"];
                        fullTitle = [NSString stringWithFormat:@"All %@ songs were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"composerName"];
                        fullTitle = [NSString stringWithFormat:@"All songs composed by '%@' were added to 'Up Next'", title];
                    }
                    [notification displayNotificationWithMessage:fullTitle
                           forDuration:1.5f];
                    notification = nil;
                }

            }
        }
    }
    else {
        if (gesture.state == UIGestureRecognizerStateEnded) {
            if ([self.entityValueProvider.baseEntityValueProvider respondsToSelector:@selector(persistentID)]) {
                NSNumber *UpNextID = [[NSNumber alloc] initWithUnsignedLongLong:[self.entityValueProvider.baseEntityValueProvider persistentID]];
                if (!(UpNextID == 0)) {
                    NSLog(@"Number: %@", UpNextID);
                    MPMediaQuery *query = nil;
                    //MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:UpNextID forProperty:MPMediaItemPropertyPersistentID];
                    if ([self.entityValueProvider.baseEntityValueProvider respondsToSelector:@selector(itemsQuery)]) {
                        query = [self.entityValueProvider.baseEntityValueProvider itemsQuery];
                    }
                    else {
                    //MPMediaQuery *query = [MPMediaPropertyPredicate predicateWithValue:UpNextID forProperty:MPMediaItemPropertyPersistentID];
                    }
                    if (query) {
                        [[[%c(MusicContextualUpNextAlertAction) alloc] initWithPlaybackContext:[[%c(MusicQueryPlaybackContext) alloc] initWithQuery:query]] _handleUpNextAction];
                    
                    }
                    else {
                    [[[%c(MusicContextualUpNextAlertAction) alloc] initWithPlaybackContext:[[%c(MusicQueryPlaybackContext) alloc] initWithQuery:[[MPMediaQuery alloc] initWithFilterPredicates: [NSSet setWithObjects: [MPMediaPropertyPredicate predicateWithValue:UpNextID forProperty:MPMediaItemPropertyPersistentID], nil]]]] _handleUpNextAction];
                    }
                    [self hapticFeedback];
                    CWStatusBarNotification *notification = [CWStatusBarNotification new];
                    notification.notificationLabelTextColor =  [UIColor whiteColor];//[[UIApplication sharedApplication] delegate].window.tintColor;
                    //notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
                    NSString *title = [self.entityValueProvider valueForEntityProperty:@"title"];
                    NSString *fullTitle = [NSString stringWithFormat:@"'%@' was added to 'Up Next'", title];
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"albumName"];
                        fullTitle = [NSString stringWithFormat:@"Songs from '%@' were added to 'Up Next'", title];

                    }
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"albumArtistName"];
                        fullTitle = [NSString stringWithFormat:@"All songs by %@ were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"genreName"];
                        fullTitle = [NSString stringWithFormat:@"All %@ songs were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"composerName"];
                        fullTitle = [NSString stringWithFormat:@"All songs composed by '%@' were added to 'Up Next'", title];
                    }
                    [notification displayNotificationWithMessage:fullTitle
                           forDuration:1.5f];
                    notification = nil;
                    //MusicHUDViewController *hud = [[%c(MusicHUDViewController) alloc] initWithHUDType:3];
                    //hud.text = @"Added";
                    //[hud presentFromRootViewController];
                }
            }
            else {
                if ([self.entityValueProvider.baseEntityValueProvider respondsToSelector:@selector(storeItemMetadataContext)] && !([self.entityValueProvider valueForEntityProperty:@"musicCopyrightText"])) {
                    NSString *storeID = self.entityValueProvider.baseEntityValueProvider.storeItemMetadataContext.storeID;
                    [[[%c(MusicContextualUpNextAlertAction) alloc] initWithPlaybackContext:[[%c(MusicStorePlaybackContext) alloc] initWithStoreIDs:[NSArray arrayWithObjects:storeID, nil]]] _handleUpNextAction];
                    [self hapticFeedback];
                    CWStatusBarNotification *notification = [CWStatusBarNotification new];
                    notification.notificationLabelTextColor =  [UIColor whiteColor];//[[UIApplication sharedApplication] delegate].window.tintColor;
                    //notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
                    NSString *title = [self.entityValueProvider valueForEntityProperty:@"title"];
                    NSString *fullTitle = [NSString stringWithFormat:@"'%@' was added to 'Up Next'", title];
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"albumName"];
                        fullTitle = [NSString stringWithFormat:@"Songs from '%@' were added to 'Up Next'", title];

                    }
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"albumArtistName"];
                        fullTitle = [NSString stringWithFormat:@"All songs by %@ were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"genreName"];
                        fullTitle = [NSString stringWithFormat:@"All %@ songs were added to 'Up Next'", title];
                    }
                    if (!title) {
                        title = [self.entityValueProvider valueForEntityProperty:@"composerName"];
                        fullTitle = [NSString stringWithFormat:@"All songs composed by '%@' were added to 'Up Next'", title];
                    }
                    [notification displayNotificationWithMessage:fullTitle
                           forDuration:1.5f];
                    notification = nil;
                }
            }
        }
    }
}
%end

%hook MusicStorePlaybackContext
- (id)initWithStoreIDs:(id)arg1 {
    NSLog(@"Class for IDs: %@", [arg1 class]);
    return %orig;
}
%end
%end

%group Podcasts

@interface MTUpNextController : NSObject
+ (instancetype)sharedInstance;
- (void)addEpisodeUuidToUpNext:(NSString *)uuid;
@end
@interface MTEpisode : NSObject
@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *cleanedTitle;
@end

@interface MTEpisodeCollectionViewCell : UICollectionViewCell <UIGestureRecognizerDelegate>
@property (nonatomic, retain) UIForceGestureRecognizer *forcePress;
@property (nonatomic, retain) MTEpisode *episode;
- (BOOL)is6S;
- (NSString *)platform;
- (void)hapticFeedback;
@end

%hook MTEpisodeCollectionViewCell
%property (nonatomic, retain) UIForceGestureRecognizer *forcePress;
-(void)layoutSubviews {
    %orig;
    if (self.forcePress) {

    }
    else {
        //if ([[self delegate] isKindOfClass:[NSClassFromString(@"MusicLibraryBrowseTableViewController") class]]) {
        UIForceGestureRecognizer *forcePress = [[UIForceGestureRecognizer alloc] initWithTarget:self action:@selector(_handleForcePress:)];
        forcePress.minimumPressDuration = 300;
        forcePress.cancelsTouchesInView = YES;
        forcePress.minimumForce = 10;
        forcePress.delegate = self;
        self.forcePress = forcePress;
        [self addGestureRecognizer:self.forcePress];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
%new
- (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *) malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

%new
- (BOOL)is6S {
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
    return NO; /* Device is iPad */
    }
    //if ([[[self platform] substringToIndex:4] isEqualToString:@"iPad"]) return FALSE;
    else return ([[[self platform] substringToIndex: 7] isEqualToString:@"iPhone8"]);
}
%new
- (void)hapticFeedback {
    if ([self is6S]) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(_tapticEngine)]) {
            UITapticEngine *tapticEngine = [UIDevice currentDevice]._tapticEngine;
            if (tapticEngine) {
            [tapticEngine actuateFeedback:UITapticEngineFeedbackPop];
            }
        }
    }
    else {
        hapticVibe();
    }
}
%new
- (void)_handleForcePress:(UIForceGestureRecognizer *)gesture {
    if (![self is6S]) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            CWStatusBarNotification *notification = [CWStatusBarNotification new];
            notification.notificationLabelTextColor =  [UIColor whiteColor];//[[UIApplication sharedApplication] delegate].window.tintColor;
            //notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
            [[%c(MTUpNextController) sharedInstance] addEpisodeUuidToUpNext: self.episode.uuid];
            [self hapticFeedback];
            NSString *title = self.episode.cleanedTitle;
            NSString *fullTitle = [NSString stringWithFormat:@"'%@' was added to 'Up Next'", title];
            [notification displayNotificationWithMessage:fullTitle
                   forDuration:1.5f];
        }     
    }
    else {
        if (gesture.state == UIGestureRecognizerStateEnded) {
            CWStatusBarNotification *notification = [CWStatusBarNotification new];
            notification.notificationLabelTextColor =  [UIColor whiteColor];//[[UIApplication sharedApplication] delegate].window.tintColor;
            //notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
            [[%c(MTUpNextController) sharedInstance] addEpisodeUuidToUpNext: self.episode.uuid];
            [self hapticFeedback];
            NSString *title = self.episode.cleanedTitle;
            NSString *fullTitle = [NSString stringWithFormat:@"'%@' was added to 'Up Next'", title];
            [notification displayNotificationWithMessage:fullTitle
                   forDuration:1.5f];
        }
    }
}

%end

%end


%ctor {
    %init;
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.Music"]) {
        %init(Music);
    }
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.apple.podcasts"]) { // Podcasts App
        %init(Podcasts);
    }
}



