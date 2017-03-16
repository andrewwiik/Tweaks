//
//  WeatherGazelleView.h
//  Weather
//
//  Created by Creatix on 04/14/2016.
//  Copyright (c) Creatix. All rights reserved.
//

@interface WeatherGazelleView : UIView {
	BOOL _viewLoaded;
}
- (BOOL)loadBundleNeededALE;
@property (nonatomic, strong) NSString *swipedIdentifier;
/**
* If you need to change the background color of the block view
* this is where you would change it
*/
- (UIColor *)presentationBackgroundColor;

/**
* This is called after a user taps on the presented views icon image
* You don't need to do anything except tell it what to do
*/
- (void)handleActionForIconTap;
@end
