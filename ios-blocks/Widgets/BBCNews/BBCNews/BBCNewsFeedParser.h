//
//  BBCNewsFeedParser.h
//  BBCNews
//
//  Created by Matt Clarke on 13/03/2015.
//
//

#import <Foundation/Foundation.h>
#import "BBCNewsFeedItem.h"

@class BBCNewsFeedParser;

// Delegate
@protocol BBCNewsFeedParserDelegate <NSObject>
@optional
- (void)feedParserDidStart:(BBCNewsFeedParser*)parser;
- (void)feedParser:(BBCNewsFeedParser*)parser didParseFeedItem:(BBCNewsFeedItem*)item;
- (void)feedParserDidFinish:(BBCNewsFeedParser*)parser;
- (void)feedParser:(BBCNewsFeedParser*)parser didFailWithError:(NSError *)error;
@end

@interface BBCNewsFeedParser : NSObject {
    NSURL *url;
}

@property (nonatomic, weak) id<BBCNewsFeedParserDelegate> delegate;

-(instancetype)initWithUrlString:(NSString*)arg1;
-(void)beginParsing;

@end