@interface ICNotesExtensionClient : NSObject
+ (instancetype)sharedExtensionClient;
+ (void)initialize;
- (void)createNoteWithContents:(NSString *)contents completionHandler:(id)handler;
@end

%hook SpringBoard
%new
- (BOOL)loadNotes {

	NSString *fullPath = [NSString stringWithFormat:@"/System/Library/Assistant/Plugins/Notes.assistantBundle"];
	NSBundle *bundle;
	bundle = [NSBundle bundleWithPath:fullPath];
	return [bundle load];
}

%new
- (void)createNoteWithText:(NSString *)text {
	[NSClassFromString(@"ICNotesExtensionClient") initialize];
	ICNotesExtensionClient *client = [NSClassFromString(@"ICNotesExtensionClient") sharedExtensionClient];
	[client createNoteWithContents:text completionHandler:nil];
}
%end

%ctor {
	NSString *fullPath = [NSString stringWithFormat:@"/System/Library/Assistant/Plugins/Notes.assistantBundle"];
	NSBundle *bundle;
	bundle = [NSBundle bundleWithPath:fullPath];
	if ([bundle load]) NSLog(@"Sucess loaded");
	%init;
}

