#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface ACUIAppInstallCell : PSTableCell
- (id)_createInstallButton;
- (id)_createLabelForAppName:(id)arg1;
- (id)_createLabelForPublisher:(id)arg1;
- (void)_updateInstallButtonWithState:(int)arg1;
- (void)_updateSubviewsWithInstallState:(int)arg1;
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3;
- (int)installState;
- (void)layoutSubviews;
- (void)setInstallState:(int)arg1;
- (void)touchesBegan:(id)arg1 withEvent:(id)arg2;
- (void)touchesCancelled:(id)arg1 withEvent:(id)arg2;
- (void)touchesEnded:(id)arg1 withEvent:(id)arg2;
- (void)touchesMoved:(id)arg1 withEvent:(id)arg2;
@end

@interface CRTProductCell : ACUIAppInstallCell
- (id)_createInstallButton;
- (id)_createLabelForAppName:(id)arg1;
- (id)_createLabelForPublisher:(id)arg1;
- (void)_updateInstallButtonWithState:(int)arg1;
- (void)_updateSubviewsWithInstallState:(int)arg1;
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3;
- (int)installState;
- (void)layoutSubviews;
- (void)setInstallState:(int)arg1;
- (void)touchesBegan:(id)arg1 withEvent:(id)arg2;
- (void)touchesCancelled:(id)arg1 withEvent:(id)arg2;
- (void)touchesEnded:(id)arg1 withEvent:(id)arg2;
- (void)touchesMoved:(id)arg1 withEvent:(id)arg2;
@end