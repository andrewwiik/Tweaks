#import <Foundation/NSObject.h>

@interface BBBulletin : NSObject
- (id)actionBlockForAction:(id)arg1;
- (NSMutableArray *)_allActions;
@property (nonatomic, retain) NSMutableDictionary *supplementaryActionsByLayout;
@property (nonatomic, retain) NSMutableDictionary *actions;
@end