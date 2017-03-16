//
//  CameraContentView.m
//  Camera
//
//  Created by Matt Clarke on 20/04/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "CameraContentView.h"
#import "CameraWidgetOverlayView.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface IBKAPI : NSObject;
+(CGFloat)heightForContentView;
@end

@implementation CameraContentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Custom initialisation
        NSMutableArray *files = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/Wallpaper/iPhone" error:nil] mutableCopy];
        for (NSString *path in [files copy]) {
            if ([path rangeOfString:@"thumbnail"].location == NSNotFound) {
                [files removeObject:path];
            }
        }
        
        NSLog(@"FILENAMES: %@", files);
        
        self.filenames = files;
        
        self.currentImage = 0;
        
        self.backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/Wallpaper/iPhone/%@", self.filenames[self.currentImage]]]];
        self.backgroundImage.frame = frame;
        self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:self.backgroundImage];
        
        self.transitionImage = [[UIImageView alloc] initWithFrame:frame];
        self.transitionImage.contentMode = UIViewContentModeScaleAspectFill;
        self.transitionImage.alpha = 0.0;
        self.transitionImage.hidden = YES;
        
        [self addSubview:self.transitionImage];
        
        self.blur = [[CKBlurView alloc] initWithFrame:frame];
        self.blur.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
        self.blur.blurCroppingRect = self.blur.bounds;
        self.blur.blurEdges = NO;
        self.blur.blurRadius = 2.5;
        
        [self addSubview:self.blur];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerCallback:) userInfo:nil repeats:YES];
        
        self.scroll = [[UIScrollView alloc] initWithFrame:frame];
        self.scroll.contentOffset = CGPointZero;
        //self.scroll.contentSize = CGSizeMake(frame.size.width*2, frame.size.height);
        self.scroll.backgroundColor = [UIColor clearColor];
        self.scroll.showsHorizontalScrollIndicator = NO;
        self.scroll.showsVerticalScrollIndicator = NO;
        self.scroll.alwaysBounceHorizontal = YES;
        self.scroll.canCancelContentTouches = YES;
        self.scroll.delaysContentTouches = YES;
        
        [self addSubview:self.scroll];
        
        self.cameraButton = [CameraWidgetButton buttonWithType:UIButtonTypeCustom];
        self.cameraButton.frame = CGRectMake(0, 0, 75, 75);
        self.cameraButton.backgroundColor = [UIColor clearColor];
        self.cameraButton.alpha = 0.75;
        [self.cameraButton setupForIsVideo:NO];
        self.cameraButton.center = CGPointMake(frame.size.width/2, [objc_getClass("IBKAPI") heightForContentView]/2);
        [self.cameraButton addTarget:self action:@selector(heldDownCameraButton:) forControlEvents:UIControlEventTouchDown];
        [self.cameraButton addTarget:self action:@selector(releasedCameraArea:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scroll addSubview:self.cameraButton];
        
        self.videoButton = [CameraWidgetButton buttonWithType:UIButtonTypeCustom];
        self.videoButton.frame = CGRectMake(0, 0, 75, 75);
        self.videoButton.backgroundColor = [UIColor clearColor];
        self.videoButton.alpha = 0.75;
        [self.videoButton setupForIsVideo:YES];
        self.videoButton.center = CGPointMake(frame.size.width/2 + frame.size.width, [objc_getClass("IBKAPI") heightForContentView]/2);
        [self.videoButton addTarget:self action:@selector(heldDownCameraButton:) forControlEvents:UIControlEventTouchDown];
        [self.videoButton addTarget:self action:@selector(releasedCameraArea:) forControlEvents:UIControlEventTouchUpInside];
        [self.videoButton addTarget:self action:@selector(releasedCameraArea:) forControlEvents:UIControlEventTouchUpOutside];
        
        [self.scroll addSubview:self.videoButton];
    }
    
    return self;
}

