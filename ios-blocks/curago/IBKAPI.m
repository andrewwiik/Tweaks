//
//  IBKAPI.m
//  curago
//
//  Created by Matt Clarke on 27/10/2014.
//
//

#import "IBKAPI.h"
#import "UIImageAverageColorAddition.h"
#import <SpringBoard7.0/SBIconImageView.h>
#import <SpringBoard7.0/SBIconModel.h>
#import <SpringBoard7.0/SBIconController.h>
#import <objc/runtime.h>

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface SBIconImageView (iOS7_1)
- (void)setIcon:(id)arg1 location:(int)arg2 animated:(BOOL)arg3;
@end

@interface SBIconModel (iOS8)
- (id)applicationIconForBundleIdentifier:(id)arg1;
@end

@implementation IBKAPI

+(UIColor*)averageColorForIconIdentifier:(NSString*)bundleId {
    SBIconImageView *iconImageView = [[objc_getClass("SBIconImageView") alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    if ([iconImageView respondsToSelector:@selector(setIcon:animated:)])
        [iconImageView setIcon:[(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] applicationIconForDisplayIdentifier:bundleId] animated:NO];
    else if ([(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] respondsToSelector:@selector(applicationIconForDisplayIdentifier:)])
        [iconImageView setIcon:[(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] applicationIconForDisplayIdentifier:bundleId] location:2 animated:NO];
    else // iOS 8
        [iconImageView setIcon:[(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] applicationIconForBundleIdentifier:bundleId] location:2 animated:NO];
    
    return [(UIImage*)[(SBIconImageView*)iconImageView squareContentsImage] mergedColor];
}

+(CGFloat)heightForContentView {
    CGFloat bbb = [IBKResources heightForWidget]-(isPad ? 50.0 : 30.0)-7.0;
    return bbb;
}

@end
