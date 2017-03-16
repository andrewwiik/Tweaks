#import "BBAction.h"

@interface BBButton : NSObject <NSCopying, NSSecureCoding>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) BBAction *action;
@property (nonatomic,copy) NSString *identifier;
@property (nonatomic,copy,readonly) NSData *glyphData;
@end