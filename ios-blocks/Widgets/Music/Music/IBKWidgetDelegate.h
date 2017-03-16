//
//  IBKWidget.h
//  curago
//
//  Created by Matt Clarke on 10/06/2014.
//

#import <Foundation/Foundation.h>

@protocol IBKWidgetDelegate <NSObject>

@required
-(UIView*)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad;
-(BOOL)hasButtonArea;
-(BOOL)hasAlternativeIconView;

@optional
-(UIView*)buttonAreaViewWithFrame:(CGRect)frame;
-(UIView*)alternativeIconView;
-(void)willRotateToInterfaceOrientation:(int)arg1;
-(void)didRotateToInterfaceOrientation:(int)arg1;

@end
