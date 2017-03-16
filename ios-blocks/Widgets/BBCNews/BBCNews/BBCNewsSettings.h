//
//  BBCNewsSettings.h
//  BBCNews
//
//  Created by Matt Clarke on 13/03/2015.
//
//

#import <Foundation/Foundation.h>

@interface BBCNewsSettings : NSObject

+(int)numberOfNewsStoriesToPull;
+(int)updateInterval;
+(NSString*)currentFeed;

+(void)reloadSettings;

@end
