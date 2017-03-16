//
//  BTOAddShortCutViewController.m
//  test
//
//  Created by Brian Olencki on 10/17/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import "BTOAddShortCutViewController.h"
#import <objc/runtime.h>
#include <dlfcn.h>
#import <libactivator/libactivator.h>

@implementation BTOInputView
@synthesize segmentedControl = _segmentedControl, txtURLScheme = _txtURLScheme;
- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(populateEvent:) name:@"BTO_ActivatorEventName" object:nil];

        NSArray *itemArray = [NSArray arrayWithObjects: @"URL Scheme", @"Activator", @"Shell Script", nil];

        _segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        _segmentedControl.frame = CGRectMake(0, 0, frame.size.width, 30);
        [_segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents: UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 0;
        [self addSubview:_segmentedControl];

        _txtURLScheme = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, 30)];
        _txtURLScheme.placeholder = @"\%@ = input";
        _txtURLScheme.textAlignment = NSTextAlignmentCenter;
        _txtURLScheme.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _txtURLScheme.autocorrectionType = UITextAutocorrectionTypeNo;
        _txtURLScheme.font = [UIFont systemFontOfSize:24];
        _txtURLScheme.hidden = NO;
        [self addSubview:_txtURLScheme];

        txtSchellScript = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, frame.size.width, 30)];
        txtSchellScript.placeholder = @"Enter Command";
        txtSchellScript.textAlignment = NSTextAlignmentCenter;
        txtSchellScript.autocapitalizationType = UITextAutocapitalizationTypeNone;
        txtSchellScript.autocorrectionType = UITextAutocorrectionTypeNo;
        txtSchellScript.font = [UIFont systemFontOfSize:24];
        txtSchellScript.hidden = YES;
        [self addSubview:txtSchellScript];
    }
    return self;
}

#pragma mark - Public Functions
- (NSString*)getURL {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            return _txtURLScheme.text;
            break;
        case 1:
            return [NSString stringWithFormat:@"activator://%@",activatorAction];
            break;
        case 2:
            return [NSString stringWithFormat:@"shellScript://%@",txtSchellScript.text];
            break;

        default:
            return @"";
            break;
    }
}

#pragma mark - Private Functions
- (void)segmentChanged:(UISegmentedControl*)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            _txtURLScheme.hidden = NO;
            txtSchellScript.hidden = YES;
            break;
        case 1:
            _txtURLScheme.hidden = YES;
            txtSchellScript.hidden = YES;
            [self loadActivator];
            break;
        case 2:
            _txtURLScheme.hidden = YES;
            txtSchellScript.hidden = NO;
            if ([_txtURLScheme.text containsString:@"shellScript://"]) {
              txtSchellScript.text = [_txtURLScheme.text stringByReplacingOccurrencesOfString:@"shellScript://" withString:@""];
            }
            break;

        default:
            break;
    }
}
- (void)populateEvent:(NSNotification*)notification {
  activatorAction = [notification object];
  _txtURLScheme.text = [NSString stringWithFormat:@"activator://%@",activatorAction];
}

