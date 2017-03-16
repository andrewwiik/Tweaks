#import "Headers.h"
#import "dopeLockObject.h"
#import "Imports.h"
static bool enabled = true;
static bool textColor = false;
static NSMutableArray *todayArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", nil];
static LPViewController *_mainPage;
static NSString *user = @"Friend"; 

id delegate;
int testing = 0;



%hook BBBulletin

+ (BBBulletin *)bulletinWithBulletin:(id)arg1 {
    
    //%log;
    if (enabled){
        BBBulletin *test = %orig;
    //test.publisherBulletinID Use this if we want to sort.
        NSLog(@"Message: %@", test.message);
        if (test.message){
            if ([test.section isEqualToString:@"com.apple.mobilecal.today"] && [test.publisherBulletinID isEqualToString:@"EKBBBirthdayBulletin"] ) {
            [todayArray replaceObjectAtIndex:0 withObject:test.message];
            }
            else if ([test.section isEqualToString:@"com.apple.weather.today"])
            {
                [todayArray replaceObjectAtIndex:1 withObject:test.message];
            }
            else if ([test.section isEqualToString:@"com.apple.mobilecal.today"] && [test.publisherBulletinID isEqualToString:@"EKBBUpcomingEventBulletin"])
            {
                [todayArray replaceObjectAtIndex:2 withObject:test.message];
            }
            else if ([test.section isEqualToString:@"com.apple.mobiletimer"])
            {
                [todayArray replaceObjectAtIndex:3 withObject:test.message];
            }
            else if ([test.section isEqualToString:@"com.apple.mobilecal.today"] && [test.publisherBulletinID isEqualToString:@"EKBBTomorrowSnippetBulletin"])
            {
                [todayArray replaceObjectAtIndex:4 withObject:test.message];
            }
        }
        
        return test;
    }
    else
        return %orig;
    
    //return %orig;
}

%end

%hook SBLockScreenView
         
 -(void)didMoveToWindow {
    if(enabled){
        [_mainPage addArray:todayArray];
        [_mainPage addUser:user];
    }
    %orig;
}

%end

%hook SBLockScreenViewController



- (_Bool)isBounceEnabledForPresentingController:(id)arg1 locationInWindow:(struct CGPoint)arg2 {
    if(enabled)
        return NO;
    else
        return %orig;
}


%end

static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.dopeteam.dopelock.plist"];
    if (prefs)
    {
        enabled =  ( [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : enabled );
        user = [prefs objectForKey:@"name"];
        textColor =  ( [prefs objectForKey:@"textColor"] ? [[prefs objectForKey:@"textColor"] boolValue] : textColor );
        if(!user || user == nil)
            user=@"Friend";
    }
    [prefs release];
}

%ctor
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.dopeteam.dopelock/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
    if(enabled)
    {
            @autoreleasepool {
             _mainPage = [[LPViewController alloc] init];
             [_mainPage addUser:user];
             [_mainPage setColor:textColor];
            [[LPPageController sharedInstance] addPage:_mainPage];
    }
    }
   
}