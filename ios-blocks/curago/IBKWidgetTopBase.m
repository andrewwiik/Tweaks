//
//  IBKWidgetTopBase.m
//  curago
//
//  Created by Matt Clarke on 01/03/2015.
//
//

#import "IBKWidgetTopBase.h"
#import "IBKResources.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation IBKWidgetTopBase

/*
 * This wee bit of code ensures that touches only hit the original icon view on the bottom left, 
 * precisely where we want to user to tap to launch apps.
*/

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = CGRectMake(0, [IBKResources heightForWidget]-(isPad ? 50 : 30)-14, (isPad ? 50 : 30)+14, (isPad ? 50 : 30)+14);
    CGRect intersect = CGRectMake(point.x, point.y, 1, 1);
    
    return !CGRectIntersectsRect(rect, intersect);
}

@end
