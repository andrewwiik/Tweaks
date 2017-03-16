#import "BetterPSSliderTableCell.h"

#define WANTS_NEGATION YES // THIS WILL ALLOW THE USER TO ENTER NEGATIVE VALUES (ON IPHONE - IPAD ALWAYS CAN)

@implementation BetterPSSliderTableCell

- (id)initWithStyle:(int)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3 {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:arg2 specifier:arg3];
    if (self) {
        CGRect frame = [self frame];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(frame.size.width-50, 0, 50, frame.size.height);
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [button setTitle:@"" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(presentPopup) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)presentPopup {
    alert = [[UIAlertView alloc] initWithTitle:self.specifier.name
                          message:[NSString stringWithFormat:@"Please enter a value between %i and %i.", (int)[[self.specifier propertyForKey:@"min"] floatValue], (int)[[self.specifier propertyForKey:@"max"] floatValue]]
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Enter"
                          , nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 342879;
    [alert show];
    [[alert textFieldAtIndex:0] setDelegate:self];
    [[alert textFieldAtIndex:0] resignFirstResponder];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    if(WANTS_NEGATION && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        UIToolbar* toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        UIBarButtonItem* buttonOne = [[UIBarButtonItem alloc] initWithTitle:@"Negate" style:UIBarButtonItemStylePlain target:self action:@selector(typeMinus)];
        NSArray* buttons = [NSArray arrayWithObjects:buttonOne, nil];
        [toolBar setItems:buttons animated:NO];
        [[alert textFieldAtIndex:0] setInputAccessoryView:toolBar];
    }
    [[alert textFieldAtIndex:0] becomeFirstResponder];
}

-(void) typeMinus {
    if (alert) {
        NSString* text = [alert textFieldAtIndex:0].text;
        if ([text hasPrefix:@"-"]) {
            [alert textFieldAtIndex:0].text = [text substringFromIndex:1];
        }
        else {
            [alert textFieldAtIndex:0].text = [NSString stringWithFormat:@"-%@", text];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 342879 && buttonIndex == 1) {
        CGFloat value = [[alertView textFieldAtIndex:0].text floatValue];
        if (value <= [[self.specifier propertyForKey:@"max"] floatValue] && value >= [[self.specifier propertyForKey:@"min"] floatValue]) {
            [[[[self superview] superview] delegate] setPreferenceValue:[NSNumber numberWithInt:value] specifier:self.specifier];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self setValue:[NSNumber numberWithInt:value]];
        }
        else {
            UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                  message:@"Ensure you enter a valid value."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil
                                  , nil];
            errorAlert.tag = 85230234;
            [errorAlert show];
        }
    }
    else if (alertView.tag == 85230234) {
        [self presentPopup];
    }
}

@end
