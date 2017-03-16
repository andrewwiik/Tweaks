//
//  NotesView.h
//  test
//
//  Created by Brian Olencki on 11/25/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotesView;
@protocol NotesViewDelegate <NSObject>
- (void)notesView:(NotesView*)view saveText:(UITextView*)textView;
@end

@interface NotesView : UIView {
    
    __unsafe_unretained id<NotesViewDelegate> _delegate;
    UITextView *_txtInput;
    UITextView *_titleInput;
}
@property (assign, nonatomic) id<NotesViewDelegate> delegate;
@property (readonly, nonatomic) UITextView *txtInput;
+ (UIColor*)defaultBackgroundColor;
- (void)saveText;
- (void)dismissKeyboard;
@end
