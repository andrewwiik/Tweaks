//
//  BBCNewsContentView.h
//  BBCNews
//
//  Created by Matt Clarke on 12/03/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "MWFeedParser/MWFeedParser.h"

@interface BBCNewsContentView : UIView <iCarouselDataSource, iCarouselDelegate, MWFeedParserDelegate>

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) IBKMWFeedParser *feedParser;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *preloadedImages;

@end