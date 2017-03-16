@interface __NSBundleTables : NSObject {

	NSLock* _lock;
	NSMutableSet* _staticFrameworks;
	NSMutableSet* _loadedBundles;
	NSMutableSet* _loadedFrameworks;
	NSMutableDictionary* _resolvedPathToBundles;
	CFDictionaryRef _bundleForClassMap;

}
+(id)bundleTables;
-(void)removeBundle:(id)arg1 forPath:(id)arg2 type:(unsigned long long)arg3 ;
-(void)setBundle:(id)arg1 forClass:(Class)arg2 ;
-(id)loadedBundles;
-(id)allBundles;
-(void)addStaticFrameworkBundles:(id)arg1 ;
-(id)allFrameworks;
-(id)bundleForPath:(id)arg1 ;
-(void)addBundle:(id)arg1 type:(unsigned long long)arg2 ;
-(id)addBundle:(id)arg1 forPath:(id)arg2 ;
-(id)init;
-(void)dealloc;
-(id)bundleForClass:(Class)arg1 ;
@end