#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface CustomUIDatePicker : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property NSInteger hours;
@property NSInteger mins;
@property NSInteger secs;

-(NSInteger) getPickerTimeInMS;
-(void) initialize;

@end
@implementation CustomUIDatePicker
-(instancetype)init {
 self = [super init];
 [self initialize];
 return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
 self = [super initWithCoder:aDecoder];
 [self initialize];
 return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
 self = [super initWithFrame:frame];
 [self initialize];
 return self;
}

-(void) initialize {
self.delegate = self;
self.dataSource = self;

int height = 20;
int offsetX = self.frame.size.width / 3;
int offsetY = self.frame.size.height / 2 - height / 2;
int marginX = 42;
int width = offsetX - marginX;

UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, offsetY, width, height)];
hourLabel.text = @"hour";
[self addSubview:hourLabel];

UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX + offsetX, offsetY, width, height)];
minsLabel.text = @"min";
[self addSubview:minsLabel];

UILabel *secsLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX + offsetX * 2, offsetY, width, height)];
secsLabel.text = @"sec";
[self addSubview:secsLabel];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
if (component == 0) {
    self.hours = row;
} else if (component == 1) {
    self.mins = row;
} else if (component == 2) {
    self.secs = row;
}
}

-(NSInteger)getPickerTimeInMS {
return (self.hours * 60 * 60 + self.mins * 60 + self.secs) * 1000;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
 if(component == 0)
     return 24;

 return 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
return 30;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
if (view != nil) {
    ((UILabel*)view).text = [NSString stringWithFormat:@"%lu", (unsigned long)row];
    return view;
}
UILabel *columnView = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.frame.size.width/3 - 35, 30)];
columnView.text = [NSString stringWithFormat:@"%lu", (unsigned long)row];
columnView.textAlignment = NSTextAlignmentLeft;

return columnView;
}

@end
CustomUIDatePicker *specialDatePicker;
%hook MTTimerPickerCell
- (void)layoutSubviews {
	NSArray *viewsToRemove = [self subviews];
for (UIView *v in viewsToRemove) {
    [v removeFromSuperview];
}
	CustomUIDatePicker *specialDatePicker = [[NSClassFromString(@"CustomUIDatePicker") new] init];
	[self addSubview:specialDatePicker];
}
- (id)picker {
	return specialDatePicker;

}
%end