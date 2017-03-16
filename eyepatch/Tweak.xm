#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@class SEStatusWindow;
@interface SEStatusWindow : UIWindow
@end
SEStatusWindow *window;

@class GPUImageFilter;
@interface GPUImageFilter : NSObject
- (void)addTarget:(id)arg1;
- (CGImageRef)newCGImageFromCurrentlyProcessedOutput;
- (void)useNextFrameForImageCapture;
@end

@class GPUImageTransformFilter;
@interface GPUImageTransformFilter : GPUImageFilter
@property(readwrite, nonatomic) CATransform3D transform3D;
@end
@class GPUImageAlphaBlendFilter;
@interface GPUImageAlphaBlendFilter : GPUImageFilter
@property(readwrite, nonatomic) CGFloat mix;
@end

@class SESketchFilter;
@interface SESketchFilter : GPUImageFilter
// @property(readwrite, nonatomic) CGFloat mix;
@end

UIImage *lastFrame;

@class CameraSource;
@interface CameraSource : NSObject
@end
CameraSource *camera1;

// @interface UIImage (BlurStuff)
// + (UIImage *)blurredImageWithImage:(UIImage *)sourceImage;
// @end
// @implementation UIImage (BlurStuff)
// + (UIImage *)blurredImageWithImage:(UIImage *)sourceImage {

//     //  Create our blurred image
//     CIContext *context = [CIContext contextWithOptions:nil];
//     CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];

//     //  Setting up Gaussian Blur
//     CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//     [filter setValue:inputImage forKey:kCIInputImageKey];
//     [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
//     CIImage *result = [filter valueForKey:kCIOutputImageKey];

//     /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches 
//      *  up exactly to the bounds of our original image */
//     CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];

//     UIImage *retVal = [UIImage imageWithCGImage:cgImage];
//     return retVal;
// }
// @end

// @implementation UIView (RemoveConstraints)

// - (void)removeAllConstraints
// {
//     UIView *superview = self.superview;
//     while (superview != nil) {
//         for (NSLayoutConstraint *c in superview.constraints) {
//             if (c.firstItem == self || c.secondItem == self) {
//                 [superview removeConstraint:c];
//             }
//         }
//         superview = superview.superview;
//     }

//     [self removeConstraints:self.constraints];
//     self.translatesAutoresizingMaskIntoConstraints = YES;
// }

// @end

@interface SEContextMenuControl : UIControl
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *image;
- (void)didTapButton:(id)arg1;
- (void)setEnabled:(BOOL)arg1;
@end

static BOOL muted = NO;
static BOOL muteVideo = NO;
// - (void)addTarget:(id)target
//            action:(SEL)action
//  forControlEvents:(UIControlEvents)controlEvents


@interface SEBroadcastContextMenuController : UIViewController
@property (nonatomic, retain) UIView *itemContainerView;
@property (nonatomic, retain) SEContextMenuControl *cameraFlipControl;
@property (nonatomic, retain) SEContextMenuControl *sketchControl;
@property (nonatomic, retain) SEContextMenuControl *chatControl;
@property (nonatomic, retain) SEContextMenuControl *muteAudioControl;
@property (nonatomic, retain) SEContextMenuControl *muteVideoControl;
@property (nonatomic, retain) SEContextMenuControl *filterControl;
- (void)didPressMuteAudioControl:(SEContextMenuControl *)control;
- (void)didPressMuteVideoControl:(SEContextMenuControl *)control;
- (void)didPressFilterControl:(SEContextMenuControl *)control;
- (void)didTapCloseButton:(id)arg1;
@end

@class GPUImageGrayscaleFilter;
@interface GPUImageGrayscaleFilter : GPUImageFilter
@end

GPUImageFilter *filter;

%hook SEBroadcastContextMenuController
%property (nonatomic, retain) SEContextMenuControl *muteAudioControl;
%property (nonatomic, retain) SEContextMenuControl *muteVideoControl;
%property (nonatomic, retain) SEContextMenuControl *filterControl;

