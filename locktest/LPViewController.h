//
//  LockLyrics7.xm
//  LockLyrics7
//
//  Created by Pigi Galdi on 13.10.2014.
//  Copyright (c) 2014 Pigi Galdi. All rights reserved.
//
//	Imports.
#import "Imports.h"

@interface LPViewController : UIViewController <LPPage>	
@property (nonatomic, retain) LPView *mainView; 		 // Create and istance of LPView.
- (void)setUpFavorites;
@end
