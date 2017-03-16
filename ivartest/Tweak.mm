#line 1 "Tweak.xm"







#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif


#include <substrate.h>
// #import "header.h"

asm(".weak_reference _OBJC_CLASS_$_SBIcon");
// asm(".weak_reference _OBJC_METACLASS_$_SBIcon");

// @interface SBIcon : NSObject

// @end
// static _OBJC_CLASS_$_SBIcon NSClassFromString(@"SBIcon");
@interface SBIcon : NSObject
@end

@class SBIcon; @class SpringBoard; @class AWTSubIcon; 


@interface AWTSubIcon : SBIcon {
	id *_originalIconView;
	NSString *_blankIconName;
	UIView<UIScrollViewDelegate> *_ibkScrollViewController;
	CGFloat _scrollPercentage;
	int _fastScrollCount;
}
@end
@implementation AWTSubIcon
- (void)testing2 {
	_blankIconName = [NSString stringWithFormat:@"Shit Head"];
}
@end

static id _logos_method$_ungrouped$SpringBoard$awtTestObject(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST self, SEL _cmd) {

	id obj = [[NSClassFromString(@"AWTSubIcon") alloc] init];
	[obj setValue:@"Shit" forKey:@"_blankIconName"];
	[obj setValue:self forKey:@"_originalIconView"];
	[obj setValue:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)] forKey:@"_ibkScrollViewController"];
	return obj;
}

static __attribute__((constructor)) void _logosLocalInit() {
{ {  }Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(awtTestObject), (IMP)&_logos_method$_ungrouped$SpringBoard$awtTestObject, _typeEncoding); }} }
#line 53 "Tweak.xm"
