#import <Preferences/Preferences.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <Twitter/TWTweetComposeViewController.h>
#import "AWApolloListController.h"
#import "AWApolloLocalizer.h"

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_1_2
#define kCFCoreFoundationVersionNumber_iOS_7_1_2 847.27
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
#define kCFCoreFoundationVersionNumber_iOS_8_0 1140.10
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_1_1
#define kCFCoreFoundationVersionNumber_iOS_8_1_1 1145.15 
#endif

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define CURRENT_INTERFACE_ORIENTATION iPad ? [[UIApplication sharedApplication] statusBarOrientation] : [[UIApplication sharedApplication] activeInterfaceOrientation]

#define iOS8 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0 \
&& kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_8_1_1

#define iOS7 kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0 \
&& kCFCoreFoundationVersionNumber <= kCFCoreFoundationVersionNumber_iOS_7_1_2

@interface UIView (Constraint)
-(NSLayoutConstraint *)_constraintForIdentifier:(id)arg1 ;
@end

#define URL_ENCODE(string) [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)(string), NULL, CFSTR(":/=,!$& '()*+;[]@#?"), kCFStringEncodingUTF8) autorelease]

#define MAIN_ICON_PATH               @"/Library/PreferenceBundles/Apollo.bundle/images/Apollo.png"
#define HEADER_ICON               @"/Library/PreferenceBundles/Apollo.bundle/images/headerLogo.png"


#define MAIN_TINTCOLOR [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f]
#define SWITCH_TINTCOLOR [UIColor colorWithRed:65/255.0f green:169/255.0f blue:214/255.0f alpha:1.0f]
#define LABEL_TINTCOLOR [UIColor colorWithRed:22/255.0f green:36/255.0f blue:51/255.0f alpha:1.0f]
#define NAVBACKGROUND_TINTCOLOR [UIColor colorWithRed:65/255.0f green:169/255.0f blue:214/255.0f alpha:1.0f]