#pragma mark - Activator
- (void)loadActivator {
  UIResponder *responder = self;
  while ([responder isKindOfClass:[UIView class]]) responder = [responder nextResponder];
  UIViewController *viewController = (UIViewController*)responder;

  dlopen("/usr/lib/libactivator.dylib", RTLD_LAZY);
  Class la = objc_getClass("LAModeSettingsController");
  if (la) {
    static dispatch_once_t p = 0;
    dispatch_once(&p, ^{
      Class BTO_la = objc_allocateClassPair(la, [[NSString stringWithFormat:@"BTO_LAModeSettingsController"] UTF8String], 0);
      objc_registerClassPair(BTO_la);

      SEL selTable = @selector(tableView:didSelectRowAtIndexPath:);
      SEL BTO_selTable = @selector(BTO_tableView:didSelectRowAtIndexPath:);
      class_addMethod(BTO_la,selTable,[self methodForSelector:BTO_selTable],[[NSString stringWithFormat:@"myTableSelect"] UTF8String]);
    });
      Class myLa = objc_getClass("BTO_LAModeSettingsController");
      [viewController presentViewController:[[myLa alloc] initWithMode:@"springboard"] animated:YES completion:nil];
  } else {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Traverse" message:@"If you want to use Activator, please install it in Cydia." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
  }
}
- (void)BTO_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  Class myLa = objc_getClass("BTO_LAModeSettingsController");
  NSString *action = [[[myLa alloc] initWithMode:@"springboard"] eventNameForIndexPath:indexPath];

  [[NSNotificationCenter defaultCenter] postNotificationName:@"BTO_ActivatorEventName" object:action];

  UIResponder *responder = tableView;
  while ([responder isKindOfClass:[UIView class]]) responder = [responder nextResponder];
  UIViewController *viewController = (UIViewController*)responder;
  [viewController dismissViewControllerAnimated:YES completion:nil];
}
@end

@implementation BTOAddShortCutViewController
@synthesize txtBundleID = _txtBundleID, txtTitle = _txtTitle, txtSubTitle = _txtSubTitle, iconNumber = _iconNumber, isOutsideSettings = _isOutsideSettings;
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Traverse";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Hide Keyboard" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)];

    scvContents = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    scvContents.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scvContents];

    _txtTitle = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, SCREEN.size.width-20, 30)];
    _txtTitle.placeholder = @"Title";
    _txtTitle.textAlignment = NSTextAlignmentCenter;
    _txtTitle.font = [UIFont systemFontOfSize:24];
    [scvContents addSubview:_txtTitle];

    _txtSubTitle = [[UITextField alloc] initWithFrame:CGRectMake(10, 140, SCREEN.size.width-20, 30)];
    _txtSubTitle.placeholder = @"Sub-title";
    _txtSubTitle.textAlignment = NSTextAlignmentCenter;
    _txtSubTitle.font = [UIFont systemFontOfSize:24];
    [scvContents addSubview:_txtSubTitle];

    _txtBundleID = [[UITextField alloc] initWithFrame:CGRectMake(10, 180, SCREEN.size.width-20, 30)];
    _txtBundleID.placeholder = @"Bundle ID";
    _txtBundleID.textAlignment = NSTextAlignmentCenter;
    _txtBundleID.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _txtBundleID.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtBundleID.font = [UIFont systemFontOfSize:24];

    BOOL AppList = [self isAppListInstalled];
    if (AppList == YES) {
      tblAppList = [[UITableView alloc] initWithFrame:CGRectMake(0,180, SCREEN.size.width, 180+70+10)];
      if (_isOutsideSettings == YES) {
        tblAppList.alpha = 0.5;
        tblAppList.userInteractionEnabled = NO;
      }
      tblAppList.delegate = self;

      Class ALApplicationTableDataSource = NSClassFromString(@"ALApplicationTableDataSource");
      id dataSource = [[NSClassFromString(@"ALApplicationTableDataSource") alloc] init];
      [dataSource setSectionDescriptors:[NSClassFromString(@"ALApplicationTableDataSource") standardSectionDescriptors]];

      tblAppList.dataSource = dataSource;
      [scvContents addSubview:tblAppList];

      viewInput = [[BTOInputView alloc] initWithFrame:CGRectMake(10, tblAppList.frame.origin.y+tblAppList.frame.size.height+10, SCREEN.size.width-20, 70)];
      [scvContents addSubview:viewInput];
    } else {
      [self.view addSubview:_txtBundleID];

      viewInput = [[BTOInputView alloc] initWithFrame:CGRectMake(10, 220, SCREEN.size.width-20, 70)];
      [scvContents addSubview:viewInput];
    }

    _iconNumber = 0;
    aryIcons = [[NSMutableArray alloc] initWithObjects:
                @"Add",
                //                @"Alarm",
                //                @"Audio",
                //                @"Bookmark",
                //                @"CapturePhoto",
                //                @"CaptureVideo",
                //                @"Cloud",
                @"Compose",
                //                @"Confirm",
                //                @"Contact",
                //                @"Date",
                //                @"Favorite",
                //                @"Home",
                //                @"Invitation",
                @"Location",
                //                @"Love",
                //                @"Mail",
                //                @"MarkLocation",
                //                @"Messages",
                @"Pause",
                @"Play",
                //                @"Prohibit",
                @"Search",
                @"Share",
                //                @"Shuffle",
                //                @"Task",
                //                @"TaskComplete",
                //                @"Time",
                //                @"Update",
                // @"Custom Image",
                nil];

    if (AppList == YES) {
      pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(SCREEN.size.width/8, viewInput.frame.origin.y+viewInput.frame.size.height+10, SCREEN.size.width*3/4, 70)];
    } else {
      pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(SCREEN.size.width/8, 300, SCREEN.size.width*3/4, 70)];
    }
    [pickerView setDataSource: self];
    [pickerView setDelegate: self];
    pickerView.showsSelectionIndicator = YES;
    [scvContents addSubview: pickerView];

    CGRect contentRect = CGRectZero;
    for (UIView *view in scvContents.subviews) {
        CGRect viewFrame = view.frame;
        contentRect = CGRectUnion(contentRect, CGRectMake(viewFrame.origin.x, viewFrame.origin.y,viewFrame.size.width,viewFrame.size.height*1.5));
    }
    scvContents.contentSize = CGSizeMake(contentRect.size.width, contentRect.size.height);

    pickedImage = @"";
}
// - (id)specifiers {
// 	if(_specifiers == nil) {
// 		_specifiers = [[self loadSpecifiersFromPlistName:@"CustomFT_AddAction" target:self] retain];
// 	}
// 	return _specifiers;
// }

