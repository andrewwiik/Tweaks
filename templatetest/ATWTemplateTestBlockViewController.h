
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "IBKWidgetDelegate.h"

@interface ATWTemplateTestBlockViewController : NSObject <IBKWidgetDelegate>

@property (nonatomic, strong) UIView *view;

-(UIView*)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad;
-(BOOL)hasButtonArea;
-(BOOL)hasAlternativeIconView;

@end

