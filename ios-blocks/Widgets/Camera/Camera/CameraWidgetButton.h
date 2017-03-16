//
//  CameraWidgetButton.h
//  Camera
//
//  Created by Matt Clarke on 20/04/2015.
//
//

#import <UIKit/UIKit.h>

@interface CameraWidgetButton : UIButton

@property (nonatomic, strong) UIView *outerRing;
@property (nonatomic, strong) UIView *innerRing;
@property (nonatomic, readwrite) BOOL isVideo;

-(void)setupForIsVideo:(BOOL)video;
-(void)setIsExpanding:(BOOL)expanding;

@end
