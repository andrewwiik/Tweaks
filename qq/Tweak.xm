#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "LEColorPicker.h"
@interface MusicRemoteController : NSObject
@end
@interface MusicNowPlayingTitlesView : UIView
-(void)slideFromRight;
-(void)slideFromLeft;
-(void)slideOutToLeft;
@end

@interface MusicArtworkView : UIImageView
@end
@interface MusicNowPlayingItemViewController : UIViewController
@property (nonatomic, retain) UIImageView *artworkImage;
@property (nonatomic, retain) UIImage *image;
- (MusicArtworkView *) _imageView;
- (UIImage *) _artworkImage;
- (id)artworkImage;
@end
@interface MusicNowPlayingViewController : UIViewController
@property (nonatomic, readonly) MusicNowPlayingItemViewController *currentItemViewController;
- (id)currentItemViewController;
@end

MusicNowPlayingViewController* artworknoblur;
MusicNowPlayingItemViewController* nowplayingitem;
static id SharedTitlesView;


%hook MusicUpNextViewController
- (void)setHidesNowPlaying:(BOOL)arg1 {
    %orig(TRUE);
}
-(BOOL)hidesNowPlaying {
    return TRUE;
}
%end
%hook MusicNowPlayingTitlesView
- (id)initWithFrame:(CGRect)arg1 {
    SharedTitlesView = %orig;
    return  SharedTitlesView;
}
%new
-(void)slideFromRight {
CGRect frame = self.frame;
    self.frame = CGRectMake(self.frame.size.width ,self.frame.origin.y, 2, 2);

     [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ self.frame = frame; } completion:^(BOOL finished){}];

}
%new
-(void)slideFromLeft {
CGRect frame = self.frame;
self.frame = CGRectMake(self.frame.size.width * -1 ,self.frame.origin.y, self.frame.size.width, self.frame.size.height);

     [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ self.frame = frame; } completion:^(BOOL finished){}];  
}
%new
-(void)slideOutToLeft {
    NSLog(@"Scroll Left");
     [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ self.frame = CGRectMake(self.frame.size.width * -1 ,self.frame.origin.y, self.frame.size.width, self.frame.size.height); } completion:^(BOOL finished){}];  
}
%end
%hook MusicNowPlayingItemViewController
- (id)initWithItem:(id)arg1 {
    nowplayingitem = %orig;
    return nowplayingitem;
}

- (void)viewDidLayoutSubviews {
%orig;
UIVisualEffect *blurEffect;
blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

UIVisualEffectView *visualEffectView;
visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

visualEffectView.frame = self.view.bounds;

UIView *removeView;
while((removeView = [self.view viewWithTag:11]) != nil) {
    [removeView removeFromSuperview];

}
self.view.tag = 7;
UIImageView *imgView = [[UIImageView alloc] initWithImage:[self artworkImage]];
UIImageView *imgBlur = [[UIImageView alloc] initWithImage:[self artworkImage]];
UIImage *img = [self artworkImage];
LEColorPicker *colorPicker = [[LEColorPicker alloc] init];
LEColorScheme *colorScheme = [colorPicker colorSchemeFromImage:img];
self.view.backgroundColor = colorScheme.backgroundColor;
imgBlur.frame = self.view.frame;
imgBlur.tag = 11;
imgView.tag = 11;
imgView.frame = CGRectMake(self.view.frame.size.height /2,self.view.frame.size.height /2,2,2);
[self.view addSubview:imgBlur];
[imgBlur addSubview:visualEffectView];
[visualEffectView addSubview:imgView];
[SharedTitlesView slideFromRight];
[UIView animateWithDuration:.5
                     animations:^{
                         imgView.frame = CGRectMake(self.view.frame.size.height /6,self.view.frame.size.height /6,self.view.frame.size.height /1.5,self.view.frame.size.height/1.5);
                     }];
                     return %orig;
imgView.layer.masksToBounds = YES;
imgView.layer.borderWidth = 0;
NSLog(@"I did it again");
}


%end

%hook MusicNowPlayingViewController
- (id)initWithPlayer:(id)arg1 {
    artworknoblur = %orig;
    return  artworknoblur;
}
%end

%hook MusicRemoteController
- (int)_handleSkipForwardCommand:(id)arg1 {
    [SharedTitlesView slideOutToLeft];
    return %orig;
}
%end
