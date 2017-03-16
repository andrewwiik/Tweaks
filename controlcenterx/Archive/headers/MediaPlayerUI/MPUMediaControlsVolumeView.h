#import <UIKit/UIView.h>
#import <MediaPlayerUI/MPVolumeControllerDelegate-Protocol.h>
#import <MediaPlayerUI/MPVolumeController.h>

@interface MPUMediaControlsVolumeView : UIView <MPVolumeControllerDelegate> {

	UIView* _warningView;
	BOOL _warningIndicatorBlinking;
	NSTimer* _warningBlinkTimer;
	NSTimer* _volumeCommitTimer;
	CGFloat _timeStoppedTracking;
	NSInteger _style;
	UISlider* _slider;
	MPVolumeController* _volumeController;

}

@property (nonatomic,readonly) NSInteger style;                                    //@synthesize style=_style - In the implementation block
@property (nonatomic,readonly) UISlider * slider;                                  //@synthesize slider=_slider - In the implementation block
@property (nonatomic,readonly) MPVolumeController * volumeController;              //@synthesize volumeController=_volumeController - In the implementation block
-(id)initWithFrame:(CGRect)arg1 ;
-(void)layoutSubviews;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(NSInteger)style;
-(id)initWithStyle:(NSInteger)arg1 ;
-(void)_layoutVolumeWarningView;
-(void)_beginBlinkingWarningView;
-(void)_blinkWarningView;
-(void)volumeController:(id)arg1 volumeValueDidChange:(CGFloat)arg2 ;
-(void)volumeController:(id)arg1 volumeWarningStateDidChange:(NSInteger)arg2 ;
-(void)volumeController:(id)arg1 EUVolumeLimitDidChange:(CGFloat)arg2 ;
-(void)volumeController:(id)arg1 EUVolumeLimitEnforcedDidChange:(BOOL)arg2 ;
-(id)_trackImageWithAlternateStyle:(BOOL)arg1 rounded:(BOOL)arg2 ;
-(void)updateSystemVolumeLevel;
-(MPVolumeController *)volumeController;
-(id)_createVolumeSliderView;
-(void)_volumeSliderBeganChanging:(id)arg1 ;
-(void)_volumeSliderValueChanged:(id)arg1 ;
-(void)_volumeSliderStoppedChanging:(id)arg1 ;
-(void)_configureVolumeSliderView:(id)arg1 ;
-(void)_stopBlinkingWarningView;
-(void)_stopVolumeCommitTimer;
-(BOOL)_shouldStartBlinkingVolumeWarningIndicator;
-(void)_beginVolumeCommitTimer;
-(BOOL)_volumeSliderDynamicsEnabled;
-(void)_removeVolumeSliderInertia;
-(void)_commitCurrentVolumeValue;
-(id)_warningTrackImage;
-(UISlider *)slider;
@end
