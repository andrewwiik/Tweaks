%hook CNQuickActionsManager
/*- (void)_addAction:(id)arg1 {
	if ([arg1 isEqualToString:@"Test"]) {
	CNContactDeleteContactAction *deleteAction = [[%c(CNContactDeleteContactAction) alloc] initWithContact:[self contact]];
	CNQuickContactAction *deleteContactAction = [[%c(CNQuickContactAction) alloc] initWithContactAction:deleteAction];
	[deleteContactAction setTitle:@"Delete Contact"];
	%orig(deleteContactAction);
	}
	else %orig(arg1);
}*/
//%new
- (id)faceTimeAudioAction {
	CNContactDeleteContactAction *deleteAction = [[%c(CNContactDeleteContactAction) alloc] initWithContact:[self contact]];
	HBLogInfo([NSString stringWithFormat:@"%@", deleteAction]);
	CNQuickContactAction *deleteContactAction = [[%c(CNQuickContactAction) alloc] initWithContactAction:deleteAction];
	[deleteContactAction setTitle:@"Delete Contact"];
	[deleteContactAction setDelegate:self];
	HBLogInfo([NSString stringWithFormat:@"%@",deleteContactAction]);
	return deleteContactAction;
	[self _addAction:deleteContactAction];
	
}
%end