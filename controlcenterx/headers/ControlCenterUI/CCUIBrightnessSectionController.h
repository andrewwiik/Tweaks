#import <ControlCenterUIKit/CCUIControlCenterSlider.h>
#import "CCUIControlCenterSectionViewController.h"
#import "CCUIBrightnessContentView.h"

@interface CCUIBrightnessSectionController : CCUIControlCenterSectionViewController {

	CCUIControlCenterSlider* _slider;
	BOOL _usesCompactHeight;

}
@property (assign,nonatomic) BOOL usesCompactHeight;              //@synthesize usesCompactHeight=_usesCompactHeight - In the implementation block
@property (nonatomic, retain) CCUIBrightnessContentView *view;
+(Class)viewClass;
-(BOOL)enabled;
-(void)_setBacklightLevel:(CGFloat)arg1 ;
-(float)_backlightLevel;
-(void)viewWillAppear:(BOOL)arg1 ;
-(void)viewDidDisappear:(BOOL)arg1 ;
-(void)viewDidLayoutSubviews;
-(void)viewDidLoad;
-(void)_sliderValueDidChange:(id)arg1 ;
-(id)sectionIdentifier;
-(void)setUsesCompactHeight:(BOOL)arg1 ;
-(BOOL)usesCompactHeight;
-(id)_brightnessContentView;
-(void)_sliderDidBeginTracking:(id)arg1 ;
-(void)_sliderDidEndTracking:(id)arg1 ;
-(void)_noteScreenBrightnessDidChange:(id)arg1 ;
-(CGFloat)_yOffsetFromCenterForSlider;
@end