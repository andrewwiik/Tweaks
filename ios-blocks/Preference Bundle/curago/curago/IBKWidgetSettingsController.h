//
//  IBKWidgetSettingsController.h
//  curago
//
//  Created by Matt Clarke on 19/03/2015.
//
//

#import <Preferences/Preferences.h>

@interface IBKWidgetSettingsController : PSListController

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *bundleIdentifier;

@end