- (void)loadView {
	//[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
	%orig;
}
- (void)viewDidLoad {


	
	// [self.cameraFlipControl removeFromSuperview];
	// [self.itemContainerView addSubview:self.cameraFlipControl];
	// self.cameraFlipControl = nil;
	// self.cameraFlipControl.translatesAutoresizingMaskIntoConstraints = NO;
	// self.cameraFlipControl.frame = CGRectMake(0,self.cameraFlipControl.frame.origin.y,self.cameraFlipControl.frame.size.width,self.cameraFlipControl.frame.size.height);
	


	// NSLayoutConstraint *centeringConstraint = [NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeCenterX multiplier:0.5 constant:0];
	// centeringConstraint.priority = 1000;
	// [self.itemContainerView addConstraint:centeringConstraint];
	//[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
	%orig;
	//[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
	// [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
	// [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	// [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
	
	// [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chatControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	// [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chatControl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
	// [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chatControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
	//[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];



	//CGRect newFrame = CGRectMake(self.cameraFlipControl.frame.size.width+1,self.cameraFlipControl.frame.origin.y,self.cameraFlipControl.frame.size.width,self.cameraFlipControl.frame.size.height);
	
	/* Initilize New Control Buttons */

	self.muteAudioControl = [[%c(SEContextMenuControl) alloc] initWithFrame:CGRectMake(0,0,0,0)];
	self.muteVideoControl = [[%c(SEContextMenuControl) alloc] initWithFrame:CGRectMake(0,0,0,0)];
	self.filterControl = [[%c(SEContextMenuControl) alloc] initWithFrame:CGRectMake(0,0,0,0)];

	/* Set targets for new control buttons */
	[self.muteAudioControl addTarget:self action:@selector(didPressMuteAudioControl:) forControlEvents:UIControlEventTouchUpInside];
	[self.muteVideoControl addTarget:self action:@selector(didPressMuteVideoControl:) forControlEvents:UIControlEventTouchUpInside];
	[self.filterControl addTarget:self action:@selector(didPressFilterControl:) forControlEvents:UIControlEventTouchUpInside];

	/* Add new control buttons to view Heichaary */

	[self.itemContainerView addSubview:self.muteAudioControl];
	[self.itemContainerView addSubview:self.muteVideoControl];
	[self.itemContainerView addSubview:self.filterControl];

	/* Set up Auto Constraints for new buttons */

	self.muteAudioControl.translatesAutoresizingMaskIntoConstraints = NO;
	self.muteVideoControl.translatesAutoresizingMaskIntoConstraints = NO;
	self.filterControl.translatesAutoresizingMaskIntoConstraints = NO;

	/* Set up filter control contraints */

	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.filterControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.filterControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.filterControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.chatControl attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.filterControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];

	/* Set up Mute Audio Control Contraints */

	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.muteAudioControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.muteAudioControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.muteAudioControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.muteAudioControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
	//[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.muteAudioControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	/* Set up Mute Video Control Constraints */

	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.muteVideoControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.muteVideoControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.muteVideoControl attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.filterControl attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.muteVideoControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];

	//[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.muteAudioControl attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
	/* set control Titles */
	if (muted == NO)
	self.muteAudioControl.title = [NSString stringWithFormat:@"Mute Mic"];
	else self.muteAudioControl.title = [NSString stringWithFormat:@"Unmute Mic"];

	if (muteVideo == NO)
	self.muteVideoControl.title = [NSString stringWithFormat:@"Mute Video"];
	else self.muteVideoControl.title = [NSString stringWithFormat:@"Unmute Video"];

	// self.muteVideoControl.title = [NSString stringWithFormat:@"Mute Video"];
	self.filterControl.title = [NSString stringWithFormat:@"Change Filter"];
	//[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.muteAudioControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	/* set Control Icons */
	if (muted == NO)
	self.muteAudioControl.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/Application Support/EyePatch/mute_audio"]];
	else {
		self.muteAudioControl.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/Application Support/EyePatch/mute_audio_alt"]];
	}

	if (muteVideo == NO)
	self.muteVideoControl.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/Application Support/EyePatch/mute_video"]];
	else {
		self.muteVideoControl.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/Application Support/EyePatch/mute_video_alt"]];
	}

	/* Divider Setup */
	UIColor *dividerColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.2];

	UIView *verticalDivider = [[UIView alloc] initWithFrame:CGRectZero];
	verticalDivider.backgroundColor = dividerColor;
	verticalDivider.userInteractionEnabled = NO;
	verticalDivider.translatesAutoresizingMaskIntoConstraints = NO;
	[self.itemContainerView addSubview:verticalDivider];

	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:verticalDivider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:verticalDivider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:verticalDivider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:verticalDivider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1]];

	UIView *horizontalDivider1 = [[UIView alloc] initWithFrame:CGRectZero];
	horizontalDivider1.backgroundColor = dividerColor;
	horizontalDivider1.userInteractionEnabled = NO;
	horizontalDivider1.translatesAutoresizingMaskIntoConstraints = NO;
	[self.itemContainerView addSubview:horizontalDivider1];

	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:horizontalDivider1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.chatControl attribute:NSLayoutAttributeBottom multiplier:1 constant:-0.5]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:horizontalDivider1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:horizontalDivider1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:horizontalDivider1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1]];

	UIView *horizontalDivider2 = [[UIView alloc] initWithFrame:CGRectZero];
	horizontalDivider2.backgroundColor = dividerColor;
	horizontalDivider2.userInteractionEnabled = NO;
	horizontalDivider2.translatesAutoresizingMaskIntoConstraints = NO;
	[self.itemContainerView addSubview:horizontalDivider2];

	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:horizontalDivider2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.filterControl attribute:NSLayoutAttributeBottom multiplier:1 constant:-0.5]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:horizontalDivider2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:horizontalDivider2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:horizontalDivider2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1]];
	//self.itemContainerView.translatesAutoresizingMaskIntoConstraints = NO;
	//self.itemContainerView.frame = CGRectMake(self.itemContainerView.frame.origin.x,self.itemContainerView.frame.origin.y - self.sketchControl.frame.size.height,self.itemContainerView.frame.size.width,self.itemContainerView.frame.size.height);
	// [self.view addConstraint:[NSLayoutConstraint constraintWitUIView *horizontalDivider1 = [[UIView alloc] initWithFrame:CGRectZero];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.itemContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.sketchControl attribute:NSLayoutAttributeHeight multiplier:3 constant:0]];
	// muteButton.title = [NSString stringWithFormat:@"Mute"];
	// if (muted) {
	// 	muteButton.title = [NSString stringWithFormat:@"Unmute"];
	// }

}
- (void)viewWillAppear:(BOOL)arg1 {
	%orig;
	self.cameraFlipControl.frame = CGRectMake(0,self.cameraFlipControl.frame.origin.y,self.cameraFlipControl.frame.size.width,self.cameraFlipControl.frame.size.height);
}
// - (void)viewDidAppear:(BOOL)arg1 {
// 	%orig;
// 	self.cameraFlipControl.frame = CGRectMake(0,self.cameraFlipControl.frame.origin.y,self.cameraFlipControl.frame.size.width,self.cameraFlipControl.frame.size.height);
// }
// - (void)reloadItems {
// 	%orig;
// 	self.cameraFlipControl.frame = CGRectMake(0,self.cameraFlipControl.frame.origin.y,self.cameraFlipControl.frame.size.width,self.cameraFlipControl.frame.size.height);
// }
// - (void)animateTransition:(id)arg1 {
// 	%orig;
// 	self.cameraFlipControl.frame = CGRectMake(0,self.cameraFlipControl.frame.origin.y,self.cameraFlipControl.frame.size.width,self.cameraFlipControl.frame.size.height);
// }
// - (void)updateChatText {
// 	%orig;
// 	self.cameraFlipControl.frame = CGRectMake(0,self.cameraFlipControl.frame.origin.y,self.cameraFlipControl.frame.size.width,self.cameraFlipControl.frame.size.height);
// }
- (void)awakeFromNib {
	// [self.view removeAllConstraints];
	// [self.itemContainerView removeAllConstraints];
	//self.cameraFlipControl.translatesAutoresizingMaskIntoConstraints = YES;
	//[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeCenterX multiplier:0.5 constant:0]];
	//self.cameraFlipControl.frame = CGRectMake(0,self.cameraFlipControl.frame.origin.y,self.cameraFlipControl.frame.size.width,self.cameraFlipControl.frame.size.height);
	//[[[self.itemContainerView constraints] objectAtIndex:9] setConstant:(CGFloat)-62.5];
	%orig;
	//self.cameraFlipControl.translatesAutoresizingMaskIntoConstraints = YES;
	//self.cameraFlipControl.frame = CGRectMake(0,self.cameraFlipControl.frame.origin.y,self.cameraFlipControl.frame.size.width,self.cameraFlipControl.frame.size.height);
	//[[[self.itemContainerView constraints] objectAtIndex:9] setConstant:(CGFloat)-62.5];

	for (NSLayoutConstraint *c in self.itemContainerView.constraints) {
        if (c.firstItem == self.cameraFlipControl && c.firstAttribute == 9 && c.secondAttribute == 9) {
            c.constant = -62.5;
        }
        else if (c.secondItem == self.cameraFlipControl && c.firstAttribute == 4 && c.secondAttribute == 4) {
            c.constant = +100;
        }
    }

    NSMutableArray *removeArray = [NSMutableArray new];
    for (UIView *v in [self.itemContainerView subviews]) {
    	if (v.frame.size.width == 1 || v.frame.size.height == 1) {
    		[removeArray addObject:v];
    	}
    }

    for (UIView *t in removeArray) {
    	[t removeFromSuperview];
    }



   // [self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeHeight multiplier:(1/3) constant:0]];
	//[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	//[self.itemContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraFlipControl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.itemContainerView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0]];
	
	// [self.itemContainerView addConstraint:[NSLayoutConstraint contr]]
	// [self.view removeAllConstraints];
	// [self.itemContainerView removeAllConstraints];
	//self.cameraFlipControl.frame = CGRectMake(0,self.cameraFlipControl.frame.origin.y,self.cameraFlipControl.frame.size.width,self.cameraFlipControl.frame.size.height);
}

