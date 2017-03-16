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
#import "BBCNewsFeedParser.h"
#import <objc/runtime.h>
#import "BBCNewsSettings.h"

static BOOL isUpdating;

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
        _carousel.scrollSpeed = 0.75;
        _carousel.alpha = 0.0;
        
        //add carousel to view
        [self addSubview:_carousel];
        
        // Loading view.
        
        self.loadingView = [[UIView alloc] initWithFrame:self.bounds];
        self.loadingView.backgroundColor = [UIColor clearColor];
        
        UIView *faded = [[UIView alloc] initWithFrame:self.bounds];
        faded.backgroundColor = [UIColor blackColor];
        
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
        grad.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        faded.layer.mask = grad;
        
        [self.loadingView addSubview:faded];
        
        IBKLabel *text = [[IBKLabel alloc] initWithFrame:CGRectMake(7, [objc_getClass("IBKAPI") heightForContentView]-38, self.frame.size.width-10, 33)];
        text.textAlignment = NSTextAlignmentLeft;
        text.textColor = [UIColor whiteColor];
        text.backgroundColor = [UIColor clearColor];
        text.tag = 2;
        text.numberOfLines = 2;
        text.text = @"Updating...";
        
        [text setLabelSize:kIBKLabelSizingSmallBold];
        
        [self.loadingView addSubview:text];
        
        [self addSubview:self.loadingView];
        
        // Setup feed parser.
        self.items = [NSMutableArray array];
        self.preloadedImages = [NSMutableDictionary dictionary];
        
        self.feedParser = [[BBCNewsFeedParser alloc] initWithUrlString:@"http://trevor-producer-cdn.api.bbci.co.uk/content/cps/news/front_page"];
        self.feedParser.delegate = self;
        [self.feedParser beginParsing];
        
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:[BBCNewsSettings updateInterval] target:self selector:@selector(reloadForSettingsChangeOrNewUpdate:) userInfo:nil repeats:YES];
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
        
        IBKLabel *text = [[IBKLabel alloc] initWithFrame:CGRectMake(7, [objc_getClass("IBKAPI") heightForContentView]-38, self.frame.size.width-14, 35)];
        text.textAlignment = NSTextAlignmentLeft;
        text.textColor = [UIColor whiteColor];
        text.backgroundColor = [UIColor clearColor];
        text.tag = 2;
        text.numberOfLines = 2;
        
        [text setLabelSize:kIBKLabelSizingSmallBold];
        
        [view addSubview:text];
    }
    
    BBCNewsFeedItem *item = self.items[index];
    
    UIImageView *imageView = (UIImageView*)[view viewWithTag:1];
    imageView.image = [self.preloadedImages objectForKey:item.identifier];
    
    if (![self.preloadedImages objectForKey:item.identifier]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSError *error;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.imageUrl] options:kNilOptions error:&error]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                imageView.image = image;
                if (image && !error)
                    [self.preloadedImages setObject:image forKey:item.identifier];
            });
        });
    }
    
    IBKLabel *label = (IBKLabel*)[view viewWithTag:2];
    label.text = item.title;
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap:
            return YES;
            break;
            
        default:
            break;
    }
    
    return value;
}

#pragma mark MWFeedParser delegate

-(void)feedParser:(BBCNewsFeedParser*)parser didParseFeedItem:(BBCNewsFeedItem*)item {
    if (item)
        [self.items addObject:item];
}

-(void)feedParserDidStart:(BBCNewsFeedParser*)parser {
    // Began downloading
    _carousel.alpha = 0.0;
    self.loadingView.alpha = 1.0;
}

-(void)feedParserDidFinish:(BBCNewsFeedParser*)parser {
    // Let iCarousel know that we've loaded this thing.
    isUpdating = NO;
    
    @try {
        [_carousel reloadData];
        
        _carousel.alpha = 1.0;
        self.loadingView.alpha = 0.0;
    } @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    
    // begin preloading images.
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        for (BBCNewsFeedItem *item in self.items) {
            NSError *error;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.imageUrl] options:kNilOptions error:&error]];
            if (image && !error) {
                if ([self.preloadedImages count] > 0) {
                    self.preloadedImages = [NSMutableDictionary dictionary];
                }
                [self.preloadedImages setObject:image forKey:item.identifier];
            }
        }
    });*/
}

-(void)feedParser:(BBCNewsFeedParser *)parser didFailWithError:(NSError *)error {
    // Oh no. Probably no connection or something!
    
    // Wait until connection then retry.
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reach.isReachable) {
                [self reloadForSettingsChangeOrNewUpdate:nil];
            }
        });
        
        [reach stopNotifier];
    };
    
    [reach startNotifier];
}

-(void)reloadForSettingsChangeOrNewUpdate:(id)sender {
    if (!isUpdating) {
        isUpdating = YES;
    
        self.items = [NSMutableArray array];
        [self.feedParser beginParsing];
    }
}

-(void)moveToNewNewsItem:(id)sender {
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    /*
     * This method will be called every time your widget rotates.
     * Therefore, it is highly recommended to set your frames here
     * in relation to the size of this content view.
    */
    
    _carousel.frame = self.bounds;
    self.loadingView.frame = self.bounds;
}

-(void)dealloc {
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    
    self.items = nil;
    self.preloadedImages = nil;
}

@end