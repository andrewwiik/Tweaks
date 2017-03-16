#import "TRVSEventSource/TRVSEventSource.h"

@interface SpringBoard : NSObject <TRVSEventSourceDelegate>
- (void)abcTest;
@end
%hook SpringBoard
- (id)init {
[self abcTest];
return %orig;
}
%new
- (void)abcTest {
	TRVSEventSource *eventSource = [[TRVSEventSource alloc] initWithURL:[NSURL URLWithString:@"http://ota.ioscreatix.com/update-stream"]];
	eventSource.delegate = self;

	[eventSource addListenerForEvent:@"update" usingEventHandler:^(TRVSServerSentEvent *event, NSError *error) {
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:event.data options:0 error:NULL];
   // Message *message = [Message messageWithJSON:JSON];
    //HBLogInfo([NSString stringWithFormat:@"%@", JSON]);
}];

[eventSource open];
}
%new
- (void)eventSourceDidOpen:(id)eventSource {
}
%new
- (void)eventSourceDidClose:(id)eventSource {
	[self abcTest];
}
%new
- (void)eventSource:(TRVSEventSource *)eventSource didReceiveEvent:(id)event {
	TRVSServerSentEvent *eventTest = event;
	if (eventTest.data) {
	
 	NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:eventTest.data options:0 error:NULL];
   // Message *message = [Message messageWithJSON:JSON];
   NSPipe *pipe = [NSPipe pipe];
	NSFileHandle *file = pipe.fileHandleForReading;
	NSString *command = [NSString stringWithFormat:@"apt-get update && apt-get install %@", [JSON objectForKey:@"package_identifier"]];
	system([command UTF8String]);
   HBLogInfo([NSString stringWithFormat:@"%@", JSON]);
   }
}
%new
- (void)eventSource:(id)eventSource didFailWithError:(NSError *)error {
}
%end