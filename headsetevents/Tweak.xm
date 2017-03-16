@interface NSString (Creatix)
- (NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end;
@end

@implementation NSString (Creatix)
- (NSString*) stringBetweenString:(NSString*)start andString:(NSString*)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;   
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
           targetRange.length = endRange.location - targetRange.location;
           return [self substringWithRange:targetRange];
        }
    }
    return nil;
}
@end




%hook iAP2NowPlaying
- (id)_findCommandRefForCommand:(unsigned)command {
	NSLog(@"Command Type: %d", command);
	NSLog(@"Media Remote Commands: %@", %orig);
	return %orig;
}
- (id)findCommandRefForCommand:(unsigned int)command {
	NSLog(@"Command Type: %d", command);
	NSLog(@"Media Remote Commands: %@", %orig);
	return %orig;
}
%end

%hook SpringBoard
-(void)_handleHIDEvent:(id)arg1 {
	return;
}
-(void)handleKeyHIDEvent:(id)arg1 {
	return;
}
%end