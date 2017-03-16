//
//  CameraWidgetOverlayView.h
//  Camera
//
//  Created by Matt Clarke on 21/04/2015.
//
//

#import <UIKit/UIKit.h>

@interface CameraWidgetOverlayView : UIView

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) UIButton *close;

@end
