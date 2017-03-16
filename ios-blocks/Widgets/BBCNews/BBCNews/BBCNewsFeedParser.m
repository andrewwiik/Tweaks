//
//  BBCNewsFeedParser.m
//  BBCNews
//
//  Created by Matt Clarke on 13/03/2015.
//
//

#import "BBCNewsFeedParser.h"

@implementation BBCNewsFeedParser

-(instancetype)initWithUrlString:(NSString*)arg1 {
    self = [super init];
    
    if (self) {
        url = [NSURL URLWithString:arg1];
    }
    
    return self;
}

-(void)beginParsing {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.delegate feedParserDidStart:self];
        });
        
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        NSError *error;
        NSDictionary * parsedData;
        
        if (jsonData) {
            parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            
            [parsedData writeToFile:@"/var/mobile/Library/Curago/Widgets/uk.co.bbc.newsuk/Cache/cached.plist" atomically:YES];
        }
    
        if (error || !jsonData) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.delegate feedParser:self didFailWithError:error];
            });
            
            // Attempt to reload data from plist
            parsedData = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Curago/Widgets/uk.co.bbc.newsuk/Cache/cached.plist"];
        }
        
        NSArray *information = [parsedData objectForKey:@"relations"];
        
        int contentCount = 20;
        if (information.count < contentCount) {
            contentCount = (int)information.count;
        }
        
        for (int i = 0; i < contentCount; i++) {
            NSDictionary *content = [[information objectAtIndex:i] objectForKey:@"content"];
        
            NSString *title = [content objectForKey:@"shortName"];
        
            NSDictionary *relationsContentDictionary = content[@"relations"][0][@"content"];
            NSString *imageUrl = [@"http://ichef.bbci.co.uk/moira/img/ios/v3/768" stringByAppendingString:[relationsContentDictionary objectForKey:@"id"]];
            
            NSString *identifier = [content objectForKey:@"id"];
            NSString *cont = [content objectForKey:@"summary"];
            
            BBCNewsFeedItem *item = [[BBCNewsFeedItem alloc] init];
            item.title = title;
            item.imageUrl = imageUrl;
            item.identifier = identifier;
            item.content = cont;
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.delegate feedParser:self didParseFeedItem:item];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.delegate feedParserDidFinish:self];
        });
    });
}

@end
