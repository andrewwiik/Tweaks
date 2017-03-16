//
//  BBCNewsSettings.m
//  BBCNews
//
//  Created by Matt Clarke on 13/03/2015.
//
//

#import "BBCNewsSettings.h"
#import "BBCNewsContentView.h"

static NSDictionary *settings;
static __weak BBCNewsContentView *contentView;

@implementation BBCNewsSettings

+(void)registerContentView:(BBCNewsContentView*)content {
    contentView = content;
}

+(int)numberOfNewsStoriesToPull {
    id temp = settings[@"storiesToPull"];
    return (temp ? [temp intValue] : 20);
}

+(int)updateInterval {
    id temp = settings[@"updateInterval"];
    return (temp ? [temp intValue] : 3600);
}

+(NSString*)currentFeed {
    id temp = settings[@"currentFeed"];
    return (temp ? [temp stringValue] : @"http://trevor-producer-cdn.api.bbci.co.uk/content/cps/news/front_page");
}

+(void)reloadSettings {
    settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.bbcNews.ibkwidget.plist"];
}

@end
