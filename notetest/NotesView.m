//
//  NotesView.m
//  test
//
//  Created by Brian Olencki on 11/25/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//
#import <Notes/Notes.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreData/NSEntityDescription.h>
#import "NotesView.h"
// #include <dlfcn.h>
#import <objc/runtime.h>


@implementation NotesView
@synthesize delegate = _delegate, txtInput = _bodyInput;
#define WhiteSmoke ([UIColor colorWithRed:((float)((0xECECEC & 0xFF0000) >> 16))/255.0 green:((float)((0xECECEC & 0xFF00) >> 8))/255.0 blue:((float)(0xECECEC & 0xFF))/255.0 alpha:1.0])
+ (UIColor*)defaultBackgroundColor {
    return WhiteSmoke;
}
- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        _titleInput = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width -20, frame.size.height/4)];
        _titleInput.backgroundColor = self.backgroundColor;
        _titleInput.dataDetectorTypes = UIDataDetectorTypeAll;
        _titleInput.userInteractionEnabled = YES;
        [self addSubview:_titleInput];

        _bodyInput = [[UITextView alloc] initWithFrame:CGRectMake(10, _titleInput.frame.size.height + 10, _titleInput.frame.size.width, frame.size.height - _titleInput.frame.size.height - 20)];
        _bodyInput.backgroundColor = self.backgroundColor;
        _bodyInput.dataDetectorTypes = UIDataDetectorTypeAll;
        _bodyInput.userInteractionEnabled = YES;
        [self addSubview:_bodyInput];
        [_titleInput becomeFirstResponder];
        self.backgroundColor = WhiteSmoke;
        
        UIPanGestureRecognizer *pgrDismissKeyboard = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [self addGestureRecognizer:pgrDismissKeyboard];
    }
    return self;
}

- (void)saveText {
    NoteContext *noteContext = [[NoteContext alloc] init];
    NSManagedObjectContext *context = [noteContext managedObjectContext];
    NoteStoreObject *store = [noteContext defaultStoreForNewNote];
    NoteObject *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    NoteBodyObject *body = [NSEntityDescription insertNewObjectForEntityForName:@"NoteBody" inManagedObjectContext:context];

    NSString *notetext = _bodyInput.text;
    NSArray *sep = [notetext componentsSeparatedByString:@"\n"];
    notetext = [sep componentsJoinedByString:@"<br />"];
    body.content = notetext;
    body.owner = note;
    note.author = @"Joesph Huber <andywiik@icloud.com";
    
    note.store = store;
    note.integerId = [noteContext nextIndex];
    note.title = _titleInput.text;
    note.summary = @"summary here";
    // note.externalFlags = 196609;
    note.body = body;
    note.creationDate = [NSDate date];
    note.modificationDate = [NSDate date];
    NSError *error;
    BOOL success = [noteContext saveOutsideApp:&error];
    if (!success) {
        UIAlertView*theAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [theAlert show];
        [theAlert release];
    }
    //[noteContext release];
}
- (void)dismissKeyboard {
    [_bodyInput resignFirstResponder];
    [self saveText];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    _bodyInput.frame = CGRectMake(10, _titleInput.frame.size.height + 10, _titleInput.frame.size.width, self.frame.size.height - _titleInput.frame.size.height - 20);
    _bodyInput.backgroundColor = self.backgroundColor;
}
@end
