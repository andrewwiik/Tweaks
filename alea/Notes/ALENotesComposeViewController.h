
@interface UIView (ALEPrivate)
@property (assign, nonatomic) id delegate;
@end

@interface ALENotesComposeViewController : UIViewController <UITextViewDelegate> {
	BOOL _savedNote;
}

@property (nonatomic, strong) UITextView *inputTextView;
- (id)init;
- (void)saveNote;
@end

