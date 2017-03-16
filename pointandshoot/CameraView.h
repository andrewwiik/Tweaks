//
//  CameraView.h
//  test
//
//  Created by Brian Olencki on 11/21/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//
//SBApplicationShortcutMenuContentView.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import "CornerHighlightView.h"
// #import <ImageIO/ImageIO.h>

@class CameraView;
@protocol CameraViewDelegate <NSObject>
- (void)cameraViewDidFinishLoading:(CameraView*)camera;
- (void)cameraViewDidTakePhoto:(CameraView*)camera;
@end

typedef enum { 
    FrontView,
    BackView,
    UnknownView
} CameraMode;

@interface CameraView : UIView {
    AVCaptureSession *captureSession;
    AVCaptureDevice *inputDevice;
    AVCaptureDeviceInput *captureInput;
    AVCaptureVideoPreviewLayer *livePreviewLayer;
    AVCaptureStillImageOutput *stillImageOutput;

    CGPoint touchStart;
    CGPoint previousPoint;
    BOOL isUp, isRight;
    BOOL isResizingLR, isResizingUL, isResizingUR, isResizingLL;
    BOOL touchForPhoto, updateFrame;
    CGFloat x, y, width, height;
    float deltaWidth, deltaHeight;
    CGPoint touchPoint, previous;
    BOOL touchingCorner;
    BOOL torchIsOn;
    BOOL calculatedCorner;

    __unsafe_unretained id<CameraViewDelegate> _delegate;
    CGRect _iconFrame;
    CornerHighlightView *cameraCornerView;
    CornerType corner;
}
@property (assign, nonatomic) id<CameraViewDelegate> delegate;
@property (assign, nonatomic) CGRect iconFrame;
- (void)presentCamera:(int)arg1;
- (void)dismissCameraAndTakePhoto:(BOOL)takePhoto;
- (void)setCameraViewMode:(CameraMode)cameraModeView;
- (void)shutter;
- (void)resize;
- (void)doneLoading;
@end
