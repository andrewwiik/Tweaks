#import "headers.h"
#import "CCXSectionObject.h"

@interface CCXSectionsPanel : NSObject
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) NSMutableArray *sectionIdentifiers;
+ (instancetype)sharedInstance;
- (NSArray *)sortedSectionIdentifiers;
- (CCXSectionObject *)sectionObjectForIdentifier:(NSString *)identifier;
- (UIColor *)primaryColorForSectionIdentifier:(NSString *)identifier;
@end