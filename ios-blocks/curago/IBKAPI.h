//
//  IBKAPI.h
//  curago
//
//  Created by Matt Clarke on 27/10/2014.
//
//

#import <Foundation/Foundation.h>
#import "IBKResources.h"

@interface IBKAPI : NSObject

/**
 * Gets the average color of a given icon
 *
 * @param bundleId Bundle identifier of an icon
 * @return The average colour of a specified icon, taking into account changes made by WinterBoard themes.
 */
+(UIColor*)averageColorForIconIdentifier:(NSString*)bundleId;
+(CGFloat)heightForContentView;

@end
