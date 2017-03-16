
%hook CKRecipientSearchListController
-(void)contactsSearchManager:(id)manager finishedSearchingWithResults:(NSArray *)results {
	int count = [results count];

	NSMutableArray *newResults = [results mutableCopy];

	for (int x = 0; x < count; x++) {
		NSObject *objectValue = [results objectAtIndex:x];
		if ([objectValue isKindOfClass:NSClassFromString(@"MFComposeRecipientGroup")]) {
			[newResults removeObject:objectValue];
			[newResults addObject:objectValue];
		}
	}

	%orig(manager,[newResults copy]);
	
}
%end