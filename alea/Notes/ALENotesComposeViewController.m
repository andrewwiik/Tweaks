#import "ALENotesComposeViewController.h"
#import "ALENotesUtility.h"

#define AntiARCRetain(...) void *retainedThing = (__bridge_retained void *)__VA_ARGS__; retainedThing = retainedThing

@implementation ALENotesComposeViewController

- (id)init {
	if (self = [super init]) {
		_savedNote = NO;
	}
	return self;
}

- (void)viewDidLoad {

	[super viewDidLoad];
	AntiARCRetain(self);

	/* Start Input Text View Setup */

	_inputTextView = [[UITextView alloc] init];
    _inputTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    _inputTextView.userInteractionEnabled = YES;
    _inputTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _inputTextView.delegate = self;
    [self.view addSubview:_inputTextView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_inputTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:15]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_inputTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-15]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_inputTextView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:15]];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:_inputTextView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-15]];

	UIPanGestureRecognizer *pgrDismissKeyboard = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:pgrDismissKeyboard];

    self.view.delegate = self;

	[_inputTextView becomeFirstResponder];



    /* End Input Text View Setup */
}

- (void)loadView {

	[super loadView];
	UIView *view = [[UIView alloc] init];
   	self.view = view;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self saveNote];
}
- (void)viewDidDisappear:(BOOL)arg1 {
	[super viewDidDisappear:arg1];
	[self saveNote];
}

- (void)saveNote {

	if (!_savedNote) {

	[NSClassFromString(@"ICNotesExtensionClient") initialize];
	ICNotesExtensionClient *client = [NSClassFromString(@"ICNotesExtensionClient") sharedExtensionClient];
	[client createNoteWithContents:_inputTextView.text completionHandler:nil];
	_savedNote =YES;
	}
}
- (void)textViewDidEndEditing:(UITextView *)textView {
	[self saveNote];
}

- (void)dismissKeyboard {
    [_inputTextView resignFirstResponder];
    [self saveNote];
}
@end
