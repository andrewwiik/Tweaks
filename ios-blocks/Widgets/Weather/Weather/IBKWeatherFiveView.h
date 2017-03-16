//
//  IBKWeatherFiveView.h
//  Weather
//
//  Created by Matt Clarke on 31/03/2015.
//
//

#import <UIKit/UIKit.h>
#import "IBKLabel.h"

@interface IBKWeatherFiveView : UIView

@property (nonatomic, strong) IBKLabel *dayName;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) IBKLabel *high;
@property (nonatomic, strong) IBKLabel *low;

-(id)initWithFrame:(CGRect)frame day:(NSString*)dayName condition:(int)condition high:(NSString*)high low:(NSString*)low;

@end
