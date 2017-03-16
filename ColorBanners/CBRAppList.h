@interface CBRAppList : NSObject {

}
+ (NSArray *)allAppIdentifiers;
+ (NSString *)randomAppIdentifier;
+ (NSSet *)hiddenIdentifiers;
@end
