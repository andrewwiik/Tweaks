
#import "SBHelpPlaceholderIcon.h"
@implementation SBHelpPlaceholderIcon
+ (id)newIcon {
	return (SBHelpPlaceholderIcon*)[objc_getClass("SBPlaceholderIcon") emptyPlaceholder];
}
@end