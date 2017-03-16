//
//  CameraView.m
//  test
//
//  Created by Brian Olencki on 11/21/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import "CameraView.h" // Import our header for this view
#import "CornerHighlightView.h" // Impprt the corner highlight header

#define NSLog(FORMAT, ...) NSLog(@"[%@]: %@",@"Appendix" , [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#define SCREEN ([[UIScreen mainScreen] bounds]) // Screen Bounds
#define CENTER (CGPointMake(SCREEN.size.width/2, SCREEN.size.height/2)) // Center of Device Screen
#define kResizeThumbSize (35) // the size of each corner resize handle

@implementation CameraView 
@synthesize delegate = _delegate, iconFrame = _iconFrame; 
- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor]; // Set the background color of our view to transparent
    }
    return self;
}

#pragma mark - Public Functions
- (void)presentCamera:(int)arg1 {

    dispatch_async(dispatch_get_main_queue(), ^{//done on different thread to prevent lag (hopefully)
        inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]; // set our input device type
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
        NSString* preset = 0;
        if (!preset) {
            preset = AVCaptureSessionPresetPhoto; //sets it as photo not video
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




        UITapGestureRecognizer *tgrPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tgrPhoto]; // Adds take photo gesture
        UITapGestureRecognizer *doubleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchCamera)] autorelease];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap]; // Adds flip camera gesture
        [tgrPhoto requireGestureRecognizerToFail:doubleTap];
        UIPinchGestureRecognizer *zoomGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchToZoomRecognizer:)];
        [self addGestureRecognizer:zoomGesture]; // Adds zoom gesture
        UILongPressGestureRecognizer *focusGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(focusWithLongPress:)];
        focusGesture.minimumPressDuration = 1.5;
        [self addGestureRecognizer: focusGesture]; // Adds focus gesture

        dispatch_async(dispatch_get_main_queue(), ^(void){
          if (arg1 == 1) {
              [self toggleCamera:BackView]; // Toggles camera to the rear facing camera
          }
          else if (arg1 == 2) {
              [self toggleCamera:FrontView]; // Toggles camera to the front facing camera
          }

          [_delegate cameraViewDidFinishLoading:self];//runs delegate
        });
    });
}
- (void)doneLoading {
  //apparently does nothing
}
- (void)dismissCameraAndTakePhoto:(BOOL)takePhoto {
    if (takePhoto) { // If we mean to take a photo
        [self takePhoto]; // call take photo method
        [self shutter];// runs shutter to signal photo was taken
        [_delegate cameraViewDidTakePhoto:self]; //runs delegate
    }
}
- (void)shutter {
  //flashes white UIView on screen and then removes the view
    UIView *viewSuccess = [[UIView alloc] initWithFrame:self.bounds]; // Creating our shutter view
           viewSuccess.backgroundColor = [UIColor whiteColor]; // Setting the shutter background to white
           viewSuccess.alpha = 0.0; // Making the shutter view totally transparent
           [self addSubview:viewSuccess]; // Add the shutter view to our camera view

           [UIView animateWithDuration:0.25 animations:^{ // Animate the shutter 
               viewSuccess.alpha = 1.0; // Make the shutter Opaque
           } completion:^(BOOL finished) { // After our animation is complete
               [UIView animateWithDuration:0.25 animations:^{
                   viewSuccess.alpha = 0.0; // Make the shutter transparent
               } completion:^(BOOL finished) {
                   [viewSuccess removeFromSuperview]; // remvoe the shutter from our view
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


- (void)resize { // Resize calcualtion to make sure the user doesn't resize beyond the screen
  if (touchingCorner == YES) { // Checks a corner is touched
    if (isResizingLR) { // If the bottom-right corner is opposite diagonally to the icon
      CGFloat finalHeight = touchPoint.y+deltaWidth; // The planned new height for our view
      CGFloat finalWidth = touchPoint.x+deltaWidth; // The planned new width for our view

      if (finalWidth > SCREEN.size.width - self.superview.frame.origin.x - 20 ) { // If the planned new width is beyond the allowed width
        finalWidth = self.superview.frame.size.width; // Reset the new planned width to what it currently is.

        }
        if (finalWidth < _iconFrame.size.width) { // If the planned new width is less than allowed width
          finalWidth = self.superview.frame.size.width; // Reset the new planned width to what it currently is.
        }

        if (finalHeight < _iconFrame.size.height) { // If the planned new height is less than the allowed height
          finalHeight = self.superview.frame.size.height; // Reset the new planned height to what it currently is
        }
        if (finalHeight > SCREEN.size.height - self.superview.frame.origin.y - 20) { // If the planned new height is greater than the allowed height
          finalHeight = self.superview.frame.size.height; // Reset the new planned height to what it currently is
        }


        self.superview.frame = CGRectMake(x, y, finalWidth, finalHeight); // Set the new frame

      }
      else if (isResizingUL) { // If the top-left corner is opposite diagonally to the icon
        CGFloat finalHeight = height-deltaHeight; // The planned new height for our view
        CGFloat finalWidth = width-deltaWidth; // The planned new width for our view
        CGFloat finalX = x+deltaWidth; // The planned origin on the x-axis for our view
        CGFloat finalY = y+deltaHeight; // The planned origin on the y-axis for our view

        if (finalWidth < _iconFrame.size.width) { // If the planned new width is less than allowed width
            finalWidth = self.superview.frame.size.width; // Reset the new planned width to what it currently is.
            finalX = self.superview.frame.origin.x; // Reset the planned origin on the x-axis to what it currently is
        }
        if (finalHeight < _iconFrame.size.height) { // If the planned new height is less than the allowed height
          finalHeight = self.superview.frame.size.height; // Reset the new planned height to what it currently is
          finalY = self.superview.frame.origin.y; // Reset the planned origin on the y-axis to what it currently is
        }

        if (finalWidth > SCREEN.size.width - (SCREEN.size.width - self.superview.frame.origin.x - self.superview.frame.size.width) -20) { // If the planned new width is beyond the allowed width
          finalWidth = self.superview.frame.size.width; // Reset the new planned width to what it currently is.
          finalX = self.superview.frame.origin.x; // Reset the planned origin on the x-axis to what it currently is
        }

        if (finalHeight > SCREEN.size.height - (SCREEN.size.height - self.superview.frame.origin.y - self.superview.frame.size.height) - 20) { // If the planned new height is greater than the allowed height
          finalHeight = self.superview.frame.size.height; // Reset the new planned height to what it currently is
          finalY = self.superview.frame.origin.y; // Reset the planned origin on the y-axis to what it currently is 
        }

        self.superview.frame = CGRectMake(finalX, finalY, finalWidth, finalHeight); // Set the new frame

      }
      else if (isResizingUR) { // If the top-right corner is opposite diagonally to the icon
        // is already handled
      }
      else if (isResizingLL) { // If the bottom-left corner is opposite diagonally to the icon
        CGFloat finalHeight = height+deltaHeight; // The planned new height for our view
        CGFloat finalWidth = width-deltaWidth; // The planned new width for our view
        CGFloat finalX = x+deltaWidth; // The planned origin on the x-axis for our view

        if (finalWidth < _iconFrame.size.width) { // If the planned new width is less than allowed width
            finalWidth = self.superview.frame.size.width; // Reset the new planned width to what it currently is.
            finalX = self.superview.frame.origin.x; // Reset the planned origin on the x-axis to what it currently is
        }
        if (finalHeight < _iconFrame.size.height) { // If the planned new height is less than the allowed height
          finalHeight = self.superview.frame.size.height; // Reset the new planned height to what it currently is
        }

        if (finalHeight > SCREEN.size.height - self.superview.frame.origin.y - 20) { // If the planned new height is greater than the allowed height
          finalHeight = self.superview.frame.size.height; // Reset the new planned height to what it currently is
        }
        if (finalWidth > SCREEN.size.width - (SCREEN.size.width - self.superview.frame.origin.x - self.superview.frame.size.width) -20) { // If the planned new width is beyond the allowed width
          finalWidth = self.superview.frame.size.width; // Reset the new planned width to what it currently is.
          finalX = self.superview.frame.origin.x; // Reset the planned origin on the x-axis to what it currently is
        }

        self.superview.frame = CGRectMake(finalX, y, finalWidth, finalHeight); // Set the new frame
      }
      self.frame = self.superview.bounds; // make our frame match the frame above us
      previous = touchPoint; // set the previous touch point as our current one
      updateFrame = YES; // tell the -(void)layoutSubviews method to resize the live camera preview layer
    }
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   if (calculatedCorner == NO) { // If we haven't found the opposite corner to the icon yet
    UIView *contentView = self.superview; // the regular 3D Touch Menu
            if (contentView.frame.origin.x < _iconFrame.origin.x && contentView.frame.origin.y < _iconFrame.origin.y) {
              // NSLog(@"Top-Left");
              isResizingUR = NO; // It's not the top-right
              isResizingLR = NO; // It's not the bottom-right
              isResizingLL = NO; // It's not the bottom-left
              isResizingUL = YES; // Looks like the opposite corner is the top-left
              corner = CornerTypeUL;// Sets which corner should be highlighted, in this case the top-left corner
            } else if (contentView.frame.origin.x+contentView.frame.size.width > _iconFrame.origin.x && contentView.frame.origin.y < _iconFrame.origin.y) {
              //NSLog(@"Top-Right");
              isResizingUL = NO; // It's not the top-left
              isResizingLL = NO; // It's not the bottom-left
              isResizingLR = NO; // It's not the bottom-right
              isResizingUR = YES; // Looks like the opposite corner is the top-right
              corner = CornerTypeUR;// Sets which corner should be highlighted, in this case the top-right corner
            } else if (contentView.frame.origin.x < _iconFrame.origin.x && contentView.frame.origin.y > _iconFrame.origin.y) {
              //NSLog(@"Bottom-Left");
              isResizingUL = NO; // It's not the top-left
              isResizingUR = NO; // It's not the top-right
              isResizingLR = NO; // It's not the bottom-right
              isResizingLL = YES; // Looks like the opposite corner is the bottom-left
              corner = CornerTypeLL;// Sets which corner should be highlighted, in this case the bottom-left corner
            } else if (contentView.frame.origin.x+contentView.frame.size.width > _iconFrame.origin.x && contentView.frame.origin.y > _iconFrame.origin.y) {
              //NSLog(@"Bottom-Right");
              isResizingUL = NO; // It's not the top-left
              isResizingUR = NO; // It's not the top-right
              isResizingLL = NO; // It's not the bottom-left
              isResizingLR = YES; // Looks like the opposite corner is the bottom-right
              corner = CornerTypeLR; // Sets which corner should be highlighted, in this case the bottom-right corner
            }
            calculatedCorner = YES; // now we know which corner so we can stop trying to fidn the corner
   }

    touchStart = [[touches anyObject] locationInView:self]; // The point we touched the screen in relation to our view
    previous=[[touches anyObject]previousLocationInView:self]; // The point we touched the screen previously in relation to our view
    if ((self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize) || // If we are touching a corner.
        (touchStart.x <kResizeThumbSize && touchStart.y <kResizeThumbSize) ||
        (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize) ||
        (touchStart.x <kResizeThumbSize && self.bounds.size.height -touchStart.y <kResizeThumbSize)) {
     touchingCorner = YES; //a corner has been touched start resize gesture
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    touchPoint = [[touches anyObject] locationInView:self]; // The current location of the user's finger in realtion to our view
    previous = [[touches anyObject]previousLocationInView:self]; // The previous location of the user's finger in relation to our view

    deltaWidth = touchPoint.x-previous.x; // The differnce on the x-axis between the previous touch and the current touch
    deltaHeight = touchPoint.y-previous.y; // The differnce on the y-axis between the previous touch and the current touch

    x = self.superview.frame.origin.x; // The current x-axis origin of the regular 3D touch menu
    y = self.superview.frame.origin.y; // The current y-axis origin of the regular 3D touch menu
    width = self.superview.frame.size.width; // The current width of the regular 3D touch menu
    height = self.superview.frame.size.height; // The current height of the regular 3D touch menu

    if (isResizingLR) { // If the bottom-right corner is opposite diagonally to the icon
      [self resize];//resize calculations
    }
    if (isResizingUL) { // If the top-left corner is opposite diagonally to the icon
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
    if (isResizingLL) { // If the bottom-left corner is opposite diagonally to the icon
       [self resize];//resize calculations
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
  touchingCorner = NO;//signal corner movement is done
}

- (void)layoutSubviews { // Layout Subviews of our Camera View
  if (cameraCornerView) { // If we already have a highlighted corner
    [cameraCornerView removeFromSuperview];//removes camera view corner movement view
  }
  if (calculatedCorner == YES) { // If we have already calcualted the opposite corner to the icon
    cameraCornerView = [[CornerHighlightView alloc] initWithCorner:corner withTouchSize:kResizeThumbSize withFrame:self.bounds];
    [self addSubview:cameraCornerView];//adds the camera view corner movement view
  }
  if (updateFrame == YES) { // If we are resizing
    [CATransaction begin]; // begin layer resize 
    [CATransaction setDisableActions:YES]; // disable actions
    livePreviewLayer.frame = self.superview.bounds;//updates camera layer size
    [CATransaction commit]; // commit resize
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
      NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];

      UIImage *imgTaken = [[UIImage alloc] initWithData:imageData];
      UIImageWriteToSavedPhotosAlbum(imgTaken, nil, nil, nil);//writes image to photo album
  }];
}
@end
