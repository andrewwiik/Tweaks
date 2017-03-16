#import <Foundation/NSObject.h>

@interface BBActionResponse : NSObject

@property (nonatomic, copy) NSString *actionID;
@property (nonatomic) int actionType;
@property (nonatomic, copy) NSString *bulletinButtonID;
@property (nonatomic, copy) NSDictionary *bulletinContext;
@property (nonatomic, copy) NSString *bulletinPublisherID;
@property (nonatomic, copy) NSString *bulletinRecordID;
@property (nonatomic, copy) NSDictionary *context;

@end