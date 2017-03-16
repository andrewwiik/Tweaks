@interface ICNotesExtensionClient : NSObject
+ (instancetype)sharedExtensionClient;
+ (void)initialize;
- (void)createNoteWithContents:(NSString *)contents completionHandler:(id)handler;
@end

@interface ALENotesUtility : NSObject

+ (void)createNoteWithText:(NSString *)noteContent;

@end