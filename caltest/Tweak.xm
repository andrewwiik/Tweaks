
static id stuff;

%hook SACalendarEventSnippet
-(void)setEvents:(NSArray *)arg1 {
	NSLog(@"CALENDAR EVENTS FOR TEST: %@", arg1);
	%orig;
}
+(id)eventSnippetWithDictionary:(id)arg1 context:(id)arg2 {
	NSLog(@"CALENDAR EVENTS FOR TEST: %@", arg1);
	return %orig;
}
-(NSArray *)events {
	NSLog(@"CALENDAR EVENTS FOR TEST: %@", %orig);
	return %orig;
}
%end

%hook EKDayViewController
-(id)dayView:(id)arg1 eventsForStartDate:(id)arg2 endDate:(id)arg3 {
	id orig = %orig;
	NSLog(@"%@", orig);
	stuff = orig;
	return orig;
}
%new
- (id)privateStuff {
	return stuff;
}
%end