%new
- (void)didPressMuteAudioControl:(SEContextMenuControl *)control {
	if (muted) muted = NO;
	else muted = YES;
	[self didTapCloseButton:nil];

}

%new
- (void)didPressMuteVideoControl:(SEContextMenuControl *)control {
	if (muteVideo) muteVideo = NO;
	else {
		[filter useNextFrameForImageCapture];
		if (window)
		[window displayPauseImage];
		muteVideo = YES;
	}	

	[self didTapCloseButton:nil];
}

%new
- (void)didPressFilterControl:(SEContextMenuControl *)control {

}

- (void)muteToggle {
	if (muted) {
		
	muted = NO;
	}
	else {
		muted = YES;
		
	}
}
%end


@interface AACEncoder : NSObject
- (void)setMuteAudio:(BOOL)arg1;
@end
%hook AACEncoder
- (void)performEncode {
	[self setMuteAudio:muted];
	%orig;
}
%new
- (BOOL)amIMuted {
	return muted;
}
%end

// %hook VTEncoder
// - (void)encodeFrame:(id)arg1 {
// 	[self setBlank:muteVideo];
// 	%orig;
// }

// - (void)setLastPTS:(CGFloat)arg1 {
// 	[self setBlank:muteVideo];
// 	%orig;
// }
// %end

