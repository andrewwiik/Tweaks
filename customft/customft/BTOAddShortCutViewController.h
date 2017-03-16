//
//  BTOAddShortCutViewController.h
//  test
//
//  Created by Brian Olencki on 10/17/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Preferences/Preferences.h>
#import "BTOShortCutManager.h"

@interface BTOInputView : UIView {
    UISegmentedControl *_segmentedControl;
    UITextField *_txtURLScheme;
    UITextField *txtSchellScript;

    NSString *activatorAction;
}
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UITextField *txtURLScheme;
- (NSString*)getURL;
@end
@interface BTOAddShortCutViewController : UIViewController/*PSListController*/ <UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    UIScrollView *scvContents;

    UITextField *_txtTitle;
    UITextField *_txtSubTitle;
    UITextField *_txtBundleID;
    BTOInputView *viewInput;
    NSString *pickedImage;
    UITableView *tblAppList;

    NSArray *aryIcons;
    UIPickerView *pickerView;
    NSInteger _iconNumber;
    BOOL _isOutsideSettings;
}
@property (retain, nonatomic) UITextField *txtTitle;
@property (retain, nonatomic) UITextField *txtSubTitle;
@property (retain, nonatomic) UITextField *txtBundleID;
@property (nonatomic) NSInteger iconNumber;
@property (nonatomic) BOOL isOutsideSettings;
- (void)setIconNumber:(NSInteger)iconNumber;
- (void)setURLText:(NSString*)text;
@end
