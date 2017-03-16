 
@interface IMMessage : NSObject
@property (nonatomic, retain) NSDate *time;
@end
@interface IMChat : NSObject
@property (nonatomic, readonly) IMMessage *lastFinishedMessage;
@end
@interface CKConversation : NSObject
-(id)date;
@property (nonatomic, retain) NSDate *currentDate;
@end
@interface CKConversationListController : UITableViewController
- (void)reloadData;
-(void)updateConversationList;
@end

%hook CKConversation
%property (nonatomic, retain) NSDate *currentDate;
- (id)initWithChat:(id)arg1 {
	%orig;
	self.currentDate = [[[self chat] lastMessage] time];
	return %orig;
}
- (NSUInteger)unreadCount {
	self.currentDate = [[[self chat] lastMessage] time];
	return %orig;
}
- (id)chat {
	id temp = %orig;
	self.currentDate = [[temp lastMessage] time];
	return temp;
}
%end
%hook IMChat
- (id)__ck_watermarkDate {
	return self.lastFinishedMessage.time;
}
%end
%hook CKConversationList
- (NSMutableArray *)conversations {
	NSMutableArray* conversationsCopy = %orig;
	NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"currentDate" ascending:NO];
    [conversationsCopy sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    return conversationsCopy;
}
- (NSMutableArray *)activeConversations {
	NSMutableArray* conversationsCopy = %orig;
	NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"currentDate" ascending:NO];
    [conversationsCopy sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    return conversationsCopy;
}
- (void)_postConversationListChangedNotification {
	%orig;
	[self resort];
}
- (void)_abChanged:(id)arg1 {
	[self resort];
}
%end
%hook CKConversationListController
- (void)_chatItemsDidChange:(id)arg1 {
	%orig;
	[self updateConversationList];
	[self.view reloadData];

}
- (void)viewWillAppear:(BOOL)arg1 {
	%orig;
	[self updateConversationList];
	[self.view reloadData];
}
%end