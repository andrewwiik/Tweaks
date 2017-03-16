//
//  BBCNewsContentView.m
//  BBCNews
//
//  Created by Matt Clarke on 12/03/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBCNewsContentView.h"
#import "IBKLabel.h"
#import <objc/runtime.h>

@interface IBKAPI : NSObject
+(CGFloat)heightForContentView;
@end

@implementation BBCNewsContentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _carousel = [[iCarousel alloc] initWithFrame:self.bounds];
        _carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _carousel.type = iCarouselTypeLinear;
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.pagingEnabled = YES;
        
        //add carousel to view
        [self addSubview:_carousel];
        
        // Setup feed parser.
        self.items = [NSMutableArray array];
        
        NSURL *feedURL = [NSURL URLWithString:@"http://feeds.bbci.co.uk/news/rss.xml"];
        self.feedParser = [[IBKMWFeedParser alloc] initWithFeedURL:feedURL];
        self.feedParser.delegate = self;
        self.feedParser.feedParseType = ParseTypeFull;
        self.feedParser.connectionType = ConnectionTypeAsynchronously;
        
        [self.feedParser parse];
    }
    
    return self;
}

- (CAGradientLayer*)gradientFrom:(UIColor*)from to:(UIColor*)to {
    UIColor *colorOne = from;
    UIColor *colorTwo = to;
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.anchorPoint = CGPointZero;
    headerLayer.startPoint = CGPointMake(0.5f, 1.0f);
    headerLayer.endPoint = CGPointMake(0.5f, 0.0f);
    
    return headerLayer;
}

-(UIImage*)darkenImageBottom:(UIImage*)image {
    return image;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.items.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (!view) {
        // Make new view.
        // Can assume view is widget bounds.
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, [objc_getClass("IBKAPI") heightForContentView])];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor blackColor];
        imageView.layer.masksToBounds = NO;
        imageView.tag = 1;
        
        [view addSubview:imageView];
        
        CAGradientLayer *grad = [CAGradientLayer layer];
        grad.anchorPoint = CGPointZero;
        grad.startPoint = CGPointMake(0.5f, 1.0f);
        grad.endPoint = CGPointMake(0.5f, 0.0f);
        
        UIColor *innerColour = [UIColor colorWithWhite:1.0 alpha:1.0];
        
        NSArray *colors = [NSArray arrayWithObjects:
                           (id)[innerColour CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.975f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.95f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.9f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.8f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.7f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.6f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.5f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.4f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.3f] CGColor],
                           (id)[[innerColour colorWithAlphaComponent:0.2f] CGColor],
                           /*(id)[[innerColour colorWithAlphaComponent:0.1f] CGColor],
                           (id)[[UIColor clearColor] CGColor],*/
                           nil];
        
        colors = [[colors reverseObjectEnumerator] allObjects];
        
        grad.colors = colors;
        grad.bounds = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        
        imageView.layer.mask = grad;
        
        
        UIView *eh = [[UIView alloc] initWithFrame:CGRectMake(0, [objc_getClass("IBKAPI") heightForContentView], view.bounds.size.width, view.bounds.size.height - [objc_getClass("IBKAPI") heightForContentView])];
        eh.backgroundColor = [UIColor blackColor];
        
        CAGradientLayer *darken = [self gradientFrom:[UIColor clearColor] to:[UIColor colorWithWhite:0.0 alpha:1.0]];
        darken.bounds = CGRectMake(0, 0, view.frame.size.width, imageView.frame.size.height);
        
        darken.startPoint = CGPointMake(0.5f, 0.0f);
        darken.endPoint = CGPointMake(0.5f, 1.0f);
        darken.locations = @[@0.65, @1.0];
        [imageView.layer insertSublayer:darken atIndex:0];
        
        [imageView addSubview:eh];
        
        IBKLabel *text = [[IBKLabel alloc] initWithFrame:CGRectMake(7, [objc_getClass("IBKAPI") heightForContentView]-38, self.frame.size.width-10, 33)];
        text.textAlignment = NSTextAlignmentLeft;
        text.textColor = [UIColor whiteColor];
        text.backgroundColor = [UIColor clearColor];
        text.tag = 2;
        text.numberOfLines = 2;
        
        [text setLabelSize:kIBKLabelSizingSmallBold];
        
        [view addSubview:text];
    }
    
    MWFeedItem *item = self.items[index];
    
    BOOL exception = NO;
    
    UIImageView *imageView = (UIImageView*)[view viewWithTag:1];
    @try {
        imageView.image = self.preloadedImages[index];
    } @catch (NSException *e) { exception = YES; }
    
    if (!imageView.image || exception) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.thumbnail]]];
            image = [self darkenImageBottom:image];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                imageView.image = image;
                [self.preloadedImages insertObject:image atIndex:index];
            });
        });
    }
    
    IBKLabel *label = (IBKLabel*)[view viewWithTag:2];
    label.text = item.title;
    
    return view;
}

#pragma mark MWFeedParser delegate

-(void)feedParser:(IBKMWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {

}

-(void)feedParser:(IBKMWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    if (item)
        [self.items addObject:item];
}

-(void)feedParserDidStart:(IBKMWFeedParser *)parser {
    // Began downloading
}

-(void)feedParserDidFinish:(IBKMWFeedParser *)parser {
    // Let iCarousel know that we've loaded this thing.
    @try {
        [_carousel reloadData];
    } @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    
    // begin preloading images.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        for (int i = 0; i < self.items.count; i++) {
            MWFeedItem *item = self.items[i];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.thumbnail]]];
            [self.preloadedImages insertObject:image atIndex:i];
        }
    });

}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    /*
     * This method will be called every time your widget rotates.
     * Therefore, it is highly recommended to set your frames here
     * in relation to the size of this content view.
    */
    
    _carousel.frame = self.bounds;
}

@end