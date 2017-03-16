
#import "ATWTemplateTestBlockViewController.h"

@implementation ATWTemplateTestBlockViewController

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (self.view == nil) {
        
		self.view = [[UIView alloc] initWithFrame:frame];
		self.view.backgroundColor = [UIColor blueColor];

	}
	
	return self.view;
}

-(BOOL)hasButtonArea {

    return YES;
}

-(BOOL)hasAlternativeIconView {

    return NO;
}

@end