#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Notes/Notes.h>
#import "NotesView.h"
#include <sqlite3.h>
#define search_by_email 17
 #define search_by_number 16

#define NSLog(FORMAT, ...) NSLog(@"[%@]: %@",@"Appendix" , [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#define SCREEN ([UIScreen mainScreen].bounds)

static NotesView *notes;

@interface SBApplication : NSObject
- (NSString*)bundleIdentifier;
- (NSString*)displayName;
@end


@interface SBApplicationShortcutMenuContentView : UIView
- (id)initWithInitialFrame:(struct CGRect)arg1 containerBounds:(struct CGRect)arg2 orientation:(long long)arg3 shortcutItems:(id)arg4 application:(id)arg5;
- (void)_handlePress:(id)arg1;
- (UILongPressGestureRecognizer *)highlightGesture;
@end
@interface SBApplicationShortcutMenu : UIView <NotesViewDelegate>
@property(retain, nonatomic) SBApplication *application; // @synthesize application=_application;
- (void)dismissAnimated:(_Bool)arg1 completionHandler:(id)arg2;
- (void)presentAnimated:(_Bool)arg1;
+(NSString *)getPersonInfoByKey:(int)key value:(NSString *)value;
@end


@interface SBIconController : UIViewController
@property(retain, nonatomic) SBApplicationShortcutMenu *presentedShortcutMenu; // @synthesize presentedShortcutMenu=_presentedShortcutMenu;
- (void)_handleShortcutMenuPeek:(UILongPressGestureRecognizer*)arg1;
@end


@interface UIApplication (Private)
-(BOOL)launchApplicationWithIdentifier:(NSString*)identifier suspended:(BOOL)suspended;
@end

@interface SBSApplicationShortcutItem : NSObject
- (id)type;
- (void)setType:(id)arg1;
@end

%hook SBApplicationShortcutMenu

/*
 To open a message the 'n' chat do this
 NSDictioanry *chats = [self getChatsDictionary];
 NSString *iden = [[chats objectForKey:[[NSNumber numberWithInteger:n] stringValue]] objectForKey:@"open"];
 if ([iden length] == 0) {
    return;
 }
 NSString *stringURL;
 stringURL = [NSString stringWithFormat:@"%@%@", @"sms:" , iden];
 NSURL *url = [NSURL URLWithString:stringURL];
 [[UIApplication sharedApplication] openURL:url];
 */





%new
-(void)savenote {
    NoteContext *noteContext = [[%c(NoteContext) alloc] init];
    NSManagedObjectContext *context = [noteContext managedObjectContext];
    NSArray *stores = [noteContext allStores];
	NoteStoreObject *store = [stores objectAtIndex:1];
    NoteObject *note = [%c(NSEntityDescription) insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    NoteBodyObject *body = [%c(NSEntityDescription) insertNewObjectForEntityForName:@"NoteBody" inManagedObjectContext:context];

    NSString *notetext = @"Your custom note text";
    NSArray *sep = [notetext componentsSeparatedByString:@"\n"];
    notetext = [sep componentsJoinedByString:@"<br />"];
    body.content = notetext;
    body.owner = note;
    
    note.store = store;
    note.integerId = [noteContext nextIndex];
    note.title = @"Title of Note";
    note.summary = @"summary here";
    note.body = body;
    note.creationDate = [NSDate date];
    note.modificationDate = [NSDate date];
    [store addNotesObject:note];
    [noteContext saveOutsideApp:NULL];
}

- (void)menuContentView:(id)arg1 activateShortcutItem:(SBSApplicationShortcutItem *)shortcutItem index:(long long)arg3 {
		if ([shortcutItem.type isEqualToString:@"com.apple.notes.newNote"]) {
			SBApplicationShortcutMenuContentView *contentView = MSHookIvar<id>(self,"_contentView");
			CGRect helpFrame = CGRectMake(0,0,contentView.frame.size.width, contentView.frame.size.height);
			notes = [[NotesView alloc] initWithFrame:helpFrame];
			 		 [contentView addSubview:notes];

	    	[contentView highlightGesture].enabled = NO;
    	}
  		else {
  			%orig;
  		}
}
%end