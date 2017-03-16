//
//  MobileTimerContentView.m
//  MobileTimer
//
//  Created by Matt Clarke on 03/04/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MobileTimerContentView.h"
#import "IBKMobileTimerResources.h"
#import "MobileTimerWidgetViewController.h"
#import "IBKMTAlarmsCell.h"
#import <objc/runtime.h>

@interface IBKAPI
+(CGFloat)heightForContentView;
@end

@implementation MobileTimerContentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [IBKMobileTimerResources reloadSettings];
    
    if (self) {
        CGFloat longerLength = 0;
        
        if (frame.size.width > frame.size.height) {
            longerLength = frame.size.width - 40;
        } else {
            longerLength = frame.size.height - 40;
        }
        
        self.scroll = [[UIScrollView alloc] initWithFrame:frame];
        self.scroll.delegate = self;
        self.scroll.backgroundColor = [UIColor clearColor];
        self.scroll.contentSize = CGSizeMake(frame.size.width*2, frame.size.height);
        self.scroll.pagingEnabled = YES;
        self.scroll.showsHorizontalScrollIndicator = NO;
        self.scroll.showsVerticalScrollIndicator = NO;
        self.scroll.canCancelContentTouches = NO;
        
        [self addSubview:self.scroll];
        
        self.clockFace = [[IBKBEMAnalogClockView alloc] initWithFrame:CGRectMake(20, 10, longerLength, longerLength)];
        self.clockFace.delegate = self;
        self.clockFace.realTime = NO;
        self.clockFace.userInteractionEnabled = NO;
        
        self.clockFace.secondHandLength = (longerLength/2) - 5;
        self.clockFace.minuteHandLength = (longerLength/2) - 5;
        self.clockFace.hourHandLength = (longerLength/2) - 25;
        
        NSDate *current = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:current];
        self.clockFace.hours = [components hour];
        self.clockFace.minutes = [components minute];
        self.clockFace.seconds = [components second];
        
        if ([IBKMobileTimerResources hasGraduations]) {
            self.clockFace.digitOffset = 7;
            self.clockFace.enableGraduations = YES;
        }
        
        self.clockFace.enableDigit = [IBKMobileTimerResources hasNumbers];
        
        clockUpdater = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateClock:) userInfo:nil repeats:YES];
        
        [self.scroll addSubview:self.clockFace];
        
        /*self.timerView = [[IBKMTTimerView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
        self.timerView.backgroundColor = [UIColor clearColor];
        
        [self.scroll addSubview:self.timerView];*/
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
         
        self.alarmsController = [[IBKMTAlarmViewController alloc] initWithCollectionViewLayout:layout];
        [self.alarmsController loadAlarmsFromManager];
        
        UICollectionView *colView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, [objc_getClass("IBKAPI") heightForContentView]) collectionViewLayout:layout];
        self.alarmsController.collectionView = colView;
         
        self.alarmsController.collectionView.backgroundColor = [UIColor clearColor];
        self.alarmsController.collectionView.opaque = NO;
        self.alarmsController.collectionView.showsVerticalScrollIndicator = NO;
        self.alarmsController.collectionView.bounces = YES;
        self.alarmsController.collectionView.clipsToBounds = NO;
         
        self.alarmsController.collectionView.dataSource = self.alarmsController;
        self.alarmsController.collectionView.delegate = self.alarmsController;
         
        self.alarmsController.collectionView.frame = CGRectMake(20, 0, self.frame.size.width-40, self.frame.size.height);
        
        [self.alarmsController.collectionView registerClass:[IBKMTAlarmsCell class] forCellWithReuseIdentifier:@"alarmsCell"];
        
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
                           (id)[[innerColour colorWithAlphaComponent:0.1f] CGColor],
                           (id)[[UIColor clearColor] CGColor],
                           nil];
        
        colors = [[colors reverseObjectEnumerator] allObjects];
        
        grad.colors = colors;
        grad.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        self.alarmsContainer = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        self.alarmsContainer.backgroundColor = [UIColor clearColor];
        
        self.alarmsContainer.layer.mask = grad;
        
        [self.alarmsContainer addSubview:self.alarmsController.collectionView];
        
        [self.scroll addSubview:self.alarmsContainer];
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    /*
     * This method will be called every time your widget rotates.
     * Therefore, it is highly recommended to set your frames here
     * in relation to the size of this content view.
    */
    
    self.scroll.frame = self.frame;
    self.scroll.contentSize = CGSizeMake(self.frame.size.width*2, self.frame.size.height);
    
    CGFloat longerLength = 0;
    
    if (self.frame.size.width > self.frame.size.height) {
        longerLength = self.frame.size.width - 40;
    } else {
        longerLength = self.frame.size.height - 40;
    }
    
    self.clockFace.frame = CGRectMake(20, 10, longerLength, longerLength);
    
    [self.clockFace reloadClock];
    
    self.clockFace.secondHandLength = (longerLength/2) - 5;
    self.clockFace.minuteHandLength = (longerLength/2) - 5;
    self.clockFace.hourHandLength = (longerLength/2) - 25;
    
    //self.timerView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    self.alarmsController.collectionView.frame = CGRectMake(20, 0, self.frame.size.width-40, self.frame.size.height);
    self.alarmsContainer.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    self.alarmsContainer.layer.mask.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark Clock delegate

-(void)updateClock:(id)sender {
    [self.clockFace setClockToCurrentTimeAnimated:YES];
}

-(CGFloat)analogClock:(IBKBEMAnalogClockView *)clock graduationLengthForIndex:(NSInteger)index {
    switch (index) {
        case 0:
        case 5:
        case 10:
        case 15:
        case 20:
        case 25:
        case 30:
        case 35:
        case 40:
        case 45:
        case 50:
        case 55:
            if ([IBKMobileTimerResources hasNumbers])
                return 6.0;
            else
                return 8.0;
            break;
            
        default:
            return 4.0;
            break;
    }
}

-(CGFloat)analogClock:(IBKBEMAnalogClockView *)clock graduationOffsetForIndex:(NSInteger)index {
    return 0.5;
}

-(UIColor*)analogClock:(IBKBEMAnalogClockView *)clock graduationColorForIndex:(NSInteger)index {
    switch (index) {
        case 0:
        case 5:
        case 10:
        case 15:
        case 20:
        case 25:
        case 30:
        case 35:
        case 40:
        case 45:
        case 50:
        case 55:
            return [UIColor darkGrayColor];
            break;
            
        default:
            return [UIColor lightGrayColor];
            break;
    }
}

#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Our contentOffset.x tells the story.
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat percent = offset/self.frame.size.width;
    
    [(MobileTimerWidgetViewController*)self.delegate updateIconWithPercentage:percent];
}

-(void)dealloc {
    [clockUpdater invalidate];
    clockUpdater = nil;
    
    [self.clockFace removeFromSuperview];
    self.clockFace = nil;
}

@end