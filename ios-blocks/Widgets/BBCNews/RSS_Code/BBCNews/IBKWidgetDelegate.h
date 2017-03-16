/*
 * It is HIGHLY recommended to read through the provided .pdf on how
 * this API works. 
*/

#import <Foundation/Foundation.h>

@protocol IBKWidgetDelegate <NSObject>

@required
// These methods will be called in this order

// Content view for the widget
-(UIView*)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad;

// Specifiy if the widget has buttons
-(BOOL)hasButtonArea;

// Use your own custom icon view
-(BOOL)hasAlternativeIconView;

@optional

// View that contains buttons
-(UIView*)buttonAreaViewWithFrame:(CGRect)frame;

// View that contains your custom icon
-(UIView*)alternativeIconViewWithFrame:(CGRect)frame;

// If wantsGradientBackground, this will not be called
-(NSString*)customHexColor;

// YES to use a gradient instead of one colour as per customHexColor
-(BOOL)wantsGradientBackground;

// An array of colours respresented by HTML colour codes
-(NSArray*)gradientBackgroundColors;

// Turns off the fading on the content view when using buttons
-(BOOL)wantsNoContentViewFadeWithButtons;

@end
