@protocol WeatherPreferencesPersistence
@required
-(id)objectForKey:(id)arg1;
-(void)removeObjectForKey:(id)arg1;
-(void)setObject:(id)arg1 forKey:(id)arg2;
-(BOOL)synchronize;
-(BOOL)boolForKey:(id)arg1;
-(id)stringForKey:(id)arg1;
-(void)setBool:(BOOL)arg1 forKey:(id)arg2;
-(id)dictionaryForKey:(id)arg1;
-(id)arrayForKey:(id)arg1;

@end