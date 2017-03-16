//  
//                                                                                                    
//    HeartTransplant.h
//    Compilation interfaces and helpers                                                                                                    
//    Add to My Music by Liking a Song                                                                                                    
//    Created by CP Digital Darkroom <tweaks@cpdigitaldarkroom.support> 07/28/2015                                                                                                    
//    © CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//
//
//

#ifdef DEBUG
	#define CPLog(fmt, ...) NSLog((@"HeartTransplant DEBUG [Line %d]: " fmt), __LINE__, ##__VA_ARGS__)
#else
	#define CPLog(...)
#endif

@interface MusicRemoteController : NSObject
-(int)_handleAddToLibraryCommand:(id)arg1 ;
-(int)_handleLikeCommand:(id)arg1 ;

@end
@interface MusicLibraryActionKeepLocalOperation : NSOperation
- (id)contentItemIdentifierCollection;
- (void)main;
@end

@interface MusicContextualActionsAlertController : UIAlertController
@end