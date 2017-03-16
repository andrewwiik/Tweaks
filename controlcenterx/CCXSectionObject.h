#import "headers.h"

#import "CCXSectionControllerDelegate-Protocol.h"

@interface CCXSectionObject : NSObject <NSCoding>
@property (nonatomic, retain) NSString *sectionName;
@property (nonatomic, retain) NSString *sectionIdentifier;
@property (nonatomic, assign) Class<CCXSectionControllerDelegate> controllerClass;
@property (nonatomic, retain) UIImage *sectionIcon;
@property (nonatomic, assign) Class settingsControllerClass;
- (id)initWithSectionClass:(Class<CCXSectionControllerDelegate>)sectionClass;
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
@end