@class GPUImageOutput;
@interface GPUImageOutput : NSObject
@end
@class GPUImageView;
@interface GPUImageView : UIView
@end
static BOOL messWith = YES;
%hook SESketchFilter
- (void)addTarget:(id)arg1 {
	if (messWith) {
		if (window) {
			// filter = self;
		GPUImageFilter *filter1 = [[%c(GPUImageFilter) alloc] init];
  //           CATransform3D perspectiveTransform = CATransform3DIdentity;
  //           perspectiveTransform.m34 = 0.4;
  //           perspectiveTransform.m33 = 0.4;
  //           perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
  //           perspectiveTransform = CATransform3DRotate(perspectiveTransform, 0.75, 0.0, 1.0, 0.0);
		// [(GPUImageTransformFilter *)filter setTransform3D:perspectiveTransform];
		GPUImageAlphaBlendFilter *blendFilter = [[%c(GPUImageAlphaBlendFilter) alloc] init];
            blendFilter.mix = 1.0;
            
            NSDate *startTime = [NSDate date];
            
            // UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0f, 320.0f)];
            // timeLabel.font = [UIFont systemFontOfSize:17.0f];
            // timeLabel.text = @"Time: 0.0 s";
            // timeLabel.textAlignment = UITextAlignmentCenter;
            // timeLabel.backgroundColor = [UIColor clearColor];
            // timeLabel.textColor = [UIColor whiteColor];

            GPUImageUIElement *uiElementInput = [[%c(GPUImageUIElement) alloc] initWithView:window];
            // [uiElementInput forceProcessingAtSize:CGSizeMake(100, 100)];
            
            [filter1 addTarget:blendFilter];
            [uiElementInput addTarget:blendFilter];
            
            [blendFilter addTarget:arg1];
            // GPUImageView *filteredVideoView = [[%c(GPUImageView) alloc] initWithFrame:CGRectMake(0.0, 0.0, 375, 667)];
            // [filter addTarget:filteredVideoView];
            // if (window) {
            // 	[window addSubview:filteredVideoView];
            // }
            // filter = blendFilter;

            __unsafe_unretained GPUImageUIElement *weakUIElementInput = uiElementInput;
            
            [filter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime frameTime){
                // timeLabel.text = [NSString stringWithFormat:@"Time: %f s", -[startTime timeIntervalSinceNow]];
                [weakUIElementInput update];
            }];

		// [filter addTarget:arg1];
		filter = filter1;
		%orig(filter1);
	}
	}
	else {
		%orig;
	}
}
%end

