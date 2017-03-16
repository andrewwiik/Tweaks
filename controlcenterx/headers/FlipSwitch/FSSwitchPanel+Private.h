#import <FlipSwitch/FSSwitchPanel.h>
#import <FlipSwitch/FSSwitchSettingsViewController.h>

@interface FSSwitchPanel (Private)
- (NSString *)descriptionOfState:(FSSwitchState)state forSwitchIdentifier:(NSString *)switchIdentifier;
- (Class <FSSwitchSettingsViewController>)settingsViewControllerClassForSwitchIdentifier:(NSString *)switchIdentifier;
- (UIViewController <FSSwitchSettingsViewController> *)settingsViewControllerForSwitchIdentifier:(NSString *)switchIdentifier;
- (NSArray *)sortedSwitchIdentifiers;
- (UIColor *)primaryColorForSwitchIdentifier:(NSString *)switchIdentifier;
@end