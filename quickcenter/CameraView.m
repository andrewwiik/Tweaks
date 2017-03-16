//
//  CameraView.m
//  test
//
//  Created by Brian Olencki on 11/21/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import "CameraView.h"

#define SCREEN ([[UIScreen mainScreen] bounds]) // Screen Bounds
#define CENTER (CGPointMake(SCREEN.size.width/2, SCREEN.size.height/2)) // Center of Device Screen
#define kResizeThumbSize (35)

@implementation CameraView
@synthesize delegate = _delegate, iconFrame = _iconFrame;
- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //_iconFrame = [[self superview] contentViewIconFrame];
    }
    return self;
}

#pragma mark - Public Functions
- (void)presentCamera:(int)arg1 {

    dispatch_async(dispatch_get_main_queue(), ^{//done on different thread to prevent lag (hopefully)
        inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        self.inputDeviceHelp = inputDevice;

        captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];// get input from camera
        if (!captureInput) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"An error loading the camera has occured." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [self dismissCameraAndTakePhoto:NO];
            return;//no camera available error message shows
        }
        AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
        NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
        NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
        [captureOutput setVideoSettings:videoSettings];//set settings
        captureSession = [[AVCaptureSession alloc] init];
        self.captureSessionHelp = [captureSession retain];
        NSString* preset = 0;
        if (!preset) {
            preset = AVCaptureSessionPresetPhoto;//sets it as photo not video
        }
        captureSession.sessionPreset = preset;
        if ([captureSession canAddInput:captureInput]) {
            [captureSession addInput:captureInput];//adds input to output so user can see the camera
        }

        stillImageOutput = [[AVCaptureStillImageOutput alloc] init];

        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [stillImageOutput setOutputSettings:outputSettings];
        [captureSession addOutput:stillImageOutput];
        livePreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];//makes the camera layer visible by adding it to the view's layer

        livePreviewLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        livePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer addSublayer: livePreviewLayer];

        [captureSession startRunning];//starts running the camera



        //UIPanGestureRecognizer *pgrResize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        //[self addGestureRecognizer:pgrResize];
        UITapGestureRecognizer *tgrPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tgrPhoto];//adds take photo gesture
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchCamera)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];//adds flip camera gesture
        [tgrPhoto requireGestureRecognizerToFail:doubleTap];
        UIPinchGestureRecognizer *zoomGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchToZoomRecognizer:)];
        [self addGestureRecognizer:zoomGesture];//adds zoom gesture
        UILongPressGestureRecognizer *focusGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(focusWithLongPress:)];
        focusGesture.minimumPressDuration = 1.5;
        [self addGestureRecognizer: focusGesture];//adds force gesture

        dispatch_async(dispatch_get_main_queue(), ^(void){
          if (arg1 == 1) {
              [self toggleCamera:BackView];//toggles camera
          }
          else if (arg1 == 2) {
              [self toggleCamera:FrontView];//toggles camera
          }

          [_delegate cameraViewDidFinishLoading:self];//runs delegate
        });
    });
}
- (void)doneLoading {
  //apparently does nothing
}
- (void)dismissCameraAndTakePhoto:(BOOL)takePhoto {
    if (takePhoto) {
        [self takePhoto];//takes photo
        [_delegate cameraViewDidTakePhoto:self];//runs delegate
    }
}
- (void)shutterWithColor:(UIColor*)color {
  //flashes white UIView on screen and then removes the view
    UIView *viewSuccess = [[UIView alloc] initWithFrame:self.bounds];
           viewSuccess.backgroundColor = color;
           viewSuccess.alpha = 0.0;
           [self addSubview:viewSuccess];

           [UIView animateWithDuration:0.25 animations:^{
               viewSuccess.alpha = 1.0;
           } completion:^(BOOL finished) {
               [UIView animateWithDuration:0.25 animations:^{
                   viewSuccess.alpha = 0.0;
               } completion:^(BOOL finished) {
                   [viewSuccess removeFromSuperview];
                   }];
               }];
}
- (void)setCameraViewMode:(CameraMode)cameraModeView {
    [self toggleCamera:cameraModeView];//toggles the camera
}
- (CameraMode)cameraMode {
    NSArray * inputs = captureSession.inputs;//gets all inputs
    for ( AVCaptureDeviceInput *INPUT in inputs ) {
        AVCaptureDevice *Device = INPUT.device ;
        if ([Device hasMediaType : AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = Device.position;

            if (position == AVCaptureDevicePositionFront) {//checks the view of the camera
                return FrontView;//returns camera is front
            } else {
                return BackView;//returns camera is back
            }
            break;
        }
    }
    return UnknownView;
}
- (void)switchCamera {
    if ([self cameraMode] == BackView) {
        [self toggleCamera:FrontView];//toggles camera front
    }
    else if ([self cameraMode] == FrontView) {
        [self toggleCamera:BackView];//toggles camera back
    }

}
- (void)resize {
  if (touchingCorner == YES) {//checks a corner is touched
    if (isResizingLR) {//checks which corner
      CGFloat finalHeight = touchPoint.y+deltaWidth;
      CGFloat finalWidth = touchPoint.x+deltaWidth;

      if (finalWidth > SCREEN.size.width - self.superview.frame.origin.x - 20 ) {
        finalWidth = self.superview.frame.size.width;

        }
        if (finalWidth < _iconFrame.size.width) {
          finalWidth = self.superview.frame.size.width;
        }

        if (finalHeight < _iconFrame.size.height) {
          finalHeight = self.superview.frame.size.height;
        }
        if (finalHeight > SCREEN.size.height - self.superview.frame.origin.y - 20) {
          finalHeight = self.superview.frame.size.height;
        }


        self.superview.frame = CGRectMake(x, y, finalWidth, finalHeight);//sets new frame

      }
      else if (isResizingUL) {//checks which corner
        CGFloat finalHeight = height-deltaHeight;
        CGFloat finalWidth = width-deltaWidth;
        CGFloat finalX = x+deltaWidth;
        CGFloat finalY = y+deltaHeight;

        if (finalWidth < _iconFrame.size.width) {
            finalWidth = self.superview.frame.size.width;
            finalX = self.superview.frame.origin.x;
        }
        if (finalHeight < _iconFrame.size.height) {
          finalHeight = self.superview.frame.size.height;
          finalY = self.superview.frame.origin.y;
        }

        if (finalWidth > SCREEN.size.width - (SCREEN.size.width - self.superview.frame.origin.x - self.superview.frame.size.width) -20) {
          finalWidth = self.superview.frame.size.width;
          finalX = self.superview.frame.origin.x;
        }

        if (finalHeight > SCREEN.size.height - (SCREEN.size.height - self.superview.frame.origin.y - self.superview.frame.size.height) - 20) {
          finalHeight = self.superview.frame.size.height;
          finalY = self.superview.frame.origin.y;
        }

        self.superview.frame = CGRectMake(finalX, finalY, finalWidth, finalHeight);//sets new frame

      }
      else if (isResizingUR) {//checks which corner
        //does normal resize
      }
      else if (isResizingLL) {//checks which corner
        CGFloat finalHeight = height+deltaHeight;
        CGFloat finalWidth = width-deltaWidth;
        CGFloat finalX = x+deltaWidth;

        if (finalWidth < _iconFrame.size.width) {
            finalWidth = self.superview.frame.size.width;
            finalX = self.superview.frame.origin.x;
        }
        if (finalHeight < _iconFrame.size.height) {
          finalHeight = self.superview.frame.size.height;
        }

        if (finalHeight > SCREEN.size.height - self.superview.frame.origin.y - 20) {
          finalHeight = self.superview.frame.size.height;
        }
        if (finalWidth > SCREEN.size.width - (SCREEN.size.width - self.superview.frame.origin.x - self.superview.frame.size.width) -20) {
          finalWidth = self.superview.frame.size.width;
          finalX = self.superview.frame.origin.x;
        }

        self.superview.frame = CGRectMake(finalX, y, finalWidth, finalHeight);//sets new frame
      }
      self.frame = self.superview.bounds;
      previous = touchPoint;
      updateFrame = YES;
    }
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   if (calculatedCorner == NO) {
    UIView *contentView = self.superview;
            if (contentView.frame.origin.x < _iconFrame.origin.x && contentView.frame.origin.y < _iconFrame.origin.y) {
              NSLog(@"Top-Left");
              isResizingUR = NO;
              isResizingLR = NO;
              isResizingLL = NO;
              isResizingUL = YES;
              corner = CornerTypeUL;//sets resize type
            } else if (contentView.frame.origin.x+contentView.frame.size.width > _iconFrame.origin.x && contentView.frame.origin.y < _iconFrame.origin.y) {
              NSLog(@"Top-Right");
              isResizingUL = NO;
              isResizingLL = NO;
              isResizingLR = NO;
              isResizingUR = YES;
              corner = CornerTypeUR;//sets resize type
            } else if (contentView.frame.origin.x < _iconFrame.origin.x && contentView.frame.origin.y > _iconFrame.origin.y) {
              NSLog(@"Bottom-Left");
              isResizingUL = NO;
              isResizingUR = NO;
              isResizingLR = NO;
              isResizingLL = YES;
              corner = CornerTypeLL;//sets resize type
            } else if (contentView.frame.origin.x+contentView.frame.size.width > _iconFrame.origin.x && contentView.frame.origin.y > _iconFrame.origin.y) {
              NSLog(@"Bottom-Right");
              isResizingUL = NO;
              isResizingUR = NO;
              isResizingLL = NO;
              isResizingLR = YES;
              corner = CornerTypeLR;//sets resize type
            }
            calculatedCorner = YES;
   }

    UITouch *touch = [[event allTouches] anyObject];
    touchStart = [[touches anyObject] locationInView:self];
    previous=[[touches anyObject]previousLocationInView:self];
    if ((self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize) ||
        (touchStart.x <kResizeThumbSize && touchStart.y <kResizeThumbSize) ||
        (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize) ||
        (touchStart.x <kResizeThumbSize && self.bounds.size.height -touchStart.y <kResizeThumbSize)) {
     touchingCorner = YES;
      NSLog(@"We are on a corner");
      //a corner has been touched start resize gesture
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
  NSLog(@"Moved On Camera View");
    touchPoint = [[touches anyObject] locationInView:self];
    previous = [[touches anyObject]previousLocationInView:self];

    deltaWidth = touchPoint.x-previous.x;
    deltaHeight = touchPoint.y-previous.y;

    x = self.superview.frame.origin.x;
    y = self.superview.frame.origin.y;
    width = self.superview.frame.size.width;
    height = self.superview.frame.size.height;

    if (isResizingLR) {
      [self resize];//resize calculations
    }
    if (isResizingUL) {
     [self resize];//resize calculations
    }
    if (isResizingUR && touchingCorner == YES) {//special resize calculations
      if (touchPoint.y > previous.y) { // is dragging down
        if (self.superview.frame.size.height < _iconFrame.size.height) { // if height is lower than minimum
          if (self.superview.frame.origin.x + self.superview.frame.size.width < SCREEN.size.width - 25) { // if width is lower than max
            if (self.superview.frame.size.width < _iconFrame.size.width) {
              if (touchPoint.x < previous.x) {// dragging left
                if (self.superview.frame.size.width < _iconFrame.size.width) {

                }
                else {
                self.superview.frame = CGRectMake(x, y, width+deltaWidth, height);
                }
              }
              else {
                 self.superview.frame = CGRectMake(x, y, width+deltaWidth, height);
              }
            }
            else {
                self.superview.frame = CGRectMake(x, y, width+deltaWidth, height);
            }
          }
          else { // if width is higher than max
            if (touchPoint.x < previous.x) {// dragging left
              if (self.superview.frame.size.width < _iconFrame.size.width) {

              }
              else {
              }
            }
            else { // if isn't dragging left
              if (self.superview.frame.size.width < _iconFrame.size.width) {

              }
              else {
              }
            }
          }
        }
        else {
          if (self.superview.frame.origin.x + self.superview.frame.size.width < SCREEN.size.width - 10) { // if width is lower than max
            if (self.superview.frame.size.width < _iconFrame.size.width) {
              self.superview.frame = CGRectMake(x, y+deltaHeight, width, height-deltaHeight);
            }
            else {
                self.superview.frame = CGRectMake(x, y+deltaHeight, width+deltaWidth, height-deltaHeight);
            }
          }
          else { // if width is higher than max
            if (touchPoint.x < previous.x) {// dragging left
              if (self.superview.frame.size.width < _iconFrame.size.width) {
                self.superview.frame = CGRectMake(x, y+deltaHeight, width, height-deltaHeight);
              }
              else {
                self.superview.frame = CGRectMake(x, y, width+deltaWidth, height);
              }
            }
            else { // if isn't dragging left
               if (self.superview.frame.size.width < _iconFrame.size.width) {

              }
              else {
              }
            }
          }
        }
      }
      else if (touchPoint.y < previous.y) { // is dragging up
        if (self.superview.frame.origin.y < SCREEN.origin.y + 25) { //
          if (self.superview.frame.origin.x + self.superview.frame.size.width < SCREEN.size.width - 10) { // if width is lower than max
            if (self.superview.frame.size.width < _iconFrame.size.width) {

              }
              else {
                 self.superview.frame = CGRectMake(x, y, width+deltaWidth, height);
              }
          }
          else { // if width is higher than MAX
            if (touchPoint.x < previous.x) {// dragging left
              if (self.superview.frame.size.width < _iconFrame.size.width) {

              }
              else {
                 self.superview.frame = CGRectMake(x, y, width+deltaWidth, height);
              }
            }
            else {
            }
          }
        }
        else {
          if (self.superview.frame.origin.x + self.superview.frame.size.width < SCREEN.size.width - 10) { // if width is lower than max
            if (touchPoint.x < previous.x) {// dragging left
              if (self.superview.frame.size.width < _iconFrame.size.width) {

              }
              else {
                 self.superview.frame = CGRectMake(x, y+deltaHeight, width+deltaWidth, height-deltaHeight);
              }
            }
            else {
              self.superview.frame = CGRectMake(x, y+deltaHeight, width+deltaWidth, height-deltaHeight);
            }
          }
          else { // if width is higher than max
            if (touchPoint.x < previous.x) { // dragging left
              if (self.superview.frame.size.width < _iconFrame.size.width) {

              }
              else {
                self.superview.frame = CGRectMake(x, y+deltaHeight, width+deltaWidth, height-deltaHeight);
              }// dragging left
            }
            else {
              self.superview.frame = CGRectMake(x, y+deltaHeight, width, height-deltaHeight);
            }
          }
        }
      }
      else {
        if (self.superview.frame.origin.x + self.superview.frame.size.width < SCREEN.size.width - 10) { // if width is lower than max
          if (self.superview.frame.size.width < _iconFrame.size.width + _iconFrame.size.width/2) {

          }
          else {
             self.superview.frame = CGRectMake(x, y+deltaHeight, width+deltaWidth, height-deltaHeight);
          }
        }
        else {
          self.superview.frame = CGRectMake(x, y+deltaHeight, width, height-deltaHeight);
        }
      }
      self.frame = self.superview.bounds;
      previous = touchPoint;
      updateFrame = YES;
    }
    if (isResizingLL) {
       [self resize];//resize calculations
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  touchingCorner = NO;//signal corner movement is done
}
- (void)layoutSubviews {
  //if (cameraCornerView) {
    //[cameraCornerView removeFromSuperview];//removes camera view corner movement view
  //}
  if (calculatedCorner == YES) {
    //cameraCornerView = [[CornerHighlightView alloc] initWithCorner:corner withTouchSize:kResizeThumbSize withFrame:self.bounds];
    //[self addSubview:cameraCornerView];//adds the camera view corner movement view
  }
  if (updateFrame == YES) {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    livePreviewLayer.frame = self.superview.bounds;//updates camera layer size
    [CATransaction commit];
  }
}
- (void)handleTap:(UITapGestureRecognizer*)recognizer {
  [self dismissCameraAndTakePhoto:YES];//camera takes photo
}
- (void)handlePinchToZoomRecognizer:(UIPinchGestureRecognizer*)pinchRecognizer {
    const CGFloat pinchVelocityDividerFactor = 25.0f;//zoom factor

    if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
        NSError *error = nil;
        NSArray * inputs = captureSession.inputs;
        AVCaptureDevice *videoDevice;
        for ( AVCaptureDeviceInput *INPUT in inputs ) {
        videoDevice = INPUT.device;//gets camera
        }
        if ([videoDevice lockForConfiguration:&error]) {
            CGFloat desiredZoomFactor = videoDevice.videoZoomFactor + atan2f(pinchRecognizer.velocity, pinchVelocityDividerFactor);
            // Check if desiredZoomFactor fits required range from 1.0 to activeFormat.videoMaxZoomFactor
            videoDevice.videoZoomFactor = MAX(1.0, MIN(desiredZoomFactor, videoDevice.activeFormat.videoMaxZoomFactor));//sets camera zoom
            [videoDevice unlockForConfiguration];
        } else {
            NSLog(@"error: %@", error);
        }
    }
}

#pragma mark - Private Function
- (void)toggleCamera:(CameraMode)cameraViewMode {
    NSArray * inputs = captureSession.inputs;
    for ( AVCaptureDeviceInput *INPUT in inputs ) {
        AVCaptureDevice *Device = INPUT.device ;//gets input
        if ([Device hasMediaType : AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = Device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;

            if (position == AVCaptureDevicePositionFront) {
                if (cameraViewMode == BackView) {//check if already that direction
                    newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];//toggles
                } else {
                    return;
                }
            } else {
                if (cameraViewMode == FrontView) {//checks if already that direction
                    newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];//toggles
                } else {
                    return;
                }
            }
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];

            //beginConfiguration ensures that pending changes are not applied immediately
            [captureSession beginConfiguration];

            [captureSession removeInput : INPUT];//removes old input
            [captureSession addInput : newInput];//sets new input

            //Changes take effect once the outermost commitConfiguration is invoked.
            [captureSession commitConfiguration];
            break;
        }
    }

}
- (void)focusWithLongPress:(UILongPressGestureRecognizer *)gesture {
    NSArray * inputs = captureSession.inputs;
    for ( AVCaptureDeviceInput *INPUT in inputs ) {
        AVCaptureDevice *Device = INPUT.device ;
          if ([Device isFocusPointOfInterestSupported]) {
            CGPoint point = [gesture locationInView:self];
            float newX = point.x / self.frame.size.width;
            float newY = point.y / self.frame.size.height;
            NSError *error;

            if ([Device lockForConfiguration:&error]) {//checks if focusing is supported

              [Device setFocusPointOfInterest:CGPointMake(newX, newY)];//focuses camera

              [Device setFocusMode:AVCaptureFocusModeAutoFocus];//focuses camera

              [Device unlockForConfiguration];

            }
          }
          else {
        // Focus not supported
          }
    }
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray * Devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] ;
    for (AVCaptureDevice *Device in Devices) if (Device.position == position ) return Device;//returs device input

    return nil;
}
- (void)takePhoto {//takes photo
  if (!captureSession.isRunning) {
    [self shutterWithColor:[UIColor redColor]];
    return;
  } else {
    [self shutterWithColor:[UIColor whiteColor]];//runs shutter to signal photo was taken
  }
  AVCaptureConnection *videoConnection = nil;
  for (AVCaptureConnection *connection in stillImageOutput.connections) {
      for (AVCaptureInputPort *port in [connection inputPorts]) {
          if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
              videoConnection = connection;
              break;
          }
      }
      if (videoConnection) {
          break;
      }
  }

  [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
      if (error) {
        return;
      }

      NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];

      UIImage *imgTaken = [[UIImage alloc] initWithData:imageData];
      UIImageWriteToSavedPhotosAlbum(imgTaken, nil, nil, nil);//writes image to photo album
  }];
}
@end
