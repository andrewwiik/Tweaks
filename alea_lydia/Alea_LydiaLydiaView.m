//
//  Alea_LydiaContentView.m
//  Alea_Lydia
//
//  Created by Creatix on @@BUILD_DATE@@.
//  Copyright (c) Creatix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Alea_LydiaLydiaView.h"
#import "ALEWeatherUtility.h"
#import "headers.h"

@interface CPDButt : NSObject
- (void)tearDownAnimated:(BOOL)arg1;
@end

@interface CPLDPresentationWindow : NSObject
+ (CPDButt *)sharedWindow;
@end

@implementation Alea_LydiaLydiaView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
       _viewLoaded = NO;
    }

    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	if (!_viewLoaded) {
	UIVisualEffect *blurEffect;
blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

UIVisualEffectView *visualEffectView;
visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

visualEffectView.frame = self.bounds;
[self addSubview:visualEffectView];
	City *localCity = [[NSClassFromString(@"WeatherPreferences") sharedPreferences] localWeatherCity];
	[CATransaction begin];
[CATransaction setValue:(id)kCFBooleanTrue
                 forKey:kCATransactionDisableActions];
[self.layer addSublayer:[ALEWeatherUtility colourBackingLayerForCondition:localCity.conditionCode isDay:localCity.isDay]];
[CATransaction commit];
	ALEWeatherViewController *weatherController = [[ALEWeatherViewController alloc] initWithCity:localCity viewType:ALEWeatherViewTypeDaily celsius:NO];
	weatherController.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:weatherController.view];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:weatherController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:weatherController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:weatherController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:weatherController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	_viewLoaded = YES;
	}

	
}

- (void)handleActionForIconTap  {
	// Do whatever you want to happen when the icon below the custom view is tapped.

	// You may or may not want to close the Lydia interface when the user taps on the icon
	// that is completly up to your descrition to do as you like.
	[[NSClassFromString(@"CPLDPresentationWindow") sharedWindow] tearDownAnimated:YES];
}

- (BOOL)loadBundleNeededALE {
NSString *fullPath = [NSString stringWithFormat:@"/System/Library/Assistant/UIPlugins/Stocks.siriUIBundle"];
NSBundle *bundle;
bundle = [NSBundle bundleWithPath:fullPath];
return [bundle load];
}

@end
