//
//  IBKWidget.h
//  curago
//
//  Created by Matt Clarke on 10/06/2014.
//
//

#import <Foundation/Foundation.h>

@protocol IBKWidget <NSObject>

@required
// These methods will be called in this order
-(UIView*)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad;
-(BOOL)hasButtonArea;
-(BOOL)hasAlternativeIconView;

@optional
-(UIView*)buttonAreaViewWithFrame:(CGRect)frame;
-(UIView*)alternativeIconViewWithFrame:(CGRect)frame;
-(void)willRotateToInterfaceOrientation:(int)arg1;
-(void)didRotateToInterfaceOrientation:(int)arg1;
-(NSString*)customHexColor;
-(BOOL)wantsGradientBackground;
-(NSArray*)gradientBackgroundColors;
-(NSArray*)gradientBackgroundColorsUIColor;
-(BOOL)wantsNoContentViewFadeWithButtons;

@end
