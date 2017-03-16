
#include "BlurBlur.h"

@implementation BlurBlur
  + (UIView *)createWithStyle:(int)style withFrame:(CGRect)frame {

    UIView *blurWindow = [[UIView alloc] initWithFrame:frame];
    blurWindow.backgroundColor = [UIColor blackColor];

    _UIBackdropView *blurView = [[_UIBackdropView alloc] initWithStyle:style];
    [blurView setBlurRadiusSetOnce:NO];
    [blurView setBlurRadius:4.0];
    [blurView setBlurHardEdges:2];
    [blurView setBlursWithHardEdges:YES];
    [blurView setBlurQuality:@"default"];
    [blurWindow addSubview:blurView];
    return blurWindow;
  }
@end


%hook _UIBackdropViewSettings
%new
+ (instancetype)settingsForStyle:(int)style weighting:(CGFloat)weight previousSettings:(_UIBackdropViewSettings *)previous {
    if (style == 1447) {
        _UIBackdropViewSettingsCombiner *settings = [[NSClassFromString(@"_UIBackdropViewSettingsCombiner") alloc] init];
        // _UIBackdropViewSettings *settingsA = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:2020];
        // settingsA.blurRadius = 0;
        // settingsA.grayscaleTintAlpha = 0.05;
        // settingsA.colorTint = [UIColor blackColor];
        // settingsA.colorTintAlpha = 0.07;
        settings.inputSettingsA = previous;
        _UIBackdropViewSettings *settingsB = [NSClassFromString(@"_UIBackdropViewSettings") settingsForStyle:2020];
        settingsB.blurRadius = 15;
        settingsB.grayscaleTintAlpha = 0.05;
        settingsB.colorTint = [UIColor blackColor];
        settingsB.colorTintAlpha = 0.07;
        settings.inputSettingsB = settingsB;
        settings.weighting = weight;

        return settings;
    }
    else return nil;
}
%end