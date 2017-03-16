#import <UIKit/UIKit.h>
#import "headers.h"
#define SCREEN ([UIScreen mainScreen].bounds)
@interface CKConversation : NSObject
@end

@interface CKConversationList : NSObject
- (CKConversation*)conversationForExistingChatWithGUID:(id)arg1;
+ (instancetype)sharedConversationList;
@end
@interface CKTranscriptCollectionView : UICollectionView
@property (nonatomic, retain) SBApplicationShortcutMenuItemView *itemView;
@end

@interface CKTranscriptCollectionViewController : UIViewController
- (CKTranscriptCollectionView*)view;
- (id)initWithConversation:(id)conversation balloonMaxWidth:(CGFloat)ballonWidth marginInsets:(UIEdgeInsets)insets;
@end

@interface CKNavigationController : UINavigationController

- (BOOL)shouldAutorotate;

@end
@interface CKMessageEntryView : UIView
- (UIView*)backdropView;
@end
@interface CKTranscriptController : UIViewController
@property (nonatomic, retain) UIView *itemView;
- (void)_setConversation:(id)arg1;
- (void)_setupViewForConversation;
- (CKMessageEntryView*)entryView;
- (CKTranscriptCollectionViewController *)collectionViewController;
@end

%hook IMDaemonController
- (unsigned int)_capabilities {
	return 17159;
}
- (void)_setCapabilities:(unsigned int)arg1 {
	%orig(17159);
}
- (unsigned int)capabilities {
	return 17159;
}
- (unsigned int)capabilitiesForListenerID:(id)arg1 {
	return 17159;
}
%end
%hook SBIconController
%new
- (id)testChatController {
	CKConversation *conversation = [[[%c(CKConversationList) sharedConversationList] conversationForExistingChatWithGUID:[NSString stringWithFormat:@"iMessage;-;+19739199824"]] retain];
	NSLog(@"Conversation: %@", conversation);
	CKTranscriptCollectionViewController *vc = [[%c(CKTranscriptCollectionViewController) alloc] initWithConversation:conversation balloonMaxWidth:nil marginInsets:UIEdgeInsetsMake(0,0,0,0)];
	return vc;
}
%end
%hook SBApplicationShortcutMenuContentView
%new
- (void)clearMenu {
    UIView *rowContainer = MSHookIvar<UIView*>(self,"_rowContainer");
    UIView *dividerContainer = MSHookIvar<UIView*>(self,"_dividerContainer");
    rowContainer.hidden = YES;
    dividerContainer.hidden = YES;
}
%end

