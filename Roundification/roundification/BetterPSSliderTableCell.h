#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSViewController.h>
//#import <UIKit/UIKit.h>
@interface PSControlTableCell : PSTableCell {
    UIControl * _control;
}

@property (nonatomic, retain) UIControl *control;

- (BOOL)canReload;
- (id)control;
- (void)controlChanged:(id)arg1;
- (id)controlValue;
- (void)dealloc;
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3;
- (id)newControl;
- (void)refreshCellContentsWithSpecifier:(id)arg1;
- (void)setControl:(id)arg1;
- (id)valueLabel;

@end

@interface PSSliderTableCell : PSControlTableCell {
    UIView * _disabledView;
}

- (BOOL)canReload;
- (id)controlValue;
- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3;
- (void)layoutSubviews;
- (id)newControl;
- (void)prepareForReuse;
- (void)refreshCellContentsWithSpecifier:(id)arg1;
- (void)setCellEnabled:(BOOL)arg1;
- (void)setValue:(id)arg1;
- (id)titleLabel;

@end
@interface BetterPSSliderTableCell : PSSliderTableCell <UIAlertViewDelegate, UITextFieldDelegate> {
    UIAlertView * alert;
}
-(void)presentPopup;
-(void) typeMinus;
@end
