#import <Foundation/Foundation.h>
#import "headers.h"
@interface IBIconHandler : NSObject
+ (IBIconHandler*)sharedHandler;
- (NSArray*)icons;
- (void)addObject:(NSString*)object;
- (void)removeObject:(NSString*)object;
- (BOOL)containsBundleID:(NSString*)bundleID;
- (int)horiztonalWidgetSizeForBundleID:(NSString *)bundleID;
- (void)setHoriztonalWidgetSize:(int)size forBundleID:(NSString *)bundleID;
- (int)verticalWidgetSizeForBundleID:(NSString *)bundleID;
- (void)setVerticalWidgetSize:(int)size forBundleID:(NSString *)bundleID;
- (void)setIndex:(unsigned long long)index forBundleID:(NSString *)bundleID;
- (unsigned long long)indexForBundleID:(NSString *)bundleID;
- (CGSize)sizeForBundleID:(NSString *)bundleID;

@end
