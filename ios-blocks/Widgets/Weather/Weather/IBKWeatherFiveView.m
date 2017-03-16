//
//  IBKWeatherFiveView.m
//  Weather
//
//  Created by Matt Clarke on 31/03/2015.
//
//

#import "IBKWeatherFiveView.h"
#import "IBKWeatherLayerFactory.h"

@implementation IBKWeatherFiveView

- (id)initWithFrame:(CGRect)frame day:(NSString *)dayName condition:(int)condition high:(NSString *)high low:(NSString *)low {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Day.
        self.dayName = [[IBKLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.dayName.text = dayName;
        self.dayName.textAlignment = NSTextAlignmentLeft;
        self.dayName.textColor = [UIColor whiteColor];
        self.dayName.backgroundColor = [UIColor clearColor];
        [self.dayName sizeToFit];
        [self.dayName setLabelSize:kIBKLabelSizingSmall];
        
        [self addSubview:self.dayName];
        
        // Icon.
        self.icon = [[UIImageView alloc] initWithImage:[[IBKWeatherLayerFactory sharedInstance] iconForCondition:condition isDay:YES wantsLargerIcons:NO]];
        self.icon.clipsToBounds = NO;
        self.icon.backgroundColor = [UIColor clearColor];
        [self addSubview:self.icon];
        
        // High
        
        self.high = [[IBKLabel alloc] initWithFrame:CGRectMake(0, 0, 20, 21)];
        self.high.text = high;
        self.high.textAlignment = NSTextAlignmentRight;
        self.high.textColor = [UIColor whiteColor];
        self.high.backgroundColor = [UIColor clearColor];
        [self.high setLabelSize:kIBKLabelSizingSmall];
        
        [self addSubview:self.high];
        
        // Low
        
        self.low = [[IBKLabel alloc] initWithFrame:CGRectMake(0, 0, 20, 21)];
        self.low.text = low;
        self.low.textAlignment = NSTextAlignmentRight;
        self.low.textColor = [UIColor whiteColor];
        self.low.backgroundColor = [UIColor clearColor];
        self.low.alpha = 0.5;
        [self.low setLabelSize:kIBKLabelSizingSmall];
        
        [self addSubview:self.low];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.dayName.frame = CGRectMake(10, (self.frame.size.height/2) - (self.dayName.frame.size.height/2), self.dayName.frame.size.width, self.dayName.frame.size.height);
    
    CGFloat iconWidth = self.icon.frame.size.width*0.8;
    CGFloat iconHeight = self.icon.frame.size.height*0.8;
    self.icon.frame = CGRectMake((self.frame.size.width/2) - (iconWidth/2), (self.frame.size.height/2) - (iconHeight/2), iconWidth, iconHeight);
    
    self.low.frame = CGRectMake(self.frame.size.width - 10 - self.low.frame.size.width, (self.frame.size.height/2) - (self.low.frame.size.height/2), self.low.frame.size.width, self.low.frame.size.height);
    self.high.frame = CGRectMake(self.low.frame.origin.x - self.high.frame.size.width, (self.frame.size.height/2) - (self.high.frame.size.height/2), self.high.frame.size.width, self.high.frame.size.height);
}

@end
