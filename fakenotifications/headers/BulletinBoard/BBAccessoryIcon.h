@interface BBAccessoryIcon : NSObject <NSCopying, NSSecureCoding> {

	NSMutableDictionary* _imagesForContentSize;

}

@property (nonatomic,copy) NSDictionary * imagesForContentSize;              //@synthesize imagesForContentSize=_imagesForContentSize - In the implementation block
+(BOOL)supportsSecureCoding;
-(id)init;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(BOOL)isEqual:(id)arg1 ;
-(id)copyWithZone:(NSZone*)arg1 ;
-(NSDictionary *)imagesForContentSize;
-(void)setImagesForContentSize:(NSDictionary *)arg1 ;
-(void)addImage:(id)arg1 forContentSizeCategory:(id)arg2 ;
-(id)imageForContentSizeCategory:(id)arg1 ;
@end