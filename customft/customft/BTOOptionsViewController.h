#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

@interface BTOOptionsViewController : PSListController {
  NSUserDefaults *prefs;
  UIView *holder;
}

@end