-(void)heldDownCameraButton:(CameraWidgetButton*)sender {
    // Show camera UI.
    if (self.cameraOpen) {
        [self.picker takePicture];
        return;
    }
    
    [sender setSelected:YES];
    
    // Get frame for our current icon.
    UIView *iconview = self.superview;
    while (![[iconview class] isEqual:[objc_getClass("IBKIconView") class]]) {
        iconview = iconview.superview;
    }
    
    self.pickerSuperview = [[UIView alloc] initWithFrame:CGRectMake(iconview.frame.origin.x, iconview.frame.origin.y + 20, self.bounds.size.width, self.bounds.size.height)];
    self.pickerSuperview.layer.cornerRadius = 12.5;
    self.pickerSuperview.backgroundColor = [UIColor clearColor];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.pickerSuperview];
    
    self.picker = [[UIImagePickerController alloc] init];
    //self.picker.cameraCaptureMode = (sender.isVideo ? UIImagePickerControllerCameraCaptureModeVideo : UIImagePickerControllerCameraCaptureModePhoto);
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = NO;
    self.picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    UIView *overlay = [[CameraWidgetOverlayView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    overlay.backgroundColor = [UIColor clearColor];
    self.picker.cameraOverlayView = overlay;
    
    self.pickerWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.pickerWindow.backgroundColor = [UIColor clearColor];
    self.pickerWindow.windowLevel = UIWindowLevelStatusBar - 1;
    [self.pickerWindow makeKeyAndVisible];
    
    self.pickerWindow.rootViewController = [[UIViewController alloc] init];
    
    sender.center = CGPointMake(self.bounds.size.width/2, [objc_getClass("IBKAPI") heightForContentView]/2);
    
    [self.pickerSuperview addSubview:sender];
    [sender setSelected:NO];
        
    [UIView animateWithDuration:0.35 animations:^{
        self.pickerSuperview.frame = [[UIScreen mainScreen] bounds];
        sender.center = CGPointMake(self.pickerSuperview.frame.size.width/2, self.pickerSuperview.frame.size.height - (sender.frame.size.height/2) - 5);
        self.pickerSuperview.backgroundColor = [UIColor blackColor];
        self.pickerSuperview.layer.cornerRadius = 0;
    } completion:^(BOOL finished){
        [self.pickerWindow.rootViewController presentViewController:self.picker animated:NO completion:^{
            [overlay addSubview:sender];
        }];
    }];
    
    self.cameraOpen = YES;
}

-(void)releasedCameraArea:(CameraWidgetButton*)sender {
    // Take photo/begin recording
    if (self.cameraOpen) {
        // Close?
        self.cameraOpen = NO;
        
        [self.pickerWindow.rootViewController dismissViewControllerAnimated:NO completion:^{
            [self.pickerSuperview addSubview:sender];
            
            UIView *iconview = self.superview;
            while (![[iconview class] isEqual:[objc_getClass("IBKIconView") class]]) {
                iconview = iconview.superview;
            }
            
            [UIView animateWithDuration:0.35 animations:^{
                self.pickerSuperview.frame = CGRectMake(iconview.frame.origin.x, iconview.frame.origin.y + 20, self.bounds.size.width, self.bounds.size.height);
                sender.center = CGPointMake(self.bounds.size.width/2, [objc_getClass("IBKAPI") heightForContentView]/2);
                self.pickerSuperview.backgroundColor = [UIColor clearColor];
                self.pickerSuperview.layer.cornerRadius = 12.5;
            } completion:^(BOOL finished){
                sender.center = CGPointMake(self.bounds.size.width/2 + (sender.isVideo ? self.bounds.size.width : 0), [objc_getClass("IBKAPI") heightForContentView]/2);
                [self.scroll addSubview:sender];
                [self.pickerSuperview removeFromSuperview];
                
                [self.pickerWindow setHidden:YES];
                self.pickerWindow = nil;
                
                self.picker = nil;
            }];
        }];
        
        
        return;
    }
    
    [sender setSelected:NO];
}

-(void)timerCallback:(id)sender {
    self.currentImage++;
    
    if ([self.filenames count]-1 < self.currentImage)
        self.currentImage = 0;
    
    self.transitionImage.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/Wallpaper/iPhone/%@", self.filenames[self.currentImage]]];
    self.transitionImage.alpha = 0.0;
    self.transitionImage.hidden = NO;
    
    [UIView animateWithDuration:0.6 animations:^{
        self.transitionImage.alpha = 1.0;
    } completion:^(BOOL finished){
        if (finished) {
            self.backgroundImage.image = self.transitionImage.image;
            self.transitionImage.hidden = YES;
            self.transitionImage.alpha = 0.0;
            self.transitionImage.image = nil;
        }
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.scroll.frame = self.bounds;
    self.backgroundImage.frame = self.bounds;
    self.transitionImage.frame = self.bounds;
    self.blur.frame = CGRectMake(0, 0, self.bounds.size.width + 20, self.bounds.size.height + 20);
    self.blur.blurCroppingRect = self.blur.bounds;
    
    if (isPad) {
        self.cameraButton.center = CGPointMake(self.bounds.size.width/4, [objc_getClass("IBKAPI") heightForContentView]/2);
        self.videoButton.center = CGPointMake(self.bounds.size.width/4, [objc_getClass("IBKAPI") heightForContentView]/2);
    } else {
        self.scroll.contentSize = CGSizeMake(self.bounds.size.width*2, self.bounds.size.height);
        //self.scroll.contentOffset = CGPointMake((self.scroll.contentOffset.x > 0 ? self.bounds.size.width : 0), 0);
        self.cameraButton.center = CGPointMake(self.bounds.size.width/2, [objc_getClass("IBKAPI") heightForContentView]/2);
        self.videoButton.center = CGPointMake(self.bounds.size.width/2 + self.bounds.size.width, [objc_getClass("IBKAPI") heightForContentView]/2);
    }
    
}

-(void)dealloc {
    [timer invalidate];
    timer = nil;
    
    [self.backgroundImage removeFromSuperview];
    self.backgroundImage = nil;
    
    [self.transitionImage removeFromSuperview];
    self.transitionImage = nil;
    
    [self.cameraButton removeFromSuperview];
    self.cameraButton = nil;
    
    [self.videoButton removeFromSuperview];
    self.videoButton = nil;
    
    [self.scroll removeFromSuperview];
    self.scroll = nil;
    
    self.filenames = nil;
}

@end