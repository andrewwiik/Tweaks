#import <objc/runtime.h>
@class SBIcon, SBPlaceholderIcon;
@interface SBIcon : NSObject
- (id)applicationBundleID;
- (BOOL)isFolderIcon;
- (id)icon;
@end

@interface SBPlaceholderIcon : SBIcon
+ (id)emptyPlaceholder;
@end

@interface SBHelpPlaceholderIcon : SBPlaceholderIcon
+ (id)newIcon;
@end