%hook SBApplicationShortcutMenu
%new
- (id)iconViewHelp {
	return nil;
}
- (void)menuContentView:(SBApplicationShortcutMenuContentView *)arg1 activateShortcutItem:(SBSApplicationShortcutItem*)arg2 index:(long long)arg3 {
	if ([arg2.type isEqualToString: @"com.apple.mobilesms.conversation"]) {
		[arg1 highlightGesture].enabled = NO;
		[arg1 clearMenu];
		[[NSNotificationCenter defaultCenter] addObserver:self 
                    selector:@selector(keyboardDidShow:) 
                    name:UIKeyboardDidShowNotification 
                    object:nil];


	CKConversation *conversation = [[[%c(CKConversationList) sharedConversationList] conversationForExistingChatWithGUID:[arg2.userInfo objectForKey:@"CKSBActionUserInfoKeyChatGUID"]] retain];
	[conversation loadMoreMessages];
	arg1.frame = CGRectMake(13, arg1.frame.origin.y, SCREEN.size.width - (13*2), arg1.frame.size.height);
	NSMutableArray *itemViews = MSHookIvar<NSMutableArray*>([self contentView],"_itemViews");
	CKTranscriptController *chatTranscriptController = [[[%c(CKTranscriptController) alloc] init] retain];
	[chatTranscriptController setConversation:conversation];
	[chatTranscriptController _setConversation:conversation];
	[[[chatTranscriptController collectionViewController] view] setItemView: itemView];
	UIImage *contactImage = [itemView iconView].image;

	SBApplicationShortcutMenuItemView *itemViewNew = [[%c(SBApplicationShortcutMenuItemView) alloc] init];
	[arg2 setLocalizedSubtitle:nil];
	[itemViewNew setShortcutItem:arg2];
	[itemViewNew _setupViewsWithIcon:contactImage title:arg2.localizedTitle subtitle:NULL];
	[itemViewNew layoutSubviews];

	itemViewNew.frame = CGRectMake(0,0,arg1.frame.size.width, itemView.frame.size.height);
	[arg1 addSubview:itemViewNew];
	UIView *headerDivider = [UIView new];
	headerDivider.frame = CGRectMake(0, itemView.frame.size.height - 0.5, arg1.frame.size.width, 0.5);
	[arg1 addSubview:headerDivider];
	[headerDivider setBackgroundColor:[UIColor blackColor]];
	[headerDivider setAlpha:0.25];

	chatTranscriptController.view.frame = CGRectMake(0,itemViewNew.frame.size.height,arg1.frame.size.width, arg1.frame.size.height);
	[arg1 addSubview:chatTranscriptController.view];
	[chatTranscriptController _setupViewForConversation];
	[[chatTranscriptController collectionViewController] loadEarlierMessages];
	[arg1 addSubview:[chatTranscriptController entryView]];
	
	[chatTranscriptController.view setBackgroundColor:[UIColor clearColor]];
	[[[chatTranscriptController collectionViewController] view] setBackgroundColor: [UIColor clearColor]];
	[chatTranscriptController entryView].frame = CGRectMake(0,arg1.frame.size.height-[chatTranscriptController entryView].frame.size.height, [chatTranscriptController entryView].frame.size.width,[chatTranscriptController entryView].frame.size.height);
	[[chatTranscriptController entryView] backdropView].hidden = YES;
	[[chatTranscriptController entryView] setBackgroundColor: [UIColor clearColor]];

	chatTranscriptController.itemView = itemViewNew;

	[[[chatTranscriptController collectionViewController] view] setContentInset:UIEdgeInsetsMake(0,0,[chatTranscriptController entryView].frame.size.height,0)];

	[[NSNotificationCenter defaultCenter] addObserver:[chatTranscriptController entryView]
                    selector:@selector(keyboardDidShow:) 
                    name:UIKeyboardDidShowNotification 
                    object:nil];
	chatTranscriptController.itemView.frame = CGRectMake(0, 0, arg1.frame.size.width, itemView.frame.size.height);
	}
	else %orig;
}
%new
- (UIView *)contentView {
	return MSHookIvar<SBApplicationShortcutMenuContentView*>(self,"_contentView");
}
%new
- (void)keyboardDidShow:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self convertRect:keyboardRect fromView:nil]; //this is it!
    if (([self contentView].frame.origin.y + [self contentView].frame.size.height) > SCREEN.size.height - keyboardRect.size.height - 20) {
    	CGRect originalFrame = [self contentView].frame;
    	[self contentView].frame = CGRectMake(originalFrame.origin.x,13, originalFrame.size.width, SCREEN.size.height - keyboardRect.size.height - 20 - 13);
    }
}
%end

%hook CKTranscriptCollectionView
%property (nonatomic, retain) SBApplicationShortcutMenuItemView *itemView;
- (void)layoutSubviews {
	%orig;
	[self setBackgroundColor:[UIColor clearColor]];
}
- (void)setContentInset:(UIEdgeInsets)arg1 {
	[[[self delegate] delegate] itemView].frame =  CGRectMake(0, 0, [[[[self delegate] delegate] itemView] superview].frame.size.width, [[[self delegate] delegate] itemView].frame.size.height);
	//%orig(UIEdgeInsetsMake(0,0,[[[self delegate] delegate] entryView].frame.size.height,0));
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [[self superview] superview].frame.size.height - [[[self delegate] delegate] entryView].frame.size.height - [[[self delegate] delegate] itemView].frame.size.height);
}
%end

%hook CKMessageEntryView
- (void)layoutSubviews {
	%orig;
	self.frame = CGRectMake(self.frame.origin.x, [self superview].frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}
%new
- (void)keyboardDidShow:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self convertRect:keyboardRect fromView:nil]; //this is it!
    self.frame = CGRectMake(self.frame.origin.x, [self superview].frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}
%end

%hook CKTranscriptController
%property (nonatomic, retain) UIView *itemView;
- (BOOL)photoButtonEnabled {
	return YES;
}
%end

%hook CKTranscriptCollectionViewController
- (void)viewDidAppear:(BOOL)arg1 {
	%orig;
	//[[[[self delegate] entryView] contentView] makeActive];
}
%end
	
%hook CKUIBehavior
- (BOOL)transcriptCanUseOpaqueMask {
	return NO;
}
- (id)transcriptBackgroundColor {
	return [UIColor clearColor];
}
-(NSArray*)gray_balloonColors {
	NSMutableArray *grayColors = [NSMutableArray new];
	[grayColors addObject:[UIColor whiteColor]];
	return [grayColors copy];
}
%end