//
//  BTOShortCutManager.h
//  test
//
//  Created by Brian Olencki on 10/17/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SCREEN ([UIScreen mainScreen].bounds)

@protocol BTOShortCutManagerDelegate <NSObject>
- (void)performActionForBundleID:(NSString*)bundleID withTitle:(NSString*)title;
@end

@interface BTOShortCutManager : NSObject {
    NSUserDefaults *prefs;

    id<BTOShortCutManagerDelegate> _delegate;
}
@property (nonatomic, assign) id <BTOShortCutManagerDelegate> delegate;
+ (BTOShortCutManager*)sharedInstance;
- (NSDictionary*)getShortCuts;
- (void)deleteShortCutWithBundleID:(NSString*)bundleID;
- (void)addShortCutWithTitle:(NSString *)title withSubTitle:(NSString *)subTitle withBundleID:(NSString *)bundleID withURL:(NSString*)url withIcon:(NSInteger)iconNumber withImage:(NSString*)image;
- (NSArray*)shortCutsForAppWithBundleID:(NSString*)bundleID;
- (NSString*)getURLSchemeForBundleID:(NSString*)bundleID withTitle:(NSString*)title;
- (BOOL)containsBundleID:(NSString*)bundleID;
- (UIApplicationShortcutIconType)iconTypeForNumber:(NSInteger)number;
- (UIImage*)customImageForBundleID:(NSString*)bundleID withTitle:(NSString*)title;
- (NSArray*)itemForBundleID:(NSString*)bundleID withTitle:(NSString*)title;
@end
