@interface ICNotesListTableViewCell : UITableViewCell
- (UILabel *)snippetLabel;
- (UILabel *)titleLabel;
@end
%hook ICNotesListTableViewCell
- (void)setupLabels {
	%orig;
	if ([[self titleLabel].text isEqualToString:[NSString stringWithFormat:@"iOSBlocks To-Do List"]]) {
		[self snippetLabel].text = @"Locked";
		UIImage *lock = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/Application Support/Curago/Images/lock.png"]];
	UIImageView *lockView = [[UIImageView alloc] initWithFrame:CGRectMake(354,31.5,9,11.5)];
	[self addSubview:lockView];
	lockView.image = lock;
	lockView.image = [lockView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[lockView setTintColor:[UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1.0]];
	}
}
%end