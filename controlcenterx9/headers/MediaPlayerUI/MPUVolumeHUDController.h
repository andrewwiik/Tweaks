@interface MPUVolumeHUDController : NSObject {

	NSMutableDictionary* _categoriesToEnabledStates;

}

@property (nonatomic,readonly) NSDictionary * categoriesToEnabledStates; 
-(id)init;
// -(void)dealloc;
-(NSDictionary *)categoriesToEnabledStates;
-(BOOL)volumeHUDEnabledForCategory:(id)arg1 ;
-(void)setVolumeHUDEnabled:(BOOL)arg1 forCategory:(id)arg2 ;
@end