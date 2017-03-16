#import "headers.h"
#import "CCXSliderToggleButton.h"
#import "CCXVolumeAndBrightnessSectionView.h"

@interface CCXVolumeAndBrightnessSectionController : CCUIControlCenterSectionViewController <SBUIIconForceTouchControllerDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, retain) CCUIControlCenterSlider *slider;
@property (nonatomic, retain) CCUIControlCenterSlider *brightnessSlider;
@property (nonatomic, retain) CCUIControlCenterSlider *volumeSlider;
@property (nonatomic, retain) CCUIBrightnessSectionController *brightnessSectionController;
@property (nonatomic, retain) MPUMediaControlsVolumeView *volumeSectionController;
@property (nonatomic, assign) BOOL isCurrentlyShowingVolume;
@property (nonatomic, retain) UIView *toggleBackgroundView;
@property (nonatomic, retain) CCXSliderToggleButton *toggleButton;
@property (nonatomic, retain) CCXVolumeAndBrightnessSectionView *view;
@property (nonatomic, retain) SBUIIconForceTouchController *iconForceTouchController;
@property (nonatomic, retain) SBUIForceTouchGestureRecognizer *forceTouchGestureRecognizer;
+ (Class)viewClass;
- (id)init;
- (void)viewDidLoad;
- (void)viewDidLayoutSubviews;
- (void)setDelegate:(id<CCUIControlCenterSectionViewControllerDelegate>)delegate;

+ (NSString *)sectionIdentifier;
+ (NSString *)sectionName;
+ (UIImage *)sectionImage;
@end