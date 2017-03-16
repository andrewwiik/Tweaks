//  
//                                                                                                    
//    HeartTransplant.xm                                                                                                    
//    Add to My Music by Liking a Song                                                                                                    
//    Created by CP Digital Darkroom <tweaks@cpdigitaldarkroom.support> 07/28/2015                                                                                                    
//    © CP Digital Darkroom <tweaks@cpdigitaldarkroom.support>. All rights reserved.
//    
//
//

#import "HeartTransplant.h"
%hook MusicRemoteController
- (int)_handleLikeCommand:(id)arg1
{
	[self _handleAddToLibraryCommand:0];
	return %orig;
}
%end
%hook MusicContextualActionsAlertController
-(void)_actionViewTapped:(id)arg1
{
	CPLog(@"Handling Tap On View:%@ with available actions:%@", self.actions);
	%orig;
}
%end