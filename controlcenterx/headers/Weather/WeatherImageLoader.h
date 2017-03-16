
@interface WeatherImageLoader : NSObject {

	CGFloat _scale;
	NSCache* _conditionImagesCache;

}

@property (nonatomic,retain) NSCache * conditionImagesCache;              //@synthesize conditionImagesCache=_conditionImagesCache - In the implementation block
+(id)sharedImageLoader;
+(id)conditionImageBundle;
+(id)conditionImageNameWithConditionIndex:(NSInteger)arg1 ;
+(id)conditionImageNamed:(id)arg1 ;
+(void)cacheImageIfNecessary:(id)arg1 ;
+(id)conditionImageWithConditionIndex:(NSInteger)arg1 ;
+(id)cachedImageNamed:(id)arg1 completion:(/*^block*/id)arg2 ;
-(id)init;
-(void)setImage:(id)arg1 forKey:(id)arg2 ;
-(id)cachedImageForKey:(id)arg1 ;
-(NSCache *)conditionImagesCache;
-(void)setConditionImagesCache:(NSCache *)arg1 ;
@end