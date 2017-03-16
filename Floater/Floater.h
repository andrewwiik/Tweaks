//
//  Floater.h
//  Floater
//
//  Created by Brian Olencki on 12/22/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Color)
- (UIColor*)averageColor;
@end

@interface UIImage (Private)
/*
 @param format
 0 - 29x29
 1 - 40x40
 2 - 62x62
 3 - 42x42
 4 - 37x48
 5 - 37x48
 6 - 82x82
 7 - 62x62
 8 - 20x20
 9 - 37x48
 10 - 37x48
 11 - 122x122
 12 - 58x58
 */
+(UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end

typedef enum {
    FloaterTypeOpen,
    FloaterTypeClosed
} FloaterType;

@interface Floater : NSObject {
    UIWindow *_overlay;
    UIViewController *_rootViewController;
    UIView *_viewOpen;
    UIImageView *viewClosed;

    NSInteger _baseWindowLevel;

    BOOL _onScreen;
    FloaterType _type;
    NSInteger _windowLevel;
    NSString *_bundleID;
}
@property (readonly, nonatomic) BOOL onScreen;
@property (readonly, nonatomic) FloaterType type;
@property (readonly, nonatomic) NSString *bundleID;
@property (assign, nonatomic) UIView *viewOpen;
+ (NSMutableArray*)getInstances;
- (instancetype)initWithApplicationBundleID:(NSString*)bundleID atPoint:(CGPoint)point withBaseWindowLevel:(NSInteger)baseWindow;
- (void)toggleFloater;
- (void)setFloaterType:(FloaterType)type animated:(BOOL)animated;
- (CGSize)floaterOpenSize;
- (CGSize)floaterClosedSize;
- (void)setPosition:(CGPoint)point;
@end
