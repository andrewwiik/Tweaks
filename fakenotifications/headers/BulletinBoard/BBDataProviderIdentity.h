#import <BulletinBoard/BBSectionIcon.h>
@interface BBDataProviderIdentity : NSObject <NSSecureCoding> {

	NSString* _sectionIdentifier;
	NSString* _universalSectionIdentifier;
	NSString* _sectionDisplayName;
	BBSectionIcon* _sectionIcon;
	NSArray* _sortDescriptors;
	NSArray* _defaultSubsectionInfos;
	NSDictionary* _subsectionDisplayNames;
	NSString* _sortKey;
	NSString* _parentSectionIdentifier;
	NSDictionary* _filterDisplayNames;
	BOOL _syncsBulletinDismissal;

}

@property (nonatomic,copy) NSString * sectionIdentifier;                           //@synthesize sectionIdentifier=_sectionIdentifier - In the implementation block
@property (nonatomic,copy) NSString * universalSectionIdentifier;                  //@synthesize universalSectionIdentifier=_universalSectionIdentifier - In the implementation block
@property (nonatomic,copy) NSString * sectionDisplayName;                          //@synthesize sectionDisplayName=_sectionDisplayName - In the implementation block
@property (nonatomic,copy) BBSectionIcon * sectionIcon;                            //@synthesize sectionIcon=_sectionIcon - In the implementation block
@property (nonatomic,copy) NSArray * sortDescriptors;                              //@synthesize sortDescriptors=_sortDescriptors - In the implementation block
@property (nonatomic,copy) NSArray * defaultSubsectionInfos;                       //@synthesize defaultSubsectionInfos=_defaultSubsectionInfos - In the implementation block
@property (nonatomic,copy) NSString * sortKey;                                     //@synthesize sortKey=_sortKey - In the implementation block
@property (nonatomic,copy) NSDictionary * subsectionDisplayNames;                  //@synthesize subsectionDisplayNames=_subsectionDisplayNames - In the implementation block
@property (nonatomic,readonly) BOOL syncsBulletinDismissal;                        //@synthesize syncsBulletinDismissal=_syncsBulletinDismissal - In the implementation block
@property (nonatomic,copy) NSString * parentSectionIdentifier;                     //@synthesize parentSectionIdentifier=_parentSectionIdentifier - In the implementation block
@property (nonatomic,copy) NSDictionary * filterDisplayNames;                      //@synthesize filterDisplayNames=_filterDisplayNames - In the implementation block
+(BOOL)supportsSecureCoding;
+(id)identityForDataProvider:(id)arg1 ;
+(id)identityForRemoteDataProvider:(id)arg1 ;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(id)description;
-(void)setSortDescriptors:(NSArray *)arg1 ;
-(NSArray *)sortDescriptors;
-(NSString *)sortKey;
-(void)setSortKey:(NSString *)arg1 ;
-(void)setUniversalSectionIdentifier:(NSString *)arg1 ;
-(id)initForDataProvider:(id)arg1 forRemoteDataProvider:(BOOL)arg2 ;
-(void)setSectionDisplayName:(NSString *)arg1 ;
-(void)setSectionIcon:(BBSectionIcon *)arg1 ;
-(void)setDefaultSubsectionInfos:(NSArray *)arg1 ;
-(NSDictionary *)subsectionDisplayNames;
-(void)setSubsectionDisplayNames:(NSDictionary *)arg1 ;
-(NSDictionary *)filterDisplayNames;
-(void)setFilterDisplayNames:(NSDictionary *)arg1 ;
-(void)setSectionIdentifier:(NSString *)arg1 ;
-(NSString *)sectionIdentifier;
-(NSArray *)defaultSubsectionInfos;
-(BOOL)syncsBulletinDismissal;
-(NSString *)universalSectionIdentifier;
-(NSString *)sectionDisplayName;
-(BBSectionIcon *)sectionIcon;
-(NSString *)parentSectionIdentifier;
-(void)setParentSectionIdentifier:(NSString *)arg1 ;
@end