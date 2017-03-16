//
//  IBKResources.h
//  curago
//
//  Created by Matt Clarke on 04/06/2014.
//
//

#import <Foundation/Foundation.h>
#import <SpringBoard7.0/SBIconListView.h>

@interface IBKResources : NSObject

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_6 (SCREEN_MAX_LENGTH == 667)
#define IS_IPHONE_6_PLUS (SCREEN_MAX_LENGTH == 736.0)

#define orient [[UIApplication sharedApplication] statusBarOrientation]

+(CGFloat)adjustedAnimationSpeed:(CGFloat)duration;

+(NSSet*)widgetBundleIdentifiers;
+(void)addNewIdentifier:(NSString*)arg1;
+(void)removeIdentifier:(NSString*)arg1;
+(NSArray*)generateWidgetIndexesForListView:(SBIconListView*)view;

+(CGFloat)widthForWidget;
+(CGFloat)heightForWidget;

+(NSString*)getRedirectedIdentifierIfNeeded:(NSString*)identifier;

+(NSString*)suffix;

// Settings.

+(BOOL)bundleIdentiferWantsToBeLocked:(NSString*)bundleIdentifier;
+(BOOL)shouldHideBadgeWhenWidgetExpanded;
+(BOOL)shouldReturnIconsIfNotMoved;
+(BOOL)transparentBackgroundForWidgets;
+(BOOL)showBorderWhenTransparent;
+(BOOL)debugLoggingEnabled;
+(BOOL)hoverOnly;
+(NSString*)passcodeHash;
+(BOOL)allWidgetsLocked;
+(BOOL)relockWidgets;
+(BOOL)isWidgetLocked:(NSString*)identifier;
+(void)reloadSettings;
+(int)defaultColourType;

@end