UIImageView *imageView2;
%hook SEStatusWindow
- (void)layoutSubviews {
	%orig;
	[self setupFakeWindow];

	
}
%new
- (void)setupFakeWindow {
	if (!window) {
UIWindow *window2 = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
window2.backgroundColor = [UIColor redColor];
// window2.windowLevel = UIWindowLevelAlert;
window = window2;
window.opaque = NO;
window.userInteractionEnabled = NO;
window.backgroundColor = [UIColor clearColor];
[window makeKeyAndVisible];
window.opaque = NO;
window.userInteractionEnabled = NO; 
[self makeKeyAndVisible];
// UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
// [window addSubview:imageView];
// imageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/Application Support/EyePatch/sierra.jpg"]];
// imageView.layer.cornerRadius = 50;
// imageView.clipsToBounds = YES;

// UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(125,0,100,100)];
// [window addSubview:imageView2];
// imageView2.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/Application Support/EyePatch/sierra2.jpg"]];
// imageView2.layer.cornerRadius = 50;
// imageView2.clipsToBounds = YES;
}
}

%new
- (id)helpImage {
	 return [[UIImage alloc] initWithCGImage:[filter newCGImageFromCurrentlyProcessedOutput]];
}
%end
%hook UIWindow
%new
- (void)displayPauseImage {
	UIImage *rawPauseImage = [[UIImage alloc] initWithCGImage:[filter newCGImageFromCurrentlyProcessedOutput]];
	UIImage *blurredImage = [UIImage blurredImageWithImage:rawPauseImage];
	imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,390,690)];
	[window addSubview:imageView2];
	imageView2.image = blurredImage;
	imageView2.alpha = 0.5;
	GPUImageView *filteredVideoView = [[%c(GPUImageView) alloc] initWithFrame:CGRectMake(0.0, 0.0, 375, 667)];
	[filter addTarget:[camera1 valueForKey:@"_view"]];
	// window.windowLevel = UIWindowLevel



}
%end

%hook CameraSource
- (void)setDelegate:(id)arg1 {
	camera1=self;
	%orig;
}
%end


%hook SEUserChannelViewController
- (void)sendHeart {
	%orig;
	%orig;
	%orig;
	%orig;
	%orig;
	%orig;
	%orig;
	%orig;
	%orig;
	%orig;
	%orig;
	%orig;
	%orig;
	%orig;
	%orig;
	
}
%end


%hook PChannel
+ (void)HandleHeartRateLimit:(id)arg1 CountDuringRateLimit:(int)arg2 ExecuteIfNoRateLimit:(id)arg3 ExecuteDuringRateLimit:(id)arg4 ExecuteIfBeginningRateLimit:(id)arg5 ReceivingHearts:(BOOL)arg6 {
	%orig(arg1,arg2,arg3,arg3,arg3,arg6);
}
%end


%hook CMClient
- (void)_queueMessage:(id)arg1 {
	NSLog(@"Message: %@",arg1);
	%orig;
	%orig;
	%orig;
	%orig;
	%orig;
}
%end

%hook SEMessage
 - (id)initChatMessageWithDisplayName:(id)arg1 username:(id)arg2 remoteID:(id)arg3 participant_index:(int)arg4 ntpForCurrentFrame:(uint64_t)arg5 ntpForBroadcasterFrame:(uint64_t)arg6 body:(id)arg7 profileImageURL:(id)arg8 {
 	return %orig([NSString stringWithFormat:@"OOPS"],[NSString stringWithFormat:@"ShitFace"],arg3,2,arg5,arg6,arg7,arg8);
 
 }
 
 %end
 
 %hook CMWireMessage
 - (NSString *)payload {
	return [[%orig stringByReplacingOccurrencesOfString:@"andywiik" withString:@"shitface"] stringByReplacingOccurrencesOfString:@"Andywiik" withString:@"shitface"];
 }
 - (id)initWithKind:(uint64_t)arg1 payload:(NSString *)arg2 originalJson:(id)arg3 {
 return %orig(arg1,[[arg2 stringByReplacingOccurrencesOfString:@"andywiik" withString:@"shitface"] stringByReplacingOccurrencesOfString:@"Andywiik" withString:@"shitface"],arg3);
 }
 %end
// Can you hea me

%hook CMSender
- (NSString *)username {
return [NSString stringWithFormat:@"shitface"];
}
%end


// Are the colors inverted? Chat the answer What color am i sketching


// Muted since I'm in class. See mute is useful

// at color am i sketching
// Celluar

// Wh
