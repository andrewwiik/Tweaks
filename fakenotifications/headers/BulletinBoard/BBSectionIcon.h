@interface BBSectionIcon : NSObject <NSCopying, NSSecureCoding> {

	NSSet* _variants;

}

@property (nonatomic,copy) NSSet * variants;              //@synthesize variants=_variants - In the implementation block
+(BOOL)supportsSecureCoding;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(BOOL)isEqual:(id)arg1 ;
-(id)copyWithZone:(NSZone*)arg1 ;
-(id)_bestVariantForFormat:(long long)arg1 ;
-(NSSet *)variants;
-(void)setVariants:(NSSet *)arg1 ;
-(void)addVariant:(id)arg1 ;
-(id)_bestVariantForUIFormat:(int)arg1 ;
@end

