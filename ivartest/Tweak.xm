@interface SBIcon : NSObject
@end

@interface AWTSubIcon : SBIcon {
	id *_originalIconView;
	NSString *_blankIconName;
	UIView<UIScrollViewDelegate> *_ibkScrollViewController;
	CGFloat _scrollPercentage;
	int _fastScrollCount;
}
@end

%subclass AWTSubIcon : SBIcon {
	id *_originalIconView;
	NSString *_blankIconName;
	UIView<UIScrollViewDelegate> *_ibkScrollViewController;
	CGFloat _scrollPercentage;
	int _fastScrollCount;
}
%new
- (void)testing {
	return;
}
%end

@interface AWTSubIcon () {
	id *_originalIconView;
	NSString *_blankIconName;
	UIView<UIScrollViewDelegate> *_ibkScrollViewController;
	CGFloat _scrollPercentage;
	int _fastScrollCount;
}

- (void)testing2;
@end
@implementation AWTSubIcon
- (void)testing2 {
	_blankIconName = [NSString stringWithFormat:@"Shit Head"];
}
@end

%hook SpringBoard
%new
- (id)awtTestObject {

	id obj = [[NSClassFromString(@"AWTSubIcon") alloc] init];
	[obj setValue:@"Shit" forKey:@"_blankIconName"];
	[obj setValue:self forKey:@"_originalIconView"];
	[obj setValue:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)] forKey:@"_ibkScrollViewController"];
	return obj;
}
%end