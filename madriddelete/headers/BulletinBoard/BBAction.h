#import <Foundation/NSObject.h>

#import "BBAppearance.h"

@interface BBAction : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic) long long actionType;
@property (nonatomic, copy) BBAppearance *appearance;
+ (instancetype)actionWithCallblock:(void (^)(void))block;
+ (instancetype)actionWithIdentifier:(NSString *)arg1 title:(NSString *)arg2;
- (void)setCallblock:(id)block;
- (void)setInternalBlock:(void (^)(void))arg1;
- (id)copy;
@end