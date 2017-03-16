//
//  IBKWidgetSelectorController.h
//  curago
//
//  Created by Matt Clarke on 10/04/2015.
//
//

#import <Preferences/Preferences.h>

@interface IBKWidgetSelectorController : PSListController

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *bundleIdentifier;
@property (nonatomic, strong) NSArray *keysMadeForWidget;
@property (nonatomic, strong) NSArray *keysCustom;

@end
