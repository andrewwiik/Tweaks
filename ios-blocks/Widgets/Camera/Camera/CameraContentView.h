//
//  CameraContentView.h
//  Camera
//
//  Created by Matt Clarke on 20/04/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CameraWidgetButton.h"
#import "CKBlurView.h"

@interface CameraContentView : UIView {
    NSTimer *timer;
}

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) NSArray *filenames;
@property (nonatomic, readwrite) int currentImage;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *transitionImage;
@property (nonatomic, strong) CKBlurView *blur;
@property (nonatomic, strong) CameraWidgetButton *cameraButton;
@property (nonatomic, strong) CameraWidgetButton *videoButton;
@property (nonatomic, readwrite) BOOL isGoingToTakeVideo;
@property (nonatomic, strong) UIView *pickerSuperview;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIWindow *pickerWindow;
@property (nonatomic, readwrite) BOOL cameraOpen;

@end