#pragma mark - UIButton Functions
- (void)dismissKeyboard {
    for (UIView *view in viewInput.subviews) {
        if ([view isMemberOfClass:[UITextField class]]) {
            [((UITextField*)view) resignFirstResponder];
        }
    }
    for (UIView *view in self.view.subviews) {
        if ([view isMemberOfClass:[UITextField class]]) {
            [((UITextField*)view) resignFirstResponder];
        }
    }
    for (UIView *view in scvContents.subviews) {
        if ([view isMemberOfClass:[UITextField class]]) {
            [((UITextField*)view) resignFirstResponder];
        }
    }
}

#pragma mark - AppList
- (BOOL)isAppListInstalled {
  dlopen("/usr/lib/libapplist.dylib", RTLD_LAZY);
  Class AppList = objc_getClass("ALApplicationList");
  if (AppList) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - Other
- (void)back {
    // [self dismissKeyboard];
    // [[BTOShortCutManager sharedInstance] addShortCutWithTitle:_txtTitle.text withSubTitle:_txtSubTitle.text withBundleID:_txtBundleID.text withURL:[viewInput getURL] withIcon:_iconNumber withImage:pickedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setIconNumber:(NSInteger)iconNumber {
    [pickerView selectRow:iconNumber inComponent:0 animated:YES];
    _iconNumber = iconNumber;
}
- (void)setURLText:(NSString*)text {
    viewInput.txtURLScheme.text = text;
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [aryIcons count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [aryIcons objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _iconNumber = row;
    return;
    if (_iconNumber == [aryIcons count]-1) {
      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
      picker.delegate = self;
      picker.allowsEditing = YES;
      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    pickedImage = info[UIImagePickerControllerReferenceURL];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self dismissKeyboard];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *displayIdentifier = [tableView.dataSource displayIdentifierForIndexPath:indexPath];
  _txtBundleID.text = displayIdentifier;
}
@end
