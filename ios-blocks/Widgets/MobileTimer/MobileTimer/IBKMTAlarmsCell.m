//
//  IBKMTAlarmsCell.m
//  MobileTimer
//
//  Created by Matt Clarke on 06/04/2015.
//
//

#import "IBKMTAlarmsCell.h"

@implementation IBKMTAlarmsCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)setupForAlarm:(Alarm*)alarm {
    BOOL isActive = alarm.isActive;
    NSString *time = [NSString stringWithFormat:@"%02d:%02d", alarm.hour, alarm.minute];
    
    if (!self.backgroundCircle) {
        self.backgroundCircle = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundCircle.layer.cornerRadius = self.bounds.size.width/2;
        self.backgroundCircle.alpha = 0.3;
        self.backgroundCircle.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.backgroundCircle];
    }
    
    if (isActive) {
        self.backgroundCircle.backgroundColor = [UIColor greenColor];
    }
    
    if (!self.time) {
        self.time = [[UILabel alloc] initWithFrame:self.bounds];
        self.time.textAlignment = NSTextAlignmentCenter;
        self.time.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        self.time.textColor = [UIColor whiteColor];
        self.time.backgroundColor = [UIColor clearColor];
        self.time.numberOfLines = 1;
        
        [self addSubview:self.time];
    }
    
    self.time.text = time;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundCircle.frame = self.bounds;
    self.backgroundCircle.layer.cornerRadius = self.bounds.size.width/2;
    self.time.frame = self.bounds;
}

-(void)prepareForReuse {
    if (self.backgroundCircle) {
        [self.backgroundCircle removeFromSuperview];
        self.backgroundCircle = nil;
    }
    
    if (self.time) {
        [self.time removeFromSuperview];
        self.time = nil;
    }
}

-(void)dealloc {
    [self prepareForReuse];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
