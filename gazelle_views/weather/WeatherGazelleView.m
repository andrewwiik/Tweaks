//
//  WeatherGazelleView.m
//  Weather
//
//  Created by Creatix on 04/14/2016.
//  Copyright (c) Creatix. All rights reserved.
//

#import <Gazelle/Gazelle.h>
#import "WeatherGazelleView.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ALEWeatherUtility.h"
#import "headers.h"

@class CAFilter;
@interface CAFilter : NSObject
+(instancetype)filterWithName:(NSString *)name;
@end
@implementation WeatherGazelleView

- (UIColor *)presentationBackgroundColor {
	return [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.2];
}

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
UIView *helpingView = [[UIView alloc] initWithFrame:CGRectMake(0,0,250,250)];
helpingView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
[self addSubview: helpingView];
helpingView.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithName:@"overlayBlendMode"];
	City *localCity = (City *)[[[NSClassFromString(@"WeatherPreferences") sharedPreferences] loadSavedCities] objectAtIndex:10];
	[CATransaction begin];
[CATransaction setValue:(id)kCFBooleanTrue
		 forKey:kCATransactionDisableActions];
[self.layer addSublayer:[ALEWeatherUtility colourBackingLayerForCondition:localCity.conditionCode isDay:localCity.isDay]];
[CATransaction commit];
	ALEWeatherViewController *weatherController = [[ALEWeatherViewController alloc] initWithCity:localCity viewType:ALEWeatherViewTypeHourly celsius:NO];
	weatherController.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:weatherController.view];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:weatherController.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:weatherController.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:weatherController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:weatherController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	_viewLoaded = YES;
	}
}

- (void)handleActionForIconTap	{
	/**
	* Decide what happens when the user taps on the icon view
	* Perhaps remove the presented view?
	*/
	[Gazelle tearDownAnimated:YES];

	/**
	* Or perhaps open the application?
	*/
}

- (void)setActivatedApplicationIdentifier:(NSString *)identifier {
	/*
	* This will be set during presentation, it will allow you to determine what app was swiped up on
	* incase user set your view for an app you didn't intend
	*/
	_swipedIdentifier = identifier;
}

- (BOOL)loadBundleNeededALE {
NSString *fullPath = [NSString stringWithFormat:@"/System/Library/Assistant/UIPlugins/Stocks.siriUIBundle"];
NSBundle *bundle;
bundle = [NSBundle bundleWithPath:fullPath];
return [bundle load];
}

@end
