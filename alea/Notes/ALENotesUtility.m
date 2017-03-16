#import "ALENotesUtility.h"

@implementation ALENotesUtility

+ (void)createNoteWithText:(NSString *)noteContent {
	[NSClassFromString(@"ICNotesExtensionClient") initialize];
	ICNotesExtensionClient *client = [NSClassFromString(@"ICNotesExtensionClient") sharedExtensionClient];
	[client createNoteWithContents:noteContent completionHandler:nil];
}

@end